import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../data/repositories/auth_repo_impl.dart';
import '../../data/datasources/auth_remote_ds.dart';
import '../../data/datasources/auth_local_ds.dart';
import '../../../../core/di/providers.dart';
import 'auth_state.dart';

/// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final localStorage = ref.watch(localStorageProvider);

  final remoteDataSource = AuthRemoteDataSourceImpl(apiClient: apiClient);
  final localDataSource = AuthLocalDataSourceImpl(
    secureStorage: secureStorage,
    localStorage: localStorage,
  );

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

/// Auth Notifier Provider
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthNotifier(this.repository) : super(const AuthInitial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = const AuthLoading();

    // First check if token exists locally
    final hasLocalToken = await repository.isAuthenticated();

    if (!hasLocalToken) {
      state = const AuthUnauthenticated();
      return;
    }

    // Validate token with backend
    try {
      final isValid = await repository.validateToken();

      if (!isValid) {
        // Token is invalid, clear local data
        await repository.clearLocalData();
        state = const AuthUnauthenticated();
        return;
      }

      // Token is valid, get user
      final user = await repository.getCurrentUser();
      if (user != null) {
        state = AuthAuthenticated(user);
      } else {
        // User not found locally, clear local data
        await repository.clearLocalData();
        state = const AuthUnauthenticated();
      }
    } catch (e) {
      // If validation fails, clear local data and set unauthenticated
      await repository.clearLocalData();
      state = const AuthUnauthenticated();
    }
  }

  String? _lastOtp; // Store OTP for development mode

  Future<void> requestOtp(String phone) async {
    state = const AuthLoading();
    try {
      final response = await repository.requestOtp(phone);
      // In development, OTP is returned in response
      _lastOtp = response['otp'] as String?;
      // OTP requested successfully
      state = const AuthUnauthenticated();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  String? getLastOtp() => _lastOtp;

  Future<void> verifyOtp(String phone, String code) async {
    state = const AuthLoading();
    try {
      final tokens = await repository.verifyOtp(phone, code);
      if (tokens.user != null) {
        state = AuthAuthenticated(tokens.user!);
      } else {
        state = const AuthUnauthenticated();
      }
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> setPin(String pin) async {
    state = const AuthLoading();
    try {
      await repository.setPin(pin);
      // PIN set successfully, state remains authenticated
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> verifyPin(String phone, String pin) async {
    state = const AuthLoading();
    try {
      final tokens = await repository.verifyPin(phone, pin);
      if (tokens.user != null) {
        state = AuthAuthenticated(tokens.user!);
      } else {
        state = const AuthUnauthenticated();
      }
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await repository.logout();
    } finally {
      state = const AuthUnauthenticated();
    }
  }
}
