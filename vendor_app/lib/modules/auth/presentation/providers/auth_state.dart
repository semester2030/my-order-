import 'package:equatable/equatable.dart';

import '../../domain/entities/vendor_session.dart';

/// نوع خطأ المصادقة لعرض رسالة واضحة للمستخدم (Phase 17).
enum AuthErrorType {
  credentials,
  network,
  validation,
  server,
  generic,
}

/// Auth UI state (no freezed codegen in Phase 3).
sealed class AuthState with EquatableMixin {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state (not loading, not authenticated).
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading (login or register in progress).
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated with session.
final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.session);
  final VendorSession session;

  @override
  List<Object?> get props => [session];
}

/// Not authenticated (after logout or never logged in).
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error (login/register failed). [type] for localized message fallback.
final class AuthError extends AuthState {
  const AuthError(this.message, [this.type]);
  final String message;
  final AuthErrorType? type;

  @override
  List<Object?> get props => [message, type];
}
