import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/modules/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:vendor_app/modules/menu/presentation/screens/menu_screen.dart';
import 'package:vendor_app/modules/home_cooking_requests/presentation/screens/home_cooking_requests_screen.dart';
import 'package:vendor_app/modules/orders/presentation/screens/orders_screen.dart';
import 'package:vendor_app/modules/profile/presentation/providers/profile_state.dart';
import 'package:vendor_app/modules/profile/presentation/screens/settings_screen.dart';
import 'package:vendor_app/modules/services/presentation/screens/services_screen.dart';
import 'package:vendor_app/modules/shell/presentation/widgets/vendor_bottom_nav.dart';
import 'package:vendor_app/modules/shell/presentation/widgets/vendor_drawer.dart';

/// Shell — ثيم موحد: Drawer + body (Dashboard / Orders / Menu / Services / Settings) + Bottom Nav.
class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final st = ref.read(profileNotifierProvider);
      if (st is! ProfileLoaded) {
        ref.read(profileNotifierProvider.notifier).loadProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedShellTabIndexProvider);
    final profileState = ref.watch(profileNotifierProvider);
    final isHomeCookingVendor =
        profileState is ProfileLoaded && profileState.profile.providerCategory == 'home_cooking';
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const VendorDrawer(currentRoute: '/shell'),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          const DashboardScreen(showDrawerButton: true),
          isHomeCookingVendor
              ? const HomeCookingRequestsScreen(showDrawerButton: true)
              : const OrdersScreen(showDrawerButton: true),
          const MenuScreen(showDrawerButton: true),
          const ServicesScreen(showDrawerButton: true),
          const SettingsScreen(showDrawerButton: true),
        ],
      ),
      bottomNavigationBar: VendorBottomNav(
        currentIndex: selectedIndex,
        ordersTabLabel: isHomeCookingVendor ? l10n.homeCookingRequests : null,
        onTap: (index) => ref.read(selectedShellTabIndexProvider.notifier).state = index,
      ),
    );
  }
}
