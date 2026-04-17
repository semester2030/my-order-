import '../../data/models/home_cooking_request_dto.dart';

sealed class HomeCookingRequestsState {}

class HomeCookingRequestsInitial extends HomeCookingRequestsState {}

class HomeCookingRequestsLoading extends HomeCookingRequestsState {}

class HomeCookingRequestsLoaded extends HomeCookingRequestsState {
  HomeCookingRequestsLoaded(this.requests);
  final List<HomeCookingRequestDto> requests;
}

class HomeCookingRequestsError extends HomeCookingRequestsState {
  HomeCookingRequestsError(this.message);
  final String message;
}
