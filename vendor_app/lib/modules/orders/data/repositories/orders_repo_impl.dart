import 'package:vendor_app/core/errors/error_mapper.dart';
import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;
import 'package:vendor_app/shared/enums/order_status.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repo.dart';
import '../datasources/orders_remote_ds.dart';
import '../mappers/orders_mapper.dart';

/// تنفيذ [OrdersRepo] — Phase 8.
class OrdersRepoImpl implements OrdersRepo {
  OrdersRepoImpl(this._remoteDs);

  final OrdersRemoteDs _remoteDs;

  @override
  Future<res.Result<PagedResult<Order>, Failure>> getOrders({
    int page = 1,
    int limit = 20,
    OrderStatus? status,
  }) async {
    try {
      final result = await _remoteDs.getOrders(
        page: page,
        limit: limit,
        status: status?.name,
      );
      return res.Success(OrdersMapper.toPagedOrders(result));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<Order, Failure>> getOrderById(String id) async {
    try {
      final dto = await _remoteDs.getOrderById(id);
      return res.Success(OrdersMapper.toOrder(dto));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<Order, Failure>> acceptOrder(String id) async {
    try {
      final dto = await _remoteDs.acceptOrder(id);
      return res.Success(OrdersMapper.toOrder(dto));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<Order, Failure>> rejectOrder(String id, {String? reason}) async {
    try {
      final dto = await _remoteDs.rejectOrder(id, reason: reason);
      return res.Success(OrdersMapper.toOrder(dto));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<Order, Failure>> updateOrderStatus(String id, OrderStatus status) async {
    try {
      final dto = await _remoteDs.updateOrderStatus(id, status.name);
      return res.Success(OrdersMapper.toOrder(dto));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }
}
