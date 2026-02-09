import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/menu_item.dart';
import '../models/menu_item_dto.dart';

/// تحويل DTOs القائمة إلى كيانات النطاق — Phase 10.
class MenuMapper {
  MenuMapper._();

  static MenuItem toMenuItem(MenuItemDto dto) {
    return MenuItem(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      price: dto.price,
      imageUrl: dto.imageUrl,
      videoUrl: dto.videoUrl,
      videoThumbnailUrl: dto.videoThumbnailUrl,
      isAvailable: dto.isAvailable,
      category: dto.category,
    );
  }

  static MenuItemDto toDto(MenuItem entity) {
    return MenuItemDto(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
      videoUrl: entity.videoUrl,
      videoThumbnailUrl: entity.videoThumbnailUrl,
      isAvailable: entity.isAvailable,
      category: entity.category,
    );
  }

  static PagedResult<MenuItem> toPagedMenu(PagedResult<MenuItemDto> dto) {
    return PagedResult<MenuItem>(
      data: dto.data.map(toMenuItem).toList(),
      meta: dto.meta,
    );
  }
}
