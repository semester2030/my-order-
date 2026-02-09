import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_keys.dart';

/// Secure storage for sensitive data (tokens, PIN, etc.)
class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: StorageKeys.accessToken, value: token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: StorageKeys.accessToken);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: StorageKeys.refreshToken, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: StorageKeys.refreshToken);
  }

  /// Save PIN hash
  Future<void> savePinHash(String pinHash) async {
    await _storage.write(key: StorageKeys.pinHash, value: pinHash);
  }

  /// Get PIN hash
  Future<String?> getPinHash() async {
    return await _storage.read(key: StorageKeys.pinHash);
  }

  /// Clear all secure data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Delete specific key
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
