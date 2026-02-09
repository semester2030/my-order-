import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../jobs/presentation/providers/jobs_notifier.dart';
import '../../../jobs/presentation/providers/jobs_state.dart';
import '../providers/delivery_notifier.dart';
import '../providers/delivery_state.dart';

class PickupScreen extends ConsumerStatefulWidget {
  const PickupScreen({super.key});

  @override
  ConsumerState<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends ConsumerState<PickupScreen> {
  bool _isConfirming = false;

  @override
  Widget build(BuildContext context) {
    final activeJobState = ref.watch(activeJobNotifierProvider);

    // Listen to status updates
    ref.listen<UpdateDeliveryStatusState>(
      updateDeliveryStatusNotifierProvider,
      (previous, next) {
        if (next is UpdateDeliveryStatusSuccess) {
          context.go(RouteNames.navigateToCustomer);
        } else if (next is UpdateDeliveryStatusError) {
          AppSnackbar.showError(context, next.message);
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Pickup Order', style: TextStyles.headlineMedium),
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
                // Confirmation Card
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
                          Icons.check_circle_outline,
                          size: 80,
                          color: SemanticColors.success,
                        ),
                        Gaps.lgV,
                        Text(
                          'Confirm Pickup',
                          style: TextStyles.headlineMedium,
                        ),
                        Gaps.smV,
                        Text(
                          'Order #${job.orderNumber}',
                          style: TextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Gaps.lgV,
                        Text(
                          'Please confirm that you have picked up the order from the restaurant.',
                          style: TextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Gaps.xlV,

                // Order Summary
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
                          'Order Details',
                          style: TextStyles.titleLarge,
                        ),
                        Gaps.mdV,
                        _buildDetailRow('Vendor', job.order.vendor.name),
                        _buildDetailRow('Items', '${job.order.items.length} items'),
                        _buildDetailRow('Total', '${job.order.total.toStringAsFixed(2)} SAR'),
                      ],
                    ),
                  ),
                ),
                Gaps.xlV,

                // Confirm Button
                PrimaryButton(
                  onPressed: _isConfirming
                      ? null
                      : () => _confirmPickup(job.orderId),
                  text: 'Confirm Pickup',
                  icon: Icons.check,
                  isLoading: _isConfirming,
                ),
              ],
            ),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
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

  Future<void> _confirmPickup(String orderId) async {
    setState(() => _isConfirming = true);
    ref
        .read(updateDeliveryStatusNotifierProvider.notifier)
        .updateDeliveryStatus(orderId, 'picked_up');
    setState(() => _isConfirming = false);
  }
}
