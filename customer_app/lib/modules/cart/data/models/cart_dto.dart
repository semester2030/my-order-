import 'package:json_annotation/json_annotation.dart';
import 'cart_item_dto.dart';

part 'cart_dto.g.dart';

@JsonSerializable()
class VendorDto {
  final String id;
  final String name;
  final String? logo;

  VendorDto({
    required this.id,
    required this.name,
    this.logo,
  });

  factory VendorDto.fromJson(Map<String, dynamic> json) =>
      _$VendorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VendorDtoToJson(this);
}

@JsonSerializable()
class CartDto {
  final String id;
  final VendorDto? vendor;
  final List<CartItemDto> items;
  @JsonKey(fromJson: _doubleFromJson)
  final double subtotal;
  @JsonKey(fromJson: _doubleFromJson)
  final double deliveryFee;
  @JsonKey(fromJson: _doubleFromJson)
  final double total;

  CartDto({
    required this.id,
    this.vendor,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  factory CartDto.fromJson(Map<String, dynamic> json) =>
      _$CartDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CartDtoToJson(this);

  static double _doubleFromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }
}
