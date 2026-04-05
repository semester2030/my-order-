import '../config/env.dart';

/// API endpoints for Vendor App (paths only; base URL from [Env]).
class Endpoints {
  Endpoints._();

  static String get baseUrl => Env.apiBaseUrl;

  // Auth
  static const String authVendorLogin = '/auth/vendor/login';
  static const String authVendorPasswordResetRequest =
      '/auth/vendor/password-reset/request';
  static const String authVendorPasswordResetConfirm =
      '/auth/vendor/password-reset/confirm';
  static const String authRefresh = '/auth/refresh';
  static const String accountDelete = '/auth/account/delete';
  static const String authVendorOnboardingStatus = '/auth/vendor/onboarding/status';
  static const String authVendorOnboardingLegalAccept =
      '/auth/vendor/onboarding/legal/accept';
  static const String authVendorOnboardingEmailRequestOtp =
      '/auth/vendor/onboarding/email/request-otp';
  static const String authVendorOnboardingEmailVerify =
      '/auth/vendor/onboarding/email/verify';
  static const String vendorsRegister = '/vendors/register';

  // Profile
  static const String vendorsProfile = '/vendors/profile';
  static const String vendorsChangePassword = '/vendors/change-password';

  // Orders
  static const String vendorsOrders = '/vendors/orders';
  static String vendorOrderById(String id) => '/vendors/orders/$id';

  // Menu
  static const String vendorsMenuOfferingTermsStatus =
      '/vendors/menu-offering-terms/status';
  static const String vendorsMenuOfferingTermsAccept =
      '/vendors/menu-offering-terms/accept';

  static const String vendorsMenu = '/vendors/menu';
  static String vendorMenuItemById(String id) => '/vendors/menu/$id';
  static String vendorMenuItemAvailability(String id) => '/vendors/menu/$id/availability';

  // Services
  static const String vendorsServices = '/vendors/services';
  static String vendorServiceById(String id) => '/vendors/services/$id';

  // Staff
  static const String vendorsStaff = '/vendors/staff';
  static String vendorStaffById(String id) => '/vendors/staff/$id';

  // Analytics
  static const String vendorsAnalytics = '/vendors/analytics';

  // Videos / Media (حد أقصى 20 مقطع لكل طباخ)
  static const String videosUploadInit = '/videos/upload/init';
  static const String videosUploadComplete = '/videos/upload/complete';
  /// رفع فيديو لصنف موجود (server-side upload → Cloudflare + video_assets)
  static String videosUploadForMenuItem(String menuItemId) => '/videos/upload/$menuItemId';
  static const String videosVendorList = '/videos/vendor';
  static const String videosVendorCount = '/videos/vendor/count';
  static String videosDelete(String videoId) => '/videos/$videoId';

  // المناسبات الخاصة
  static const String vendorsEventOffers = '/vendors/event-offers';
  static String vendorEventOfferById(String id) => '/vendors/event-offers/$id';
  static const String vendorsPrivateEventRequests = '/vendors/private-event-requests';
  static String vendorPrivateEventRequestAccept(String id) =>
      '/vendors/private-event-requests/$id/accept';
  static String vendorPrivateEventRequestReject(String id) =>
      '/vendors/private-event-requests/$id/reject';

  // Health (optional)
  static const String health = '/health';
}
