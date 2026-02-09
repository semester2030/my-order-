import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Location Service using Geolocator ONLY
/// 
/// Handles:
/// - Foreground location tracking
/// - Background location tracking (when active delivery)
/// - Location throttling (battery optimization)
/// - Permission management
class LocationService {
  StreamSubscription<Position>? _positionStream;
  final List<Function(Position)> _listeners = [];
  
  bool _isTracking = false;
  bool _isActiveDelivery = false;
  
  // Throttling settings
  static const Duration _activeDeliveryInterval = Duration(seconds: 5);  // Every 5 seconds during delivery
  static const Duration _idleInterval = Duration(seconds: 60);         // Every 60 seconds when idle
  static const LocationAccuracy _activeDeliveryAccuracy = LocationAccuracy.high;
  static const LocationAccuracy _idleAccuracy = LocationAccuracy.medium;

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current position (one-time)
  Future<Position> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: accuracy,
      timeLimit: const Duration(seconds: 10),
    );
  }

  /// Start location tracking
  /// 
  /// [isActiveDelivery] - If true, tracks every 5 seconds (high accuracy)
  ///                      If false, tracks every 60 seconds (medium accuracy)
  Future<void> startTracking({required bool isActiveDelivery}) async {
    if (_isTracking) {
      await stopTracking();
    }

    _isActiveDelivery = isActiveDelivery;
    _isTracking = true;

    final interval = isActiveDelivery ? _activeDeliveryInterval : _idleInterval;
    final accuracy = isActiveDelivery ? _activeDeliveryAccuracy : _idleAccuracy;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: isActiveDelivery ? 10 : 100, // meters
        timeLimit: interval,
      ),
    ).listen(
      (Position position) {
        _notifyListeners(position);
      },
      onError: (error) {
        // Handle error (log, notify, etc.)
        // ignore: avoid_print
        debugPrint('Location error: $error');
      },
    );
  }

  /// Stop location tracking
  Future<void> stopTracking() async {
    await _positionStream?.cancel();
    _positionStream = null;
    _isTracking = false;
    _isActiveDelivery = false;
  }

  /// Update tracking mode (active delivery vs idle)
  Future<void> updateTrackingMode({required bool isActiveDelivery}) async {
    if (_isActiveDelivery == isActiveDelivery) return;
    
    if (_isTracking) {
      await startTracking(isActiveDelivery: isActiveDelivery);
    } else {
      _isActiveDelivery = isActiveDelivery;
    }
  }

  /// Add location listener
  void addListener(Function(Position) listener) {
    _listeners.add(listener);
  }

  /// Remove location listener
  void removeListener(Function(Position) listener) {
    _listeners.remove(listener);
  }

  /// Notify all listeners
  void _notifyListeners(Position position) {
    for (final listener in _listeners) {
      listener(position);
    }
  }

  /// Calculate distance between two points (in meters)
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Check if tracking is active
  bool get isTracking => _isTracking;

  /// Check if active delivery mode
  bool get isActiveDelivery => _isActiveDelivery;

  /// Dispose
  void dispose() {
    stopTracking();
    _listeners.clear();
  }
}
