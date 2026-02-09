import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;
import 'package:vendor_app/shared/models/paged_result.dart';

import '../entities/menu_item.dart';

/// مستودع قائمة الوجبات — Phase 10 (قائمة + إضافة + تعديل + توفر).
abstract interface class MenuRepo {
  Future<res.Result<PagedResult<MenuItem>, Failure>> getMenu({
    int page = 1,
    int limit = 20,
  });

  Future<res.Result<MenuItem, Failure>> getItemById(String id);

  Future<res.Result<MenuItem, Failure>> addItem(MenuItem item);

  Future<res.Result<MenuItem, Failure>> updateItem(MenuItem item);

  Future<res.Result<MenuItem, Failure>> toggleAvailability(String id, bool isAvailable);
}
