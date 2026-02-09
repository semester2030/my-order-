import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/job_offer_dto.dart';
import '../models/active_job_dto.dart';
import '../models/accept_job_dto.dart';
import '../models/delivery_history_dto.dart';

/// Jobs Remote Data Source
abstract class JobsRemoteDataSource {
  Future<List<JobOfferDto>> getInbox();
  Future<ActiveJobDto?> getActiveJob();
  Future<DeliveryHistoryDto> getDeliveryHistory();
  Future<Map<String, dynamic>> acceptJob(AcceptJobDto dto);
  Future<Map<String, dynamic>> rejectJob(String jobOfferId);
}

class JobsRemoteDataSourceImpl implements JobsRemoteDataSource {
  final ApiClient apiClient;

  JobsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<JobOfferDto>> getInbox() async {
    try {
      final response = await apiClient.get(Endpoints.getInbox);
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => JobOfferDto.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Failed to get inbox',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<ActiveJobDto?> getActiveJob() async {
    try {
      final response = await apiClient.get(Endpoints.getActiveJob);
      if (response.data == null) {
        return null;
      }
      // Handle case where response.data might be a String (error message)
      if (response.data is String) {
        return null; // No active job or error message
      }
      // Ensure it's a Map before parsing
      if (response.data is! Map<String, dynamic>) {
        return null;
      }
      return ActiveJobDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // No active job
      }
      if (e.response != null) {
        // Handle case where error response might be a String
        final errorData = e.response?.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? (errorData['message'] as String? ?? 'Failed to get active job')
            : (errorData is String ? errorData : 'Failed to get active job');
        throw NetworkException(
          message: errorMessage,
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<DeliveryHistoryDto> getDeliveryHistory() async {
    try {
      final response = await apiClient.get(Endpoints.getHistory);
      if (response.data is! Map<String, dynamic>) {
        return DeliveryHistoryDto(totalEarnings: 0, deliveries: []);
      }
      return DeliveryHistoryDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Failed to get delivery history',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<Map<String, dynamic>> acceptJob(AcceptJobDto dto) async {
    try {
      final response = await apiClient.post(
        Endpoints.acceptJob,
        data: dto.toJson(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Failed to accept job',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<Map<String, dynamic>> rejectJob(String jobOfferId) async {
    try {
      final response = await apiClient.post(
        Endpoints.rejectJob.replaceAll('{jobOfferId}', jobOfferId),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null) {
        throw NetworkException(
          message: e.response?.data['message'] as String? ?? 'Failed to reject job',
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }
}
