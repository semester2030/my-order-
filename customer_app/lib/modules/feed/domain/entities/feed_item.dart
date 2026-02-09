import 'package:equatable/equatable.dart';
import 'video_asset.dart';

class Vendor extends Equatable {
  final String id;
  final String name;
  final String? logo;
  final double rating;
  final int ratingCount;
  final String type;
  /// إن كانت الطباخة تقبل "خدمات عند الطلب" (اطلبي طباخة).
  final bool acceptsCustomRequests;
  /// فئة الخدمة: home_cooking | popular_cooking | ...
  final String? providerCategory;

  const Vendor({
    required this.id,
    required this.name,
    this.logo,
    required this.rating,
    required this.ratingCount,
    required this.type,
    this.acceptsCustomRequests = true,
    this.providerCategory,
  });

  bool get isPopularCooking =>
      providerCategory != null && providerCategory == 'popular_cooking';

  @override
  List<Object?> get props => [id, name, logo, rating, ratingCount, type, acceptsCustomRequests, providerCategory];
}

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? image;
  final bool isSignature;

  const MenuItem({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.image,
    required this.isSignature,
  });

  @override
  List<Object?> get props => [id, name, description, price, image, isSignature];
}

class FeedItem extends Equatable {
  final String id;
  final MenuItem menuItem;
  final Vendor vendor;
  final VideoAsset? video;
  final double? distance; // in kilometers

  const FeedItem({
    required this.id,
    required this.menuItem,
    required this.vendor,
    this.video,
    this.distance,
  });

  @override
  List<Object?> get props => [id, menuItem, vendor, video, distance];
}
