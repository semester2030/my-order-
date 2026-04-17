import 'package:equatable/equatable.dart';

class Vendor extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? logo;
  final String? cover;
  final double rating;
  final int ratingCount;
  final String type;
  final String address;
  final String phoneNumber;
  final bool isActive;
  final bool isAcceptingOrders;
  final String? providerCategory;
  final List<PopularCookingAddOn>? popularCookingAddOns;

  const Vendor({
    required this.id,
    required this.name,
    this.description,
    this.logo,
    this.cover,
    required this.rating,
    required this.ratingCount,
    required this.type,
    required this.address,
    required this.phoneNumber,
    required this.isActive,
    required this.isAcceptingOrders,
    this.providerCategory,
    this.popularCookingAddOns,
  });

  /// طبخ الذبائح عند العميل
  bool get isPopularCooking =>
      providerCategory != null && providerCategory == 'popular_cooking';

  /// شواء خارجي عند العميل
  bool get isGrilling =>
      providerCategory != null && providerCategory == 'grilling';

  /// طبخ منزلي (عرض أطباق + حجز خدمة)
  bool get isHomeCooking =>
      providerCategory != null && providerCategory == 'home_cooking';

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        logo,
        cover,
        rating,
        ratingCount,
        type,
        address,
        phoneNumber,
        isActive,
        isAcceptingOrders,
        providerCategory,
        popularCookingAddOns,
      ];
}

/// طلب جانبي لطبخ الذبائح (جريش، قرصان، إدامات...)
class PopularCookingAddOn extends Equatable {
  final String name;
  final double price;

  const PopularCookingAddOn({required this.name, required this.price});

  @override
  List<Object?> get props => [name, price];
}
