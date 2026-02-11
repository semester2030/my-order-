import '../entities/user_entity.dart';
import '../../data/models/auth_tokens_dto.dart';

abstract class AuthRepository {
  Future<AuthTokensDto> register(String name, String email, String password);
  Future<AuthTokensDto> login(String email, String password);
  Future<AuthTokensDto> refreshToken(String refreshToken);
  Future<void> logout();
  Future<void> clearLocalData();
  Future<bool> isAuthenticated();
  Future<UserEntity?> getCurrentUser();
  Future<bool> validateToken();
}
