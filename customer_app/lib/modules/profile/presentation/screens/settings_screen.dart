// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/di/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.settings,
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
              Text(
                l10n.appSettings,
                style: TextStyles.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Gaps.mdV,
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: l10n.notifications,
                subtitle: l10n.manageNotifications,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.comingSoon),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
              ),
              Gaps.smV,
              _SettingsTile(
                icon: Icons.language_outlined,
                title: l10n.language,
                subtitle: l10n.changeLanguage,
                onTap: () => _showLanguageSheet(context, ref),
              ),
              Gaps.smV,
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                title: l10n.theme,
                subtitle: l10n.lightDarkMode,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.comingSoon),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
              ),
              Gaps.xlV,
              Text(
                l10n.about,
                style: TextStyles.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Gaps.mdV,
              _SettingsTile(
                icon: Icons.help_outline,
                title: l10n.helpSupport,
                subtitle: l10n.getHelp,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.comingSoon), backgroundColor: AppColors.info),
                  );
                },
              ),
              Gaps.smV,
              _SettingsTile(
                icon: Icons.description_outlined,
                title: l10n.termsConditions,
                subtitle: l10n.readTerms,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.comingSoon), backgroundColor: AppColors.info),
                  );
                },
              ),
              Gaps.smV,
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: l10n.privacyPolicy,
                subtitle: l10n.readPrivacy,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.comingSoon), backgroundColor: AppColors.info),
                  );
                },
              ),
              Gaps.smV,
              _SettingsTile(
                icon: Icons.info_outline,
                title: l10n.appVersion,
                subtitle: '1.0.0',
                onTap: null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.topLG,
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.languageAr),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              title: Text(l10n.languageEn),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
            ),
          ],
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
