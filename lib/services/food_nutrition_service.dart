import '../data/nutrition_data.dart';
import '../models/food_model.dart';

class FoodNutritionService {
  FoodNutritionService._();

  // ============================================================
  // STANDARD NUTRITION REFERENCE
  // ============================================================
  //
  // NutritionData is stored per 100 g.
  //
  // This is the standard reference for the detailed nutrition
  // system.
  //
  // User quantity is still allowed to be:
  //   piece
  //   g
  //   ml
  //   slice
  //   bowl
  //   etc.
  //
  // The FoodLogBuilderService converts piece-based quantities
  // into effective grams before reaching this service.
  // ============================================================

  static const double nutritionReferenceGrams = 100.0;

  // ============================================================
  // GET NUTRITION RECORD
  // ============================================================

  static NutritionRecord? getRecord(
    FoodModel food,
  ) {
    return NutritionData.findByFoodId(
      food.id,
    );
  }

  // ============================================================
  // GET NUTRITION FOR ACTUAL QUANTITY
  // ============================================================
  //
  // NutritionData:
  //   nutrition per 100 g
  //
  // Example:
  //   record = 130 kcal / 100 g
  //   quantity = 150 g
  //
  //   multiplier = 150 / 100 = 1.5
  //   calories = 130 × 1.5 = 195 kcal
  //
  // ALL nutrients are scaled:
  // calories, macros, sugar, fats, minerals, vitamins, etc.
  // ============================================================

  static NutritionRecord nutritionForQuantity({
    required FoodModel food,
    required double quantity,
  }) {
    if (quantity <= 0) {
      return _emptyRecord();
    }

    final record = getRecord(food);

    // ----------------------------------------------------------
    // VERIFIED / DETAILED NUTRITION DATA
    // ----------------------------------------------------------
    //
    // NutritionData is standardized to 100 g.
    // ----------------------------------------------------------

    if (record != null) {
      final multiplier =
          quantity / nutritionReferenceGrams;

      return record.scale(
        multiplier,
      );
    }

    // ----------------------------------------------------------
    // LEGACY FALLBACK
    // ----------------------------------------------------------
    //
    // FoodModel values are based on food.servingSize.
    //
    // Convert them to a 100 g reference first, then scale
    // according to the actual quantity.
    // ----------------------------------------------------------

    final normalizedRecord =
        _legacyRecordPer100g(food);

    final multiplier =
        quantity / nutritionReferenceGrams;

    return normalizedRecord.scale(
      multiplier,
    );
  }

  // ============================================================
  // LEGACY RECORD — NORMALIZED TO 100 g
  // ============================================================
  //
  // Existing FoodModel nutrition can be based on its
  // servingSize.
  //
  // Example:
  //
  //   servingSize = 40 g
  //   calories = 110 kcal
  //
  // Convert:
  //
  //   110 × 100 / 40 = 275 kcal / 100 g
  //
  // This keeps the old 180-food database working while the
  // detailed NutritionData layer is progressively populated.
  // ============================================================

  static NutritionRecord _legacyRecordPer100g(
    FoodModel food,
  ) {
    if (food.servingSize <= 0) {
      return _emptyRecord();
    }

    final multiplier =
        nutritionReferenceGrams /
            food.servingSize;

    return NutritionRecord(
      calories:
          food.calories * multiplier,

      protein:
          food.protein * multiplier,

      carbohydrates:
          food.carbohydrates * multiplier,

      fats:
          food.fats * multiplier,

      fiber:
          food.fiber * multiplier,

      sugar:
          food.sugar * multiplier,

      addedSugar:
          food.addedSugar * multiplier,

      saturatedFat:
          food.saturatedFat * multiplier,

      transFat:
          food.transFat * multiplier,

      cholesterol:
          food.cholesterol * multiplier,

      sodium:
          food.sodium * multiplier,

      potassium:
          food.potassium * multiplier,

      calcium:
          food.calcium * multiplier,

      iron:
          food.iron * multiplier,

      magnesium:
          food.magnesium * multiplier,

      phosphorus:
          food.phosphorus * multiplier,

      zinc:
          food.zinc * multiplier,

      copper:
          food.copper * multiplier,

      manganese:
          food.manganese * multiplier,

      selenium:
          food.selenium * multiplier,

      iodine:
          food.iodine * multiplier,

      vitaminA:
          food.vitaminA * multiplier,

      vitaminC:
          food.vitaminC * multiplier,

      vitaminD:
          food.vitaminD * multiplier,

      vitaminE:
          food.vitaminE * multiplier,

      vitaminK:
          food.vitaminK * multiplier,

      vitaminB1:
          food.vitaminB1 * multiplier,

      vitaminB2:
          food.vitaminB2 * multiplier,

      vitaminB3:
          food.vitaminB3 * multiplier,

      vitaminB5:
          food.vitaminB5 * multiplier,

      vitaminB6:
          food.vitaminB6 * multiplier,

      vitaminB7:
          food.vitaminB7 * multiplier,

      vitaminB9:
          food.vitaminB9 * multiplier,

      vitaminB12:
          food.vitaminB12 * multiplier,

      preparationState:
          food.preparationState,

      source:
          food.source,

      sourceId:
          food.sourceId,

      verified:
          food.nutritionDataVerified,
    );
  }

  // ============================================================
  // EMPTY RECORD
  // ============================================================

  static NutritionRecord _emptyRecord() {
    return const NutritionRecord(
      calories: 0,
      protein: 0,
      carbohydrates: 0,
      fats: 0,
      fiber: 0,
    );
  }

  // ============================================================
  // IS VERIFIED
  // ============================================================

  static bool isVerified(
    FoodModel food,
  ) {
    final record =
        getRecord(food);

    if (record != null) {
      return record.verified;
    }

    return food.nutritionDataVerified;
  }

  // ============================================================
  // PREPARATION STATE
  // ============================================================

  static String preparationState(
    FoodModel food,
  ) {
    final record =
        getRecord(food);

    if (record != null) {
      return record.preparationState;
    }

    return food.preparationState;
  }

  // ============================================================
  // SOURCE
  // ============================================================

  static String source(
    FoodModel food,
  ) {
    final record =
        getRecord(food);

    if (record != null) {
      return record.source;
    }

    return food.source;
  }
}