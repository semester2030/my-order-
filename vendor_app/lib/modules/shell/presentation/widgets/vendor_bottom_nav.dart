import 'package:flutter/material.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';

/// الشريط السفلي — ثيم موحد (Phase 13: Dashboard, Orders, Menu, Services, Staff, Settings).
class VendorBottomNav extends StatelessWidget {
  const VendorBottomNav({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  final int currentIndex;
  final void Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BottomNavigationBar(
      currentIndex: currentIndex.clamp(0, 5),
      onTap: onTap ?? (_) {},
      backgroundColor: AppColors.surfaceElevated,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      selectedLabelStyle: TextStyles.labelMedium,
      unselectedLabelStyle: TextStyles.labelSmall,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard_outlined),
          activeIcon: const Icon(Icons.dashboard),
          label: l10n.dashboard,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.receipt_long_outlined),
          activeIcon: const Icon(Icons.receipt_long),
          label: l10n.orders,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.restaurant_menu_outlined),
          activeIcon: const Icon(Icons.restaurant_menu),
          label: l10n.menu,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.handyman_outlined),
          activeIcon: const Icon(Icons.handyman),
          label: l10n.services,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.people_outline),
          activeIcon: const Icon(Icons.people),
          label: l10n.staff,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          activeIcon: const Icon(Icons.settings),
          label: l10n.settings,
        ),
      ],
    );
  }
}
