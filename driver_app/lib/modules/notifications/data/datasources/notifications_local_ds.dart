import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/storage_keys.dart';
import '../models/notification_model.dart';
import 'dart:convert';

/// Notifications Local Data Source
abstract class NotificationsLocalDataSource {
  Future<void> saveNotification(NotificationModel notification);
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId);
  Future<void> clearAll();
}

class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  final LocalStorage localStorage;

  NotificationsLocalDataSourceImpl({required this.localStorage});

  @override
  Future<void> saveNotification(NotificationModel notification) async {
    final notifications = await getNotifications();
    notifications.insert(0, notification);
    
    // Keep only last 100 notifications
    if (notifications.length > 100) {
      notifications.removeRange(100, notifications.length);
    }
    
    await _saveNotifications(notifications);
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final json = await localStorage.getString(StorageKeys.notifications);
    if (json == null || json.isEmpty) {
      return [];
    }
    
    final List<dynamic> data = jsonDecode(json) as List<dynamic>;
    return data
        .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final notifications = await getNotifications();
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      await _saveNotifications(notifications);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    final notifications = await getNotifications();
    final updated = notifications.map((n) => n.copyWith(isRead: true)).toList();
    await _saveNotifications(updated);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    final notifications = await getNotifications();
    notifications.removeWhere((n) => n.id == notificationId);
    await _saveNotifications(notifications);
  }

  @override
  Future<void> clearAll() async {
    await localStorage.remove(StorageKeys.notifications);
  }

  Future<void> _saveNotifications(List<NotificationModel> notifications) async {
    final json = jsonEncode(notifications.map((n) => n.toJson()).toList());
    await localStorage.saveString(StorageKeys.notifications, json);
  }
}
