/// API endpoints constants
class Endpoints {
  Endpoints._();

  /// Base URL للـ API.
  /// افتراضياً: localhost للتطوير (OTP + Resend يعملان محلياً).
  /// للربط مع Render: flutter run --dart-define=API_BASE_URL=https://my-order.onrender.com/api
  static String get baseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (fromEnv.isNotEmpty) return fromEnv;
    return 'http://localhost:3001/api';
  }

  // Auth
  static const String auth = '/auth';
  static const String customerRegister = '$auth/customer/register';
  static const String customerLogin = '$auth/customer/login';
  static const String refreshToken = '$auth/refresh';
  static const String logout = '$auth/logout';

  // Users
  static const String users = '/users';
  static const String userProfile = '$users/profile';

  // Addresses
  static const String addresses = '/addresses';
  static const String getAddresses = addresses;
  static const String addAddress = addresses;
  static const String updateAddress = '$addresses/{id}';
  static const String deleteAddress = '$addresses/{id}';

  // Feed
  static const String feed = '/feed';

  // Cart
  static const String cart = '/cart';
  static const String getCart = cart;
  static const String addToCart = '$cart/add';
  static const String updateCartItem = '$cart/update/{id}';
  static const String removeCartItem = '$cart/remove/{id}';
  static const String clearCart = '$cart/clear';

  // Orders
  static const String orders = '/orders';
  static const String createOrder = orders;
  static const String getOrders = orders;
  static const String getOrderDetails = '$orders/{id}';
  static const String cancelOrder = '$orders/{id}';

  // Payments
  static const String payments = '/payments';
  static const String initiatePayment = '$payments/initiate';
  static const String confirmPayment = '$payments/confirm';
  static const String getPayment = '$payments/{id}';
  static const String getOrderPayments = '$payments/order/{orderId}';

  // Vendors
  static const String vendors = '/vendors';
  static const String getVendors = vendors;
  static const String getVendorDetails = '$vendors/{id}';

  // Search
  static const String search = '/search';
  static const String searchVendors = '$search/vendors';

  // Menu
  static const String menu = '/menu';
  static const String getVendorMenu = '$menu/vendor/{vendorId}';
  static const String getSignatureItems = '$menu/signature/{vendorId}';

  // Videos
  static const String videos = '/videos';
  static const String uploadInit = '$videos/upload/init';
  static const String uploadComplete = '$videos/upload/complete';
}
