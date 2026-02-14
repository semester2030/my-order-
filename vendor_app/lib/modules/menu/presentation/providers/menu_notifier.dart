import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/utils/result.dart' as res;
import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repo.dart';
import 'menu_state.dart';

/// Notifier لقائمة الوجبات — Phase 10 (قائمة + إضافة + تعديل + توفر).
class MenuNotifier extends StateNotifier<MenuState> {
  MenuNotifier(this._repo) : super(const MenuInitial());

  final MenuRepo _repo;

  static const int _defaultLimit = 20;

  Future<void> loadMenu({int page = 1}) async {
    state = const MenuLoading();
    final result = await _repo.getMenu(page: page, limit: _defaultLimit);
    result.when(
      success: (paged) => state = MenuLoaded(paged),
      failure: (f) => state = MenuError(f.message),
    );
  }

  Future<void> refresh() async {
    await loadMenu(page: 1);
  }

  bool _loadingMore = false;

  /// تحميل الصفحة التالية عند التمرير — Phase 19 (استخدام paged_result و api_meta).
  Future<void> loadMore() async {
    final current = state;
    if (current is! MenuLoaded ||
        !current.result.hasNextPage ||
        _loadingMore) {
      return;
    }
    _loadingMore = true;
    final nextPage = current.result.meta.page + 1;
    final result = await _repo.getMenu(page: nextPage, limit: _defaultLimit);
    _loadingMore = false;
    result.when(
      success: (paged) {
        final merged = PagedResult<MenuItem>(
          data: [...current.result.data, ...paged.data],
          meta: paged.meta,
        );
        state = MenuLoaded(merged);
      },
      failure: (_) {},
    );
  }

  Future<bool> addItem(MenuItem item) async {
    state = const MenuSaving();
    final result = await _repo.addItem(item);
    return result.when(
      success: (_) {
        loadMenu(page: 1);
        return true;
      },
      failure: (f) {
        state = MenuError(f.message);
        return false;
      },
    );
  }

  /// يضيف وجبة ويرجع العنصر المُنشأ (لرفع الفيديو بعده).
  Future<MenuItem?> addItemAndReturnCreated(MenuItem item) async {
    state = const MenuSaving();
    final result = await _repo.addItem(item);
    return result.when(
      success: (created) {
        loadMenu(page: 1);
        return created;
      },
      failure: (f) {
        state = MenuError(f.message);
        return null;
      },
    );
  }

  Future<bool> updateItem(MenuItem item) async {
    state = const MenuSaving();
    final result = await _repo.updateItem(item);
    return result.when(
      success: (_) {
        loadMenu(page: 1);
        return true;
      },
      failure: (f) {
        state = MenuError(f.message);
        return false;
      },
    );
  }

  Future<bool> toggleAvailability(String id, bool isAvailable) async {
    final previous = state;
    final result = await _repo.toggleAvailability(id, isAvailable);
    return result.when(
      success: (item) {
        if (previous is MenuLoaded) {
          final updated = previous.result.data.map((e) => e.id == id ? item : e).toList();
          state = MenuLoaded(
            PagedResult<MenuItem>(data: updated, meta: previous.result.meta),
          );
        }
        return true;
      },
      failure: (_) => false,
    );
  }
}
