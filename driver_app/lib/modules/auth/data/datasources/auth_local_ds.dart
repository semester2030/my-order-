import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../domain/entities/user_entity.dart';

/// Auth Local Data Source
abstract class AuthLocalDataSource {
  Future<void> saveTokens(String accessToken, String refreshToken);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
  Future<void> saveUser(UserEntity user);
  Future<UserEntity?> getUser();
  Future<void> clearUser();
  Future<void> savePinHash(String pinHash);
  Future<String?> getPinHash();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage secureStorage;
  final LocalStorage localStorage;

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.localStorage,
  });

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await secureStorage.saveAccessToken(accessToken);
    await secureStorage.saveRefreshToken(refreshToken);
  }

  @override
  Future<String?> getAccessToken() async {
    return await secureStorage.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return await secureStorage.getRefreshToken();
  }

  @override
  Future<void> clearTokens() async {
    await secureStorage.delete(StorageKeys.accessToken);
    await secureStorage.delete(StorageKeys.refreshToken);
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    await localStorage.saveString(StorageKeys.userId, user.id);
    await localStorage.saveString(StorageKeys.userPhone, user.phone);
    if (user.name != null) {
      await localStorage.saveString(StorageKeys.userName, user.name!);
    }
  }

  @override
  Future<UserEntity?> getUser() async {
    final userId = await localStorage.getString(StorageKeys.userId);
    final userPhone = await localStorage.getString(StorageKeys.userPhone);

    if (userId == null || userPhone == null) {
      return null;
    }

    final userName = await localStorage.getString(StorageKeys.userName);

    return UserEntity(
      id: userId,
      phone: userPhone,
      name: userName,
      isVerified: true,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> clearUser() async {
    await localStorage.remove(StorageKeys.userId);
    await localStorage.remove(StorageKeys.userPhone);
    await localStorage.remove(StorageKeys.userName);
  }

  @override
  Future<void> savePinHash(String pinHash) async {
    await secureStorage.savePinHash(pinHash);
  }

  @override
  Future<String?> getPinHash() async {
    return await secureStorage.getPinHash();
  }
}
