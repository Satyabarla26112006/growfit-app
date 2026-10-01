import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global GrowFit appearance controller.
///
/// The default remains ThemeMode.system until the user chooses
/// Light or Dark in Profile. The selected mode is persisted locally.
class AppThemeController extends ChangeNotifier {
  AppThemeController._();

  static final AppThemeController instance = AppThemeController._();

  static const String _storageKey = 'growfit_theme_mode';

  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_storageKey);

    switch (value) {
      case 'light':
        _mode = ThemeMode.light;
        break;
      case 'dark':
        _mode = ThemeMode.dark;
        break;
      default:
        _mode = ThemeMode.system;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) {
      return;
    }

    _mode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    switch (mode) {
      case ThemeMode.light:
        await prefs.setString(_storageKey, 'light');
        break;
      case ThemeMode.dark:
        await prefs.setString(_storageKey, 'dark');
        break;
      case ThemeMode.system:
        await prefs.remove(_storageKey);
        break;
    }
  }
}
