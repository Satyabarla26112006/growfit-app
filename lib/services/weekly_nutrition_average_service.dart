import 'daily_history_service.dart';

class WeeklyNutritionAverageService {
  WeeklyNutritionAverageService._();

  static DateTime _weekStart(DateTime date) {
    final day = DateTime(
      date.year,
      date.month,
      date.day,
    );

    return day.subtract(
      Duration(days: day.weekday - 1),
    );
  }

  static int _foodDays(DateTime week) {
    final start = _weekStart(week);

    int count = 0;

    for (int i = 0; i < 7; i++) {
      final date = start.add(
        Duration(days: i),
      );

      if (DailyHistoryService.hasFoodForDate(
        date,
      )) {
        count++;
      }
    }

    return count;
  }

  static double calories(DateTime week) {
    final days = _foodDays(week);

    if (days == 0) {
      return 0;
    }

    final start = _weekStart(week);

    double total = 0;

    for (int i = 0; i < 7; i++) {
      total += DailyHistoryService.caloriesForDate(
        start.add(Duration(days: i)),
      );
    }

    return total / days;
  }

  static double protein(DateTime week) {
    final days = _foodDays(week);

    if (days == 0) {
      return 0;
    }

    final start = _weekStart(week);

    double total = 0;

    for (int i = 0; i < 7; i++) {
      total += DailyHistoryService.proteinForDate(
        start.add(Duration(days: i)),
      );
    }

    return total / days;
  }

  static double carbs(DateTime week) {
    final days = _foodDays(week);

    if (days == 0) {
      return 0;
    }

    final start = _weekStart(week);

    double total = 0;

    for (int i = 0; i < 7; i++) {
      total += DailyHistoryService.carbsForDate(
        start.add(Duration(days: i)),
      );
    }

    return total / days;
  }

  static double fats(DateTime week) {
    final days = _foodDays(week);

    if (days == 0) {
      return 0;
    }

    final start = _weekStart(week);

    double total = 0;

    for (int i = 0; i < 7; i++) {
      total += DailyHistoryService.fatsForDate(
        start.add(Duration(days: i)),
      );
    }

    return total / days;
  }
}