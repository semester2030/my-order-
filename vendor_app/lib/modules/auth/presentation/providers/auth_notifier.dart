import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../../domain/entities/register_vendor_request.dart';
import '../../domain/repositories/auth_repo.dart';
import 'auth_state.dart';

/// Notifier for auth: login and register. Updates [AuthState].
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repo) : super(const AuthInitial());

  final AuthRepo _repo;

  /// Login with email and password.
  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    final result = await _repo.login(email, password);
    result.when(
      success: (session) => state = AuthAuthenticated(session),
      failure: (f) => state = AuthError(f.message, _errorTypeFromFailure(f)),
    );
  }

  /// Register a new vendor.
  Future<void> register(RegisterVendorRequest request) async {
    state = const AuthLoading();
    final result = await _repo.register(request);
    result.when(
      success: (_) => state = const AuthUnauthenticated(),
      failure: (f) => state = AuthError(f.message, _errorTypeFromFailure(f)),
    );
  }

  static AuthErrorType _errorTypeFromFailure(Failure f) {
    if (f is AuthFailure) return AuthErrorType.credentials;
    if (f is NetworkFailure) return AuthErrorType.network;
    if (f is ValidationFailure) return AuthErrorType.validation;
    if (f is ServerFailure) return AuthErrorType.server;
    return AuthErrorType.generic;
  }

  /// Clear to unauthenticated (e.g. for navigation; full logout in Phase 7).
  void setUnauthenticated() {
    state = const AuthUnauthenticated();
  }

  /// Clear error and go to initial.
  void clearError() {
    if (state is AuthError) state = const AuthInitial();
  }
}
