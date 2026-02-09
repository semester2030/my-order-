import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/notifications_repo.dart';
import '../../data/repositories/notifications_repo_impl.dart';
import '../../data/datasources/notifications_local_ds.dart';
import '../../../../core/di/providers.dart';
import '../../data/models/notification_model.dart';
import 'notifications_state.dart';

/// Notifications Repository Provider
final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  final localDataSource = NotificationsLocalDataSourceImpl(localStorage: localStorage);
  return NotificationsRepositoryImpl(localDataSource: localDataSource);
});

/// Notifications Notifier Provider
final notificationsNotifierProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return NotificationsNotifier(repository);
});

/// Notifications Notifier
class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final NotificationsRepository repository;

  NotificationsNotifier(this.repository) : super(const NotificationsInitial()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    state = const NotificationsLoading();
    try {
      final notifications = await repository.getNotifications();
      final unreadCount = notifications.where((n) => !n.isRead).length;
      state = NotificationsLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      );
    } catch (e) {
      state = NotificationsError(e.toString());
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    try {
      await repository.saveNotification(notification);
      await loadNotifications();
    } catch (e) {
      state = NotificationsError(e.toString());
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await repository.markAsRead(notificationId);
      await loadNotifications();
    } catch (e) {
      state = NotificationsError(e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await repository.markAllAsRead();
      await loadNotifications();
    } catch (e) {
      state = NotificationsError(e.toString());
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await repository.deleteNotification(notificationId);
      await loadNotifications();
    } catch (e) {
      state = NotificationsError(e.toString());
    }
  }

  Future<void> clearAll() async {
    try {
      await repository.clearAll();
      await loadNotifications();
    } catch (e) {
      state = NotificationsError(e.toString());
    }
  }
}
