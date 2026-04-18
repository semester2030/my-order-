import 'package:flutter/material.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';

/// الشريط السفلي — ثيم موحد (Dashboard, Orders, Menu, Services, Settings).
class VendorBottomNav extends StatelessWidget {
  const VendorBottomNav({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.ordersTabLabel,
  });

  final int currentIndex;
  final void Function(int index)? onTap;
  /// إن وُجد (مثلاً «طلبات الطبخ المنزلي») يُستبدل تسمية تبويب الطلبات.
  final String? ordersTabLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BottomNavigationBar(
      currentIndex: currentIndex.clamp(0, 4),
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
          label: ordersTabLabel ?? l10n.orders,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.ondemand_video_outlined),
          activeIcon: const Icon(Icons.ondemand_video),
          label: l10n.menu,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.restaurant_menu_outlined),
          activeIcon: const Icon(Icons.restaurant_menu),
          label: l10n.services,
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
