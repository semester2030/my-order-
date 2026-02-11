import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../di/providers.dart';
import 'route_names.dart';
import 'guards.dart';
import '../../../modules/auth/presentation/screens/splash_screen.dart';
import '../../../modules/auth/presentation/screens/welcome_screen.dart';
import '../../../modules/auth/presentation/screens/register_screen.dart';
import '../../../modules/auth/presentation/screens/login_screen.dart';
import '../../../modules/categories/presentation/screens/categories_screen.dart';
import '../../../modules/feed/presentation/screens/feed_screen.dart';
import '../../../modules/cart/presentation/screens/cart_screen.dart';
import '../../../modules/orders/presentation/screens/orders_screen.dart';
import '../../../modules/orders/presentation/screens/order_tracking_screen.dart';
import '../../../modules/orders/presentation/screens/order_confirmation_screen.dart';
import '../../../modules/orders/presentation/screens/order_completed_screen.dart';
import '../../../modules/orders/presentation/screens/rating_screen.dart';
import '../../../modules/payments/presentation/screens/payment_screen.dart';
import '../../../modules/payments/presentation/screens/add_card_screen.dart';
import '../../../modules/addresses/presentation/screens/select_address_map_screen.dart';
import '../../../modules/vendors/presentation/screens/vendor_screen.dart';
import '../../../modules/vendors/presentation/screens/vendor_reviews_screen.dart';
import '../../../modules/vendors/presentation/screens/request_chef_screen.dart';
import '../../../modules/profile/presentation/screens/profile_screen.dart';
import '../../../modules/profile/presentation/screens/edit_name_screen.dart';
import '../../../modules/profile/presentation/screens/settings_screen.dart';
import '../../../modules/addresses/presentation/screens/addresses_list_screen.dart';
import '../../../modules/payments/presentation/screens/payment_methods_screen.dart';
import '../../../modules/search/presentation/screens/search_screen.dart';

/// App router configuration
final routerProvider = Provider<GoRouter>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final authGuard = AuthGuard(secureStorage: secureStorage);

  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final path = state.uri.path;
      final isAuth = await authGuard.isAuthenticated();
      final isSplash = path == RouteNames.splash;
      final isAuthRoute = path == RouteNames.welcome ||
          path == RouteNames.register ||
          path == RouteNames.login;
      if (isSplash || isAuthRoute) return null;
      if (!isAuth) return RouteNames.splash;
      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      // Welcome
      GoRoute(
        path: RouteNames.welcome,
        name: 'welcome',
        builder: (context, state) {
          return const WelcomeScreen();
        },
      ),

      // Auth routes
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Main routes (protected)
      GoRoute(
        path: RouteNames.categories,
        name: 'categories',
        builder: (context, state) {
          return const CategoriesScreen();
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),
      GoRoute(
        path: RouteNames.feed,
        name: 'feed',
        builder: (context, state) {
          final category = state.uri.queryParameters['category'];
          return FeedScreen(category: category);
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),

      GoRoute(
        path: RouteNames.cart,
        name: 'cart',
        builder: (context, state) {
          return const CartScreen();
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),

      GoRoute(
        path: RouteNames.orders,
        name: 'orders',
        builder: (context, state) {
          return const OrdersScreen();
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),

      GoRoute(
        path: '${RouteNames.orderDetails}/:id',
        name: 'order-details',
        builder: (context, state) {
          final orderId = state.pathParameters['id'] ?? '';
          return OrderTrackingScreen(orderId: orderId);
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),

      GoRoute(
        path: '${RouteNames.orderConfirmation}/:id',
        name: 'order-confirmation',
        builder: (context, state) {
          final orderId = state.pathParameters['id'] ?? '';
          return OrderConfirmationScreen(orderId: orderId);
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),

      GoRoute(
        path: '${RouteNames.orderCompleted}/:id',
        name: 'order-completed',
        builder: (context, state) {
          final orderId = state.pathParameters['id'] ?? '';
          return OrderCompletedScreen(orderId: orderId);
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),

      GoRoute(
        path: '${RouteNames.rating}/:orderId',
        name: 'rating',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'] ?? '';
          return RatingScreen(orderId: orderId);
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),

      // Payment
      GoRoute(
        path: '${RouteNames.payment}/:orderId',
        name: 'payment',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'] ?? '';
          final amount = (state.extra as Map<String, dynamic>?)?['amount'] as double? ?? 0.0;
          return PaymentScreen(orderId: orderId, amount: amount);
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),
      GoRoute(
        path: RouteNames.paymentMethods,
        name: 'payment-methods',
        builder: (context, state) {
          return const PaymentMethodsScreen();
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),
      GoRoute(
        path: RouteNames.addCard,
        name: 'add-card',
        builder: (context, state) {
          return const AddCardScreen();
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),

      // Addresses
      GoRoute(
        path: RouteNames.addresses,
        name: 'addresses',
        builder: (context, state) {
          return const AddressesListScreen();
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),
      GoRoute(
        path: RouteNames.selectAddressMap,
        name: 'select-address-map',
        builder: (context, state) {
          return const SelectAddressMapScreen();
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),

      // Vendors
      GoRoute(
        path: '${RouteNames.vendorDetails}/:id',
        name: 'vendor-details',
        builder: (context, state) {
          final vendorId = state.pathParameters['id'] ?? '';
          return VendorScreen(vendorId: vendorId);
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),
      GoRoute(
        path: '${RouteNames.requestChef}/:id',
        name: 'request-chef',
        builder: (context, state) {
          final vendorId = state.pathParameters['id'] ?? '';
          return RequestChefScreen(vendorId: vendorId);
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),
      GoRoute(
        path: '${RouteNames.vendorDetails}/:id/reviews',
        name: 'vendor-reviews',
        builder: (context, state) {
          final vendorId = state.pathParameters['id'] ?? '';
          return VendorReviewsScreen(vendorId: vendorId);
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),

      // Profile
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        builder: (context, state) {
          return const ProfileScreen();
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),

      GoRoute(
        path: RouteNames.editProfile,
        name: 'edit-profile',
        builder: (context, state) {
          return const EditNameScreen();
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        builder: (context, state) {
          return const SettingsScreen();
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),

      // Search
      GoRoute(
        path: RouteNames.search,
        name: 'search',
        builder: (context, state) {
          return const SearchScreen();
        },
        redirect: (context, state) async {
          return await authGuard.redirectIfNotAuthenticated(context, state);
        },
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text('Error: ${state.error}'),
        ),
      );
    },
  );
});
