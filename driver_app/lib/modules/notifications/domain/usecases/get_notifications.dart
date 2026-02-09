import '../repositories/notifications_repo.dart';
import '../../data/models/notification_model.dart';

/// Get Notifications Use Case
/// 
/// Handles fetching notifications:
/// - Calls repository to get notifications
/// - Returns list of notifications
class GetNotificationsUseCase {
  final NotificationsRepository repository;

  GetNotificationsUseCase(this.repository);

  /// Execute get notifications
  Future<List<NotificationModel>> call() async {
    return await repository.getNotifications();
  }
}
