import 'package:vendor_app/shared/models/api_meta.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../models/staff_member_dto.dart';
import 'staff_remote_ds.dart';

/// Stub للموظفين حتى ربط الـ API — Phase 13.
class StaffRemoteDsStub implements StaffRemoteDs {
  final List<StaffMemberDto> _items = [
    const StaffMemberDto(
      id: 'staff-1',
      name: 'أحمد محمد',
      role: 'طباخ',
      phone: '0500000001',
      isActive: true,
    ),
    const StaffMemberDto(
      id: 'staff-2',
      name: 'سارة علي',
      role: 'مساعد',
      isActive: true,
    ),
  ];

  @override
  Future<PagedResult<StaffMemberDto>> getStaff({
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return PagedResult<StaffMemberDto>(
      data: List<StaffMemberDto>.from(_items),
      meta: ApiMeta(page: page, limit: limit, total: _items.length, totalPages: 1),
    );
  }

  @override
  Future<StaffMemberDto> getItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    for (final e in _items) {
      if (e.id == id) return e;
    }
    return const StaffMemberDto(id: '', name: 'موظف');
  }

  @override
  Future<StaffMemberDto> addItem(StaffMemberDto dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final id = 'staff-${DateTime.now().millisecondsSinceEpoch}';
    final added = StaffMemberDto(
      id: id,
      name: dto.name,
      role: dto.role,
      email: dto.email,
      phone: dto.phone,
      isActive: dto.isActive,
    );
    _items.add(added);
    return added;
  }

  @override
  Future<StaffMemberDto> updateItem(StaffMemberDto dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((e) => e.id == dto.id);
    if (index >= 0) _items[index] = dto;
    return dto;
  }
}
