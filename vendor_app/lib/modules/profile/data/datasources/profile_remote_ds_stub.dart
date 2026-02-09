import '../models/vendor_profile_dto.dart';
import 'profile_remote_ds.dart';

/// Stub: يرجع profile وهمي حتى ربط الـ API (Phase 6: update/changePassword واجهة فقط).
class ProfileRemoteDsStub implements ProfileRemoteDs {
  VendorProfileDto _cached = const VendorProfileDto(
    id: 'mock-vendor-1',
    name: 'مطبخ تجريبي',
    tradeName: 'Test Kitchen',
    email: 'vendor@example.com',
    phoneNumber: '0500000000',
    isActive: true,
    isAcceptingOrders: true,
    registrationStatus: 'approved',
  );

  @override
  Future<VendorProfileDto> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _cached;
  }

  @override
  Future<VendorProfileDto> updateProfile(VendorProfileDto dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _cached = dto;
    return dto;
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
