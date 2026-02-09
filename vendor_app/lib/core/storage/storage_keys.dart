/// Storage keys for Vendor App (secure and local).
class StorageKeys {
  StorageKeys._();

  /// Access token (secure).
  static const String accessToken = 'vendor_app_access_token';

  /// Refresh token (secure).
  static const String refreshToken = 'vendor_app_refresh_token';

  /// Selected locale (e.g. 'ar', 'en').
  static const String locale = 'vendor_app_locale';

  /// User ID or vendor ID after login (local).
  static const String userId = 'vendor_app_user_id';

  /// Onboarding / first launch flag (local).
  static const String hasCompletedOnboarding = 'vendor_app_onboarding_done';
}
