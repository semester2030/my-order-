import '../constants/provider_categories.dart';

/// صور بطاقات «اختر الخدمة» — صورة احترافية لكل فئة.
abstract final class CategoryCoverAssets {
  static const String _base = 'assets/images/categories';

  static String pathFor(String category) {
    switch (category) {
      case ProviderCategories.homeCooking:
        return '$_base/home_cooking.png';
      case ProviderCategories.popularCooking:
        return '$_base/popular_cooking.png';
      case ProviderCategories.privateEvents:
        return '$_base/private_events.png';
      case ProviderCategories.grilling:
        return '$_base/grilling.png';
      default:
        return '$_base/home_cooking.png';
    }
  }
}
