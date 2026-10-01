import 'package:flutter/material.dart';

/// GrowFit 2.0 semantic color system.
///
/// Keep screen-level colors out of individual widgets whenever a theme token
/// can express the intent. The static AppColors API is retained for existing
/// screens that still reference AppColors directly.
class AppColors {
  AppColors._();

  // ============================================================
  // LIGHT PALETTE
  // ============================================================

  static const Color lightBackground = Color(0xFFFFF9F2);
  static const Color lightSurface = Color(0xFFFFF3EA);
  static const Color lightSurfaceElevated = Color(0xFFFFEDE2);
  static const Color lightPrimary = Color(0xFF18A999);
  static const Color lightPrimaryStrong = Color(0xFF087F73);
  static const Color lightSecondary = Color(0xFF6D5DFB);
  static const Color lightSuccess = Color(0xFF167A4A);
  static const Color lightWarning = Color(0xFFE09A2D);
  static const Color lightError = Color(0xFFD9534F);
  static const Color lightPremium = Color(0xFFC8A45D);
  static const Color lightTextPrimary = Color(0xFF17342F);
  static const Color lightTextSecondary = Color(0xFF60746F);
  static const Color lightBorder = Color(0xFFE8DCD2);

  // ============================================================
  // DARK PALETTE
  // ============================================================

  static const Color darkBackground = Color(0xFF07111F);
  static const Color darkSurface = Color(0xFF0C1A2B);
  static const Color darkSurfaceElevated = Color(0xFF12243A);
  static const Color darkPrimary = Color(0xFF42D7C6);
  static const Color darkPrimaryStrong = Color(0xFF24B5A5);
  static const Color darkSecondary = Color(0xFF8B6CFF);
  static const Color darkSuccess = Color(0xFF43C77A);
  static const Color darkWarning = Color(0xFFF4B85A);
  static const Color darkError = Color(0xFFFF746E);
  static const Color darkPremium = Color(0xFFD7B66A);
  static const Color darkTextPrimary = Color(0xFFF4FBF8);
  static const Color darkTextSecondary = Color(0xFF9FB3AD);
  static const Color darkBorder = Color(0xFF20364E);

  // ============================================================
  // SHARED / SEMANTIC
  // ============================================================

  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static const Color protein = Color(0xFF8B6CFF);
  static const Color carbs = Color(0xFFF0A44B);
  static const Color fats = Color(0xFF30B9D6);
  static const Color fiber = Color(0xFF5DBB73);
  static const Color calories = Color(0xFFE99A3D);

  // ============================================================
  // LEGACY DEFAULT ALIASES
  // ============================================================
  //
  // These aliases preserve compatibility with older screens. New code
  // should prefer Theme.of(context).colorScheme.* so both modes work
  // automatically.

  static const Color background = darkBackground;
  static const Color surface = darkSurface;
  static const Color surfaceLight = darkSurfaceElevated;
  static const Color primary = darkPrimary;
  static const Color primaryDark = darkPrimaryStrong;
  static const Color secondary = darkSecondary;
  static const Color success = darkSuccess;
  static const Color warning = darkWarning;
  static const Color error = darkError;
  static const Color premium = darkPremium;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color border = darkBorder;
}
