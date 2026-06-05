import 'package:flutter/material.dart';

import '../theme/design_system.dart';

/// رسالة بديلة عن أزرار الدفع الإلكتروني قبل تفعيل بوابة الدفع.
class ElectronicPaymentComingSoonBanner extends StatelessWidget {
  const ElectronicPaymentComingSoonBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: IconSizes.md),
          Gaps.smH,
          Expanded(
            child: Text(
              message,
              style: TextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
