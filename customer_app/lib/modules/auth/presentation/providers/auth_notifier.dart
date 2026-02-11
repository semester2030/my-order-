import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../data/repositories/auth_repo_impl.dart';
import '../../data/datasources/auth_remote_ds.dart';
import '../../data/datasources/auth_local_ds.dart';
import '../../../../core/di/providers.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final localStorage = ref.watch(localStorageProvider);
  return AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(apiClient: apiClient),
    localDataSource: AuthLocalDataSourceImpl(
      secureStorage: secureStorage,
      localStorage: localStorage,
    ),
  );
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthNotifier(this.repository) : super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = const AuthState.loading();
    final hasLocalToken = await repository.isAuthenticated();
    if (!hasLocalToken) {
      state = const AuthState.unauthenticated();
      return;
    }
    try {
      final isValid = await repository.validateToken();
      if (!isValid) {
        await repository.clearLocalData();
        state = const AuthState.unauthenticated();
        return;
      }
      final user = await repository.getCurrentUser();
      state = user != null ? AuthState.authenticated(user) : const AuthState.unauthenticated();
      if (user == null) await repository.clearLocalData();
    } catch (_) {
      await repository.clearLocalData();
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = const AuthState.loading();
    try {
      final tokens = await repository.register(name, email.trim(), password);
      if (tokens.user != null) {
        state = AuthState.authenticated(tokens.user!);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final tokens = await repository.login(email.trim(), password);
      if (tokens.user != null) {
        state = AuthState.authenticated(tokens.user!);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      await repository.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}
