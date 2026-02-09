import 'package:dio/dio.dart';

import '../../storage/storage_keys.dart';
import '../../storage/secure_storage.dart';
import '../endpoints.dart';

/// عند 401 يحاول تجديد التوكن ثم إعادة الطلب (Phase 17).
class RefreshInterceptor extends QueuedInterceptor {
  RefreshInterceptor(this._dio, this._secureStorage);

  final Dio _dio;
  final SecureStorage _secureStorage;

  static bool _isRefreshPath(String path) {
    return path.contains(Endpoints.authRefresh);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode ?? 0;
    if (statusCode != 401 || _isRefreshPath(err.requestOptions.path)) {
      handler.next(err);
      return;
    }

    final refreshToken = await _secureStorage.read(StorageKeys.refreshToken);
    if (refreshToken == null || refreshToken.isEmpty) {
      await _secureStorage.write(StorageKeys.accessToken, null);
      await _secureStorage.write(StorageKeys.refreshToken, null);
      handler.next(err);
      return;
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        Endpoints.authRefresh,
        data: <String, dynamic>{'refreshToken': refreshToken},
      );
      final data = response.data;
      if (data != null &&
          data['accessToken'] != null &&
          data['refreshToken'] != null) {
        await _secureStorage.write(
          StorageKeys.accessToken,
          data['accessToken'] as String,
        );
        await _secureStorage.write(
          StorageKeys.refreshToken,
          data['refreshToken'] as String,
        );
        final opts = err.requestOptions;
        opts.headers['Authorization'] =
            'Bearer ${data['accessToken'] as String}';
        final result = await _dio.fetch(opts);
        handler.resolve(
          Response(
            requestOptions: opts,
            data: result.data,
            statusCode: result.statusCode,
          ),
        );
        return;
      }
    } catch (_) {
      await _secureStorage.write(StorageKeys.accessToken, null);
      await _secureStorage.write(StorageKeys.refreshToken, null);
    }
    handler.next(err);
  }
}
