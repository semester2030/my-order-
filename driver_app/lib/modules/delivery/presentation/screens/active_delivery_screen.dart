import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/maps/route_launcher.dart';
import '../../../jobs/presentation/providers/jobs_notifier.dart';
import '../../../jobs/presentation/providers/jobs_state.dart';
import '../../../jobs/data/models/active_job_dto.dart';
import '../providers/delivery_notifier.dart';
import '../providers/delivery_state.dart';
import '../providers/location_publisher.dart';
import '../widgets/order_summary_card.dart';
import '../widgets/customer_contact_bar.dart';
import '../widgets/delivery_stepper.dart';
import '../widgets/delivery_map_view.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/di/providers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActiveDeliveryScreen extends ConsumerStatefulWidget {
  const ActiveDeliveryScreen({super.key});

  @override
  ConsumerState<ActiveDeliveryScreen> createState() => _ActiveDeliveryScreenState();
}

class _ActiveDeliveryScreenState extends ConsumerState<ActiveDeliveryScreen> {
  final RouteLauncher _routeLauncher = RouteLauncher();
  Position? _currentDriverPosition;
  /// Tracks that driver tapped "Pickup Order" (backend keeps status out_for_delivery)
  bool _hasMarkedPickup = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadActiveJob();
      }
    });
  }

  @override
  void dispose() {
    // Stop location publishing when screen is disposed
    _stopLocationPublishing();
    super.dispose();
  }

  void _stopLocationPublishing() {
    final locationPublisher = ref.read(locationPublisherProvider);
    locationPublisher.stopPublishing();
  }

  Future<void> _loadActiveJob() async {
    if (!mounted) return;
    try {
      final activeJobState = ref.read(activeJobNotifierProvider);
      if (activeJobState is ActiveJobLoaded) {
        // Already have active job, just load delivery details
        final orderId = activeJobState.job.orderId;
        await ref
            .read(deliveryDetailsNotifierProvider.notifier)
            .getDeliveryDetails(orderId);
        
        // Start location publishing for active delivery
        final locationPublisher = ref.read(locationPublisherProvider);
        await locationPublisher.startPublishing(orderId);
        
        // Get initial driver position
        _updateDriverPosition();
      } else {
        // Load active job first
        await ref.read(activeJobNotifierProvider.notifier).getActiveJob();
        
        // After loading, check if we got a job and load details
        if (mounted) {
          final newState = ref.read(activeJobNotifierProvider);
          if (newState is ActiveJobLoaded) {
            final orderId = newState.job.orderId;
            await ref
                .read(deliveryDetailsNotifierProvider.notifier)
                .getDeliveryDetails(orderId);
            
            // Start location publishing for active delivery
            final locationPublisher = ref.read(locationPublisherProvider);
            await locationPublisher.startPublishing(orderId);
            
            // Get initial driver position
            _updateDriverPosition();
          }
        }
      }
    } catch (e) {
      // Error is handled by the notifier state
      if (mounted) {
        debugPrint('Error loading active job: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeJobState = ref.watch(activeJobNotifierProvider);
    final deliveryDetailsState = ref.watch(deliveryDetailsNotifierProvider);
    final statusState = ref.watch(updateDeliveryStatusNotifierProvider);

    // Listen to status updates
    ref.listen<UpdateDeliveryStatusState>(
      updateDeliveryStatusNotifierProvider,
      (previous, next) {
        if (next is UpdateDeliveryStatusSuccess) {
          if (next.status == 'delivered') {
            _stopLocationPublishing();
            final currentJob = ref.read(activeJobNotifierProvider);
            if (currentJob is ActiveJobLoaded) {
              ref.read(activeJobNotifierProvider.notifier).clearActiveJob();
              context.go(
                RouteNames.delivered,
                extra: {
                  'orderNumber': currentJob.job.orderNumber,
                  'driverEarnings': currentJob.job.driverEarnings,
                  'deliveryFee': currentJob.job.deliveryFee,
                  'vendorName': currentJob.job.order.vendor.name,
                  'total': currentJob.job.order.total,
                  'itemsCount': currentJob.job.order.items.length,
                },
              );
            } else {
              context.go(RouteNames.delivered);
            }
          } else {
            _loadActiveJob();
          }
        } else if (next is UpdateDeliveryStatusError) {
          AppSnackbar.showError(context, next.message);
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Active Delivery', style: TextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _buildContent(activeJobState, deliveryDetailsState, statusState),
    );
  }

  Widget _buildContent(
    ActiveJobState activeJobState,
    DeliveryDetailsState deliveryDetailsState,
    UpdateDeliveryStatusState statusState,
  ) {
    // Handle error state
    if (activeJobState is ActiveJobError) {
      return ErrorState(
        message: activeJobState.message,
        onRetry: () => _loadActiveJob(),
      );
    }

    // Handle empty state (no active job)
    if (activeJobState is ActiveJobEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 80,
              color: AppColors.textTertiary,
            ),
            Gaps.lgV,
            Text(
              'No active delivery',
              style: TextStyles.headlineMedium,
            ),
            Gaps.smV,
            Text(
              'Accept a job to start delivery',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Gaps.xlV,
            PrimaryButton(
              onPressed: () {
                // Job offers come via push notifications
                // Driver accepts/rejects from notification
                AppSnackbar.showInfo(
                  context,
                  'Job offers will be sent via notifications',
                );
              },
              text: 'Go to Profile',
              icon: Icons.person,
            ),
          ],
        ),
      );
    }

    // Handle loading or initial state
    if (activeJobState is ActiveJobInitial || activeJobState is ActiveJobLoading) {
      return const LoadingView(message: 'Loading active delivery...');
    }

    // Must be ActiveJobLoaded at this point
    if (activeJobState is! ActiveJobLoaded) {
      return const LoadingView();
    }

    final job = activeJobState.job;

    return switch (deliveryDetailsState) {
      DeliveryDetailsInitial() => const LoadingView(),
      DeliveryDetailsLoading() => const LoadingView(),
      DeliveryDetailsLoaded(:final details) => SingleChildScrollView(
          padding: const EdgeInsets.all(Insets.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Map View
              DeliveryMapView(
                job: job,
                details: details,
                driverLocation: _currentDriverPosition != null
                    ? LatLng(
                        _currentDriverPosition!.latitude,
                        _currentDriverPosition!.longitude,
                      )
                    : null,
              ),
              Gaps.lgV,

              // ETA & distance
              if (job.estimatedDuration > 0 || job.estimatedDistance > 0)
                _buildEtaCard(job),
              if (job.estimatedDuration > 0 || job.estimatedDistance > 0)
                Gaps.mdV,

              // Delivery Stepper
              DeliveryStepper(
                orderStatus: job.orderStatus,
                hasMarkedPickup: _hasMarkedPickup,
                onNavigateToRestaurant: () => _navigateToRestaurant(job),
                onPickup: () => _handlePickup(job.orderId),
                onNavigateToCustomer: () => _navigateToCustomer(job),
                onDelivered: () => _handleDelivered(job.orderId),
              ),
              Gaps.lgV,

              // Order Summary
              OrderSummaryCard(order: job.order),
              Gaps.mdV,

              // Customer Contact
              CustomerContactBar(
                customer: details.customer,
                address: details.deliveryAddress,
              ),
            ],
          ),
        ),
      DeliveryDetailsError(:final message) => ErrorState(
          message: message,
          onRetry: () => _loadActiveJob(),
        ),
    };
  }

  Widget _buildEtaCard(ActiveJobDto job) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      child: Padding(
        padding: const EdgeInsets.all(Insets.md),
        child: Row(
          children: [
            if (job.estimatedDuration > 0)
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, color: AppColors.primary),
                    Gaps.smH,
                    Text(
                      '~${job.estimatedDuration} min',
                      style: TextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gaps.xsH,
                    Text(
                      'ETA',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            if (job.estimatedDuration > 0 && job.estimatedDistance > 0)
              Container(
                width: 1,
                height: 24,
                color: AppColors.border,
              ),
            if (job.estimatedDistance > 0)
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.straighten, color: AppColors.primary),
                    Gaps.smH,
                    Text(
                      '${job.estimatedDistance.toStringAsFixed(1)} km',
                      style: TextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToRestaurant(ActiveJobDto job) async {
    final success = await _routeLauncher.openRoute(
      destinationLat: job.pickupLocation.latitude,
      destinationLng: job.pickupLocation.longitude,
      destinationName: job.order.vendor.name,
    );

    if (!success && mounted) {
      AppSnackbar.showError(context, 'Could not open navigation app');
    }
  }

  Future<void> _navigateToCustomer(ActiveJobDto job) async {
    final success = await _routeLauncher.openRoute(
      destinationLat: job.deliveryLocation.latitude,
      destinationLng: job.deliveryLocation.longitude,
      destinationName: 'Customer Location',
    );

    if (!success && mounted) {
      AppSnackbar.showError(context, 'Could not open navigation app');
    }
  }

  Future<void> _handlePickup(String orderId) async {
    await ref
        .read(updateDeliveryStatusNotifierProvider.notifier)
        .updateDeliveryStatus(orderId, 'picked_up');
    if (mounted) setState(() => _hasMarkedPickup = true);
  }

  Future<void> _handleDelivered(String orderId) async {
    ref
        .read(updateDeliveryStatusNotifierProvider.notifier)
        .updateDeliveryStatus(orderId, 'delivered');
  }

  Future<void> _updateDriverPosition() async {
    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentDriverPosition = position;
        });
      }
    } catch (e) {
      // Silently fail - position will be updated by location publisher
      debugPrint('Failed to get driver position: $e');
    }
  }
}
