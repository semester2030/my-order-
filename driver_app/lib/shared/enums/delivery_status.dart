/// Delivery Status Enum
/// 
/// Represents the status of a delivery
enum DeliveryStatus {
  pending('pending', 'Pending'),
  accepted('accepted', 'Accepted'),
  pickedUp('picked_up', 'Picked Up'),
  onTheWay('on_the_way', 'On The Way'),
  delivered('delivered', 'Delivered'),
  cancelled('cancelled', 'Cancelled');

  final String value;
  final String displayName;

  const DeliveryStatus(this.value, this.displayName);

  /// Get status from string value
  static DeliveryStatus? fromString(String value) {
    try {
      return DeliveryStatus.values.firstWhere((e) => e.value == value);
    } catch (e) {
      return null;
    }
  }

  /// Check if status is active (not delivered or cancelled)
  bool get isActive => this != delivered && this != cancelled;

  /// Check if status is completed (delivered or cancelled)
  bool get isCompleted => this == delivered || this == cancelled;

  /// Get next possible status
  DeliveryStatus? get nextStatus {
    return switch (this) {
      DeliveryStatus.pending => DeliveryStatus.accepted,
      DeliveryStatus.accepted => DeliveryStatus.pickedUp,
      DeliveryStatus.pickedUp => DeliveryStatus.onTheWay,
      DeliveryStatus.onTheWay => DeliveryStatus.delivered,
      DeliveryStatus.delivered => null,
      DeliveryStatus.cancelled => null,
    };
  }
}
