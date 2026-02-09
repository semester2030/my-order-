import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/design_system.dart';
import '../routing/route_names.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  int _getIndexForRoute(String route) {
    if (route == RouteNames.categories || route.startsWith(RouteNames.feed)) return 0;
    if (route.startsWith(RouteNames.cart)) return 1;
    if (route.startsWith(RouteNames.orders)) return 2;
    if (route.startsWith(RouteNames.payment) || route.startsWith(RouteNames.paymentMethods)) return 3;
    if (route.startsWith(RouteNames.profile) || route.startsWith(RouteNames.settings) || route.startsWith(RouteNames.addresses)) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.categories);
        break;
      case 1:
        context.go(RouteNames.cart);
        break;
      case 2:
        context.go(RouteNames.orders);
        break;
      case 3:
        context.go(RouteNames.paymentMethods);
        break;
      case 4:
        context.go(RouteNames.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final selectedIndex = _getIndexForRoute(currentRoute);

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      selectedLabelStyle: TextStyles.labelMedium,
      unselectedLabelStyle: TextStyles.labelSmall,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'اكتشف',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          label: 'Payment',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
