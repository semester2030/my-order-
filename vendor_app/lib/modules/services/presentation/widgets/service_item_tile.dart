import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/modules/services/domain/entities/service_item.dart';

/// عنصر قائمة خدمة — ثيم موحد (Phase 11).
class ServiceItemTile extends StatelessWidget {
  const ServiceItemTile({
    super.key,
    required this.item,
  });

  final ServiceItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: InkWell(
        onTap: () => context.push(RouteNames.serviceItemEdit(item.id)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (item.description != null && item.description!.isNotEmpty) ...[
                      Gaps.xsV,
                      Text(
                        item.description!,
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (item.price != null) ...[
                      Gaps.xsV,
                      Text(
                        Formatters.currency(item.price),
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    Gaps.xsV,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
                      decoration: BoxDecoration(
                        color: item.isActive
                            ? SemanticColors.success.withValues(alpha: 0.15)
                            : AppColors.textTertiary.withValues(alpha: 0.15),
                        borderRadius: AppRadius.smAll,
                      ),
                      child: Text(
                        item.isActive ? 'نشط' : 'غير نشط',
                        style: TextStyles.labelSmall.copyWith(
                          color: item.isActive ? SemanticColors.success : AppColors.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_left, color: AppColors.textTertiary, size: IconSizes.md),
            ],
          ),
        ),
      ),
    );
  }
}
