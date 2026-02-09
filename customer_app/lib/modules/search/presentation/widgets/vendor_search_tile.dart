// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../domain/entities/search_result.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VendorSearchTile extends StatelessWidget {
  final SearchResult result;

  const VendorSearchTile({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final vendor = result.vendor;

    return InkWell(
      onTap: () {
        context.push('${RouteNames.vendorDetails}/${vendor.id}');
      },
      borderRadius: AppRadius.mdAll,
      child: Container(
        padding: const EdgeInsets.all(Insets.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppRadius.mdAll,
          boxShadow: AppShadows.elevation1,
        ),
        child: Row(
          children: [
            // Logo
            if (vendor.logo != null)
              ClipRRect(
                borderRadius: AppRadius.smAll,
                child: CachedNetworkImage(
                  imageUrl: vendor.logo!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: AppRadius.smAll,
                    ),
                    child: Icon(
                      Icons.ramen_dining,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: AppRadius.smAll,
                ),
                child: Icon(
                  Icons.ramen_dining,
                  color: AppColors.primary,
                ),
              ),
            Gaps.mdH,
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor.name,
                    style: TextStyles.titleMedium,
                  ),
                  Gaps.xsV,
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      Gaps.xsH,
                      Text(
                        vendor.rating.toStringAsFixed(1),
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Gaps.smH,
                      Text(
                        '(${vendor.ratingCount} reviews)',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      if (result.distance != null) ...[
                        Gaps.smH,
                        Text(
                          '• ${result.distance!.toStringAsFixed(1)} km',
                          style: TextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: IconSizes.md,
            ),
          ],
        ),
      ),
    );
  }
}
