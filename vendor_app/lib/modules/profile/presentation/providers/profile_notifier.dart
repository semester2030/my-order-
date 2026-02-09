import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../../domain/entities/vendor_profile.dart';
import '../../domain/repositories/profile_repo.dart';
import 'profile_state.dart';

/// Notifier لبروفايل المقدم: جلب، تحديث، تغيير كلمة المرور (Phase 6).
class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier(this._repo) : super(const ProfileInitial());

  final ProfileRepo _repo;

  Future<void> loadProfile() async {
    state = const ProfileLoading();
    final result = await _repo.getProfile();
    result.when(
      success: (profile) => state = ProfileLoaded(profile),
      failure: (f) => state = ProfileError(f.message),
    );
  }

  Future<bool> updateProfile(VendorProfile profile) async {
    final previous = state;
    state = const ProfileSaving();
    final result = await _repo.updateProfile(profile);
    return result.when(
      success: (updated) {
        state = ProfileLoaded(updated);
        return true;
      },
      failure: (f) {
        state = ProfileSaveError(f.message);
        if (previous is ProfileLoaded) {
          state = ProfileLoaded(previous.profile);
        }
        return false;
      },
    );
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    final previous = state;
    state = const ProfileSaving();
    final result = await _repo.changePassword(currentPassword, newPassword);
    return result.when(
      success: (_) {
        if (previous is ProfileLoaded) {
          state = ProfileLoaded(previous.profile);
        }
        return true;
      },
      failure: (f) {
        state = ProfileSaveError(f.message);
        if (previous is ProfileLoaded) {
          state = ProfileLoaded(previous.profile);
        }
        return false;
      },
    );
  }
}
