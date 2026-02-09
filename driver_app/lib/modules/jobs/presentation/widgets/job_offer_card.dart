import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../data/models/job_offer_dto.dart';
import 'job_countdown_timer.dart';

class JobOfferCard extends StatelessWidget {
  final JobOfferDto job;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const JobOfferCard({
    super.key,
    required this.job,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isExpired = job.expiresAt.isBefore(DateTime.now());

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgAll,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${job.orderNumber}',
                  style: TextStyles.titleLarge,
                ),
                if (!isExpired)
                  JobCountdownTimer(expiresAt: job.expiresAt),
              ],
            ),
            Gaps.smV,

            // Earnings
            Container(
              padding: const EdgeInsets.all(Insets.sm),
              decoration: BoxDecoration(
                color: SemanticColors.successContainer,
                borderRadius: AppRadius.mdAll,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    color: SemanticColors.success,
                    size: IconSizes.md,
                  ),
                  Gaps.smH,
                  Text(
                    '${job.driverEarnings.toStringAsFixed(2)} SAR',
                    style: TextStyles.titleMedium.copyWith(
                      color: SemanticColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.mdV,

            // Details
            _buildDetailRow(
              Icons.route,
              'Distance: ${job.estimatedDistance.toStringAsFixed(1)} km',
            ),
            Gaps.xsV,
            _buildDetailRow(
              Icons.access_time,
              'Duration: ${job.estimatedDuration} min',
            ),
            Gaps.xsV,
            _buildDetailRow(
              Icons.local_shipping,
              'Fee: ${job.deliveryFee.toStringAsFixed(2)} SAR',
            ),

            Gaps.lgV,

            // Actions
            if (isExpired)
              Container(
                padding: const EdgeInsets.all(Insets.sm),
                decoration: BoxDecoration(
                  color: SemanticColors.errorContainer,
                  borderRadius: AppRadius.mdAll,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: SemanticColors.error,
                      size: IconSizes.sm,
                    ),
                    Gaps.smH,
                    Text(
                      'Expired',
                      style: TextStyles.bodyMedium.copyWith(
                        color: SemanticColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      onPressed: onReject,
                      text: 'Reject',
                    ),
                  ),
                  Gaps.mdH,
                  Expanded(
                    child: PrimaryButton(
                      onPressed: onAccept,
                      text: 'Accept',
                      icon: Icons.check,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: IconSizes.sm,
          color: AppColors.textSecondary,
        ),
        Gaps.smH,
        Text(
          text,
          style: TextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
