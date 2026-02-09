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
      // Check if already on auth screen
      if (state.uri.path == RouteNames.phoneInput ||
          state.uri.path == RouteNames.otpVerification ||
          state.uri.path == RouteNames.pinVerification ||
          state.uri.path == RouteNames.registerStep1 ||
          state.uri.path == RouteNames.registerStep2 ||
          state.uri.path == RouteNames.registerStep3 ||
          state.uri.path == RouteNames.trackApplication) {
        return null; // Allow navigation
      }
      return RouteNames.phoneInput; // Redirect to login
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
      // If authenticated and trying to access auth screens, redirect to main
      if (state.uri.path == RouteNames.phoneInput ||
          state.uri.path == RouteNames.otpVerification ||
          state.uri.path == RouteNames.pinVerification ||
          state.uri.path == RouteNames.splash) {
        return RouteNames.mainShell; // Redirect to main shell
      }
    }

    return null; // Allow navigation
  }
}
