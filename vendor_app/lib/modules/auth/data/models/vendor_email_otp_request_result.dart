/// استجابة POST /auth/vendor/onboarding/email/request-otp
class VendorEmailOtpRequestResult {
  const VendorEmailOtpRequestResult({
    required this.sent,
    required this.message,
    this.code,
  });

  final bool sent;
  final String message;
  /// يُعاد في بيئة التطوير أو عند OTP_FORCE_WHITELIST عندما لا يُرسل البريد.
  final String? code;

  factory VendorEmailOtpRequestResult.fromJson(Map<String, dynamic> json) {
    return VendorEmailOtpRequestResult(
      sent: json['sent'] as bool? ?? false,
      message: (json['message'] as String?)?.trim() ?? '',
      code: json['code'] as String?,
    );
  }
}
