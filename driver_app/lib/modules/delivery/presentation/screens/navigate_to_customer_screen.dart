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
import '../widgets/customer_contact_bar.dart';
import '../providers/delivery_notifier.dart';
import '../providers/delivery_state.dart';

class NavigateToCustomerScreen extends ConsumerStatefulWidget {
  const NavigateToCustomerScreen({super.key});

  @override
  ConsumerState<NavigateToCustomerScreen> createState() =>
      _NavigateToCustomerScreenState();
}

class _NavigateToCustomerScreenState
    extends ConsumerState<NavigateToCustomerScreen> {
  final RouteLauncher _routeLauncher = RouteLauncher();
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDeliveryDetails();
    });
  }

  Future<void> _loadDeliveryDetails() async {
    final activeJobState = ref.read(activeJobNotifierProvider);
    if (activeJobState is ActiveJobLoaded) {
      await ref
          .read(deliveryDetailsNotifierProvider.notifier)
          .getDeliveryDetails(activeJobState.job.orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeJobState = ref.watch(activeJobNotifierProvider);
    final deliveryDetailsState = ref.watch(deliveryDetailsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Navigate to Customer', style: TextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: switch ((activeJobState, deliveryDetailsState)) {
        (ActiveJobLoaded(:final job), DeliveryDetailsLoaded(:final details)) =>
          SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Contact
                CustomerContactBar(
                  customer: details.customer,
                  address: details.deliveryAddress,
                ),
                Gaps.lgV,

                // Delivery Info
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
                          'Delivery Info',
                          style: TextStyles.titleLarge,
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
                  onPressed: _isNavigating
                      ? null
                      : () => _openNavigation(job),
                  text: 'Open Navigation',
                  icon: Icons.navigation,
                  isLoading: _isNavigating,
                ),
                Gaps.mdV,
                PrimaryButton(
                  onPressed: () => context.go(RouteNames.delivered),
                  text: 'Mark as Delivered',
                  icon: Icons.done_all,
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
        destinationLat: job.deliveryLocation.latitude,
        destinationLng: job.deliveryLocation.longitude,
        destinationName: 'Customer Location',
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
