import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/storage_providers.dart';
import '../storage/storage_keys.dart';

/// يحمّل اللغة المحفوظة ويسمح بتغييرها — Phase 16.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    Future.microtask(() => _load());
    return const Locale('ar');
  }

  Future<void> _load() async {
    final storage = ref.read(localStorageProvider);
    final code = await storage.getString(StorageKeys.locale);
    if (code == 'en') {
      state = const Locale('en');
    }
  }

  Future<void> setLocale(Locale locale) async {
    final storage = ref.read(localStorageProvider);
    await storage.setString(StorageKeys.locale, locale.languageCode);
    state = locale;
  }
}
