// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../domain/entities/address.dart';

class AddressTile extends StatelessWidget {
  final Address address;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;

  const AddressTile({
    super.key,
    required this.address,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: Container(
        padding: const EdgeInsets.all(Insets.md),
        margin: const EdgeInsets.only(bottom: Insets.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppRadius.mdAll,
          border: Border.all(
            color: address.isDefault
                ? AppColors.primary
                : AppColors.border,
            width: address.isDefault ? 2 : 1,
          ),
          boxShadow: AppShadows.elevation1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: IconSizes.md,
                ),
                Gaps.smH,
                Expanded(
                  child: Text(
                    address.label,
                    style: TextStyles.titleMedium.copyWith(
                      color: address.isDefault
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Insets.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: AppRadius.smAll,
                    ),
                    child: Text(
                      'Default',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            Gaps.smV,
            Text(
              address.streetAddress,
              style: TextStyles.bodyMedium,
            ),
            if (address.building != null) ...[
              Gaps.xsV,
              Text(
                'Building ${address.building}',
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (address.apartment != null) ...[
              Gaps.xsV,
              Text(
                'Apartment ${address.apartment}',
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            Gaps.xsV,
            Text(
              '${address.city}${address.district != null ? ', ${address.district}' : ''}',
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (onEdit != null || onDelete != null || onSetDefault != null) ...[
              Gaps.mdV,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onSetDefault != null && !address.isDefault)
                    TextButton(
                      onPressed: onSetDefault,
                      child: Text(
                        'Set Default',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  if (onEdit != null)
                    IconButton(
                      icon: Icon(Icons.edit, size: IconSizes.sm),
                      onPressed: onEdit,
                      color: AppColors.textSecondary,
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(Icons.delete, size: IconSizes.sm),
                      onPressed: onDelete,
                      color: SemanticColors.error,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
