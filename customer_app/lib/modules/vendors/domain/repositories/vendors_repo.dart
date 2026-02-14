import '../entities/vendor.dart';
import '../entities/menu_item.dart';

/// بيانات طلب احجز الطباخ / طلب طباخة
class CreateEventRequestParams {
  final String vendorId;
  final String requestType;
  final String scheduledDate;
  final String scheduledTime;
  final int guestsCount;
  final String? addressId;
  final List<Map<String, dynamic>> addOns;
  final List<String>? dishIds;
  final bool? delivery;
  final String? notes;

  const CreateEventRequestParams({
    required this.vendorId,
    required this.requestType,
    required this.scheduledDate,
    required this.scheduledTime,
    this.guestsCount = 1,
    this.addressId,
    this.addOns = const [],
    this.dishIds,
    this.delivery,
    this.notes,
  });
}

abstract class VendorsRepository {
  Future<Vendor> getVendor(String vendorId);
  Future<List<MenuItem>> getVendorMenu(String vendorId);
  Future<List<MenuItem>> getSignatureItems(String vendorId);
  Future<void> createEventRequest(CreateEventRequestParams params);
}
