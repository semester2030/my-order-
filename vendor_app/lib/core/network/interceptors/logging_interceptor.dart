import 'package:dio/dio.dart';

import '../../utils/logger.dart';

/// يسجّل الطلبات والاستجابات في وضع التطوير (Phase 7).
/// Phase 20: لا نُسجّل body ولا رؤوس Authorization لتفادي تسريب بيانات حساسة.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d(
      'HTTP ${options.method} ${options.uri}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.d(
      'HTTP ${response.statusCode} ${response.requestOptions.uri}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      'HTTP error ${err.requestOptions.uri}',
      err.error,
      err.stackTrace,
    );
    handler.next(err);
  }
}
