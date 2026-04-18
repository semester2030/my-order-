/// Provider (service) categories for the four entry icons.
/// Single source of truth — do not duplicate elsewhere.
class ProviderCategories {
  ProviderCategories._();

  static const String homeCooking = 'home_cooking';
  static const String popularCooking = 'popular_cooking';
  static const String privateEvents = 'private_events';
  static const String grilling = 'grilling';

  static const List<String> all = [
    homeCooking,
    popularCooking,
    privateEvents,
    grilling,
  ];

  /// فيديو الاكتشاف: فئات تعرض البرومو (زر عريض أسفل + اختصار حجز جانبي) وليست «سلة منتجات».
  static bool usesFeedPromoVideoLayout(String? category) {
    if (category == null || category.isEmpty) return false;
    return category == homeCooking ||
        category == popularCooking ||
        category == grilling ||
        category == privateEvents;
  }

  static String label(String value) {
    switch (value) {
      case homeCooking:
        return 'الطبخ المنزلي';
      case popularCooking:
        return 'طبخ الذبائح';
      case privateEvents:
        return 'المناسبات والحفلات';
      case grilling:
        return 'الشواء الخارجي';
      default:
        return value;
    }
  }
}
