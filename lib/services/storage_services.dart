import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  static const String _settingsKey = 'app_settings';

  SharedPreferences? _prefs;

  // Initialize shared preferences
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Ensure preferences are initialized
  Future<SharedPreferences> get _preferences async {
    if (_prefs == null) {
      await initialize();
    }
    return _prefs!;
  }

  // ===================
  // Authentication Data
  // ===================

  // Save authentication token
  Future<bool> saveToken(String token) async {
    final prefs = await _preferences;
    return await prefs.setString(_tokenKey, token);
  }

  // Get authentication token
  Future<String?> getToken() async {
    final prefs = await _preferences;
    return prefs.getString(_tokenKey);
  }

  // Remove authentication token
  Future<bool> removeToken() async {
    final prefs = await _preferences;
    return await prefs.remove(_tokenKey);
  }

  // Save user data
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await _preferences;
    final userDataJson = json.encode(userData);
    return await prefs.setString(_userDataKey, userDataJson);
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await _preferences;
    final userDataJson = prefs.getString(_userDataKey);

    if (userDataJson != null && userDataJson.isNotEmpty) {
      try {
        return json.decode(userDataJson) as Map<String, dynamic>;
      } catch (e) {
        print('Error parsing user data: $e');
        return null;
      }
    }
    return null;
  }

  // Remove user data
  Future<bool> removeUserData() async {
    final prefs = await _preferences;
    return await prefs.remove(_userDataKey);
  }

  // ===================
  // App Settings
  // ===================

  // Save app settings
  Future<bool> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await _preferences;
    final settingsJson = json.encode(settings);
    return await prefs.setString(_settingsKey, settingsJson);
  }

  // Get app settings
  Future<Map<String, dynamic>?> getSettings() async {
    final prefs = await _preferences;
    final settingsJson = prefs.getString(_settingsKey);

    if (settingsJson != null && settingsJson.isNotEmpty) {
      try {
        return json.decode(settingsJson) as Map<String, dynamic>;
      } catch (e) {
        print('Error parsing settings: $e');
        return null;
      }
    }
    return null;
  }

  // ===================
  // Generic Methods
  // ===================

  // Save string value
  Future<bool> saveString(String key, String value) async {
    final prefs = await _preferences;
    return await prefs.setString(key, value);
  }

  // Get string value
  Future<String?> getString(String key) async {
    final prefs = await _preferences;
    return prefs.getString(key);
  }

  // Save boolean value
  Future<bool> saveBool(String key, bool value) async {
    final prefs = await _preferences;
    return await prefs.setBool(key, value);
  }

  // Get boolean value
  Future<bool?> getBool(String key) async {
    final prefs = await _preferences;
    return prefs.getBool(key);
  }

  // Save integer value
  Future<bool> saveInt(String key, int value) async {
    final prefs = await _preferences;
    return await prefs.setInt(key, value);
  }

  // Get integer value
  Future<int?> getInt(String key) async {
    final prefs = await _preferences;
    return prefs.getInt(key);
  }

  // Save double value
  Future<bool> saveDouble(String key, double value) async {
    final prefs = await _preferences;
    return await prefs.setDouble(key, value);
  }

  // Get double value
  Future<double?> getDouble(String key) async {
    final prefs = await _preferences;
    return prefs.getDouble(key);
  }

  // Save list of strings
  Future<bool> saveStringList(String key, List<String> value) async {
    final prefs = await _preferences;
    return await prefs.setStringList(key, value);
  }

  // Get list of strings
  Future<List<String>?> getStringList(String key) async {
    final prefs = await _preferences;
    return prefs.getStringList(key);
  }

  // Remove specific key
  Future<bool> remove(String key) async {
    final prefs = await _preferences;
    return await prefs.remove(key);
  }

  // Check if key exists
  Future<bool> containsKey(String key) async {
    final prefs = await _preferences;
    return prefs.containsKey(key);
  }

  // Get all keys
  Future<Set<String>> getAllKeys() async {
    final prefs = await _preferences;
    return prefs.getKeys();
  }

  // Clear all data
  Future<bool> clearAll() async {
    final prefs = await _preferences;
    return await prefs.clear();
  }

  // ===================
  // Utility Methods
  // ===================

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final userData = await getUserData();
    return token != null && userData != null;
  }

  // Save JSON object
  Future<bool> saveJson(String key, Map<String, dynamic> data) async {
    final jsonString = json.encode(data);
    return await saveString(key, jsonString);
  }

  // Get JSON object
  Future<Map<String, dynamic>?> getJson(String key) async {
    final jsonString = await getString(key);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        return json.decode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        print('Error parsing JSON for key $key: $e');
        return null;
      }
    }
    return null;
  }
}
