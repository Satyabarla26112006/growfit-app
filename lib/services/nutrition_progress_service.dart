import '../models/nutrition_progress_model.dart';
import '../models/nutrition_target_model.dart';
import '../models/user_model.dart';
import 'daily_history_service.dart';
import 'nutrition_target_service.dart';

class NutritionProgressService {
  NutritionProgressService._();

  // ============================================================
  // BUILD TARGETS FROM USER PROFILE
  // ============================================================

  static NutritionTargetModel targetsForUser(
    UserModel user,
  ) {
    final calories =
        user.targetCalories ?? 0;

    final protein =
        user.targetProtein ?? 0;

    final carbs =
        user.targetCarbs ?? 0;

    final fats =
        user.targetFats ?? 0;

    return NutritionTargetModel(
      calories: calories,
      protein: protein,
      carbohydrates: carbs,
      fats: fats,
      fiber:
          NutritionTargetService.calculateFiberTarget(
        calories: calories,
      ),
      sugar:
          NutritionTargetService.calculateSugarTarget(
        calories: calories,
      ),
      sodium:
          NutritionTargetService.calculateSodiumTarget(),
    );
  }

  // ============================================================
  // COMPLETE DAILY PROGRESS
  // ============================================================

  static NutritionDailyProgress calculate({
    required DateTime date,
    required NutritionTargetModel targets,
  }) {
    return NutritionDailyProgress(
      calories: NutritionProgressModel.fromValues(
        consumed:
            DailyHistoryService.caloriesForDate(date),
        target:
            targets.calories,
      ),

      protein: NutritionProgressModel.fromValues(
        consumed:
            DailyHistoryService.proteinForDate(date),
        target:
            targets.protein,
      ),

      carbohydrates: NutritionProgressModel.fromValues(
        consumed:
            DailyHistoryService.carbsForDate(date),
        target:
            targets.carbohydrates,
      ),

      fats: NutritionProgressModel.fromValues(
        consumed:
            DailyHistoryService.fatsForDate(date),
        target:
            targets.fats,
      ),

      fiber: NutritionProgressModel.fromValues(
        consumed:
            DailyHistoryService.fiberForDate(date),
        target:
            targets.fiber,
      ),

      sugar: NutritionProgressModel.fromValues(
        consumed:
            DailyHistoryService.sugarForDate(date),
        target:
            targets.sugar,
      ),

      sodium: NutritionProgressModel.fromValues(
        consumed:
            _sodiumForDate(date),
        target:
            targets.sodium,
      ),
    );
  }

  // ============================================================
  // SODIUM
  // ============================================================

  static double _sodiumForDate(
    DateTime date,
  ) {
    final logs =
        DailyHistoryService.getLogsForDate(date);

    double total = 0;

    for (final log in logs) {
      total += log.sodium;
    }

    return total;
  }
}

// ================================================================
// DAILY PROGRESS CONTAINER
// ================================================================

class NutritionDailyProgress {
  final NutritionProgressModel calories;
  final NutritionProgressModel protein;
  final NutritionProgressModel carbohydrates;
  final NutritionProgressModel fats;
  final NutritionProgressModel fiber;
  final NutritionProgressModel sugar;
  final NutritionProgressModel sodium;

  const NutritionDailyProgress({
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fats,
    required this.fiber,
    required this.sugar,
    required this.sodium,
  });
}