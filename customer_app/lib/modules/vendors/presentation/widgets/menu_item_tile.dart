// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../domain/entities/menu_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MenuItemTile extends StatelessWidget {
  final MenuItem menuItem;
  final VoidCallback? onTap;

  const MenuItemTile({
    super.key,
    required this.menuItem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: menuItem.isAvailable ? onTap : null,
      borderRadius: AppRadius.mdAll,
      child: Container(
        padding: const EdgeInsets.all(Insets.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppRadius.mdAll,
          border: Border.all(
            color: menuItem.isAvailable
                ? AppColors.border
                : AppColors.warmDivider,
          ),
          boxShadow: AppShadows.elevation1,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (menuItem.image != null)
              ClipRRect(
                borderRadius: AppRadius.smAll,
                child: CachedNetworkImage(
                  imageUrl: menuItem.image!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: AppColors.primaryContainer,
                    child: Icon(
                      Icons.lunch_dining,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: AppRadius.smAll,
                ),
                child: Icon(
                  Icons.lunch_dining,
                  color: AppColors.primary,
                ),
              ),
            Gaps.mdH,
            // Content
            Expanded(
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
                            'Signature',
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (menuItem.description != null) ...[
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${menuItem.price.toStringAsFixed(2)} SAR',
                        style: TextStyles.titleMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!menuItem.isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Insets.sm,
                            vertical: Insets.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: AppRadius.smAll,
                          ),
                          child: Text(
                            'Unavailable',
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
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
      ),
    );
  }
}
