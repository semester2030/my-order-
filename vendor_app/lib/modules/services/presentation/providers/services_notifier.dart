import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../../domain/entities/service_item.dart';
import '../../domain/repositories/services_repo.dart';
import 'services_state.dart';

/// Notifier لقائمة الخدمات — Phase 11 (قائمة + إضافة + تعديل).
class ServicesNotifier extends StateNotifier<ServicesState> {
  ServicesNotifier(this._repo) : super(const ServicesInitial());

  final ServicesRepo _repo;

  static const int _defaultLimit = 20;

  Future<void> loadServices({int page = 1}) async {
    state = const ServicesLoading();
    final result = await _repo.getServices(page: page, limit: _defaultLimit);
    result.when(
      success: (paged) => state = ServicesLoaded(paged),
      failure: (f) => state = ServicesError(f.message),
    );
  }

  Future<void> refresh() async {
    await loadServices(page: 1);
  }

  Future<bool> addItem(ServiceItem item) async {
    state = const ServicesSaving();
    final result = await _repo.addItem(item);
    return result.when(
      success: (_) {
        loadServices(page: 1);
        return true;
      },
      failure: (f) {
        state = ServicesError(f.message);
        return false;
      },
    );
  }

  Future<bool> updateItem(ServiceItem item) async {
    state = const ServicesSaving();
    final result = await _repo.updateItem(item);
    return result.when(
      success: (_) {
        loadServices(page: 1);
        return true;
      },
      failure: (f) {
        state = ServicesError(f.message);
        return false;
      },
    );
  }
}
