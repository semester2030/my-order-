import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../entities/dashboard_stats.dart';

/// Repository for dashboard stats (Phase 5: أساس).
abstract interface class DashboardRepo {
  Future<res.Result<DashboardStats, Failure>> getStats();
}
