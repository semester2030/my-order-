import '../models/event_offer_dto.dart';

/// مصدر بيانات عروض المناسبات عبر API.
abstract class EventOffersRemoteDs {
  Future<List<EventOfferDto>> getOffers();
  Future<EventOfferDto> addOffer(EventOfferDto dto);
  Future<EventOfferDto> updateOffer(String offerId, EventOfferDto dto);
  Future<void> deleteOffer(String offerId);
}
