import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../storage/secure_storage.dart';
import 'route_names.dart';

/// Route guards for authentication
class AuthGuard {
  final SecureStorage secureStorage;

  AuthGuard({required this.secureStorage});

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await secureStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Redirect to login if not authenticated
  Future<String?> redirectIfNotAuthenticated(
    BuildContext context,
    GoRouterState state,
  ) async {
    final isAuth = await isAuthenticated();

    if (!isAuth) {
      if (state.uri.path == RouteNames.register || state.uri.path == RouteNames.login) {
        return null;
      }
      return RouteNames.welcome;
    }

    return null; // Allow navigation
  }

  /// Redirect to home if authenticated
  Future<String?> redirectIfAuthenticated(
    BuildContext context,
    GoRouterState state,
  ) async {
    final isAuth = await isAuthenticated();

    if (isAuth) {
      if (state.uri.path == RouteNames.register ||
          state.uri.path == RouteNames.login ||
          state.uri.path == RouteNames.splash) {
        return RouteNames.categories;
      }
    }

    return null; // Allow navigation
  }
}
