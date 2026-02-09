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

  /// طبخ شعبي (ذبايح) عند العميل
  bool get isPopularCooking =>
      providerCategory != null && providerCategory == 'popular_cooking';

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

/// طلب جانبي للطبخ الشعبي (جريش، قرصان، ادامات...)
class PopularCookingAddOn extends Equatable {
  final String name;
  final double price;

  const PopularCookingAddOn({required this.name, required this.price});

  @override
  List<Object?> get props => [name, price];
}
