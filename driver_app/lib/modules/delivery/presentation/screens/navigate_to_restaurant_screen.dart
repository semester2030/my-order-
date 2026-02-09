import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/maps/route_launcher.dart';
import '../../../jobs/presentation/providers/jobs_notifier.dart';
import '../../../jobs/presentation/providers/jobs_state.dart';
import '../../../jobs/data/models/active_job_dto.dart';

class NavigateToRestaurantScreen extends ConsumerStatefulWidget {
  const NavigateToRestaurantScreen({super.key});

  @override
  ConsumerState<NavigateToRestaurantScreen> createState() => _NavigateToRestaurantScreenState();
}

class _NavigateToRestaurantScreenState
    extends ConsumerState<NavigateToRestaurantScreen> {
  final RouteLauncher _routeLauncher = RouteLauncher();
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    final activeJobState = ref.watch(activeJobNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Navigate to Restaurant', style: TextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: switch (activeJobState) {
        ActiveJobLoaded(:final job) => SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Info
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
                        Row(
                          children: [
                            Icon(
                              Icons.restaurant,
                              size: IconSizes.lg,
                              color: AppColors.primary,
                            ),
                            Gaps.mdH,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job.order.vendor.name,
                                    style: TextStyles.titleLarge,
                                  ),
                                  Gaps.xsV,
                                  Text(
                                    job.order.vendor.address,
                                    style: TextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gaps.mdV,
                        _buildDetailRow(
                          Icons.route,
                          'Distance: ${job.estimatedDistance.toStringAsFixed(1)} km',
                        ),
                        Gaps.xsV,
                        _buildDetailRow(
                          Icons.access_time,
                          'Estimated: ${job.estimatedDuration} min',
                        ),
                      ],
                    ),
                  ),
                ),
                Gaps.xlV,

                // Navigation Actions
                PrimaryButton(
                  onPressed: _isNavigating ? null : () => _openNavigation(job),
                  text: 'Open Navigation',
                  icon: Icons.navigation,
                  isLoading: _isNavigating,
                ),
                Gaps.mdV,
                PrimaryButton(
                  onPressed: () => context.go(RouteNames.pickup),
                  text: 'I\'ve Arrived',
                  icon: Icons.location_on,
                ),
              ],
            ),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: IconSizes.sm, color: AppColors.textSecondary),
        Gaps.smH,
        Text(
          text,
          style: TextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Future<void> _openNavigation(ActiveJobDto job) async {
    setState(() => _isNavigating = true);
    try {
      final success = await _routeLauncher.openRoute(
        destinationLat: job.pickupLocation.latitude,
        destinationLng: job.pickupLocation.longitude,
        destinationName: job.order.vendor.name,
      );

      if (!mounted) return;

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open navigation app'),
            backgroundColor: SemanticColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isNavigating = false);
      }
    }
  }
}
