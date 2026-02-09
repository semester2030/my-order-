import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/otp_request_dto.dart';
import '../models/otp_verify_dto.dart';
import '../models/auth_tokens_dto.dart';
import '../mappers/auth_mapper.dart';

/// Auth Remote Data Source
abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> requestOtp(OtpRequestDto dto);
  Future<AuthTokensDto> verifyOtp(OtpVerifyDto dto);
  Future<void> setPin(String pin);
  Future<AuthTokensDto> verifyPin(String phone, String pin);
  Future<AuthTokensDto> refreshToken(String refreshToken);
  Future<void> logout();
  Future<bool> validateToken();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> requestOtp(OtpRequestDto dto) async {
    try {
      final response = await apiClient.post(
        Endpoints.requestOtp,
        data: dto.toJson(),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Request failed',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<AuthTokensDto> verifyOtp(OtpVerifyDto dto) async {
    try {
      final response = await apiClient.post(
        Endpoints.verifyOtp,
        data: dto.toJson(),
      );

      return AuthMapper.mapAuthTokensFromResponse(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Verification failed',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> setPin(String pin) async {
    try {
      await apiClient.post(
        Endpoints.setPin,
        data: {'pin': pin},
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Set PIN failed',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<AuthTokensDto> verifyPin(String phone, String pin) async {
    try {
      final response = await apiClient.post(
        Endpoints.verifyPin,
        data: {'phone': phone, 'pin': pin},
      );

      return AuthMapper.mapAuthTokensFromResponse(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'PIN verification failed',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<AuthTokensDto> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.post(
        Endpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      return AuthTokensDto(
        accessToken: response.data['accessToken'] as String,
        refreshToken: response.data['refreshToken'] as String,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Token refresh failed',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post(Endpoints.logout);
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Logout failed',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<bool> validateToken() async {
    try {
      // Use /users/profile endpoint to validate token
      // If token is invalid or expired, this will throw 401
      await apiClient.get('/users/profile');
      return true; // Token is valid
    } on DioException catch (e) {
      // Check if it's an authentication error (401 Unauthorized)
      if (e.response?.statusCode == 401) {
        return false; // Token is invalid or expired
      }
      // For other network errors, return false to be safe
      return false;
    } catch (e) {
      // Any other error, assume token is invalid
      return false;
    }
  }
}
