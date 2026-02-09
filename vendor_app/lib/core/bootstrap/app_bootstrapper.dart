import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../routing/route_names.dart';
import '../di/providers.dart';
import '../../modules/auth/presentation/providers/session_state.dart';

/// يشغّل التحقق من الجلسة ويوجّه إلى Login / Pending / Rejected / Shell.
Future<void> runAppBootstrap(BuildContext context, WidgetRef ref) async {
  await ref.read(sessionNotifierProvider.notifier).checkSession();
  final sessionState = ref.read(sessionNotifierProvider);

  if (!context.mounted) return;

  if (sessionState is SessionUnauthenticated) {
    context.go(RouteNames.login);
  } else if (sessionState is SessionPending) {
    context.go(RouteNames.pending);
  } else if (sessionState is SessionRejected) {
    context.go(RouteNames.rejected);
  } else if (sessionState is SessionAuthenticated) {
    context.go(RouteNames.shell);
  }
  // SessionInitial / SessionLoading: نبقى على الشاشة الحالية (Splash)
}
