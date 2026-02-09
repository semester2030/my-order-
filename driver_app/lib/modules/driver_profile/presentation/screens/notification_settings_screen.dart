import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_snackbar.dart';

/// Notification Settings Screen
/// 
/// Allows driver to configure notification preferences
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  bool _jobOffersEnabled = true;
  bool _deliveryUpdatesEnabled = true;
  bool _systemNotificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Notification Settings', style: TextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Preferences',
              style: TextStyles.titleLarge,
            ),
            Gaps.lgV,
            _buildNotificationSection(
              'Job Offers',
              'Receive notifications for new job offers',
              _jobOffersEnabled,
              (value) => setState(() => _jobOffersEnabled = value),
            ),
            Gaps.mdV,
            _buildNotificationSection(
              'Delivery Updates',
              'Receive notifications for delivery status updates',
              _deliveryUpdatesEnabled,
              (value) => setState(() => _deliveryUpdatesEnabled = value),
            ),
            Gaps.mdV,
            _buildNotificationSection(
              'System Notifications',
              'Receive system and account notifications',
              _systemNotificationsEnabled,
              (value) => setState(() => _systemNotificationsEnabled = value),
            ),
            Gaps.xlV,
            Text(
              'Notification Style',
              style: TextStyles.titleLarge,
            ),
            Gaps.lgV,
            _buildNotificationSection(
              'Sound',
              'Play sound for notifications',
              _soundEnabled,
              (value) => setState(() => _soundEnabled = value),
            ),
            Gaps.mdV,
            _buildNotificationSection(
              'Vibration',
              'Vibrate for notifications',
              _vibrationEnabled,
              (value) => setState(() => _vibrationEnabled = value),
            ),
            Gaps.xlV,
            PrimaryButton(
              onPressed: _saveSettings,
              text: 'Save Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(
    String title,
    String description,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      child: SwitchListTile(
        title: Text(title, style: TextStyles.bodyLarge),
        subtitle: Text(
          description,
          style: TextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Future<void> _saveSettings() async {
    // TODO: Save notification preferences to local storage
    AppSnackbar.showSuccess(context, 'Notification settings saved');
    Navigator.of(context).pop();
  }
}
