import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/routing/route_names.dart';
import '../modules/delivery/presentation/screens/active_delivery_screen.dart';
import '../modules/jobs/presentation/screens/jobs_screen.dart';
import '../modules/driver_profile/presentation/screens/profile_screen.dart';
import 'bottom_nav.dart';

/// Main Shell - Container for main app screens with bottom navigation
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.work_outline,
      activeIcon: Icons.work,
      label: 'Jobs',
      route: RouteNames.jobs,
    ),
    NavigationItem(
      icon: Icons.local_shipping_outlined,
      activeIcon: Icons.local_shipping,
      label: 'Delivery',
      route: RouteNames.activeDelivery,
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: RouteNames.profile,
    ),
  ];

  void _updateCurrentIndex(BuildContext context) {
    final router = GoRouter.of(context);
    final location = router.routerDelegate.currentConfiguration.uri.path;
    int newIndex = _currentIndex;
    
    if (location == RouteNames.jobs || location == RouteNames.mainShell) {
      newIndex = 0;
    } else if (location == RouteNames.activeDelivery || 
               location.contains('/delivery/')) {
      newIndex = 1;
    } else if (location == RouteNames.profile) {
      newIndex = 2;
    }
    
    if (newIndex != _currentIndex) {
      setState(() => _currentIndex = newIndex);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    context.go(_navigationItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    // Update current index based on route
    _updateCurrentIndex(context);
    // Build only the active tab to avoid initializing Google Map / location
    // when user is on Jobs tab (prevents crash when location permission is denied)
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const JobsScreen(),
          if (_currentIndex == 1) const ActiveDeliveryScreen() else const SizedBox.shrink(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        items: _navigationItems,
        onTap: _onItemTapped,
      ),
    );
  }
}

/// Navigation Item
class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
