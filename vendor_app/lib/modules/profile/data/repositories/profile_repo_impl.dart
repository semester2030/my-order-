import 'package:vendor_app/core/errors/error_mapper.dart';
import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../../domain/entities/vendor_profile.dart';
import '../../domain/repositories/profile_repo.dart';
import '../datasources/profile_remote_ds.dart';
import '../mappers/profile_mapper.dart';

/// Implementation of [ProfileRepo].
class ProfileRepoImpl implements ProfileRepo {
  ProfileRepoImpl(this._remoteDs);

  final ProfileRemoteDs _remoteDs;

  @override
  Future<res.Result<VendorProfile, Failure>> getProfile() async {
    try {
      final dto = await _remoteDs.getProfile();
      final profile = ProfileMapper.toEntity(dto);
      return res.Success(profile);
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<VendorProfile, Failure>> updateProfile(VendorProfile profile) async {
    try {
      final dto = ProfileMapper.toDto(profile);
      final updated = await _remoteDs.updateProfile(dto);
      return res.Success(ProfileMapper.toEntity(updated));
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<void, Failure>> changePassword(String currentPassword, String newPassword) async {
    try {
      await _remoteDs.changePassword(currentPassword, newPassword);
      return res.Success(null);
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }
}
