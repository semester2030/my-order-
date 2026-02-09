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
    
    // First check if token exists locally
    final hasLocalToken = await repository.isAuthenticated();
    
    if (!hasLocalToken) {
      state = const AuthState.unauthenticated();
      return;
    }

    // Validate token with backend
    try {
      final isValid = await repository.validateToken();
      
      if (!isValid) {
        // Token is invalid, clear local data (don't call backend logout)
        await repository.clearLocalData();
        state = const AuthState.unauthenticated();
        return;
      }

      // Token is valid, get user
      final user = await repository.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        // User not found locally, clear local data
        await repository.clearLocalData();
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      // If validation fails, clear local data and set unauthenticated
      await repository.clearLocalData();
      state = const AuthState.unauthenticated();
    }
  }

  String? _lastOtp; // Store OTP for development mode

  Future<void> requestOtp(String identifier) async {
    state = const AuthState.loading();
    try {
      final response = await repository.requestOtp(identifier);
      // In development, OTP is returned in response
      _lastOtp = response['otp'] as String?;
      // OTP requested successfully, stay in loading or move to next screen
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  String? getLastOtp() => _lastOtp;

  Future<void> verifyOtp(String identifier, String code) async {
    state = const AuthState.loading();
    try {
      final tokens = await repository.verifyOtp(identifier, code);
      if (tokens.user != null) {
        state = AuthState.authenticated(tokens.user!);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> setPin(String pin) async {
    state = const AuthState.loading();
    try {
      await repository.setPin(pin);
      // PIN set successfully
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> verifyPin(String identifier, String pin) async {
    state = const AuthState.loading();
    try {
      final tokens = await repository.verifyPin(identifier, pin);
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
