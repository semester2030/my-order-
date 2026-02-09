// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../providers/profile_notifier.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyles.titleLarge,
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 4),
      body: profileState.when(
        initial: () => const LoadingView(),
        loading: () => const LoadingView(),
        loaded: (profile) => _buildProfileContent(context, ref, profile),
        error: (message) => ErrorState(
          message: message,
          onRetry: () {
            ref.read(profileNotifierProvider.notifier).refresh();
          },
        ),
      ),
    );
  }

  static Widget _buildProfileContent(BuildContext context, WidgetRef ref, profile) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile header
          ProfileHeader(profile: profile),
          Gaps.lgV,
          // Profile options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
            child: Column(
              children: [
                ProfileTile(
                  icon: Icons.person_outline,
                  title: 'Edit Name',
                  subtitle: profile.name ?? 'Not set',
                  onTap: () {
                    context.push(RouteNames.editProfile);
                  },
                ),
                Gaps.mdV,
                ProfileTile(
                  icon: Icons.location_on_outlined,
                  title: 'My Addresses',
                  subtitle: 'Manage delivery addresses',
                  onTap: () {
                    context.push(RouteNames.addresses);
                  },
                ),
                Gaps.mdV,
                ProfileTile(
                  icon: Icons.edit_location_outlined,
                  title: 'Change Address',
                  subtitle: 'Update your delivery address',
                  onTap: () {
                    context.push(RouteNames.selectAddressMap);
                  },
                ),
                Gaps.mdV,
                ProfileTile(
                  icon: Icons.payment_outlined,
                  title: 'Payment Methods',
                  subtitle: 'Add and manage payment cards',
                  onTap: () {
                    context.push(RouteNames.paymentMethods);
                  },
                ),
                Gaps.mdV,
                ProfileTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'My Orders',
                  subtitle: 'View order history',
                  onTap: () {
                    context.go(RouteNames.orders);
                  },
                ),
                Gaps.mdV,
                ProfileTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  subtitle: 'App settings and preferences',
                  onTap: () {
                    context.push(RouteNames.settings);
                  },
                ),
                Gaps.xlV,
                // Logout button
                OutlinedButton.icon(
                  onPressed: () => _handleLogout(context, ref),
                  icon: Icon(Icons.logout, size: IconSizes.md),
                  label: Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Insets.lg,
                      vertical: Insets.md,
                    ),
                    foregroundColor: SemanticColors.error,
                    side: BorderSide(color: SemanticColors.error),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Logout',
          style: TextStyles.titleMedium,
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: TextStyles.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go(RouteNames.splash);
              }
            },
            child: Text(
              'Logout',
              style: TextStyles.button.copyWith(
                color: SemanticColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
