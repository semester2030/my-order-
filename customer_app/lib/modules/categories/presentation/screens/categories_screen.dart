// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/constants/provider_categories.dart';

/// Single screen: four category icons. Tapping one opens Feed with that category.
/// No duplicate screens or widgets — icons built inline.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _openFeed(BuildContext context, String category) {
    context.go('${RouteNames.feed}?category=$category');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'اختر الخدمة',
          style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: Insets.md,
          crossAxisSpacing: Insets.md,
          childAspectRatio: 0.95,
          children: [
            _CategoryTile(
              category: ProviderCategories.homeCooking,
              icon: Icons.restaurant,
              onTap: () => _openFeed(context, ProviderCategories.homeCooking),
            ),
            _CategoryTile(
              category: ProviderCategories.popularCooking,
              icon: Icons.celebration,
              onTap: () => _openFeed(context, ProviderCategories.popularCooking),
            ),
            _CategoryTile(
              category: ProviderCategories.privateEvents,
              icon: Icons.event,
              onTap: () => _openFeed(context, ProviderCategories.privateEvents),
            ),
            _CategoryTile(
              category: ProviderCategories.grilling,
              icon: Icons.outdoor_grill,
              onTap: () => _openFeed(context, ProviderCategories.grilling),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.icon,
    required this.onTap,
  });

  final String category;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: EdgeInsets.all(Insets.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: IconSizes.xxl, color: AppColors.primary),
              Gaps.smV,
              Text(
                ProviderCategories.label(category),
                textAlign: TextAlign.center,
                style: TextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
