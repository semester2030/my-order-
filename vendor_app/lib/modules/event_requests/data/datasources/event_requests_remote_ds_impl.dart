import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';

import '../models/private_event_request_dto.dart';
import 'event_requests_remote_ds.dart';

class EventRequestsRemoteDsImpl implements EventRequestsRemoteDs {
  EventRequestsRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<PrivateEventRequestDto>> getRequests() async {
    try {
      final response =
          await _dio.get<dynamic>(Endpoints.vendorsPrivateEventRequests);
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
          .map((e) => PrivateEventRequestDto.fromJson(e))
          .toList();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 404 || code == 500) return [];
      rethrow;
    }
  }

  @override
  Future<PrivateEventRequestDto> accept(String requestId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorPrivateEventRequestAccept(requestId),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return PrivateEventRequestDto.fromJson(data);
  }

  @override
  Future<PrivateEventRequestDto> reject(String requestId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorPrivateEventRequestReject(requestId),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return PrivateEventRequestDto.fromJson(data);
  }
}
