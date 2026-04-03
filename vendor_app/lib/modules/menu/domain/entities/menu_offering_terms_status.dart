/// حالة قبول الشروط العامة لعرض الوجبات — يتوافق مع GET /vendors/menu-offering-terms/status.
class MenuOfferingTermsStatus {
  const MenuOfferingTermsStatus({
    required this.requiredVersion,
    required this.isCurrent,
    this.acceptedAt,
    this.acceptedVersion,
  });

  final String requiredVersion;
  final DateTime? acceptedAt;
  final String? acceptedVersion;
  /// true عندما وُقِّع آخر إصدار مطلوب من الخادم
  final bool isCurrent;

  factory MenuOfferingTermsStatus.fromJson(Map<String, dynamic> json) {
    DateTime? at;
    final rawAt = json['acceptedAt'];
    if (rawAt != null) {
      at = DateTime.tryParse(rawAt.toString());
    }
    return MenuOfferingTermsStatus(
      requiredVersion: json['requiredVersion'] as String? ?? '',
      isCurrent: json['isCurrent'] as bool? ?? false,
      acceptedAt: at,
      acceptedVersion: json['acceptedVersion'] as String?,
    );
  }
}
