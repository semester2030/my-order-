import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order, OrderStatus } from '../orders/entities/order.entity';
import { Driver } from '../drivers/entities/driver.entity';
import { DriversService } from '../drivers/drivers.service';
import { UpdateLocationDto } from './dto/update-location.dto';
import { UpdateDeliveryStatusDto } from './dto/update-delivery-status.dto';

@Injectable()
export class DeliveryService {
  constructor(
    @InjectRepository(Order)
    private readonly orderRepository: Repository<Order>,
    @InjectRepository(Driver)
    private readonly driverRepository: Repository<Driver>,
    private readonly driversService: DriversService,
  ) {}

  // Expose driversService for controller access
  getDriversService() {
    return this.driversService;
  }

  /**
   * Track order (for customer)
   */
  async trackOrder(orderId: string) {
    const order = await this.orderRepository.findOne({
      where: { id: orderId },
      relations: ['vendor', 'address', 'driver'],
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    return {
      orderId: order.id,
      orderNumber: order.orderNumber,
      status: order.status,
      driver: order.driverId
        ? {
            id: order.driver?.id,
            name: order.driver?.fullName,
            latitude: order.driverLatitude,
            longitude: order.driverLongitude,
          }
        : null,
      estimatedDeliveryTime: order.estimatedDeliveryTime,
      deliveredAt: order.deliveredAt,
    };
  }

  /**
   * Update driver location (for active delivery)
   */
  async updateLocation(orderId: string, driverId: string, dto: UpdateLocationDto) {
    const order = await this.orderRepository.findOne({
      where: { id: orderId },
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    if (order.driverId !== driverId) {
      throw new ForbiddenException('You are not assigned to this order');
    }

    if (order.status !== OrderStatus.OUT_FOR_DELIVERY) {
      throw new BadRequestException(
        `Cannot update location. Order status: ${order.status}`,
      );
    }

    // Update order location
    order.driverLatitude = dto.latitude;
    order.driverLongitude = dto.longitude;
    await this.orderRepository.save(order);

    // Update driver current location
    const driver = await this.driverRepository.findOne({
      where: { id: driverId },
    });

    if (driver) {
      driver.currentLatitude = dto.latitude;
      driver.currentLongitude = dto.longitude;
      driver.lastLocationUpdate = new Date();
      await this.driverRepository.save(driver);
    }

    return {
      orderId: order.id,
      latitude: order.driverLatitude,
      longitude: order.driverLongitude,
      updatedAt: new Date(),
    };
  }

  /**
   * Update delivery status (picked up, delivered)
   */
  async updateDeliveryStatus(
    orderId: string,
    driverId: string,
    dto: UpdateDeliveryStatusDto,
  ) {
    const order = await this.orderRepository.findOne({
      where: { id: orderId },
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    if (order.driverId !== driverId) {
      throw new ForbiddenException('You are not assigned to this order');
    }

    // Validate status transition
    if (dto.status === 'picked_up') {
      if (order.status !== OrderStatus.OUT_FOR_DELIVERY) {
        throw new BadRequestException(
          `Cannot mark as picked up. Current status: ${order.status}`,
        );
      }
      // Keep status as OUT_FOR_DELIVERY, just track that it's picked up
      // You can add a 'pickedUpAt' field if needed
    } else if (dto.status === OrderStatus.DELIVERED) {
      if (order.status !== OrderStatus.OUT_FOR_DELIVERY) {
        throw new BadRequestException(
          `Cannot mark as delivered. Current status: ${order.status}`,
        );
      }
      order.status = OrderStatus.DELIVERED;
      order.deliveredAt = new Date();
    } else {
      throw new BadRequestException('Invalid status');
    }

    await this.orderRepository.save(order);

    return {
      orderId: order.id,
      status: order.status,
      deliveredAt: order.deliveredAt,
      message: 'Delivery status updated successfully',
    };
  }

  /**
   * Get delivery details for driver
   */
  async getDeliveryDetails(orderId: string, driverId: string) {
    const order = await this.orderRepository.findOne({
      where: { id: orderId },
      relations: ['vendor', 'address', 'items', 'user'],
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    if (order.driverId !== driverId) {
      throw new ForbiddenException('You are not assigned to this order');
    }

    return {
      orderId: order.id,
      orderNumber: order.orderNumber,
      status: order.status,
      total: order.total,
      deliveryFee: order.deliveryFee,
      vendor: {
        id: order.vendor.id,
        name: order.vendor.name,
        address: order.vendor.address,
        phoneNumber: order.vendor.phoneNumber,
        latitude: order.vendor.latitude,
        longitude: order.vendor.longitude,
      },
      customer: {
        id: order.user.id,
        name: order.user.name,
        phone: order.user.phone ?? order.user.email ?? '',
      },
      deliveryAddress: {
        streetAddress: order.address.streetAddress,
        city: order.address.city,
        district: order.address.district,
        latitude: order.address.latitude,
        longitude: order.address.longitude,
      },
      items: order.items,
      estimatedDeliveryTime: order.estimatedDeliveryTime,
      createdAt: order.createdAt,
    };
  }
}
