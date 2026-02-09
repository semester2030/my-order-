import '../models/analytics_dto.dart';

/// مصدر بيانات التحليلات عن بعد — Phase 14.
abstract interface class AnalyticsRemoteDs {
  Future<AnalyticsDto> getAnalytics({String? from, String? to});
}
