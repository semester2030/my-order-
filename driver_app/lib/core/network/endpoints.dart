/// API endpoints constants for Driver App
class Endpoints {
  Endpoints._();

  // Base URL
  static const String baseUrl = 'http://localhost:3001/api';

  // Auth
  static const String auth = '/auth';
  static const String requestOtp = '$auth/otp/request';
  static const String verifyOtp = '$auth/otp/verify';
  static const String setPin = '$auth/pin/set';
  static const String verifyPin = '$auth/pin/verify';
  static const String refreshToken = '$auth/refresh';
  static const String logout = '$auth/logout';

  // Drivers
  static const String drivers = '/drivers';
  static const String registerStep1 = '$drivers/register/step1';
  static const String registerStep2 = '$drivers/register/step2/{driverId}';
  static const String registerStep3 = '$drivers/register/step3/{driverId}';
  static const String checkDriverExists = '$drivers/exists';
  static const String driverProfile = '$drivers/profile';
  static const String updateAvailability = '$drivers/availability';
  static const String trackApplication = '$drivers/track/{driverId}';

  // Jobs
  static const String jobs = '/jobs';
  static const String getInbox = '$jobs/inbox';
  static const String getActiveJob = '$jobs/active';
  static const String getHistory = '$jobs/history';
  static const String acceptJob = '$jobs/accept';
  static const String rejectJob = '$jobs/reject/{jobOfferId}';

  // Delivery
  static const String delivery = '/delivery';
  static const String getDeliveryDetails = '$delivery/{orderId}/details';
  static const String updateLocation = '$delivery/{orderId}/location';
  static const String updateDeliveryStatus = '$delivery/{orderId}/status';
  static const String trackOrder = '$delivery/tracking/{orderId}';
}
