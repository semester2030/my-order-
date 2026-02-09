/// Application-wide constants for Vendor App.
class AppConstants {
  AppConstants._();

  /// Application display name.
  static const String appName = 'Vendor App';

  /// Default request timeout in seconds.
  static const int defaultTimeoutSeconds = 30;

  /// Maximum file size for uploads (in bytes) - 10 MB.
  static const int maxUploadSizeBytes = 10 * 1024 * 1024;

  /// Pagination default page size.
  static const int defaultPageSize = 20;
}
