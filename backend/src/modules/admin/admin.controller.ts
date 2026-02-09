import { Controller, Get, Post, Query, Param, Body, UseGuards, Request } from '@nestjs/common';
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

@ApiTags('admin')
@Controller('admin')
@UseGuards(AdminJwtGuard)
@ApiBearerAuth('admin')
export class AdminController {
  constructor(
    private readonly adminService: AdminService,
    private readonly auditService: AuditService,
  ) {}

  @Get('dashboard')
  @ApiOperation({ summary: 'Get admin dashboard' })
  async getDashboard() {
    return this.adminService.getDashboard();
  }

  @Get('audit-logs')
  @ApiOperation({ summary: 'Get audit logs' })
  async getAuditLogs(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('action') action?: string,
    @Query('entityType') entityType?: string,
  ) {
    return this.auditService.findMany({
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
      action,
      entityType,
    });
  }

  @Get('vendors')
  @ApiOperation({ summary: 'List vendors' })
  async getVendors(
    @Query('status') status?: VendorStatus,
    @Query('category') category?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.adminService.getVendorsList({
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
  @ApiOperation({ summary: 'List disputes (stub — returns empty until disputes entity exists)' })
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
    return this.adminService.rejectVendor(id, dto.reason ?? '', req.user.sub, req as any);
  }

  @Post('vendors/:id/suspend')
  @ApiOperation({ summary: 'Suspend vendor' })
  async suspendVendor(
    @Param('id') id: string,
    @Request() req: { user: AdminTokenPayload },
  ) {
    return this.adminService.suspendVendor(id, req.user.sub, req as any);
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
    return this.adminService.rejectDriver(id, dto.reason ?? '', req.user.sub, req as any);
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
    return this.adminService.forceOrderStatus(id, dto.status, req.user.sub, req as any);
  }

  @Get('risk-flags')
  @ApiOperation({ summary: 'Get risk flags' })
  async getRiskFlags() {
    return this.adminService.getRiskFlags();
  }
}
