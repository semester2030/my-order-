import 'package:equatable/equatable.dart';

/// Session / bootstrap state (حالة الجلسة وموافقة التسجيل).
sealed class SessionState with EquatableMixin {
  const SessionState();

  @override
  List<Object?> get props => [];
}

/// لم يتم التحقق بعد.
final class SessionInitial extends SessionState {
  const SessionInitial();
}

/// جاري التحقق من الجلسة.
final class SessionLoading extends SessionState {
  const SessionLoading();
}

/// غير مسجل — التوجيه إلى Login.
final class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated();
}

/// مسجل وفي انتظار الموافقة — التوجيه إلى Pending.
final class SessionPending extends SessionState {
  const SessionPending([this.message]);
  final String? message;

  @override
  List<Object?> get props => [message];
}

/// مسجل وتم رفض الطلب — التوجيه إلى Rejected.
final class SessionRejected extends SessionState {
  const SessionRejected([this.reason]);
  final String? reason;

  @override
  List<Object?> get props => [reason];
}

/// مسجل وموافق — التوجيه إلى Shell.
final class SessionAuthenticated extends SessionState {
  const SessionAuthenticated();
}
