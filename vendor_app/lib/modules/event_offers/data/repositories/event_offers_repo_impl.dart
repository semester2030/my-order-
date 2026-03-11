import '../../domain/repositories/event_offers_repo.dart';
import '../datasources/event_offers_remote_ds.dart';
import '../models/event_offer_dto.dart';

class EventOffersRepoImpl implements EventOffersRepo {
  EventOffersRepoImpl(this._ds);

  final EventOffersRemoteDs _ds;

  @override
  Future<List<EventOfferDto>> getOffers() => _ds.getOffers();

  @override
  Future<EventOfferDto> addOffer(EventOfferDto dto) => _ds.addOffer(dto);

  @override
  Future<EventOfferDto> updateOffer(String offerId, EventOfferDto dto) =>
      _ds.updateOffer(offerId, dto);

  @override
  Future<void> deleteOffer(String offerId) => _ds.deleteOffer(offerId);
}
