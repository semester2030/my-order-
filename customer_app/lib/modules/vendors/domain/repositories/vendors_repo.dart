import '../entities/vendor.dart';
import '../entities/menu_item.dart';

/// بيانات طلب احجز الطباخ / طلب طباخة
class CreateEventRequestParams {
  final String vendorId;
  final String requestType;
  final String scheduledDate;
  /// للطبخ المنزلي فقط — للذبائح/الشوي يُرسل [mealSlot] بدلاً منه.
  final String? scheduledTime;
  /// `lunch` | `dinner` لطبخ الذبائح والشواء الخارجي.
  final String? mealSlot;
  final int guestsCount;
  final String? addressId;
  final List<Map<String, dynamic>> addOns;
  final List<String>? dishIds;
  /// أطباق مخصصة بنص حر — العميل يكتب ما يريد (كبسة، إدام، سلطة...)
  final String? customDishNames;
  final bool? delivery;
  final String? notes;

  const CreateEventRequestParams({
    required this.vendorId,
    required this.requestType,
    required this.scheduledDate,
    this.scheduledTime,
    this.mealSlot,
    this.guestsCount = 1,
    this.addressId,
    this.addOns = const [],
    this.dishIds,
    this.customDishNames,
    this.delivery,
    this.notes,
  });
}

/// خدمة مطلوبة في طلب المناسبة
class PrivateEventServiceRequest {
  final String serviceType; // buffet, desserts, drinks, staff
  final int guestsCount;
  final String? notes;

  const PrivateEventServiceRequest({
    required this.serviceType,
    required this.guestsCount,
    this.notes,
  });
}

/// بيانات طلب مناسبة خاصة
class CreatePrivateEventRequestParams {
  final String vendorId;
  final String? addressId;
  final String eventType; // wedding, graduation, henna, engagement, other
  final String eventDate; // YYYY-MM-DD
  final String eventTime; // HH:mm
  final int guestsCount;
  final List<PrivateEventServiceRequest> services;
  final String? notes;

  const CreatePrivateEventRequestParams({
    required this.vendorId,
    this.addressId,
    required this.eventType,
    required this.eventDate,
    required this.eventTime,
    this.guestsCount = 1,
    required this.services,
    this.notes,
  });
}

abstract class VendorsRepository {
  Future<Vendor> getVendor(String vendorId);
  Future<List<MenuItem>> getVendorMenu(String vendorId);
  Future<List<MenuItem>> getSignatureItems(String vendorId);
  Future<void> createEventRequest(CreateEventRequestParams params);
  /// طلبات احجز الطباخ لطبخ الذبائح والشواء فقط (تُصفّى من استجابة «طلباتي»).
  Future<List<Map<String, dynamic>>> getMyChefBookingRequests();
  /// طلبات الطبخ المنزلي فقط (`request_type == home_cooking`).
  Future<List<Map<String, dynamic>>> getMyHomeCookingRequests();
  Future<Map<String, dynamic>> getMyHomeCookingRequestById(String requestId);
  Future<void> declareHomeCookingPayment(
    String requestId, {
    required String paymentReference,
    String? notes,
  });
  /// إغلاق الطلب بعد تأكيد الاستلام — يعيد السجل بما فيه رمز الإتمام.
  Future<Map<String, dynamic>> confirmHomeCookingReceipt(String requestId);
  Future<void> cancelMyEventRequest(String requestId);
  Future<List<Map<String, dynamic>>> getVendorEventOffers(String vendorId);
  Future<void> createPrivateEventRequest(CreatePrivateEventRequestParams params);
}
