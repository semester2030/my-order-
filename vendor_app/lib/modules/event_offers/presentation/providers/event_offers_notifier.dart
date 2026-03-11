import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/event_offers_repo.dart';
import '../../data/models/event_offer_dto.dart';
import 'event_offers_state.dart';

class EventOffersNotifier extends StateNotifier<EventOffersState> {
  EventOffersNotifier(this._repo) : super(EventOffersInitial());

  final EventOffersRepo _repo;

  Future<void> load() async {
    state = EventOffersLoading();
    try {
      final offers = await _repo.getOffers();
      state = EventOffersLoaded(offers);
    } catch (e) {
      state = EventOffersError(e.toString());
    }
  }

  Future<bool> addOffer(EventOfferDto dto) async {
    state = EventOffersSaving();
    try {
      final created = await _repo.addOffer(dto);
      if (state is EventOffersLoaded) {
        final list = (state as EventOffersLoaded).offers;
        state = EventOffersLoaded([...list, created]);
      } else {
        state = EventOffersLoaded([created]);
      }
      return true;
    } catch (e) {
      state = EventOffersError(e.toString());
      return false;
    }
  }

  Future<bool> updateOffer(String offerId, EventOfferDto dto) async {
    state = EventOffersSaving();
    try {
      final updated = await _repo.updateOffer(offerId, dto);
      if (state is EventOffersLoaded) {
        final list = (state as EventOffersLoaded).offers;
        final idx = list.indexWhere((o) => o.id == offerId);
        final newList = [...list];
        if (idx >= 0) {
          newList[idx] = updated;
        } else {
          newList.add(updated);
        }
        state = EventOffersLoaded(newList);
      }
      return true;
    } catch (e) {
      state = EventOffersError(e.toString());
      return false;
    }
  }

  Future<bool> deleteOffer(String offerId) async {
    state = EventOffersSaving();
    try {
      await _repo.deleteOffer(offerId);
      if (state is EventOffersLoaded) {
        final list = (state as EventOffersLoaded).offers;
        state = EventOffersLoaded(list.where((o) => o.id != offerId).toList());
      }
      return true;
    } catch (e) {
      state = EventOffersError(e.toString());
      return false;
    }
  }
}
