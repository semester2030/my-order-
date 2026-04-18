import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { QueryFailedError, Repository } from 'typeorm';
import { ServiceReview } from './entities/service-review.entity';
import { ServiceQualityTicket } from './entities/service-quality-ticket.entity';
import {
  SERVICE_EXPERIENCE_REVIEW_WINDOW_DAYS,
  ServiceReviewSubjectType,
  QualityTicketStatus,
} from './service-experience.constants';
import { SubmitServiceReviewDto } from './dto/submit-service-review.dto';
import { SubmitQualityTicketDto } from './dto/submit-quality-ticket.dto';
import { AdminUpdateQualityTicketDto } from './dto/admin-update-quality-ticket.dto';
import {
  EventRequest,
  EventRequestStatus,
} from '../event-requests/entities/event-request.entity';
import { Order, OrderStatus } from '../orders/entities/order.entity';
import { Vendor } from '../vendors/entities/vendor.entity';

const PG_UNIQUE_VIOLATION = '23505';

function isPostgresUniqueViolation(err: unknown): boolean {
  return (
    err instanceof QueryFailedError &&
    (err as QueryFailedError & { driverError?: { code?: string } })
      .driverError?.code === PG_UNIQUE_VIOLATION
  );
}

function addDays(d: Date, days: number): Date {
  const x = new Date(d.getTime());
  x.setUTCDate(x.getUTCDate() + days);
  return x;
}

function withinReviewWindow(serviceCompletedAt: Date): void {
  const end = addDays(serviceCompletedAt, SERVICE_EXPERIENCE_REVIEW_WINDOW_DAYS);
  if (new Date() > end) {
    throw new BadRequestException(
      `انتهت فترة التقييم (${SERVICE_EXPERIENCE_REVIEW_WINDOW_DAYS} يوماً بعد إتمام الخدمة)`,
    );
  }
}

function sanitizeDetailScores(
  raw: Record<string, number> | undefined | null,
): Record<string, number> | null {
  if (!raw || typeof raw !== 'object') return null;
  const out: Record<string, number> = {};
  let n = 0;
  for (const [k, v] of Object.entries(raw)) {
    if (n >= 20) break;
    const key = k.trim().slice(0, 64);
    if (!key) continue;
    const num = Number(v);
    if (!Number.isFinite(num)) continue;
    const rounded = Math.round(num);
    if (rounded < 1 || rounded > 5) continue;
    out[key] = rounded;
    n++;
  }
  return Object.keys(out).length ? out : null;
}

@Injectable()
export class ServiceExperienceService {
  constructor(
    @InjectRepository(ServiceReview)
    private readonly reviewRepo: Repository<ServiceReview>,
    @InjectRepository(ServiceQualityTicket)
    private readonly ticketRepo: Repository<ServiceQualityTicket>,
    @InjectRepository(EventRequest)
    private readonly eventRequestRepo: Repository<EventRequest>,
    @InjectRepository(Order)
    private readonly orderRepo: Repository<Order>,
    @InjectRepository(Vendor)
    private readonly vendorRepo: Repository<Vendor>,
  ) {}

  private async resolveSubjectContext(
    customerUserId: string,
    subjectType: ServiceReviewSubjectType,
    subjectId: string,
  ): Promise<{ vendorId: string; serviceCompletedAt: Date }> {
    if (subjectType === ServiceReviewSubjectType.ORDER) {
      const order = await this.orderRepo.findOne({
        where: { id: subjectId, userId: customerUserId },
      });
      if (!order) {
        throw new NotFoundException('الطلب غير موجود');
      }
      if (order.status !== OrderStatus.DELIVERED) {
        throw new BadRequestException(
          'يمكن التقييم بعد تسليم الطلب فقط',
        );
      }
      const serviceCompletedAt = order.deliveredAt ?? order.updatedAt;
      withinReviewWindow(serviceCompletedAt);
      return { vendorId: order.vendorId, serviceCompletedAt };
    }

    if (subjectType === ServiceReviewSubjectType.EVENT_REQUEST) {
      const row = await this.eventRequestRepo.findOne({
        where: { id: subjectId, userId: customerUserId },
      });
      if (!row) {
        throw new NotFoundException('الطلب غير موجود');
      }
      if (row.status !== EventRequestStatus.COMPLETED) {
        throw new BadRequestException(
          'يمكن التقييم بعد إتمام الطلب فقط',
        );
      }
      if (!row.completedAt) {
        throw new BadRequestException('تاريخ الإتمام غير متاح');
      }
      withinReviewWindow(row.completedAt);
      return { vendorId: row.vendorId, serviceCompletedAt: row.completedAt };
    }

    throw new BadRequestException('نوع الخدمة غير مدعوم');
  }

  async submitReview(
    customerUserId: string,
    dto: SubmitServiceReviewDto,
  ): Promise<ServiceReview> {
    const { vendorId } = await this.resolveSubjectContext(
      customerUserId,
      dto.subjectType,
      dto.subjectId,
    );

    const comment =
      dto.publicComment?.trim().length ? dto.publicComment.trim() : null;

    const row = this.reviewRepo.create({
      subjectType: dto.subjectType,
      subjectId: dto.subjectId,
      customerUserId,
      vendorId,
      stars: dto.stars,
      publicComment: comment,
    });

    try {
      const saved = await this.reviewRepo.save(row);
      await this.recomputeVendorRating(vendorId);
      return saved;
    } catch (e) {
      if (isPostgresUniqueViolation(e)) {
        throw new ConflictException('تم إرسال تقييم لهذه الخدمة مسبقاً');
      }
      throw e;
    }
  }

  async submitQualityTicket(
    customerUserId: string,
    dto: SubmitQualityTicketDto,
  ): Promise<ServiceQualityTicket> {
    const { vendorId } = await this.resolveSubjectContext(
      customerUserId,
      dto.subjectType,
      dto.subjectId,
    );

    const ticket = this.ticketRepo.create({
      subjectType: dto.subjectType,
      subjectId: dto.subjectId,
      customerUserId,
      vendorId,
      category: dto.category,
      privateMessage: dto.privateMessage.trim(),
      detailScores: sanitizeDetailScores(dto.detailScores),
      status: QualityTicketStatus.OPEN,
    });
    return this.ticketRepo.save(ticket);
  }

  async listPublicVendorReviews(
    vendorId: string,
    page = 1,
    limit = 20,
  ): Promise<{
    items: Array<{
      id: string;
      stars: number;
      publicComment: string | null;
      createdAt: string;
      subjectType: string;
    }>;
    total: number;
    page: number;
    limit: number;
  }> {
    const exists = await this.vendorRepo.exists({ where: { id: vendorId } });
    if (!exists) {
      throw new NotFoundException('المقدّم غير موجود');
    }
    const p = Math.max(1, page);
    const lim = Math.min(50, Math.max(1, limit));
    const [rows, total] = await this.reviewRepo.findAndCount({
      where: { vendorId },
      order: { createdAt: 'DESC' },
      take: lim,
      skip: (p - 1) * lim,
      select: ['id', 'stars', 'publicComment', 'createdAt', 'subjectType'],
    });
    return {
      items: rows.map((r) => ({
        id: r.id,
        stars: r.stars,
        publicComment: r.publicComment,
        createdAt: r.createdAt.toISOString(),
        subjectType: r.subjectType,
      })),
      total,
      page: p,
      limit: lim,
    };
  }

  private async recomputeVendorRating(vendorId: string): Promise<void> {
    const raw = await this.reviewRepo
      .createQueryBuilder('r')
      .select('COALESCE(AVG(r.stars), 0)', 'avg')
      .addSelect('COUNT(r.id)', 'cnt')
      .where('r.vendorId = :vendorId', { vendorId })
      .getRawOne<{ avg: string; cnt: string }>();
    const cnt = parseInt(raw?.cnt ?? '0', 10);
    const avg = cnt === 0 ? 0 : Number.parseFloat(String(raw?.avg ?? '0'));
    const rating = Math.min(5, Math.round(avg * 100) / 100);
    await this.vendorRepo.update(vendorId, {
      rating,
      ratingCount: cnt,
    });
  }

  async listQualityTicketsForAdmin(opts: {
    status?: QualityTicketStatus;
    page?: number;
    limit?: number;
  }): Promise<{
    items: ServiceQualityTicket[];
    total: number;
    page: number;
    limit: number;
  }> {
    const page = Math.max(1, opts.page ?? 1);
    const limit = Math.min(100, Math.max(1, opts.limit ?? 20));
    const qb = this.ticketRepo
      .createQueryBuilder('t')
      .leftJoinAndSelect('t.customer', 'customer')
      .leftJoinAndSelect('t.vendor', 'vendor')
      .orderBy('t.createdAt', 'DESC');
    if (opts.status) {
      qb.andWhere('t.status = :st', { st: opts.status });
    }
    const total = await qb.getCount();
    const items = await qb
      .skip((page - 1) * limit)
      .take(limit)
      .getMany();
    return { items, total, page, limit };
  }

  async updateQualityTicketByAdmin(
    id: string,
    dto: AdminUpdateQualityTicketDto,
  ): Promise<ServiceQualityTicket> {
    const row = await this.ticketRepo.findOne({
      where: { id },
      relations: ['customer', 'vendor'],
    });
    if (!row) {
      throw new NotFoundException('التذكرة غير موجودة');
    }
    if (dto.status != null) {
      row.status = dto.status;
    }
    if (dto.adminNotes !== undefined) {
      row.adminNotes = dto.adminNotes?.trim() || null;
    }
    return this.ticketRepo.save(row);
  }
}
