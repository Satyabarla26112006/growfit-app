import 'daily_completion_service.dart';

class CompletionStatsService {
  CompletionStatsService._();

  static double todayPercentage() {
    return DailyCompletionService
        .percentage(
      DateTime.now(),
    );
  }

  static bool todayCompleted() {
    return DailyCompletionService
        .isCompleted(
      DateTime.now(),
    );
  }

  static double datePercentage(
    DateTime date,
  ) {
    return DailyCompletionService
        .percentage(date);
  }

  static bool dateCompleted(
    DateTime date,
  ) {
    return DailyCompletionService
        .isCompleted(date);
  }

  static String percentageText(
    DateTime date,
  ) {
    final percentage =
        datePercentage(date) * 100;

    return '${percentage.round()}%';
  }
}