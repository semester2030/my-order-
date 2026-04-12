import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// أسباب فشل جلب الموقع من الجهاز (تُترجم في الواجهة).
enum RegisterLocationPickError {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  positionUnavailable,
}

/// نتيجة ناجحة: إحداثيات + اقتراح عنوان/مدينة من العكس الجغرافي (قد يكون null).
class RegisterLocationPickData {
  const RegisterLocationPickData({
    required this.latitude,
    required this.longitude,
    this.suggestedAddress,
    this.suggestedCity,
  });

  final double latitude;
  final double longitude;
  final String? suggestedAddress;
  final String? suggestedCity;
}

/// جلب الموقع الحالي لتسجيل الطبّاخ — بدون اعتماد على واجهات أخرى.
class RegisterLocationHelper {
  RegisterLocationHelper._();

  static String? _addressFromPlacemark(Placemark p) {
    final parts = <String>[];
    void add(String? s) {
      final t = s?.trim();
      if (t != null && t.isNotEmpty) parts.add(t);
    }

    add(p.street);
    if (parts.isEmpty) add(p.thoroughfare);
    add(p.subThoroughfare);
    add(p.subLocality);
    if (parts.length < 2) add(p.name);
    return parts.isEmpty ? null : parts.join('، ');
  }

  static String? _cityFromPlacemark(Placemark p) {
    final a = p.locality?.trim();
    if (a != null && a.isNotEmpty) return a;
    final b = p.subAdministrativeArea?.trim();
    if (b != null && b.isNotEmpty) return b;
    final c = p.administrativeArea?.trim();
    if (c != null && c.isNotEmpty) return c;
    return null;
  }

  static Future<({RegisterLocationPickData? data, RegisterLocationPickError? err})>
      obtainCurrent() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      return (data: null, err: RegisterLocationPickError.serviceDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      return (data: null, err: RegisterLocationPickError.permissionDenied);
    }
    if (permission == LocationPermission.deniedForever) {
      return (data: null, err: RegisterLocationPickError.permissionDeniedForever);
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      String? suggestedAddress;
      String? suggestedCity;
      try {
        final marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
        if (marks.isNotEmpty) {
          final p = marks.first;
          suggestedAddress = _addressFromPlacemark(p);
          suggestedCity = _cityFromPlacemark(p);
        }
      } catch (_) {
        // العكس الجغرافي اختياري — الإحداثيات كافية
      }

      return (
        data: RegisterLocationPickData(
          latitude: pos.latitude,
          longitude: pos.longitude,
          suggestedAddress: suggestedAddress,
          suggestedCity: suggestedCity,
        ),
        err: null,
      );
    } catch (_) {
      return (data: null, err: RegisterLocationPickError.positionUnavailable);
    }
  }
}
