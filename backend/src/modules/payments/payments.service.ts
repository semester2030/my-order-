import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Payment, PaymentStatus, PaymentMethod } from './entities/payment.entity';
import { Order, OrderStatus } from '../orders/entities/order.entity';
import { InitiatePaymentDto } from './dto/initiate-payment.dto';
import { ConfirmPaymentDto } from './dto/confirm-payment.dto';

@Injectable()
export class PaymentsService {
  constructor(
    @InjectRepository(Payment)
    private readonly paymentRepository: Repository<Payment>,
    @InjectRepository(Order)
    private readonly orderRepository: Repository<Order>,
  ) {}

  /**
   * Initiate payment for an order
   */
  async initiatePayment(userId: string, dto: InitiatePaymentDto) {
    const { orderId, method } = dto;

    // Get order
    const order = await this.orderRepository.findOne({
      where: { id: orderId },
      relations: ['payments'],
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    // Verify order belongs to user
    if (order.userId !== userId) {
      throw new ForbiddenException('Order does not belong to user');
    }

    // Check if order is in valid status for payment
    if (order.status !== OrderStatus.PENDING && order.status !== OrderStatus.CONFIRMED) {
      throw new BadRequestException(
        `Cannot initiate payment for order with status: ${order.status}`,
      );
    }

    // Check if payment already exists and is completed
    const existingPayment = order.payments?.find(
      (p) => p.status === PaymentStatus.COMPLETED,
    );

    if (existingPayment) {
      throw new BadRequestException('Order already has a completed payment');
    }

    // Check if there's a pending payment
    const pendingPayment = order.payments?.find(
      (p) => p.status === PaymentStatus.PENDING,
    );

    if (pendingPayment) {
      throw new BadRequestException('Payment already initiated for this order');
    }

    // Create payment
    const payment = this.paymentRepository.create({
      orderId: order.id,
      method,
      amount: order.total,
      status: PaymentStatus.PENDING,
    });

    const savedPayment = await this.paymentRepository.save(payment);

    // Update order status to CONFIRMED (payment initiated)
    if (order.status === OrderStatus.PENDING) {
      order.status = OrderStatus.CONFIRMED;
      await this.orderRepository.save(order);
    }

    // In a real implementation, you would:
    // 1. Call payment gateway API (Apple Pay, Mada, STC Pay)
    // 2. Get payment intent/session
    // 3. Return payment details to client

    // For now, return payment with mock gateway response
    return {
      id: savedPayment.id,
      orderId: savedPayment.orderId,
      method: savedPayment.method,
      amount: parseFloat(savedPayment.amount.toString()),
      status: savedPayment.status,
      paymentIntent: `pi_mock_${savedPayment.id}`, // Mock payment intent ID
      clientSecret: `cs_mock_${savedPayment.id}`, // Mock client secret
      message: 'Payment initiated. Please complete payment using the provided details.',
    };
  }

  /**
   * Confirm payment (webhook or client callback)
   */
  async confirmPayment(userId: string, dto: ConfirmPaymentDto) {
    const { paymentId, transactionId } = dto;

    // Get payment
    const payment = await this.paymentRepository.findOne({
      where: { id: paymentId },
      relations: ['order'],
    });

    if (!payment) {
      throw new NotFoundException('Payment not found');
    }

    // Verify order belongs to user
    if (payment.order.userId !== userId) {
      throw new ForbiddenException('Payment does not belong to user');
    }

    // Check payment status
    if (payment.status === PaymentStatus.COMPLETED) {
      throw new BadRequestException('Payment already completed');
    }

    if (payment.status === PaymentStatus.FAILED) {
      throw new BadRequestException('Payment has failed and cannot be confirmed');
    }

    // In a real implementation, you would:
    // 1. Verify transaction with payment gateway
    // 2. Check transaction status
    // 3. Handle success/failure

    // For now, simulate successful payment
    payment.status = PaymentStatus.COMPLETED;
    payment.transactionId = transactionId;
    payment.gatewayResponse = JSON.stringify({
      status: 'succeeded',
      transactionId,
      timestamp: new Date().toISOString(),
    });

    await this.paymentRepository.save(payment);

    // Update order status: PENDING -> CONFIRMED -> PREPARING
    if (payment.order.status === OrderStatus.PENDING) {
      // First change to CONFIRMED after payment
      payment.order.status = OrderStatus.CONFIRMED;
      await this.orderRepository.save(payment.order);
    } else if (payment.order.status === OrderStatus.CONFIRMED) {
      // If already confirmed, change to PREPARING
      payment.order.status = OrderStatus.PREPARING;
      await this.orderRepository.save(payment.order);
    }

    return {
      id: payment.id,
      orderId: payment.orderId,
      method: payment.method,
      amount: parseFloat(payment.amount.toString()),
      status: payment.status,
      transactionId: payment.transactionId,
      message: 'Payment confirmed successfully',
    };
  }

  /**
   * Get payment details
   */
  async getPayment(paymentId: string, userId: string) {
    const payment = await this.paymentRepository.findOne({
      where: { id: paymentId },
      relations: ['order'],
    });

    if (!payment) {
      throw new NotFoundException('Payment not found');
    }

    // Verify order belongs to user
    if (payment.order.userId !== userId) {
      throw new ForbiddenException('Payment does not belong to user');
    }

    return {
      id: payment.id,
      orderId: payment.orderId,
      method: payment.method,
      amount: parseFloat(payment.amount.toString()),
      status: payment.status,
      transactionId: payment.transactionId,
      gatewayResponse: payment.gatewayResponse
        ? JSON.parse(payment.gatewayResponse)
        : null,
      failureReason: payment.failureReason,
      createdAt: payment.createdAt,
      updatedAt: payment.updatedAt,
    };
  }

  /**
   * Get payments for an order
   */
  async getOrderPayments(orderId: string, userId: string) {
    // Verify order belongs to user
    const order = await this.orderRepository.findOne({
      where: { id: orderId },
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    if (order.userId !== userId) {
      throw new ForbiddenException('Order does not belong to user');
    }

    const payments = await this.paymentRepository.find({
      where: { orderId },
      order: { createdAt: 'DESC' },
    });

    return payments.map((payment) => ({
      id: payment.id,
      method: payment.method,
      amount: parseFloat(payment.amount.toString()),
      status: payment.status,
      transactionId: payment.transactionId,
      createdAt: payment.createdAt,
    }));
  }
}
