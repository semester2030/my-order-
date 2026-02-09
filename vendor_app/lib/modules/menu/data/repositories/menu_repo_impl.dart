import 'package:vendor_app/core/errors/error_mapper.dart';
import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;
import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repo.dart';
import '../datasources/menu_remote_ds.dart';
import '../mappers/menu_mapper.dart';

/// تنفيذ [MenuRepo] — Phase 10.
class MenuRepoImpl implements MenuRepo {
  MenuRepoImpl(this._remoteDs);

  final MenuRemoteDs _remoteDs;

  @override
  Future<res.Result<PagedResult<MenuItem>, Failure>> getMenu({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await _remoteDs.getMenu(page: page, limit: limit);
      return res.Success(MenuMapper.toPagedMenu(result));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<MenuItem, Failure>> getItemById(String id) async {
    try {
      final dto = await _remoteDs.getItemById(id);
      return res.Success(MenuMapper.toMenuItem(dto));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<MenuItem, Failure>> addItem(MenuItem item) async {
    try {
      final dto = MenuMapper.toDto(item);
      final added = await _remoteDs.addItem(dto);
      return res.Success(MenuMapper.toMenuItem(added));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<MenuItem, Failure>> updateItem(MenuItem item) async {
    try {
      final dto = MenuMapper.toDto(item);
      final updated = await _remoteDs.updateItem(dto);
      return res.Success(MenuMapper.toMenuItem(updated));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<MenuItem, Failure>> toggleAvailability(String id, bool isAvailable) async {
    try {
      final dto = await _remoteDs.toggleAvailability(id, isAvailable);
      return res.Success(MenuMapper.toMenuItem(dto));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }
}
