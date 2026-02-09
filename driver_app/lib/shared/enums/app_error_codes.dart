/// App Error Codes
/// 
/// Standardized error codes for the application
enum AppErrorCode {
  // Network errors (1000-1999)
  networkError(1000, 'Network error'),
  timeout(1001, 'Request timeout'),
  connectionFailed(1002, 'Connection failed'),
  serverError(1003, 'Server error'),

  // Authentication errors (2000-2999)
  unauthorized(2000, 'Unauthorized'),
  forbidden(2001, 'Forbidden'),
  tokenExpired(2002, 'Token expired'),
  invalidCredentials(2003, 'Invalid credentials'),

  // Validation errors (3000-3999)
  validationError(3000, 'Validation error'),
  invalidInput(3001, 'Invalid input'),
  missingRequiredField(3002, 'Missing required field'),

  // Business logic errors (4000-4999)
  notFound(4000, 'Not found'),
  alreadyExists(4001, 'Already exists'),
  operationFailed(4002, 'Operation failed'),
  insufficientPermissions(4003, 'Insufficient permissions'),

  // Location errors (5000-5999)
  locationPermissionDenied(5000, 'Location permission denied'),
  locationServiceDisabled(5001, 'Location service disabled'),
  locationUnavailable(5002, 'Location unavailable'),

  // Unknown error
  unknown(9999, 'Unknown error');

  final int code;
  final String message;

  const AppErrorCode(this.code, this.message);

  /// Get error code from integer
  static AppErrorCode? fromCode(int code) {
    try {
      return AppErrorCode.values.firstWhere((e) => e.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Get error code from string
  static AppErrorCode? fromString(String value) {
    try {
      return AppErrorCode.values.firstWhere(
        (e) => e.name == value || e.message == value,
      );
    } catch (e) {
      return null;
    }
  }
}
