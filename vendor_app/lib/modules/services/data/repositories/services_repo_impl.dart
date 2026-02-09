import 'package:vendor_app/core/errors/error_mapper.dart';
import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;
import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/service_item.dart';
import '../../domain/repositories/services_repo.dart';
import '../datasources/services_remote_ds.dart';
import '../mappers/services_mapper.dart';

/// تنفيذ [ServicesRepo] — Phase 11.
class ServicesRepoImpl implements ServicesRepo {
  ServicesRepoImpl(this._remoteDs);

  final ServicesRemoteDs _remoteDs;

  @override
  Future<res.Result<PagedResult<ServiceItem>, Failure>> getServices({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await _remoteDs.getServices(page: page, limit: limit);
      return res.Success(ServicesMapper.toPagedServices(result));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<ServiceItem, Failure>> getItemById(String id) async {
    try {
      final dto = await _remoteDs.getItemById(id);
      return res.Success(ServicesMapper.toServiceItem(dto));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<ServiceItem, Failure>> addItem(ServiceItem item) async {
    try {
      final dto = ServicesMapper.toDto(item);
      final added = await _remoteDs.addItem(dto);
      return res.Success(ServicesMapper.toServiceItem(added));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<ServiceItem, Failure>> updateItem(ServiceItem item) async {
    try {
      final dto = ServicesMapper.toDto(item);
      final updated = await _remoteDs.updateItem(dto);
      return res.Success(ServicesMapper.toServiceItem(updated));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }
}
