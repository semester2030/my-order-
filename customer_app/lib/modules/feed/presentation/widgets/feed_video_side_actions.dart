// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../domain/entities/feed_item.dart';

/// أزرار على يمين الفيديو (نمط تيك توك): وجبات جاهزة + خدمات عند الطلب.
class FeedVideoSideActions extends StatelessWidget {
  final FeedItem item;
  /// إن كانت الخدمة غير متاحة يظهر الزر معطّلاً مع توضيح.
  final bool acceptsCustomRequests;

  const FeedVideoSideActions({
    super.key,
    required this.item,
    this.acceptsCustomRequests = true,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: Insets.sm,
      bottom: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // وجبات جاهزة → صفحة الطباخ (قائمة الوجبات)
          _SideActionButton(
            icon: Icons.lunch_dining,
            label: 'وجبات جاهزة',
            onTap: () {
              context.push(
                '${RouteNames.vendorDetails}/${item.vendor.id}',
              );
            },
          ),
          Gaps.mdV,
          // طبخ شعبي: "طلب ذبايح" — غير ذلك: "خدمات عند الطلب"
          _SideActionButton(
            icon: Icons.person_rounded,
            label: item.vendor.isPopularCooking ? 'طلب ذبايح' : 'خدمات عند الطلب',
            onTap: acceptsCustomRequests
                ? () {
                    context.push(
                      '${RouteNames.requestChef}/${item.vendor.id}',
                    );
                  }
                : null,
            disabledTooltip: 'غير متوفر حالياً',
          ),
        ],
      ),
    );
  }
}

class _SideActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? disabledTooltip;

  const _SideActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.disabledTooltip,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;

    return Tooltip(
      message: isDisabled && disabledTooltip != null
          ? disabledTooltip!
          : label,
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
