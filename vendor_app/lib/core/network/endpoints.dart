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

  // Services — في الباكند هي عناصر القائمة (menu) وليست مسار /services
  static const String vendorsServices = '/vendors/menu';
  static String vendorServiceById(String id) => '/vendors/menu/$id';

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

  /// طلبات حجز طبخ الذبائح والشواء (للمورّدين popular_cooking / grilling).
  static const String vendorsChefBookingRequests = '/vendors/chef-booking-requests';
  static String vendorChefBookingRequestAccept(String id) =>
      '/vendors/chef-booking-requests/$id/accept';
  static String vendorChefBookingRequestReject(String id) =>
      '/vendors/chef-booking-requests/$id/reject';

  /// طلبات الطبخ المنزلي (عرض سعر / رفض / جاهز).
  static const String vendorsHomeCookingRequests = '/vendors/home-cooking-requests';
  static String vendorHomeCookingQuote(String id) =>
      '/vendors/home-cooking-requests/$id/quote';
  static String vendorHomeCookingReject(String id) =>
      '/vendors/home-cooking-requests/$id/reject';
  static String vendorHomeCookingMarkReady(String id) =>
      '/vendors/home-cooking-requests/$id/mark-ready';
  static String vendorHomeCookingMarkHandedOver(String id) =>
      '/vendors/home-cooking-requests/$id/mark-handed-over';

  // Health (optional)
  static const String health = '/health';
}
