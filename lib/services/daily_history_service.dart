import '../models/food_log_model.dart';
import 'attendance_service.dart';
import 'food_log_service.dart';

class DailyHistoryService {
  DailyHistoryService._();

  // ============================================================
  // AVAILABLE DATES
  // ============================================================

  static List<String>
      getAvailableDates() {
    final dates =
        <String>{};

    for (final log
        in FoodLogService
            .allLogs) {
      dates.add(log.date);
    }

    final result =
        dates.toList();

    result.sort(
      (a, b) =>
          b.compareTo(a),
    );

    return result;
  }

  // ============================================================
  // LOGS FOR DATE
  // ============================================================

  static List<FoodLogModel>
      getLogsForDate(
    DateTime date,
  ) {
    return FoodLogService
        .getLogsForDate(
      date,
    );
  }

  // ============================================================
  // LOGS FOR DATE KEY
  // ============================================================

  static List<FoodLogModel>
      getLogsForDateKey(
    String date,
  ) {
    return FoodLogService
        .allLogs
        .where(
          (log) =>
              log.date == date,
        )
        .toList();
  }

  // ============================================================
  // CALORIES
  // ============================================================

  static double caloriesForDate(
    DateTime date,
  ) {
    return getLogsForDate(date)
        .fold(
      0.0,
      (total, log) =>
          total +
          log.calories,
    );
  }

  // ============================================================
  // PROTEIN
  // ============================================================

  static double proteinForDate(
    DateTime date,
  ) {
    return getLogsForDate(date)
        .fold(
      0.0,
      (total, log) =>
          total +
          log.protein,
    );
  }

  // ============================================================
  // CARBS
  // ============================================================

  static double carbsForDate(
    DateTime date,
  ) {
    return getLogsForDate(date)
        .fold(
      0.0,
      (total, log) =>
          total +
          log.carbs,
    );
  }

  // ============================================================
  // FATS
  // ============================================================

  static double fatsForDate(
    DateTime date,
  ) {
    return getLogsForDate(date)
        .fold(
      0.0,
      (total, log) =>
          total +
          log.fats,
    );
  }

  // ============================================================
  // FIBER
  // ============================================================

  static double fiberForDate(
    DateTime date,
  ) {
    return getLogsForDate(date)
        .fold(
      0.0,
      (total, log) =>
          total +
          log.fiber,
    );
  }
    // ============================================================
  // SUGAR
  // ============================================================

  static double sugarForDate(
    DateTime date,
  ) {
    return getLogsForDate(date)
        .fold(
      0.0,
      (total, log) =>
          total +
          log.sugar,
    );
  }

  // ============================================================
  // HAS FOOD
  // ============================================================

  static bool hasFoodForDate(
    DateTime date,
  ) {
    return getLogsForDate(
      date,
    ).isNotEmpty;
  }

  // ============================================================
  // FOOD COUNT
  // ============================================================

  static int foodCountForDate(
    DateTime date,
  ) {
    return getLogsForDate(
      date,
    ).length;
  }

  // ============================================================
  // ATTENDANCE
  // ============================================================

  static bool isAttendanceMarked(
    DateTime date,
  ) {
    return AttendanceService
        .isPresent(date);
  }

  static int get attendanceCount {
    return AttendanceService
        .attendanceCount;
  }

  static int get currentStreak {
    return AttendanceService
        .currentStreak;
  }

  static int get longestStreak {
    return AttendanceService
        .longestStreak;
  }

  // ============================================================
  // DATE KEY
  // ============================================================

  static String dateKey(
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

  static DateTime?
      parseDateKey(
    String value,
  ) {
    return AttendanceService
        .parseDateKey(value);
  }
}