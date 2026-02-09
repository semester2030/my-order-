import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../data/models/active_job_dto.dart';

class NewJobBanner extends StatelessWidget {
  final ActiveJobDto job;
  final VoidCallback onTap;

  const NewJobBanner({
    super.key,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: SemanticColors.successContainer,
        border: Border(
          bottom: BorderSide(
            color: SemanticColors.success.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Insets.sm),
              decoration: BoxDecoration(
                color: SemanticColors.success,
                borderRadius: AppRadius.mdAll,
              ),
              child: const Icon(
                Icons.local_shipping,
                color: AppColors.textOnPrimary,
                size: IconSizes.lg,
              ),
            ),
            Gaps.mdH,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Delivery',
                    style: TextStyles.titleMedium.copyWith(
                      color: SemanticColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.xsV,
                  Text(
                    'Order #${job.orderNumber}',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: SemanticColors.success,
              size: IconSizes.sm,
            ),
          ],
        ),
      ),
    );
  }
}
