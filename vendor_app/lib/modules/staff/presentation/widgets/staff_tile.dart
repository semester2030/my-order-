import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/modules/staff/domain/entities/staff_member.dart';

/// عنصر قائمة موظف — Phase 13.
class StaffTile extends StatelessWidget {
  const StaffTile({
    super.key,
    required this.item,
  });

  final StaffMember item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: InkWell(
        onTap: () => context.push(RouteNames.staffMemberEdit(item.id)),
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
                    if (item.role != null && item.role!.isNotEmpty) ...[
                      Gaps.xsV,
                      Text(
                        item.role!,
                        style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                    if (item.phone != null && item.phone!.isNotEmpty) ...[
                      Gaps.xsV,
                      Text(
                        item.phone!,
                        style: TextStyles.labelSmall.copyWith(color: AppColors.textTertiary),
                      ),
                    ],
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
