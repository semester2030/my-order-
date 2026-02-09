import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/update_location_dto.dart';
import '../models/update_delivery_status_dto.dart';
import '../models/delivery_details_dto.dart';

/// Delivery Remote Data Source
abstract class DeliveryRemoteDataSource {
  Future<DeliveryDetailsDto> getDeliveryDetails(String orderId);
  Future<Map<String, dynamic>> updateLocation(String orderId, UpdateLocationDto dto);
  Future<Map<String, dynamic>> updateDeliveryStatus(
    String orderId,
    UpdateDeliveryStatusDto dto,
  );
}

class DeliveryRemoteDataSourceImpl implements DeliveryRemoteDataSource {
  final ApiClient apiClient;

  DeliveryRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<DeliveryDetailsDto> getDeliveryDetails(String orderId) async {
    try {
      final response = await apiClient.get(
        Endpoints.getDeliveryDetails.replaceAll('{orderId}', orderId),
      );
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
      return DeliveryDetailsDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle case where error response might be a String
        final errorData = e.response?.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? (errorData['message'] as String? ?? 'Failed to get delivery details')
            : (errorData is String ? errorData : 'Failed to get delivery details');
        throw NetworkException(
          message: errorMessage,
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<Map<String, dynamic>> updateLocation(String orderId, UpdateLocationDto dto) async {
    try {
      final response = await apiClient.post(
        Endpoints.updateLocation.replaceAll('{orderId}', orderId),
        data: dto.toJson(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Failed to update location',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<Map<String, dynamic>> updateDeliveryStatus(
    String orderId,
    UpdateDeliveryStatusDto dto,
  ) async {
    try {
      final response = await apiClient.put(
        Endpoints.updateDeliveryStatus.replaceAll('{orderId}', orderId),
        data: dto.toJson(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Failed to update delivery status',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }
}
