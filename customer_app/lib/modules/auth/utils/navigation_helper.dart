import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/di/providers.dart';

/// Helper function to navigate after authentication
/// Checks if user has an address and navigates accordingly
Future<void> navigateAfterAuth(
  BuildContext context,
  WidgetRef ref,
) async {
  if (!context.mounted) return;

  try {
    final addressesRepo = ref.read(addressesRepositoryProvider);
    final defaultAddress = await addressesRepo.getDefaultAddress();

    if (!context.mounted) return;

    if (defaultAddress == null) {
      // No address, redirect to address selection
      context.go(RouteNames.selectAddressMap);
    } else {
      // Has address, go to categories (four icons)
      context.go(RouteNames.categories);
    }
  } catch (e) {
    // Error checking address, go to address selection to be safe
    if (context.mounted) {
      context.go(RouteNames.selectAddressMap);
    }
  }
}
