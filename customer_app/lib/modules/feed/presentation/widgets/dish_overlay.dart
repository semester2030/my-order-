// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/constants/provider_categories.dart';
import '../../../../core/routing/route_names.dart';
import '../../domain/entities/feed_item.dart';
import 'view_chef_button.dart';

class DishOverlay extends StatelessWidget {
  final FeedItem item;
  final VoidCallback? onAddToCart;
  /// إن كانت الطباخة تقبل "خدمات عند الطلب"؛ إن false يظهر الزر معطّلاً.
  final bool acceptsCustomRequests;

  bool get _isPopularCooking =>
      item.vendor.providerCategory == ProviderCategories.popularCooking;

  const DishOverlay({
    super.key,
    required this.item,
    this.onAddToCart,
    this.acceptsCustomRequests = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Top content - Chef and Dish info in a frame
          Container(
            margin: const EdgeInsets.all(Insets.md),
            padding: const EdgeInsets.symmetric(
              horizontal: Insets.md,
              vertical: Insets.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: AppRadius.mdAll,
              border: Border.all(
                color: AppColors.textInverse.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                if (item.vendor.logo != null)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(item.vendor.logo!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.ramen_dining,
                      color: AppColors.primary,
                      size: IconSizes.xs,
                    ),
                  ),
                Gaps.smH,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Chef / provider name and dish name in one line
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              item.vendor.name,
                              style: VideoOverlayTheme.subtitleStyle.copyWith(
                                fontSize: FontSizes.bodySmall,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gaps.xsH,
                          Text(
                            '•',
                            style: VideoOverlayTheme.subtitleStyle.copyWith(
                              fontSize: FontSizes.bodySmall,
                            ),
                          ),
                          Gaps.xsH,
                          Flexible(
                            child: Text(
                              item.menuItem.name,
                              style: VideoOverlayTheme.subtitleStyle.copyWith(
                                fontSize: FontSizes.bodySmall,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Gaps.xsV,
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 12,
                            color: AppColors.accent,
                          ),
                          Gaps.xsH,
                          Text(
                            item.vendor.rating.toStringAsFixed(1),
                            style: VideoOverlayTheme.subtitleStyle.copyWith(
                              fontSize: FontSizes.labelSmall,
                            ),
                          ),
                          Gaps.xsH,
                          Text(
                            '(${item.vendor.ratingCount})',
                            style: VideoOverlayTheme.subtitleStyle.copyWith(
                              fontSize: FontSizes.labelSmall,
                            ),
                          ),
                          if (item.distance != null) ...[
                            Gaps.xsH,
                            Text(
                              '• ${item.distance!.toStringAsFixed(1)} km',
                              style: VideoOverlayTheme.subtitleStyle.copyWith(
                                fontSize: FontSizes.labelSmall,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Bottom content
          Container(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.menuItem.description != null) ...[
                  Gaps.smV,
                  Text(
                    item.menuItem.description!,
                    style: VideoOverlayTheme.subtitleStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                Gaps.mdV,
                // Price and badges
                Row(
                  children: [
                    Text(
                      '${item.menuItem.price.toStringAsFixed(2)} SAR',
                      style: VideoOverlayTheme.titleStyle.copyWith(
                        fontSize: FontSizes.headlineMedium,
                        color: AppColors.accent,
                      ),
                    ),
                    Gaps.mdH,
                    if (item.menuItem.isSignature)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Insets.sm,
                          vertical: Insets.xs,
                        ),
                        decoration: BoxDecoration(
                          color: SemanticColors.badgeSignature,
                          borderRadius: AppRadius.fullAll,
                        ),
                        child: Text(
                          'Signature',
                          style: TextStyles.labelSmall.copyWith(
                            color: AppColors.textInverse,
                          ),
                        ),
                      ),
                  ],
                ),
                Gaps.lgV,
                // CTA: عرض الطباخ + (طبخ شعبي: احجز الطباخ | وجبات جاهزة: أضف للسلة)
                Row(
                  children: [
                    Expanded(
                      child: ViewChefButton(
                        onTap: () {
                          context.push(
                            '${RouteNames.vendorDetails}/${item.vendor.id}',
                          );
                        },
                      ),
                    ),
                    Gaps.mdH,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isPopularCooking
                            ? (acceptsCustomRequests
                                ? () => context.push(
                                      '${RouteNames.requestChef}/${item.vendor.id}?category=popular_cooking',
                                    )
                                : null)
                            : onAddToCart,
                        style: VideoOverlayTheme.ctaButtonStyle,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isPopularCooking
                                  ? Icons.restaurant_menu
                                  : Icons.shopping_cart,
                              size: IconSizes.xs,
                            ),
                            Gaps.xsH,
                            Flexible(
                              child: Text(
                                _isPopularCooking ? 'احجز الطباخ' : 'أضف للسلة',
                                style: TextStyles.button.copyWith(
                                  fontSize: FontSizes.bodySmall,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
