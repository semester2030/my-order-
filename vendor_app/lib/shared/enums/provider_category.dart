/// فئة مقدم الخدمة — Phase 12 (لإظهار الطلبات الجانبية لمقدمي طبخ الذبائح فقط).
enum ProviderCategory {
  homeCooking('home_cooking', 'طبخ منزلي'),
  popularCooking('popular_cooking', 'طبخ الذبائح'),
  privateEvents('private_events', 'المناسبات والحفلات'),
  grilling('grilling', 'الشواء الخارجي');

  const ProviderCategory(this.value, this.labelAr);

  final String value;
  final String labelAr;

  static ProviderCategory? fromString(String? v) {
    if (v == null || v.isEmpty) return null;
    for (final e in ProviderCategory.values) {
      if (e.value == v) return e;
    }
    return null;
  }

  bool get isPopularCooking => this == ProviderCategory.popularCooking;
}
