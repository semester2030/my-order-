import 'package:flutter/material.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/modules/profile/domain/entities/vendor_profile.dart';

/// رأس البروفايل في شاشة الإعدادات — ثيم موحد (Phase 6).
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
  });

  final VendorProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        boxShadow: const [AppShadows.sm],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: Icon(
              Icons.person,
              size: IconSizes.xxl,
              color: AppColors.primary,
            ),
          ),
          Gaps.mdV,
          Text(
            profile.name,
            style: TextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (profile.tradeName != null && profile.tradeName!.isNotEmpty) ...[
            Gaps.xsV,
            Text(
              profile.tradeName!,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (profile.email != null && profile.email!.isNotEmpty) ...[
            Gaps.xsV,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email_outlined, size: IconSizes.sm, color: AppColors.textTertiary),
                Gaps.xsH,
                Text(
                  profile.email!,
                  style: TextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
