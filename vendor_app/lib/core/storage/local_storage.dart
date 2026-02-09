import 'package:shared_preferences/shared_preferences.dart';

/// Local storage for non-sensitive data (preferences, settings).
abstract interface class LocalStorage {
  Future<bool> setString(String key, String value);
  Future<String?> getString(String key);
  Future<bool> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<bool> setInt(String key, int value);
  Future<int?> getInt(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
  Future<bool> containsKey(String key);
}

/// Default implementation using [SharedPreferences].
class LocalStorageImpl implements LocalStorage {
  LocalStorageImpl([SharedPreferences? prefs]) : _prefs = prefs;

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<bool> setString(String key, String value) async {
    final prefs = await _instance;
    return prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    final prefs = await _instance;
    return prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    final prefs = await _instance;
    return prefs.getBool(key);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    final prefs = await _instance;
    return prefs.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    final prefs = await _instance;
    return prefs.getInt(key);
  }

  @override
  Future<bool> remove(String key) async {
    final prefs = await _instance;
    return prefs.remove(key);
  }

  @override
  Future<bool> clear() async {
    final prefs = await _instance;
    return prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    final prefs = await _instance;
    return prefs.containsKey(key);
  }
}
