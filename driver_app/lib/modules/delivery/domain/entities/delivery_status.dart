/// Delivery Status Entity
/// 
/// Enum-like class for delivery status values
class DeliveryStatus {
  static const String pending = 'pending';
  static const String accepted = 'accepted';
  static const String pickedUp = 'picked_up';
  static const String onTheWay = 'on_the_way';
  static const String delivered = 'delivered';
  static const String cancelled = 'cancelled';

  /// Validate status
  static bool isValid(String status) {
    return [
      pending,
      accepted,
      pickedUp,
      onTheWay,
      delivered,
      cancelled,
    ].contains(status);
  }
}
