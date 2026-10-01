import '../screens/onboarding/activity_level_screen.dart';
import '../screens/onboarding/goals_screen.dart';

class CalorieService {
  CalorieService._();

  static double activityMultiplier(
    GrowFitActivityLevel level,
  ) {
    switch (level) {
      case GrowFitActivityLevel.sedentary:
        return 1.2;

      case GrowFitActivityLevel.lightlyActive:
        return 1.375;

      case GrowFitActivityLevel.moderatelyActive:
        return 1.55;

      case GrowFitActivityLevel.veryActive:
        return 1.725;

      case GrowFitActivityLevel.extremelyActive:
        return 1.9;
    }
  }

  static double goalAdjustment(
    GrowFitGoal goal,
  ) {
    switch (goal) {
      case GrowFitGoal.loseWeight:
        return -400;

      case GrowFitGoal.gainWeight:
        return 300;

      case GrowFitGoal.gainMuscle:
        return 250;

      case GrowFitGoal.maintainWeight:
        return 0;

      case GrowFitGoal.improveFitness:
        return 0;
    }
  }

  static double calculateBmr({
    required double weight,
    required double height,
    required int age,
    required bool isMale,
  }) {
    if (weight <= 0 || height <= 0 || age <= 0) {
      return 0;
    }

    final base =
        (10 * weight) +
        (6.25 * height) -
        (5 * age);

    return isMale
        ? base + 5
        : base - 161;
  }

  static double calculateTdee({
    required double bmr,
    required GrowFitActivityLevel activityLevel,
  }) {
    if (bmr <= 0) {
      return 0;
    }

    return bmr *
        activityMultiplier(activityLevel);
  }

  static double calculateDailyCalories({
    required double bmr,
    required GrowFitActivityLevel activityLevel,
    required GrowFitGoal goal,
  }) {
    final tdee = calculateTdee(
      bmr: bmr,
      activityLevel: activityLevel,
    );

    if (tdee <= 0) {
      return 0;
    }

    final calories =
        tdee + goalAdjustment(goal);

    if (calories < 1200) {
      return 1200;
    }

    return calories;
  }

  static double calculateProteinTarget({
    required double weight,
    required GrowFitGoal goal,
  }) {
    if (weight <= 0) {
      return 0;
    }

    double multiplier;

    switch (goal) {
      case GrowFitGoal.loseWeight:
        multiplier = 1.8;

      case GrowFitGoal.gainWeight:
        multiplier = 1.6;

      case GrowFitGoal.gainMuscle:
        multiplier = 2.0;

      case GrowFitGoal.maintainWeight:
        multiplier = 1.6;

      case GrowFitGoal.improveFitness:
        multiplier = 1.6;
    }

    return weight * multiplier;
  }

  static double calculateFatTarget({
    required double calories,
  }) {
    if (calories <= 0) {
      return 0;
    }

    return (calories * 0.25) / 9;
  }

  static double calculateCarbTarget({
    required double calories,
    required double protein,
    required double fats,
  }) {
    if (calories <= 0) {
      return 0;
    }

    final proteinCalories = protein * 4;
    final fatCalories = fats * 9;

    final remaining =
        calories -
        proteinCalories -
        fatCalories;

    if (remaining <= 0) {
      return 0;
    }

    return remaining / 4;
  }

  static NutritionTargets calculateNutritionTargets({
    required double weight,
    required double height,
    required int age,
    required bool isMale,
    required GrowFitActivityLevel activityLevel,
    required GrowFitGoal goal,
  }) {
    final bmr = calculateBmr(
      weight: weight,
      height: height,
      age: age,
      isMale: isMale,
    );

    final tdee = calculateTdee(
      bmr: bmr,
      activityLevel: activityLevel,
    );

    final calories =
        calculateDailyCalories(
      bmr: bmr,
      activityLevel: activityLevel,
      goal: goal,
    );

    final protein =
        calculateProteinTarget(
      weight: weight,
      goal: goal,
    );

    final fats =
        calculateFatTarget(
      calories: calories,
    );

    final carbs =
        calculateCarbTarget(
      calories: calories,
      protein: protein,
      fats: fats,
    );

    return NutritionTargets(
      bmr: bmr,
      tdee: tdee,
      calories: calories,
      protein: protein,
      carbohydrates: carbs,
      fats: fats,
    );
  }
}

class NutritionTargets {
  final double bmr;
  final double tdee;
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fats;

  const NutritionTargets({
    required this.bmr,
    required this.tdee,
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fats,
  });

  Map<String, dynamic> toJson() {
    return {
      'bmr': bmr,
      'tdee': tdee,
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fats': fats,
    };
  }
}