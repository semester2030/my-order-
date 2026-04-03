/// Route path constants for Vendor App.
class RouteNames {
  RouteNames._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String pending = '/pending';
  static const String rejected = '/rejected';
  static const String shell = '/shell';
  static const String orders = '/orders';
  static String orderDetail(String id) => '/orders/$id';
  static const String menu = '/menu';
  /// شروط عرض الوجبات العامة (قبل أول إضافة وجبة).
  static const String menuOfferingTerms = '/menu/offering-terms';
  static const String menuAdd = '/menu/add';
  static String menuItemEdit(String id) => '/menu/$id/edit';
  static const String services = '/services';
  static const String servicesAdd = '/services/add';
  static String serviceItemEdit(String id) => '/services/$id/edit';
  static const String sideOrders = '/side-orders';
  static const String staff = '/staff';
  static const String staffAdd = '/staff/add';
  static String staffMemberEdit(String id) => '/staff/$id/edit';
  static const String analytics = '/analytics';
  static const String videos = '/videos';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String deleteAccount = '/delete-account';

  // المناسبات الخاصة (للمقدمين private_events)
  static const String eventOffers = '/event-offers';
  static const String eventOffersAdd = '/event-offers/add';
  static String eventOfferEdit(String id) => '/event-offers/$id/edit';
  static const String eventRequests = '/event-requests';
}
