import 'package:dio/dio.dart';

import 'app_network_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/refresh_interceptor.dart';
import '../storage/secure_storage.dart';
import '../config/env.dart';

/// عميل HTTP مبني على Dio — Phase 7؛ Phase 17: + refresh عند 401.
Dio createApiClient(SecureStorage secureStorage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppNetworkConfig.baseUrl,
      connectTimeout: Duration(milliseconds: AppNetworkConfig.connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: AppNetworkConfig.receiveTimeoutMs),
      sendTimeout: Duration(milliseconds: AppNetworkConfig.sendTimeoutMs),
      headers: <String, dynamic>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
  dio.interceptors.addAll([
    AuthInterceptor(secureStorage),
    ErrorInterceptor(),
    RefreshInterceptor(dio, secureStorage),
    if (Env.isDebug) LoggingInterceptor(),
  ]);
  return dio;
}
