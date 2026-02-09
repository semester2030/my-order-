import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../shared/enums/driver_status.dart';
import '../../../driver_profile/presentation/providers/driver_profile_notifier.dart';

/// Blocked or Pending Screen
/// 
/// Shown when driver account is blocked, pending, or under review
class BlockedOrPendingScreen extends ConsumerWidget {
  final DriverStatus status;

  const BlockedOrPendingScreen({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPending = status == DriverStatus.pending ||
        status == DriverStatus.underReview;
    final isBlocked = status == DriverStatus.rejected ||
        status == DriverStatus.suspended;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Insets.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPending ? Icons.pending_outlined : Icons.block,
                size: 100,
                color: isPending
                    ? SemanticColors.warning
                    : SemanticColors.error,
              ),
              Gaps.xlV,
              Text(
                isPending ? 'Account Pending' : 'Account Blocked',
                style: TextStyles.headlineLarge,
                textAlign: TextAlign.center,
              ),
              Gaps.mdV,
              Text(
                _getMessage(status),
                style: TextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.xlV,
              if (isPending) ...[
                PrimaryButton(
                  onPressed: () {
                    ref
                        .read(driverProfileNotifierProvider.notifier)
                        .getProfile();
                  },
                  text: 'Refresh Status',
                  icon: Icons.refresh,
                ),
                Gaps.mdV,
                SecondaryButton(
                  onPressed: () {
                    context.go(RouteNames.trackApplication);
                  },
                  text: 'Track Application',
                  icon: Icons.track_changes,
                ),
              ] else if (isBlocked) ...[
                PrimaryButton(
                  onPressed: () {
                    // TODO: Contact support
                  },
                  text: 'Contact Support',
                  icon: Icons.support_agent,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getMessage(DriverStatus status) {
    return switch (status) {
      DriverStatus.pending =>
        'Your account is pending approval. Please wait while we review your application.',
      DriverStatus.underReview =>
        'Your account is under review. We will notify you once the review is complete.',
      DriverStatus.rejected =>
        'Your account has been rejected. Please contact support for more information.',
      DriverStatus.suspended =>
        'Your account has been suspended. Please contact support for more information.',
      DriverStatus.inactive =>
        'Your account is inactive. Please contact support to reactivate.',
      _ => 'Your account status requires attention. Please contact support.',
    };
  }
}
