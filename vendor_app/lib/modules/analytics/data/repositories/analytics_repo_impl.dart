import 'package:vendor_app/core/errors/error_mapper.dart';
import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../../domain/entities/analytics_snapshot.dart';
import '../../domain/repositories/analytics_repo.dart';
import '../datasources/analytics_remote_ds.dart';
import '../mappers/analytics_mapper.dart';

/// تنفيذ [AnalyticsRepo] — Phase 14.
class AnalyticsRepoImpl implements AnalyticsRepo {
  AnalyticsRepoImpl(this._remoteDs);

  final AnalyticsRemoteDs _remoteDs;

  @override
  Future<res.Result<AnalyticsSnapshot, Failure>> getAnalytics({
    String? from,
    String? to,
  }) async {
    try {
      final dto = await _remoteDs.getAnalytics(from: from, to: to);
      return res.Success(AnalyticsMapper.toSnapshot(dto));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }
}
