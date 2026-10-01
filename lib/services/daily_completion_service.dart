import '../models/daily_completion_model.dart';
import 'attendance_service.dart';
import 'daily_history_service.dart';

class DailyCompletionService {
  DailyCompletionService._();

  static DailyCompletionModel forDate(
    DateTime date,
  ) {
    return DailyCompletionModel(
      date: DailyHistoryService.dateKey(
        date,
      ),
      attendance:
          AttendanceService.isPresent(
        date,
      ),
      foodLogged:
          DailyHistoryService.hasFoodForDate(
        date,
      ),
      calories:
          DailyHistoryService.caloriesForDate(
        date,
      ),
      protein:
          DailyHistoryService.proteinForDate(
        date,
      ),
      carbs:
          DailyHistoryService.carbsForDate(
        date,
      ),
      fats:
          DailyHistoryService.fatsForDate(
        date,
      ),
    );
  }

  static DailyCompletionModel today() {
    return forDate(
      DateTime.now(),
    );
  }

  static bool isCompleted(
    DateTime date,
  ) {
    return forDate(date).completed;
  }

  static double percentage(
    DateTime date,
  ) {
    return forDate(date)
        .completionPercentage;
  }
}