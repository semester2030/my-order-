import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/utils/result.dart' as res;
import 'package:vendor_app/shared/enums/order_status.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repo.dart';
import 'orders_state.dart';

/// Notifier لقائمة الطلبات — Phase 9 (pagination + refresh)، Phase 19 (load-more).
class OrdersNotifier extends StateNotifier<OrdersState> {
  OrdersNotifier(this._repo) : super(const OrdersInitial());

  final OrdersRepo _repo;

  static const int _defaultLimit = 20;
  bool _loadingMore = false;

  Future<void> loadOrders({int page = 1, OrderStatus? status}) async {
    state = const OrdersLoading();
    final result = await _repo.getOrders(
      page: page,
      limit: _defaultLimit,
      status: status,
    );
    result.when(
      success: (paged) => state = OrdersLoaded(paged),
      failure: (f) => state = OrdersError(f.message),
    );
  }

  Future<void> refresh() async {
    await loadOrders(page: 1);
  }

  /// تحميل الصفحة التالية عند التمرير — Phase 19 (استخدام paged_result و api_meta).
  Future<void> loadMore({OrderStatus? status}) async {
    final current = state;
    if (current is! OrdersLoaded ||
        !current.result.hasNextPage ||
        _loadingMore) {
      return;
    }
    _loadingMore = true;
    final nextPage = current.result.meta.page + 1;
    final result = await _repo.getOrders(
      page: nextPage,
      limit: _defaultLimit,
      status: status,
    );
    _loadingMore = false;
    result.when(
      success: (paged) {
        final merged = PagedResult<Order>(
          data: [...current.result.data, ...paged.data],
          meta: paged.meta,
        );
        state = OrdersLoaded(merged);
      },
      failure: (_) {},
    );
  }
}
