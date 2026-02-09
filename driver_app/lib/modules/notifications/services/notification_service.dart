import '../../../../core/audio/sound_player.dart';
import '../data/models/notification_model.dart';

/// Notification Service
/// Handles local notifications and audio alerts
class NotificationService {
  final SoundPlayer _soundPlayer = SoundPlayer();

  /// Show notification (local)
  Future<void> showNotification(NotificationModel notification) async {
    // Play sound based on notification type
    switch (notification.type) {
      case NotificationType.jobOffer:
        await _soundPlayer.playJobOfferSound();
        break;
      case NotificationType.jobAccepted:
        await _soundPlayer.playJobAcceptedSound();
        break;
      case NotificationType.deliveryUpdate:
        await _soundPlayer.playDeliveryUpdateSound();
        break;
      default:
        // Play default sound for other types
        await _soundPlayer.playNotificationSound(notification.type.name);
        break;
    }
    
    // TODO: Show local notification using flutter_local_notifications
    // This will be implemented when needed (after testing)
  }

  /// Dispose
  void dispose() {
    _soundPlayer.dispose();
  }
}
