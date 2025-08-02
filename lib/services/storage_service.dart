import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../models/user_model.dart';

class StorageService {
  static SharedPreferences? _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call StorageService.init() first.');
    }
    return _prefs!;
  }
  
  // Auth Token
  static Future<void> saveAuthToken(String token) async {
    await prefs.setString(Constants.authTokenKey, token);
    await prefs.setBool(Constants.isLoggedInKey, true);
  }
  
  static String? getAuthToken() {
    return prefs.getString(Constants.authTokenKey);
  }
  
  static Future<void> clearAuthToken() async {
    await prefs.remove(Constants.authTokenKey);
    await prefs.setBool(Constants.isLoggedInKey, false);
  }
  
  // User Data
  static Future<void> saveUserData(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(Constants.userDataKey, userJson);
  }
  
  static UserModel? getUserData() {
    final userJson = prefs.getString(Constants.userDataKey);
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
  
  static Future<void> clearUserData() async {
    await prefs.remove(Constants.userDataKey);
  }
  
  // Login Status
  static bool isLoggedIn() {
    return prefs.getBool(Constants.isLoggedInKey) ?? false;
  }
  
  static Future<void> setLoggedIn(bool status) async {
    await prefs.setBool(Constants.isLoggedInKey, status);
  }
  
  // Clear All Auth Data
  static Future<void> clearAuth() async {
    await Future.wait([
      clearAuthToken(),
      clearUserData(),
      setLoggedIn(false),
    ]);
  }
  
  // Generic String Storage
  static Future<void> saveString(String key, String value) async {
    await prefs.setString(key, value);
  }
  
  static String? getString(String key) {
    return prefs.getString(key);
  }
  
  static Future<void> removeString(String key) async {
    await prefs.remove(key);
  }
  
  // Generic Bool Storage
  static Future<void> saveBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }
  
  static bool? getBool(String key) {
    return prefs.getBool(key);
  }
  
  static Future<void> removeBool(String key) async {
    await prefs.remove(key);
  }
  
  // Generic Int Storage
  static Future<void> saveInt(String key, int value) async {
    await prefs.setInt(key, value);
  }
  
  static int? getInt(String key) {
    return prefs.getInt(key);
  }
  
  static Future<void> removeInt(String key) async {
    await prefs.remove(key);
  }
  
  // Generic Double Storage
  static Future<void> saveDouble(String key, double value) async {
    await prefs.setDouble(key, value);
  }
  
  static double? getDouble(String key) {
    return prefs.getDouble(key);
  }
  
  static Future<void> removeDouble(String key) async {
    await prefs.remove(key);
  }
  
  // Generic List Storage
  static Future<void> saveStringList(String key, List<String> value) async {
    await prefs.setStringList(key, value);
  }
  
  static List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }
  
  static Future<void> removeStringList(String key) async {
    await prefs.remove(key);
  }
  
  // Clear All Data
  static Future<void> clearAll() async {
    await prefs.clear();
  }
  
  // Check if key exists
  static bool containsKey(String key) {
    return prefs.containsKey(key);
  }
  
  // Get all keys
  static Set<String> getAllKeys() {
    return prefs.getKeys();
  }
}
