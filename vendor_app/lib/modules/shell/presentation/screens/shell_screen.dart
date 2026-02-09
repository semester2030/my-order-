import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:vendor_app/modules/menu/presentation/screens/menu_screen.dart';
import 'package:vendor_app/modules/orders/presentation/screens/orders_screen.dart';
import 'package:vendor_app/modules/profile/presentation/screens/settings_screen.dart';
import 'package:vendor_app/modules/services/presentation/screens/services_screen.dart';
import 'package:vendor_app/modules/staff/presentation/screens/staff_screen.dart';
import 'package:vendor_app/modules/shell/presentation/widgets/vendor_bottom_nav.dart';
import 'package:vendor_app/modules/shell/presentation/widgets/vendor_drawer.dart';

/// Shell — ثيم موحد: Drawer + body (Dashboard / Orders / Menu / Services / Staff / Settings) + Bottom Nav (Phase 13).
class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedShellTabIndexProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const VendorDrawer(currentRoute: '/shell'),
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          DashboardScreen(showDrawerButton: true),
          OrdersScreen(showDrawerButton: true),
          MenuScreen(showDrawerButton: true),
          ServicesScreen(showDrawerButton: true),
          StaffScreen(showDrawerButton: true),
          SettingsScreen(showDrawerButton: true),
        ],
      ),
      bottomNavigationBar: VendorBottomNav(
        currentIndex: selectedIndex,
        onTap: (index) => ref.read(selectedShellTabIndexProvider.notifier).state = index,
      ),
    );
  }
}
