// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../profile/presentation/widgets/profile_tile.dart';

/// شاشة مركزية تربط طلبات الطبخ المنزلي وحجوزات الولائم والشوي.
class MyRequestsHubScreen extends StatelessWidget {
  const MyRequestsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.orders,
          style: TextStyles.titleLarge,
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileTile(
              icon: Icons.home_work_outlined,
              title: l10n.myHomeCookingRequests,
              subtitle: l10n.myHomeCookingRequestsSubtitle,
              onTap: () => context.push(RouteNames.myHomeCookingRequests),
            ),
            Gaps.mdV,
            ProfileTile(
              icon: Icons.restaurant_menu,
              title: l10n.myChefBookings,
              subtitle: l10n.myChefBookingsSubtitle,
              onTap: () => context.push(RouteNames.myChefBookings),
            ),
          ],
        ),
      ),
    );
  }
}
