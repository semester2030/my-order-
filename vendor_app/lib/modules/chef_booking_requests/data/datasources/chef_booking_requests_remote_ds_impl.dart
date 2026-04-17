import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';

import '../models/chef_booking_request_dto.dart';
import 'chef_booking_requests_remote_ds.dart';

class ChefBookingRequestsRemoteDsImpl implements ChefBookingRequestsRemoteDs {
  ChefBookingRequestsRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ChefBookingRequestDto>> getRequests() async {
    try {
      final response = await _dio.get<dynamic>(Endpoints.vendorsChefBookingRequests);
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
          .map(ChefBookingRequestDto.fromJson)
          .toList();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 404 || code == 500) return [];
      rethrow;
    }
  }

  @override
  Future<ChefBookingRequestDto> accept(String requestId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorChefBookingRequestAccept(requestId),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return ChefBookingRequestDto.fromJson(data);
  }

  @override
  Future<ChefBookingRequestDto> reject(String requestId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorChefBookingRequestReject(requestId),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return ChefBookingRequestDto.fromJson(data);
  }
}
