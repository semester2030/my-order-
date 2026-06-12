/**
 * مفاتيح تشغيل المنصة — غيّرها عند تفعيل متطلبات لاحقاً.
 */
export const PlatformFeatures = {
  /** يطلب آيبان قبل عرض السعر على طلبات الخدمة المدفوعة. */
  requireVendorIbanForQuotes: false,

  /** يطلب آيبان قبل بدء جلسة الدفع بالبطاقة. */
  requireVendorIbanForCardPayment: false,

  /** يطلب آيبان عند إنشاء طلب تحويل مستحقات للمزوّد. */
  requireVendorIbanForPayout: false,
} as const;
