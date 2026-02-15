// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../providers/profile_notifier.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.profile,
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
    final l10n = AppLocalizations.of(context);
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
                  title: l10n.editName,
                  subtitle: profile.name ?? l10n.notSet,
                  onTap: () {
                    context.push(RouteNames.editProfile);
                  },
                ),
                Gaps.mdV,
                ProfileTile(
                  icon: Icons.location_on_outlined,
                  title: l10n.myAddresses,
                  subtitle: l10n.manageAddresses,
                  onTap: () {
                    context.push(RouteNames.addresses);
                  },
                ),
                Gaps.mdV,
                ProfileTile(
                  icon: Icons.edit_location_outlined,
                  title: l10n.changeAddress,
                  subtitle: l10n.updateAddress,
                  onTap: () {
                    context.push(RouteNames.selectAddressMap);
                  },
                ),
                Gaps.mdV,
                ProfileTile(
                  icon: Icons.payment_outlined,
                  title: l10n.paymentMethods,
                  subtitle: l10n.managePaymentCards,
                  onTap: () {
                    context.push(RouteNames.paymentMethods);
                  },
                ),
                Gaps.mdV,
                ProfileTile(
                  icon: Icons.receipt_long_outlined,
                  title: l10n.myOrders,
                  subtitle: l10n.viewOrderHistory,
                  onTap: () {
                    context.go(RouteNames.orders);
                  },
                ),
                Gaps.mdV,
                ProfileTile(
                  icon: Icons.settings_outlined,
                  title: l10n.settings,
                  subtitle: l10n.appSettings,
                  onTap: () {
                    context.push(RouteNames.settings);
                  },
                ),
                Gaps.xlV,
                // Logout button
                OutlinedButton.icon(
                  onPressed: () => _handleLogout(context, ref),
                  icon: Icon(Icons.logout, size: IconSizes.md),
                  label: Text(l10n.logout),
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
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          l10n.logout,
          style: TextStyles.titleMedium,
        ),
        content: Text(
          l10n.logoutConfirm,
          style: TextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
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
              l10n.logout,
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
