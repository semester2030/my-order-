// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/constants/provider_categories.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/feed_item.dart';

/// أزرار على يمين الفيديو (نمط تيك توك).
/// — الطبخ المنزلي: وجبات جاهزة + "اطلب وجبتك المخصصة" (طلب وجبة غير القائمة).
/// — الطبخ الشعبي + الشوي: "احجز الطباخ" — الطباخ يأتي عند العميل.
class FeedVideoSideActions extends StatelessWidget {
  final FeedItem item;
  /// إن كانت الخدمة غير متاحة يظهر الزر معطّلاً مع توضيح.
  final bool acceptsCustomRequests;

  const FeedVideoSideActions({
    super.key,
    required this.item,
    this.acceptsCustomRequests = true,
  });

  bool get _isPopularCooking =>
      item.vendor.providerCategory == ProviderCategories.popularCooking;

  /// الطبخ المنزلي: "اطلب وجبتك المخصصة" | الطبخ الشعبي + الشوي: "احجز الطباخ" | المناسبات: "طلب مناسبة"
  bool get _showRequestChefButton {
    final cat = item.vendor.providerCategory;
    return cat == ProviderCategories.homeCooking ||
        cat == ProviderCategories.popularCooking ||
        cat == ProviderCategories.grilling ||
        cat == ProviderCategories.privateEvents;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Positioned(
      right: Insets.sm,
      bottom: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SideActionButton(
            icon: _isPopularCooking ? Icons.person_rounded : Icons.lunch_dining,
            label: _isPopularCooking ? l.viewChef : l.readyMeals,
            tooltip: _isPopularCooking ? null : l.readyMealsTooltip,
            onTap: () {
              context.push(
                '${RouteNames.vendorDetails}/${item.vendor.id}',
              );
            },
          ),
          if (_showRequestChefButton) ...[
            Gaps.mdV,
            _SideActionButton(
              icon: Icons.restaurant_menu,
              label: _getRequestLabel(l),
              tooltip: item.vendor.providerCategory == ProviderCategories.homeCooking
                  ? l.requestCookingTooltip
                  : null,
              onTap: acceptsCustomRequests
                  ? () {
                      if (item.vendor.providerCategory ==
                          ProviderCategories.privateEvents) {
                        context.push(
                            '${RouteNames.requestPrivateEvent}/${item.vendor.id}');
                      } else if (item.vendor.isPopularCooking) {
                        context.push(
                            '${RouteNames.requestChef}/${item.vendor.id}?category=popular_cooking');
                      } else {
                        context.push(
                            '${RouteNames.requestChef}/${item.vendor.id}');
                      }
                    }
                  : null,
              disabledTooltip: l.unavailableNow,
            ),
          ],
        ],
      ),
    );
  }

  String _getRequestLabel(AppLocalizations l) {
    final cat = item.vendor.providerCategory;
    if (cat == ProviderCategories.homeCooking) return l.requestCooking; // اطلب وجبتك المخصصة
    if (item.vendor.isPopularCooking || cat == ProviderCategories.grilling) return l.bookChef;
    if (cat == ProviderCategories.privateEvents) return l.requestEvent;
    return l.requestCooking;
  }
}

class _SideActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? disabledTooltip;
  final String? tooltip;

  const _SideActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.disabledTooltip,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    final message = isDisabled && disabledTooltip != null
        ? disabledTooltip!
        : (tooltip ?? label);

    return Tooltip(
      message: message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.black.withValues(alpha: 0.4),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: isDisabled
                      ? AppColors.textInverse.withValues(alpha: 0.5)
                      : AppColors.textInverse,
                  size: 26,
                ),
              ),
            ),
          ),
          Gaps.xsV,
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyles.labelSmall.copyWith(
                color: isDisabled
                    ? AppColors.textInverse.withValues(alpha: 0.6)
                    : AppColors.textInverse,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
