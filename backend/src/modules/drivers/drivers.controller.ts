import {
  Controller,
  Get,
  Post,
  Put,
  Body,
  Param,
  UseGuards,
  Request,
  Query,
  NotFoundException,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiResponse,
  ApiQuery,
} from '@nestjs/swagger';
import { DriversService } from './drivers.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RegisterDriverStep1Dto } from './dto/register-driver-step1.dto';
import { RegisterDriverStep2Dto } from './dto/register-driver-step2.dto';
import { RegisterDriverStep3Dto } from './dto/register-driver-step3.dto';
import { UpdateDriverAvailabilityDto } from './dto/update-driver-availability.dto';
import { UpdateFcmTokenDto } from './dto/update-fcm-token.dto';
import { DriverStatus } from './enums/driver-status.enum';

@ApiTags('drivers')
@Controller('drivers')
export class DriversController {
  constructor(private readonly driversService: DriversService) {}

  @Post('register/step1')
  @ApiOperation({ summary: 'Register driver - Step 1: Basic info' })
  @ApiResponse({ status: 201, description: 'Driver registered successfully' })
  @ApiResponse({ status: 409, description: 'Driver already exists' })
  async registerStep1(@Body() dto: RegisterDriverStep1Dto) {
    return this.driversService.registerStep1(dto);
  }

  @Post('register/step2/:driverId')
  @ApiOperation({ summary: 'Register driver - Step 2: Documents' })
  @ApiResponse({ status: 200, description: 'Documents submitted successfully' })
  @ApiResponse({ status: 404, description: 'Driver not found' })
  @ApiResponse({ status: 400, description: 'Invalid documents' })
  async registerStep2(
    @Param('driverId') driverId: string,
    @Body() dto: RegisterDriverStep2Dto,
  ) {
    return this.driversService.registerStep2(driverId, dto);
  }

  @Post('register/step3/:driverId')
  @ApiOperation({ summary: 'Register driver - Step 3: Insurance & Banking' })
  @ApiResponse({ status: 200, description: 'Additional info submitted successfully' })
  @ApiResponse({ status: 404, description: 'Driver not found' })
  async registerStep3(
    @Param('driverId') driverId: string,
    @Body() dto: RegisterDriverStep3Dto,
  ) {
    return this.driversService.registerStep3(driverId, dto);
  }

  @Get('track/:nationalId')
  @ApiOperation({ summary: 'Track application status' })
  @ApiResponse({ status: 200, description: 'Application status retrieved' })
  @ApiResponse({ status: 404, description: 'Application not found' })
  async trackApplication(@Param('nationalId') nationalId: string) {
    return this.driversService.trackApplication(nationalId);
  }

  @Get('exists')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Check if driver exists for authenticated user' })
  @ApiResponse({ status: 200, description: 'Driver exists check result' })
  async checkDriverExists(@Request() req: any) {
    const userId = req.user.id;
    const driver = await this.driversService.getDriverByUserId(userId);
    return { exists: !!driver };
  }

  @Get('profile')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get driver profile' })
  @ApiResponse({ status: 200, description: 'Profile retrieved successfully' })
  @ApiResponse({ status: 404, description: 'Driver not found' })
  async getProfile(@Request() req: any) {
    // Get driver by user ID from JWT
    const userId = req.user.id;
    const driver = await this.driversService.getDriverByUserId(userId);

    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    return this.driversService.getProfile(driver.id);
  }

  @Put('availability')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update driver availability (online/offline)' })
  @ApiResponse({ status: 200, description: 'Availability updated successfully' })
  @ApiResponse({ status: 403, description: 'Driver not approved' })
  async updateAvailability(
    @Request() req: any,
    @Body() dto: UpdateDriverAvailabilityDto,
  ) {
    const userId = req.user.id;
    const driver = await this.driversService.getDriverByUserId(userId);

    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    return this.driversService.updateAvailability(driver.id, dto);
  }

  @Put('fcm-token')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update FCM token for push notifications' })
  @ApiResponse({ status: 200, description: 'FCM token updated successfully' })
  @ApiResponse({ status: 404, description: 'Driver not found' })
  async updateFcmToken(
    @Request() req: any,
    @Body() dto: UpdateFcmTokenDto,
  ) {
    const userId = req.user.id;
    const driver = await this.driversService.getDriverByUserId(userId);

    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    return this.driversService.updateFcmToken(driver.id, dto.fcmToken);
  }

  // Admin endpoints
  @Get('admin/all')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get all drivers (Admin only)' })
  @ApiQuery({ name: 'status', required: false, enum: DriverStatus })
  @ApiResponse({ status: 200, description: 'Drivers retrieved successfully' })
  async getAllDrivers(@Query('status') status?: DriverStatus) {
    return this.driversService.getAllDrivers(status);
  }

  @Post('admin/:driverId/approve')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Approve driver (Admin only)' })
  @ApiResponse({ status: 200, description: 'Driver approved successfully' })
  @ApiResponse({ status: 404, description: 'Driver not found' })
  async approveDriver(
    @Param('driverId') driverId: string,
    @Request() req: any,
  ) {
    const adminId = req.user.id;
    return this.driversService.approveDriver(driverId, adminId);
  }

  @Post('admin/:driverId/reject')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Reject driver (Admin only)' })
  @ApiResponse({ status: 200, description: 'Driver rejected successfully' })
  @ApiResponse({ status: 404, description: 'Driver not found' })
  async rejectDriver(
    @Param('driverId') driverId: string,
    @Body('rejectionReason') rejectionReason: string,
    @Request() req: any,
  ) {
    const adminId = req.user.id;
    return this.driversService.rejectDriver(driverId, rejectionReason, adminId);
  }
}
