import 'route_names.dart';

/// مسارات يسمح للزائر بفتحها بدون تسجيل (متطلب App Store).
abstract final class GuestRoutes {
  static bool isAllowed(String path) {
    if (path == RouteNames.splash ||
        path == RouteNames.welcome ||
        path == RouteNames.login ||
        path == RouteNames.register) {
      return true;
    }
    if (path == RouteNames.categories) return true;
    if (path == RouteNames.feed || path.startsWith('${RouteNames.feed}?')) {
      return true;
    }
    if (path == RouteNames.profile) return true;
    if (path == RouteNames.privacyPolicy || path == RouteNames.terms) {
      return true;
    }
    if (path.startsWith('${RouteNames.vendorDetails}/')) return true;
    return false;
  }

  /// يتطلب حساباً — يُستخدم لاعتراض الحجز والطلب.
  static bool requiresAuth(String path) {
    if (path.startsWith('${RouteNames.requestChef}/')) return true;
    if (path.startsWith('${RouteNames.requestPrivateEvent}/')) return true;
    if (path.startsWith(RouteNames.myRequestsHub)) return true;
    if (path.startsWith(RouteNames.myChefBookings)) return true;
    if (path.startsWith(RouteNames.myHomeCookingRequests)) return true;
    if (path.startsWith(RouteNames.cart)) return true;
    if (path.startsWith(RouteNames.orders)) return true;
    if (path.startsWith(RouteNames.payment)) return true;
    if (path.startsWith(RouteNames.addresses)) return true;
    return false;
  }
}
