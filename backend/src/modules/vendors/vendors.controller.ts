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
  ApiBody,
} from '@nestjs/swagger';
import { VendorsService } from './vendors.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
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

@ApiTags('vendors')
@Controller('vendors')
export class VendorsController {
  constructor(private readonly vendorsService: VendorsService) {}

  @Post('register')
  @ApiOperation({ summary: 'Register new vendor' })
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
  @ApiOperation({ summary: 'Get vendor profile' })
  async getProfile(@Request() req: { user: User }) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.getProfile(vendorId);
  }

  @Put('profile')
  @UseGuards(JwtAuthGuard)
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
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Change vendor password' })
  @HttpCode(HttpStatus.OK)
  async changePassword(
    @Request() req: { user: User },
    @Body() dto: ChangePasswordDto,
  ) {
    return this.vendorsService.changePassword(req.user.id, dto.currentPassword, dto.newPassword);
  }

  @Post('certificates')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Add certificate' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FileFieldsInterceptor([{ name: 'certificateImage', maxCount: 1 }], storageConfig),
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
  @UseGuards(JwtAuthGuard)
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
  @UseGuards(JwtAuthGuard)
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
  @UseGuards(JwtAuthGuard)
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
  @UseGuards(JwtAuthGuard)
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
  @UseGuards(JwtAuthGuard)
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
  @UseGuards(JwtAuthGuard)
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
  @Get('menu')
  @UseGuards(JwtAuthGuard)
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
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Add menu item' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileFieldsInterceptor([{ name: 'image', maxCount: 1 }], storageConfig))
  @HttpCode(HttpStatus.CREATED)
  async addMenuItem(
    @Request() req: { user: User },
    @Body() body: {
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
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update menu item' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileFieldsInterceptor([{ name: 'image', maxCount: 1 }], storageConfig))
  async updateMenuItem(
    @Request() req: { user: User },
    @Param('id') menuItemId: string,
    @Body() body: {
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
      isSignature: body.isSignature !== undefined ? body.isSignature === 'true' : undefined,
      isAvailable: body.isAvailable !== undefined ? body.isAvailable !== 'false' : undefined,
    });
  }

  @Delete('menu/:id')
  @UseGuards(JwtAuthGuard)
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
  @UseGuards(JwtAuthGuard)
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
  @UseGuards(JwtAuthGuard)
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
  @UseGuards(JwtAuthGuard)
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
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Add staff member' })
  @HttpCode(HttpStatus.CREATED)
  async addStaff(
    @Request() req: { user: User },
    @Body() dto: AddStaffDto,
  ) {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) {
      throw new NotFoundException('Vendor not found for this user');
    }
    return this.vendorsService.addStaff(vendorId, dto);
  }

  @Put('staff/:id')
  @UseGuards(JwtAuthGuard)
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
  @UseGuards(JwtAuthGuard)
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

  @Get(':id')
  @ApiOperation({ summary: 'Get vendor details' })
  async getVendor(@Param('id') id: string) {
    return this.vendorsService.getVendor(id);
  }
}
