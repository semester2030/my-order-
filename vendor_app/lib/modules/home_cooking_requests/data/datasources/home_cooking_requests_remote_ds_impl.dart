import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';

import '../models/home_cooking_request_dto.dart';
import 'home_cooking_requests_remote_ds.dart';

class HomeCookingRequestsRemoteDsImpl implements HomeCookingRequestsRemoteDs {
  HomeCookingRequestsRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<HomeCookingRequestDto>> getRequests() async {
    try {
      final response = await _dio.get<dynamic>(Endpoints.vendorsHomeCookingRequests);
      final data = response.data;
      if (data == null) return [];
      List<dynamic> list;
      if (data is List) {
        list = data;
      } else if (data is Map<String, dynamic> && data['data'] is List) {
        list = data['data'] as List<dynamic>;
      } else {
        list = [];
      }
      return list
          .whereType<Map<String, dynamic>>()
          .map(HomeCookingRequestDto.fromJson)
          .toList();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 404 || code == 500) return [];
      rethrow;
    }
  }

  @override
  Future<HomeCookingRequestDto> quote(
    String requestId, {
    required double quotedAmount,
    String? quoteNotes,
  }) async {
    final body = <String, dynamic>{
      'quotedAmount': quotedAmount,
      if (quoteNotes != null && quoteNotes.trim().isNotEmpty) 'quoteNotes': quoteNotes.trim(),
    };
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorHomeCookingQuote(requestId),
      data: body,
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return HomeCookingRequestDto.fromJson(data);
  }

  @override
  Future<HomeCookingRequestDto> reject(String requestId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorHomeCookingReject(requestId),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return HomeCookingRequestDto.fromJson(data);
  }

  @override
  Future<HomeCookingRequestDto> markReady(String requestId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorHomeCookingMarkReady(requestId),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return HomeCookingRequestDto.fromJson(data);
  }

  @override
  Future<HomeCookingRequestDto> markHandedOver(
    String requestId, {
    String? handoverNotes,
  }) async {
    final body = <String, dynamic>{
      if (handoverNotes != null && handoverNotes.trim().isNotEmpty)
        'handoverNotes': handoverNotes.trim(),
    };
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorHomeCookingMarkHandedOver(requestId),
      data: body.isEmpty ? {} : body,
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return HomeCookingRequestDto.fromJson(data);
  }
}
