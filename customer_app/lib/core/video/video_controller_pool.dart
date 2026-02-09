import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';

/// Pool for managing video controllers to prevent memory leaks
class VideoControllerPool {
  VideoControllerPool._();

  static final Map<String, VideoPlayerController> _controllers = {};
  static const int maxControllers = 5; // Maximum controllers to keep in memory

  /// Get or create video controller
  static Future<VideoPlayerController?> getController(String videoUrl) async {
    // Return existing controller if available
    if (_controllers.containsKey(videoUrl)) {
      final controller = _controllers[videoUrl]!;
      if (controller.value.isInitialized) {
        return controller;
      }
    }

    // Create new controller
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );

      await controller.initialize();

      // Add to pool
      _controllers[videoUrl] = controller;

      // Remove oldest if pool is full
      if (_controllers.length > maxControllers) {
        final firstKey = _controllers.keys.first;
        await disposeController(firstKey);
      }

      return controller;
    } catch (e) {
      debugPrint('Error initializing video controller: $e');
      return null;
    }
  }

  /// Dispose specific controller
  static Future<void> disposeController(String videoUrl) async {
    final controller = _controllers.remove(videoUrl);
    if (controller != null) {
      await controller.dispose();
    }
  }

  /// Dispose all controllers
  static Future<void> disposeAll() async {
    for (final controller in _controllers.values) {
      await controller.dispose();
    }
    _controllers.clear();
  }

  /// Pause all playing videos
  static void pauseAll() {
    for (final controller in _controllers.values) {
      if (controller.value.isPlaying) {
        controller.pause();
      }
    }
  }
}
