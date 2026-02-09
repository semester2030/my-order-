import 'package:vendor_app/shared/models/paged_result.dart';

import '../models/staff_member_dto.dart';

/// مصدر بيانات الموظفين عن بعد — Phase 13.
abstract interface class StaffRemoteDs {
  Future<PagedResult<StaffMemberDto>> getStaff({
    int page = 1,
    int limit = 20,
  });

  Future<StaffMemberDto> getItemById(String id);

  Future<StaffMemberDto> addItem(StaffMemberDto dto);

  Future<StaffMemberDto> updateItem(StaffMemberDto dto);
}
