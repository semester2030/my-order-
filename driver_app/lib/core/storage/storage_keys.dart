/// Storage keys constants for Driver App
class StorageKeys {
  StorageKeys._();

  // Auth tokens
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String pinHash = 'pin_hash';

  // User data
  static const String userId = 'user_id';
  static const String userPhone = 'user_phone';
  static const String userName = 'user_name';
  static const String driverId = 'driver_id';

  // App preferences
  static const String isFirstLaunch = 'is_first_launch';
  static const String isDarkMode = 'is_dark_mode';
  static const String selectedLanguage = 'selected_language';

  // Driver-specific
  static const String isOnline = 'is_online';
  static const String lastKnownLatitude = 'last_known_latitude';
  static const String lastKnownLongitude = 'last_known_longitude';
  static const String fcmToken = 'fcm_token';
  
  // Notifications
  static const String notifications = 'notifications';
}
