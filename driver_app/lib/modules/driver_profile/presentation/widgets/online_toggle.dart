import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_system.dart';
import '../../../shared/enums/driver_status.dart';
import '../../data/models/driver_profile_dto.dart';
import '../providers/driver_profile_notifier.dart';
import '../providers/driver_profile_state.dart';

/// Online/Offline Toggle Widget
/// 
/// Displays availability toggle with status information
class OnlineToggleWidget extends ConsumerWidget {
  final DriverProfileDto profile;
  final DriverAvailabilityState availabilityState;

  const OnlineToggleWidget({
    super.key,
    required this.profile,
    required this.availabilityState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUpdating = availabilityState is DriverAvailabilityUpdating;
    final canToggle = profile.status == DriverStatus.approved;
    final isPending = profile.status == DriverStatus.pending ||
        profile.status == DriverStatus.underReview;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Availability',
                      style: TextStyles.titleMedium,
                    ),
                    Gaps.xsV,
                    Text(
                      profile.isOnline
                          ? 'Online - Ready for jobs'
                          : 'Offline',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: profile.isOnline,
                  onChanged: canToggle && !isUpdating
                      ? (value) {
                          ref
                              .read(driverAvailabilityNotifierProvider.notifier)
                              .updateAvailability(value);
                        }
                      : null,
                  activeColor: SemanticColors.success,
                ),
              ],
            ),
            if (isPending) ...[
              Gaps.mdV,
              Container(
                padding: const EdgeInsets.all(Insets.sm),
                decoration: BoxDecoration(
                  color: SemanticColors.warning.withValues(alpha: 0.1),
                  borderRadius: AppRadius.smAll,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: IconSizes.sm,
                      color: SemanticColors.warning,
                    ),
                    Gaps.smH,
                    Expanded(
                      child: Text(
                        'Your account is pending approval. You cannot go online until approved.',
                        style: TextStyles.bodySmall.copyWith(
                          color: SemanticColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
