// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/profile.dart';

bool _isEmail(String s) => s.contains('@');

class ProfileHeader extends StatelessWidget {
  final Profile profile;

  const ProfileHeader({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(Insets.xl),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: AppRadius.bottomLG,
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary,
            child: Text(
              (profile.name?.isNotEmpty == true
                      ? profile.name![0].toUpperCase()
                      : profile.contact.isNotEmpty
                          ? profile.contact[0].toUpperCase()
                          : '?')
                  .toUpperCase(),
              style: TextStyles.headlineLarge.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Gaps.lgV,
          // Name
          Text(
            profile.name ?? l.user,
            style: TextStyles.headlineMedium,
          ),
          if (profile.contact.isNotEmpty) ...[
            Gaps.xsV,
            Text(
              profile.contact,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (_isEmail(profile.contact))
              Text(
                l.emailLabel,
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            else
              Text(
                l.phoneLabel,
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
