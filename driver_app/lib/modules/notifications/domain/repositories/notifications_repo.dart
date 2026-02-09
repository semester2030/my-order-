import '../../data/models/notification_model.dart';

/// Notifications Repository
abstract class NotificationsRepository {
  Future<void> saveNotification(NotificationModel notification);
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId);
  Future<void> clearAll();
}
