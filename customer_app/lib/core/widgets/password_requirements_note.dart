import 'package:flutter/material.dart';

import '../theme/design_system.dart';

/// توضيح شروط الرمز السري عند التسجيل أو اختيار كلمة المرور.
class PasswordRequirementsNote extends StatelessWidget {
  const PasswordRequirementsNote({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_outline, color: AppColors.primary, size: IconSizes.md),
          Gaps.smH,
          Expanded(
            child: Text(
              message,
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
