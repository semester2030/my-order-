import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../entities/analytics_snapshot.dart';

/// مستودع التحليلات — Phase 14.
abstract interface class AnalyticsRepo {
  Future<res.Result<AnalyticsSnapshot, Failure>> getAnalytics({String? from, String? to});
}
