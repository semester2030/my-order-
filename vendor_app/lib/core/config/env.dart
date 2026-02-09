/// Environment configuration for Vendor App.
/// Values can be overridden per flavor or build.
class Env {
  Env._();

  /// Base URL for API (no trailing slash).
  /// المحاكي يصل لـ localhost؛ الباك اند NestJS على 3001 والمسارات تحت /api.
  /// على جهاز حقيقي (آيفون): 127.0.0.1 = الآيفون نفسه → Connection refused.
  /// استخدم عنوان الماك على الشبكة أو السيرفر المنشور:
  ///   flutter run --release -d <device> --dart-define=API_BASE_URL=http://192.168.x.x:3001/api
  ///   أو: --dart-define=API_BASE_URL=https://api.yourserver.com/api
  static String get apiBaseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (fromEnv.isNotEmpty) return fromEnv;
    return _defaultApiBaseUrl;
  }

  /// للاستخدام على المحاكي فقط. على الجهاز الحقيقي مرّر API_BASE_URL أعلاه.
  static const String _defaultApiBaseUrl = 'http://127.0.0.1:3001/api';

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
