import '../../domain/entities/user_entity.dart';
import '../models/auth_tokens_dto.dart';

/// Auth Mapper
class AuthMapper {
  static UserEntity? mapUserFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return UserEntity(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  static AuthTokensDto mapAuthTokensFromResponse(Map<String, dynamic> json) {
    return AuthTokensDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: mapUserFromJson(json['user'] as Map<String, dynamic>?),
    );
  }
}
