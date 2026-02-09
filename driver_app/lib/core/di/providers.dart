import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage.dart';
import '../storage/local_storage.dart';
import '../network/api_client.dart';

/// Core providers for dependency injection
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorage();
});

/// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: secureStorage);
});
