import 'package:vendor_app/core/errors/error_mapper.dart';
import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repo.dart';
import '../datasources/dashboard_remote_ds.dart';
import '../mappers/dashboard_mapper.dart';

/// Implementation of [DashboardRepo].
class DashboardRepoImpl implements DashboardRepo {
  DashboardRepoImpl(this._remoteDs);

  final DashboardRemoteDs _remoteDs;

  @override
  Future<res.Result<DashboardStats, Failure>> getStats() async {
    try {
      final dto = await _remoteDs.getStats();
      final stats = DashboardMapper.toEntity(dto);
      return res.Success(stats);
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }
}
