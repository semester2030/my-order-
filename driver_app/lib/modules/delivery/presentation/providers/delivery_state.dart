import '../../data/models/delivery_details_dto.dart';

/// Delivery Details State
sealed class DeliveryDetailsState {
  const DeliveryDetailsState();
}

class DeliveryDetailsInitial extends DeliveryDetailsState {
  const DeliveryDetailsInitial();
}

class DeliveryDetailsLoading extends DeliveryDetailsState {
  const DeliveryDetailsLoading();
}

class DeliveryDetailsLoaded extends DeliveryDetailsState {
  final DeliveryDetailsDto details;

  const DeliveryDetailsLoaded(this.details);
}

class DeliveryDetailsError extends DeliveryDetailsState {
  final String message;

  const DeliveryDetailsError(this.message);
}

/// Update Location State
sealed class UpdateLocationState {
  const UpdateLocationState();
}

class UpdateLocationInitial extends UpdateLocationState {
  const UpdateLocationInitial();
}

class UpdateLocationUpdating extends UpdateLocationState {
  const UpdateLocationUpdating();
}

class UpdateLocationSuccess extends UpdateLocationState {
  final double latitude;
  final double longitude;

  const UpdateLocationSuccess({
    required this.latitude,
    required this.longitude,
  });
}

class UpdateLocationError extends UpdateLocationState {
  final String message;

  const UpdateLocationError(this.message);
}

/// Update Delivery Status State
sealed class UpdateDeliveryStatusState {
  const UpdateDeliveryStatusState();
}

class UpdateDeliveryStatusInitial extends UpdateDeliveryStatusState {
  const UpdateDeliveryStatusInitial();
}

class UpdateDeliveryStatusUpdating extends UpdateDeliveryStatusState {
  const UpdateDeliveryStatusUpdating();
}

class UpdateDeliveryStatusSuccess extends UpdateDeliveryStatusState {
  final String status;

  const UpdateDeliveryStatusSuccess(this.status);
}

class UpdateDeliveryStatusError extends UpdateDeliveryStatusState {
  final String message;

  const UpdateDeliveryStatusError(this.message);
}
