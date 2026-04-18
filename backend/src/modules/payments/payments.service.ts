import { randomUUID } from 'crypto';
import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
  ConflictException,
  InternalServerErrorException,
  Inject,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { EntityManager, In, QueryFailedError, Repository } from 'typeorm';
import { Payment, PaymentStatus } from './entities/payment.entity';
import { Order, OrderStatus } from '../orders/entities/order.entity';
import {
  EventRequest,
  EventRequestStatus,
  EventRequestType,
} from '../event-requests/entities/event-request.entity';
import type { PaymentConfig } from '../../config/payment.config';
import { InitiatePaymentDto } from './dto/initiate-payment.dto';
import { InitiateHomeCookingCardPaymentDto } from './dto/initiate-home-cooking-card-payment.dto';
import { ConfirmPaymentDto } from './dto/confirm-payment.dto';
import { PaymentWebhookDto } from './dto/payment-webhook.dto';
import {
  PAYMENT_GATEWAY,
  type PaymentGatewayPort,
  type PaymentGatewayVerifyResult,
} from './gateway/payment-gateway.port';
import { verifyWebhookSignature } from './utils/payment-webhook-signature';

const PG_UNIQUE_VIOLATION = '23505';
const PAYMENT_CURRENCY = 'SAR';

function isPostgresUniqueViolation(err: unknown): boolean {
  return (
    err instanceof QueryFailedError &&
    (err as QueryFailedError & { driverError?: { code?: string } })
      .driverError?.code === PG_UNIQUE_VIOLATION
  );
}

@Injectable()
export class PaymentsService {
  constructor(
    @InjectRepository(Payment)
    private readonly paymentRepository: Repository<Payment>,
    @InjectRepository(Order)
    private readonly orderRepository: Repository<Order>,
    @InjectRepository(EventRequest)
    private readonly eventRequestRepository: Repository<EventRequest>,
    private readonly configService: ConfigService,
    @Inject(PAYMENT_GATEWAY)
    private readonly paymentGateway: PaymentGatewayPort,
  ) {}

  private paymentConfig(): PaymentConfig {
    const cfg = this.configService.get<PaymentConfig>('payment');
    if (!cfg) {
      throw new InternalServerErrorException('payment configuration is not loaded');
    }
    return cfg;
  }

  private parseStoredPaymentIntentId(payment: Payment): string | null {
    const raw = payment.gatewayResponse?.trim();
    if (!raw) {
      return null;
    }
    try {
      const o = JSON.parse(raw) as { paymentIntentId?: unknown };
      return typeof o.paymentIntentId === 'string' ? o.paymentIntentId : null;
    } catch {
      return null;
    }
  }

  private assertWebhookSignature(
    cfg: PaymentConfig,
    headerSig: string | undefined,
    dto: PaymentWebhookDto,
  ): void {
    const secret = cfg.webhook.secret;
    const isProd = cfg.nodeEnv === 'production';

    if (isProd && secret.length < 8) {
      throw new ForbiddenException(
        'Webhook غير مهيأ: PAYMENT_WEBHOOK_SECRET مطلوب في الإنتاج',
      );
    }

    if (secret.length >= 8) {
      if (!verifyWebhookSignature(secret, headerSig, dto)) {
        throw new ForbiddenException('توقيع webhook غير صالح');
      }
      return;
    }

    if (isProd) {
      throw new ForbiddenException('تكوين webhook غير صالح للإنتاج');
    }

    if (!cfg.devAllowUnsignedWebhook) {
      throw new ForbiddenException(
        'webhook بدون توقيع مرفوض: عيّن PAYMENT_WEBHOOK_SECRET (8 أحرف على الأقل) أو PAYMENT_DEV_ALLOW_UNSIGNED_WEBHOOK=true في التطوير',
      );
    }
  }

  /**
   * تحقق عبر المزوّد (نفس منطق webhook من حيث المطابقة مع الجلسة المخزّنة).
   * لا يُكمّل الدفع — للاختبار أو تكامل داخلي لاحق.
   */
  async verifyPaymentWithGateway(
    paymentId: string,
    claimedPaymentIntentId: string,
  ): Promise<PaymentGatewayVerifyResult> {
    const payment = await this.paymentRepository.findOne({
      where: { id: paymentId },
    });
    if (!payment) {
      throw new NotFoundException('Payment not found');
    }
    return this.paymentGateway.verifyPayment({
      paymentId: payment.id,
      amount: Number(payment.amount),
      currency: PAYMENT_CURRENCY,
      storedPaymentIntentId: this.parseStoredPaymentIntentId(payment),
      claimedPaymentIntentId,
    });
  }

  async assertNoBlockingHomeCookingCardPayment(
    eventRequestId: string,
  ): Promise<void> {
    const blocked = await this.paymentRepository.exists({
      where: {
        eventRequestId,
        status: In([PaymentStatus.PENDING, PaymentStatus.PROCESSING]),
      },
    });
    if (blocked) {
      throw new ConflictException(
        'يوجد دفع بالبطاقة قيد المعالجة لهذا الطلب. انتظر اكتماله أو انتهاء صلاحيته قبل إعلان التحويل البنكي.',
      );
    }
  }

  async handlePaymentWebhook(
    headerSig: string | undefined,
    dto: PaymentWebhookDto,
  ) {
    const cfg = this.paymentConfig();
    this.assertWebhookSignature(cfg, headerSig, dto);

    return this.paymentRepository.manager.transaction(async (em) => {
      const payRepo = em.getRepository(Payment);
      const payment = await payRepo.findOne({
        where: { id: dto.paymentId },
        relations: ['order', 'eventRequest'],
      });

      if (!payment) {
        throw new NotFoundException('Payment not found');
      }

      if (payment.status === PaymentStatus.COMPLETED) {
        return { ok: true as const, duplicate: true as const };
      }

      if (payment.status === PaymentStatus.FAILED) {
        throw new BadRequestException('Payment has failed');
      }

      const verify = await this.paymentGateway.verifyPayment({
        paymentId: payment.id,
        amount: Number(payment.amount),
        currency: PAYMENT_CURRENCY,
        storedPaymentIntentId: this.parseStoredPaymentIntentId(payment),
        claimedPaymentIntentId: dto.paymentIntentId,
      });

      if (!verify.ok || !verify.transactionId) {
        throw new BadRequestException(
          verify.refusalReason ?? 'gateway_verify_failed',
        );
      }

      const body = await this.applyVerifiedCompletion(
        em,
        payment,
        verify.transactionId,
        verify.raw,
      );
      return { ok: true as const, duplicate: false as const, ...body };
    });
  }

  /**
   * إكمال دفع معلّق للاختبار التجريبي — غير الإنتاج فقط.
   * في الإنتاج: الإكمال عبر webhook شركة الدفع فقط.
   */
  async adminSimulateCompletePayment(paymentId: string) {
    const cfg = this.paymentConfig();
    if (cfg.nodeEnv === 'production') {
      throw new ForbiddenException(
        'إكمال الدفع التجريبي غير متاح في الإنتاج — الإكمال عبر webhook شركة الدفع فقط.',
      );
    }

    return this.paymentRepository.manager.transaction(async (em) => {
      const payRepo = em.getRepository(Payment);
      const payment = await payRepo.findOne({
        where: { id: paymentId },
        relations: ['order', 'eventRequest'],
      });

      if (!payment) {
        throw new NotFoundException('Payment not found');
      }

      if (payment.status === PaymentStatus.COMPLETED) {
        return {
          ok: true as const,
          duplicate: true as const,
          id: payment.id,
          orderId: payment.orderId,
          eventRequestId: payment.eventRequestId,
          method: payment.method,
          amount: parseFloat(String(payment.amount)),
          status: payment.status,
          transactionId: payment.transactionId,
          message: 'Payment already completed',
        };
      }

      if (payment.status === PaymentStatus.FAILED) {
        throw new BadRequestException('Payment has failed');
      }

      const txId = `dev_admin_${randomUUID()}`;
      const body = await this.applyVerifiedCompletion(em, payment, txId, {
        path: 'admin_simulate_complete',
        paymentProvider: cfg.provider,
      });
      return { ok: true as const, duplicate: false as const, ...body };
    });
  }

  private async persistGatewaySession(
    payment: Payment,
  ): Promise<Payment> {
    const session = await this.paymentGateway.createCheckoutSession({
      paymentId: payment.id,
      amount: Number(payment.amount),
      currency: PAYMENT_CURRENCY,
      metadata: payment.orderId
        ? { orderId: payment.orderId }
        : payment.eventRequestId
          ? { eventRequestId: payment.eventRequestId }
          : {},
    });

    payment.gatewayResponse = JSON.stringify({
      ...(session.raw ?? {}),
      paymentIntentId: session.paymentIntentId,
      clientSecret: session.clientSecret,
    });
    return this.paymentRepository.save(payment);
  }

  async initiatePayment(userId: string, dto: InitiatePaymentDto) {
    const { orderId, method } = dto;

    const order = await this.orderRepository.findOne({
      where: { id: orderId },
      relations: ['payments'],
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    if (order.userId !== userId) {
      throw new ForbiddenException('Order does not belong to user');
    }

    if (
      order.status !== OrderStatus.PENDING &&
      order.status !== OrderStatus.CONFIRMED
    ) {
      throw new BadRequestException(
        `Cannot initiate payment for order with status: ${order.status}`,
      );
    }

    const existingPayment = order.payments?.find(
      (p) => p.status === PaymentStatus.COMPLETED,
    );

    if (existingPayment) {
      throw new BadRequestException('Order already has a completed payment');
    }

    const pendingPayment = order.payments?.find(
      (p) => p.status === PaymentStatus.PENDING,
    );

    if (pendingPayment) {
      throw new BadRequestException('Payment already initiated for this order');
    }

    const payment = this.paymentRepository.create({
      orderId: order.id,
      eventRequestId: null,
      method,
      amount: order.total,
      status: PaymentStatus.PENDING,
    });

    const savedPayment = await this.paymentRepository.save(payment);
    let withSession: Payment;
    try {
      withSession = await this.persistGatewaySession(savedPayment);
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : String(e);
      throw new BadRequestException(`تعذّر بدء جلسة الدفع: ${msg}`);
    }

    if (order.status === OrderStatus.PENDING) {
      order.status = OrderStatus.CONFIRMED;
      await this.orderRepository.save(order);
    }

    return {
      id: withSession.id,
      orderId: withSession.orderId,
      eventRequestId: withSession.eventRequestId,
      method: withSession.method,
      amount: parseFloat(String(withSession.amount)),
      status: withSession.status,
      paymentIntent: this.parseStoredPaymentIntentId(withSession),
      clientSecret: (() => {
        try {
          const o = JSON.parse(withSession.gatewayResponse ?? '{}') as {
            clientSecret?: string;
          };
          return typeof o.clientSecret === 'string'
            ? o.clientSecret
            : undefined;
        } catch {
          return undefined;
        }
      })(),
      message:
        'Payment initiated. Complete via PSP; server finalizes on webhook (or dev confirm if enabled).',
    };
  }

  async initiateHomeCookingCardPayment(
    userId: string,
    dto: InitiateHomeCookingCardPaymentDto,
  ) {
    const { eventRequestId, method } = dto;

    const row = await this.eventRequestRepository.findOne({
      where: { id: eventRequestId, userId },
    });

    if (!row) {
      throw new NotFoundException('الطلب غير موجود');
    }
    if (row.requestType !== EventRequestType.HOME_COOKING) {
      throw new BadRequestException('هذا الدفع للطبخ المنزلي فقط');
    }
    if (row.status === EventRequestStatus.PAYMENT_PENDING) {
      throw new ConflictException(
        'الطلب بانتظار تحقق التحويل البنكي؛ لا يمكن بدء دفع بالبطاقة الآن',
      );
    }
    if (row.status !== EventRequestStatus.QUOTED) {
      throw new ConflictException(
        'يمكن بدء الدفع بالبطاقة بعد استلام عرض السعر فقط',
      );
    }
    if (row.quotedAmount == null) {
      throw new BadRequestException('لا يوجد سعر معروض');
    }

    const amount = Number.parseFloat(String(row.quotedAmount));
    if (!Number.isFinite(amount) || amount < 0.01) {
      throw new BadRequestException('المبلغ المعروض غير صالح');
    }

    const completed = await this.paymentRepository.exists({
      where: { eventRequestId: row.id, status: PaymentStatus.COMPLETED },
    });
    if (completed) {
      throw new BadRequestException('تم تسجيل دفع مكتمل لهذا الطلب مسبقاً');
    }

    const pending = await this.paymentRepository.exists({
      where: {
        eventRequestId: row.id,
        status: In([PaymentStatus.PENDING, PaymentStatus.PROCESSING]),
      },
    });
    if (pending) {
      throw new BadRequestException('يوجد دفع بالبطاقة قيد الانتظار لهذا الطلب');
    }

    const payment = this.paymentRepository.create({
      orderId: null,
      eventRequestId: row.id,
      method,
      amount,
      status: PaymentStatus.PENDING,
    });

    let savedPayment: Payment;
    try {
      savedPayment = await this.paymentRepository.save(payment);
    } catch (e) {
      if (isPostgresUniqueViolation(e)) {
        throw new ConflictException(
          'يوجد دفع بالبطاقة قيد الانتظار لهذا الطلب (تعارض متزامن)',
        );
      }
      throw e;
    }

    let withSession: Payment;
    try {
      withSession = await this.persistGatewaySession(savedPayment);
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : String(e);
      throw new BadRequestException(`تعذّر بدء جلسة الدفع: ${msg}`);
    }

    return {
      id: withSession.id,
      orderId: withSession.orderId,
      eventRequestId: withSession.eventRequestId,
      method: withSession.method,
      amount: parseFloat(String(withSession.amount)),
      status: withSession.status,
      paymentIntent: this.parseStoredPaymentIntentId(withSession),
      clientSecret: (() => {
        try {
          const o = JSON.parse(withSession.gatewayResponse ?? '{}') as {
            clientSecret?: string;
          };
          return typeof o.clientSecret === 'string'
            ? o.clientSecret
            : undefined;
        } catch {
          return undefined;
        }
      })(),
      message:
        'Payment initiated for home cooking. Finalize via PSP webhook (or dev confirm if enabled).',
    };
  }

  /**
   * لا يُعتمد على transactionId من العميل.
   * الإنتاج: مرفوض — الإكمال عبر webhook فقط.
   * التطوير: إذا PAYMENT_DEV_ALLOW_CLIENT_CONFIRM_MOCK=true والمزوّد mock، يُكمّل بعد تحقق وهمي من السيرفر.
   */
  async confirmPayment(userId: string, dto: ConfirmPaymentDto) {
    const cfg = this.paymentConfig();
    const isProd = cfg.nodeEnv === 'production';
    const allowDevClientMock =
      !isProd &&
      cfg.devAllowClientConfirmMock === true &&
      cfg.provider === 'mock';

    if (!allowDevClientMock) {
      throw new ForbiddenException(
        'PAYMENT_CONFIRM_DISABLED: لا يُقبل إكمال الدفع من التطبيق؛ الإكمال عبر webhook المزوّد بعد تحقق السيرفر فقط.',
      );
    }

    return this.paymentRepository.manager.transaction(async (em) => {
      const payRepo = em.getRepository(Payment);
      const payment = await payRepo.findOne({
        where: { id: dto.paymentId },
        relations: ['order', 'eventRequest'],
      });

      if (!payment) {
        throw new NotFoundException('Payment not found');
      }

      const ownerId =
        payment.order?.userId ?? payment.eventRequest?.userId ?? null;
      if (ownerId !== userId) {
        throw new ForbiddenException('Payment does not belong to user');
      }

      if (payment.status === PaymentStatus.COMPLETED) {
        throw new BadRequestException('Payment already completed');
      }

      if (payment.status === PaymentStatus.FAILED) {
        throw new BadRequestException(
          'Payment has failed and cannot be confirmed',
        );
      }

      const verify = await this.paymentGateway.verifyPayment({
        paymentId: payment.id,
        amount: Number(payment.amount),
        currency: PAYMENT_CURRENCY,
        storedPaymentIntentId: this.parseStoredPaymentIntentId(payment),
        devClientMockComplete: true,
      });

      if (!verify.ok || !verify.transactionId) {
        throw new BadRequestException(
          verify.refusalReason ?? 'gateway_verify_failed',
        );
      }

      return this.applyVerifiedCompletion(
        em,
        payment,
        verify.transactionId,
        verify.raw,
      );
    });
  }

  private async applyVerifiedCompletion(
    em: EntityManager,
    payment: Payment,
    serverTransactionId: string,
    verificationMeta: Record<string, unknown> | undefined,
  ) {
    const payRepo = em.getRepository(Payment);

    let prev: Record<string, unknown> = {};
    if (payment.gatewayResponse?.trim()) {
      try {
        prev = JSON.parse(payment.gatewayResponse) as Record<string, unknown>;
      } catch {
        prev = {};
      }
    }

    payment.status = PaymentStatus.COMPLETED;
    payment.transactionId = serverTransactionId;
    payment.gatewayResponse = JSON.stringify({
      ...prev,
      serverVerifiedAt: new Date().toISOString(),
      serverVerification: verificationMeta ?? {},
    });

    await payRepo.save(payment);

    if (payment.orderId && payment.order) {
      if (payment.order.status === OrderStatus.PENDING) {
        payment.order.status = OrderStatus.CONFIRMED;
        await em.getRepository(Order).save(payment.order);
      } else if (payment.order.status === OrderStatus.CONFIRMED) {
        payment.order.status = OrderStatus.PREPARING;
        await em.getRepository(Order).save(payment.order);
      }
    } else if (payment.eventRequestId && payment.eventRequest) {
      const er = payment.eventRequest;
      if (er.requestType !== EventRequestType.HOME_COOKING) {
        throw new BadRequestException('Invalid event request type for payment');
      }
      if (er.status !== EventRequestStatus.QUOTED) {
        throw new ConflictException(
          'لا يمكن تأكيد الدفع: حالة طلب الطبخ المنزلي غير مناسبة',
        );
      }
      er.status = EventRequestStatus.ACCEPTED;
      er.paymentVerifiedAt = new Date();
      er.paymentVerifiedByAdminId = null;
      if (!er.paymentReference?.trim()) {
        const ref = `card:${serverTransactionId}`;
        er.paymentReference = ref.length > 2000 ? ref.slice(0, 2000) : ref;
      }
      await em.getRepository(EventRequest).save(er);
    } else {
      throw new BadRequestException('Payment is not linked to order or event');
    }

    return {
      id: payment.id,
      orderId: payment.orderId,
      eventRequestId: payment.eventRequestId,
      method: payment.method,
      amount: parseFloat(String(payment.amount)),
      status: payment.status,
      transactionId: payment.transactionId,
      message: 'Payment confirmed successfully',
    };
  }

  async getPayment(paymentId: string, userId: string) {
    const payment = await this.paymentRepository.findOne({
      where: { id: paymentId },
      relations: ['order', 'eventRequest'],
    });

    if (!payment) {
      throw new NotFoundException('Payment not found');
    }

    const ownerId =
      payment.order?.userId ?? payment.eventRequest?.userId ?? null;
    if (ownerId !== userId) {
      throw new ForbiddenException('Payment does not belong to user');
    }

    return {
      id: payment.id,
      orderId: payment.orderId,
      eventRequestId: payment.eventRequestId,
      method: payment.method,
      amount: parseFloat(String(payment.amount)),
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

  async getOrderPayments(orderId: string, userId: string) {
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

    return payments.map((p) => ({
      id: p.id,
      method: p.method,
      amount: parseFloat(String(p.amount)),
      status: p.status,
      transactionId: p.transactionId,
      createdAt: p.createdAt,
    }));
  }
}
