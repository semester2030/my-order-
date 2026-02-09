import 'package:vendor_app/shared/models/paged_result.dart';

import '../models/service_item_dto.dart';

/// مصدر بيانات الخدمات عن بعد — Phase 11.
abstract interface class ServicesRemoteDs {
  Future<PagedResult<ServiceItemDto>> getServices({
    int page = 1,
    int limit = 20,
  });

  Future<ServiceItemDto> getItemById(String id);

  Future<ServiceItemDto> addItem(ServiceItemDto dto);

  Future<ServiceItemDto> updateItem(ServiceItemDto dto);
}
