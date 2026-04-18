/// Route names constants
class RouteNames {
  RouteNames._();

  // Auth
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String register = '/register';
  static const String login = '/login';

  // Main
  static const String home = '/home';
  static const String categories = '/categories';
  static const String feed = '/feed';

  // Cart
  static const String cart = '/cart';

  // Orders
  static const String orders = '/orders';
  static const String orderDetails = '/order-details';
  static const String orderConfirmation = '/order-confirmation';
  static const String orderCompleted = '/order-completed';
  static const String rating = '/rating';

  // Addresses
  static const String addresses = '/addresses';
  static const String addAddress = '/add-address';
  static const String selectAddressMap = '/select-address-map';

  // Profile
  static const String profile = '/profile';
  /// مركز «طلباتي»: الطبخ المنزلي + حجوزات الولائم والشوي.
  static const String myRequestsHub = '/my-requests';

  /// حجوزات طبخ الذبائح والشواء الخارجي (طلبات event-requests المصفّاة).
  static const String myChefBookings = '/my-chef-bookings';
  /// طلبات الطبخ المنزلي (عرض سعر → دفع → تحضير → جاهز).
  static const String myHomeCookingRequests = '/my-home-cooking-requests';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String privacyPolicy = '/privacy-policy';
  static const String terms = '/terms';
  static const String deleteAccount = '/delete-account';

  // Search
  static const String search = '/search';

  // Vendors / Providers (Chef)
  static const String vendorDetails = '/vendor-details';
  static const String requestChef = '/request-chef';
  static const String requestPrivateEvent = '/request-private-event';

  // Payments
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String paymentMethods = '/payment-methods';
  static const String addCard = '/add-card';
}
