import '../../data/models/private_event_request_dto.dart';

sealed class EventRequestsState {}

class EventRequestsInitial extends EventRequestsState {}

class EventRequestsLoading extends EventRequestsState {}

class EventRequestsLoaded extends EventRequestsState {
  EventRequestsLoaded(this.requests);
  final List<PrivateEventRequestDto> requests;
}

class EventRequestsError extends EventRequestsState {
  EventRequestsError(this.message);
  final String message;
}

class EventRequestsActioning extends EventRequestsState {}
