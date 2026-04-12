import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, In } from 'typeorm';
import { Vendor } from '../vendors/entities/vendor.entity';
import { VendorStaff } from '../vendors/entities/vendor-staff.entity';
import { VendorStatus } from '../vendors/enums/vendor-status.enum';
import { Driver } from '../drivers/entities/driver.entity';
import { EventRequest } from '../event-requests/entities/event-request.entity';
import { PrivateEventRequest } from '../private-events/entities/private-event-request.entity';
import { EventOffer } from '../private-events/entities/event-offer.entity';
import { User } from '../users/entities/user.entity';
import { DriverStatus } from '../drivers/enums/driver-status.enum';
import { Order } from '../orders/entities/order.entity';
import { OrderStatus } from '../orders/entities/order.entity';
import { Payment } from '../payments/entities/payment.entity';
import { PaymentStatus } from '../payments/entities/payment.entity';
import { AuditService } from './audit.service';
import { VendorsService } from '../vendors/vendors.service';

type ReqForAudit = { ip?: string; headers?: { 'user-agent'?: string } };

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(Vendor)
    private readonly vendorRepo: Repository<Vendor>,
    @InjectRepository(VendorStaff)
    private readonly vendorStaffRepo: Repository<VendorStaff>,
    @InjectRepository(Driver)
    private readonly driverRepo: Repository<Driver>,
    @InjectRepository(Order)
    private readonly orderRepo: Repository<Order>,
    @InjectRepository(Payment)
    private readonly paymentRepo: Repository<Payment>,
    @InjectRepository(EventRequest)
    private readonly eventRequestRepo: Repository<EventRequest>,
    @InjectRepository(PrivateEventRequest)
    private readonly privateEventRequestRepo: Repository<PrivateEventRequest>,
    @InjectRepository(EventOffer)
    private readonly eventOfferRepo: Repository<EventOffer>,
    private readonly auditService: AuditService,
    private readonly vendorsService: VendorsService,
  ) {}

  async getDashboard() {
    const todayStart = new Date();
    todayStart.setHours(0, 0, 0, 0);
    const todayEnd = new Date(todayStart);
    todayEnd.setDate(todayEnd.getDate() + 1);

    const [
      ordersToday,
      ordersPending,
      vendorsPendingCount,
      driversPendingCount,
      ordersLiveCount,
      paymentFailedCount,
    ] = await Promise.all([
      this.orderRepo.count({
        where: {
          createdAt: Between(todayStart, todayEnd),
        },
      }),
      this.orderRepo.count({
        where: { status: OrderStatus.PENDING },
      }),
      this.vendorRepo.count({
        where: {
          registrationStatus: In([
            VendorStatus.PENDING_APPROVAL,
            VendorStatus.UNDER_REVIEW,
          ]),
        },
      }),
      this.driverRepo.count({
        where: {
          status: DriverStatus.PENDING,
        },
      }),
      this.orderRepo.count({
        where: { status: OrderStatus.OUT_FOR_DELIVERY },
      }),
      this.paymentRepo.count({
        where: { status: PaymentStatus.FAILED },
      }),
    ]);

    const recentOrders = await this.orderRepo.find({
      take: 10,
      order: { createdAt: 'DESC' },
      relations: ['vendor'],
      select: ['id', 'orderNumber', 'status', 'total', 'createdAt', 'vendorId'],
    });

    return {
      ordersToday,
      ordersPending,
      vendorsPendingCount,
      driversPendingCount,
      ordersLiveCount,
      paymentIssuesCount: paymentFailedCount,
      recentOrders: recentOrders.map((o) => ({
        id: o.id,
        orderNumber: o.orderNumber,
        status: o.status,
        total: Number(o.total),
        createdAt: o.createdAt,
        vendorId: o.vendorId,
      })),
    };
  }

  async getVendorsList(options: {
    status?: VendorStatus;
    /** طابور التسجيل: بانتظار الموافقة + قيد المراجعة (لصفحة طلبات التسجيل) */
    registrationQueue?: boolean;
    category?: string;
    page?: number;
    limit?: number;
  }) {
    const page = Math.max(1, options.page ?? 1);
    const limit = Math.min(100, Math.max(1, options.limit ?? 20));
    const skip = (page - 1) * limit;

    const where: Record<string, unknown> = {};
    if (options.registrationQueue) {
      where.registrationStatus = In([
        VendorStatus.PENDING_APPROVAL,
        VendorStatus.UNDER_REVIEW,
      ]);
    } else if (options.status) {
      where.registrationStatus = options.status;
    }
    if (options.category?.trim())
      where.providerCategory = options.category.trim();

    const [items, total] = await this.vendorRepo.findAndCount({
      where,
      order: { createdAt: 'DESC' },
      skip,
      take: limit,
    });

    return {
      items: items.map((v) => ({
        id: v.id,
        name: v.name,
        email: v.email,
        phoneNumber: v.phoneNumber,
        city: v.city,
        registrationStatus: v.registrationStatus,
        isActive: v.isActive,
        providerCategory: v.providerCategory,
        createdAt: v.createdAt,
      })),
      total,
      page,
      limit,
    };
  }

  async getVendorById(id: string) {
    const vendor = await this.vendorRepo.findOne({
      where: { id },
      relations: ['certificates'],
    });
    if (!vendor) throw new NotFoundException('Vendor not found');
    const onboardingCompliance =
      await this.vendorsService.getVendorOnboardingSnapshotForAdmin(id);
    return { ...vendor, onboardingCompliance };
  }

  async getDriversList(options: {
    status?: DriverStatus;
    page?: number;
    limit?: number;
  }) {
    const page = Math.max(1, options.page ?? 1);
    const limit = Math.min(100, Math.max(1, options.limit ?? 20));
    const skip = (page - 1) * limit;

    const where: Partial<{ status: DriverStatus }> = {};
    if (options.status) where.status = options.status;

    const [items, total] = await this.driverRepo.findAndCount({
      where,
      relations: ['user'],
      order: { createdAt: 'DESC' },
      skip,
      take: limit,
    });

    return {
      items: items.map((d) => ({
        id: d.id,
        userId: d.userId,
        fullName: d.fullName,
        phoneNumber: d.phoneNumber,
        email: d.email,
        status: d.status,
        nationalId: d.nationalId,
        createdAt: d.createdAt,
        user: d.user
          ? { phone: d.user.phone ?? d.user.email ?? '', name: d.user.name }
          : null,
      })),
      total,
      page,
      limit,
    };
  }

  async getDriverById(id: string) {
    const driver = await this.driverRepo.findOne({
      where: { id },
      relations: ['user'],
    });
    if (!driver) throw new NotFoundException('Driver not found');
    return driver;
  }

  async getOrdersList(options: {
    status?: OrderStatus;
    dateFrom?: string;
    dateTo?: string;
    page?: number;
    limit?: number;
  }) {
    const page = Math.max(1, options.page ?? 1);
    const limit = Math.min(100, Math.max(1, options.limit ?? 20));
    const skip = (page - 1) * limit;

    const qb = this.orderRepo
      .createQueryBuilder('o')
      .leftJoin('o.vendor', 'v')
      .addSelect(['v.name'])
      .orderBy('o.createdAt', 'DESC')
      .skip(skip)
      .take(limit);

    if (options.status) {
      qb.andWhere('o.status = :status', { status: options.status });
    }
    if (options.dateFrom) {
      qb.andWhere('o.created_at >= :dateFrom', {
        dateFrom: new Date(options.dateFrom),
      });
    }
    if (options.dateTo) {
      const dateTo = new Date(options.dateTo);
      dateTo.setHours(23, 59, 59, 999);
      qb.andWhere('o.created_at <= :dateTo', { dateTo });
    }

    const [items, total] = await qb.getManyAndCount();
    return {
      items: items.map((o) => ({
        id: o.id,
        orderNumber: o.orderNumber,
        status: o.status,
        total: Number(o.total),
        vendorId: o.vendorId,
        createdAt: o.createdAt,
        vendor: (o as Order & { vendor?: { name: string } }).vendor
          ? { name: (o as Order & { vendor: { name: string } }).vendor.name }
          : null,
      })),
      total,
      page,
      limit,
    };
  }

  async getOrderById(id: string) {
    const order = await this.orderRepo.findOne({
      where: { id },
      relations: ['vendor', 'items', 'payments'],
    });
    if (!order) throw new NotFoundException('Order not found');
    return order;
  }

  async getPaymentsList(options: { page?: number; limit?: number }) {
    const page = Math.max(1, options.page ?? 1);
    const limit = Math.min(100, Math.max(1, options.limit ?? 20));
    const skip = (page - 1) * limit;

    const [items, total] = await this.paymentRepo.findAndCount({
      order: { createdAt: 'DESC' },
      skip,
      take: limit,
      relations: ['order'],
    });

    return {
      items: items.map((p) => ({
        id: p.id,
        orderId: p.orderId,
        method: p.method,
        status: p.status,
        amount: Number(p.amount),
        transactionId: p.transactionId,
        failureReason: p.failureReason,
        createdAt: p.createdAt,
      })),
      total,
      page,
      limit,
    };
  }

  /** Stub: لا يوجد جدول disputes حالياً — يرجع قائمة فارغة حتى يُضاف الكيان لاحقاً */
  async getDisputesList(options: { page?: number; limit?: number }) {
    const page = Math.max(1, options.page ?? 1);
    const limit = Math.min(100, Math.max(1, options.limit ?? 20));
    return { items: [], total: 0, page, limit };
  }

  async approveVendor(id: string, adminId: string, req?: ReqForAudit) {
    const vendor = await this.vendorRepo.findOne({ where: { id } });
    if (!vendor) throw new NotFoundException('Vendor not found');
    await this.vendorsService.assertVendorComplianceForAdminApproval(id);
    if (
      vendor.registrationStatus !== VendorStatus.PENDING_APPROVAL &&
      vendor.registrationStatus !== VendorStatus.UNDER_REVIEW
    ) {
      const msg =
        vendor.registrationStatus === VendorStatus.APPROVED
          ? 'المورد معتمد مسبقاً'
          : vendor.registrationStatus === VendorStatus.REJECTED
            ? 'المورد مرفوض مسبقاً'
            : vendor.registrationStatus === VendorStatus.SUSPENDED
              ? 'المورد موقوف مسبقاً'
              : `حالة المورد الحالية: ${vendor.registrationStatus}`;
      throw new BadRequestException(msg);
    }
    const addr = (vendor.address || '').trim();
    const city = (vendor.city || '').trim();
    const lat = Number(vendor.latitude);
    const lng = Number(vendor.longitude);
    const missingLocation =
      addr.length < 3 ||
      city.length < 2 ||
      addr === 'قيد الإكمال' ||
      city === 'غير محدد' ||
      Number.isNaN(lat) ||
      Number.isNaN(lng) ||
      (Math.abs(lat) < 1e-9 && Math.abs(lng) < 1e-9);
    if (missingLocation) {
      throw new BadRequestException(
        'لا يمكن اعتماد مقدم الخدمة: يجب إكمال عنوان الموقع والمدينة وإحداثيات صحيحة على الخريطة قبل الموافقة.',
      );
    }
    const oldStatus = vendor.registrationStatus;
    vendor.registrationStatus = VendorStatus.APPROVED;
    vendor.approvedAt = new Date();
    vendor.approvedBy = adminId;
    vendor.rejectionReason = null;
    vendor.isActive = true;
    vendor.isAcceptingOrders = true;
    await this.vendorRepo.save(vendor);
    await this.auditService.log({
      actorId: adminId,
      action: 'APPROVE_VENDOR',
      entityType: 'vendor',
      entityId: id,
      oldValue: { registrationStatus: oldStatus },
      newValue: { registrationStatus: VendorStatus.APPROVED },
      req,
    });
    return {
      success: true,
      vendor: { id: vendor.id, registrationStatus: vendor.registrationStatus },
    };
  }

  async rejectVendor(
    id: string,
    reason: string,
    adminId: string,
    req?: ReqForAudit,
  ) {
    const vendor = await this.vendorRepo.findOne({ where: { id } });
    if (!vendor) throw new NotFoundException('Vendor not found');
    const oldStatus = vendor.registrationStatus;
    vendor.registrationStatus = VendorStatus.REJECTED;
    vendor.rejectionReason = reason ?? null;
    vendor.approvedAt = null;
    vendor.approvedBy = null;
    await this.vendorRepo.save(vendor);
    await this.auditService.log({
      actorId: adminId,
      action: 'REJECT_VENDOR',
      entityType: 'vendor',
      entityId: id,
      oldValue: { registrationStatus: oldStatus },
      newValue: { registrationStatus: VendorStatus.REJECTED },
      reason: reason ?? undefined,
      req,
    });
    return {
      success: true,
      vendor: { id: vendor.id, registrationStatus: vendor.registrationStatus },
    };
  }

  async resendVendorRegistrationEmail(
    id: string,
    adminId: string,
    req?: ReqForAudit,
  ) {
    const { emailSent } =
      await this.vendorsService.resendPendingVendorRegistrationEmail(id);
    await this.auditService.log({
      actorId: adminId,
      action: 'RESEND_VENDOR_REGISTRATION_EMAIL',
      entityType: 'vendor',
      entityId: id,
      newValue: { emailSent },
      req,
    });
    return {
      success: true,
      emailSent,
      message: emailSent
        ? 'تم إرسال نسخة من رسالة التسجيل إلى بريد مقدّم الخدمة.'
        : 'تعذّر إرسال البريد. تحقق من إعدادات الخادم (RESEND_API_KEY / RESEND_FROM).',
    };
  }

  async suspendVendor(id: string, adminId: string, req?: ReqForAudit) {
    const vendor = await this.vendorRepo.findOne({ where: { id } });
    if (!vendor) throw new NotFoundException('Vendor not found');
    const oldStatus = vendor.registrationStatus;
    vendor.registrationStatus = VendorStatus.SUSPENDED;
    vendor.isAcceptingOrders = false;
    vendor.isActive = false;
    await this.vendorRepo.save(vendor);
    await this.auditService.log({
      actorId: adminId,
      action: 'SUSPEND_VENDOR',
      entityType: 'vendor',
      entityId: id,
      oldValue: { registrationStatus: oldStatus },
      newValue: { registrationStatus: VendorStatus.SUSPENDED },
      req,
    });
    return {
      success: true,
      vendor: { id: vendor.id, registrationStatus: vendor.registrationStatus },
    };
  }

  async reactivateVendor(id: string, adminId: string, req?: ReqForAudit) {
    const vendor = await this.vendorRepo.findOne({ where: { id } });
    if (!vendor) throw new NotFoundException('Vendor not found');
    if (vendor.registrationStatus !== VendorStatus.SUSPENDED) {
      throw new BadRequestException(
        vendor.registrationStatus === VendorStatus.APPROVED
          ? 'المقدّم معتمد بالفعل'
          : `لا يمكن إعادة التفعيل من الحالة الحالية: ${vendor.registrationStatus}`,
      );
    }
    const oldStatus = vendor.registrationStatus;
    vendor.registrationStatus = VendorStatus.APPROVED;
    vendor.isActive = true;
    vendor.isAcceptingOrders = true;
    await this.vendorRepo.save(vendor);
    await this.auditService.log({
      actorId: adminId,
      action: 'REACTIVATE_VENDOR',
      entityType: 'vendor',
      entityId: id,
      oldValue: { registrationStatus: oldStatus },
      newValue: { registrationStatus: VendorStatus.APPROVED },
      req,
    });
    return {
      success: true,
      vendor: { id: vendor.id, registrationStatus: vendor.registrationStatus },
    };
  }

  /**
   * حذف مقدّم الخدمة وحسابات مستخدمي فريقه لتحرير البريد وإعادة التسجيل.
   * غير مسموح للمعتمدين النشطين — يجب الإيقاف أولاً. يتطلب عدم وجود طلبات أو ارتباطات تمنع الحذف.
   */
  async removeVendorForReregistration(
    id: string,
    adminId: string,
    req?: ReqForAudit,
  ) {
    const vendor = await this.vendorRepo.findOne({ where: { id } });
    if (!vendor) throw new NotFoundException('Vendor not found');

    if (vendor.registrationStatus === VendorStatus.APPROVED) {
      throw new BadRequestException(
        'لا يمكن حذف مقدّم معتمد من هذه الشاشة. أوقف الحساب أولاً ثم أعد المحاولة.',
      );
    }

    const orderCount = await this.orderRepo.count({ where: { vendorId: id } });
    if (orderCount > 0) {
      throw new BadRequestException(
        'لا يمكن الحذف: يوجد طلبات مرتبطة بهذا المقدّم.',
      );
    }

    const [evReqV, pevReqV, offersV] = await Promise.all([
      this.eventRequestRepo.count({ where: { vendorId: id } }),
      this.privateEventRequestRepo.count({ where: { vendorId: id } }),
      this.eventOfferRepo.count({ where: { vendorId: id } }),
    ]);
    if (evReqV + pevReqV + offersV > 0) {
      throw new BadRequestException(
        'لا يمكن الحذف: يوجد طلبات أو عروض مناسبات مرتبطة بهذا المقدّم.',
      );
    }

    const staff = await this.vendorStaffRepo.find({ where: { vendorId: id } });
    const userIds = [...new Set(staff.map((s) => s.userId))];

    for (const userId of userIds) {
      const driver = await this.driverRepo.findOne({ where: { userId } });
      if (driver) {
        throw new BadRequestException(
          'لا يمكن الحذف: أحد الحسابات مرتبط كسائق.',
        );
      }
      const custOrders = await this.orderRepo.count({ where: { userId } });
      if (custOrders > 0) {
        throw new BadRequestException(
          'لا يمكن الحذف: أحد الحسابات له طلبات كعميل.',
        );
      }
      const evU = await this.eventRequestRepo.count({ where: { userId } });
      const pevU = await this.privateEventRequestRepo.count({
        where: { userId },
      });
      if (evU + pevU > 0) {
        throw new BadRequestException(
          'لا يمكن الحذف: أحد الحسابات له طلبات مناسبات كعميل.',
        );
      }
    }

    const snapshot = {
      email: vendor.email,
      name: vendor.name,
      registrationStatus: vendor.registrationStatus,
    };

    await this.vendorRepo.manager.transaction(async (em) => {
      await em.delete(EventOffer, { vendorId: id });
      await em.delete(EventRequest, { vendorId: id });
      await em.delete(PrivateEventRequest, { vendorId: id });
      await em.delete(Vendor, { id });
      for (const userId of userIds) {
        await em.delete(User, { id: userId });
      }
    });

    await this.auditService.log({
      actorId: adminId,
      action: 'REMOVE_VENDOR_REREGISTRATION',
      entityType: 'vendor',
      entityId: id,
      oldValue: snapshot,
      newValue: { removed: true },
      req,
    });

    return { success: true };
  }

  async approveDriver(id: string, adminId: string, req?: ReqForAudit) {
    const driver = await this.driverRepo.findOne({ where: { id } });
    if (!driver) throw new NotFoundException('Driver not found');
    if (
      driver.status !== DriverStatus.PENDING &&
      driver.status !== DriverStatus.UNDER_REVIEW
    ) {
      throw new BadRequestException(
        `Cannot approve driver. Current status: ${driver.status}`,
      );
    }
    const oldStatus = driver.status;
    driver.status = DriverStatus.APPROVED;
    driver.rejectionReason = null;
    await this.driverRepo.save(driver);
    await this.auditService.log({
      actorId: adminId,
      action: 'APPROVE_DRIVER',
      entityType: 'driver',
      entityId: id,
      oldValue: { status: oldStatus },
      newValue: { status: DriverStatus.APPROVED },
      req,
    });
    return { success: true, driver: { id: driver.id, status: driver.status } };
  }

  async rejectDriver(
    id: string,
    reason: string,
    adminId: string,
    req?: ReqForAudit,
  ) {
    const driver = await this.driverRepo.findOne({ where: { id } });
    if (!driver) throw new NotFoundException('Driver not found');
    const oldStatus = driver.status;
    driver.status = DriverStatus.REJECTED;
    driver.rejectionReason = reason ?? null;
    await this.driverRepo.save(driver);
    await this.auditService.log({
      actorId: adminId,
      action: 'REJECT_DRIVER',
      entityType: 'driver',
      entityId: id,
      oldValue: { status: oldStatus },
      newValue: { status: DriverStatus.REJECTED },
      reason: reason ?? undefined,
      req,
    });
    return { success: true, driver: { id: driver.id, status: driver.status } };
  }

  async suspendDriver(id: string, adminId: string, req?: ReqForAudit) {
    const driver = await this.driverRepo.findOne({ where: { id } });
    if (!driver) throw new NotFoundException('Driver not found');
    const oldStatus = driver.status;
    driver.status = DriverStatus.SUSPENDED;
    await this.driverRepo.save(driver);
    await this.auditService.log({
      actorId: adminId,
      action: 'SUSPEND_DRIVER',
      entityType: 'driver',
      entityId: id,
      oldValue: { status: oldStatus },
      newValue: { status: DriverStatus.SUSPENDED },
      req,
    });
    return { success: true, driver: { id: driver.id, status: driver.status } };
  }

  async forceOrderStatus(
    id: string,
    status: OrderStatus,
    adminId: string,
    req?: ReqForAudit,
  ) {
    const order = await this.orderRepo.findOne({ where: { id } });
    if (!order) throw new NotFoundException('Order not found');
    const oldStatus = order.status;
    order.status = status;
    if (status === OrderStatus.DELIVERED) {
      order.deliveredAt = new Date();
    }
    await this.orderRepo.save(order);
    await this.auditService.log({
      actorId: adminId,
      action: 'FORCE_ORDER_STATUS',
      entityType: 'order',
      entityId: id,
      oldValue: { status: oldStatus },
      newValue: { status },
      req,
    });
    return { success: true, order: { id: order.id, status: order.status } };
  }

  async getRiskFlags(): Promise<{
    flags: Array<{
      id: string;
      type: string;
      title: string;
      description: string;
      severity: string;
      entityType: string;
      entityId: string | null;
    }>;
  }> {
    const [failedPaymentsCount, pendingVendorsCount, pendingDriversCount] =
      await Promise.all([
        this.paymentRepo.count({ where: { status: PaymentStatus.FAILED } }),
        this.vendorRepo.count({
          where: {
            registrationStatus: In([
              VendorStatus.PENDING_APPROVAL,
              VendorStatus.UNDER_REVIEW,
            ]),
          },
        }),
        this.driverRepo.count({ where: { status: DriverStatus.PENDING } }),
      ]);
    const flags: Array<{
      id: string;
      type: string;
      title: string;
      description: string;
      severity: string;
      entityType: string;
      entityId: string | null;
    }> = [];
    if (failedPaymentsCount > 0) {
      flags.push({
        id: 'payment-failed-count',
        type: 'payment_issues',
        title: 'مدفوعات فاشلة',
        description: `عدد المعاملات الفاشلة: ${failedPaymentsCount}`,
        severity: 'high',
        entityType: 'payment',
        entityId: null,
      });
    }
    if (pendingVendorsCount > 5) {
      flags.push({
        id: 'vendors-pending-backlog',
        type: 'pending_backlog',
        title: 'تراكم طلبات تسجيل مقدّمي الخدمة',
        description: `${pendingVendorsCount} مقدّم خدمة بانتظار الموافقة`,
        severity: 'medium',
        entityType: 'vendor',
        entityId: null,
      });
    }
    if (pendingDriversCount > 5) {
      flags.push({
        id: 'drivers-pending-backlog',
        type: 'pending_backlog',
        title: 'تراكم طلبات السائقين',
        description: `${pendingDriversCount} سائق بانتظار الموافقة`,
        severity: 'medium',
        entityType: 'driver',
        entityId: null,
      });
    }
    return { flags };
  }
}
