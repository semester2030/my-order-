import 'package:vendor_app/shared/models/paged_result.dart';

import '../models/menu_item_dto.dart';

/// مصدر بيانات القائمة عن بعد — Phase 10.
abstract interface class MenuRemoteDs {
  Future<PagedResult<MenuItemDto>> getMenu({
    int page = 1,
    int limit = 20,
  });

  Future<MenuItemDto> getItemById(String id);

  Future<MenuItemDto> addItem(MenuItemDto dto);

  Future<MenuItemDto> updateItem(MenuItemDto dto);

  Future<MenuItemDto> toggleAvailability(String id, bool isAvailable);
}
