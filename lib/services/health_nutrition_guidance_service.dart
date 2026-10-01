import '../data/food_data.dart';
import '../models/food_log_model.dart';
import '../models/food_model.dart';
import 'food_nutrition_service.dart';

/// Nutrition guidance based on logged-food patterns and, when available,
/// user-entered blood pressure or blood glucose readings.
///
/// This service does not diagnose or treat any medical condition.
/// It provides general nutrition education and food suggestions.
class HealthNutritionGuidance {
  final String area;
  final String title;
  final String message;
  final List<FoodModel> foods;
  final bool caution;

  const HealthNutritionGuidance({
    required this.area,
    required this.title,
    required this.message,
    required this.foods,
    required this.caution,
  });
}

class HealthNutritionGuidanceService {
  HealthNutritionGuidanceService._();

  static const double sodiumHighThresholdMg = 2300;
  static const double sodiumLowerGoalMg = 1500;

  static const double addedSugarHighThresholdG = 50;
  static const double fiberLowThresholdG = 22.4;

  static const double potassiumHelpfulThresholdMg = 2600;
  static const double glucoseHighThresholdMgDl = 126;
  static const double glucoseLowThresholdMgDl = 70;

  static const int maxGuidance = 4;
  static const int maxFoods = 4;

  /// Generates general nutrition guidance from the selected day's logs.
  ///
  /// [systolic] and [diastolic] are optional because the app currently
  /// does not have to store a blood-pressure reading.
  ///
  /// [bloodGlucoseMgDl] is optional for the same reason.
  static List<HealthNutritionGuidance> generate({
    required List<FoodLogModel> logs,
    double? systolic,
    double? diastolic,
    double? bloodGlucoseMgDl,
  }) {
    final totals = _Totals.fromLogs(logs);
    final guidance = <HealthNutritionGuidance>[];

    _addBloodPressureGuidance(
      guidance: guidance,
      totals: totals,
      systolic: systolic,
      diastolic: diastolic,
    );

    _addBloodSugarGuidance(
      guidance: guidance,
      totals: totals,
      bloodGlucoseMgDl: bloodGlucoseMgDl,
    );

    _addGeneralBalanceGuidance(
      guidance: guidance,
      totals: totals,
    );

    return guidance.take(maxGuidance).toList();
  }

  static void _addBloodPressureGuidance({
    required List<HealthNutritionGuidance> guidance,
    required _Totals totals,
    double? systolic,
    double? diastolic,
  }) {
    final hasHighReading = systolic != null &&
        diastolic != null &&
        (systolic >= 130 || diastolic >= 80);

    final hasStage2Reading = systolic != null &&
        diastolic != null &&
        (systolic >= 140 || diastolic >= 90);

    if (hasStage2Reading) {
      guidance.add(
        HealthNutritionGuidance(
          area: 'Blood Pressure',
          title: 'Blood pressure reading is high',
          message:
              'Consider a lower-sodium, heart-healthy eating pattern and '
              'discuss repeated high readings with a healthcare professional.',
          foods: _bestFoodsFor(
            selector: (nutrition) => nutrition.potassium,
            lowerIsBetter: false,
            count: maxFoods,
          ),
          caution: true,
        ),
      );
      return;
    }

    if (hasHighReading || totals.sodium > sodiumHighThresholdMg) {
      guidance.add(
        HealthNutritionGuidance(
          area: 'Blood Pressure',
          title: 'Go easier on sodium',
          message:
              'Your day includes a sodium pattern worth watching. Favor '
              'minimally processed foods, vegetables, fruit, beans and '
              'unsalted nuts, and compare sodium on packaged-food labels.',
          foods: _bestFoodsFor(
            selector: (nutrition) => nutrition.sodium,
            lowerIsBetter: true,
            count: maxFoods,
          ),
          caution: true,
        ),
      );
      return;
    }

    if (totals.potassium < potassiumHelpfulThresholdMg &&
        totals.sodium < sodiumHighThresholdMg) {
      guidance.add(
        HealthNutritionGuidance(
          area: 'Blood Pressure',
          title: 'Add more potassium-rich foods',
          message:
              'A heart-healthy pattern can include more potassium-rich foods '
              'such as fruits, vegetables, beans and other minimally processed '
              'foods.',
          foods: _bestFoodsFor(
            selector: (nutrition) => nutrition.potassium,
            lowerIsBetter: false,
            count: maxFoods,
          ),
          caution: false,
        ),
      );
    }
  }

  static void _addBloodSugarGuidance({
    required List<HealthNutritionGuidance> guidance,
    required _Totals totals,
    double? bloodGlucoseMgDl,
  }) {
    final hasHighGlucose =
        bloodGlucoseMgDl != null &&
        bloodGlucoseMgDl >= glucoseHighThresholdMgDl;

    final hasLowGlucose =
        bloodGlucoseMgDl != null &&
        bloodGlucoseMgDl < glucoseLowThresholdMgDl;

    if (hasLowGlucose) {
      guidance.add(
        const HealthNutritionGuidance(
          area: 'Blood Sugar',
          title: 'Blood sugar reading is low',
          message:
              'Low blood glucose can require prompt action. Follow your '
              'personal medical plan and seek urgent medical guidance when '
              'needed rather than relying on food recommendations in the app.',
          foods: <FoodModel>[],
          caution: true,
        ),
      );
      return;
    }

    if (hasHighGlucose ||
        totals.addedSugar > addedSugarHighThresholdG ||
        (totals.carbohydrates > 0 &&
            totals.fiber < fiberLowThresholdG)) {
      guidance.add(
        HealthNutritionGuidance(
          area: 'Blood Sugar',
          title: 'Choose higher-fiber, less refined carbs',
          message:
              'For blood-sugar-friendly meals, favor high-fiber foods and '
              'whole-food carbohydrate sources, watch portions, and limit '
              'sugary drinks and foods with lots of added sugar.',
          foods: _bestFoodsForBloodSugar(
            count: maxFoods,
          ),
          caution: true,
        ),
      );
    }
  }

  static void _addGeneralBalanceGuidance({
    required List<HealthNutritionGuidance> guidance,
    required _Totals totals,
  }) {
    if (totals.sodium <= sodiumLowerGoalMg &&
        totals.addedSugar <= addedSugarHighThresholdG &&
        totals.fiber >= fiberLowThresholdG) {
      guidance.add(
        const HealthNutritionGuidance(
          area: 'Overall',
          title: 'Good heart and blood-sugar foundation',
          message:
              'Your logged foods show a useful balance of lower sodium, '
              'moderate added sugar and solid fiber intake so far.',
          foods: <FoodModel>[],
          caution: false,
        ),
      );
      return;
    }

    if (totals.fiber < fiberLowThresholdG) {
      guidance.add(
        HealthNutritionGuidance(
          area: 'Overall',
          title: 'Increase fiber gradually',
          message:
              'Add vegetables, whole grains, legumes, fruit, nuts or seeds '
              'across the day. Increase fiber gradually and drink enough water.',
          foods: _bestFoodsFor(
            selector: (nutrition) => nutrition.fiber,
            lowerIsBetter: false,
            count: maxFoods,
          ),
          caution: false,
        ),
      );
    }
  }

  static List<FoodModel> _bestFoodsFor({
    required double Function(_ReferenceNutrition nutrition) selector,
    required bool lowerIsBetter,
    required int count,
  }) {
    final scored = <_ScoredFood>[];

    for (final food in FoodData.foods) {
      final nutrition = _ReferenceNutrition.fromFood(food);

      if (nutrition.calories <= 0) {
        continue;
      }

      final score = selector(nutrition);

      if (score < 0) {
        continue;
      }

      scored.add(
        _ScoredFood(
          food: food,
          score: score,
        ),
      );
    }

    scored.sort(
      (a, b) {
        final comparison = a.score.compareTo(b.score);
        return lowerIsBetter ? comparison : -comparison;
      },
    );

    return _uniqueFoods(
      scored.map((item) => item.food),
      count,
    );
  }

  static List<FoodModel> _bestFoodsForBloodSugar({
    required int count,
  }) {
    final scored = <_BloodSugarFood>[];

    for (final food in FoodData.foods) {
      final nutrition = _ReferenceNutrition.fromFood(food);

      if (nutrition.calories <= 0) {
        continue;
      }

      final score =
          (nutrition.fiber * 4) +
          nutrition.protein -
          (nutrition.addedSugar * 5) -
          (nutrition.sodium / 500);

      scored.add(
        _BloodSugarFood(
          food: food,
          score: score,
        ),
      );
    }

    scored.sort(
      (a, b) => b.score.compareTo(a.score),
    );

    return _uniqueFoods(
      scored.map((item) => item.food),
      count,
    );
  }

  static List<FoodModel> _uniqueFoods(
    Iterable<FoodModel> foods,
    int count,
  ) {
    final result = <FoodModel>[];
    final seen = <String>{};

    for (final food in foods) {
      if (!seen.add(food.id)) {
        continue;
      }

      result.add(food);

      if (result.length >= count) {
        break;
      }
    }

    return result;
  }
}

class _Totals {
  final double carbohydrates;
  final double fiber;
  final double addedSugar;
  final double sodium;
  final double potassium;

  const _Totals({
    required this.carbohydrates,
    required this.fiber,
    required this.addedSugar,
    required this.sodium,
    required this.potassium,
  });

  factory _Totals.fromLogs(List<FoodLogModel> logs) {
    var carbohydrates = 0.0;
    var fiber = 0.0;
    var addedSugar = 0.0;
    var sodium = 0.0;
    var potassium = 0.0;

    for (final log in logs) {
      carbohydrates += log.carbs;
      fiber += log.fiber;
      addedSugar += log.addedSugar;
      sodium += log.sodium;
      potassium += log.potassium;
    }

    return _Totals(
      carbohydrates: carbohydrates,
      fiber: fiber,
      addedSugar: addedSugar,
      sodium: sodium,
      potassium: potassium,
    );
  }
}

class _ReferenceNutrition {
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fiber;
  final double addedSugar;
  final double sodium;
  final double potassium;

  const _ReferenceNutrition({
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fiber,
    required this.addedSugar,
    required this.sodium,
    required this.potassium,
  });

  factory _ReferenceNutrition.fromFood(FoodModel food) {
    final nutrition = FoodNutritionService.nutritionForQuantity(
      food: food,
      quantity: 100,
    );

    return _ReferenceNutrition(
      calories: nutrition.calories,
      protein: nutrition.protein,
      carbohydrates: nutrition.carbohydrates,
      fiber: nutrition.fiber,
      addedSugar: nutrition.addedSugar,
      sodium: nutrition.sodium,
      potassium: nutrition.potassium,
    );
  }
}

class _ScoredFood {
  final FoodModel food;
  final double score;

  const _ScoredFood({
    required this.food,
    required this.score,
  });
}

class _BloodSugarFood {
  final FoodModel food;
  final double score;

  const _BloodSugarFood({
    required this.food,
    required this.score,
  });
}
