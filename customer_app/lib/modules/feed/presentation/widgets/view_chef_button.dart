// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/theme/design_system.dart' as components;

/// زر عرض صفحة الطباخ/مقدم الخدمة (بدل View Restaurant — هوية طبخ منزلي).
class ViewChefButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ViewChefButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: components.ButtonTheme.outlined.copyWith(
        side: WidgetStateProperty.all(
          BorderSide(
            color: AppColors.textInverse,
            width: 1.5,
          ),
        ),
        foregroundColor: WidgetStateProperty.all(AppColors.textInverse),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: Insets.md,
            vertical: Insets.sm,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.ramen_dining,
            size: IconSizes.xs,
          ),
          Gaps.xsH,
          Flexible(
            child: Text(
              'عرض الطباخ',
              style: TextStyles.button.copyWith(
                color: AppColors.textInverse,
                fontSize: FontSizes.bodySmall,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
