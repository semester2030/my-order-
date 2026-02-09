import '../../domain/repositories/notifications_repo.dart';
import '../../data/models/notification_model.dart';
import '../datasources/notifications_local_ds.dart';

/// Notifications Repository Implementation
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsLocalDataSource localDataSource;

  NotificationsRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<void> saveNotification(NotificationModel notification) async {
    await localDataSource.saveNotification(notification);
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    return await localDataSource.getNotifications();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await localDataSource.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead() async {
    await localDataSource.markAllAsRead();
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await localDataSource.deleteNotification(notificationId);
  }

  @override
  Future<void> clearAll() async {
    await localDataSource.clearAll();
  }
}
