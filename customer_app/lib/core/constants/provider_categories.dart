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

  static String label(String value) {
    switch (value) {
      case homeCooking:
        return 'الطبخ المنزلي';
      case popularCooking:
        return 'الطبخ الشعبي';
      case privateEvents:
        return 'المناسبات الخاصة';
      case grilling:
        return 'الشوي';
      default:
        return value;
    }
  }
}
