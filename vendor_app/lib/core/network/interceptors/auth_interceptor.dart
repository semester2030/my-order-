import 'package:dio/dio.dart';

import '../../storage/storage_keys.dart';
import '../../storage/secure_storage.dart';
import '../endpoints.dart';

/// يضيف رأس Authorization من التوكن المحفوظ (Phase 7).
/// لا يضيف التوكن لـ login و refresh (Phase 17).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final SecureStorage _secureStorage;

  static bool _isAuthPath(String path) {
    return path.contains(Endpoints.authVendorLogin) ||
        path.contains(Endpoints.authRefresh);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isAuthPath(options.path)) {
      handler.next(options);
      return;
    }
    final token = await _secureStorage.read(StorageKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
