import 'package:dio/dio.dart';
import '../endpoints.dart';
import '../../storage/secure_storage.dart';

/// Interceptor for adding authentication token to requests
class AuthInterceptor extends Interceptor {
  final SecureStorage secureStorage;

  AuthInterceptor({required this.secureStorage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for login/register endpoints
    if (_shouldSkipAuth(options.path)) {
      return handler.next(options);
    }

    // Get access token
    final token = await secureStorage.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - token expired or invalid
    if (err.response?.statusCode == 401) {
      // Skip refresh for auth endpoints to avoid infinite loop
      final authEndpoints = [
        '/auth/otp/request',
        '/auth/otp/verify',
        '/auth/pin/set',
        '/auth/pin/verify',
        '/auth/refresh',
        '/auth/logout',
      ];

      final isAuthEndpoint = authEndpoints.any(
        (endpoint) => err.requestOptions.path.contains(endpoint),
      );

      if (isAuthEndpoint) {
        handler.next(err);
        return;
      }

      // Try to refresh token
      final refreshToken = await secureStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Create a new Dio instance to avoid circular dependency
          final dio = Dio(BaseOptions(
            baseUrl: err.requestOptions.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));
          
          final response = await dio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200) {
            final data = response.data as Map<String, dynamic>;
            final newAccessToken = data['accessToken'] as String?;
            final newRefreshToken = data['refreshToken'] as String?;

            if (newAccessToken != null) {
              await secureStorage.saveAccessToken(newAccessToken);
              if (newRefreshToken != null) {
                await secureStorage.saveRefreshToken(newRefreshToken);
              }

              // Retry the original request with new token
              final opts = err.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newAccessToken';

              final cloneReq = await dio.request(
                opts.path,
                options: Options(
                  method: opts.method,
                  headers: opts.headers,
                ),
                data: opts.data,
                queryParameters: opts.queryParameters,
              );

              return handler.resolve(cloneReq);
            }
          }
        } catch (e) {
          // Refresh failed, clear tokens and let error propagate
          await secureStorage.delete('access_token');
          await secureStorage.delete('refresh_token');
        }
      }
    }

    handler.next(err);
  }

  bool _shouldSkipAuth(String path) {
    // Skip adding token for auth endpoints
    final authEndpoints = [
      '/auth/otp/request',
      '/auth/otp/verify',
      '/auth/pin/set',
      '/auth/pin/verify',
      '/auth/refresh',
    ];

    return authEndpoints.any(
      (endpoint) => path.contains(endpoint),
    );
  }
}
