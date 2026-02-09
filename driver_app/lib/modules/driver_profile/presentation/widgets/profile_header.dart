import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../shared/enums/driver_status.dart';
import '../../data/models/driver_profile_dto.dart';

/// Profile Header Widget
/// 
/// Displays driver profile header with avatar, name, and status
class ProfileHeaderWidget extends StatelessWidget {
  final DriverProfileDto profile;

  const ProfileHeaderWidget({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primaryContainer,
              child: Text(
                profile.fullName.isNotEmpty
                    ? profile.fullName[0].toUpperCase()
                    : 'D',
                style: TextStyles.displayMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            Gaps.mdV,
            Text(
              profile.fullName.isNotEmpty ? profile.fullName : 'Driver',
              style: TextStyles.headlineMedium,
            ),
            Gaps.xsV,
            StatusBadge(
              text: profile.status.displayName,
              backgroundColor: _getStatusColor(profile.status).withValues(alpha: 0.1),
              textColor: _getStatusColor(profile.status),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(DriverStatus status) {
    return switch (status) {
      DriverStatus.pending => SemanticColors.warning,
      DriverStatus.underReview => SemanticColors.info,
      DriverStatus.approved => SemanticColors.success,
      DriverStatus.rejected => SemanticColors.error,
      DriverStatus.suspended => SemanticColors.error,
      DriverStatus.inactive => AppColors.textSecondary,
    };
  }
}
