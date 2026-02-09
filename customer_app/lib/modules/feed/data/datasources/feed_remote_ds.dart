import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/feed_page_dto.dart';

abstract class FeedRemoteDataSource {
  Future<FeedPageDto> getFeed({
    int page = 1,
    int limit = 10,
    String? vendorType,
    String? category,
    String? sortBy,
    String? city,
  });
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final ApiClient apiClient;

  FeedRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<FeedPageDto> getFeed({
    int page = 1,
    int limit = 10,
    String? vendorType,
    String? category,
    String? sortBy,
    String? city,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (vendorType != null && vendorType.isNotEmpty) {
        queryParameters['vendorType'] = vendorType;
      }
      if (category != null && category.isNotEmpty) {
        queryParameters['category'] = category;
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParameters['sortBy'] = sortBy;
      }
      if (city != null && city.isNotEmpty) {
        queryParameters['city'] = city;
      }

      final response = await apiClient.get(
        Endpoints.feed,
        queryParameters: queryParameters,
      );

      return FeedPageDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }
}
