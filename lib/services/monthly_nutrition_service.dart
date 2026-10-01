import 'daily_history_service.dart';

class MonthlyNutritionService {
  MonthlyNutritionService._();

  static DateTime _date(
    DateTime month,
    int day,
  ) {
    return DateTime(
      month.year,
      month.month,
      day,
    );
  }

  static int _days(DateTime month) {
    return DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;
  }

  static double calories(DateTime month) {
    double total = 0;

    for (int day = 1; day <= _days(month); day++) {
      total += DailyHistoryService.caloriesForDate(
        _date(month, day),
      );
    }

    return total;
  }

  static double protein(DateTime month) {
    double total = 0;

    for (int day = 1; day <= _days(month); day++) {
      total += DailyHistoryService.proteinForDate(
        _date(month, day),
      );
    }

    return total;
  }

  static double carbs(DateTime month) {
    double total = 0;

    for (int day = 1; day <= _days(month); day++) {
      total += DailyHistoryService.carbsForDate(
        _date(month, day),
      );
    }

    return total;
  }

  static double fats(DateTime month) {
    double total = 0;

    for (int day = 1; day <= _days(month); day++) {
      total += DailyHistoryService.fatsForDate(
        _date(month, day),
      );
    }

    return total;
  }

  static int foodDays(DateTime month) {
    int count = 0;

    for (int day = 1; day <= _days(month); day++) {
      if (DailyHistoryService.hasFoodForDate(
        _date(month, day),
      )) {
        count++;
      }
    }

    return count;
  }
}