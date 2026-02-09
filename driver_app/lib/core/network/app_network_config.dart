/// Network Configuration for Driver App
/// 
/// Driver-specific network settings:
/// - Longer timeouts (network may be unstable while driving)
/// - More retries for critical operations
/// - Different retry policies based on operation type
class AppNetworkConfig {
  AppNetworkConfig._();

  // Base URL
  static const String baseUrl = 'http://localhost:3001/api';

  // Timeouts (longer for driver)
  static const Duration connectTimeout = Duration(seconds: 60);  // ⚠️ Longer (vs 30s)
  static const Duration receiveTimeout = Duration(seconds: 60);  // ⚠️ Longer (vs 30s)
  static const Duration sendTimeout = Duration(seconds: 60);

  // Retry Configuration
  static const int defaultRetryCount = 3;  // ⚠️ More retries (vs 2)

  // Retry Policies (per operation type)
  static const int locationUpdateRetryCount = 1;  // ⚠️ Fire-and-forget (next update will cover)
  static const int acceptJobRetryCount = 3;       // ✅ Critical - retry more
  static const int statusUpdateRetryCount = 3;    // ✅ Critical - retry more
  static const int getActiveJobRetryCount = 2;    // ⚠️ Simple - retry less

  // Log Level
  static const bool enableLogging = true;
}
