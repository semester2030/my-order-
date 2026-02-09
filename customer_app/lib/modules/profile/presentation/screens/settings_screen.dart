// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyles.titleLarge,
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 4),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Settings Section
              Text(
                'App Settings',
                style: TextStyles.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Gaps.mdV,
              // Notifications
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () {
                  // TODO: Navigate to notifications settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Notifications settings coming soon'),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
              ),
              Gaps.smV,
              // Language
              _SettingsTile(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: 'Change app language',
                onTap: () {
                  // TODO: Navigate to language settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Language settings coming soon'),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
              ),
              Gaps.smV,
              // Theme
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                title: 'Theme',
                subtitle: 'Light / Dark mode',
                onTap: () {
                  // TODO: Navigate to theme settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Theme settings coming soon'),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
              ),
              Gaps.xlV,
              // About Section
              Text(
                'About',
                style: TextStyles.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Gaps.mdV,
              // Help & Support
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                onTap: () {
                  // TODO: Navigate to help screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Help & Support coming soon'),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
              ),
              Gaps.smV,
              // Terms & Conditions
              _SettingsTile(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                subtitle: 'Read our terms and conditions',
                onTap: () {
                  // TODO: Navigate to terms screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Terms & Conditions coming soon'),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
              ),
              Gaps.smV,
              // Privacy Policy
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () {
                  // TODO: Navigate to privacy policy screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Privacy Policy coming soon'),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
              ),
              Gaps.smV,
              // App Version
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'App Version',
                subtitle: '1.0.0',
                onTap: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: Container(
        padding: const EdgeInsets.all(Insets.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppRadius.mdAll,
          boxShadow: AppShadows.elevation1,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: IconSizes.md,
            ),
            Gaps.mdH,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.titleMedium,
                  ),
                  if (subtitle != null) ...[
                    Gaps.xsV,
                    Text(
                      subtitle!,
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}
