import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../../domain/entities/staff_member.dart';
import '../../domain/repositories/staff_repo.dart';
import 'staff_state.dart';

/// Notifier لقائمة الموظفين — Phase 13.
class StaffNotifier extends StateNotifier<StaffState> {
  StaffNotifier(this._repo) : super(const StaffInitial());

  final StaffRepo _repo;

  static const int _defaultLimit = 20;

  Future<void> loadStaff({int page = 1}) async {
    state = const StaffLoading();
    final result = await _repo.getStaff(page: page, limit: _defaultLimit);
    result.when(
      success: (paged) => state = StaffLoaded(paged),
      failure: (f) => state = StaffError(f.message),
    );
  }

  Future<void> refresh() async {
    await loadStaff(page: 1);
  }

  Future<bool> addItem(StaffMember item) async {
    state = const StaffSaving();
    final result = await _repo.addItem(item);
    return result.when(
      success: (_) {
        loadStaff(page: 1);
        return true;
      },
      failure: (f) {
        state = StaffError(f.message);
        return false;
      },
    );
  }

  Future<bool> updateItem(StaffMember item) async {
    state = const StaffSaving();
    final result = await _repo.updateItem(item);
    return result.when(
      success: (_) {
        loadStaff(page: 1);
        return true;
      },
      failure: (f) {
        state = StaffError(f.message);
        return false;
      },
    );
  }
}
