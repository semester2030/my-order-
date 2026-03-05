import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/localization/app_localizations.dart';

/// شاشة عرض سياسة الخصوصية أو الشروط والأحكام — المحتوى داخل التطبيق.
enum LegalContentType { privacy, terms }

class LegalContentScreen extends ConsumerWidget {
  const LegalContentScreen({
    super.key,
    required this.type,
  });

  final LegalContentType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isPrivacy = type == LegalContentType.privacy;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        backgroundColor: AppColors.warmBackground,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          isPrivacy ? l10n.privacyPolicy : l10n.termsConditions,
          style: TextStyles.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.legalLastUpdated,
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Gaps.mdV,
            if (isPrivacy) ...[
              _buildSection(l10n.privacySection1Title, l10n.privacySection1Body),
              _buildSection(l10n.privacySection2Title, l10n.privacySection2Body),
              _buildSection(l10n.privacySection3Title, l10n.privacySection3Body),
              _buildSection(l10n.privacySection4Title, l10n.privacySection4Body),
              _buildSection(l10n.privacySection5Title, l10n.privacySection5Body),
              _buildSection(l10n.privacySection6Title, l10n.privacySection6Body),
            ] else ...[
              _buildSection(l10n.termsSection1Title, l10n.termsSection1Body),
              _buildSection(l10n.termsSection2Title, l10n.termsSection2Body),
              _buildSection(l10n.termsSection3Title, l10n.termsSection3Body),
              _buildSection(l10n.termsSection4Title, l10n.termsSection4Body),
              _buildSection(l10n.termsSection5Title, l10n.termsSection5Body),
              _buildSection(l10n.termsSection6Title, l10n.termsSection6Body),
              _buildSection(l10n.termsSection7Title, l10n.termsSection7Body),
              _buildSection(l10n.termsSection8Title, l10n.termsSection8Body),
              _buildSection(l10n.termsSection9Title, l10n.termsSection9Body),
              _buildSection(l10n.termsSection10Title, l10n.termsSection10Body),
              _buildSection(l10n.termsSection11Title, l10n.termsSection11Body),
              _buildSection(l10n.termsSection12Title, l10n.termsSection12Body),
              _buildSection(l10n.termsSection13Title, l10n.termsSection13Body),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String body) {
    return Container(
      margin: const EdgeInsets.only(bottom: Insets.md),
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.smV,
          Text(
            body,
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
