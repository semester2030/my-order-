import '../models/private_event_request_dto.dart';

/// مصدر بيانات طلبات المناسبات عبر API.
abstract class EventRequestsRemoteDs {
  Future<List<PrivateEventRequestDto>> getRequests();
  Future<PrivateEventRequestDto> accept(String requestId);
  Future<PrivateEventRequestDto> reject(String requestId);
}
