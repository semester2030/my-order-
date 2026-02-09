import 'package:url_launcher/url_launcher.dart';

/// Route Launcher
/// 
/// Opens external maps apps (Google Maps, Waze) for navigation
/// 
/// Phase 1 Approach: Use external apps instead of in-app navigation
/// - Simpler implementation
/// - Better UX (users prefer their familiar navigation app)
/// - No complex turn-by-turn logic needed
class RouteLauncher {
  /// Open route in Google Maps
  /// 
  /// [destinationLat] - Destination latitude
  /// [destinationLng] - Destination longitude
  /// [destinationName] - Optional destination name
  /// [startLat] - Optional start latitude (current location if null)
  /// [startLng] - Optional start longitude (current location if null)
  Future<bool> openInGoogleMaps({
    required double destinationLat,
    required double destinationLng,
    String? destinationName,
    double? startLat,
    double? startLng,
  }) async {
    String url = 'https://www.google.com/maps/dir/';
    
    if (startLat != null && startLng != null) {
      url += '$startLat,$startLng/';
    }
    
    url += '$destinationLat,$destinationLng';
    
    if (destinationName != null) {
      url += '/data=!3m1!4b1!4m2!4m1!3e0';
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// Open route in Waze
  /// 
  /// [destinationLat] - Destination latitude
  /// [destinationLng] - Destination longitude
  /// [destinationName] - Optional destination name
  Future<bool> openInWaze({
    required double destinationLat,
    required double destinationLng,
    String? destinationName,
  }) async {
    String url = 'waze://?ll=$destinationLat,$destinationLng';
    
    if (destinationName != null) {
      url += '&navigate=yes';
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    
    // Fallback to Waze web if app not installed
    final webUri = Uri.parse('https://waze.com/ul?ll=$destinationLat,$destinationLng');
    if (await canLaunchUrl(webUri)) {
      return await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
    
    return false;
  }

  /// Open route in Apple Maps (iOS only)
  /// 
  /// [destinationLat] - Destination latitude
  /// [destinationLng] - Destination longitude
  /// [destinationName] - Optional destination name
  Future<bool> openInAppleMaps({
    required double destinationLat,
    required double destinationLng,
    String? destinationName,
  }) async {
    String url = 'https://maps.apple.com/?daddr=$destinationLat,$destinationLng';
    
    if (destinationName != null) {
      url += '&dirflg=d';
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// Open route in default map app (smart selection)
  /// 
  /// Tries: Waze → Google Maps → Apple Maps
  Future<bool> openRoute({
    required double destinationLat,
    required double destinationLng,
    String? destinationName,
    double? startLat,
    double? startLng,
  }) async {
    // Try Waze first (popular for drivers)
    if (await openInWaze(
      destinationLat: destinationLat,
      destinationLng: destinationLng,
      destinationName: destinationName,
    )) {
      return true;
    }

    // Fallback to Google Maps
    if (await openInGoogleMaps(
      destinationLat: destinationLat,
      destinationLng: destinationLng,
      destinationName: destinationName,
      startLat: startLat,
      startLng: startLng,
    )) {
      return true;
    }

    // Fallback to Apple Maps (iOS)
    return await openInAppleMaps(
      destinationLat: destinationLat,
      destinationLng: destinationLng,
      destinationName: destinationName,
    );
  }
}
