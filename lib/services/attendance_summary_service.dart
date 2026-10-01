import 'attendance_service.dart';
import 'daily_history_service.dart';

class AttendanceSummaryService {
  AttendanceSummaryService._();

  static int get currentStreak {
    return AttendanceService.currentStreak;
  }

  static int get longestStreak {
    return AttendanceService.longestStreak;
  }

  static int get completedDays {
    return AttendanceService.attendanceCount;
  }

  static bool completedToday() {
    return AttendanceService.isPresent(
      DateTime.now(),
    );
  }

  static int foodDays() {
    return DailyHistoryService
        .getAvailableDates()
        .length;
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
}