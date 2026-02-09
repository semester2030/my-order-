import 'package:flutter/material.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/modules/side_orders/domain/entities/side_order_item.dart';

/// عنصر طلب جانبي — Phase 12.
class SideOrderTile extends StatelessWidget {
  const SideOrderTile({
    super.key,
    required this.item,
    this.onTap,
    this.onRemove,
  });

  final SideOrderItem item;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
          child: Row(
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
                    Gaps.xsV,
                    Text(
                      Formatters.currency(item.price),
                      style: TextStyles.bodyMedium.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              if (onRemove != null)
                IconButton(
                  icon: Icon(Icons.delete_outline, color: SemanticColors.error, size: IconSizes.md),
                  onPressed: onRemove,
                )
              else
                Icon(Icons.chevron_left, color: AppColors.textTertiary, size: IconSizes.md),
            ],
          ),
        ),
      ),
    );
  }
}

