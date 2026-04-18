/**
 * عقد موحّد لتحويل المستحقات لمقدّمي الخدمة — يُستبدل التنفيذ فقط عند التعاقد مع PSP.
 */

export const PAYOUT_GATEWAY = Symbol('PAYOUT_GATEWAY');

export interface PayoutGatewaySubmitInput {
  idempotencyKey: string;
  amount: number;
  currency: string;
  beneficiary: {
    /** معرّف الحساب المرتبط عند المزوّد بعد إتمام onboarding */
    externalAccountId?: string | null;
    /** تلميح آمن للسجلات (مثلاً آخر 4 من الآيبان) */
    ibanHint?: string | null;
  };
  metadata?: Record<string, string>;
}

export interface PayoutGatewaySubmitResult {
  ok: boolean;
  providerPayoutId?: string;
  refusalReason?: string;
  raw?: Record<string, unknown>;
}

export interface PayoutGatewayPort {
  submitPayout(input: PayoutGatewaySubmitInput): Promise<PayoutGatewaySubmitResult>;
}
