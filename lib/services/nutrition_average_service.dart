import 'daily_history_service.dart';

class NutritionAverageService {
  NutritionAverageService._();

  static int _daysWithFood(DateTime month) {
    final days = DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    int count = 0;

    for (int day = 1; day <= days; day++) {
      if (DailyHistoryService.hasFoodForDate(
        DateTime(
          month.year,
          month.month,
          day,
        ),
      )) {
        count++;
      }
    }

    return count;
  }

  static double calories(DateTime month) {
    final days = _daysWithFood(month);

    if (days == 0) {
      return 0;
    }

    double total = 0;

    for (int day = 1;
        day <=
            DateTime(
              month.year,
              month.month + 1,
              0,
            ).day;
        day++) {
      total += DailyHistoryService
          .caloriesForDate(
        DateTime(
          month.year,
          month.month,
          day,
        ),
      );
    }

    return total / days;
  }

  static double protein(DateTime month) {
    final days = _daysWithFood(month);

    if (days == 0) {
      return 0;
    }

    double total = 0;

    for (int day = 1;
        day <=
            DateTime(
              month.year,
              month.month + 1,
              0,
            ).day;
        day++) {
      total += DailyHistoryService
          .proteinForDate(
        DateTime(
          month.year,
          month.month,
          day,
        ),
      );
    }

    return total / days;
  }

  static double carbs(DateTime month) {
    final days = _daysWithFood(month);

    if (days == 0) {
      return 0;
    }

    double total = 0;

    for (int day = 1;
        day <=
            DateTime(
              month.year,
              month.month + 1,
              0,
            ).day;
        day++) {
      total += DailyHistoryService
          .carbsForDate(
        DateTime(
          month.year,
          month.month,
          day,
        ),
      );
    }

    return total / days;
  }

  static double fats(DateTime month) {
    final days = _daysWithFood(month);

    if (days == 0) {
      return 0;
    }

    double total = 0;

    for (int day = 1;
        day <=
            DateTime(
              month.year,
              month.month + 1,
              0,
            ).day;
        day++) {
      total += DailyHistoryService
          .fatsForDate(
        DateTime(
          month.year,
          month.month,
          day,
        ),
      );
    }

    return total / days;
  }
}