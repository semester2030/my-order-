import '../entities/user_entity.dart';
import '../../data/models/auth_tokens_dto.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> requestOtp(String identifier);
  Future<AuthTokensDto> verifyOtp(String identifier, String code);
  Future<void> setPin(String pin);
  Future<AuthTokensDto> verifyPin(String identifier, String pin);
  Future<AuthTokensDto> refreshToken(String refreshToken);
  Future<void> logout();
  Future<void> clearLocalData();
  Future<bool> isAuthenticated();
  Future<UserEntity?> getCurrentUser();
  Future<bool> validateToken();
}
