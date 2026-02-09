import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/theme/design_system.dart';
import '../../data/models/delivery_details_dto.dart';
import '../../../jobs/data/models/active_job_dto.dart';

/// Delivery Map View
///
/// Displays a map showing:
/// - Driver's current location
/// - Restaurant location (pickup point)
/// - Customer location (delivery point)
/// - Route between points (if available)
///
/// Only builds GoogleMap when location permission is granted to avoid
/// native crash (SIGABRT) when GMSServices runs with permission denied.
class DeliveryMapView extends StatefulWidget {
  final ActiveJobDto job;
  final DeliveryDetailsDto? details;
  final LatLng? driverLocation;

  const DeliveryMapView({
    super.key,
    required this.job,
    this.details,
    this.driverLocation,
  });

  @override
  State<DeliveryMapView> createState() => _DeliveryMapViewState();
}

class _DeliveryMapViewState extends State<DeliveryMapView> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  /// null = checking, true = can show map, false = permission denied
  bool? _canShowMap;

  @override
  void initState() {
    super.initState();
    _buildMarkers();
    _checkPermissionAndSetMapAllowed();
  }

  Future<void> _checkPermissionAndSetMapAllowed() async {
    try {
      final permission = await Geolocator.checkPermission();
      final allowed = permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
      if (mounted) {
        setState(() => _canShowMap = allowed);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _canShowMap = false);
      }
    }
  }

  @override
  void didUpdateWidget(DeliveryMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.driverLocation != widget.driverLocation ||
        oldWidget.job != widget.job) {
      _buildMarkers();
      _updateCameraPosition();
    }
  }

  void _buildMarkers() {
    _markers.clear();

    // Restaurant marker (pickup point)
    _markers.add(
      Marker(
        markerId: const MarkerId('restaurant'),
        position: LatLng(
          widget.job.pickupLocation.latitude,
          widget.job.pickupLocation.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: widget.job.order.vendor.name,
          snippet: 'Pickup location',
        ),
      ),
    );

    // Customer marker (delivery point)
    _markers.add(
      Marker(
        markerId: const MarkerId('customer'),
        position: LatLng(
          widget.job.deliveryLocation.latitude,
          widget.job.deliveryLocation.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'Delivery Location',
          snippet: widget.details?.deliveryAddress?.streetAddress ?? 'Customer location',
        ),
      ),
    );

    // Driver marker (current location) - if available
    if (widget.driverLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: widget.driverLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Driver current position',
          ),
        ),
      );
    }

    setState(() {});
  }

  void _updateCameraPosition() {
    if (_mapController == null) return;

    // Calculate bounds to include all markers
    final positions = _markers.map((m) => m.position).toList();
    if (positions.isEmpty) return;

    double minLat = positions.first.latitude;
    double maxLat = positions.first.latitude;
    double minLng = positions.first.longitude;
    double maxLng = positions.first.longitude;

    for (final pos in positions) {
      minLat = minLat < pos.latitude ? minLat : pos.latitude;
      maxLat = maxLat > pos.latitude ? maxLat : pos.latitude;
      minLng = minLng < pos.longitude ? minLng : pos.longitude;
      maxLng = maxLng > pos.longitude ? maxLng : pos.longitude;
    }

    // Add padding
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    minLat -= latDiff * 0.1;
    maxLat += latDiff * 0.1;
    minLng -= lngDiff * 0.1;
    maxLng += lngDiff * 0.1;

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          100.0, // padding
        ),
      );
    }
  }

  Future<void> _openSettingsAndRecheck() async {
    await Geolocator.openAppSettings();
    _checkPermissionAndSetMapAllowed();
  }

  Widget _buildMapPlaceholder(String message, {bool showOpenSettings = false}) {
    final content = Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.border),
        color: AppColors.surface,
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(Insets.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off, size: 48, color: AppColors.textSecondary),
            Gaps.mdV,
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            if (showOpenSettings) ...[
              Gaps.lgV,
              TextButton.icon(
                onPressed: _openSettingsAndRecheck,
                icon: const Icon(Icons.settings),
                label: const Text('Open Settings'),
              ),
            ],
          ],
        ),
      ),
    );
    if (showOpenSettings) {
      return GestureDetector(
        onTap: _openSettingsAndRecheck,
        child: content,
      );
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    if (_canShowMap == null) {
      return _buildMapPlaceholder('Checking location...');
    }
    if (_canShowMap == false) {
      return _buildMapPlaceholder(
        'Location access is needed to show the map. Enable it in Settings.',
        showOpenSettings: true,
      );
    }

    final centerLat = (widget.job.pickupLocation.latitude +
            widget.job.deliveryLocation.latitude) /
        2;
    final centerLng = (widget.job.pickupLocation.longitude +
            widget.job.deliveryLocation.longitude) /
        2;

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.lgAll,
        child: GoogleMap(
          onMapCreated: (controller) {
            _mapController = controller;
            _updateCameraPosition();
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(centerLat, centerLng),
            zoom: 13.0,
          ),
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          compassEnabled: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
