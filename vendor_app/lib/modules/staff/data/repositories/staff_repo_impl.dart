import 'package:vendor_app/core/errors/error_mapper.dart';
import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;
import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/staff_member.dart';
import '../../domain/repositories/staff_repo.dart';
import '../datasources/staff_remote_ds.dart';
import '../mappers/staff_mapper.dart';

/// تنفيذ [StaffRepo] — Phase 13.
class StaffRepoImpl implements StaffRepo {
  StaffRepoImpl(this._remoteDs);

  final StaffRemoteDs _remoteDs;

  @override
  Future<res.Result<PagedResult<StaffMember>, Failure>> getStaff({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await _remoteDs.getStaff(page: page, limit: limit);
      return res.Success(StaffMapper.toPagedStaff(result));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<StaffMember, Failure>> getItemById(String id) async {
    try {
      final dto = await _remoteDs.getItemById(id);
      return res.Success(StaffMapper.toStaffMember(dto));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<StaffMember, Failure>> addItem(StaffMember item) async {
    try {
      final dto = StaffMapper.toDto(item);
      final added = await _remoteDs.addItem(dto);
      return res.Success(StaffMapper.toStaffMember(added));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<StaffMember, Failure>> updateItem(StaffMember item) async {
    try {
      final dto = StaffMapper.toDto(item);
      final updated = await _remoteDs.updateItem(dto);
      return res.Success(StaffMapper.toStaffMember(updated));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }
}
