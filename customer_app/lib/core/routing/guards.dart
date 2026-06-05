import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/guest_mode_keys.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import 'guest_routes.dart';
import 'route_names.dart';

/// Route guards for authentication and guest browsing.
class AuthGuard {
  AuthGuard({
    required this.secureStorage,
    required this.localStorage,
  });

  final SecureStorage secureStorage;
  final LocalStorage localStorage;

  Future<bool> isAuthenticated() async {
    final token = await secureStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<bool> isGuestBrowsing() async {
    if (await isAuthenticated()) return false;
    return await localStorage.getBool(GuestModeKeys.browsing) == true;
  }

  Future<String?> redirectIfNotAuthenticated(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (await isAuthenticated()) return null;

    final path = state.uri.path;
    if (path == RouteNames.register || path == RouteNames.login) {
      return null;
    }

    if (await isGuestBrowsing() && GuestRoutes.isAllowed(path)) {
      return null;
    }

    return RouteNames.welcome;
  }

  Future<String?> redirectIfAuthenticated(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (await isAuthenticated()) {
      if (state.uri.path == RouteNames.register ||
          state.uri.path == RouteNames.login ||
          state.uri.path == RouteNames.splash) {
        return RouteNames.categories;
      }
    }

    return null;
  }
}
