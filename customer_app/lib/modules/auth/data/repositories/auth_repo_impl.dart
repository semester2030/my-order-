import '../../domain/repositories/auth_repo.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_ds.dart';
import '../datasources/auth_local_ds.dart';
import '../models/auth_tokens_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<void> _saveAuth(AuthTokensDto tokens) async {
    await localDataSource.saveTokens(tokens.accessToken, tokens.refreshToken);
    if (tokens.user != null) {
      await localDataSource.saveUser(tokens.user!);
    }
  }

  @override
  Future<AuthTokensDto> register(String name, String email, String password) async {
    final tokens = await remoteDataSource.register(name, email, password);
    await _saveAuth(tokens);
    return tokens;
  }

  @override
  Future<AuthTokensDto> login(String email, String password) async {
    final tokens = await remoteDataSource.login(email, password);
    await _saveAuth(tokens);
    return tokens;
  }

  @override
  Future<AuthTokensDto> refreshToken(String refreshToken) async {
    final tokens = await remoteDataSource.refreshToken(refreshToken);
    await localDataSource.saveTokens(tokens.accessToken, tokens.refreshToken);
    return tokens;
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } finally {
      await localDataSource.clearTokens();
      await localDataSource.clearUser();
      await localDataSource.clearPinHash();
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await localDataSource.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return localDataSource.getUser();
  }

  @override
  Future<bool> validateToken() async {
    try {
      return await remoteDataSource.validateToken();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> clearLocalData() async {
    await localDataSource.clearTokens();
    await localDataSource.clearUser();
    await localDataSource.clearPinHash();
  }
}
