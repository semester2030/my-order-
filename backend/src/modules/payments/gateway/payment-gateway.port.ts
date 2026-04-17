/**
 * عقد موحّد لمزوّد الدفع — استبدل التنفيذ فقط عند ربط PSP حقيقي.
 * لا يُعلَّم الدفع «مكتملاً» إلا بعد نجاح verifyPayment من السيرفر.
 */

export const PAYMENT_GATEWAY = Symbol('PAYMENT_GATEWAY');

export interface PaymentGatewayCheckoutSession {
  paymentIntentId: string;
  clientSecret: string;
  raw?: Record<string, unknown>;
}

export interface PaymentGatewayVerifyInput {
  paymentId: string;
  amount: number;
  currency: string;
  /** قيمة paymentIntentId المخزّنة عند initiate (من جلسة المزوّد) */
  storedPaymentIntentId: string | null;
  /**
   * ما أرسله الـ webhook من المزوّد (يُقارَن مع المخزّن).
   * لا يُستخدم من مسار العميل كدليل نجاح في الإنتاج.
   */
  claimedPaymentIntentId?: string;
  /**
   * مسار تطوير فقط: إكمال وهمي من السيرفر بعد Jwt + ملكية الدفع — لا يطابق intent من العميل.
   * يُضبط من PaymentsService حسب الإعدادات.
   */
  devClientMockComplete?: boolean;
}

export interface PaymentGatewayVerifyResult {
  ok: boolean;
  /** يُنشأ من السيرفر/المزوّد — لا يُؤخذ من طلب العميل */
  transactionId?: string;
  refusalReason?: string;
  raw?: Record<string, unknown>;
}

export interface PaymentGatewayPort {
  createCheckoutSession(input: {
    paymentId: string;
    amount: number;
    currency: string;
    metadata?: Record<string, string>;
  }): Promise<PaymentGatewayCheckoutSession>;

  verifyPayment(
    input: PaymentGatewayVerifyInput,
  ): Promise<PaymentGatewayVerifyResult>;
}
