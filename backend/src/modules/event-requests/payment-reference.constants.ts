/** مراجع ثابتة — بدون إثبات تحويل من العميل */
export const PAYMENT_REF_TRANSFER_DECLARED = 'تم التحويل';
export const PAYMENT_REF_CASH_SELECTED = 'cash';
export const PAYMENT_REF_CASH_PAID = 'تم الدفع';

export function isCashPaymentReference(ref: string | null | undefined): boolean {
  const r = ref?.trim().toLowerCase() ?? '';
  return r === 'cash' || r === PAYMENT_REF_CASH_PAID.toLowerCase();
}

export function isTransferDeclaredReference(
  ref: string | null | undefined,
): boolean {
  const r = ref?.trim() ?? '';
  return (
    r === PAYMENT_REF_TRANSFER_DECLARED ||
    r.toLowerCase() === 'stc_bank' ||
    r.toLowerCase() === 'stc'
  );
}
