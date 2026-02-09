import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Map Provider
/// 
/// Wrapper for Google Maps functionality
class MapProvider {
  /// Create camera position from coordinates
  static CameraPosition createCameraPosition({
    required double latitude,
    required double longitude,
    double zoom = 15.0,
  }) {
    return CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: zoom,
    );
  }

  /// Create marker from coordinates
  static Marker createMarker({
    required String markerId,
    required double latitude,
    required double longitude,
    String? title,
    String? snippet,
    BitmapDescriptor? icon,
  }) {
    return Marker(
      markerId: MarkerId(markerId),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: title,
        snippet: snippet,
      ),
      icon: icon ?? BitmapDescriptor.defaultMarker,
    );
  }

  /// Calculate bounds from list of positions
  static LatLngBounds? calculateBounds(List<LatLng> positions) {
    if (positions.isEmpty) return null;

    double minLat = positions.first.latitude;
    double maxLat = positions.first.latitude;
    double minLng = positions.first.longitude;
    double maxLng = positions.first.longitude;

    for (final position in positions) {
      minLat = minLat < position.latitude ? minLat : position.latitude;
      maxLat = maxLat > position.latitude ? maxLat : position.latitude;
      minLng = minLng < position.longitude ? minLng : position.longitude;
      maxLng = maxLng > position.longitude ? maxLng : position.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// Create polyline from list of coordinates
  static Polyline createPolyline({
    required String polylineId,
    required List<LatLng> points,
    Color color = const Color(0xFF4285F4),
    int width = 5,
    bool geodesic = true,
  }) {
    return Polyline(
      polylineId: PolylineId(polylineId),
      points: points,
      color: color,
      width: width,
      geodesic: geodesic,
    );
  }
}
