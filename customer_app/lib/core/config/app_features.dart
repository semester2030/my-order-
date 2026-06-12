/// مفاتيح تشغيل المنتج — غيّرها عند تفعيل ميزة (مثل الدفع الإلكتروني).
abstract final class AppFeatures {
  /// `false` = الدفع الإلكتروني متوقف مؤقتاً؛ يُستخدم تحويل STC Bank برقم الجوال.
  static const bool electronicPaymentEnabled = false;

  /// تحويل يدوي عبر STC Bank برقم الجوال (فعّال عندما [electronicPaymentEnabled] = false).
  static bool get useStcBankMobileTransfer => !electronicPaymentEnabled;
}
