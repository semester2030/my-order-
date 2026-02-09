import '../../domain/entities/user_entity.dart';
import '../mappers/auth_mapper.dart';

/// Auth Tokens DTO
class AuthTokensDto {
  final String accessToken;
  final String refreshToken;
  final UserEntity? user;

  AuthTokensDto({
    required this.accessToken,
    required this.refreshToken,
    this.user,
  });

  factory AuthTokensDto.fromJson(Map<String, dynamic> json) {
    return AuthTokensDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: AuthMapper.mapUserFromJson(
        json['user'] as Map<String, dynamic>?,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        if (user != null)
          'user': {
            'id': user!.id,
            'phone': user!.phone,
            'name': user!.name,
            'email': user!.email,
            'isVerified': user!.isVerified,
            'createdAt': user!.createdAt.toIso8601String(),
          },
      };
}
