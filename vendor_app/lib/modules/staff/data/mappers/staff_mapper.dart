import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/staff_member.dart';
import '../models/staff_member_dto.dart';

/// تحويل DTOs الموظفين إلى كيانات النطاق — Phase 13.
class StaffMapper {
  StaffMapper._();

  static StaffMember toStaffMember(StaffMemberDto dto) {
    return StaffMember(
      id: dto.id,
      name: dto.name,
      role: dto.role,
      email: dto.email,
      phone: dto.phone,
      isActive: dto.isActive,
    );
  }

  static StaffMemberDto toDto(StaffMember entity) {
    return StaffMemberDto(
      id: entity.id,
      name: entity.name,
      role: entity.role,
      email: entity.email,
      phone: entity.phone,
      isActive: entity.isActive,
    );
  }

  static PagedResult<StaffMember> toPagedStaff(PagedResult<StaffMemberDto> dto) {
    return PagedResult<StaffMember>(
      data: dto.data.map(toStaffMember).toList(),
      meta: dto.meta,
    );
  }
}
