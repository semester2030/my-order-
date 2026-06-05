import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/guest_mode_keys.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/storage/local_storage.dart';

final guestModeProvider =
    StateNotifierProvider<GuestModeNotifier, bool>((ref) {
  return GuestModeNotifier(ref.watch(localStorageProvider));
});

class GuestModeNotifier extends StateNotifier<bool> {
  GuestModeNotifier(this._storage) : super(false) {
    _load();
  }

  final LocalStorage _storage;

  Future<void> _load() async {
    final v = await _storage.getBool(GuestModeKeys.browsing);
    if (v == true) state = true;
  }

  Future<void> enable() async {
    await _storage.saveBool(GuestModeKeys.browsing, true);
    state = true;
  }

  Future<void> disable() async {
    await _storage.saveBool(GuestModeKeys.browsing, false);
    state = false;
  }
}
