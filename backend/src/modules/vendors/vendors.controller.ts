import {
  Controller,
  Get,
  Post,
  Put,
  Patch,
  Delete,
  Param,
  Body,
  Query,
  UseGuards,
  UseInterceptors,
  UploadedFiles,
  Request,
  HttpCode,
  HttpStatus,
  NotFoundException,
} from '@nestjs/common';
import { FileFieldsInterceptor } from '@nestjs/platform-express';
import { storageConfig } from '../../config/storage.config';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiConsumes,
} from '@nestjs/swagger';
import { VendorsService } from './vendors.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { ApprovedVendorGuard } from './guards/approved-vendor.guard';
import { RegisterVendorDto } from './dto/register-vendor.dto';
import { UpdateVendorProfileDto } from './dto/update-vendor-profile.dto';
import { AddCertificateDto } from './dto/add-certificate.dto';
import { UpdateOrderStatusDto } from './dto/update-order-status.dto';
import { RejectOrderDto } from './dto/reject-order.dto';
import { AddStaffDto } from './dto/add-staff.dto';
import { UpdateStaffDto } from './dto/update-staff.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { User } from '../users/entities/user.entity';
import { OrderStatus } from '../orders/entities/order.entity';
import { PrivateEventsService } from '../private-events/private-events.service';
import { CreateEventOfferDto } from '../private-events/dto/create-event-offer.dto';
import { AcceptMenuOfferingTermsDto } from './dto/accept-menu-offering-terms.dto';

@ApiTags('vendors')
@Controller('vendors')
export class VendorsController {
  constructor(
    private readonly vendorsService: VendorsService,
    private readonly privateEventsService: PrivateEventsService,
  ) {}

  @Post('register')
  @ApiOperation({
    summary: 'تسجيل مقدّم خدمة (طبّاخ منزلي، شعبي، شواء، مناسبات/بوفيه)',
  })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FileFieldsInterceptor(
      [
        { name: 'commercialRegistration', maxCount: 1 },
        { name: 'ownerId', maxCount: 1 },
        { name: 'logo', maxCount: 1 },
        { name: 'cover', maxCount: 1 },
        { name: 'restaurantImages', maxCount: 10 },
      ],
      storageConfig,
    ),
  )
  @HttpCode(HttpStatus.CREATED)
  async register(
    @Body() dto: RegisterVendorDto,
    @UploadedFiles()
    files?: {
      commercialRegistration?: any[];
      ownerId?: any[];
      logo?: any[];
      cover?: any[];
      restaurantImages?: any[];
    },
  ) {
    return this.vendorsService.register(dto, files);
  }

  @Get('registration-status/:id')
  @ApiOperation({ summary: 'Check registration status' })
  async getRegistrationStatus(@Param('id') id: string) {
    return this.vendorsService.getRegistrationStatus(id);
  }

  @Get('profile')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({
    summary:
      'Get vendor profile (أي حالة تسجيل — للعرض في التطبيق قبل/بعد الاعتماد)',
  })
  async getProfile(@Request() req: { user: User }) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.getProfile(vendorId);
  }

  @Put('profile')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update vendor profile' })
  async updateProfile(
    @Request() req: { user: User },
    @Body() dto: UpdateVendorProfileDto,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.updateProfile(vendorId, dto);
  }

  @Patch('change-password')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Change vendor password' })
  @HttpCode(HttpStatus.OK)
  async changePassword(
    @Request() req: { user: User },
    @Body() dto: ChangePasswordDto,
  ) {
    return this.vendorsService.changePassword(
      req.user.id,
      dto.currentPassword,
      dto.newPassword,
    );
  }

  @Post('certificates')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Add certificate' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FileFieldsInterceptor(
      [{ name: 'certificateImage', maxCount: 1 }],
      storageConfig,
    ),
  )
  async addCertificate(
    @Request() req: { user: User },
    @Body() dto: AddCertificateDto,
    @UploadedFiles()
    files?: {
      certificateImage?: any[];
    },
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.addCertificate(
      vendorId,
      dto,
      files?.certificateImage?.[0],
    );
  }

  @Get('certificates')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get vendor certificates' })
  async getCertificates(@Request() req: { user: User }) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.getCertificates(vendorId);
  }

  // Vendor Orders Management
  @Get('orders')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get vendor orders' })
  async getOrders(
    @Request() req: { user: User },
    @Query('status') status?: OrderStatus,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.getVendorOrders(vendorId, status);
  }

  @Get('orders/:orderId')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get vendor order details' })
  async getOrder(
    @Request() req: { user: User },
    @Param('orderId') orderId: string,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.getVendorOrder(vendorId, orderId);
  }

  @Post('orders/:orderId/accept')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Accept order' })
  @HttpCode(HttpStatus.OK)
  async acceptOrder(
    @Request() req: { user: User },
    @Param('orderId') orderId: string,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.acceptOrder(vendorId, orderId);
  }

  @Post('orders/:orderId/reject')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Reject order' })
  @HttpCode(HttpStatus.OK)
  async rejectOrder(
    @Request() req: { user: User },
    @Param('orderId') orderId: string,
    @Body() dto: RejectOrderDto,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.rejectOrder(vendorId, orderId, dto.reason);
  }

  @Patch('orders/:orderId/status')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update order status' })
  async updateOrderStatus(
    @Request() req: { user: User },
    @Param('orderId') orderId: string,
    @Body() dto: UpdateOrderStatusDto,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.updateOrderStatus(vendorId, orderId, dto.status);
  }

  // Vendor Menu Management
  @Get('menu-offering-terms/status')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({
    summary:
      'حالة قبول الشروط العامة لعرض الوجبات (قبل أول إضافة وجبة — مشتركة لكل الفئات)',
  })
  async getMenuOfferingTermsStatus(@Request() req: { user: User }) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.getMenuOfferingTermsStatus(vendorId);
  }

  @Post('menu-offering-terms/accept')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'قبول الشروط العامة لعرض الوجبات' })
  @HttpCode(HttpStatus.OK)
  async acceptMenuOfferingTerms(
    @Request() req: { user: User },
    @Body() dto: AcceptMenuOfferingTermsDto,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    await this.vendorsService.acceptMenuOfferingTerms(
      vendorId,
      dto.documentVersion,
    );
    return { success: true };
  }

  @Get('menu')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get vendor menu' })
  async getMenu(@Request() req: { user: User }) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.getVendorMenu(vendorId);
  }

  @Post('menu')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Add menu item' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FileFieldsInterceptor([{ name: 'image', maxCount: 1 }], storageConfig),
  )
  @HttpCode(HttpStatus.CREATED)
  async addMenuItem(
    @Request() req: { user: User },
    @Body()
    body: {
      name: string;
      description?: string;
      price: string;
      isSignature?: string;
      isAvailable?: string;
    },
    @UploadedFiles() files?: { image?: any[] },
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.addMenuItem(vendorId, {
      name: body.name,
      description: body.description,
      price: parseFloat(body.price),
      image: files?.image?.[0]?.filename,
      isSignature: body.isSignature === 'true',
      isAvailable: body.isAvailable !== 'false',
    });
  }

  @Put('menu/:id')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update menu item' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FileFieldsInterceptor([{ name: 'image', maxCount: 1 }], storageConfig),
  )
  async updateMenuItem(
    @Request() req: { user: User },
    @Param('id') menuItemId: string,
    @Body()
    body: {
      name?: string;
      description?: string;
      price?: string;
      isSignature?: string;
      isAvailable?: string;
    },
    @UploadedFiles() files?: { image?: any[] },
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.updateMenuItem(vendorId, menuItemId, {
      name: body.name,
      description: body.description,
      price: body.price ? parseFloat(body.price) : undefined,
      image: files?.image?.[0]?.filename,
      isSignature:
        body.isSignature !== undefined
          ? body.isSignature === 'true'
          : undefined,
      isAvailable:
        body.isAvailable !== undefined
          ? body.isAvailable !== 'false'
          : undefined,
    });
  }

  @Delete('menu/:id')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Delete menu item' })
  @HttpCode(HttpStatus.NO_CONTENT)
  async deleteMenuItem(
    @Request() req: { user: User },
    @Param('id') menuItemId: string,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    await this.vendorsService.deleteMenuItem(vendorId, menuItemId);
  }

  @Patch('menu/:id/availability')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Set menu item availability' })
  async toggleMenuItemAvailability(
    @Request() req: { user: User },
    @Param('id') menuItemId: string,
    @Body() body: { isAvailable?: boolean },
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.setMenuItemAvailability(
      vendorId,
      menuItemId,
      body.isAvailable,
    );
  }

  // Vendor Analytics
  @Get('analytics')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get vendor analytics' })
  async getAnalytics(
    @Request() req: { user: User },
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.getVendorAnalytics(
      vendorId,
      startDate ? new Date(startDate) : undefined,
      endDate ? new Date(endDate) : undefined,
    );
  }

  // Vendor Staff Management
  @Get('staff')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get vendor staff' })
  async getStaff(@Request() req: { user: User }) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.getVendorStaff(vendorId);
  }

  @Post('staff')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Add staff member' })
  @HttpCode(HttpStatus.CREATED)
  async addStaff(@Request() req: { user: User }, @Body() dto: AddStaffDto) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.addStaff(vendorId, dto);
  }

  @Put('staff/:id')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update staff member' })
  async updateStaff(
    @Request() req: { user: User },
    @Param('id') staffId: string,
    @Body() dto: UpdateStaffDto,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.updateStaff(vendorId, staffId, dto);
  }

  @Delete('staff/:id')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Remove staff member' })
  @HttpCode(HttpStatus.NO_CONTENT)
  async removeStaff(
    @Request() req: { user: User },
    @Param('id') staffId: string,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    await this.vendorsService.removeStaff(vendorId, staffId);
  }

  // المناسبات الخاصة — عروض المقدم
  @Get('event-offers')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'عروض المناسبات الخاصة (للمقدم)' })
  async getMyEventOffers(@Request() req: { user: User }) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) throw new NotFoundException('Vendor not found');
    return this.privateEventsService.getVendorEventOffersForManagement(
      vendorId,
    );
  }

  @Post('event-offers')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'إضافة عرض مناسبة' })
  @HttpCode(HttpStatus.CREATED)
  async createEventOffer(
    @Request() req: { user: User },
    @Body() dto: CreateEventOfferDto,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) throw new NotFoundException('Vendor not found');
    return this.privateEventsService.createEventOffer(vendorId, dto);
  }

  @Put('event-offers/:offerId')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'تحديث عرض مناسبة' })
  async updateEventOffer(
    @Request() req: { user: User },
    @Param('offerId') offerId: string,
    @Body() dto: CreateEventOfferDto,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) throw new NotFoundException('Vendor not found');
    return this.privateEventsService.updateEventOffer(vendorId, offerId, dto);
  }

  @Delete('event-offers/:offerId')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'حذف عرض مناسبة' })
  @HttpCode(HttpStatus.NO_CONTENT)
  async deleteEventOffer(
    @Request() req: { user: User },
    @Param('offerId') offerId: string,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) throw new NotFoundException('Vendor not found');
    await this.privateEventsService.deleteEventOffer(vendorId, offerId);
  }

  @Get('private-event-requests')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'طلبات المناسبات الواردة للمقدم' })
  async getPrivateEventRequests(@Request() req: { user: User }) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) throw new NotFoundException('Vendor not found');
    return this.privateEventsService.findPrivateEventRequestsByVendor(vendorId);
  }

  @Post('private-event-requests/:requestId/accept')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'قبول طلب مناسبة' })
  @HttpCode(HttpStatus.OK)
  async acceptPrivateEventRequest(
    @Request() req: { user: User },
    @Param('requestId') requestId: string,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) throw new NotFoundException('Vendor not found');
    return this.privateEventsService.updatePrivateEventRequestStatus(
      vendorId,
      requestId,
      'accepted',
    );
  }

  @Post('private-event-requests/:requestId/reject')
  @UseGuards(JwtAuthGuard, ApprovedVendorGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'رفض طلب مناسبة' })
  @HttpCode(HttpStatus.OK)
  async rejectPrivateEventRequest(
    @Request() req: { user: User },
    @Param('requestId') requestId: string,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) throw new NotFoundException('Vendor not found');
    return this.privateEventsService.updatePrivateEventRequestStatus(
      vendorId,
      requestId,
      'rejected',
    );
  }

  @Get(':id/event-offers')
  @ApiOperation({ summary: 'عروض المناسبات للمقدم (عام)' })
  async getVendorEventOffers(@Param('id') id: string) {
    return this.privateEventsService.getVendorEventOffers(id);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get vendor details' })
  async getVendor(@Param('id') id: string) {
    const vendor = await this.vendorsService.getVendor(id);
    if (!vendor) throw new NotFoundException('Vendor not found');
    // تضمين snake_case للتوافق مع تطبيق العميل (provider_category, popular_cooking_add_ons)
    return {
      ...vendor,
      provider_category: vendor.providerCategory,
      popular_cooking_add_ons: vendor.popularCookingAddOns,
    };
  }
}
