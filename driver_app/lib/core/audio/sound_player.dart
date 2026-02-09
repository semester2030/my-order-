import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'sound_assets.dart';

/// Sound Player
/// 
/// Handles playing notification sounds for job offers and updates
class SoundPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Play notification sound
  /// 
  /// [notificationType] - Type of notification (job_offer, job_accepted, etc.)
  Future<void> playNotificationSound(String notificationType) async {
    try {
      final soundPath = SoundAssets.getSoundForNotificationType(notificationType);
      if (soundPath != null) {
        await _audioPlayer.play(AssetSource(soundPath));
      }
    } catch (e) {
      // Silently fail - sound is not critical
      // ignore: avoid_print
      debugPrint('Sound playback error: $e');
    }
  }

  /// Play job offer notification sound
  Future<void> playJobOfferSound() async {
    await playNotificationSound('job_offer');
  }

  /// Play job accepted notification sound
  Future<void> playJobAcceptedSound() async {
    await playNotificationSound('job_accepted');
  }

  /// Play delivery update notification sound
  Future<void> playDeliveryUpdateSound() async {
    await playNotificationSound('delivery_update');
  }

  /// Stop any currently playing sound
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      // Ignore errors
    }
  }

  /// Dispose
  void dispose() {
    _audioPlayer.dispose();
  }
}
