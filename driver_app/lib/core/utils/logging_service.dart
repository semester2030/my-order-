import 'package:flutter/foundation.dart';

/// Logging Service
/// 
/// Provides unified logging across the app
class LoggingService {
  static const String _tag = '[DriverApp]';

  /// Log debug message
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('$_tag [DEBUG] $message');
      if (error != null) {
        debugPrint('$_tag [ERROR] $error');
        if (stackTrace != null) {
          debugPrint('$_tag [STACK] $stackTrace');
        }
      }
    }
  }

  /// Log info message
  static void info(String message) {
    if (kDebugMode) {
      debugPrint('$_tag [INFO] $message');
    }
  }

  /// Log warning message
  static void warning(String message, [Object? error]) {
    if (kDebugMode) {
      debugPrint('$_tag [WARNING] $message');
      if (error != null) {
        debugPrint('$_tag [ERROR] $error');
      }
    }
  }

  /// Log error message
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('$_tag [ERROR] $message');
      if (error != null) {
        debugPrint('$_tag [ERROR DETAILS] $error');
        if (stackTrace != null) {
          debugPrint('$_tag [STACK TRACE] $stackTrace');
        }
      }
    }
  }

  /// Log network request
  static void network(String method, String url, [Map<String, dynamic>? data]) {
    if (kDebugMode) {
      debugPrint('$_tag [NETWORK] $method $url');
      if (data != null) {
        debugPrint('$_tag [NETWORK DATA] $data');
      }
    }
  }

  /// Log location update
  static void location(double latitude, double longitude) {
    if (kDebugMode) {
      debugPrint('$_tag [LOCATION] lat: $latitude, lng: $longitude');
    }
  }
}
