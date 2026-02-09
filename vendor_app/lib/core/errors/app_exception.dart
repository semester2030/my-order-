/// Application exception (throwable, e.g. from data layer).
class AppException implements Exception {
  AppException(this.message, [this.code, this.cause]);
  final String message;
  final String? code;
  final Object? cause;

  @override
  String toString() => 'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Network-related exception.
class NetworkException extends AppException {
  NetworkException(String message, [String? code, Object? cause]) : super(message, code, cause);
}

/// Unauthorized exception (401).
class UnauthorizedException extends AppException {
  UnauthorizedException([String message = 'Unauthorized', String? code, Object? cause])
      : super(message, code, cause);
}

/// Validation exception (400, 422).
class ValidationException extends AppException {
  ValidationException(String message, [String? code, Object? cause]) : super(message, code, cause);
}

/// Server exception (5xx).
class ServerException extends AppException {
  ServerException(String message, [String? code, Object? cause]) : super(message, code, cause);
}
