import 'daily_history_service.dart';

class WeeklyNutritionService {
  WeeklyNutritionService._();

  static DateTime _dateOnly(
    DateTime date,
  ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  static DateTime _mondayOfWeek(
    DateTime date,
  ) {
    final day = _dateOnly(date);

    return day.subtract(
      Duration(days: day.weekday - 1),
    );
  }

  static double calories(
    DateTime weekDate,
  ) {
    final monday =
        _mondayOfWeek(weekDate);

    double total = 0;

    for (int i = 0; i < 7; i++) {
      final date = monday.add(
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

  static double protein(
    DateTime weekDate,
  ) {
    final monday =
        _mondayOfWeek(weekDate);

    double total = 0;

    for (int i = 0; i < 7; i++) {
      final date = monday.add(
        Duration(days: i),
      );

      total +=
          DailyHistoryService
              .proteinForDate(
        date,
      );
    }

    return total;
  }

  static double carbs(
    DateTime weekDate,
  ) {
    final monday =
        _mondayOfWeek(weekDate);

    double total = 0;

    for (int i = 0; i < 7; i++) {
      final date = monday.add(
        Duration(days: i),
      );

      total +=
          DailyHistoryService
              .carbsForDate(
        date,
      );
    }

    return total;
  }

  static double fats(
    DateTime weekDate,
  ) {
    final monday =
        _mondayOfWeek(weekDate);

    double total = 0;

    for (int i = 0; i < 7; i++) {
      final date = monday.add(
        Duration(days: i),
      );

      total +=
          DailyHistoryService
              .fatsForDate(
        date,
      );
    }

    return total;
  }

  static int foodDays(
    DateTime weekDate,
  ) {
    final monday =
        _mondayOfWeek(weekDate);

    int count = 0;

    for (int i = 0; i < 7; i++) {
      final date = monday.add(
        Duration(days: i),
      );

      if (DailyHistoryService
          .hasFoodForDate(date)) {
        count++;
      }
    }

    return count;
  }
}