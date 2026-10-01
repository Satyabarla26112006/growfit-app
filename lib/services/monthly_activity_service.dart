import 'daily_history_service.dart';

class MonthlyActivityService {
  MonthlyActivityService._();

  static int foodDays(DateTime month) {
    final days = DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    int count = 0;

    for (int day = 1; day <= days; day++) {
      final date = DateTime(
        month.year,
        month.month,
        day,
      );

      if (DailyHistoryService.hasFoodForDate(
        date,
      )) {
        count++;
      }
    }

    return count;
  }

  static int foodEntries(DateTime month) {
    final days = DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    int count = 0;

    for (int day = 1; day <= days; day++) {
      final date = DateTime(
        month.year,
        month.month,
        day,
      );

      count += DailyHistoryService
          .foodCountForDate(date);
    }

    return count;
  }

  static double calories(DateTime month) {
    final days = DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    double total = 0;

    for (int day = 1; day <= days; day++) {
      total += DailyHistoryService
          .caloriesForDate(
        DateTime(
          month.year,
          month.month,
          day,
        ),
      );
    }

    return total;
  }
}