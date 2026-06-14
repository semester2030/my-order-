/// مفاتيح تشغيل المنتج — غيّرها عند تفعيل ميزة (مثل الدفع الإلكتروني).
abstract final class AppFeatures {
  /// `false` = الدفع الإلكتروني متوقف مؤقتاً.
  static const bool electronicPaymentEnabled = false;

  /// دفع الخدمة (STC + كاش) — مفعّل.
  static const bool servicePaymentEnabled = true;

  /// تحويل STC Bank برقم الجوال — مفعّل.
  static const bool stcBankMobileTransferEnabled = true;

  /// إضافة بطاقة مدى — **متوقف مؤقتاً** (فعّله لاحقاً بـ `true`).
  static const bool madaPaymentEnabled = false;

  /// تحويل يدوي عبر STC Bank برقم الجوال.
  static bool get useStcBankMobileTransfer =>
      servicePaymentEnabled && stcBankMobileTransferEnabled;

  /// مرجع إعلان STC — بدون إثبات
  static const String paymentRefTransferDeclared = 'تم التحويل';

  /// `false` = يرسل paymentReference فقط (متوافق مع API على Render).
  static const bool declarePaymentMethodFieldEnabled = false;
}
