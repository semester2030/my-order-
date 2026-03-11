import '../../data/models/event_offer_dto.dart';

sealed class EventOffersState {}

class EventOffersInitial extends EventOffersState {}

class EventOffersLoading extends EventOffersState {}

class EventOffersLoaded extends EventOffersState {
  EventOffersLoaded(this.offers);
  final List<EventOfferDto> offers;
}

class EventOffersError extends EventOffersState {
  EventOffersError(this.message);
  final String message;
}

class EventOffersSaving extends EventOffersState {}
