import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';
import 'location_models.dart';

/// Background Location Service
/// 
/// Handles background location tracking ONLY during active delivery
/// 
/// Rules:
/// - Only tracks when [isActiveDelivery] is true
/// - Tracks every 5 seconds (high accuracy)
/// - Stops automatically when delivery is completed
/// - Uses Geolocator background location capabilities
class BackgroundLocationService {
  final LocationService _locationService;
  
  bool _isActiveDelivery = false;
  final List<Function(DriverLocation)> _locationCallbacks = [];

  BackgroundLocationService(this._locationService);

  /// Start background location tracking (only during active delivery)
  Future<void> startBackgroundTracking({
    required Function(DriverLocation) onLocationUpdate,
    required Function(String) onError,
  }) async {
    if (_isActiveDelivery) {
      // Already tracking
      return;
    }

    _isActiveDelivery = true;
    _locationCallbacks.add(onLocationUpdate);

    // Start tracking with active delivery settings
    await _locationService.startTracking(isActiveDelivery: true);

    // Listen to location updates
    _locationService.addListener((Position position) {
      final location = DriverLocation.fromPosition(position);
      for (final callback in _locationCallbacks) {
        callback(location);
      }
    });
  }

  /// Stop background location tracking
  Future<void> stopBackgroundTracking() async {
    _isActiveDelivery = false;
    _locationCallbacks.clear();
    await _locationService.stopTracking();
  }

  /// Check if background tracking is active
  bool get isActive => _isActiveDelivery;

  /// Dispose
  void dispose() {
    stopBackgroundTracking();
  }
}
