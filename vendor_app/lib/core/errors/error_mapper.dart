import 'package:dio/dio.dart';

import 'app_exception.dart';
import 'failure.dart';

/// Maps exceptions/errors to [Failure].
class ErrorMapper {
  ErrorMapper._();

  static Failure toFailure(Object error) {
    // Phase 7: Dio rejects with error = AppException from ErrorInterceptor.
    Object? appError = error;
    if (error is DioException && error.error is AppException) {
      appError = error.error;
    }
    if (appError is AppException) {
      if (appError is NetworkException) return NetworkFailure(appError.message);
      if (appError is UnauthorizedException) return AuthFailure(appError.message);
      if (appError is ValidationException) return ValidationFailure(appError.message);
      if (appError is ServerException) return ServerFailure(appError.message);
      return GenericFailure(appError.message);
    }
    return GenericFailure(error.toString());
  }
}
