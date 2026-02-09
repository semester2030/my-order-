import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/driver_profile_dto.dart';
import '../models/update_availability_dto.dart';

/// Driver Profile Remote Data Source
abstract class DriverProfileRemoteDataSource {
  Future<bool> checkDriverExists();
  Future<DriverProfileDto> getProfile();
  Future<Map<String, dynamic>> updateAvailability(UpdateAvailabilityDto dto);
}

class DriverProfileRemoteDataSourceImpl implements DriverProfileRemoteDataSource {
  final ApiClient apiClient;

  DriverProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<bool> checkDriverExists() async {
    try {
      final response = await apiClient.get(Endpoints.checkDriverExists);
      final data = response.data as Map<String, dynamic>;
      return data['exists'] as bool? ?? false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
      }
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Failed to check driver existence',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<DriverProfileDto> getProfile() async {
    try {
      final response = await apiClient.get(Endpoints.driverProfile);
      // Handle case where response.data might be a String (error message)
      if (response.data is String) {
        throw NetworkException(
          message: response.data as String,
          statusCode: 500,
        );
      }
      // Ensure it's a Map before parsing
      if (response.data is! Map<String, dynamic>) {
        throw NetworkException(
          message: 'Invalid response format from server',
          statusCode: 500,
        );
      }
      return DriverProfileDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle case where error response might be a String
        final errorData = e.response?.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? (errorData['message'] as String? ?? 'Failed to get profile')
            : (errorData is String ? errorData : 'Failed to get profile');
        throw NetworkException(
          message: errorMessage,
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<Map<String, dynamic>> updateAvailability(UpdateAvailabilityDto dto) async {
    try {
      final response = await apiClient.put(
        Endpoints.updateAvailability,
        data: dto.toJson(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Failed to update availability',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }
}
