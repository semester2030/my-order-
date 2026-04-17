import '../../data/models/chef_booking_request_dto.dart';

sealed class ChefBookingRequestsState {}

class ChefBookingRequestsInitial extends ChefBookingRequestsState {}

class ChefBookingRequestsLoading extends ChefBookingRequestsState {}

class ChefBookingRequestsLoaded extends ChefBookingRequestsState {
  ChefBookingRequestsLoaded(this.requests);
  final List<ChefBookingRequestDto> requests;
}

class ChefBookingRequestsError extends ChefBookingRequestsState {
  ChefBookingRequestsError(this.message);
  final String message;
}
