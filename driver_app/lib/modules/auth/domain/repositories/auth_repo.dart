import '../entities/user_entity.dart';
import '../../data/models/auth_tokens_dto.dart';

/// Auth Repository
abstract class AuthRepository {
  Future<Map<String, dynamic>> requestOtp(String phone);
  Future<AuthTokensDto> verifyOtp(String phone, String code);
  Future<void> setPin(String pin);
  Future<AuthTokensDto> verifyPin(String phone, String pin);
  Future<AuthTokensDto> refreshToken(String refreshToken);
  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<UserEntity?> getCurrentUser();
  Future<bool> validateToken();
  Future<void> clearLocalData();
}
