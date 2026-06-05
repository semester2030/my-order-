import 'package:flutter/material.dart';

import '../theme/design_system.dart';

/// شريط علوي خفيف يذكّر الزائر أنه يتصفح بدون حساب.
class GuestExploreBanner extends StatelessWidget {
  const GuestExploreBanner({
    super.key,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryContainer.withValues(alpha: 0.65),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: Insets.sm,
        ),
        child: Row(
          children: [
            Icon(Icons.explore_outlined, color: AppColors.primary, size: IconSizes.md),
            Gaps.smH,
            Expanded(
              child: Text(
                message,
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.35,
                ),
              ),
            ),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
