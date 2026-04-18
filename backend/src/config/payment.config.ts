import { registerAs } from '@nestjs/config';

export interface PaymentConfig {
  nodeEnv: string;
  /**
   * مزوّد الدفع: `mock` للتجارب.
   * لأي قيمة أخرى يُحمَّل NotImplementedPaymentGateway — نفّذ PaymentGatewayPort وسجّله في payments.module.ts.
   */
  provider: string;
  webhook: {
    /** سر مشترك لتوقيع webhook (HMAC). في الإنتاج يجب ضبطه وعدم قبول webhook بدون توقيع صالح */
    secret: string;
  };
  /**
   * في التطوير فقط: السماح بـ POST /payments/confirm بعد تحقق وهمي من السيرفر (لا يُعتمد على transactionId من العميل).
   * في production يُرفض دائماً حتى لو true في .env
   */
  devAllowClientConfirmMock: boolean;
  /**
   * في التطوير: قبول POST /payments/webhook بدون توقيع إذا كان السر غير مضبوط (يجب تفعيله صراحة).
   * في production دائماً false
   */
  devAllowUnsignedWebhook: boolean;
  applePay: { merchantId?: string };
  mada: { apiKey?: string; apiUrl?: string };
  stcPay: { apiKey?: string; apiUrl?: string };
}

function parseBool(v: string | undefined, defaultFalse = false): boolean {
  if (v == null || v === '') return defaultFalse;
  return ['1', 'true', 'yes', 'on'].includes(String(v).trim().toLowerCase());
}

export default registerAs(
  'payment',
  (): PaymentConfig => ({
    nodeEnv: process.env.NODE_ENV ?? 'development',
    provider: (process.env.PAYMENT_PROVIDER ?? 'mock').trim().toLowerCase(),
    webhook: {
      secret: (process.env.PAYMENT_WEBHOOK_SECRET ?? '').trim(),
    },
    devAllowClientConfirmMock: parseBool(
      process.env.PAYMENT_DEV_ALLOW_CLIENT_CONFIRM_MOCK,
    ),
    devAllowUnsignedWebhook: parseBool(
      process.env.PAYMENT_DEV_ALLOW_UNSIGNED_WEBHOOK,
    ),
    applePay: {
      merchantId: process.env.APPLE_PAY_MERCHANT_ID,
    },
    mada: {
      apiKey: process.env.MADA_API_KEY,
      apiUrl: process.env.MADA_API_URL,
    },
    stcPay: {
      apiKey: process.env.STC_PAY_API_KEY,
      apiUrl: process.env.STC_PAY_API_URL,
    },
  }),
);
