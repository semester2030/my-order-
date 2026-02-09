import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/app_snackbar.dart';

/// Help Screen
/// 
/// Provides help and support information
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Help & Support', style: TextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpSection(
              icon: Icons.help_outline,
              title: 'Frequently Asked Questions',
              onTap: () {
                // TODO: Navigate to FAQ screen
                AppSnackbar.showInfo(context, 'FAQ coming soon');
              },
            ),
            Gaps.mdV,
            _buildHelpSection(
              icon: Icons.phone_outlined,
              title: 'Contact Support',
              subtitle: 'Call or message our support team',
              onTap: () => _contactSupport(context),
            ),
            Gaps.mdV,
            _buildHelpSection(
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'support@example.com',
              onTap: () => _emailSupport(context),
            ),
            Gaps.mdV,
            _buildHelpSection(
              icon: Icons.chat_bubble_outline,
              title: 'Live Chat',
              onTap: () {
                // TODO: Open live chat
                AppSnackbar.showInfo(context, 'Live chat coming soon');
              },
            ),
            Gaps.xlV,
            Text(
              'App Information',
              style: TextStyles.titleLarge,
            ),
            Gaps.mdV,
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
              child: Padding(
                padding: const EdgeInsets.all(Insets.md),
                child: Column(
                  children: [
                    _buildInfoRow('Version', '1.0.0'),
                    _buildInfoRow('Build', '1'),
                    _buildInfoRow('Platform', 'iOS / Android'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: TextStyles.bodyLarge),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: Icon(Icons.chevron_right, color: AppColors.textTertiary),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _contactSupport(BuildContext context) async {
    final uri = Uri.parse('tel:+966501234567');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppSnackbar.showError(context, 'Could not open phone dialer');
    }
  }

  Future<void> _emailSupport(BuildContext context) async {
    final uri = Uri.parse('mailto:support@example.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppSnackbar.showError(context, 'Could not open email client');
    }
  }
}
