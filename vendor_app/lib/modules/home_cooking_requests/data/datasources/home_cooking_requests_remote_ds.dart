import '../models/home_cooking_request_dto.dart';

/// طلبات الطبخ المنزلي — `/vendors/home-cooking-requests`.
abstract class HomeCookingRequestsRemoteDs {
  Future<List<HomeCookingRequestDto>> getRequests();
  Future<HomeCookingRequestDto> quote(
    String requestId, {
    required double quotedAmount,
    String? quoteNotes,
  });
  Future<HomeCookingRequestDto> reject(String requestId);
  Future<HomeCookingRequestDto> markReady(String requestId);
  Future<HomeCookingRequestDto> markHandedOver(
    String requestId, {
    String? handoverNotes,
  });
}
