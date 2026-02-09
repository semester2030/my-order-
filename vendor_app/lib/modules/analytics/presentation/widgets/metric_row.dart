import 'package:flutter/material.dart';
import 'package:vendor_app/core/theme/design_system.dart';

/// صف مقياس واحد (عنوان + قيمة) — Phase 14.
class MetricRow extends StatelessWidget {
  const MetricRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Insets.sm),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: IconSizes.md, color: AppColors.primary),
            Gaps.smH,
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Text(
            value,
            style: TextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
