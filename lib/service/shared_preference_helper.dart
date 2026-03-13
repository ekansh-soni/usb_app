import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Singleton Pattern
  static final SharedPreferencesHelper _instance =
  SharedPreferencesHelper._internal();

  factory SharedPreferencesHelper() => _instance;

  SharedPreferencesHelper._internal();

  SharedPreferences? _preferences;

  // Initialize SharedPreferences instance
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save a String value
  Future<void> setString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  // Get a String value
  String? getString(String key) {
    return _preferences?.getString(key);
  }

  // Save an Integer value
  Future<void> setInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  // Get an Integer value
  int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  // Save a Boolean value
  Future<void> setBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  // Get a Boolean value
  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  // Save a Double value
  Future<void> setDouble(String key, double value) async {
    await _preferences?.setDouble(key, value);
  }

  // Get a Double value
  double? getDouble(String key) {
    return _preferences?.getDouble(key);
  }

  // Save a List of Strings
  Future<void> setStringList(String key, List<String> value) async {
    await _preferences?.setStringList(key, value);
  }

  // Get a List of Strings
  List<String>? getStringList(String key) {
    return _preferences?.getStringList(key);
  }

  // Remove a specific key
  Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  // Clear all preferences
  Future<void> clear() async {
    await _preferences?.clear();
  }

  // Check if a key exists
  bool containsKey(String key) {
    return _preferences?.containsKey(key) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    await _preferences?.setBool('isLoggedIn', value);
  }

  bool? isLoggedIn() {
    return _preferences?.getBool('isLoggedIn') ?? false;
  }
}