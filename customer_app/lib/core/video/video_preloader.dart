import 'video_controller_pool.dart';

/// Preloads videos for smooth playback
class VideoPreloader {
  VideoPreloader._();

  /// Preload next videos in the feed
  static Future<void> preloadVideos(List<String> videoUrls) async {
    // Preload first 3 videos
    final urlsToPreload = videoUrls.take(3).toList();

    for (final url in urlsToPreload) {
      try {
        await VideoControllerPool.getController(url);
      } catch (e) {
        // Ignore preload errors
      }
    }
  }
}
