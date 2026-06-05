/// مفاتيح تشغيل المنتج — غيّرها عند تفعيل ميزة (مثل الدفع الإلكتروني).
abstract final class AppFeatures {
  /// `false` حتى ربط مدى/Apple Pay/STC Pay — يُظهر رسالة «الدفع قريباً» بدل أزرار الدفع.
  static const bool electronicPaymentEnabled = false;
}
