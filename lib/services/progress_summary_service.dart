import 'attendance_service.dart';
import 'daily_completion_service.dart';
import 'daily_history_service.dart';

class ProgressSummaryService {
  ProgressSummaryService._();

  // ============================================================
  // TODAY
  // ============================================================

  static bool todayComplete() {
    return DailyCompletionService.isCompleted(
      DateTime.now(),
    );
  }

  static double todayCompletion() {
    return DailyCompletionService.percentage(
      DateTime.now(),
    );
  }

  static double todayCalories() {
    return DailyHistoryService.caloriesForDate(
      DateTime.now(),
    );
  }

  static double todayProtein() {
    return DailyHistoryService.proteinForDate(
      DateTime.now(),
    );
  }

  static double todayCarbs() {
    return DailyHistoryService.carbsForDate(
      DateTime.now(),
    );
  }

  static double todayFats() {
    return DailyHistoryService.fatsForDate(
      DateTime.now(),
    );
  }

  // ============================================================
  // ATTENDANCE
  // ============================================================

  static int currentStreak() {
    return AttendanceService.currentStreak;
  }

  static int longestStreak() {
    return AttendanceService.longestStreak;
  }

  static int totalAttendanceDays() {
    return AttendanceService.attendanceCount;
  }

  static bool attendedToday() {
    return AttendanceService.isPresent(
      DateTime.now(),
    );
  }

  // ============================================================
  // WEEK
  // ============================================================

  static DateTime _weekStart(
    DateTime date,
  ) {
    final day = DateTime(
      date.year,
      date.month,
      date.day,
    );

    return day.subtract(
      Duration(
        days: day.weekday - 1,
      ),
    );
  }

  static int weeklyActiveDays() {
    final start = _weekStart(
      DateTime.now(),
    );

    int count = 0;

    for (int i = 0; i < 7; i++) {
      final date = start.add(
        Duration(days: i),
      );

      final attendance =
          AttendanceService.isPresent(
        date,
      );

      final food =
          DailyHistoryService
              .hasFoodForDate(
        date,
      );

      if (attendance || food) {
        count++;
      }
    }

    return count;
  }

  static int weeklyAttendanceDays() {
    final start = _weekStart(
      DateTime.now(),
    );

    int count = 0;

    for (int i = 0; i < 7; i++) {
      final date = start.add(
        Duration(days: i),
      );

      if (AttendanceService.isPresent(
        date,
      )) {
        count++;
      }
    }

    return count;
  }

  static int weeklyFoodDays() {
    final start = _weekStart(
      DateTime.now(),
    );

    int count = 0;

    for (int i = 0; i < 7; i++) {
      final date = start.add(
        Duration(days: i),
      );

      if (DailyHistoryService
          .hasFoodForDate(date)) {
        count++;
      }
    }

    return count;
  }

  static double weeklyCompletion() {
    return weeklyActiveDays() / 7;
  }

  static double weeklyCalories() {
    final start = _weekStart(
      DateTime.now(),
    );

    double total = 0;

    for (int i = 0; i < 7; i++) {
      final date = start.add(
        Duration(days: i),
      );

      total +=
          DailyHistoryService
              .caloriesForDate(
        date,
      );
    }

    return total;
  }

  // ============================================================
  // DISPLAY
  // ============================================================

  static String percentageText(
    double value,
  ) {
    final percentage =
        (value * 100).round();

    return '$percentage%';
  }
}