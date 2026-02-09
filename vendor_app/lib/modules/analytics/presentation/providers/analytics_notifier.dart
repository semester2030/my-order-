import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../../domain/entities/analytics_snapshot.dart';
import '../../domain/repositories/analytics_repo.dart';
import 'analytics_state.dart';

/// Notifier للتحليلات — Phase 14.
class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  AnalyticsNotifier(this._repo) : super(const AnalyticsInitial());

  final AnalyticsRepo _repo;

  Future<void> load({String? from, String? to}) async {
    state = const AnalyticsLoading();
    final result = await _repo.getAnalytics(from: from, to: to);
    result.when(
      success: (AnalyticsSnapshot snapshot) => state = AnalyticsLoaded(snapshot),
      failure: (f) => state = AnalyticsError(f.message),
    );
  }
}
