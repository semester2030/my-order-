import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';

abstract class ServiceExperienceRemoteDataSource {
  Future<Map<String, dynamic>> getPublicVendorReviews(
    String vendorId, {
    int page = 1,
    int limit = 20,
  });

  Future<void> submitReview({
    required String subjectType,
    required String subjectId,
    required int stars,
    String? publicComment,
  });

  Future<void> submitQualityTicket({
    required String subjectType,
    required String subjectId,
    required String category,
    required String privateMessage,
    Map<String, num>? detailScores,
  });
}

class ServiceExperienceRemoteDataSourceImpl
    implements ServiceExperienceRemoteDataSource {
  ServiceExperienceRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<Map<String, dynamic>> getPublicVendorReviews(
    String vendorId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await apiClient.get(
        Endpoints.publicVendorServiceReviews(vendorId),
        queryParameters: <String, dynamic>{
          'page': page,
          'limit': limit,
        },
      );
      final data = response.data;
      if (data is! Map) {
        return <String, dynamic>{'items': [], 'total': 0, 'page': page, 'limit': limit};
      }
      return Map<String, dynamic>.from(data);
    } on DioException catch (e) {
      if (e.error is NetworkException) throw e.error as NetworkException;
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> submitReview({
    required String subjectType,
    required String subjectId,
    required int stars,
    String? publicComment,
  }) async {
    try {
      await apiClient.post(
        Endpoints.serviceExperienceReviews,
        data: <String, dynamic>{
          'subjectType': subjectType,
          'subjectId': subjectId,
          'stars': stars,
          if (publicComment != null && publicComment.trim().isNotEmpty)
            'publicComment': publicComment.trim(),
        },
      );
    } on DioException catch (e) {
      if (e.error is NetworkException) throw e.error as NetworkException;
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> submitQualityTicket({
    required String subjectType,
    required String subjectId,
    required String category,
    required String privateMessage,
    Map<String, num>? detailScores,
  }) async {
    try {
      await apiClient.post(
        Endpoints.serviceExperienceQualityTickets,
        data: <String, dynamic>{
          'subjectType': subjectType,
          'subjectId': subjectId,
          'category': category,
          'privateMessage': privateMessage.trim(),
          if (detailScores != null && detailScores.isNotEmpty) 'detailScores': detailScores,
        },
      );
    } on DioException catch (e) {
      if (e.error is NetworkException) throw e.error as NetworkException;
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }
}
