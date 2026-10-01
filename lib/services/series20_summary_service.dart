import 'attendance_service.dart';
import 'daily_history_service.dart';

class Series20SummaryService {
  Series20SummaryService._();

  // ============================================================
  // ATTENDANCE
  // ============================================================

  static int attendanceDays() {
    return AttendanceService.attendanceCount;
  }

  static int currentStreak() {
    return AttendanceService.currentStreak;
  }

  static int longestStreak() {
    return AttendanceService.longestStreak;
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

  static int todayFoodCount() {
    return DailyHistoryService.foodCountForDate(
      DateTime.now(),
    );
  }

  // ============================================================
  // TODAY NUTRITION
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

  static double todayFiber() {
    return DailyHistoryService.fiberForDate(
      DateTime.now(),
    );
  }

  // ============================================================
  // TODAY STATUS
  // ============================================================

  static bool hasActivityToday() {
    return attendedToday() ||
        todayFoodCount() > 0;
  }

  static bool hasHistory() {
    return attendanceDays() > 0 ||
        foodDays() > 0;
  }

  // ============================================================
  // SERIES SUMMARY
  // ============================================================

  static Map<String, dynamic> summary() {
    return {
      'attendanceDays': attendanceDays(),
      'currentStreak': currentStreak(),
      'longestStreak': longestStreak(),
      'foodDays': foodDays(),
      'todayFoodCount': todayFoodCount(),
      'todayCalories': todayCalories(),
      'todayProtein': todayProtein(),
      'todayCarbs': todayCarbs(),
      'todayFats': todayFats(),
      'todayFiber': todayFiber(),
      'attendedToday': attendedToday(),
      'hasActivityToday': hasActivityToday(),
      'hasHistory': hasHistory(),
    };
  }
}