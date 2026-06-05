import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../localization/app_localizations.dart';
import '../routing/route_names.dart';
import '../../modules/auth/presentation/providers/auth_notifier.dart';

/// يعرض حوار تسجيل الدخول عند محاولة حجز/طلب في وضع الزائر.
Future<bool> requireCustomerAuth(
  BuildContext context,
  WidgetRef ref, {
  String? message,
}) async {
  final auth = ref.read(authNotifierProvider);
  final isAuth = auth.maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );
  if (isAuth) return true;

  final l = AppLocalizations.of(context);
  final go = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.guestAuthRequiredTitle),
      content: Text(message ?? l.guestAuthRequiredMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, 'register'),
          child: Text(l.register),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, 'login'),
          child: Text(l.login),
        ),
      ],
    ),
  );
  if (!context.mounted) return false;
  if (go == 'login') {
    context.push(RouteNames.login);
  } else if (go == 'register') {
    context.push(RouteNames.register);
  }
  return false;
}
