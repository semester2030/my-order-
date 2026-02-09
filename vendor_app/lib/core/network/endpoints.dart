import '../config/env.dart';

/// API endpoints for Vendor App (paths only; base URL from [Env]).
class Endpoints {
  Endpoints._();

  static String get baseUrl => Env.apiBaseUrl;

  // Auth
  static const String authVendorLogin = '/auth/vendor/login';
  static const String authRefresh = '/auth/refresh';
  static const String vendorsRegister = '/vendors/register';

  // Profile
  static const String vendorsProfile = '/vendors/profile';
  static const String vendorsChangePassword = '/vendors/change-password';

  // Orders
  static const String vendorsOrders = '/vendors/orders';
  static String vendorOrderById(String id) => '/vendors/orders/$id';

  // Menu
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
  static const String videosVendorList = '/videos/vendor';
  static const String videosVendorCount = '/videos/vendor/count';
  static String videosDelete(String videoId) => '/videos/$videoId';

  // Health (optional)
  static const String health = '/health';
}
