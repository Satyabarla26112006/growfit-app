import 'attendance_service.dart';
import 'daily_history_service.dart';

class OverallProgressService {
  OverallProgressService._();

  static int totalFoodDays() {
    return DailyHistoryService
        .getAvailableDates()
        .length;
  }

  static int totalAttendanceDays() {
    return AttendanceService.attendanceCount;
  }

  static int currentStreak() {
    return AttendanceService.currentStreak;
  }

  static int longestStreak() {
    return AttendanceService.longestStreak;
  }

  static double totalCalories() {
    double total = 0;

    for (final dateKey
        in DailyHistoryService
            .getAvailableDates()) {
      final date =
          DailyHistoryService.parseDateKey(
        dateKey,
      );

      if (date == null) {
        continue;
      }

      total += DailyHistoryService
          .caloriesForDate(date);
    }

    return total;
  }

  static double totalProtein() {
    double total = 0;

    for (final dateKey
        in DailyHistoryService
            .getAvailableDates()) {
      final date =
          DailyHistoryService.parseDateKey(
        dateKey,
      );

      if (date == null) {
        continue;
      }

      total += DailyHistoryService
          .proteinForDate(date);
    }

    return total;
  }

  static double totalCarbs() {
    double total = 0;

    for (final dateKey
        in DailyHistoryService
            .getAvailableDates()) {
      final date =
          DailyHistoryService.parseDateKey(
        dateKey,
      );

      if (date == null) {
        continue;
      }

      total += DailyHistoryService
          .carbsForDate(date);
    }

    return total;
  }

  static double totalFats() {
    double total = 0;

    for (final dateKey
        in DailyHistoryService
            .getAvailableDates()) {
      final date =
          DailyHistoryService.parseDateKey(
        dateKey,
      );

      if (date == null) {
        continue;
      }

      total += DailyHistoryService
          .fatsForDate(date);
    }

    return total;
  }

  static bool hasProgress() {
    return totalFoodDays() > 0 ||
        totalAttendanceDays() > 0;
  }
}