/// حالة إكمال التسجيل من GET /auth/vendor/onboarding/status
class VendorOnboardingStatus {
  const VendorOnboardingStatus({
    required this.emailVerified,
    required this.legalAccepted,
    required this.requiredLegalDocumentVersion,
    this.legalDocumentVersion,
  });

  final bool emailVerified;
  final bool legalAccepted;
  final String requiredLegalDocumentVersion;
  final String? legalDocumentVersion;

  factory VendorOnboardingStatus.fromJson(Map<String, dynamic> json) {
    return VendorOnboardingStatus(
      emailVerified: json['emailVerified'] as bool? ?? false,
      legalAccepted: json['legalAccepted'] as bool? ?? false,
      requiredLegalDocumentVersion:
          (json['requiredLegalDocumentVersion'] as String?)?.trim() ?? '',
      legalDocumentVersion: json['legalDocumentVersion'] as String?,
    );
  }
}
