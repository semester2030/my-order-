import '../config/env.dart';

/// إعدادات الشبكة — baseUrl، timeouts (Phase 7).
class AppNetworkConfig {
  AppNetworkConfig._();

  static String get baseUrl => Env.apiBaseUrl;

  /// مهلة الاتصال (ميلي ثانية). 60s لاستيعاب استيقاظ Render (Free tier).
  static const int connectTimeoutMs = 60000;

  /// مهلة استقبال البيانات (ميلي ثانية).
  static const int receiveTimeoutMs = 60000;

  /// مهلة الإرسال (ميلي ثانية).
  static const int sendTimeoutMs = 30000;
}
