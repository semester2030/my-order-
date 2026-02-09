import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/config/feature_flags.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/modules/profile/presentation/providers/profile_state.dart';

/// القائمة الجانبية — ثيم موحد (Phase 12: + الطلبات الجانبية لـ popular_cooking، Phase 13: + الموظفون).
class VendorDrawer extends ConsumerWidget {
  const VendorDrawer({
    super.key,
    this.currentRoute,
    this.onTapItem,
  });

  final String? currentRoute;
  final void Function(String route)? onTapItem;

  static bool _showSideOrders(WidgetRef ref) {
    if (!FeatureFlags.sideOrdersEnabled) return false;
    final state = ref.watch(profileNotifierProvider);
    if (state is ProfileLoaded) {
      return state.profile.providerCategory == 'popular_cooking';
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Drawer(
      backgroundColor: AppColors.surfaceElevated,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(Insets.lg),
              child: Text(
                'Vendor App',
                style: TextStyles.headlineSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(height: 1, color: AppColors.divider),
            ListTile(
              leading: Icon(Icons.dashboard, color: AppColors.primary, size: IconSizes.md),
              title: Text(
                l10n.dashboard,
                style: TextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
              ),
              selected: currentRoute == RouteNames.shell &&
                  ref.watch(selectedShellTabIndexProvider) == 0,
              onTap: () {
                ref.read(selectedShellTabIndexProvider.notifier).state = 0;
                Navigator.of(context).pop();
                if (onTapItem != null) {
                  onTapItem!(RouteNames.shell);
                } else {
                  context.go(RouteNames.shell);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt_long, color: AppColors.textSecondary, size: IconSizes.md),
              title: Text(
                l10n.orders,
                style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              selected: currentRoute == RouteNames.shell &&
                  ref.watch(selectedShellTabIndexProvider) == 1,
              onTap: () {
                ref.read(selectedShellTabIndexProvider.notifier).state = 1;
                Navigator.of(context).pop();
                if (onTapItem != null) {
                  onTapItem!(RouteNames.shell);
                } else {
                  context.go(RouteNames.shell);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.restaurant_menu, color: AppColors.textSecondary, size: IconSizes.md),
              title: Text(
                l10n.menu,
                style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              selected: currentRoute == RouteNames.shell &&
                  ref.watch(selectedShellTabIndexProvider) == 2,
              onTap: () {
                ref.read(selectedShellTabIndexProvider.notifier).state = 2;
                Navigator.of(context).pop();
                if (onTapItem != null) {
                  onTapItem!(RouteNames.shell);
                } else {
                  context.go(RouteNames.shell);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.handyman, color: AppColors.textSecondary, size: IconSizes.md),
              title: Text(
                l10n.services,
                style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              selected: currentRoute == RouteNames.shell &&
                  ref.watch(selectedShellTabIndexProvider) == 3,
              onTap: () {
                ref.read(selectedShellTabIndexProvider.notifier).state = 3;
                Navigator.of(context).pop();
                if (onTapItem != null) {
                  onTapItem!(RouteNames.shell);
                } else {
                  context.go(RouteNames.shell);
                }
              },
            ),
            if (VendorDrawer._showSideOrders(ref)) ...[
              ListTile(
                leading: Icon(Icons.add_circle_outline, color: AppColors.textSecondary, size: IconSizes.md),
                title: Text(
                  l10n.sideOrders,
                  style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(RouteNames.sideOrders);
                },
              ),
            ],
            ListTile(
              leading: Icon(Icons.people, color: AppColors.textSecondary, size: IconSizes.md),
              title: Text(
                l10n.staff,
                style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              selected: currentRoute == RouteNames.shell &&
                  ref.watch(selectedShellTabIndexProvider) == 4,
              onTap: () {
                ref.read(selectedShellTabIndexProvider.notifier).state = 4;
                Navigator.of(context).pop();
                if (onTapItem != null) {
                  onTapItem!(RouteNames.shell);
                } else {
                  context.go(RouteNames.shell);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics_outlined, color: AppColors.textSecondary, size: IconSizes.md),
              title: Text(
                l10n.analytics,
                style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.of(context).pop();
                context.push(RouteNames.analytics);
              },
            ),
            ListTile(
              leading: Icon(Icons.video_library, color: AppColors.textSecondary, size: IconSizes.md),
              title: Text(
                l10n.videos,
                style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.of(context).pop();
                context.push(RouteNames.videos);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: AppColors.textSecondary, size: IconSizes.md),
              title: Text(
                l10n.settings,
                style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              selected: currentRoute == RouteNames.shell &&
                  ref.watch(selectedShellTabIndexProvider) == 5,
              onTap: () {
                ref.read(selectedShellTabIndexProvider.notifier).state = 5;
                Navigator.of(context).pop();
                if (onTapItem != null) {
                  onTapItem!(RouteNames.shell);
                } else {
                  context.go(RouteNames.shell);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
