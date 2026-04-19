import '../models/chef_booking_request_dto.dart';

/// طلبات حجز الذبائح والشواء — مسارات `/vendors/chef-booking-requests` فقط.
abstract class ChefBookingRequestsRemoteDs {
  Future<List<ChefBookingRequestDto>> getRequests();
  Future<ChefBookingRequestDto> reject(String requestId);
  Future<ChefBookingRequestDto> quote(
    String requestId, {
    required double quotedAmount,
    String? quoteNotes,
  });
  Future<ChefBookingRequestDto> markReady(String requestId);
  Future<ChefBookingRequestDto> markHandedOver(
    String requestId, {
    String? handoverNotes,
  });
}
