import 'package:dio/dio.dart';

import '../../errors/app_exception.dart';
import '../network_exceptions.dart';

/// يحوّل أخطاء Dio إلى [AppException] (Phase 7).
class ErrorInterceptor extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final statusCode = err.response?.statusCode ?? 0;
    final body = err.response?.data?.toString();
    final exception = mapStatusCodeToException(statusCode, body);
    if (statusCode == 0 &&
        (err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.sendTimeout)) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException('انتهت المهلة أو لا يوجد اتصال', null, err),
        ),
      );
    } else if (statusCode == 0) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException(
            err.message ?? 'خطأ في الاتصال',
            null,
            err,
          ),
        ),
      );
    } else {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: exception,
          response: err.response,
        ),
      );
    }
  }
}
