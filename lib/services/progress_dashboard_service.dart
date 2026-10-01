import 'attendance_service.dart';
import 'daily_history_service.dart';

class ProgressDashboardService {
  ProgressDashboardService._();

  // ============================================================
  // TODAY
  // ============================================================

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

  static int attendanceDays() {
    return AttendanceService.attendanceCount;
  }

  static bool attendedToday() {
    return AttendanceService.isPresent(
      DateTime.now(),
    );
  }

  // ============================================================
  // FOOD HISTORY
  // ============================================================

  static int foodDays() {
    return DailyHistoryService
        .getAvailableDates()
        .length;
  }

  static bool hasFoodToday() {
    return DailyHistoryService.hasFoodForDate(
      DateTime.now(),
    );
  }

  // ============================================================
  // DAILY STATUS
  // ============================================================

  static bool hasActivityToday() {
    return attendedToday() ||
        hasFoodToday();
  }
}