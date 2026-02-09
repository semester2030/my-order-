import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../domain/repositories/profile_repo.dart';
import 'profile_state.dart';

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository);
});

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository repository;

  ProfileNotifier(this.repository) : super(const ProfileState.initial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = const ProfileState.loading();
    try {
      final profile = await repository.getProfile();
      state = ProfileState.loaded(profile);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }

  Future<void> updateProfile({String? name, String? email}) async {
    state = const ProfileState.loading();
    try {
      final profile = await repository.updateProfile(name: name, email: email);
      state = ProfileState.loaded(profile);
    } catch (e) {
      state = ProfileState.error(e.toString());
      rethrow;
    }
  }

  Future<void> refresh() async {
    await loadProfile();
  }
}
