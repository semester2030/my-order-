import 'package:json_annotation/json_annotation.dart';

part 'vendor_dto.g.dart';

class PopularCookingAddOnDto {
  final String name;
  final double price;

  const PopularCookingAddOnDto({required this.name, required this.price});
}

@JsonSerializable()
class VendorDto {
  @JsonKey(fromJson: _stringFromJson)
  final String id;
  @JsonKey(fromJson: _stringFromJson)
  final String name;
  final String? description;
  final String? logo;
  final String? cover;
  @JsonKey(name: 'rating', fromJson: _doubleFromJson)
  final double rating;
  @JsonKey(name: 'rating_count', fromJson: _intFromJson)
  final int ratingCount;
  @JsonKey(fromJson: _stringFromJson)
  final String type;
  @JsonKey(fromJson: _stringFromJson)
  final String address;
  @JsonKey(name: 'phone_number', fromJson: _stringFromJson)
  final String phoneNumber;
  @JsonKey(name: 'is_active', fromJson: _boolFromJson)
  final bool isActive;
  @JsonKey(name: 'is_accepting_orders', fromJson: _boolFromJson)
  final bool isAcceptingOrders;
  @JsonKey(name: 'provider_category')
  final String? providerCategory;
  @JsonKey(name: 'popular_cooking_add_ons', fromJson: _popularCookingAddOnsFromJson)
  final List<PopularCookingAddOnDto>? popularCookingAddOns;

  VendorDto({
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

  factory VendorDto.fromJson(Map<String, dynamic> json) =>
      _$VendorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VendorDtoToJson(this);

  static double _doubleFromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }

  static int _intFromJson(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.parse(value);
    return 0;
  }

  static bool _boolFromJson(dynamic value) {
    if (value is bool) return value;
    if (value == null) return false;
    if (value is int) return value != 0;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  static String _stringFromJson(dynamic value) {
    if (value is String) return value;
    if (value == null) return '';
    return value.toString();
  }

  static List<PopularCookingAddOnDto>? _popularCookingAddOnsFromJson(dynamic value) {
    if (value == null) return null;
    if (value is! List) return null;
    final list = <PopularCookingAddOnDto>[];
    for (final e in value) {
      final map = e is Map ? Map<String, dynamic>.from(e) : null;
      if (map == null) continue;
      list.add(
        PopularCookingAddOnDto(
          name: _stringFromJson(map['name']),
          price: _doubleFromJson(map['price']),
        ),
      );
    }
    return list.isEmpty ? null : list;
  }
}
