import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/food_log_model.dart';
import 'attendance_service.dart';
import 'daily_nutrition_service.dart';

class FoodLogService {
  FoodLogService._();

  // ============================================================
  // STORAGE
  // ============================================================

  static final List<FoodLogModel> _logs = [];

  static bool _initialized = false;
  static Future<void>? _initialization;

  static const String _storageKey =
      'growfit_food_logs';

  // ============================================================
  // INITIALIZE
  // ============================================================

  static Future<void> initialize() {
    return _initialization ??=
        _loadLogs();
  }

  static Future<void> _loadLogs() async {
    if (_initialized) {
      return;
    }

    final prefs =
        await SharedPreferences.getInstance();

    final savedLogs =
        prefs.getStringList(
      _storageKey,
    );

    _logs.clear();

    if (savedLogs != null) {
      for (final value in savedLogs) {
        try {
          final decoded =
              jsonDecode(value);

          if (decoded
              is Map<String, dynamic>) {
            _logs.add(
              FoodLogModel.fromJson(
                decoded,
              ),
            );
          }
        } catch (_) {
          // Ignore invalid saved log.
        }
      }
    }

    _initialized = true;
  }

  // ============================================================
  // SAVE
  // ============================================================

  static Future<void> _saveLogs() async {
    final prefs =
        await SharedPreferences.getInstance();

    final values = _logs
        .map(
          (log) => jsonEncode(
            log.toJson(),
          ),
        )
        .toList();

    await prefs.setStringList(
      _storageKey,
      values,
    );
  }

  // ============================================================
  // ALL LOGS
  // ============================================================

  static List<FoodLogModel> get allLogs {
    return List.unmodifiable(
      _logs,
    );
  }

  // ============================================================
  // ADD LOG
  // ============================================================

  static void addLog(
    FoodLogModel log,
  ) {
    _logs.add(log);

    // Food logging marks the date
    // as an attended day.
    unawaited(
      AttendanceService.markDatePresent(
        _parseDate(log.date),
      ),
    );

    unawaited(
      _saveLogs(),
    );
  }

  // ============================================================
  // TODAY
  // ============================================================

  static List<FoodLogModel>
      getTodayLogs() {
    return getLogsForDate(
      DateTime.now(),
    );
  }

  // ============================================================
  // LOGS FOR DATE
  // ============================================================

  static List<FoodLogModel>
      getLogsForDate(
    DateTime date,
  ) {
    final key =
        _dateKey(date);

    return _logs
        .where(
          (log) => log.date == key,
        )
        .toList();
  }

  // ============================================================
  // BREAKFAST
  // ============================================================

  static List<FoodLogModel>
      getBreakfastLogs() {
    return getTodayLogs()
        .where(
          (log) =>
              log.mealType
                  .toLowerCase() ==
              'breakfast',
        )
        .toList();
  }

  // ============================================================
  // LUNCH
  // ============================================================

  static List<FoodLogModel>
      getLunchLogs() {
    return getTodayLogs()
        .where(
          (log) =>
              log.mealType
                  .toLowerCase() ==
              'lunch',
        )
        .toList();
  }

  // ============================================================
  // DINNER
  // ============================================================

  static List<FoodLogModel>
      getDinnerLogs() {
    return getTodayLogs()
        .where(
          (log) =>
              log.mealType
                  .toLowerCase() ==
              'dinner',
        )
        .toList();
  }

  // ============================================================
  // SNACKS
  // ============================================================

  static List<FoodLogModel>
      getSnackLogs() {
    return getTodayLogs()
        .where(
          (log) {
            final meal =
                log.mealType
                    .toLowerCase();

            return meal == 'snack' ||
                meal == 'snacks';
          },
        )
        .toList();
  }

  // ============================================================
  // DELETE LOG
  // ============================================================

  static bool deleteLog(
    String id,
  ) {
    final index =
        _logs.indexWhere(
      (log) => log.id == id,
    );

    if (index == -1) {
      return false;
    }

    final log =
        _logs[index];

    // Remove nutrition contribution.
    DailyNutritionService
        .removeFoodLog(
      log,
    );

    _logs.removeAt(index);

    unawaited(
      _saveLogs(),
    );

    return true;
  }

  // ============================================================
  // UPDATE LOG
  // ============================================================

  static bool updateLog(
    FoodLogModel updatedLog,
  ) {
    final index =
        _logs.indexWhere(
      (log) =>
          log.id ==
          updatedLog.id,
    );

    if (index == -1) {
      return false;
    }

    _logs[index] =
        updatedLog;

    unawaited(
      _saveLogs(),
    );

    return true;
  }

  // ============================================================
  // FIND LOG
  // ============================================================

  static FoodLogModel?
      getLogById(
    String id,
  ) {
    for (final log in _logs) {
      if (log.id == id) {
        return log;
      }
    }

    return null;
  }

  // ============================================================
  // TODAY CALORIES
  // ============================================================

  static double get todayCalories {
    return getTodayLogs().fold(
      0.0,
      (total, log) =>
          total + log.calories,
    );
  }

  // ============================================================
  // TODAY PROTEIN
  // ============================================================

  static double get todayProtein {
    return getTodayLogs().fold(
      0.0,
      (total, log) =>
          total + log.protein,
    );
  }

  // ============================================================
  // TODAY CARBS
  // ============================================================

  static double get todayCarbs {
    return getTodayLogs().fold(
      0.0,
      (total, log) =>
          total + log.carbs,
    );
  }

  // ============================================================
  // TODAY FATS
  // ============================================================

  static double get todayFats {
    return getTodayLogs().fold(
      0.0,
      (total, log) =>
          total + log.fats,
    );
  }

  // ============================================================
  // TODAY FIBER
  // ============================================================

  static double get todayFiber {
    return getTodayLogs().fold(
      0.0,
      (total, log) =>
          total + log.fiber,
    );
  }

  // ============================================================
  // CLEAR ALL LOGS
  // ============================================================

  static void clearAll() {
    _logs.clear();

    unawaited(
      _saveLogs(),
    );
  }

  // ============================================================
  // DATE KEY
  // ============================================================

  static String _dateKey(
    DateTime date,
  ) {
    final year =
        date.year.toString();

    final month =
        date.month
            .toString()
            .padLeft(2, '0');

    final day =
        date.day
            .toString()
            .padLeft(2, '0');

    return '$year-$month-$day';
  }

  // ============================================================
  // PARSE DATE
  // ============================================================

  static DateTime _parseDate(
    String value,
  ) {
    return DateTime.tryParse(
          value,
        ) ??
        DateTime.now();
  }
}