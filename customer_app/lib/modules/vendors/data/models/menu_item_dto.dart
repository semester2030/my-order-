import 'package:json_annotation/json_annotation.dart';

part 'menu_item_dto.g.dart';

@JsonSerializable()
class MenuItemDto {
  final String id;
  final String name;
  final String? description;
  @JsonKey(fromJson: _doubleFromJson)
  final double price;
  final String? image;
  @JsonKey(name: 'is_signature', fromJson: _boolFromJson)
  final bool isSignature;
  @JsonKey(name: 'is_available', fromJson: _boolFromJson)
  final bool isAvailable;

  MenuItemDto({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.image,
    required this.isSignature,
    required this.isAvailable,
  });

  factory MenuItemDto.fromJson(Map<String, dynamic> json) =>
      _$MenuItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemDtoToJson(this);

  static double _doubleFromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
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
}
