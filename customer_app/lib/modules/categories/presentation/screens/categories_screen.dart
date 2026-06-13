// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/category_cover_assets.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/widgets/guest_explore_banner.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/constants/provider_categories.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../auth/presentation/providers/guest_mode_notifier.dart';

/// شاشة اختيار الخدمة — أربع بطاقات بصور احترافية تمثل كل فئة.
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  void _openFeed(BuildContext context, String category) {
    context.go('${RouteNames.feed}?category=$category');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final isGuest = ref.watch(guestModeProvider);
    final isAuth = ref.watch(authNotifierProvider).maybeWhen(
          authenticated: (_) => true,
          orElse: () => false,
        );
    final showGuestBanner = isGuest && !isAuth;

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showGuestBanner)
            GuestExploreBanner(
              message: l.guestExploreBanner,
              actionLabel: l.guestExploreBannerAction,
              onAction: () => context.push(RouteNames.login),
            ),
          Expanded(
            child: Padding(
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
                      childAspectRatio: 0.78,
                      children: [
                        _CategoryCoverTile(
                          category: ProviderCategories.homeCooking,
                          onTap: () => _openFeed(context, ProviderCategories.homeCooking),
                        ),
                        _CategoryCoverTile(
                          category: ProviderCategories.popularCooking,
                          onTap: () => _openFeed(context, ProviderCategories.popularCooking),
                        ),
                        _CategoryCoverTile(
                          category: ProviderCategories.privateEvents,
                          onTap: () => _openFeed(context, ProviderCategories.privateEvents),
                        ),
                        _CategoryCoverTile(
                          category: ProviderCategories.grilling,
                          onTap: () => _openFeed(context, ProviderCategories.grilling),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
    );
  }
}

class _CategoryCoverTile extends StatelessWidget {
  const _CategoryCoverTile({
    required this.category,
    required this.onTap,
  });

  final String category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final label = l.categoryLabel(category);
    final imagePath = CategoryCoverAssets.pathFor(category);

    return Semantics(
      button: true,
      label: label,
      hint: l.categoriesVideoHint,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shadowColor: AppColors.primary.withValues(alpha: 0.18),
        child: InkWell(
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: AppColors.warmDivider.withValues(alpha: 0.55),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => ColoredBox(
                    color: AppColors.primaryContainer.withValues(alpha: 0.45),
                    child: Icon(Icons.restaurant_menu, color: AppColors.primary, size: 48),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.08),
                        Colors.black.withValues(alpha: 0.22),
                        Colors.black.withValues(alpha: 0.72),
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: Insets.sm,
                  end: Insets.sm,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.42),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.play_circle_filled_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: Insets.md,
                  end: Insets.md,
                  bottom: Insets.md,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.55),
                          blurRadius: 8,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
