import {
  Controller,
  Get,
  Post,
  Put,
  Param,
  Body,
  UseGuards,
  Request,
  NotFoundException,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiResponse,
} from '@nestjs/swagger';
import { DeliveryService } from './delivery.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { UpdateLocationDto } from './dto/update-location.dto';
import { UpdateDeliveryStatusDto } from './dto/update-delivery-status.dto';

@ApiTags('delivery')
@Controller('delivery')
export class DeliveryController {
  constructor(private readonly deliveryService: DeliveryService) {}

  @Get('tracking/:orderId')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Track order (Customer)' })
  @ApiResponse({ status: 200, description: 'Order tracking retrieved' })
  @ApiResponse({ status: 404, description: 'Order not found' })
  async trackOrder(@Param('orderId') orderId: string) {
    return this.deliveryService.trackOrder(orderId);
  }

  @Get(':orderId/details')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get delivery details (Driver)' })
  @ApiResponse({ status: 200, description: 'Delivery details retrieved' })
  @ApiResponse({ status: 403, description: 'Not assigned to this order' })
  async getDeliveryDetails(
    @Param('orderId') orderId: string,
    @Request() req: any,
  ) {
    const userId = req.user.id;
    const driversService = this.deliveryService.getDriversService();
    const driver = await driversService.getDriverByUserId(userId);
    if (!driver) {
      throw new NotFoundException('Driver not found');
    }
    return this.deliveryService.getDeliveryDetails(orderId, driver.id);
  }

  @Post(':orderId/location')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update driver location (Driver)' })
  @ApiResponse({ status: 200, description: 'Location updated successfully' })
  @ApiResponse({ status: 403, description: 'Not assigned to this order' })
  async updateLocation(
    @Param('orderId') orderId: string,
    @Body() dto: UpdateLocationDto,
    @Request() req: any,
  ) {
    const userId = req.user.id;
    const driversService = this.deliveryService.getDriversService();
    const driver = await driversService.getDriverByUserId(userId);
    if (!driver) {
      throw new NotFoundException('Driver not found');
    }
    return this.deliveryService.updateLocation(orderId, driver.id, dto);
  }

  @Put(':orderId/status')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update delivery status (Driver)' })
  @ApiResponse({ status: 200, description: 'Status updated successfully' })
  @ApiResponse({ status: 403, description: 'Not assigned to this order' })
  async updateDeliveryStatus(
    @Param('orderId') orderId: string,
    @Body() dto: UpdateDeliveryStatusDto,
    @Request() req: any,
  ) {
    const userId = req.user.id;
    const driversService = this.deliveryService.getDriversService();
    const driver = await driversService.getDriverByUserId(userId);
    if (!driver) {
      throw new NotFoundException('Driver not found');
    }
    return this.deliveryService.updateDeliveryStatus(orderId, driver.id, dto);
  }
}
