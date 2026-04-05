/// نتيجة طلب رمز التحقق للبريد (مقدّم خدمة).
class VendorEmailOtpRequestOutcome {
  const VendorEmailOtpRequestOutcome({
    required this.sent,
    required this.message,
    this.code,
  });

  final bool sent;
  final String message;
  final String? code;
}
