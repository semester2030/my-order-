import '../../domain/entities/driver_notification.dart' as domain;
import '../models/notification_model.dart' as data;

/// Notifications Mapper
/// 
/// Maps between DTOs/Models (Data Layer) and Entities (Domain Layer)
class NotificationsMapper {
  /// Map NotificationModel to DriverNotification entity
  static domain.DriverNotification toDriverNotification(
    data.NotificationModel model,
  ) {
    return domain.DriverNotification(
      id: model.id,
      title: model.title,
      body: model.body,
      type: _mapNotificationType(model.type),
      createdAt: model.createdAt,
      isRead: model.isRead,
      data: model.data,
    );
  }

  /// Map list of NotificationModel to list of DriverNotification entities
  static List<domain.DriverNotification> toDriverNotificationList(
    List<data.NotificationModel> models,
  ) {
    return models.map((model) => toDriverNotification(model)).toList();
  }

  /// Map NotificationType enum to domain NotificationType
  static domain.NotificationType _mapNotificationType(
    data.NotificationType modelType,
  ) {
    return switch (modelType) {
      data.NotificationType.jobOffer => domain.NotificationType.jobOffer,
      data.NotificationType.jobAccepted =>
        domain.NotificationType.jobAccepted,
      data.NotificationType.deliveryUpdate =>
        domain.NotificationType.deliveryUpdate,
      data.NotificationType.system => domain.NotificationType.system,
      _ => domain.NotificationType.other,
    };
  }
}
