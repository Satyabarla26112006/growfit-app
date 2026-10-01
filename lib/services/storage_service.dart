import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();

  static SharedPreferences? _preferences;

  // ============================================================
  // INITIALIZE
  // ============================================================

  static Future<void> init() async {
    _preferences ??=
        await SharedPreferences.getInstance();
  }

  static SharedPreferences get _prefs {
    if (_preferences == null) {
      throw StateError(
        'StorageService.init() must be called before using StorageService.',
      );
    }

    return _preferences!;
  }

  // ============================================================
  // USER PROFILE
  // ============================================================

  static const String userProfileKey =
      'growfit_user_profile';

  static Future<void> saveUserProfile(
    Map<String, dynamic> data,
  ) async {
    await _prefs.setString(
      userProfileKey,
      jsonEncode(data),
    );
  }

  static Map<String, dynamic>? getUserProfile() {
    final value = _prefs.getString(
      userProfileKey,
    );

    if (value == null || value.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(value);

      if (decoded is Map) {
        return Map<String, dynamic>.from(
          decoded,
        );
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // PROFILE EXISTS
  // ============================================================

  static bool get hasUserProfile {
    return _prefs.containsKey(userProfileKey);
  }

  // ============================================================
  // REMOVE USER PROFILE
  // ============================================================

  static Future<void> clearUserProfile() async {
    await _prefs.remove(userProfileKey);
  }

  // ============================================================
  // GENERIC STRING
  // ============================================================

  static Future<void> saveString(
    String key,
    String value,
  ) async {
    await _prefs.setString(
      key,
      value,
    );
  }

  static String? getString(
    String key,
  ) {
    return _prefs.getString(key);
  }

  // ============================================================
  // GENERIC DOUBLE
  // ============================================================

  static Future<void> saveDouble(
    String key,
    double value,
  ) async {
    await _prefs.setDouble(
      key,
      value,
    );
  }

  static double? getDouble(
    String key,
  ) {
    return _prefs.getDouble(key);
  }

  // ============================================================
  // GENERIC INTEGER
  // ============================================================

  static Future<void> saveInt(
    String key,
    int value,
  ) async {
    await _prefs.setInt(
      key,
      value,
    );
  }

  static int? getInt(
    String key,
  ) {
    return _prefs.getInt(key);
  }

  // ============================================================
  // GENERIC BOOLEAN
  // ============================================================

  static Future<void> saveBool(
    String key,
    bool value,
  ) async {
    await _prefs.setBool(
      key,
      value,
    );
  }

  static bool? getBool(
    String key,
  ) {
    return _prefs.getBool(key);
  }

  // ============================================================
  // REMOVE VALUE
  // ============================================================

  static Future<void> remove(
    String key,
  ) async {
    await _prefs.remove(key);
  }

  // ============================================================
  // CLEAR EVERYTHING
  // ============================================================

  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}