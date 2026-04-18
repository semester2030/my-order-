import 'package:json_annotation/json_annotation.dart';

part 'menu_item_dto.g.dart';

@JsonSerializable()
class MenuItemDto {
  final String id;
  final String name;
  final String? description;
  @JsonKey(fromJson: _nullablePriceFromJson, toJson: _nullablePriceToJson)
  final double? price;
  final String? image;
  @JsonKey(name: 'is_signature', fromJson: _boolFromJson)
  final bool isSignature;
  @JsonKey(name: 'is_available', fromJson: _boolFromJson)
  final bool isAvailable;

  MenuItemDto({
    required this.id,
    required this.name,
    this.description,
    this.price,
    this.image,
    required this.isSignature,
    required this.isAvailable,
  });

  factory MenuItemDto.fromJson(Map<String, dynamic> json) =>
      _$MenuItemDtoFromJson(_normalizeMenuItemKeys(json));

  /// يدعم استجابة الـ API بصيغة camelCase (`isAvailable`) أو snake_case (`is_available`).
  static Map<String, dynamic> _normalizeMenuItemKeys(Map<String, dynamic> json) {
    final m = Map<String, dynamic>.from(json);
    if (m.containsKey('isAvailable') && !m.containsKey('is_available')) {
      m['is_available'] = m['isAvailable'];
    }
    if (m.containsKey('isSignature') && !m.containsKey('is_signature')) {
      m['is_signature'] = m['isSignature'];
    }
    if (m.containsKey('imageUrl') && !m.containsKey('image')) {
      m['image'] = m['imageUrl'];
    }
    return m;
  }

  Map<String, dynamic> toJson() => _$MenuItemDtoToJson(this);

  static double? _nullablePriceFromJson(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final t = value.trim();
      if (t.isEmpty) return null;
      try {
        return double.parse(t);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Object? _nullablePriceToJson(double? value) => value;

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
