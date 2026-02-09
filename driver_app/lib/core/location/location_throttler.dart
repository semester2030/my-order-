import 'dart:async';
import 'dart:math';
import 'location_models.dart';

/// Location Throttler
/// 
/// Prevents sending too many location updates to the server
/// Implements debouncing and minimum distance filtering
class LocationThrottler {
  Timer? _debounceTimer;
  DriverLocation? _lastSentLocation;
  
  final Duration _debounceDuration;
  final double _minimumDistance; // meters

  LocationThrottler({
    Duration debounceDuration = const Duration(seconds: 5),
    double minimumDistance = 50.0, // 50 meters
  })  : _debounceDuration = debounceDuration,
        _minimumDistance = minimumDistance;

  /// Process location update
  /// 
  /// Returns true if location should be sent to server
  /// Returns false if location should be throttled
  bool shouldSendLocation(DriverLocation location) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Check minimum distance
    if (_lastSentLocation != null) {
      final distance = _calculateDistance(
        _lastSentLocation!.latitude,
        _lastSentLocation!.longitude,
        location.latitude,
        location.longitude,
      );

      if (distance < _minimumDistance) {
        // Too close to last sent location - throttle
        return false;
      }
    }

    // Schedule debounce
    bool shouldSend = false;
    _debounceTimer = Timer(_debounceDuration, () {
      shouldSend = true;
      _lastSentLocation = location;
    });

    return shouldSend;
  }

  /// Calculate distance between two points (Haversine formula)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // meters
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }

  /// Reset throttler
  void reset() {
    _debounceTimer?.cancel();
    _lastSentLocation = null;
  }

  /// Dispose
  void dispose() {
    _debounceTimer?.cancel();
  }
}
