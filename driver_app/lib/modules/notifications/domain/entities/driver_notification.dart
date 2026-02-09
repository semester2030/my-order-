/// Driver Notification Entity
/// 
/// Domain entity representing a driver notification
class DriverNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  DriverNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });
}

/// Notification Type
enum NotificationType {
  jobOffer,
  jobAccepted,
  deliveryUpdate,
  system,
  other;

  static NotificationType fromString(String value) {
    return switch (value.toLowerCase()) {
      'job_offer' => NotificationType.jobOffer,
      'job_accepted' => NotificationType.jobAccepted,
      'delivery_update' => NotificationType.deliveryUpdate,
      'system' => NotificationType.system,
      _ => NotificationType.other,
    };
  }
}
