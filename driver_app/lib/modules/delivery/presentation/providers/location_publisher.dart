import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/di/providers.dart';
import '../providers/delivery_notifier.dart';

/// Location Publisher Provider
/// 
/// Publishes driver location to backend during active delivery
/// - Starts when delivery begins
/// - Sends location every 5 seconds
/// - Stops when delivery ends
final locationPublisherProvider = Provider<LocationPublisher>((ref) {
  final locationService = ref.watch(locationServiceProvider);
  final updateLocationNotifier = ref.watch(updateLocationNotifierProvider.notifier);
  return LocationPublisher(
    locationService: locationService,
    updateLocationNotifier: updateLocationNotifier,
  );
});

/// Location Service Provider
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Location Publisher
/// 
/// Handles publishing driver location to backend during active delivery
class LocationPublisher {
  final LocationService locationService;
  final UpdateLocationNotifier updateLocationNotifier;
  
  String? _currentOrderId;
  Timer? _publishTimer;
  bool _isPublishing = false;
  Position? _lastPublishedPosition;

  LocationPublisher({
    required this.locationService,
    required this.updateLocationNotifier,
  });

  /// Start publishing location for active delivery
  /// 
  /// [orderId] - The order ID for the active delivery
  Future<void> startPublishing(String orderId) async {
    // Stop any existing publishing
    await stopPublishing();

    _currentOrderId = orderId;
    _isPublishing = true;

    // Start location tracking with active delivery mode
    await locationService.startTracking(isActiveDelivery: true);

    // Add listener to LocationService for real-time updates
    locationService.addListener(_onLocationUpdate);

    // Start periodic publishing (every 5 seconds) as backup
    _publishTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_isPublishing && _currentOrderId != null) {
        await _publishLocation();
      }
    });
  }

  /// Stop publishing location
  Future<void> stopPublishing() async {
    _isPublishing = false;
    _currentOrderId = null;

    // Cancel timer
    _publishTimer?.cancel();
    _publishTimer = null;

    // Remove listener
    locationService.removeListener(_onLocationUpdate);

    // Stop location tracking (switch to idle mode)
    await locationService.updateTrackingMode(isActiveDelivery: false);
  }

  /// Handle location update from LocationService
  void _onLocationUpdate(Position position) {
    if (!_isPublishing || _currentOrderId == null) return;

    // Store last position
    _lastPublishedPosition = position;

    // Publish location immediately (fire-and-forget)
    _publishLocation(position);
  }

  /// Publish location to backend
  /// 
  /// [position] - Optional position. If not provided, uses last known position or gets current
  Future<void> _publishLocation([Position? position]) async {
    if (!_isPublishing || _currentOrderId == null) return;

    try {
      double latitude;
      double longitude;

      if (position != null) {
        // Use provided position
        latitude = position.latitude;
        longitude = position.longitude;
      } else if (_lastPublishedPosition != null) {
        // Use last known position
        latitude = _lastPublishedPosition!.latitude;
        longitude = _lastPublishedPosition!.longitude;
      } else {
        // Get current position as fallback
        final currentPosition = await locationService.getCurrentPosition();
        latitude = currentPosition.latitude;
        longitude = currentPosition.longitude;
      }

      // Update location via notifier (handles API call)
      await updateLocationNotifier.updateLocation(
        _currentOrderId!,
        latitude,
        longitude,
      );
    } catch (e) {
      // Silently fail - location updates are fire-and-forget
      // Next update will cover any missed updates
      // ignore: avoid_print
      debugPrint('Location publish error: $e');
    }
  }

  /// Check if currently publishing
  bool get isPublishing => _isPublishing;

  /// Get current order ID
  String? get currentOrderId => _currentOrderId;

  /// Dispose
  void dispose() {
    stopPublishing();
  }
}
