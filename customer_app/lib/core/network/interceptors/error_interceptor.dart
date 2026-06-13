import 'package:dio/dio.dart';
import '../../errors/network_exceptions.dart';

/// Interceptor for handling and transforming errors
class ErrorInterceptor extends Interceptor {
  static String messageFromBody(dynamic data, {String fallback = 'An error occurred.'}) {
    if (data is! Map) return fallback;
    final msg = data['message'];
    if (msg is String && msg.trim().isNotEmpty) return msg;
    if (msg is List && msg.isNotEmpty) {
      return msg.map((e) => e.toString()).join('\n');
    }
    return fallback;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final networkException = _handleDioError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: networkException,
        type: err.type,
        response: err.response,
      ),
    );
  }

  NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException.timeout(
          message: 'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return NetworkException.cancel(
          message: 'Request was cancelled.',
        );

      case DioExceptionType.unknown:
      default:
        if (error.error is NetworkException) {
          return error.error as NetworkException;
        }
        return NetworkException.unknown(
          message: error.message ?? 'An unknown error occurred.',
        );
    }
  }

  NetworkException _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    switch (statusCode) {
      case 400:
        return NetworkException.badRequest(
          message: messageFromBody(data, fallback: 'Bad request.'),
        );

      case 401:
        return NetworkException.unauthorized(
          message: messageFromBody(data, fallback: 'Unauthorized. Please login again.'),
        );

      case 403:
        return NetworkException.forbidden(
          message: messageFromBody(data, fallback: 'Access forbidden.'),
        );

      case 404:
        return NetworkException.notFound(
          message: messageFromBody(data, fallback: 'Resource not found.'),
        );

      case 409:
        return NetworkException.conflict(
          message: messageFromBody(data, fallback: 'Conflict occurred.'),
        );

      case 422:
        return NetworkException.validationError(
          message: messageFromBody(data, fallback: 'Validation error.'),
          errors: data is Map ? data['errors'] : null,
        );

      case 500:
      case 502:
      case 503:
        return NetworkException.serverError(
          message: messageFromBody(data, fallback: 'Server error. Please try again later.'),
        );

      default:
        return NetworkException.unknown(
          message: messageFromBody(data),
        );
    }
  }
}
