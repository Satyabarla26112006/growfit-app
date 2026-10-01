import 'attendance_service.dart';
import 'daily_history_service.dart';

class FinalProgressService {
  FinalProgressService._();

  // ============================================================
  // TODAY
  // ============================================================

  static bool isTodayActive() {
    final today = DateTime.now();

    return AttendanceService.isPresent(today) ||
        DailyHistoryService.hasFoodForDate(
          today,
        );
  }

  static int todayFoodCount() {
    return DailyHistoryService.foodCountForDate(
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

  static int totalAttendance() {
    return AttendanceService.attendanceCount;
  }

  static bool attendedToday() {
    return AttendanceService.isPresent(
      DateTime.now(),
    );
  }

  // ============================================================
  // HISTORY
  // ============================================================

  static int totalFoodDays() {
    return DailyHistoryService
        .getAvailableDates()
        .length;
  }

  static bool hasHistory() {
    return totalFoodDays() > 0 ||
        totalAttendance() > 0;
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  static String summaryText() {
    if (!hasHistory()) {
      return 'Start logging your progress today.';
    }

    final days = totalAttendance();
    final streak = currentStreak();

    return '$days attendance days • '
        '$streak day streak';
  }
}