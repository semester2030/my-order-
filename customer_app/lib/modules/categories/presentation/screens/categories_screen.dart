// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/constants/provider_categories.dart';
import '../../../../core/localization/app_localizations.dart';

/// Single screen: four category icons. Tapping one opens Feed with that category.
/// No duplicate screens or widgets — icons built inline.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _openFeed(BuildContext context, String category) {
    context.go('${RouteNames.feed}?category=$category');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          l.selectService,
          style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Insets.md,
                  vertical: Insets.sm + 2,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.play_circle_outline_rounded,
                      size: 22,
                      color: AppColors.primary,
                    ),
                    Gaps.smH,
                    Expanded(
                      child: Text(
                        l.categoriesVideoHint,
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: 0.82),
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gaps.mdV,
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: Insets.md,
                crossAxisSpacing: Insets.md,
                childAspectRatio: 0.88,
                children: [
                  _CategoryTile(
                    category: ProviderCategories.homeCooking,
                    icon: Icons.dinner_dining_rounded,
                    onTap: () => _openFeed(context, ProviderCategories.homeCooking),
                  ),
                  _CategoryTile(
                    category: ProviderCategories.popularCooking,
                    // طبخ ميداني / ولائم وقدور — أقرب من «طبق صحي» لـ set_meal
                    icon: Icons.soup_kitchen_rounded,
                    onTap: () => _openFeed(context, ProviderCategories.popularCooking),
                  ),
                  _CategoryTile(
                    category: ProviderCategories.privateEvents,
                    // بوفيه وموائد مناسبات — أدق من حفلة (celebration) أو مجرد تقويم
                    icon: Icons.brunch_dining_rounded,
                    onTap: () => _openFeed(context, ProviderCategories.privateEvents),
                  ),
                  _CategoryTile(
                    category: ProviderCategories.grilling,
                    icon: Icons.outdoor_grill_rounded,
                    onTap: () => _openFeed(context, ProviderCategories.grilling),
                  ),
                ],
              ),
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
    final l = AppLocalizations.of(context);
    final label = l.categoryLabel(category);
    return Semantics(
      button: true,
      label: label,
      hint: l.categoriesVideoHint,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.md + 2),
          border: Border.all(color: AppColors.warmDivider.withValues(alpha: 0.85)),
          boxShadow: const [AppShadows.sm],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md + 2),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.md + 2),
            splashColor: AppColors.primary.withValues(alpha: 0.09),
            highlightColor: AppColors.primary.withValues(alpha: 0.05),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Insets.sm + 2,
                vertical: Insets.md,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 84,
                    height: 84,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primaryContainer,
                                AppColors.primaryContainer.withValues(alpha: 0.65),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.14),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.65),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            icon,
                            size: IconSizes.xxl - 2,
                            color: AppColors.primary,
                            shadows: [
                              Shadow(
                                color: AppColors.primaryDark.withValues(alpha: 0.18),
                                blurRadius: 6,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        PositionedDirectional(
                          end: -1,
                          bottom: 0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryContainer,
                                width: 2,
                              ),
                              boxShadow: const [AppShadows.sm],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: Icon(
                                Icons.play_circle_filled_rounded,
                                size: 24,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gaps.smV,
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
