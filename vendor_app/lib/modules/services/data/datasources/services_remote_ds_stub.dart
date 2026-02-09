import 'package:vendor_app/shared/models/api_meta.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../models/service_item_dto.dart';
import 'services_remote_ds.dart';

/// Stub للخدمات حتى ربط الـ API — Phase 11.
class ServicesRemoteDsStub implements ServicesRemoteDs {
  final List<ServiceItemDto> _items = [
    const ServiceItemDto(
      id: 'svc-1',
      name: 'خدمة تجريبية ١',
      description: 'وصف الخدمة',
      price: 100.0,
      isActive: true,
    ),
    const ServiceItemDto(
      id: 'svc-2',
      name: 'خدمة تجريبية ٢',
      isActive: false,
    ),
  ];

  @override
  Future<PagedResult<ServiceItemDto>> getServices({
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return PagedResult<ServiceItemDto>(
      data: List<ServiceItemDto>.from(_items),
      meta: ApiMeta(page: page, limit: limit, total: _items.length, totalPages: 1),
    );
  }

  @override
  Future<ServiceItemDto> getItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    for (final e in _items) {
      if (e.id == id) return e;
    }
    return ServiceItemDto(id: id, name: 'خدمة');
  }

  @override
  Future<ServiceItemDto> addItem(ServiceItemDto dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final id = 'svc-${DateTime.now().millisecondsSinceEpoch}';
    final added = ServiceItemDto(
      id: id,
      name: dto.name,
      description: dto.description,
      price: dto.price,
      imageUrl: dto.imageUrl,
      isActive: dto.isActive,
      category: dto.category,
    );
    _items.add(added);
    return added;
  }

  @override
  Future<ServiceItemDto> updateItem(ServiceItemDto dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((e) => e.id == dto.id);
    if (index >= 0) _items[index] = dto;
    return dto;
  }
}
