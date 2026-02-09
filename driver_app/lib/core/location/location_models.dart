/// Location models for Driver App
class DriverLocation {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? heading;
  final DateTime timestamp;

  DriverLocation({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.heading,
    required this.timestamp,
  });

  factory DriverLocation.fromPosition(dynamic position) {
    return DriverLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      heading: position.heading,
      timestamp: position.timestamp ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'heading': heading,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Location tracking mode
enum LocationTrackingMode {
  idle,           // Idle - track every 60 seconds
  activeDelivery, // Active delivery - track every 5 seconds
  stopped,        // Stopped - no tracking
}
