import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order, OrderStatus } from './entities/order.entity';
import { OrderItem } from './entities/order-item.entity';
import { Cart } from '../cart/entities/cart.entity';
import { CartItem } from '../cart/entities/cart-item.entity';
import { Address } from '../addresses/entities/address.entity';
import { CreateOrderDto } from './dto/create-order.dto';

@Injectable()
export class OrdersService {
  constructor(
    @InjectRepository(Order)
    private readonly orderRepository: Repository<Order>,
    @InjectRepository(OrderItem)
    private readonly orderItemRepository: Repository<OrderItem>,
    @InjectRepository(Cart)
    private readonly cartRepository: Repository<Cart>,
    @InjectRepository(CartItem)
    private readonly cartItemRepository: Repository<CartItem>,
    @InjectRepository(Address)
    private readonly addressRepository: Repository<Address>,
  ) {}

  /**
   * Generate unique order number
   */
  private async generateOrderNumber(): Promise<string> {
    const year = new Date().getFullYear();
    const startOfYear = new Date(`${year}-01-01`);
    const endOfYear = new Date(`${year + 1}-01-01`);

    const count = await this.orderRepository
      .createQueryBuilder('order')
      .where('order.createdAt >= :start', { start: startOfYear })
      .andWhere('order.createdAt < :end', { end: endOfYear })
      .getCount();

    const orderNumber = `ORD-${year}-${String(count + 1).padStart(6, '0')}`;
    return orderNumber;
  }

  /**
   * Calculate estimated delivery time (simple: 30-45 minutes)
   */
  private calculateETA(): Date {
    const eta = new Date();
    eta.setMinutes(eta.getMinutes() + 30 + Math.floor(Math.random() * 15)); // 30-45 minutes
    return eta;
  }

  /**
   * Create order from cart
   */
  async createOrder(userId: string, dto: CreateOrderDto) {
    const { addressId, notes } = dto;

    // Get user cart
    const cart = await this.cartRepository.findOne({
      where: { userId },
      relations: ['items', 'items.menuItem', 'vendor'],
    });

    if (!cart || !cart.items || cart.items.length === 0) {
      throw new BadRequestException('Cart is empty');
    }

    if (!cart.vendorId) {
      throw new BadRequestException('Cart has no vendor');
    }

    // Verify address belongs to user
    const address = await this.addressRepository.findOne({
      where: { id: addressId, userId },
    });

    if (!address) {
      throw new NotFoundException('Address not found or does not belong to user');
    }

    if (!address.isActive) {
      throw new BadRequestException('Address is not active');
    }

    // Generate order number
    const orderNumber = await this.generateOrderNumber();

    // Create order
    const order = this.orderRepository.create({
      userId,
      vendorId: cart.vendorId,
      addressId: address.id,
      orderNumber,
      status: OrderStatus.PENDING,
      subtotal: cart.subtotal,
      deliveryFee: cart.deliveryFee,
      total: cart.total,
      estimatedDeliveryTime: this.calculateETA(),
    });

    const savedOrder = await this.orderRepository.save(order);

    // Create order items from cart items
    const orderItems = cart.items.map((cartItem) =>
      this.orderItemRepository.create({
        orderId: savedOrder.id,
        menuItemId: cartItem.menuItemId,
        quantity: cartItem.quantity,
        price: cartItem.price,
      }),
    );

    await this.orderItemRepository.save(orderItems);

    // Clear cart
    await this.cartItemRepository.delete({ cartId: cart.id });
    cart.vendorId = null;
    cart.subtotal = 0;
    cart.deliveryFee = 0;
    cart.total = 0;
    await this.cartRepository.save(cart);

    // Return order with relations
    return this.getOrderDetails(savedOrder.id, userId);
  }

  /**
   * Get user orders
   */
  async getOrders(userId: string) {
    const orders = await this.orderRepository.find({
      where: { userId },
      relations: ['items', 'items.menuItem', 'vendor', 'address'],
      order: { createdAt: 'DESC' },
    });

    return orders.map((order) => ({
      id: order.id,
      orderNumber: order.orderNumber,
      status: order.status,
      vendor: {
        id: order.vendor.id,
        name: order.vendor.name,
        logo: order.vendor.logo,
      },
      items: order.items.map((item) => ({
        id: item.id,
        menuItem: {
          id: item.menuItem.id,
          name: item.menuItem.name,
          image: item.menuItem.image,
        },
        quantity: item.quantity,
        price: parseFloat(item.price.toString()),
      })),
      subtotal: parseFloat(order.subtotal.toString()),
      deliveryFee: parseFloat(order.deliveryFee.toString()),
      total: parseFloat(order.total.toString()),
      estimatedDeliveryTime: order.estimatedDeliveryTime,
      createdAt: order.createdAt,
    }));
  }

  /**
   * Get order details
   */
  async getOrderDetails(orderId: string, userId: string) {
    const order = await this.orderRepository.findOne({
      where: { id: orderId },
      relations: ['items', 'items.menuItem', 'vendor', 'address', 'driver'],
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    // Verify order belongs to user
    if (order.userId !== userId) {
      throw new ForbiddenException('Order does not belong to user');
    }

    return {
      id: order.id,
      orderNumber: order.orderNumber,
      status: order.status,
      vendor: {
        id: order.vendor.id,
        name: order.vendor.name,
        logo: order.vendor.logo,
        phoneNumber: order.vendor.phoneNumber,
      },
      address: {
        id: order.address.id,
        label: order.address.label,
        streetAddress: order.address.streetAddress,
        building: order.address.building,
        floor: order.address.floor,
        apartment: order.address.apartment,
        city: order.address.city,
        district: order.address.district,
      },
      items: order.items.map((item) => ({
        id: item.id,
        menuItem: {
          id: item.menuItem.id,
          name: item.menuItem.name,
          description: item.menuItem.description,
          image: item.menuItem.image,
        },
        quantity: item.quantity,
        price: parseFloat(item.price.toString()),
        subtotal: parseFloat(item.price.toString()) * item.quantity,
      })),
      subtotal: parseFloat(order.subtotal.toString()),
      deliveryFee: parseFloat(order.deliveryFee.toString()),
      total: parseFloat(order.total.toString()),
      estimatedDeliveryTime: order.estimatedDeliveryTime,
      deliveredAt: order.deliveredAt,
      driverId: order.driverId,
      driverPhone: order.driver?.phoneNumber ?? null,
      driverName: order.driver?.fullName ?? null,
      driverLatitude: order.driverLatitude,
      driverLongitude: order.driverLongitude,
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    };
  }

  /**
   * Cancel order
   */
  async cancelOrder(orderId: string, userId: string) {
    const order = await this.orderRepository.findOne({
      where: { id: orderId },
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    // Verify order belongs to user
    if (order.userId !== userId) {
      throw new ForbiddenException('Order does not belong to user');
    }

    // Only allow cancellation for pending or confirmed orders
    if (
      order.status !== OrderStatus.PENDING &&
      order.status !== OrderStatus.CONFIRMED
    ) {
      throw new BadRequestException(
        `Cannot cancel order with status: ${order.status}`,
      );
    }

    order.status = OrderStatus.CANCELLED;
    await this.orderRepository.save(order);

    return {
      message: 'Order cancelled successfully',
      order: await this.getOrderDetails(orderId, userId),
    };
  }
}
