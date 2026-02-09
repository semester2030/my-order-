/// Storage keys constants
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

  // App preferences
  static const String isFirstLaunch = 'is_first_launch';
  static const String isDarkMode = 'is_dark_mode';
  static const String selectedLanguage = 'selected_language';

  // Location
  static const String lastKnownLatitude = 'last_known_latitude';
  static const String lastKnownLongitude = 'last_known_longitude';
  static const String defaultAddressId = 'default_address_id';

  // Video preferences
  static const String videoQuality = 'video_quality';
  static const String autoPlayVideos = 'auto_play_videos';
  static const String videoSoundEnabled = 'video_sound_enabled';
}
