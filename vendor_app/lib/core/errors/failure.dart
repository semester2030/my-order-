import 'package:equatable/equatable.dart';

/// Domain failure for Vendor App (used in repositories/use cases).
abstract base class Failure with EquatableMixin {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Generic failure (e.g. unknown, server).
final class GenericFailure extends Failure {
  const GenericFailure(super.message);
}

/// Network failure (no connection, timeout).
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Auth failure (unauthorized, invalid credentials).
final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Validation failure (invalid input).
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Server failure (5xx, bad response).
final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}
