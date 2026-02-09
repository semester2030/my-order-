import '../errors/app_exception.dart';

/// Network-related exceptions (no HTTP calls in Phase 1; for future use).
AppException mapStatusCodeToException(int statusCode, [String? body]) {
  switch (statusCode) {
    case 400:
    case 422:
      return ValidationException(body ?? 'طلب غير صالح', '$statusCode');
    case 401:
      return UnauthorizedException(body ?? 'غير مصرح');
    case 403:
      return NetworkException(body ?? 'ممنوع', '$statusCode');
    case 404:
      return NetworkException(body ?? 'غير موجود', '$statusCode');
    case 408:
    case 504:
      return NetworkException(body ?? 'انتهت المهلة', '$statusCode');
    case 500:
    case 502:
    case 503:
      return ServerException(body ?? 'خطأ في الخادم', '$statusCode');
    default:
      return NetworkException(body ?? 'خطأ في الشبكة', '$statusCode');
  }
}
