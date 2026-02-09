import 'package:permission_handler/permission_handler.dart' as permission_handler;

/// Permission Service
/// 
/// Handles app permissions in a unified way
class PermissionService {
  /// Request location permission
  Future<bool> requestLocationPermission() async {
    final status = await permission_handler.Permission.location.request();
    return status.isGranted;
  }

  /// Check if location permission is granted
  Future<bool> isLocationPermissionGranted() async {
    final status = await permission_handler.Permission.location.status;
    return status.isGranted;
  }

  /// Request camera permission
  Future<bool> requestCameraPermission() async {
    final status = await permission_handler.Permission.camera.request();
    return status.isGranted;
  }

  /// Check if camera permission is granted
  Future<bool> isCameraPermissionGranted() async {
    final status = await permission_handler.Permission.camera.status;
    return status.isGranted;
  }

  /// Request storage permission (for image picker)
  Future<bool> requestStoragePermission() async {
    // On Android 13+, storage permission is not needed for image picker
    // On older versions, request storage permission
    if (await permission_handler.Permission.storage.isDenied) {
      final status = await permission_handler.Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  /// Check if storage permission is granted
  Future<bool> isStoragePermissionGranted() async {
    final status = await permission_handler.Permission.storage.status;
    return status.isGranted;
  }

  /// Request notification permission
  Future<bool> requestNotificationPermission() async {
    final status = await permission_handler.Permission.notification.request();
    return status.isGranted;
  }

  /// Check if notification permission is granted
  Future<bool> isNotificationPermissionGranted() async {
    final status = await permission_handler.Permission.notification.status;
    return status.isGranted;
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    return await permission_handler.openAppSettings();
  }

  /// Request multiple permissions
  Future<Map<permission_handler.Permission, permission_handler.PermissionStatus>> requestPermissions(
    List<permission_handler.Permission> permissions,
  ) async {
    return await permissions.request();
  }

  /// Check multiple permissions
  Future<Map<permission_handler.Permission, permission_handler.PermissionStatus>> checkPermissions(
    List<permission_handler.Permission> permissions,
  ) async {
    final Map<permission_handler.Permission, permission_handler.PermissionStatus> statuses = {};
    for (final permission in permissions) {
      statuses[permission] = await permission.status;
    }
    return statuses;
  }
}
