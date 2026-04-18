import '../models/vendor_profile_dto.dart';

/// Remote datasource for vendor profile (Phase 5–6: stub؛ Phase 7/18: real API).
abstract interface class ProfileRemoteDs {
  Future<VendorProfileDto> getProfile();
  Future<VendorProfileDto> updateProfile(
    VendorProfileDto dto, {
    bool bankingFieldsOnly = false,
  });
  Future<void> changePassword(String currentPassword, String newPassword);
}
