import '../models/chef_booking_request_dto.dart';

/// طلبات حجز الذبائح والشواء — مسارات `/vendors/chef-booking-requests` فقط.
abstract class ChefBookingRequestsRemoteDs {
  Future<List<ChefBookingRequestDto>> getRequests();
  Future<ChefBookingRequestDto> accept(String requestId);
  Future<ChefBookingRequestDto> reject(String requestId);
}
