import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';
import '../mappers/auth_mapper.dart';

part 'auth_tokens_dto.g.dart';

@JsonSerializable()
class AuthTokensDto {
  final String accessToken;
  final String refreshToken;
  @JsonKey(fromJson: _userFromJson, toJson: _userToJson)
  final UserEntity? user;

  AuthTokensDto({
    required this.accessToken,
    required this.refreshToken,
    this.user,
  });

  factory AuthTokensDto.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokensDtoToJson(this);

  static UserEntity? _userFromJson(Map<String, dynamic>? json) {
    return AuthMapper.mapUserFromJson(json);
  }

  static Map<String, dynamic>? _userToJson(UserEntity? user) {
    if (user == null) return null;
    return {
      'id': user.id,
      'phone': user.phone,
      'name': user.name,
      'email': user.email,
      'isVerified': user.isVerified,
      'createdAt': user.createdAt.toIso8601String(),
    };
  }
}
