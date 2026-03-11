import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';

import '../models/event_offer_dto.dart';
import 'event_offers_remote_ds.dart';

class EventOffersRemoteDsImpl implements EventOffersRemoteDs {
  EventOffersRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<EventOfferDto>> getOffers() async {
    try {
      final response = await _dio.get<dynamic>(Endpoints.vendorsEventOffers);
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
          .map((e) => EventOfferDto.fromJson(e))
          .toList();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 404 || code == 500) return [];
      rethrow;
    }
  }

  @override
  Future<EventOfferDto> addOffer(EventOfferDto dto) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorsEventOffers,
      data: dto.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return EventOfferDto.fromJson(data);
  }

  @override
  Future<EventOfferDto> updateOffer(String offerId, EventOfferDto dto) async {
    final response = await _dio.put<Map<String, dynamic>>(
      Endpoints.vendorEventOfferById(offerId),
      data: dto.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return EventOfferDto.fromJson(data);
  }

  @override
  Future<void> deleteOffer(String offerId) async {
    await _dio.delete<void>(Endpoints.vendorEventOfferById(offerId));
  }
}
