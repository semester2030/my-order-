import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';
import '../storage/storage_keys.dart';
import '../di/providers.dart';
import '../../modules/auth/presentation/screens/login_screen.dart';
import '../../modules/auth/presentation/screens/pending_screen.dart';
import '../../modules/auth/presentation/screens/register_screen.dart';
import '../../modules/auth/presentation/screens/rejected_screen.dart';
import '../../modules/auth/presentation/screens/splash_screen.dart';
import '../../modules/profile/presentation/screens/change_password_screen.dart';
import '../../modules/profile/presentation/screens/edit_profile_screen.dart';
import '../../modules/orders/presentation/screens/order_detail_screen.dart';
import '../../modules/menu/presentation/screens/add_menu_item_screen.dart';
import '../../modules/menu/presentation/screens/edit_menu_item_screen.dart';
import '../../modules/services/presentation/screens/add_service_screen.dart';
import '../../modules/services/presentation/screens/edit_service_screen.dart';
import '../../modules/analytics/presentation/screens/analytics_screen.dart';
import '../../modules/videos/presentation/screens/videos_screen.dart';
import '../../modules/side_orders/presentation/screens/side_orders_screen.dart';
import '../../modules/staff/presentation/screens/add_staff_screen.dart';
import '../../modules/staff/presentation/screens/edit_staff_screen.dart';
import '../../modules/shell/presentation/screens/shell_screen.dart';

/// Builds GoRouter for Vendor App (Phase 7: + redirect guards).
GoRouter createAppRouter(Ref ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: false,
    redirect: (BuildContext context, GoRouterState state) async {
      final path = state.uri.path;
      final isProtected = path == RouteNames.shell ||
          path.startsWith('${RouteNames.shell}/') ||
          path == RouteNames.orders ||
          path.startsWith('${RouteNames.orders}/') ||
          path == RouteNames.menu ||
          path.startsWith('${RouteNames.menu}/') ||
          path == RouteNames.services ||
          path.startsWith('${RouteNames.services}/') ||
          path == RouteNames.sideOrders ||
          path == RouteNames.staff ||
          path.startsWith('${RouteNames.staff}/') ||
          path == RouteNames.analytics ||
          path == RouteNames.videos ||
          path == RouteNames.editProfile ||
          path == RouteNames.changePassword;
      if (!isProtected) return null;
      try {
        final secureStorage = ref.read(secureStorageProvider);
        final token = await secureStorage.read(StorageKeys.accessToken);
        if (token == null || token.isEmpty) return RouteNames.login;
      } catch (_) {
        return RouteNames.login;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.pending,
        name: 'pending',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const PendingScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.rejected,
        name: 'rejected',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const RejectedScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.shell,
        name: 'shell',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const ShellScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: 'editProfile',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        name: 'changePassword',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const ChangePasswordScreen(),
        ),
      ),
      GoRoute(
        path: '/orders/:id',
        name: 'orderDetail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MaterialPage<void>(
            key: state.pageKey,
            child: OrderDetailScreen(orderId: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.menuAdd,
        name: 'menuAdd',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const AddMenuItemScreen(),
        ),
      ),
      GoRoute(
        path: '/menu/:id/edit',
        name: 'menuItemEdit',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MaterialPage<void>(
            key: state.pageKey,
            child: EditMenuItemScreen(itemId: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.servicesAdd,
        name: 'servicesAdd',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const AddServiceScreen(),
        ),
      ),
      GoRoute(
        path: '/services/:id/edit',
        name: 'serviceItemEdit',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MaterialPage<void>(
            key: state.pageKey,
            child: EditServiceScreen(itemId: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.sideOrders,
        name: 'sideOrders',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const SideOrdersScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.staffAdd,
        name: 'staffAdd',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const AddStaffScreen(),
        ),
      ),
      GoRoute(
        path: '/staff/:id/edit',
        name: 'staffMemberEdit',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MaterialPage<void>(
            key: state.pageKey,
            child: EditStaffScreen(memberId: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.analytics,
        name: 'analytics',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const AnalyticsScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.videos,
        name: 'videos',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const VideosScreen(),
        ),
      ),
    ],
  );
}
