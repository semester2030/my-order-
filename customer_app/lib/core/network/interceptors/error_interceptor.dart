import 'package:dio/dio.dart';
import '../../errors/network_exceptions.dart';

/// Interceptor for handling and transforming errors
class ErrorInterceptor extends Interceptor {
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
          message: data?['message'] ?? 'Bad request.',
        );

      case 401:
        return NetworkException.unauthorized(
          message: data?['message'] ?? 'Unauthorized. Please login again.',
        );

      case 403:
        return NetworkException.forbidden(
          message: data?['message'] ?? 'Access forbidden.',
        );

      case 404:
        return NetworkException.notFound(
          message: data?['message'] ?? 'Resource not found.',
        );

      case 409:
        return NetworkException.conflict(
          message: data?['message'] ?? 'Conflict occurred.',
        );

      case 422:
        return NetworkException.validationError(
          message: data?['message'] ?? 'Validation error.',
          errors: data?['errors'],
        );

      case 500:
      case 502:
      case 503:
        return NetworkException.serverError(
          message: data?['message'] ?? 'Server error. Please try again later.',
        );

      default:
        return NetworkException.unknown(
          message: data?['message'] ?? 'An error occurred.',
        );
    }
  }
}
