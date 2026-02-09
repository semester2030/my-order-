import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../entities/vendor_profile.dart';

/// Repository for vendor profile (Phase 5–6).
abstract interface class ProfileRepo {
  Future<res.Result<VendorProfile, Failure>> getProfile();
  Future<res.Result<VendorProfile, Failure>> updateProfile(VendorProfile profile);
  Future<res.Result<void, Failure>> changePassword(String currentPassword, String newPassword);
}
