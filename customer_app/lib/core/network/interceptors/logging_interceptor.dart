import 'package:dio/dio.dart';
import '../../utils/logger.dart';

/// Interceptor for logging HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d(
      'REQUEST[${options.method}] => PATH: ${options.path}',
    );
    if (options.queryParameters.isNotEmpty) {
      AppLogger.d('QueryParameters: ${options.queryParameters}');
    }
    if (options.data != null) {
      AppLogger.d('Data: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.d(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    AppLogger.d('Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    AppLogger.e('Message: ${err.message}');
    if (err.response?.data != null) {
      AppLogger.e('Error Data: ${err.response?.data}');
    }
    handler.next(err);
  }
}
