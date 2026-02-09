import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_keys.dart';

/// Secure storage for sensitive data (tokens, etc.).
abstract interface class SecureStorage {
  Future<void> write(String key, String? value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}

/// Default implementation using [FlutterSecureStorage].
class SecureStorageImpl implements SecureStorage {
  SecureStorageImpl() : _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String? value) async {
    if (value == null) {
      await _storage.delete(key: key);
    } else {
      await _storage.write(key: key, value: value);
    }
  }

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}

/// Convenience: save/read access and refresh tokens.
extension SecureStorageTokens on SecureStorage {
  Future<void> saveAccessToken(String token) =>
      write(StorageKeys.accessToken, token);

  Future<String?> getAccessToken() => read(StorageKeys.accessToken);

  Future<void> saveRefreshToken(String token) =>
      write(StorageKeys.refreshToken, token);

  Future<String?> getRefreshToken() => read(StorageKeys.refreshToken);

  Future<void> clearTokens() async {
    await write(StorageKeys.accessToken, null);
    await write(StorageKeys.refreshToken, null);
  }
}
