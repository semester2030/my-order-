import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';

/// Storage providers only (to avoid circular deps with locale_notifier).
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorageImpl();
});

final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorageImpl();
});
