import 'attendance_service.dart';
import 'daily_history_service.dart';

class DailyProgressService {
  DailyProgressService._();

  static bool hasAttendance(DateTime date) {
    return AttendanceService.isPresent(date);
  }

  static bool hasFood(DateTime date) {
    return DailyHistoryService.hasFoodForDate(
      date,
    );
  }

  static double calories(DateTime date) {
    return DailyHistoryService.caloriesForDate(
      date,
    );
  }

  static double protein(DateTime date) {
    return DailyHistoryService.proteinForDate(
      date,
    );
  }

  static double carbs(DateTime date) {
    return DailyHistoryService.carbsForDate(
      date,
    );
  }

  static double fats(DateTime date) {
    return DailyHistoryService.fatsForDate(
      date,
    );
  }

  static int foodCount(DateTime date) {
    return DailyHistoryService.foodCountForDate(
      date,
    );
  }

  static double completion(DateTime date) {
    int completed = 0;

    if (hasAttendance(date)) {
      completed++;
    }

    if (hasFood(date)) {
      completed++;
    }

    return completed / 2;
  }
}