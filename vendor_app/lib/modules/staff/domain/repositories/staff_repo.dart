import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;
import 'package:vendor_app/shared/models/paged_result.dart';

import '../entities/staff_member.dart';

/// مستودع الموظفين — Phase 13.
abstract interface class StaffRepo {
  Future<res.Result<PagedResult<StaffMember>, Failure>> getStaff({
    int page = 1,
    int limit = 20,
  });

  Future<res.Result<StaffMember, Failure>> getItemById(String id);

  Future<res.Result<StaffMember, Failure>> addItem(StaffMember item);

  Future<res.Result<StaffMember, Failure>> updateItem(StaffMember item);
}
