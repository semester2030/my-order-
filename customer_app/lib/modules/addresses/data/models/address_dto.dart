import 'package:json_annotation/json_annotation.dart';

part 'address_dto.g.dart';

@JsonSerializable()
class AddressDto {
  @JsonKey(fromJson: _stringFromJson)
  final String id;
  @JsonKey(name: 'user_id', fromJson: _stringFromJson)
  final String userId;
  @JsonKey(fromJson: _stringFromJson)
  final String label;
  @JsonKey(name: 'street_address', fromJson: _stringFromJson)
  final String streetAddress;
  final String? building;
  final String? floor;
  final String? apartment;
  @JsonKey(fromJson: _stringFromJson)
  final String city;
  final String? district;
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  @JsonKey(fromJson: _doubleFromJson)
  final double latitude;
  @JsonKey(fromJson: _doubleFromJson)
  final double longitude;
  @JsonKey(name: 'is_default', fromJson: _boolFromJson)
  final bool isDefault;
  @JsonKey(name: 'is_active', fromJson: _boolFromJson)
  final bool isActive;
  @JsonKey(name: 'created_at', fromJson: _stringFromJson)
  final String createdAt;
  @JsonKey(name: 'updated_at', fromJson: _stringFromJson)
  final String updatedAt;

  AddressDto({
    required this.id,
    required this.userId,
    required this.label,
    required this.streetAddress,
    this.building,
    this.floor,
    this.apartment,
    required this.city,
    this.district,
    this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDtoToJson(this);

  static String _stringFromJson(dynamic value) {
    if (value is String) return value;
    if (value == null) return '';
    return value.toString();
  }

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
