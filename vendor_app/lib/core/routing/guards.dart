import 'package:go_router/go_router.dart';

/// Route guards for Vendor App.
/// Phase 1: no auth check; guards used from Phase 7 onwards.
class RouteGuards {
  RouteGuards._();

  /// Redirect to login if not authenticated (used later with session).
  static String? redirectToLoginIfNeeded(GoRouterState state) {
    // Phase 1: no auth — no redirect
    return null;
  }
}
