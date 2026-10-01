import '../models/food_log_model.dart';
import '../models/food_model.dart';
import 'food_nutrition_service.dart';

class FoodLogBuilderService {
  FoodLogBuilderService._();

  /// Builds a food log from the quantity the user entered.
  ///
  /// Quantity semantics:
  /// - g / ml / L: quantity is already the real amount.
  /// - piece / slice / each: quantity is a count, so nutrition is scaled
  ///   by the number of units.
  /// - other units are treated as serving/count units and scaled by quantity.
  ///
  /// The FoodLogModel always stores the user's entered quantity. The
  /// nutrition fields are calculated from the food's own serving values.
  static FoodLogModel build({
    required FoodModel food,
    required String meal,
    required double quantityInput,
    required DateTime loggedAt,
  }) {
    if (quantityInput <= 0) {
      throw ArgumentError.value(
        quantityInput,
        'quantityInput',
        'Quantity must be greater than zero.',
      );
    }

    if (food.servingSize <= 0) {
      throw ArgumentError.value(
        food.servingSize,
        'food.servingSize',
        'Serving size must be greater than zero.',
      );
    }

    // Convert the user's entered quantity into the actual amount used by
    // the nutrition database:
    // - g / ml / L: already the real amount
    // - piece / slice / each: count × servingSize
    // - other units: preserve the existing serving/count behavior
    final effectiveAmount = _effectiveAmount(
      food: food,
      quantity: quantityInput,
    );

    // IMPORTANT:
    // FoodModel is the app's food catalog, while detailed micronutrients are
    // stored in NutritionData and resolved by FoodNutritionService.
    //
    // Using NutritionRecord here ensures vitamins/minerals are written into
    // FoodLogModel when a food is logged, so Progress can aggregate them.
    final nutrition = FoodNutritionService.nutritionForQuantity(
      food: food,
      quantity: effectiveAmount,
    );

    return FoodLogModel(
      id: '${food.id}_${loggedAt.microsecondsSinceEpoch}',
      date: _dateKey(loggedAt),
      foodId: food.id,
      foodName: food.name,
      mealType: meal,
      quantity: quantityInput,
      servingUnit: food.servingUnit,

      calories: nutrition.calories,
      protein: nutrition.protein,
      carbs: nutrition.carbohydrates,
      fats: nutrition.fats,
      fiber: nutrition.fiber,
      sugar: nutrition.sugar,

      addedSugar: nutrition.addedSugar,
      saturatedFat: nutrition.saturatedFat,
      transFat: nutrition.transFat,
      cholesterol: nutrition.cholesterol,
      sodium: nutrition.sodium,

      potassium: nutrition.potassium,
      calcium: nutrition.calcium,
      iron: nutrition.iron,
      magnesium: nutrition.magnesium,
      phosphorus: nutrition.phosphorus,
      zinc: nutrition.zinc,
      copper: nutrition.copper,
      manganese: nutrition.manganese,
      selenium: nutrition.selenium,
      iodine: nutrition.iodine,

      vitaminA: nutrition.vitaminA,
      vitaminC: nutrition.vitaminC,
      vitaminD: nutrition.vitaminD,
      vitaminE: nutrition.vitaminE,
      vitaminK: nutrition.vitaminK,

      vitaminB1: nutrition.vitaminB1,
      vitaminB2: nutrition.vitaminB2,
      vitaminB3: nutrition.vitaminB3,
      vitaminB5: nutrition.vitaminB5,
      vitaminB6: nutrition.vitaminB6,
      vitaminB7: nutrition.vitaminB7,
      vitaminB9: nutrition.vitaminB9,
      vitaminB12: nutrition.vitaminB12,

      preparationState: food.preparationState,
      source: food.source,
      sourceId: food.sourceId,
      nutritionDataVerified: food.nutritionDataVerified,

      loggedAt: loggedAt,
    );
  }

  static double _effectiveAmount({
    required FoodModel food,
    required double quantity,
  }) {
    final unit = food.servingUnit.trim().toLowerCase();

    if (_isDirectAmountUnit(unit)) {
      return quantity;
    }

    if (_isCountBasedUnit(unit)) {
      return quantity * food.servingSize;
    }

    return quantity * food.servingSize;
  }

  static bool _isDirectAmountUnit(String unit) {
    return const {
      'g',
      'gm',
      'gram',
      'grams',
      'ml',
      'milliliter',
      'milliliters',
      'millilitre',
      'millilitres',
      'l',
      'liter',
      'liters',
      'litre',
      'litres',
    }.contains(unit);
  }

  static bool _isCountBasedUnit(String unit) {
    return const {
      'piece',
      'pieces',
      'pc',
      'pcs',
      'each',
      'slice',
      'slices',
    }.contains(unit);
  }

  static String _dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
