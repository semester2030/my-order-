import '../../data/models/event_offer_dto.dart';

abstract class EventOffersRepo {
  Future<List<EventOfferDto>> getOffers();
  Future<EventOfferDto> addOffer(EventOfferDto dto);
  Future<EventOfferDto> updateOffer(String offerId, EventOfferDto dto);
  Future<void> deleteOffer(String offerId);
}
