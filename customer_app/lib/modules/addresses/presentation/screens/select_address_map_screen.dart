// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/di/providers.dart';
import '../../domain/entities/address.dart';

class SelectAddressMapScreen extends ConsumerStatefulWidget {
  const SelectAddressMapScreen({super.key});

  @override
  ConsumerState<SelectAddressMapScreen> createState() =>
      _SelectAddressMapScreenState();
}

class _SelectAddressMapScreenState
    extends ConsumerState<SelectAddressMapScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String? _selectedAddress;
  Placemark? _currentPlacemark; // Store placemark for address parsing
  bool _isLoadingLocation = true;
  bool _isLoadingAddress = false;
  bool _isSaving = false; // Prevent multiple saves
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _errorMessage = null;
    });

    try {
      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Use default location (Riyadh, Saudi Arabia) if location services are disabled
        _setDefaultLocation();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Use default location (Riyadh, Saudi Arabia) if permission denied
          _setDefaultLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Use default location (Riyadh, Saudi Arabia) if permission permanently denied
        _setDefaultLocation();
        return;
      }

      // Get current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10), // 10 seconds timeout
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          // If timeout, use default location (Riyadh, Saudi Arabia)
          throw TimeoutException('Location request timed out');
        },
      );

      final location = LatLng(position.latitude, position.longitude);
      
      // Check if location is reasonable (within Saudi Arabia or nearby)
      // Riyadh coordinates: 24.7136, 46.6753
      // If location is too far from Riyadh (more than 1000 km), use default
      const riyadhLocation = LatLng(24.7136, 46.6753);
      final distance = _calculateDistance(
        location.latitude,
        location.longitude,
        riyadhLocation.latitude,
        riyadhLocation.longitude,
      );
      
      // If distance is more than 1000 km, it's likely wrong (e.g., San Francisco)
      if (distance > 1000) {
        // Use default location (Riyadh) instead
        _setDefaultLocation();
        return;
      }
      
      setState(() {
        _selectedLocation = location;
        _isLoadingLocation = false;
      });

      // Get address for current location
      await _getAddressFromLocation(location);
    } catch (e) {
      // If any error, use default location (Riyadh, Saudi Arabia)
      _setDefaultLocation();
    }
  }

  void _setDefaultLocation() {
    // Default location: Riyadh, Saudi Arabia
    // Coordinates: 24.7136° N, 46.6753° E
    const defaultLocation = LatLng(24.7136, 46.6753);
    setState(() {
      _selectedLocation = defaultLocation;
      _isLoadingLocation = false;
      _errorMessage = null;
    });
    // Set default address manually (Riyadh) instead of using geocoding
    // This avoids getting wrong location from geocoding API
    setState(() {
      _selectedAddress = 'Riyadh, Saudi Arabia';
      _currentPlacemark = null; // Clear placemark to use manual address
    });
    
    // Also try to get address from geocoding, but don't wait for it
    _getAddressFromLocation(defaultLocation).catchError((e) {
      // If geocoding fails, keep the manual address
    });
  }

  // Calculate distance between two coordinates in kilometers
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth radius in kilometers
    
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    final double c = 2 * math.asin(math.sqrt(a));
    
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }

  Future<void> _getAddressFromLocation(LatLng location) async {
    setState(() {
      _isLoadingAddress = true;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (!mounted) return;
      final l = AppLocalizations.of(context);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final address = _formatAddress(placemark, l);
        setState(() {
          _selectedAddress = address;
          _isLoadingAddress = false;
          _currentPlacemark = placemark;
        });
      } else {
        setState(() {
          _selectedAddress = l.addressNotFound;
          _isLoadingAddress = false;
        });
      }
    } catch (e) {
      if (mounted) {
        final l = AppLocalizations.of(context);
        setState(() {
          _selectedAddress = l.getAddressFailed;
          _isLoadingAddress = false;
        });
      }
    }
  }

  String _formatAddress(Placemark placemark, AppLocalizations l) {
    final parts = <String>[];
    if (placemark.street != null && placemark.street!.isNotEmpty) {
      parts.add(placemark.street!);
    }
    if (placemark.subThoroughfare != null &&
        placemark.subThoroughfare!.isNotEmpty) {
      parts.add(placemark.subThoroughfare!);
    }
    if (placemark.thoroughfare != null &&
        placemark.thoroughfare!.isNotEmpty) {
      parts.add(placemark.thoroughfare!);
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      parts.add(placemark.locality!);
    }
    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      parts.add(placemark.administrativeArea!);
    }

    return parts.isNotEmpty ? parts.join(', ') : l.unknownAddress;
  }

  // Extract city from placemark (locality is the city, administrativeArea is the state)
  String _getCityFromPlacemark(Placemark placemark) {
    // Use locality (city) if available, otherwise use subAdministrativeArea or administrativeArea
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      return placemark.locality!;
    }
    if (placemark.subAdministrativeArea != null && placemark.subAdministrativeArea!.isNotEmpty) {
      return placemark.subAdministrativeArea!;
    }
    if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
      return placemark.administrativeArea!;
    }
    return 'Riyadh'; // Default fallback
  }

  // Extract district from placemark
  String? _getDistrictFromPlacemark(Placemark placemark) {
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      return placemark.subLocality!;
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      return placemark.locality!;
    }
    return null;
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    _getAddressFromLocation(location);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _confirmAddress() async {
    if (_selectedLocation == null || _selectedAddress == null) {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.pleaseSelectLocation),
          backgroundColor: SemanticColors.error,
        ),
      );
      return;
    }

    // Prevent multiple saves
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Save address to backend
    try {
      final addressesRepo = ref.read(addressesRepositoryProvider);
      
      // Parse address components from placemark if available, otherwise from formatted address
      String streetAddress;
      String city;
      String? district;
      
      // Always use Riyadh as city if location is in Saudi Arabia area
      // Check if location is in Saudi Arabia (rough bounds)
      final isInSaudiArabia = _selectedLocation!.latitude >= 16.0 &&
                              _selectedLocation!.latitude <= 32.0 &&
                              _selectedLocation!.longitude >= 34.0 &&
                              _selectedLocation!.longitude <= 55.0;
      
      if (_currentPlacemark != null && isInSaudiArabia) {
        // Use placemark data for accurate parsing
        final placemark = _currentPlacemark!;
        streetAddress = placemark.street ?? 
                       placemark.thoroughfare ?? 
                       _selectedAddress!.split(', ').first;
        // Force city to be from placemark, but ensure it's not empty
        final parsedCity = _getCityFromPlacemark(placemark);
        city = parsedCity.isNotEmpty ? parsedCity : 'Riyadh';
        district = _getDistrictFromPlacemark(placemark);
      } else {
        // If not in Saudi Arabia or no placemark, use default Riyadh
        final addressParts = _selectedAddress!.split(', ');
        streetAddress = addressParts.isNotEmpty ? addressParts.first : _selectedAddress!;
        city = 'Riyadh'; // Always use Riyadh as default
        district = addressParts.length > 2 ? addressParts[addressParts.length - 2] : null;
      }
      
      // Ensure city is always non-null and non-empty
      if (city.isEmpty || city == 'CA' || city == 'California') {
        city = 'Riyadh';
      }
      
      // Create address entity
      final address = Address(
        id: '', // Will be generated by backend
        label: AppLocalizations.of(context).homeAddressLabel,
        streetAddress: streetAddress,
        building: null,
        floor: null,
        apartment: null,
        city: city, // Always non-null
        district: district,
        postalCode: null,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        isDefault: true, // Set as default since it's the first address
        isActive: true,
      );

      // Save address
      await addressesRepo.addAddress(address);
      
      // Navigate to feed after saving
      if (mounted) {
        context.go(RouteNames.categories);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l.saveAddressFailed}: ${e.toString()}'),
            backgroundColor: SemanticColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingLocation) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).selectAddressTitle,
            style: TextStyles.titleLarge,
          ),
        ),
        body: const LoadingView(),
      );
    }

    if (_errorMessage != null && _selectedLocation == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).selectAddressTitle,
            style: TextStyles.titleLarge,
          ),
        ),
        body: ErrorState(
          message: _errorMessage!,
          onRetry: _getCurrentLocation,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Select Address',
          style: TextStyles.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: AppLocalizations.of(context).getCurrentLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          // Map
          Expanded(
            child: _selectedLocation != null
                ? GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _selectedLocation!,
                      zoom: 15.0,
                    ),
                    onTap: _onMapTap,
                    markers: _selectedLocation != null
                        ? {
                            Marker(
                              markerId: const MarkerId('selected_location'),
                              position: _selectedLocation!,
                              draggable: true,
                              onDragEnd: (LatLng newPosition) {
                                setState(() {
                                  _selectedLocation = newPosition;
                                });
                                _getAddressFromLocation(newPosition);
                              },
                            ),
                          }
                        : {},
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                  )
                : const LoadingView(),
          ),
          // Address info and confirm button
          Container(
            padding: const EdgeInsets.all(Insets.lg),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              boxShadow: AppShadows.elevation4,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Selected address
                  Container(
                    padding: const EdgeInsets.all(Insets.md),
                    decoration: BoxDecoration(
                      color: AppColors.warmSurface,
                      borderRadius: AppRadius.mdAll,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: IconSizes.lg,
                        ),
                        Gaps.mdH,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_isLoadingAddress)
                                Text(
                                  AppLocalizations.of(context).gettingAddress,
                                  style: TextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                )
                              else if (_selectedAddress != null)
                                Text(
                                  _selectedAddress!,
                                  style: TextStyles.bodyLarge,
                                )
                              else
                                Text(
                                  AppLocalizations.of(context).tapToSelectLocation,
                                  style: TextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gaps.lgV,
                  // Confirm button
                  PrimaryButton(
                    onPressed:
                        (_selectedLocation != null && _selectedAddress != null && !_isSaving)
                            ? _confirmAddress
                            : null,
                    text: AppLocalizations.of(context).confirmAddress,
                    width: double.infinity,
                    isLoading: _isLoadingAddress || _isSaving,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
