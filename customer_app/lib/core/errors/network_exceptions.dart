import 'package:equatable/equatable.dart';

/// Network exception types
class NetworkException extends Equatable implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errors;

  const NetworkException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  // Factory constructors for different error types
  factory NetworkException.timeout({String? message}) {
    return NetworkException(
      message: message ?? 'Connection timeout',
    );
  }

  factory NetworkException.badRequest({String? message}) {
    return NetworkException(
      message: message ?? 'Bad request',
      statusCode: 400,
    );
  }

  factory NetworkException.unauthorized({String? message}) {
    return NetworkException(
      message: message ?? 'Unauthorized',
      statusCode: 401,
    );
  }

  factory NetworkException.forbidden({String? message}) {
    return NetworkException(
      message: message ?? 'Forbidden',
      statusCode: 403,
    );
  }

  factory NetworkException.notFound({String? message}) {
    return NetworkException(
      message: message ?? 'Not found',
      statusCode: 404,
    );
  }

  factory NetworkException.conflict({String? message}) {
    return NetworkException(
      message: message ?? 'Conflict',
      statusCode: 409,
    );
  }

  factory NetworkException.validationError({
    String? message,
    dynamic errors,
  }) {
    return NetworkException(
      message: message ?? 'Validation error',
      statusCode: 422,
      errors: errors,
    );
  }

  factory NetworkException.serverError({String? message}) {
    return NetworkException(
      message: message ?? 'Server error',
      statusCode: 500,
    );
  }

  factory NetworkException.cancel({String? message}) {
    return NetworkException(
      message: message ?? 'Request cancelled',
    );
  }

  factory NetworkException.unknown({String? message}) {
    return NetworkException(
      message: message ?? 'Unknown error',
    );
  }

  @override
  List<Object?> get props => [message, statusCode, errors];

  @override
  String toString() => message;
}
