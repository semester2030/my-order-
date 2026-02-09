import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import 'guards.dart';
import '../di/providers.dart';
import '../../../modules/auth/presentation/screens/splash_screen.dart';
import '../../../modules/auth/presentation/screens/welcome_screen.dart';
import '../../../modules/auth/presentation/screens/phone_screen.dart';
import '../../../modules/auth/presentation/screens/otp_screen.dart';
import '../../../modules/auth/presentation/screens/pin_setup_screen.dart';
import '../../../modules/auth/presentation/screens/pin_verification_screen.dart';
import '../../../modules/registration/presentation/screens/register_step1_screen.dart';
import '../../../modules/registration/presentation/screens/register_step2_screen.dart';
import '../../../modules/registration/presentation/screens/register_step3_screen.dart';
import '../../../modules/registration/presentation/screens/track_application_screen.dart';
import '../../../modules/delivery/presentation/screens/active_delivery_screen.dart';
import '../../../modules/delivery/presentation/screens/navigate_to_restaurant_screen.dart';
import '../../../modules/delivery/presentation/screens/pickup_screen.dart';
import '../../../modules/delivery/presentation/screens/navigate_to_customer_screen.dart';
import '../../../modules/delivery/presentation/screens/delivered_screen.dart';
import '../../../modules/driver_profile/presentation/screens/profile_screen.dart';
import '../../../modules/driver_profile/presentation/screens/language_settings_screen.dart';
import '../../../modules/driver_profile/presentation/screens/notification_settings_screen.dart';
import '../../../modules/driver_profile/presentation/screens/help_screen.dart';
import '../../../modules/jobs/presentation/screens/jobs_screen.dart';
import '../../../shell/main_shell.dart';

/// App router configuration
final routerProvider = Provider<GoRouter>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final authGuard = AuthGuard(secureStorage: secureStorage);

  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Welcome
      GoRoute(
        path: RouteNames.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Phone Input
      GoRoute(
        path: RouteNames.phoneInput,
        name: 'phone-input',
        builder: (context, state) => const PhoneScreen(),
      ),

      // OTP Verification
      GoRoute(
        path: RouteNames.otpVerification,
        name: 'otp-verification',
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpScreen(phone: phone);
        },
      ),

      // Registration
      GoRoute(
        path: RouteNames.registerStep1,
        name: 'register-step1',
        builder: (context, state) => const RegisterStep1Screen(),
      ),
      GoRoute(
        path: RouteNames.registerStep2,
        name: 'register-step2',
        builder: (context, state) {
          final driverId = state.extra as String? ?? '';
          return RegisterStep2Screen(driverId: driverId);
        },
      ),
      GoRoute(
        path: RouteNames.registerStep3,
        name: 'register-step3',
        builder: (context, state) {
          final driverId = state.extra as String? ?? '';
          return RegisterStep3Screen(driverId: driverId);
        },
      ),
      GoRoute(
        path: RouteNames.trackApplication,
        name: 'track-application',
        builder: (context, state) {
          final driverId = state.extra as String?;
          return TrackApplicationScreen(driverId: driverId);
        },
      ),

      // Main Shell (with nested routes)
      GoRoute(
        path: RouteNames.mainShell,
        name: 'main',
        redirect: (context, state) async {
          final redirect = await authGuard.redirectIfNotAuthenticated(context, state);
          if (redirect != null) return redirect;
          // Default to jobs screen when accessing /main (not active delivery)
          if (state.uri.path == RouteNames.mainShell) {
            return RouteNames.jobs;
          }
          return null;
        },
        builder: (context, state) => const MainShell(),
        routes: [
          // Delivery
          GoRoute(
            path: 'delivery/active',
            name: 'active-delivery',
            builder: (context, state) => const ActiveDeliveryScreen(),
          ),
          GoRoute(
            path: 'delivery/navigate-restaurant',
            name: 'navigate-restaurant',
            builder: (context, state) => const NavigateToRestaurantScreen(),
          ),
          GoRoute(
            path: 'delivery/pickup',
            name: 'pickup',
            builder: (context, state) => const PickupScreen(),
          ),
          GoRoute(
            path: 'delivery/navigate-customer',
            name: 'navigate-customer',
            builder: (context, state) => const NavigateToCustomerScreen(),
          ),
          GoRoute(
            path: 'delivery/delivered',
            name: 'delivered',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return DeliveredScreen(deliveredSummary: extra);
            },
          ),

          // Jobs
          GoRoute(
            path: 'jobs',
            name: 'jobs',
            builder: (context, state) => const JobsScreen(),
          ),

          // Profile
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'language-settings',
                name: 'language-settings',
                builder: (context, state) => const LanguageSettingsScreen(),
              ),
              GoRoute(
                path: 'notification-settings',
                name: 'notification-settings',
                builder: (context, state) => const NotificationSettingsScreen(),
              ),
              GoRoute(
                path: 'help',
                name: 'help',
                builder: (context, state) => const HelpScreen(),
              ),
            ],
          ),
        ],
      ),

      // Pin Setup
      GoRoute(
        path: RouteNames.pinSetup,
        name: 'pin-setup',
        builder: (context, state) => const PinSetupScreen(),
      ),

      // Pin Verification (for login)
      GoRoute(
        path: RouteNames.pinVerification,
        name: 'pin-verification',
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return PinVerificationScreen(phone: phone);
        },
      ),
    ],
  );
});
