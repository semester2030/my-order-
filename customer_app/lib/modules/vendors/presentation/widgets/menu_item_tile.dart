// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/design_system.dart';
import '../../domain/entities/menu_item.dart';

/// بطاقة وجبة — صورة ثابتة للطبق في الأعلى، والتفاصيل في الأسفل (بدون فيديو).
class MenuItemTile extends StatelessWidget {
  final MenuItem menuItem;
  final VoidCallback? onTap;

  const MenuItemTile({
    super.key,
    required this.menuItem,
    this.onTap,
  });

  static const double _photoHeight = 200;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final photoUrl = menuItem.dishPhotoUrl;

    return Semantics(
      button: true,
      label: menuItem.name,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shadowColor: AppColors.primary.withValues(alpha: 0.12),
        child: InkWell(
          onTap: menuItem.isAvailable ? onTap : null,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: menuItem.isAvailable
                    ? AppColors.border
                    : AppColors.warmDivider,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: _photoHeight,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (photoUrl != null)
                        CachedNetworkImage(
                          imageUrl: photoUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => _photoPlaceholder(),
                        )
                      else
                        _photoPlaceholder(),
                      if (!menuItem.isAvailable)
                        ColoredBox(
                          color: Colors.black.withValues(alpha: 0.35),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Insets.md,
                                vertical: Insets.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: AppRadius.smAll,
                              ),
                              child: Text(
                                l.notAvailable,
                                style: TextStyles.bodySmall.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Insets.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              menuItem.name,
                              style: TextStyles.titleMedium.copyWith(
                                color: menuItem.isAvailable
                                    ? AppColors.textPrimary
                                    : AppColors.textTertiary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (menuItem.isSignature)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Insets.xs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentContainer,
                                borderRadius: AppRadius.smAll,
                              ),
                              child: Text(
                                l.signature,
                                style: TextStyles.bodySmall.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (menuItem.description != null &&
                          menuItem.description!.trim().isNotEmpty) ...[
                        Gaps.xsV,
                        Text(
                          menuItem.description!,
                          style: TextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      Gaps.smV,
                      Text(
                        menuItem.price != null
                            ? '${menuItem.price!.toStringAsFixed(2)} SAR'
                            : l.priceOnRequest,
                        style: TextStyles.titleMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _photoPlaceholder() {
    return ColoredBox(
      color: AppColors.primaryContainer.withValues(alpha: 0.55),
      child: Center(
        child: Icon(
          Icons.restaurant_menu,
          color: AppColors.primary,
          size: 56,
        ),
      ),
    );
  }
}
