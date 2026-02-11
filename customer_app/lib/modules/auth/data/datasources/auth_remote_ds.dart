import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/auth_tokens_dto.dart';
import '../mappers/auth_mapper.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokensDto> register(String name, String email, String password);
  Future<AuthTokensDto> login(String email, String password);
  Future<AuthTokensDto> refreshToken(String refreshToken);
  Future<void> logout();
  Future<bool> validateToken();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthTokensDto> register(String name, String email, String password) async {
    try {
      final response = await apiClient.post(
        Endpoints.customerRegister,
        data: {'name': name, 'email': email, 'password': password},
      );
      return AuthMapper.mapAuthTokensFromResponse(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) throw e.error as NetworkException;
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<AuthTokensDto> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        Endpoints.customerLogin,
        data: {'email': email, 'password': password},
      );
      return AuthMapper.mapAuthTokensFromResponse(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) throw e.error as NetworkException;
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
      if (e.error is NetworkException) throw e.error as NetworkException;
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post(Endpoints.logout);
    } on DioException catch (e) {
      if (e.error is NetworkException) throw e.error as NetworkException;
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<bool> validateToken() async {
    try {
      await apiClient.get(Endpoints.userProfile);
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) return false;
      return false;
    }
  }
}
