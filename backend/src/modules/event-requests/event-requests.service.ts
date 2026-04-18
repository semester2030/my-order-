import { randomBytes } from 'crypto';
import {
  Injectable,
  BadRequestException,
  ConflictException,
  NotFoundException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Not, QueryFailedError, Repository } from 'typeorm';
import {
  EventRequest,
  EventRequestType,
  EventRequestStatus,
  ChefMealSlot,
  CHEF_BOOKING_TYPES,
  isChefBookingType,
  scheduledTimeForChefMealSlot,
  scheduledTimeForHomeCookingPresetSlot,
} from './entities/event-request.entity';
import { CreateEventRequestDto } from './dto/create-event-request.dto';
import { QuoteHomeCookingDto } from './dto/quote-home-cooking.dto';
import { DeclareHomeCookingPaymentDto } from './dto/declare-home-cooking-payment.dto';
import { HandoverHomeCookingDto } from './dto/handover-home-cooking.dto';
import { PaymentsService } from '../payments/payments.service';

const PG_UNIQUE_VIOLATION = '23505';

function isPostgresUniqueViolation(err: unknown): boolean {
  return (
    err instanceof QueryFailedError &&
    (err as QueryFailedError & { driverError?: { code?: string } })
      .driverError?.code === PG_UNIQUE_VIOLATION
  );
}

@Injectable()
export class EventRequestsService {
  constructor(
    @InjectRepository(EventRequest)
    private readonly eventRequestRepository: Repository<EventRequest>,
    private readonly configService: ConfigService,
    private readonly paymentsService: PaymentsService,
  ) {}

  private vendorResponseHours(): number {
    const raw = this.configService.get<string>(
      'EVENT_REQUEST_VENDOR_RESPONSE_HOURS',
      '48',
    );
    const n = Number.parseInt(String(raw), 10);
    if (!Number.isFinite(n) || n < 1 || n > 168) {
      return 48;
    }
    return n;
  }

  /** إلغاء تلقائي لطلبات ذبائح/شواء المعلّقة بعد انتهاء respond_by */
  async expireStaleChefBookingRequests(): Promise<number> {
    const r = await this.eventRequestRepository
      .createQueryBuilder()
      .update(EventRequest)
      .set({ status: EventRequestStatus.CANCELLED })
      .where('status = :pending', { pending: EventRequestStatus.PENDING })
      .andWhere('request_type IN (:...types)', { types: CHEF_BOOKING_TYPES })
      .andWhere('respond_by IS NOT NULL')
      .andWhere('respond_by < :now', { now: new Date() })
      .execute();
    return r.affected ?? 0;
  }

  private normalizeHomeCookingTime(raw: string): string {
    const t = raw.trim();
    if (/^\d{2}:\d{2}$/.test(t)) {
      return `${t}:00`;
    }
    if (/^\d{2}:\d{2}:\d{2}$/.test(t)) {
      return t;
    }
    throw new BadRequestException('صيغة وقت غير صالحة');
  }

  async create(
    userId: string,
    dto: CreateEventRequestDto,
  ): Promise<EventRequest> {
    const needsServiceLocation =
      dto.requestType === EventRequestType.POPULAR_COOKING ||
      dto.requestType === EventRequestType.GRILLING;

    if (needsServiceLocation) {
      if (!dto.addressId?.trim()) {
        throw new BadRequestException(
          'عنوان موقع تنفيذ الخدمة مطلوب (طبخ ذبائح أو شواء خارجي)',
        );
      }
    } else {
      const hasDishes = (dto.dishIds?.length ?? 0) > 0;
      const hasCustomDishes = !!dto.customDishNames?.trim();
      if (!hasDishes && !hasCustomDishes) {
        throw new BadRequestException('اكتب ما تريد أو اختر من القائمة');
      }
    }

    let scheduledTime: string;
    let mealSlot: ChefMealSlot | null = null;

    if (isChefBookingType(dto.requestType)) {
      if (dto.mealSlot == null) {
        throw new BadRequestException('يجب اختيار الوجبة: غداء أو عشاء');
      }
      if (dto.mealSlot === ChefMealSlot.BREAKFAST) {
        throw new BadRequestException(
          'وجبة الإفطار متاحة للطبخ المنزلي فقط — اختر غداء أو عشاء',
        );
      }
      mealSlot = dto.mealSlot;
      scheduledTime = scheduledTimeForChefMealSlot(mealSlot);
    } else if (dto.requestType === EventRequestType.HOME_COOKING) {
      if (dto.mealSlot != null) {
        mealSlot = dto.mealSlot;
        scheduledTime = scheduledTimeForHomeCookingPresetSlot(dto.mealSlot);
      } else {
        if (!dto.scheduledTime?.trim()) {
          throw new BadRequestException(
            'اختر وجبة (فطور أو غداء أو عشاء) أو حدّد وقتاً مخصصاً للحجز',
          );
        }
        mealSlot = null;
        scheduledTime = this.normalizeHomeCookingTime(dto.scheduledTime);
      }
    } else {
      throw new BadRequestException('نوع الطلب غير مدعوم');
    }

    const hours = this.vendorResponseHours();
    const respondBy =
      dto.requestType === EventRequestType.POPULAR_COOKING ||
      dto.requestType === EventRequestType.GRILLING
        ? new Date(Date.now() + hours * 60 * 60 * 1000)
        : null;

    const entity = this.eventRequestRepository.create({
      userId,
      vendorId: dto.vendorId,
      addressId: needsServiceLocation ? dto.addressId : null,
      requestType: dto.requestType,
      scheduledDate: dto.scheduledDate,
      scheduledTime,
      mealSlot,
      guestsCount: dto.guestsCount ?? 1,
      addOns: dto.addOns?.length ? dto.addOns : null,
      dishIds: dto.dishIds?.length ? dto.dishIds : null,
      customDishNames: dto.customDishNames?.trim() || null,
      delivery:
        dto.requestType === EventRequestType.HOME_COOKING
          ? (dto.delivery ?? false)
          : null,
      notes: dto.notes?.trim() || null,
      status: EventRequestStatus.PENDING,
      respondBy,
    });

    try {
      return await this.eventRequestRepository.save(entity);
    } catch (e) {
      if (isPostgresUniqueViolation(e)) {
        throw new ConflictException(
          'لا يمكن إنشاء الطلب: الوجبة والتاريخ محجوزان بالفعل لك أو لهذا الطبّاخ',
        );
      }
      throw e;
    }
  }

  async findByUser(userId: string): Promise<EventRequest[]> {
    await this.expireStaleChefBookingRequests();
    return this.eventRequestRepository.find({
      where: { userId },
      relations: ['vendor', 'address'],
      order: { createdAt: 'DESC' },
    });
  }

  async findOneByUser(userId: string, id: string): Promise<EventRequest> {
    await this.expireStaleChefBookingRequests();
    const row = await this.eventRequestRepository.findOne({
      where: { id, userId },
      relations: ['vendor', 'address'],
    });
    if (!row) {
      throw new NotFoundException('الطلب غير موجود');
    }
    return row;
  }

  /** طلبات الطبخ المنزلي الواردة للمطبخ */
  async findHomeCookingRequestsForVendor(vendorId: string): Promise<EventRequest[]> {
    await this.expireStaleChefBookingRequests();
    return this.eventRequestRepository.find({
      where: { vendorId, requestType: EventRequestType.HOME_COOKING },
      relations: ['user', 'address', 'vendor'],
      order: { createdAt: 'DESC' },
    });
  }

  private async loadHomeCookingForVendorOrThrow(
    vendorId: string,
    requestId: string,
  ): Promise<EventRequest> {
    await this.expireStaleChefBookingRequests();
    const row = await this.eventRequestRepository.findOne({
      where: { id: requestId, vendorId },
      relations: ['user', 'address', 'vendor'],
    });
    if (!row) {
      throw new NotFoundException('الطلب غير موجود');
    }
    if (row.requestType !== EventRequestType.HOME_COOKING) {
      throw new BadRequestException('طلبات الطبخ المنزلي فقط');
    }
    return row;
  }

  async quoteHomeCookingByVendor(
    vendorId: string,
    requestId: string,
    dto: QuoteHomeCookingDto,
  ): Promise<EventRequest> {
    await this.loadHomeCookingForVendorOrThrow(vendorId, requestId);
    const amt = Number(dto.quotedAmount);
    if (!Number.isFinite(amt) || amt < 0.01) {
      throw new BadRequestException('المبلغ غير صالح');
    }
    const res = await this.eventRequestRepository.update(
      {
        id: requestId,
        vendorId,
        requestType: EventRequestType.HOME_COOKING,
        status: EventRequestStatus.PENDING,
      },
      {
        status: EventRequestStatus.QUOTED,
        quotedAmount: amt.toFixed(2),
        quoteNotes: dto.quoteNotes?.trim() || null,
        quotedAt: new Date(),
      },
    );
    if (!res.affected) {
      throw new ConflictException(
        'لا يمكن عرض السعر: الطلب ليس قيد الانتظار أو ليس طبخاً منزلياً',
      );
    }
    return this.reloadEventRequestOrThrow(requestId);
  }

  async rejectHomeCookingByVendor(
    vendorId: string,
    requestId: string,
  ): Promise<EventRequest> {
    const row = await this.loadHomeCookingForVendorOrThrow(vendorId, requestId);
    const cancellable = new Set<EventRequestStatus>([
      EventRequestStatus.PENDING,
      EventRequestStatus.QUOTED,
      EventRequestStatus.PAYMENT_PENDING,
    ]);
    if (!cancellable.has(row.status)) {
      throw new ConflictException('لا يمكن الرفض في هذه الحالة');
    }
    row.status = EventRequestStatus.REJECTED;
    return this.eventRequestRepository.save(row);
  }

  async markHomeCookingReadyByVendor(
    vendorId: string,
    requestId: string,
  ): Promise<EventRequest> {
    const row = await this.loadHomeCookingForVendorOrThrow(vendorId, requestId);
    if (row.status !== EventRequestStatus.ACCEPTED) {
      throw new ConflictException(
        'يمكن تمييز «جاهز» بعد قبول الطلب وتأكيد الدفع فقط',
      );
    }
    row.status = EventRequestStatus.READY;
    row.readyAt = new Date();
    return this.eventRequestRepository.save(row);
  }

  /**
   * تأكيد تسليم الطلب من المطبخ — سواء استلمه العميل شخصياً أو مندوب/وسيط.
   * ينتقل إلى handed_over حتى يؤكد العميل الاستلام ويُصدر رمز الإتمام.
   */
  async markHomeCookingHandedOverByVendor(
    vendorId: string,
    requestId: string,
    dto?: HandoverHomeCookingDto,
  ): Promise<EventRequest> {
    const row = await this.loadHomeCookingForVendorOrThrow(vendorId, requestId);
    if (row.status !== EventRequestStatus.READY) {
      throw new ConflictException(
        'يمكن تأكيد التسليم بعد تمييز الطلب كجاهز فقط',
      );
    }
    row.status = EventRequestStatus.HANDED_OVER;
    row.handedOverAt = new Date();
    row.handoverNotes = dto?.handoverNotes?.trim() || null;
    return this.eventRequestRepository.save(row);
  }

  private generateCompletionCertificateCode(): string {
    const d = new Date();
    const y = String(d.getFullYear()).slice(-2);
    const m = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    const rand = randomBytes(5).toString('hex').toUpperCase();
    return `HC-${y}${m}${day}-${rand}`;
  }

  /** تأكيد استلام العميل — إغلاق الطلب برمز إتمام فريد (للإدارة والعميل). */
  async confirmHomeCookingReceiptByCustomer(
    userId: string,
    requestId: string,
  ): Promise<EventRequest> {
    const row = await this.eventRequestRepository.findOne({
      where: { id: requestId, userId },
      relations: ['vendor', 'address'],
    });
    if (!row) {
      throw new NotFoundException('الطلب غير موجود');
    }
    if (row.requestType !== EventRequestType.HOME_COOKING) {
      throw new BadRequestException('هذا الإجراء للطبخ المنزلي فقط');
    }
    if (row.status !== EventRequestStatus.HANDED_OVER) {
      throw new ConflictException(
        'يمكن تأكيد الاستلام بعد أن يؤكد المطبخ التسليم فقط',
      );
    }
    for (let attempt = 0; attempt < 20; attempt++) {
      row.completionCertificateCode = this.generateCompletionCertificateCode();
      row.status = EventRequestStatus.COMPLETED;
      row.completedAt = new Date();
      try {
        return await this.eventRequestRepository.save(row);
      } catch (e) {
        if (!isPostgresUniqueViolation(e)) {
          throw e;
        }
        row.status = EventRequestStatus.HANDED_OVER;
        row.completedAt = null;
        row.completionCertificateCode = null;
      }
    }
    throw new ConflictException(
      'تعذّر إنشاء رمز إتمام فريد، يرجى المحاولة لاحقاً',
    );
  }

  async findHomeCookingCompletedForAdmin(opts: {
    page?: number;
    limit?: number;
  }): Promise<{ items: EventRequest[]; total: number }> {
    const page = Math.max(1, opts.page ?? 1);
    const limit = Math.min(100, Math.max(1, opts.limit ?? 20));
    const [items, total] = await this.eventRequestRepository.findAndCount({
      where: {
        requestType: EventRequestType.HOME_COOKING,
        status: EventRequestStatus.COMPLETED,
      },
      relations: ['user', 'vendor', 'address'],
      order: { completedAt: 'DESC' },
      take: limit,
      skip: (page - 1) * limit,
    });
    return { items, total };
  }

  async declareHomeCookingPaymentByCustomer(
    userId: string,
    requestId: string,
    dto: DeclareHomeCookingPaymentDto,
  ): Promise<EventRequest> {
    const row = await this.eventRequestRepository.findOne({
      where: { id: requestId, userId },
      relations: ['vendor', 'address'],
    });
    if (!row) {
      throw new NotFoundException('الطلب غير موجود');
    }
    if (row.requestType !== EventRequestType.HOME_COOKING) {
      throw new BadRequestException('هذا الإجراء للطبخ المنزلي فقط');
    }
    if (row.status !== EventRequestStatus.QUOTED) {
      throw new ConflictException(
        'يمكن إعلان التحويل بعد استلام عرض السعر فقط',
      );
    }
    if (row.quotedAmount == null) {
      throw new ConflictException('لا يوجد سعر معروض');
    }
    await this.paymentsService.assertNoBlockingHomeCookingCardPayment(row.id);
    const ref = dto.paymentReference.trim();
    if (ref.length < 3) {
      throw new BadRequestException('أدخل مرجع التحويل (3 أحرف على الأقل)');
    }
    row.status = EventRequestStatus.PAYMENT_PENDING;
    row.paymentReference = ref;
    row.paymentDeclaredAt = new Date();
    const extra = dto.notes?.trim();
    if (extra) {
      row.notes = row.notes
        ? `${row.notes}\n[إعلان دفع]: ${extra}`
        : `[إعلان دفع]: ${extra}`;
    }
    return this.eventRequestRepository.save(row);
  }

  async findHomeCookingPaymentPendingForAdmin(opts: {
    page?: number;
    limit?: number;
  }): Promise<{ items: EventRequest[]; total: number }> {
    const page = Math.max(1, opts.page ?? 1);
    const limit = Math.min(100, Math.max(1, opts.limit ?? 20));
    const [items, total] = await this.eventRequestRepository.findAndCount({
      where: {
        requestType: EventRequestType.HOME_COOKING,
        status: EventRequestStatus.PAYMENT_PENDING,
      },
      relations: ['user', 'vendor', 'address'],
      order: { createdAt: 'DESC' },
      take: limit,
      skip: (page - 1) * limit,
    });
    return { items, total };
  }

  async verifyHomeCookingPaymentByAdmin(
    requestId: string,
    adminId: string,
  ): Promise<EventRequest> {
    const row = await this.eventRequestRepository.findOne({
      where: { id: requestId, requestType: EventRequestType.HOME_COOKING },
      relations: ['user', 'vendor', 'address'],
    });
    if (!row) {
      throw new NotFoundException('الطلب غير موجود');
    }
    if (row.status !== EventRequestStatus.PAYMENT_PENDING) {
      throw new ConflictException('الطلب ليس بانتظار تحقق الدفع');
    }
    row.status = EventRequestStatus.ACCEPTED;
    row.paymentVerifiedAt = new Date();
    row.paymentVerifiedByAdminId = adminId;
    return this.eventRequestRepository.save(row);
  }

  private async reloadEventRequestOrThrow(id: string): Promise<EventRequest> {
    const row = await this.eventRequestRepository.findOne({
      where: { id },
      relations: ['user', 'address', 'vendor'],
    });
    if (!row) throw new NotFoundException();
    return row;
  }

  /** قائمة حجوزات الذبائح/الشواء الواردة للطبّاخ */
  async findChefBookingsForVendor(vendorId: string): Promise<EventRequest[]> {
    await this.expireStaleChefBookingRequests();
    return this.eventRequestRepository.find({
      where: {
        vendorId,
        requestType: In(CHEF_BOOKING_TYPES),
      },
      relations: ['user', 'address', 'vendor'],
      order: { createdAt: 'DESC' },
    });
  }

  private async loadChefBookingOrThrow(
    vendorId: string,
    requestId: string,
  ): Promise<EventRequest> {
    await this.expireStaleChefBookingRequests();
    const row = await this.eventRequestRepository.findOne({
      where: { id: requestId, vendorId },
      relations: ['user', 'address', 'vendor'],
    });
    if (!row) {
      throw new NotFoundException('الطلب غير موجود');
    }
    if (!CHEF_BOOKING_TYPES.includes(row.requestType)) {
      throw new BadRequestException(
        'هذا المسار مخصص لطلبات طبخ الذبائح والشواء فقط',
      );
    }
    return row;
  }

  async acceptChefBookingByVendor(
    vendorId: string,
    requestId: string,
  ): Promise<EventRequest> {
    const row = await this.loadChefBookingOrThrow(vendorId, requestId);
    if (!row.mealSlot) {
      throw new ConflictException(
        'لا يمكن القبول: الطلب بدون وجبة محددة — يُرجى تحديث البيانات',
      );
    }
    const otherAccepted = await this.eventRequestRepository.exists({
      where: {
        vendorId,
        scheduledDate: row.scheduledDate,
        mealSlot: row.mealSlot,
        status: EventRequestStatus.ACCEPTED,
        requestType: In(CHEF_BOOKING_TYPES),
        id: Not(requestId),
      },
    });
    if (otherAccepted) {
      throw new ConflictException('هذه الوجبة محجوزة بالفعل لدى الطبّاخ');
    }
    try {
      const res = await this.eventRequestRepository.update(
        {
          id: requestId,
          vendorId,
          status: EventRequestStatus.PENDING,
          requestType: In(CHEF_BOOKING_TYPES),
        },
        { status: EventRequestStatus.ACCEPTED },
      );
      if (!res.affected) {
        throw new ConflictException(
          'لا يمكن القبول: الطلب ليس قيد الانتظار أو انتهت مهلته',
        );
      }
    } catch (e) {
      if (isPostgresUniqueViolation(e)) {
        throw new ConflictException(
          'لا يمكن القبول: توجد حجوزة أخرى لنفس الوجبة والتاريخ',
        );
      }
      throw e;
    }
    const updated = await this.eventRequestRepository.findOne({
      where: { id: requestId },
      relations: ['user', 'address', 'vendor'],
    });
    if (!updated) throw new NotFoundException();
    return updated;
  }

  async rejectChefBookingByVendor(
    vendorId: string,
    requestId: string,
  ): Promise<EventRequest> {
    await this.loadChefBookingOrThrow(vendorId, requestId);
    const res = await this.eventRequestRepository.update(
      {
        id: requestId,
        vendorId,
        status: EventRequestStatus.PENDING,
        requestType: In(CHEF_BOOKING_TYPES),
      },
      { status: EventRequestStatus.REJECTED },
    );
    if (!res.affected) {
      throw new ConflictException(
        'لا يمكن الرفض: الطلب ليس قيد الانتظار أو انتهت مهلته',
      );
    }
    const updated = await this.eventRequestRepository.findOne({
      where: { id: requestId },
      relations: ['user', 'address', 'vendor'],
    });
    if (!updated) throw new NotFoundException();
    return updated;
  }

  /** إلغاء من العميل — الطبخ المنزلي: قبل التحضير؛ الذبائح/الشوي: pending فقط */
  async cancelByCustomer(userId: string, requestId: string): Promise<EventRequest> {
    await this.expireStaleChefBookingRequests();
    const row = await this.eventRequestRepository.findOne({
      where: { id: requestId, userId },
    });
    if (!row) {
      throw new NotFoundException('الطلب غير موجود');
    }
    const homeCancellable = new Set<EventRequestStatus>([
      EventRequestStatus.PENDING,
      EventRequestStatus.QUOTED,
      EventRequestStatus.PAYMENT_PENDING,
    ]);
    if (row.requestType === EventRequestType.HOME_COOKING) {
      if (!homeCancellable.has(row.status)) {
        throw new ConflictException(
          'يمكن إلغاء طلب الطبخ المنزلي قبل بدء التحضير فقط',
        );
      }
    } else if (isChefBookingType(row.requestType)) {
      if (row.status !== EventRequestStatus.PENDING) {
        throw new ConflictException('يمكن إلغاء الطلبات قيد الانتظار فقط');
      }
    } else if (row.status !== EventRequestStatus.PENDING) {
      throw new ConflictException('يمكن إلغاء الطلبات قيد الانتظار فقط');
    }
    row.status = EventRequestStatus.CANCELLED;
    return this.eventRequestRepository.save(row);
  }

  /**
   * تأكيد إتمام خدمة حجز الطبّاخ (ذبائح/شواء) من العميل — بعد قبول المقدّم.
   * يُمكّن التقييم والبلاغات بنفس مسار الطبخ المنزلي (حالة completed).
   */
  async confirmChefServiceCompletionByCustomer(
    userId: string,
    requestId: string,
  ): Promise<EventRequest> {
    await this.expireStaleChefBookingRequests();
    const row = await this.eventRequestRepository.findOne({
      where: { id: requestId, userId },
      relations: ['vendor', 'address'],
    });
    if (!row) {
      throw new NotFoundException('الطلب غير موجود');
    }
    if (!isChefBookingType(row.requestType)) {
      throw new BadRequestException(
        'هذا الإجراء لحجوزات طبخ الذبائح والشواء فقط',
      );
    }
    if (row.status === EventRequestStatus.COMPLETED) {
      return row;
    }
    if (row.status !== EventRequestStatus.ACCEPTED) {
      throw new ConflictException(
        'يمكن تأكيد إتمام الخدمة بعد قبول الطبّاخ فقط',
      );
    }
    row.status = EventRequestStatus.COMPLETED;
    row.completedAt = new Date();
    return this.eventRequestRepository.save(row);
  }
}
