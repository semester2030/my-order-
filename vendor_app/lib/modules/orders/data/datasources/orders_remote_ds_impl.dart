import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';
import 'package:vendor_app/shared/models/api_meta.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../models/order_dto.dart';
import 'orders_remote_ds.dart';

/// تنفيذ الطلبات عبر API الباك اند — Phase 18.
class OrdersRemoteDsImpl implements OrdersRemoteDs {
  OrdersRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<PagedResult<OrderDto>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (status != null && status.isNotEmpty) 'status': status,
    };
    final response = await _dio.get<dynamic>(
      Endpoints.vendorsOrders,
      queryParameters: query,
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    List<dynamic> list;
    Map<String, dynamic>? metaMap;
    if (data is List) {
      list = data;
      metaMap = null;
    } else if (data is Map<String, dynamic>) {
      list = data['data'] is List ? data['data'] as List<dynamic> : <dynamic>[];
      metaMap = data['meta'] is Map<String, dynamic> ? data['meta'] as Map<String, dynamic> : null;
    } else {
      list = <dynamic>[];
    }
    final items = <OrderDto>[];
    for (final e in list) {
      if (e is Map<String, dynamic>) {
        items.add(OrderDto.fromJson(_normalizeOrderJson(e)));
      }
    }
    final meta = metaMap != null
        ? ApiMeta.fromJson(metaMap)
        : ApiMeta(page: page, limit: limit, total: items.length, totalPages: 1);
    return PagedResult<OrderDto>(data: items, meta: meta);
  }

  @override
  Future<OrderDto> getOrderById(String id) async {
    final response = await _dio.get<dynamic>(
      Endpoints.vendorOrderById(id),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    final map = data is Map<String, dynamic>
        ? _normalizeOrderJson(data)
        : <String, dynamic>{};
    return OrderDto.fromJson(map);
  }

  /// الباك اند يرجع كيان Order: total بدل totalAmount، user.name بدل customerName — توحيد المفاتيح.
  /// الباك اند قد يرسل أرقاماً كنص (String) — نتعامل معها بأمان.
  static Map<String, dynamic> _normalizeOrderJson(Map<String, dynamic> json) {
    final m = Map<String, dynamic>.from(json);
    if (m.containsKey('total') && !m.containsKey('totalAmount')) {
      m['totalAmount'] = _safeDouble(m['total']);
    }
    if (m.containsKey('user') && m['user'] is Map<String, dynamic>) {
      final user = m['user'] as Map<String, dynamic>;
      if (!m.containsKey('customerName')) {
        m['customerName'] = user['name'] ?? user['email'] ?? '';
      }
      if (!m.containsKey('customerPhone')) {
        m['customerPhone'] = user['phoneNumber'] ?? user['phone'];
      }
    }
    if (m['items'] is List) {
      final items = (m['items'] as List).map<Map<String, dynamic>>((e) {
        if (e is! Map<String, dynamic>) return <String, dynamic>{};
        final item = Map<String, dynamic>.from(e);
        if (item.containsKey('menuItem') && item['menuItem'] is Map<String, dynamic>) {
          final menuItem = item['menuItem'] as Map<String, dynamic>;
          if (!item.containsKey('name')) item['name'] = menuItem['name'] ?? '';
        }
        if (item.containsKey('price') && !item.containsKey('unitPrice')) {
          item['unitPrice'] = _safeDouble(item['price']);
        }
        return item;
      }).toList();
      m['items'] = items;
    }
    return m;
  }

  static double _safeDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  Future<OrderDto> acceptOrder(String id) async {
    await _dio.post<dynamic>(
      '${Endpoints.vendorOrderById(id)}/accept',
    );
    // الباك اند قد يرجع كيان Order بدون علاقات (user, items) — نجلب الطلب الكامل بعد القبول.
    return getOrderById(id);
  }

  @override
  Future<OrderDto> rejectOrder(String id, {String? reason}) async {
    await _dio.post<dynamic>(
      '${Endpoints.vendorOrderById(id)}/reject',
      data: reason != null && reason.isNotEmpty ? {'reason': reason} : null,
    );
    // الباك اند قد يرجع كيان Order بدون علاقات — نجلب الطلب الكامل بعد الرفض.
    return getOrderById(id);
  }

  @override
  Future<OrderDto> updateOrderStatus(String id, String status) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '${Endpoints.vendorOrderById(id)}/status',
      data: {'status': status},
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return OrderDto.fromJson(data);
  }
}
