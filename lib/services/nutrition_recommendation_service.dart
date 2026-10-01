import '../data/food_data.dart';
import '../models/food_log_model.dart';
import '../models/food_model.dart';
import '../models/nutrition_target_model.dart';
import 'food_nutrition_service.dart';

class NutritionRecommendation {
  final String nutrient;
  final String title;
  final String message;
  final List<FoodModel> foods;
  final bool positive;

  const NutritionRecommendation({
    required this.nutrient,
    required this.title,
    required this.message,
    required this.foods,
    required this.positive,
  });
}

/// Generates food suggestions from the user's actual logged nutrition.
///
/// The engine prioritizes the largest nutrition gaps first, then scores
/// candidate foods using the target nutrient plus useful counter-balancing
/// factors such as protein, fiber, sodium and added sugar.
class NutritionRecommendationService {
  NutritionRecommendationService._();

  static const int maxRecommendations = 4;
  static const int maxFoodsPerRecommendation = 4;

  static const double sodiumLimit = 2300;
  static const double addedSugarLimit = 50;

  static List<NutritionRecommendation> generate({
    required List<FoodLogModel> logs,
    required NutritionTargetModel targets,
  }) {
    final totals = _Totals.fromLogs(logs);
    final loggedFoodIds = logs.map((log) => log.foodId).toSet();
    final recommendations = <_RankedRecommendation>[];

    _addMacroGap(
      recommendations,
      totals,
      targets,
      loggedFoodIds,
    );

    _addFiberGap(
      recommendations,
      totals,
      targets,
      loggedFoodIds,
    );

    _addMicronutrientGap(
      recommendations,
      totals,
      loggedFoodIds,
    );

    _addSodiumWarning(
      recommendations,
      totals,
      loggedFoodIds,
    );

    _addSugarWarning(
      recommendations,
      totals,
      loggedFoodIds,
    );

    if (recommendations.isEmpty) {
      return [
        const NutritionRecommendation(
          nutrient: 'balanced',
          title: 'Your nutrition looks balanced',
          message:
              'No major nutrition gap was detected from the foods logged '
              'today. Keep building meals around varied whole foods.',
          foods: [],
          positive: true,
        ),
      ];
    }

    recommendations.sort(
      (a, b) => b.priority.compareTo(a.priority),
    );

    return recommendations
        .take(maxRecommendations)
        .map((item) => item.recommendation)
        .toList();
  }

  static void _addMacroGap(
    List<_RankedRecommendation> output,
    _Totals totals,
    NutritionTargetModel targets,
    Set<String> loggedFoodIds,
  ) {
    if (targets.protein > 0 &&
        totals.protein < targets.protein * 0.80) {
      final gap = targets.protein - totals.protein;

      output.add(
        _RankedRecommendation(
          priority: 100 + gap / targets.protein * 20,
          recommendation: NutritionRecommendation(
            nutrient: 'protein',
            title: 'Prioritize protein',
            message:
                'You have about ${gap.toStringAsFixed(0)} g of your protein '
                'target left. Choose a protein-rich food that also fits your '
                'overall calorie and sodium needs.',
            foods: _bestFoodsFor(
              target: _TargetNutrient.protein,
              loggedFoodIds: loggedFoodIds,
            ),
            positive: false,
          ),
        ),
      );
    }

    if (targets.carbohydrates > 0 &&
        totals.carbohydrates < targets.carbohydrates * 0.80) {
      final gap = targets.carbohydrates - totals.carbohydrates;

      output.add(
        _RankedRecommendation(
          priority: 65 + gap / targets.carbohydrates * 10,
          recommendation: NutritionRecommendation(
            nutrient: 'carbohydrates',
            title: 'Add a balanced carb source',
            message:
                'You have about ${gap.toStringAsFixed(0)} g of your '
                'carbohydrate target left. Favor minimally processed '
                'carbohydrate sources and pair them with protein or fiber.',
            foods: _bestFoodsFor(
              target: _TargetNutrient.carbohydrates,
              loggedFoodIds: loggedFoodIds,
            ),
            positive: false,
          ),
        ),
      );
    }

    if (targets.fats > 0 &&
        totals.fats < targets.fats * 0.80) {
      final gap = targets.fats - totals.fats;

      output.add(
        _RankedRecommendation(
          priority: 60 + gap / targets.fats * 10,
          recommendation: NutritionRecommendation(
            nutrient: 'fats',
            title: 'Add nutrient-dense fats',
            message:
                'You have about ${gap.toStringAsFixed(0)} g of your fat '
                'target left. Use a modest portion of nutrient-dense fat '
                'sources rather than relying on highly processed foods.',
            foods: _bestFoodsFor(
              target: _TargetNutrient.fats,
              loggedFoodIds: loggedFoodIds,
            ),
            positive: false,
          ),
        ),
      );
    }
  }

  static void _addFiberGap(
    List<_RankedRecommendation> output,
    _Totals totals,
    NutritionTargetModel targets,
    Set<String> loggedFoodIds,
  ) {
    final fiberTarget =
        targets.fiber > 0 ? targets.fiber : 28;

    if (totals.fiber < fiberTarget * 0.80) {
      final gap = fiberTarget - totals.fiber;

      output.add(
        _RankedRecommendation(
          priority: 90 + gap / fiberTarget * 12,
          recommendation: NutritionRecommendation(
            nutrient: 'fiber',
            title: 'Boost fiber',
            message:
                'You have about ${gap.toStringAsFixed(1)} g of fiber left '
                'to reach your daily reference. Add fruit, vegetables, '
                'legumes, whole grains, nuts or seeds.',
            foods: _bestFoodsFor(
              target: _TargetNutrient.fiber,
              loggedFoodIds: loggedFoodIds,
            ),
            positive: false,
          ),
        ),
      );
    }
  }

  static void _addMicronutrientGap(
    List<_RankedRecommendation> output,
    _Totals totals,
    Set<String> loggedFoodIds,
  ) {
    final gaps = <_MicroGap>[
      _MicroGap(
        nutrient: 'vitaminC',
        title: 'Vitamin C is low',
        message:
            'Your logged foods are currently below 50% of the standard '
            'vitamin C Daily Value.',
        consumed: totals.vitaminC,
        target: 90,
        targetType: _TargetNutrient.vitaminC,
        priority: 86,
      ),
      _MicroGap(
        nutrient: 'calcium',
        title: 'Calcium is low',
        message:
            'Your logged foods are currently below 50% of the standard '
            'calcium Daily Value.',
        consumed: totals.calcium,
        target: 1300,
        targetType: _TargetNutrient.calcium,
        priority: 84,
      ),
      _MicroGap(
        nutrient: 'iron',
        title: 'Iron is low',
        message:
            'Your logged foods are currently below 50% of the standard '
            'iron Daily Value.',
        consumed: totals.iron,
        target: 18,
        targetType: _TargetNutrient.iron,
        priority: 82,
      ),
      _MicroGap(
        nutrient: 'potassium',
        title: 'Potassium is low',
        message:
            'Your logged foods are currently below 50% of the standard '
            'potassium Daily Value.',
        consumed: totals.potassium,
        target: 4700,
        targetType: _TargetNutrient.potassium,
        priority: 80,
      ),
    ];

    gaps.sort(
      (a, b) {
        final aRatio = a.target <= 0
            ? 1.0
            : a.consumed / a.target;
        final bRatio = b.target <= 0
            ? 1.0
            : b.consumed / b.target;

        return aRatio.compareTo(bRatio);
      },
    );

    for (final gap in gaps) {
      if (gap.consumed >= gap.target * 0.50) {
        continue;
      }

      output.add(
        _RankedRecommendation(
          priority: gap.priority +
              ((gap.target - gap.consumed) / gap.target * 10),
          recommendation: NutritionRecommendation(
            nutrient: gap.nutrient,
            title: gap.title,
            message: gap.message,
            foods: _bestFoodsFor(
              target: gap.targetType,
              loggedFoodIds: loggedFoodIds,
            ),
            positive: false,
          ),
        ),
      );
    }
  }

  static void _addSodiumWarning(
    List<_RankedRecommendation> output,
    _Totals totals,
    Set<String> loggedFoodIds,
  ) {
    if (totals.sodium > sodiumLimit) {
      output.add(
        _RankedRecommendation(
          priority: 95 +
              ((totals.sodium - sodiumLimit) / sodiumLimit * 10),
          recommendation: NutritionRecommendation(
            nutrient: 'sodium',
            title: 'Choose lower-sodium foods next',
            message:
                'Your logged sodium is above the 2,300 mg standard daily '
                'limit. Favor fresh or minimally processed foods for the '
                'rest of the day and check packaged-food labels.',
            foods: _bestFoodsFor(
              target: _TargetNutrient.lowerSodium,
              loggedFoodIds: loggedFoodIds,
            ),
            positive: false,
          ),
        ),
      );
    }
  }

  static void _addSugarWarning(
    List<_RankedRecommendation> output,
    _Totals totals,
    Set<String> loggedFoodIds,
  ) {
    if (totals.addedSugar > addedSugarLimit) {
      output.add(
        _RankedRecommendation(
          priority: 92 +
              ((totals.addedSugar - addedSugarLimit) /
                  addedSugarLimit *
                  10),
          recommendation: NutritionRecommendation(
            nutrient: 'addedSugar',
            title: 'Keep added sugar low next',
            message:
                'Your added sugar is above 50 g for the day. For the next '
                'food choice, prefer foods with little or no added sugar.',
            foods: _bestFoodsFor(
              target: _TargetNutrient.lowerAddedSugar,
              loggedFoodIds: loggedFoodIds,
            ),
            positive: false,
          ),
        ),
      );
    }
  }

  static List<FoodModel> _bestFoodsFor({
    required _TargetNutrient target,
    required Set<String> loggedFoodIds,
  }) {
    final candidates = <_ScoredFood>[];

    for (final food in FoodData.foods) {
      // Avoid repeatedly recommending foods already logged today.
      if (loggedFoodIds.contains(food.id)) {
        continue;
      }

      final n =
          _ReferenceNutrition.fromFood(food);

      if (n.calories <= 0) {
        continue;
      }

      final score = _score(
        target: target,
        n: n,
      );

      candidates.add(
        _ScoredFood(
          food: food,
          score: score,
        ),
      );
    }

    candidates.sort(
      (a, b) => b.score.compareTo(a.score),
    );

    return _diverseFoods(candidates, maxFoodsPerRecommendation);
  }

  static double _score({
    required _TargetNutrient target,
    required _ReferenceNutrition n,
  }) {
    final nutrientScore = switch (target) {
      _TargetNutrient.protein =>
        _density(n.protein, n.calories, scale: 4.0),
      _TargetNutrient.carbohydrates =>
        _density(n.carbohydrates, n.calories, scale: 1.8),
      _TargetNutrient.fats =>
        _density(n.fats, n.calories, scale: 2.0),
      _TargetNutrient.fiber =>
        _density(n.fiber, n.calories, scale: 7.0),
      _TargetNutrient.vitaminC =>
        _density(n.vitaminC, n.calories, scale: 2.5),
      _TargetNutrient.calcium =>
        _density(n.calcium, n.calories, scale: 0.20),
      _TargetNutrient.iron =>
        _density(n.iron, n.calories, scale: 1.2),
      _TargetNutrient.potassium =>
        _density(n.potassium, n.calories, scale: 0.06),
      _TargetNutrient.lowerSodium =>
        4.0 -
        _density(n.sodium, n.calories, scale: 0.03),
      _TargetNutrient.lowerAddedSugar =>
        4.0 -
        _density(n.addedSugar, n.calories, scale: 0.8),
    };

    final helpfulProtein =
        _density(n.protein, n.calories, scale: 0.7);
    final helpfulFiber =
        _density(n.fiber, n.calories, scale: 1.2);

    final sodiumPenalty =
        _density(n.sodium, n.calories, scale: 0.015);

    final sugarPenalty =
        _density(n.addedSugar, n.calories, scale: 0.40);

    return nutrientScore +
        helpfulProtein +
        helpfulFiber -
        sodiumPenalty -
        sugarPenalty;
  }

  static double _density(
    double amount,
    double calories, {
    required double scale,
  }) {
    if (calories <= 0) return 0;
    return (amount / calories * 100) * scale;
  }

  static List<FoodModel> _diverseFoods(
    List<_ScoredFood> candidates,
    int count,
  ) {
    final result = <FoodModel>[];
    final categories = <String>{};

    // First pass: prefer different categories so four suggestions aren't
    // essentially the same type of food.
    for (final candidate in candidates) {
      final category =
          candidate.food.category.trim().toLowerCase();

      if (!categories.add(category)) {
        continue;
      }

      result.add(candidate.food);

      if (result.length >= count) {
        return result;
      }
    }

    // Second pass: fill any remaining slots.
    for (final candidate in candidates) {
      if (result.any(
        (food) => food.id == candidate.food.id,
      )) {
        continue;
      }

      result.add(candidate.food);

      if (result.length >= count) {
        break;
      }
    }

    return result;
  }
}

enum _TargetNutrient {
  protein,
  carbohydrates,
  fats,
  fiber,
  vitaminC,
  calcium,
  iron,
  potassium,
  lowerSodium,
  lowerAddedSugar,
}

class _MicroGap {
  final String nutrient;
  final String title;
  final String message;
  final double consumed;
  final double target;
  final _TargetNutrient targetType;
  final double priority;

  const _MicroGap({
    required this.nutrient,
    required this.title,
    required this.message,
    required this.consumed,
    required this.target,
    required this.targetType,
    required this.priority,
  });
}

class _RankedRecommendation {
  final double priority;
  final NutritionRecommendation recommendation;

  const _RankedRecommendation({
    required this.priority,
    required this.recommendation,
  });
}

class _ScoredFood {
  final FoodModel food;
  final double score;

  const _ScoredFood({
    required this.food,
    required this.score,
  });
}

class _Totals {
  double protein = 0;
  double carbohydrates = 0;
  double fats = 0;
  double fiber = 0;
  double addedSugar = 0;
  double sodium = 0;
  double vitaminC = 0;
  double calcium = 0;
  double iron = 0;
  double potassium = 0;

  static _Totals fromLogs(
    List<FoodLogModel> logs,
  ) {
    final totals = _Totals();

    for (final log in logs) {
      totals.protein += log.protein;
      totals.carbohydrates += log.carbs;
      totals.fats += log.fats;
      totals.fiber += log.fiber;
      totals.addedSugar += log.addedSugar;
      totals.sodium += log.sodium;
      totals.vitaminC += log.vitaminC;
      totals.calcium += log.calcium;
      totals.iron += log.iron;
      totals.potassium += log.potassium;
    }

    return totals;
  }
}

class _ReferenceNutrition {
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fats;
  final double fiber;
  final double addedSugar;
  final double sodium;
  final double vitaminC;
  final double calcium;
  final double iron;
  final double potassium;

  const _ReferenceNutrition({
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fats,
    required this.fiber,
    required this.addedSugar,
    required this.sodium,
    required this.vitaminC,
    required this.calcium,
    required this.iron,
    required this.potassium,
  });

  factory _ReferenceNutrition.fromFood(
    FoodModel food,
  ) {
    final nutrition =
        FoodNutritionService.nutritionForQuantity(
      food: food,
      quantity: 100,
    );

    return _ReferenceNutrition(
      calories: nutrition.calories,
      protein: nutrition.protein,
      carbohydrates: nutrition.carbohydrates,
      fats: nutrition.fats,
      fiber: nutrition.fiber,
      addedSugar: nutrition.addedSugar,
      sodium: nutrition.sodium,
      vitaminC: nutrition.vitaminC,
      calcium: nutrition.calcium,
      iron: nutrition.iron,
      potassium: nutrition.potassium,
    );
  }
}
