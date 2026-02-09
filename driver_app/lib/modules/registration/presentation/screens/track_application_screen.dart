import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/di/providers.dart';
import '../providers/registration_notifier.dart';
import '../providers/registration_state.dart';
import '../../../shared/enums/driver_status.dart';
import '../../domain/entities/driver_entity.dart';
import '../../../driver_profile/presentation/providers/driver_profile_notifier.dart';

class TrackApplicationScreen extends ConsumerStatefulWidget {
  final String? driverId;

  const TrackApplicationScreen({
    super.key,
    this.driverId,
  });

  @override
  ConsumerState<TrackApplicationScreen> createState() => _TrackApplicationScreenState();
}

class _TrackApplicationScreenState extends ConsumerState<TrackApplicationScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.driverId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(registrationNotifierProvider.notifier)
            .trackApplication(widget.driverId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final registrationState = ref.watch(registrationNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Track Application', style: TextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _buildContent(registrationState),
    );
  }

  Widget _buildContent(RegistrationState state) {
    return switch (state) {
      RegistrationInitial() => const LoadingView(),
      RegistrationLoading() => const LoadingView(),
      RegistrationTrackSuccess(:final driver) => SingleChildScrollView(
          padding: const EdgeInsets.all(Insets.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.lgAll,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Insets.xl),
                  child: Column(
                    children: [
                      Icon(
                        _getStatusIcon(driver.status),
                        size: 80,
                        color: _getStatusColor(driver.status),
                      ),
                      Gaps.lgV,
                      Text(
                        driver.status.displayName,
                        style: TextStyles.headlineLarge.copyWith(
                          color: _getStatusColor(driver.status),
                        ),
                      ),
                      Gaps.smV,
                      Text(
                        _getStatusMessage(driver.status),
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.xlV,

              // Driver Info
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.lgAll,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Insets.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Application Details',
                        style: TextStyles.titleLarge,
                      ),
                      Gaps.mdV,
                      _buildDetailRow('Full Name', driver.fullName),
                      _buildDetailRow('National ID', driver.nationalId),
                      _buildDetailRow('Status', driver.status.displayName),
                      _buildDetailRow(
                        'Submitted',
                        _formatDate(driver.createdAt),
                      ),
                      _buildDetailRow(
                        'Last Updated',
                        _formatDate(driver.updatedAt),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.xlV,

              // Actions
              if (driver.status == DriverStatus.approved)
                PrimaryButton(
                  onPressed: () async {
                    // Driver is approved, verify existence before navigating
                    try {
                      final repository = ref.read(driverProfileRepositoryProvider);
                      final driverExists = await repository.checkDriverExists();
                      
                      if (!mounted) return;
                      
                      if (driverExists) {
                        context.go(RouteNames.mainShell);
                      } else {
                        // Driver doesn't exist (shouldn't happen if approved, but check anyway)
                        AppSnackbar.showError(context, 'Driver profile not found. Please contact support.');
                      }
                    } catch (e) {
                      if (mounted) {
                        AppSnackbar.showError(context, 'Failed to verify driver: ${e.toString()}');
                      }
                    }
                  },
                  text: 'Go to App',
                  icon: Icons.check_circle,
                )
              else if (driver.status == DriverStatus.rejected)
                PrimaryButton(
                  onPressed: () => context.go(RouteNames.registerStep1),
                  text: 'Reapply',
                  icon: Icons.refresh,
                ),
            ],
          ),
        ),
      RegistrationError(:final message) => ErrorState(
          message: message,
          onRetry: widget.driverId != null
              ? () {
                  ref
                      .read(registrationNotifierProvider.notifier)
                      .trackApplication(widget.driverId!);
                }
              : null,
        ),
      _ => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 80,
                color: AppColors.textTertiary,
              ),
              Gaps.lgV,
              Text(
                'No application to track',
                style: TextStyles.headlineMedium,
              ),
              Gaps.smV,
              Text(
                'Please complete registration first',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
    };
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.sm),
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
            style: TextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(DriverStatus status) {
    switch (status) {
      case DriverStatus.approved:
        return Icons.check_circle;
      case DriverStatus.pending:
      case DriverStatus.underReview:
        return Icons.hourglass_empty;
      case DriverStatus.rejected:
        return Icons.cancel;
      case DriverStatus.suspended:
        return Icons.block;
      case DriverStatus.inactive:
        return Icons.pause_circle;
    }
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

  String _getStatusMessage(DriverStatus status) {
    switch (status) {
      case DriverStatus.approved:
        return 'Your application has been approved! You can now start accepting jobs.';
      case DriverStatus.pending:
        return 'Your application is pending review. We will notify you once it\'s reviewed.';
      case DriverStatus.underReview:
        return 'Your application is under review. Please wait for our team to process it.';
      case DriverStatus.rejected:
        return 'Your application has been rejected. Please contact support for more information.';
      case DriverStatus.suspended:
        return 'Your account has been suspended. Please contact support.';
      case DriverStatus.inactive:
        return 'Your account is inactive. Please contact support to reactivate.';
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }
}
