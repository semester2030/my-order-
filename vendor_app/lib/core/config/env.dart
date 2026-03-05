/// Environment configuration for Vendor App.
/// Values can be overridden per flavor or build.
class Env {
  Env._();

  /// Base URL for API (no trailing slash).
  /// افتراضياً: https://my-order.onrender.com/api
  /// للتطوير المحلي: flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3001/api
  static String get apiBaseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (fromEnv.isNotEmpty) return fromEnv;
    return _defaultApiBaseUrl;
  }

  /// افتراضياً: Render (للاختبار والإنتاج). للتطوير المحلي: --dart-define=API_BASE_URL=http://127.0.0.1:3001/api
  static const String _defaultApiBaseUrl = 'https://my-order.onrender.com/api';

  /// Whether the app is running in debug mode.
  static bool get isDebug {
    bool result = false;
    assert(() {
      result = true;
      return true;
    }());
    return result;
  }
}
