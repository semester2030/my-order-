/// API endpoints constants
class Endpoints {
  Endpoints._();

  /// Base URL للـ API.
  /// افتراضياً: Render (للاختبار والإنتاج).
  /// للتطوير المحلي: flutter run --dart-define=API_BASE_URL=http://localhost:3001/api
  static String get baseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (fromEnv.isNotEmpty) return fromEnv;
    return 'https://my-order.onrender.com/api';
  }

  /// أصل الخادم بدون لاحقة `/api` — لروابط الملفات الثابتة مثل `/uploads/...`.
  static String get publicOrigin {
    final b = baseUrl.trimRight();
    if (b.endsWith('/api')) return b.substring(0, b.length - 4);
    if (b.endsWith('/api/')) return b.substring(0, b.length - 5);
    try {
      final u = Uri.parse(b);
      final segs = u.pathSegments;
      if (segs.isNotEmpty && segs.last == 'api') {
        return u.resolve('../').toString().replaceAll(RegExp(r'/$'), '');
      }
    } catch (_) {}
    return b;
  }

  /// يحوّل قيمة `image` من الـ API (اسم ملف أو مسار نسبي أو URL كامل) إلى URL جاهز للعرض.
  static String? resolveMenuImageUrl(String? raw) {
    if (raw == null) return null;
    final t = raw.trim();
    if (t.isEmpty) return null;
    if (t.startsWith('http://') || t.startsWith('https://')) return t;
    final origin = publicOrigin;
    if (t.startsWith('/')) return '$origin$t';
    return '$origin/uploads/$t';
  }

  // Auth
  static const String auth = '/auth';
  static const String customerRegister = '$auth/customer/register';
  static const String customerLogin = '$auth/customer/login';
  static const String refreshToken = '$auth/refresh';
  static const String logout = '$auth/logout';
  static const String accountDelete = '$auth/account/delete';

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
  static const String initiateHomeCookingCardPayment =
      '$payments/initiate-home-cooking';
  static const String confirmPayment = '$payments/confirm';
  static const String getPayment = '$payments/{id}';
  static const String getOrderPayments = '$payments/order/{orderId}';
  static const String savedPaymentMethods = '$payments/saved-methods';
  static String savedPaymentMethodById(String id) =>
      '$payments/saved-methods/$id';

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

  // Event Requests (احجز الطباخ / طلب طباخة)
  static const String eventRequests = '/event-requests';
  static const String createEventRequest = eventRequests;
  static const String listMyEventRequests = eventRequests;
  static String eventRequestById(String id) => '$eventRequests/$id';
  static String declareHomeCookingPayment(String id) =>
      '$eventRequests/$id/declare-home-cooking-payment';
  static String confirmHomeCookingReceipt(String id) =>
      '$eventRequests/$id/confirm-home-cooking-receipt';
  static String cancelEventRequest(String id) => '$eventRequests/$id/cancel';
  static String confirmChefServiceCompletion(String id) =>
      '$eventRequests/$id/confirm-service-completion';

  /// تجربة الخدمة: تقييمات عامة + بلاغات (مصدر واحد للطلبات وحجوزات الطبّاخ)
  static const String serviceExperience = '/service-experience';
  static const String serviceExperienceReviews = '$serviceExperience/reviews';
  static const String serviceExperienceQualityTickets =
      '$serviceExperience/quality-tickets';
  static String publicVendorServiceReviews(String vendorId) =>
      '$serviceExperience/public/vendors/$vendorId/reviews';

  // Private Event Requests (المناسبات الخاصة)
  static const String privateEventRequests = '/private-event-requests';
  static String vendorEventOffers(String vendorId) => '$vendors/$vendorId/event-offers';

  // Videos
  static const String videos = '/videos';
  static const String uploadInit = '$videos/upload/init';
  static const String uploadComplete = '$videos/upload/complete';
}
