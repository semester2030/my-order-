import '../../data/models/driver_profile_dto.dart';

/// Driver Profile State
sealed class DriverProfileState {
  const DriverProfileState();
}

class DriverProfileInitial extends DriverProfileState {
  const DriverProfileInitial();
}

class DriverProfileLoading extends DriverProfileState {
  const DriverProfileLoading();
}

class DriverProfileLoaded extends DriverProfileState {
  final DriverProfileDto profile;

  const DriverProfileLoaded(this.profile);
}

class DriverProfileError extends DriverProfileState {
  final String message;

  const DriverProfileError(this.message);
}

/// Driver Availability State
sealed class DriverAvailabilityState {
  const DriverAvailabilityState();
}

class DriverAvailabilityInitial extends DriverAvailabilityState {
  const DriverAvailabilityInitial();
}

class DriverAvailabilityUpdating extends DriverAvailabilityState {
  const DriverAvailabilityUpdating();
}

class DriverAvailabilityUpdated extends DriverAvailabilityState {
  final bool isOnline;

  const DriverAvailabilityUpdated(this.isOnline);
}

class DriverAvailabilityError extends DriverAvailabilityState {
  final String message;

  const DriverAvailabilityError(this.message);
}
