/// App constants
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'Driver App';
  static const String appVersion = '1.0.0';

  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration locationUpdateInterval = Duration(seconds: 5);
  static const Duration idleLocationInterval = Duration(seconds: 60);

  // Job
  static const Duration jobExpiryTime = Duration(minutes: 10);
  static const int maxRetries = 3;

  // Location
  static const double minimumDistanceForUpdate = 50.0; // meters
  static const double locationAccuracyThreshold = 100.0; // meters
}
