import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/search_result_dto.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchResultDto>> searchVendors(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SearchResultDto>> searchVendors(String query) async {
    try {
      // TODO: Replace with actual search endpoint when available
      // For now, use vendors endpoint with query parameter
      final response = await apiClient.get(
        Endpoints.searchVendors,
        queryParameters: {'q': query},
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => SearchResultDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }
}
