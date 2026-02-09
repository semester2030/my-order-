import 'package:json_annotation/json_annotation.dart';

part 'order_item_dto.g.dart';

@JsonSerializable()
class OrderMenuItemDto {
  @JsonKey(fromJson: _stringFromJson)
  final String id;
  @JsonKey(fromJson: _stringFromJson)
  final String name;
  final String? description;
  final String? image;
  @JsonKey(fromJson: _doubleFromJson)
  final double price;

  OrderMenuItemDto({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.price,
  });

  factory OrderMenuItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderMenuItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderMenuItemDtoToJson(this);

  static double _doubleFromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }

  static String _stringFromJson(dynamic value) {
    if (value is String) return value;
    if (value == null) return '';
    return value.toString();
  }
}

@JsonSerializable()
class OrderItemDto {
  @JsonKey(fromJson: _stringFromJson)
  final String id;
  @JsonKey(fromJson: _menuItemFromJson)
  final OrderMenuItemDto menuItem;
  final int quantity;
  @JsonKey(fromJson: _doubleFromJson)
  final double price;
  @JsonKey(fromJson: _doubleFromJson)
  final double subtotal;

  OrderItemDto({
    required this.id,
    required this.menuItem,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemDtoToJson(this);

  static double _doubleFromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }

  static OrderMenuItemDto _menuItemFromJson(dynamic value) {
    if (value == null) {
      return OrderMenuItemDto(
        id: '',
        name: 'Unknown Item',
        description: null,
        image: null,
        price: 0.0,
      );
    }
    if (value is Map<String, dynamic>) {
      return OrderMenuItemDto.fromJson(value);
    }
    return OrderMenuItemDto(
      id: '',
      name: 'Unknown Item',
      description: null,
      image: null,
      price: 0.0,
    );
  }

  static String _stringFromJson(dynamic value) {
    if (value is String) return value;
    if (value == null) return '';
    return value.toString();
  }
}
