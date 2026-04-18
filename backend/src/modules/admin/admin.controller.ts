import {
  Controller,
  Get,
  Post,
  Patch,
  Query,
  Param,
  Body,
  UseGuards,
  Request,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AdminService } from './admin.service';
import { AuditService } from './audit.service';
import { AdminJwtGuard } from './guards/admin-jwt.guard';
import { AdminTokenPayload } from './admin-auth.service';
import { VendorStatus } from '../vendors/enums/vendor-status.enum';
import { DriverStatus } from '../drivers/enums/driver-status.enum';
import { OrderStatus } from '../orders/entities/order.entity';
import { RejectReasonDto } from './dto/reject-reason.dto';
import { ForceOrderStatusDto } from './dto/force-order-status.dto';
import { EventRequestsService } from '../event-requests/event-requests.service';
import { ServiceExperienceService } from '../service-experience/service-experience.service';
import { AdminUpdateQualityTicketDto } from '../service-experience/dto/admin-update-quality-ticket.dto';
import { QualityTicketStatus } from '../service-experience/service-experience.constants';

@ApiTags('admin')
@Controller('admin')
@UseGuards(AdminJwtGuard)
@ApiBearerAuth('admin')
export class AdminController {
  constructor(
    private readonly adminService: AdminService,
    private readonly auditService: AuditService,
    private readonly eventRequestsService: EventRequestsService,
    private readonly serviceExperienceService: ServiceExperienceService,
  ) {}

  @Get('dashboard')
  @ApiOperation({ summary: 'Get admin dashboard' })
  async getDashboard() {
    return this.adminService.getDashboard();
  }

  @Get('audit-logs')
  @ApiOperation({ summary: 'Get audit logs (with actor name/email)' })
  async getAuditLogs(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('action') action?: string,
    @Query('entityType') entityType?: string,
    @Query('actorId') actorId?: string,
    @Query('dateFrom') dateFrom?: string,
    @Query('dateTo') dateTo?: string,
  ) {
    return this.auditService.findMany({
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
      action,
      entityType,
      actorId,
      dateFrom,
      dateTo,
    });
  }

  @Get('vendors')
  @ApiOperation({ summary: 'List vendors' })
  async getVendors(
    @Query('status') status?: VendorStatus,
    @Query('registrationQueue') registrationQueue?: string,
    @Query('category') category?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    const rq = registrationQueue?.toLowerCase();
    return this.adminService.getVendorsList({
      registrationQueue: rq === '1' || rq === 'true' || rq === 'yes',
      status,
      category,
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });
  }

  @Get('vendors/:id')
  @ApiOperation({ summary: 'Get vendor by id' })
  async getVendorById(@Param('id') id: string) {
    return this.adminService.getVendorById(id);
  }

  @Get('drivers')
  @ApiOperation({ summary: 'List drivers' })
  async getDrivers(
    @Query('status') status?: DriverStatus,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.adminService.getDriversList({
      status,
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });
  }

  @Get('drivers/:id')
  @ApiOperation({ summary: 'Get driver by id' })
  async getDriverById(@Param('id') id: string) {
    return this.adminService.getDriverById(id);
  }

  @Get('orders')
  @ApiOperation({ summary: 'List orders' })
  async getOrders(
    @Query('status') status?: OrderStatus,
    @Query('dateFrom') dateFrom?: string,
    @Query('dateTo') dateTo?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.adminService.getOrdersList({
      status,
      dateFrom,
      dateTo,
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });
  }

  @Get('orders/:id')
  @ApiOperation({ summary: 'Get order by id' })
  async getOrderById(@Param('id') id: string) {
    return this.adminService.getOrderById(id);
  }

  @Get('payments')
  @ApiOperation({ summary: 'List payments' })
  async getPayments(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.adminService.getPaymentsList({
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });
  }

  @Get('disputes')
  @ApiOperation({
    summary:
      'List disputes (stub — returns empty until disputes entity exists)',
  })
  async getDisputes(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.adminService.getDisputesList({
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });
  }

  @Post('vendors/:id/approve')
  @ApiOperation({ summary: 'Approve vendor' })
  async approveVendor(
    @Param('id') id: string,
    @Request() req: { user: AdminTokenPayload },
  ) {
    return this.adminService.approveVendor(id, req.user.sub, req as any);
  }

  @Post('vendors/:id/reject')
  @ApiOperation({ summary: 'Reject vendor' })
  async rejectVendor(
    @Param('id') id: string,
    @Body() dto: RejectReasonDto,
    @Request() req: { user: AdminTokenPayload },
  ) {
    return this.adminService.rejectVendor(
      id,
      dto.reason ?? '',
      req.user.sub,
      req as any,
    );
  }

  @Post('vendors/:id/resend-registration-email')
  @ApiOperation({
    summary:
      'إعادة إرسال بريد «تم استلام طلب التسجيل» (pending_approval / under_review)',
  })
  async resendVendorRegistrationEmail(
    @Param('id') id: string,
    @Request() req: { user: AdminTokenPayload },
  ) {
    return this.adminService.resendVendorRegistrationEmail(
      id,
      req.user.sub,
      req as any,
    );
  }

  @Post('vendors/:id/suspend')
  @ApiOperation({ summary: 'Suspend vendor' })
  async suspendVendor(
    @Param('id') id: string,
    @Request() req: { user: AdminTokenPayload },
  ) {
    return this.adminService.suspendVendor(id, req.user.sub, req as any);
  }

  @Post('vendors/:id/reactivate')
  @ApiOperation({ summary: 'Reactivate suspended vendor' })
  async reactivateVendor(
    @Param('id') id: string,
    @Request() req: { user: AdminTokenPayload },
  ) {
    return this.adminService.reactivateVendor(id, req.user.sub, req as any);
  }

  @Post('vendors/:id/remove-for-reregistration')
  @ApiOperation({
    summary:
      'Remove vendor and staff users (no orders) to free email for re-registration',
  })
  async removeVendorForReregistration(
    @Param('id') id: string,
    @Request() req: { user: AdminTokenPayload },
  ) {
    return this.adminService.removeVendorForReregistration(
      id,
      req.user.sub,
      req as any,
    );
  }

  @Post('drivers/:id/approve')
  @ApiOperation({ summary: 'Approve driver' })
  async approveDriver(
    @Param('id') id: string,
    @Request() req: { user: AdminTokenPayload },
  ) {
    return this.adminService.approveDriver(id, req.user.sub, req as any);
  }

  @Post('drivers/:id/reject')
  @ApiOperation({ summary: 'Reject driver' })
  async rejectDriver(
    @Param('id') id: string,
    @Body() dto: RejectReasonDto,
    @Request() req: { user: AdminTokenPayload },
  ) {
    return this.adminService.rejectDriver(
      id,
      dto.reason ?? '',
      req.user.sub,
      req as any,
    );
  }

  @Post('drivers/:id/suspend')
  @ApiOperation({ summary: 'Suspend driver' })
  async suspendDriver(
    @Param('id') id: string,
    @Request() req: { user: AdminTokenPayload },
  ) {
    return this.adminService.suspendDriver(id, req.user.sub, req as any);
  }

  @Post('orders/:id/force-status')
  @ApiOperation({ summary: 'Force order status (admin)' })
  async forceOrderStatus(
    @Param('id') id: string,
    @Body() dto: ForceOrderStatusDto,
    @Request() req: { user: AdminTokenPayload },
  ) {
    return this.adminService.forceOrderStatus(
      id,
      dto.status,
      req.user.sub,
      req as any,
    );
  }

  @Get('risk-flags')
  @ApiOperation({ summary: 'Get risk flags' })
  async getRiskFlags() {
    return this.adminService.getRiskFlags();
  }

  @Get('home-cooking-payment-queue')
  @ApiOperation({
    summary: 'قائمة طلبات الطبخ المنزلي بانتظار تحقق التحويل البنكي',
  })
  async getHomeCookingPaymentQueue(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    const { items, total } =
      await this.eventRequestsService.findHomeCookingPaymentPendingForAdmin({
        page: page ? parseInt(page, 10) : undefined,
        limit: limit ? parseInt(limit, 10) : undefined,
      });
    return {
      items,
      total,
      page: page ? parseInt(page, 10) : 1,
      limit: limit ? parseInt(limit, 10) : 20,
    };
  }

  @Post('home-cooking-requests/:id/verify-payment')
  @ApiOperation({
    summary: 'تأكيد استلام تحويل طلب طبخ منزلي — يُبلّغ المطبخ بالبدء',
  })
  @HttpCode(HttpStatus.OK)
  async verifyHomeCookingPayment(
    @Param('id') id: string,
    @Request() req: { user: AdminTokenPayload } & { ip?: string; headers?: object },
  ) {
    const updated =
      await this.eventRequestsService.verifyHomeCookingPaymentByAdmin(
        id,
        req.user.sub,
      );
    await this.auditService.log({
      actorId: req.user.sub,
      action: 'home_cooking_payment_verified',
      entityType: 'event_request',
      entityId: id,
      newValue: {
        status: updated.status,
        paymentVerifiedAt: updated.paymentVerifiedAt,
      },
      req: req as { ip?: string; headers?: { 'user-agent'?: string } },
    });
    return updated;
  }

  @Get('home-cooking-completed')
  @ApiOperation({
    summary:
      'أرشيف طلبات الطبخ المنزلي المكتملة (بعد تأكيد استلام العميل) مع رمز الإتمام',
  })
  async getHomeCookingCompleted(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    const { items, total } =
      await this.eventRequestsService.findHomeCookingCompletedForAdmin({
        page: page ? parseInt(page, 10) : undefined,
        limit: limit ? parseInt(limit, 10) : undefined,
      });
    return {
      items,
      total,
      page: page ? parseInt(page, 10) : 1,
      limit: limit ? parseInt(limit, 10) : 20,
    };
  }

  @Get('service-quality-tickets')
  @ApiOperation({ summary: 'قائمة بلاغات الجودة (خاصة بالإدارة)' })
  async listServiceQualityTickets(
    @Query('status') status?: QualityTicketStatus,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.serviceExperienceService.listQualityTicketsForAdmin({
      status,
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });
  }

  @Patch('service-quality-tickets/:id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'تحديث حالة تذكرة جودة أو ملاحظات الإدارة' })
  async updateServiceQualityTicket(
    @Param('id') id: string,
    @Body() dto: AdminUpdateQualityTicketDto,
  ) {
    return this.serviceExperienceService.updateQualityTicketByAdmin(id, dto);
  }
}
