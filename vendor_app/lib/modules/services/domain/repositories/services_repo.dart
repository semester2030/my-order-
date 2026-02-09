import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;
import 'package:vendor_app/shared/models/paged_result.dart';

import '../entities/service_item.dart';

/// مستودع الخدمات — Phase 11 (قائمة + إضافة + تعديل).
abstract interface class ServicesRepo {
  Future<res.Result<PagedResult<ServiceItem>, Failure>> getServices({
    int page = 1,
    int limit = 20,
  });

  Future<res.Result<ServiceItem, Failure>> getItemById(String id);

  Future<res.Result<ServiceItem, Failure>> addItem(ServiceItem item);

  Future<res.Result<ServiceItem, Failure>> updateItem(ServiceItem item);
}
