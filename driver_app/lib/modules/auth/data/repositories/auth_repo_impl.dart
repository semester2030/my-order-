import '../../domain/repositories/auth_repo.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_ds.dart';
import '../datasources/auth_local_ds.dart';
import '../models/otp_request_dto.dart';
import '../models/otp_verify_dto.dart';
import '../models/auth_tokens_dto.dart';

/// Auth Repository Implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Map<String, dynamic>> requestOtp(String phone) async {
    final dto = OtpRequestDto(phone: phone);
    final response = await remoteDataSource.requestOtp(dto);
    return response;
  }

  @override
  Future<AuthTokensDto> verifyOtp(String phone, String code) async {
    final dto = OtpVerifyDto(phone: phone, code: code);
    final tokens = await remoteDataSource.verifyOtp(dto);

    // Save tokens locally
    await localDataSource.saveTokens(
      tokens.accessToken,
      tokens.refreshToken,
    );

    // Save user if available
    if (tokens.user != null) {
      await localDataSource.saveUser(tokens.user!);
    }

    return tokens;
  }

  @override
  Future<void> setPin(String pin) async {
    await remoteDataSource.setPin(pin);
  }

  @override
  Future<AuthTokensDto> verifyPin(String phone, String pin) async {
    final tokens = await remoteDataSource.verifyPin(phone, pin);

    // Save tokens locally
    await localDataSource.saveTokens(
      tokens.accessToken,
      tokens.refreshToken,
    );

    // Save user if available
    if (tokens.user != null) {
      await localDataSource.saveUser(tokens.user!);
    }

    return tokens;
  }

  @override
  Future<AuthTokensDto> refreshToken(String refreshToken) async {
    final tokens = await remoteDataSource.refreshToken(refreshToken);

    // Save new tokens locally
    await localDataSource.saveTokens(
      tokens.accessToken,
      tokens.refreshToken,
    );

    return tokens;
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } finally {
      // Clear local data regardless of API call success
      await localDataSource.clearTokens();
      await localDataSource.clearUser();
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await localDataSource.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await localDataSource.getUser();
  }

  @override
  Future<bool> validateToken() async {
    try {
      return await remoteDataSource.validateToken();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearLocalData() async {
    await localDataSource.clearTokens();
    await localDataSource.clearUser();
  }
}
