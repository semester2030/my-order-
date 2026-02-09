/// Sound Assets Paths
/// 
/// Defines paths to sound files used in the driver app
class SoundAssets {
  SoundAssets._();

  // Base path for sounds
  static const String soundsPath = 'assets/sounds';

  // Notification sounds
  static const String jobOfferNotification = '$soundsPath/job_offer_notification.mp3';
  static const String jobAcceptedNotification = '$soundsPath/job_accepted_notification.mp3';
  static const String deliveryUpdateNotification = '$soundsPath/delivery_update_notification.mp3';
  static const String systemNotification = '$soundsPath/system_notification.mp3';

  // Get sound path by notification type
  static String? getSoundForNotificationType(String notificationType) {
    switch (notificationType) {
      case 'job_offer':
        return jobOfferNotification;
      case 'job_accepted':
        return jobAcceptedNotification;
      case 'delivery_update':
        return deliveryUpdateNotification;
      case 'system':
        return systemNotification;
      default:
        return jobOfferNotification; // Default sound
    }
  }
}
