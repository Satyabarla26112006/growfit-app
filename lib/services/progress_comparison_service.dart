import 'daily_history_service.dart';

class ProgressComparisonService {
  ProgressComparisonService._();

  static DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  static DateTime previousDay(
    DateTime date,
  ) {
    return _dateOnly(date).subtract(
      const Duration(days: 1),
    );
  }

  static double caloriesDifference(
    DateTime date,
  ) {
    final current =
        DailyHistoryService.caloriesForDate(
      date,
    );

    final previous =
        DailyHistoryService.caloriesForDate(
      previousDay(date),
    );

    return current - previous;
  }

  static double proteinDifference(
    DateTime date,
  ) {
    final current =
        DailyHistoryService.proteinForDate(
      date,
    );

    final previous =
        DailyHistoryService.proteinForDate(
      previousDay(date),
    );

    return current - previous;
  }

  static double carbsDifference(
    DateTime date,
  ) {
    final current =
        DailyHistoryService.carbsForDate(
      date,
    );

    final previous =
        DailyHistoryService.carbsForDate(
      previousDay(date),
    );

    return current - previous;
  }

  static double fatsDifference(
    DateTime date,
  ) {
    final current =
        DailyHistoryService.fatsForDate(
      date,
    );

    final previous =
        DailyHistoryService.fatsForDate(
      previousDay(date),
    );

    return current - previous;
  }

  static bool caloriesIncreased(
    DateTime date,
  ) {
    return caloriesDifference(date) > 0;
  }

  static bool caloriesDecreased(
    DateTime date,
  ) {
    return caloriesDifference(date) < 0;
  }
}