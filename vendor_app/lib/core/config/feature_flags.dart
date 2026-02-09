/// Feature flags for Vendor App (default values).
/// Can be overridden remotely or by flavor.
class FeatureFlags {
  FeatureFlags._();

  /// Show "Side Orders" in Shell for popular_cooking vendors.
  static const bool sideOrdersEnabled = true;

  /// Enable analytics module.
  static const bool analyticsEnabled = true;

  /// Enable staff module.
  static const bool staffEnabled = true;

  /// Enable video upload.
  static const bool videoUploadEnabled = true;
}
