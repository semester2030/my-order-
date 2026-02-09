import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/status_badge.dart';
import '../providers/driver_profile_notifier.dart';
import '../providers/driver_profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/online_toggle.dart';
import '../../data/models/driver_profile_dto.dart';
import '../../../shared/enums/driver_status.dart';
import '../../../shared/enums/vehicle_type.dart';
import '../../../shared/enums/license_type.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/theme/driver_theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(driverProfileNotifierProvider.notifier).getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(driverProfileNotifierProvider);
    final availabilityState = ref.watch(driverAvailabilityNotifierProvider);

    // Listen to availability updates
    ref.listen<DriverAvailabilityState>(
      driverAvailabilityNotifierProvider,
      (previous, next) {
        if (next is DriverAvailabilityUpdated) {
          AppSnackbar.showSuccess(
            context,
            next.isOnline ? 'You are now online' : 'You are now offline',
          );
          // Refresh profile
          ref.read(driverProfileNotifierProvider.notifier).getProfile();
        } else if (next is DriverAvailabilityError) {
          AppSnackbar.showError(context, next.message);
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Profile', style: TextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _buildContent(profileState, availabilityState),
    );
  }

  Widget _buildContent(
    DriverProfileState profileState,
    DriverAvailabilityState availabilityState,
  ) {
    return switch (profileState) {
      DriverProfileInitial() => const LoadingView(),
      DriverProfileLoading() => const LoadingView(),
      DriverProfileLoaded(:final profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(Insets.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              ProfileHeaderWidget(profile: profile),
              Gaps.xlV,

              // Online/Offline Toggle
              OnlineToggleWidget(
                profile: profile,
                availabilityState: availabilityState,
              ),
              Gaps.xlV,

              // Profile Details
              _buildProfileDetails(profile),
              Gaps.xlV,

              // Settings
              _buildSettings(),
              Gaps.xlV,

              // Logout
              _buildLogoutButton(),
              Gaps.xlV,
            ],
          ),
        ),
      DriverProfileError(:final message) => ErrorState(
          message: message,
          onRetry: () {
            ref.read(driverProfileNotifierProvider.notifier).getProfile();
          },
        ),
    };
  }

  Widget _buildProfileHeader(DriverProfileDto profile) {
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
                profile.fullName.isNotEmpty ? profile.fullName[0].toUpperCase() : 'D',
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

  Widget _buildOnlineToggle(
    DriverProfileDto profile,
    DriverAvailabilityState availabilityState,
  ) {
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
                      profile.isOnline ? 'Online - Ready for jobs' : 'Offline',
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

  Widget _buildProfileDetails(DriverProfileDto profile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Details',
              style: TextStyles.titleLarge,
            ),
            Gaps.mdV,
            _buildDetailRow('Full Name', profile.fullName.isNotEmpty ? profile.fullName : 'N/A'),
            _buildDetailRow('National ID', profile.nationalId.isNotEmpty ? profile.nationalId : 'N/A'),
            if (profile.phoneNumber != null)
              _buildDetailRow('Phone', profile.phoneNumber!),
            if (profile.email != null) _buildDetailRow('Email', profile.email!),
            if (profile.licenseNumber != null)
              _buildDetailRow('License Number', profile.licenseNumber!),
            if (profile.licenseType != null)
              _buildDetailRow('License Type', profile.licenseType!.displayName),
            if (profile.licenseExpiryDate != null)
              _buildDetailRow('License Expiry', _formatDate(profile.licenseExpiryDate!)),
            if (profile.vehicleType != null)
              _buildDetailRow('Vehicle Type', profile.vehicleType!.displayName),
            if (profile.plateNumber != null)
              _buildDetailRow('Plate Number', profile.plateNumber!),
            if (profile.plateRegion != null)
              _buildDetailRow('Plate Region', profile.plateRegion!),
            if (profile.insuranceCompany != null)
              _buildDetailRow('Insurance Company', profile.insuranceCompany!),
            if (profile.insuranceExpiryDate != null)
              _buildDetailRow('Insurance Expiry', _formatDate(profile.insuranceExpiryDate!)),
            if (profile.currentLatitude != null && profile.currentLongitude != null)
              _buildDetailRow('Location', '${profile.currentLatitude!.toStringAsFixed(6)}, ${profile.currentLongitude!.toStringAsFixed(6)}'),
            if (profile.lastOnlineAt != null)
              _buildDetailRow('Last Online', _formatDateTime(profile.lastOnlineAt!)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () {
              context.push(RouteNames.languageSettings);
            },
          ),
          Divider(height: 1, color: AppColors.border),
          _buildSettingTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage notifications',
            onTap: () {
              context.push(RouteNames.notificationSettings);
            },
          ),
          Divider(height: 1, color: AppColors.border),
          _buildSettingTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help',
            onTap: () {
              context.push(RouteNames.help);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: TextStyles.bodyLarge),
      subtitle: Text(subtitle, style: TextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary,
      )),
      trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: DriverTheme.touchTargetMinSize,
      child: ElevatedButton(
        onPressed: () => _handleLogout(),
        style: ElevatedButton.styleFrom(
          backgroundColor: SemanticColors.error,
          foregroundColor: AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mdAll,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: IconSizes.md),
            Gaps.smH,
            Text('Logout', style: TextStyles.button),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout', style: TextStyles.headlineSmall),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyles.bodyMedium),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: SemanticColors.error,
            ),
            child: Text('Logout', style: TextStyles.bodyMedium.copyWith(
              color: SemanticColors.error,
              fontWeight: FontWeight.w600,
            )),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      try {
        // Logout
        await ref.read(authNotifierProvider.notifier).logout();
        
        // Navigate to welcome screen
        if (mounted) {
          context.go(RouteNames.welcome);
        }
      } catch (e) {
        if (mounted) {
          AppSnackbar.showError(context, 'Failed to logout: ${e.toString()}');
        }
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(DriverStatus status) {
    switch (status) {
      case DriverStatus.approved:
        return SemanticColors.success;
      case DriverStatus.pending:
      case DriverStatus.underReview:
        return SemanticColors.warning;
      case DriverStatus.rejected:
      case DriverStatus.suspended:
        return SemanticColors.error;
      case DriverStatus.inactive:
        return AppColors.textSecondary;
    }
  }
}
