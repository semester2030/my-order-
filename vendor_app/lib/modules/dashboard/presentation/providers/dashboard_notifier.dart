import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../../domain/repositories/dashboard_repo.dart';
import 'dashboard_state.dart';

/// Notifier for dashboard stats (Phase 5: أساس).
class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier(this._repo) : super(const DashboardInitial());

  final DashboardRepo _repo;

  Future<void> loadStats() async {
    state = const DashboardLoading();
    final result = await _repo.getStats();
    result.when(
      success: (stats) => state = DashboardLoaded(stats),
      failure: (f) => state = DashboardError(f.message),
    );
  }
}
