import '../config/env.dart';

/// إعدادات الشبكة — baseUrl، timeouts (Phase 7).
class AppNetworkConfig {
  AppNetworkConfig._();

  static String get baseUrl => Env.apiBaseUrl;

  /// مهلة الاتصال (ميلي ثانية).
  static const int connectTimeoutMs = 30000;

  /// مهلة استقبال البيانات (ميلي ثانية).
  static const int receiveTimeoutMs = 30000;

  /// مهلة الإرسال (ميلي ثانية).
  static const int sendTimeoutMs = 30000;
}
