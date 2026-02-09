import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/storage/secure_storage.dart';
import 'package:vendor_app/core/storage/storage_keys.dart';
import 'package:vendor_app/core/utils/result.dart';
import 'package:vendor_app/modules/profile/domain/entities/vendor_profile.dart';
import 'package:vendor_app/modules/profile/domain/repositories/profile_repo.dart';

import 'auth_notifier.dart';
import 'session_state.dart';

/// Notifier لحالة الجلسة وموافقة التسجيل. Phase 7: توكن + profile + registrationStatus.
class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier(
    this._authNotifier,
    this._profileRepo,
    this._secureStorage,
  ) : super(const SessionInitial());

  final AuthNotifier _authNotifier;
  final ProfileRepo _profileRepo;
  final SecureStorage _secureStorage;

  /// التحقق من الجلسة: توكن ثم جلب البروفايل وقراءة registrationStatus.
  Future<void> checkSession() async {
    state = const SessionLoading();
    final token = await _secureStorage.read(StorageKeys.accessToken);
    if (token == null || token.isEmpty) {
      state = const SessionUnauthenticated();
      return;
    }
    final result = await _profileRepo.getProfile();
    var isFailure = false;
    result.when(
      success: (VendorProfile profile) {
        final status = profile.registrationStatus?.toLowerCase();
        if (status == 'pending') {
          state = SessionPending(profile.rejectionReason ?? 'جاري مراجعة طلبك');
        } else if (status == 'rejected') {
          state = SessionRejected(
            profile.rejectionReason ?? 'تم رفض طلب التسجيل',
          );
        } else {
          state = const SessionAuthenticated();
        }
      },
      failure: (_) {
        isFailure = true;
      },
    );
    if (isFailure) {
      await _secureStorage.write(StorageKeys.accessToken, null);
      await _secureStorage.write(StorageKeys.refreshToken, null);
      state = const SessionUnauthenticated();
    }
  }

  /// عند 401 من البروفايل: مسح التوكن.
  Future<void> clearSession() async {
    await _secureStorage.write(StorageKeys.accessToken, null);
    await _secureStorage.write(StorageKeys.refreshToken, null);
    _authNotifier.setUnauthenticated();
    state = const SessionUnauthenticated();
  }

  /// للاختبار: تعيين حالة pending يدوياً.
  void setPending([String? message]) {
    state = SessionPending(message);
  }

  /// للاختبار: تعيين حالة rejected يدوياً.
  void setRejected([String? reason]) {
    state = SessionRejected(reason);
  }

  /// للاختبار: تعيين حالة authenticated (للتوجيه إلى Shell لاحقاً).
  void setAuthenticated() {
    state = const SessionAuthenticated();
  }

  /// إعادة إلى unauthenticated (تسجيل خروج) — مسح التوكن.
  Future<void> setUnauthenticated() async {
    await _secureStorage.write(StorageKeys.accessToken, null);
    await _secureStorage.write(StorageKeys.refreshToken, null);
    _authNotifier.setUnauthenticated();
    state = const SessionUnauthenticated();
  }
}
