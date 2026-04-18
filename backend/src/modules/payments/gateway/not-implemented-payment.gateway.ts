import { Injectable } from '@nestjs/common';
import type {
  PaymentGatewayPort,
  PaymentGatewayCheckoutSession,
  PaymentGatewayVerifyInput,
  PaymentGatewayVerifyResult,
} from './payment-gateway.port';

/**
 * يُستخدم عند ضبط PAYMENT_PROVIDER لقيمة غير mock قبل تنفيذ محوّل PSP حقيقي.
 * يحافظ على تشغيل التطبيق (التحميل) ويُفشل بوضوح عند استدعاء الدفع.
 */
@Injectable()
export class NotImplementedPaymentGateway implements PaymentGatewayPort {
  constructor(private readonly provider: string) {}

  async createCheckoutSession(_input: {
    paymentId: string;
    amount: number;
    currency: string;
    metadata?: Record<string, string>;
  }): Promise<PaymentGatewayCheckoutSession> {
    throw new Error(
      `Payment PSP adapter not registered for provider "${this.provider}". ` +
        `Add a class implementing PaymentGatewayPort and register it in payments.module.ts.`,
    );
  }

  async verifyPayment(
    _input: PaymentGatewayVerifyInput,
  ): Promise<PaymentGatewayVerifyResult> {
    return {
      ok: false,
      refusalReason: `psp_not_implemented:${this.provider}`,
      raw: { provider: this.provider },
    };
  }
}
