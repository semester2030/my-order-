import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

@JsonSerializable()
class ProfileDto {
  @JsonKey(fromJson: _stringFromJson)
  final String id;
  @JsonKey(name: 'phone', fromJson: _phoneFromJson)
  final String? phone;
  final String? name;
  final String? email;
  @JsonKey(name: 'is_verified', fromJson: _boolFromJson)
  final bool isVerified;
  @JsonKey(name: 'created_at', fromJson: _stringFromJson)
  final String createdAt;

  ProfileDto({
    required this.id,
    this.phone,
    this.name,
    this.email,
    required this.isVerified,
    required this.createdAt,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);

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

  static String? _phoneFromJson(dynamic value) {
    if (value == null) return null;
    final s = value is String ? value : value.toString();
    return s.isEmpty ? null : s;
  }
}
