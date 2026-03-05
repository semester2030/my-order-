import 'package:dio/dio.dart';

/// يعيد المحاولة عند انقطاع الاتصال أو مهلة زمنية (مهم لـ Render Free tier — cold start).
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    final opts = err.requestOptions;
    final attempt = opts.extra['retry_count'] as int? ?? 0;
    if (attempt >= maxRetries) {
      return handler.next(err);
    }

    opts.extra['retry_count'] = attempt + 1;
    await Future.delayed(retryDelay);

    final retryDio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ));

    try {
      final response = await retryDio.fetch(opts);
      return handler.resolve(response);
    } catch (e) {
      if (e is DioException && _shouldRetry(e)) {
        return onError(e, handler);
      }
      return handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      default:
        return false;
    }
  }
}
