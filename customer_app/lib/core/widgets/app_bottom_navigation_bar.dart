import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/design_system.dart';
import '../routing/route_names.dart';
import '../localization/app_localizations.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  int _getIndexForRoute(String route) {
    if (route == RouteNames.categories || route.startsWith(RouteNames.feed)) return 0;
    if (route.startsWith(RouteNames.myRequestsHub) ||
        route.startsWith(RouteNames.myChefBookings) ||
        route.startsWith(RouteNames.myHomeCookingRequests)) {
      return 1;
    }
    if (route.startsWith(RouteNames.payment) ||
        route.startsWith(RouteNames.paymentMethods) ||
        route.startsWith(RouteNames.checkout) ||
        route.startsWith(RouteNames.addCard)) {
      return 2;
    }
    if (route.startsWith(RouteNames.profile) ||
        route.startsWith(RouteNames.settings) ||
        route.startsWith(RouteNames.addresses) ||
        route.startsWith(RouteNames.editProfile) ||
        route.startsWith(RouteNames.privacyPolicy) ||
        route.startsWith(RouteNames.terms) ||
        route.startsWith(RouteNames.deleteAccount)) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.categories);
        break;
      case 1:
        context.go(RouteNames.myRequestsHub);
        break;
      case 2:
        context.go(RouteNames.paymentMethods);
        break;
      case 3:
        context.go(RouteNames.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: l10n.discover,
        ),
        BottomNavigationBarItem(
          icon: const _MyRequestsHubNavIcon(selected: false),
          activeIcon: const _MyRequestsHubNavIcon(selected: true),
          label: l10n.orders,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.payment),
          label: l10n.payment,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: l10n.profile,
        ),
      ],
    );
  }
}

/// أيقونتان صغيرتان داخل خانة واحدة لتمثيل الطبخ المنزلي + الولائم والشوي.
class _MyRequestsHubNavIcon extends StatelessWidget {
  const _MyRequestsHubNavIcon({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textTertiary;
    return SizedBox(
      width: 30,
      height: 24,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: Icon(Icons.home_work_outlined, size: 18, color: color),
          ),
          Positioned(
            right: 0,
            child: Icon(Icons.restaurant_menu, size: 18, color: color),
          ),
        ],
      ),
    );
  }
}
