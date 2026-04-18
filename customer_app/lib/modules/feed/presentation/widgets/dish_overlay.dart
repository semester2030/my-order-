// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/constants/provider_categories.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/feed_item.dart';
import 'view_chef_button.dart';

class DishOverlay extends StatelessWidget {
  final FeedItem item;
  final VoidCallback? onAddToCart;
  /// إن كانت الطباخة تقبل "خدمات عند الطلب"؛ إن false يظهر الزر معطّلاً.
  final bool acceptsCustomRequests;

  /// مسافة إضافية من الأعلى لتفادي تداخل [FeedScreen] الشريط (فئة + فلتر) فوق اسم الطباخ والوجبة.
  final double topChromeInset;

  bool get _isPrivateEvents =>
      item.vendor.providerCategory == ProviderCategories.privateEvents;

  /// طبخ ذبائح أو شواء خارجي — حجز طباخ في الموقع.
  bool get _isChefOnsiteService {
    final c = item.vendor.providerCategory;
    return c == ProviderCategories.popularCooking ||
        c == ProviderCategories.grilling;
  }

  /// خدمة (حجز) وليس منتجاً للسلة.
  bool get _primaryIsServiceBookingNotCart =>
      _isChefOnsiteService || _isPrivateEvents;

  bool get _usesFeedPromoLayout =>
      ProviderCategories.usesFeedPromoVideoLayout(item.vendor.providerCategory);

  void _onPromoOpenVendorProfile(BuildContext context) {
    context.push('${RouteNames.vendorDetails}/${item.vendor.id}');
  }

  (IconData icon, String title, String hint) _promoBottomCta(AppLocalizations l) {
    final c = item.vendor.providerCategory ?? '';
    switch (c) {
      case ProviderCategories.homeCooking:
        return (
          Icons.menu_book_rounded,
          l.homeCookingFeedPrimaryCta,
          l.homeCookingFeedPrimaryCtaHint,
        );
      case ProviderCategories.popularCooking:
        return (
          Icons.home_work_outlined,
          l.popularCookingFeedPrimaryCta,
          l.popularCookingFeedPrimaryCtaHint,
        );
      case ProviderCategories.grilling:
        return (
          Icons.local_fire_department,
          l.grillingFeedPrimaryCta,
          l.grillingFeedPrimaryCtaHint,
        );
      case ProviderCategories.privateEvents:
        return (
          Icons.celebration_outlined,
          l.privateEventsFeedPrimaryCta,
          l.privateEventsFeedPrimaryCtaHint,
        );
      default:
        return (
          Icons.menu_book_rounded,
          l.homeCookingFeedPrimaryCta,
          l.homeCookingFeedPrimaryCtaHint,
        );
    }
  }

  String get _requestChefQuery {
    final c = item.vendor.providerCategory;
    if (c == ProviderCategories.popularCooking) {
      return '?category=${ProviderCategories.popularCooking}';
    }
    if (c == ProviderCategories.grilling) {
      return '?category=${ProviderCategories.grilling}';
    }
    return '';
  }

  void _onPrimaryServiceCta(BuildContext context) {
    if (_isPrivateEvents) {
      context.push('${RouteNames.requestPrivateEvent}/${item.vendor.id}');
    } else {
      context.push(
        '${RouteNames.requestChef}/${item.vendor.id}$_requestChefQuery',
      );
    }
  }

  const DishOverlay({
    super.key,
    required this.item,
    this.onAddToCart,
    this.acceptsCustomRequests = true,
    this.topChromeInset = 0,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: topChromeInset),
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
                          if (item.distance != null && item.distance! <= 100) ...[
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
                      item.menuItem.price != null
                          ? '${item.menuItem.price!.toStringAsFixed(2)} SAR'
                          : l.priceOnRequest,
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
                          l.signature,
                          style: TextStyles.labelSmall.copyWith(
                            color: AppColors.textInverse,
                          ),
                        ),
                      ),
                  ],
                ),
                Gaps.lgV,
                // فئات البرومو (منزلي / ذبائح / شواء / مناسبات): زر عريض واحد — ليس «أضف للسلة».
                if (_usesFeedPromoLayout)
                  Builder(
                    builder: (ctx) {
                      final spec = _promoBottomCta(l);
                      return Tooltip(
                        message: spec.$3,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _onPromoOpenVendorProfile(ctx),
                            style: VideoOverlayTheme.ctaButtonStyle.copyWith(
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: Insets.lg,
                                ),
                              ),
                              minimumSize: WidgetStateProperty.all(
                                const Size(double.infinity, 52),
                              ),
                              textStyle: WidgetStateProperty.all(
                                TextStyles.button.copyWith(
                                  color: AppColors.textOnPrimary,
                                  fontSize: FontSizes.bodyMedium,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(spec.$1, size: 22),
                                Gaps.smH,
                                Flexible(
                                  child: Text(
                                    spec.$2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                else if (_primaryIsServiceBookingNotCart)
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
                          onPressed: acceptsCustomRequests
                              ? () => _onPrimaryServiceCta(context)
                              : null,
                          style: VideoOverlayTheme.ctaButtonStyle,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isPrivateEvents
                                    ? Icons.event_available_rounded
                                    : Icons.restaurant_menu,
                                size: IconSizes.xs,
                              ),
                              Gaps.xsH,
                              Flexible(
                                child: Text(
                                  _isPrivateEvents ? l.bookYourEvent : l.bookChef,
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
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ViewChefButton(
                      onTap: () {
                        context.push(
                          '${RouteNames.vendorDetails}/${item.vendor.id}',
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
