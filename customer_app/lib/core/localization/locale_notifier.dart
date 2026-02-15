import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/providers.dart';
import '../storage/storage_keys.dart';

/// يحمّل اللغة المحفوظة ويسمح بتغييرها.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    Future.microtask(() => _load());
    return const Locale('ar');
  }

  Future<void> _load() async {
    final storage = ref.read(localStorageProvider);
    final code = await storage.getString(StorageKeys.selectedLanguage);
    if (code == 'en') {
      state = const Locale('en');
    }
  }

  Future<void> setLocale(Locale locale) async {
    final storage = ref.read(localStorageProvider);
    await storage.saveString(StorageKeys.selectedLanguage, locale.languageCode);
    state = locale;
  }
}
