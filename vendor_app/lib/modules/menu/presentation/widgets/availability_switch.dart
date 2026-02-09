import 'package:flutter/material.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/modules/menu/domain/entities/menu_item.dart';

/// مفتاح توفر الوجبة — ثيم موحد (Phase 10).
class AvailabilitySwitch extends StatelessWidget {
  const AvailabilitySwitch({
    super.key,
    required this.item,
    required this.onChanged,
    this.isLoading = false,
  });

  final MenuItem item;
  final ValueChanged<bool> onChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.isAvailable ? 'متوفر' : 'غير متوفر',
          style: TextStyles.labelSmall.copyWith(
            color: item.isAvailable ? SemanticColors.success : AppColors.textTertiary,
          ),
        ),
        Gaps.smH,
        Switch(
          value: item.isAvailable,
          onChanged: isLoading ? null : (v) => onChanged(v),
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}
