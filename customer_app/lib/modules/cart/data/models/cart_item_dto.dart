import 'package:json_annotation/json_annotation.dart';

part 'cart_item_dto.g.dart';

@JsonSerializable()
class MenuItemDto {
  final String id;
  final String name;
  final String? image;
  @JsonKey(fromJson: _doubleFromJson)
  final double price;

  MenuItemDto({
    required this.id,
    required this.name,
    this.image,
    required this.price,
  });

  factory MenuItemDto.fromJson(Map<String, dynamic> json) =>
      _$MenuItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemDtoToJson(this);

  static double _doubleFromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }
}

@JsonSerializable()
class CartItemDto {
  final String id;
  final MenuItemDto menuItem;
  final int quantity;
  @JsonKey(fromJson: _doubleFromJson)
  final double price;
  @JsonKey(fromJson: _doubleFromJson)
  final double subtotal;

  CartItemDto({
    required this.id,
    required this.menuItem,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory CartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemDtoToJson(this);

  static double _doubleFromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }
}
