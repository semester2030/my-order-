import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/service_item.dart';
import '../models/service_item_dto.dart';

/// تحويل DTOs الخدمات إلى كيانات النطاق — Phase 11.
class ServicesMapper {
  ServicesMapper._();

  static ServiceItem toServiceItem(ServiceItemDto dto) {
    return ServiceItem(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      price: dto.price,
      imageUrl: dto.imageUrl,
      isActive: dto.isActive,
      category: dto.category,
    );
  }

  static ServiceItemDto toDto(ServiceItem entity) {
    return ServiceItemDto(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
      isActive: entity.isActive,
      category: entity.category,
    );
  }

  static PagedResult<ServiceItem> toPagedServices(PagedResult<ServiceItemDto> dto) {
    return PagedResult<ServiceItem>(
      data: dto.data.map(toServiceItem).toList(),
      meta: dto.meta,
    );
  }
}
