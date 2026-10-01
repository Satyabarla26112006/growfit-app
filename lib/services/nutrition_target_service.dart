import '../models/nutrition_target_model.dart';
import 'calorie_service.dart';
import '../screens/onboarding/activity_level_screen.dart';
import '../screens/onboarding/goals_screen.dart';

class NutritionTargetService {
  NutritionTargetService._();

  // ============================================================
  // DAILY FIBER TARGET
  // ============================================================

  static double calculateFiberTarget({
    required double calories,
  }) {
    if (calories <= 0) {
      return 0;
    }

    // General planning target:
    // approximately 14 g fiber per 1,000 kcal.
    return calories * 14 / 1000;
  }

  // ============================================================
  // DAILY SUGAR LIMIT
  // ============================================================

  static double calculateSugarTarget({
    required double calories,
  }) {
    if (calories <= 0) {
      return 0;
    }

    // Keep added/free sugar within approximately 10%
    // of daily energy intake.
    //
    // 1 g sugar = 4 kcal.
    return (calories * 0.10) / 4;
  }

  // ============================================================
  // DAILY SODIUM LIMIT
  // ============================================================

  static double calculateSodiumTarget() {
    // 2300 mg/day upper limit.
    return 2300;
  }

  // ============================================================
  // COMPLETE DAILY TARGET
  // ============================================================

  static NutritionTargetModel calculate({
    required double weight,
    required double height,
    required int age,
    required bool isMale,
    required GrowFitActivityLevel activityLevel,
    required GrowFitGoal goal,
  }) {
    final nutritionTargets =
        CalorieService.calculateNutritionTargets(
      weight: weight,
      height: height,
      age: age,
      isMale: isMale,
      activityLevel: activityLevel,
      goal: goal,
    );

    final fiber =
        calculateFiberTarget(
      calories: nutritionTargets.calories,
    );

    final sugar =
        calculateSugarTarget(
      calories: nutritionTargets.calories,
    );

    final sodium =
        calculateSodiumTarget();

    return NutritionTargetModel(
      calories: nutritionTargets.calories,
      protein: nutritionTargets.protein,
      carbohydrates:
          nutritionTargets.carbohydrates,
      fats: nutritionTargets.fats,
      fiber: fiber,
      sugar: sugar,
      sodium: sodium,
    );
  }

  // ============================================================
  // BUILD FROM EXISTING CALORIE TARGETS
  // ============================================================

  static NutritionTargetModel fromNutritionTargets(
    NutritionTargets targets,
  ) {
    final fiber =
        calculateFiberTarget(
      calories: targets.calories,
    );

    final sugar =
        calculateSugarTarget(
      calories: targets.calories,
    );

    final sodium =
        calculateSodiumTarget();

    return NutritionTargetModel(
      calories: targets.calories,
      protein: targets.protein,
      carbohydrates: targets.carbohydrates,
      fats: targets.fats,
      fiber: fiber,
      sugar: sugar,
      sodium: sodium,
    );
  }
}