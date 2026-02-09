/// API endpoints constants
class Endpoints {
  Endpoints._();

  // Base URL
  // Backend runs on port 3001, Vendor Web App runs on port 3000
  // Note: For iOS Simulator, use 'http://localhost:3001/api' (Backend)
  // For physical device or if localhost doesn't work, use your Mac's IP:
  // Example: 'http://192.168.1.100:3001/api'
  // To find your Mac's IP: Run 'ipconfig getifaddr en0' in terminal
  static const String baseUrl = 'http://localhost:3001/api';

  // Auth
  static const String auth = '/auth';
  static const String requestOtp = '$auth/otp/request';
  static const String verifyOtp = '$auth/otp/verify';
  static const String setPin = '$auth/pin/set';
  static const String verifyPin = '$auth/pin/verify';
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
