import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/register_step1_dto.dart';
import '../models/register_step2_dto.dart';
import '../models/register_step3_dto.dart';
import '../../domain/entities/driver_entity.dart';

/// Registration Remote Data Source
abstract class RegistrationRemoteDataSource {
  Future<Map<String, dynamic>> registerStep1(RegisterStep1Dto dto);
  Future<Map<String, dynamic>> registerStep2(String driverId, RegisterStep2Dto dto);
  Future<Map<String, dynamic>> registerStep3(String driverId, RegisterStep3Dto dto);
  Future<DriverEntity> trackApplication(String driverId);
}

class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  final ApiClient apiClient;

  RegistrationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> registerStep1(RegisterStep1Dto dto) async {
    try {
      final response = await apiClient.post(
        Endpoints.registerStep1,
        data: dto.toJson(),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Registration failed',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<Map<String, dynamic>> registerStep2(String driverId, RegisterStep2Dto dto) async {
    try {
      final response = await apiClient.post(
        Endpoints.registerStep2.replaceAll('{driverId}', driverId),
        data: dto.toJson(),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Registration step 2 failed',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<Map<String, dynamic>> registerStep3(String driverId, RegisterStep3Dto dto) async {
    try {
      final response = await apiClient.post(
        Endpoints.registerStep3.replaceAll('{driverId}', driverId),
        data: dto.toJson(),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Registration step 3 failed',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<DriverEntity> trackApplication(String driverId) async {
    try {
      final response = await apiClient.get(
        Endpoints.trackApplication.replaceAll('{driverId}', driverId),
      );

      return DriverEntity.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Failed to track application',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }
}
