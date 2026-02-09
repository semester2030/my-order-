import '../../domain/entities/driver_entity.dart';

/// Registration State
sealed class RegistrationState {
  const RegistrationState();
}

class RegistrationInitial extends RegistrationState {
  const RegistrationInitial();
}

class RegistrationLoading extends RegistrationState {
  const RegistrationLoading();
}

class RegistrationStep1Success extends RegistrationState {
  final String driverId;
  final String userId;
  final String status;

  const RegistrationStep1Success({
    required this.driverId,
    required this.userId,
    required this.status,
  });
}

class RegistrationStep2Success extends RegistrationState {
  final String driverId;
  final String status;

  const RegistrationStep2Success({
    required this.driverId,
    required this.status,
  });
}

class RegistrationStep3Success extends RegistrationState {
  final String driverId;
  final String status;

  const RegistrationStep3Success({
    required this.driverId,
    required this.status,
  });
}

class RegistrationTrackSuccess extends RegistrationState {
  final DriverEntity driver;

  const RegistrationTrackSuccess(this.driver);
}

class RegistrationError extends RegistrationState {
  final String message;

  const RegistrationError(this.message);
}
