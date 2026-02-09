import 'package:vendor_app/shared/models/api_meta.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../models/menu_item_dto.dart';
import 'menu_remote_ds.dart';

/// Stub للقائمة حتى ربط الـ API — Phase 10.
class MenuRemoteDsStub implements MenuRemoteDs {
  final List<MenuItemDto> _items = [
    MenuItemDto(
      id: 'menu-1',
      name: 'وجبة تجريبية ١',
      description: 'وصف الوجبة',
      price: 45.0,
      isAvailable: true,
    ),
    MenuItemDto(
      id: 'menu-2',
      name: 'وجبة تجريبية ٢',
      price: 60.0,
      isAvailable: false,
    ),
  ];

  @override
  Future<PagedResult<MenuItemDto>> getMenu({
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return PagedResult<MenuItemDto>(
      data: List<MenuItemDto>.from(_items),
      meta: ApiMeta(page: page, limit: limit, total: _items.length, totalPages: 1),
    );
  }

  @override
  Future<MenuItemDto> getItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    for (final e in _items) {
      if (e.id == id) return e;
    }
    return MenuItemDto(id: id, name: 'وجبة', price: 0);
  }

  @override
  Future<MenuItemDto> addItem(MenuItemDto dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final id = 'menu-${DateTime.now().millisecondsSinceEpoch}';
    final added = MenuItemDto(
      id: id,
      name: dto.name,
      description: dto.description,
      price: dto.price,
      imageUrl: dto.imageUrl,
      videoUrl: dto.videoUrl,
      videoThumbnailUrl: dto.videoThumbnailUrl,
      isAvailable: dto.isAvailable,
      category: dto.category,
    );
    _items.add(added);
    return added;
  }

  @override
  Future<MenuItemDto> updateItem(MenuItemDto dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((e) => e.id == dto.id);
    if (index >= 0) _items[index] = dto;
    return dto;
  }

  @override
  Future<MenuItemDto> toggleAvailability(String id, bool isAvailable) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _items.indexWhere((e) => e.id == id);
    if (index >= 0) {
      final old = _items[index];
      _items[index] = MenuItemDto(
        id: old.id,
        name: old.name,
        description: old.description,
        price: old.price,
        imageUrl: old.imageUrl,
        videoUrl: old.videoUrl,
        videoThumbnailUrl: old.videoThumbnailUrl,
        isAvailable: isAvailable,
        category: old.category,
      );
      return _items[index];
    }
    return getItemById(id);
  }
}
