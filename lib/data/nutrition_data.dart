// ============================================================
// GROWFIT NUTRITION DATA
// ============================================================
//
// This file is a separate nutrition layer.
//
// IMPORTANT:
// - Existing FoodData remains untouched.
// - Nutrition values can be upgraded independently.
// - "verified" tells the app whether the record is
//   source-backed or an estimate.
// - preparationState identifies raw/cooked/prepared form.
//
// Units:
// - calories = kcal
// - protein/carbohydrates/fats/fiber/sugars = g
// - sodium/potassium/calcium/iron/magnesium/phosphorus/
//   zinc/copper/manganese/cholesterol = mg
// - selenium/iodine/vitamin A/D/K/B7/B9/B12 = mcg
// - vitamin C/E/B1/B2/B3/B5/B6 = mg
// ============================================================

class NutritionRecord {
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fats;
  final double fiber;

  final double sugar;
  final double addedSugar;

  final double saturatedFat;
  final double transFat;
  final double cholesterol;
  final double sodium;

  final double potassium;
  final double calcium;
  final double iron;
  final double magnesium;
  final double phosphorus;
  final double zinc;
  final double copper;
  final double manganese;
  final double selenium;
  final double iodine;

  final double vitaminA;
  final double vitaminC;
  final double vitaminD;
  final double vitaminE;
  final double vitaminK;

  final double vitaminB1;
  final double vitaminB2;
  final double vitaminB3;
  final double vitaminB5;
  final double vitaminB6;
  final double vitaminB7;
  final double vitaminB9;
  final double vitaminB12;

  final String preparationState;
  final String source;
  final String? sourceId;
  final bool verified;

  const NutritionRecord({
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fats,
    required this.fiber,

    this.sugar = 0,
    this.addedSugar = 0,

    this.saturatedFat = 0,
    this.transFat = 0,
    this.cholesterol = 0,
    this.sodium = 0,

    this.potassium = 0,
    this.calcium = 0,
    this.iron = 0,
    this.magnesium = 0,
    this.phosphorus = 0,
    this.zinc = 0,
    this.copper = 0,
    this.manganese = 0,
    this.selenium = 0,
    this.iodine = 0,

    this.vitaminA = 0,
    this.vitaminC = 0,
    this.vitaminD = 0,
    this.vitaminE = 0,
    this.vitaminK = 0,

    this.vitaminB1 = 0,
    this.vitaminB2 = 0,
    this.vitaminB3 = 0,
    this.vitaminB5 = 0,
    this.vitaminB6 = 0,
    this.vitaminB7 = 0,
    this.vitaminB9 = 0,
    this.vitaminB12 = 0,

    this.preparationState = 'Standard',
    this.source = 'Not specified',
    this.sourceId,
    this.verified = false,
  });

  // ============================================================
  // SCALE NUTRITION
  // ============================================================

  NutritionRecord scale(
    double multiplier,
  ) {
    if (multiplier <= 0) {
      return const NutritionRecord(
        calories: 0,
        protein: 0,
        carbohydrates: 0,
        fats: 0,
        fiber: 0,
      );
    }

    return NutritionRecord(
      calories:
          calories * multiplier,
      protein:
          protein * multiplier,
      carbohydrates:
          carbohydrates * multiplier,
      fats:
          fats * multiplier,
      fiber:
          fiber * multiplier,

      sugar:
          sugar * multiplier,
      addedSugar:
          addedSugar * multiplier,

      saturatedFat:
          saturatedFat * multiplier,
      transFat:
          transFat * multiplier,
      cholesterol:
          cholesterol * multiplier,
      sodium:
          sodium * multiplier,

      potassium:
          potassium * multiplier,
      calcium:
          calcium * multiplier,
      iron:
          iron * multiplier,
      magnesium:
          magnesium * multiplier,
      phosphorus:
          phosphorus * multiplier,
      zinc:
          zinc * multiplier,
      copper:
          copper * multiplier,
      manganese:
          manganese * multiplier,
      selenium:
          selenium * multiplier,
      iodine:
          iodine * multiplier,

      vitaminA:
          vitaminA * multiplier,
      vitaminC:
          vitaminC * multiplier,
      vitaminD:
          vitaminD * multiplier,
      vitaminE:
          vitaminE * multiplier,
      vitaminK:
          vitaminK * multiplier,

      vitaminB1:
          vitaminB1 * multiplier,
      vitaminB2:
          vitaminB2 * multiplier,
      vitaminB3:
          vitaminB3 * multiplier,
      vitaminB5:
          vitaminB5 * multiplier,
      vitaminB6:
          vitaminB6 * multiplier,
      vitaminB7:
          vitaminB7 * multiplier,
      vitaminB9:
          vitaminB9 * multiplier,
      vitaminB12:
          vitaminB12 * multiplier,

      preparationState:
          preparationState,
      source:
          source,
      sourceId:
          sourceId,
      verified:
          verified,
    );
  }
}

// ============================================================
// NUTRITION DATA
// ============================================================

class NutritionData {
  NutritionData._();

  // ============================================================
  // RECORDS
  // ============================================================

  static const Map<String, NutritionRecord> records = {
    // ==========================================================
    // WHITE RICE — COOKED
    // Reference basis: 100 g
    // ==========================================================

    'food_001':
        NutritionRecord(
      calories: 130,
      protein: 2.69,
      carbohydrates: 28.17,
      fats: 0.28,
      fiber: 0.40,
      sugar: 0.05,

      saturatedFat: 0.077,
      transFat: 0,
      cholesterol: 0,
      sodium: 1,

      potassium: 35,
      calcium: 10,
      iron: 0.20,
      magnesium: 12,
      phosphorus: 43,
      zinc: 0.49,
      copper: 0.069,
      manganese: 0.472,
      selenium: 7.5,

      vitaminA: 0,
      vitaminC: 0,
      vitaminD: 0,
      vitaminE: 0.04,
      vitaminK: 0,

      vitaminB1: 0.020,
      vitaminB2: 0.013,
      vitaminB3: 0.400,
      vitaminB5: 0.390,
      vitaminB6: 0.093,
      vitaminB7: 0,
      vitaminB9: 3,
      vitaminB12: 0,

      preparationState: 'Cooked',
      source: 'USDA FoodData Central',
      verified: true,
    ),

    // ==========================================================
    // BROWN RICE — COOKED
    // Reference basis: 100 g
    // ==========================================================

    'food_002':
        NutritionRecord(
      calories: 123,
      protein: 2.74,
      carbohydrates: 25.58,
      fats: 0.97,
      fiber: 1.60,
      sugar: 0.24,

      saturatedFat: 0.260,
      transFat: 0,
      cholesterol: 0,
      sodium: 4,

      potassium: 86,
      calcium: 3,
      iron: 0.56,
      magnesium: 39,
      phosphorus: 103,
      zinc: 0.71,
      copper: 0.106,
      manganese: 0.974,
      selenium: 5.8,

      vitaminA: 0,
      vitaminC: 0,
      vitaminD: 0,
      vitaminE: 0.17,
      vitaminK: 0.2,

      vitaminB1: 0.177,
      vitaminB2: 0.069,
      vitaminB3: 1.493,
      vitaminB5: 0.590,
      vitaminB6: 0.123,
      vitaminB7: 0,
      vitaminB9: 9,
      vitaminB12: 0,

      preparationState: 'Cooked',
      source: 'USDA FoodData Central',
      verified: true,
    ),


        // ==========================================================
    // JEERA RICE — COOKED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_003':
        NutritionRecord(
      calories: 145,
      protein: 2.8,
      carbohydrates: 27.0,
      fats: 3.0,
      fiber: 0.8,
      sugar: 0.3,

      saturatedFat: 0.5,
      transFat: 0,
      cholesterol: 0,
      sodium: 180,

      potassium: 45,
      calcium: 12,
      iron: 0.4,
      magnesium: 13,
      phosphorus: 45,
      zinc: 0.5,
      copper: 0.07,
      manganese: 0.4,

      vitaminA: 2,
      vitaminC: 0.5,
      vitaminE: 0.2,
      vitaminK: 0.5,

      vitaminB1: 0.04,
      vitaminB2: 0.02,
      vitaminB3: 0.8,
      vitaminB5: 0.2,
      vitaminB6: 0.08,
      vitaminB9: 8,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // VEG PULAO — COOKED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_004':
        NutritionRecord(
      calories: 150,
      protein: 3.0,
      carbohydrates: 24.0,
      fats: 4.5,
      fiber: 1.8,
      sugar: 1.5,

      saturatedFat: 0.8,
      transFat: 0,
      cholesterol: 0,
      sodium: 220,

      potassium: 90,
      calcium: 20,
      iron: 0.6,
      magnesium: 18,
      phosphorus: 50,
      zinc: 0.55,
      copper: 0.08,
      manganese: 0.35,

      vitaminA: 120,
      vitaminC: 5,
      vitaminE: 0.5,
      vitaminK: 8,

      vitaminB1: 0.06,
      vitaminB2: 0.04,
      vitaminB3: 0.9,
      vitaminB5: 0.25,
      vitaminB6: 0.1,
      vitaminB9: 18,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // CHICKEN BIRYANI — COOKED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_005':
        NutritionRecord(
      calories: 165,
      protein: 7.0,
      carbohydrates: 20.0,
      fats: 6.0,
      fiber: 1.0,
      sugar: 0.8,

      saturatedFat: 1.8,
      transFat: 0.05,
      cholesterol: 25,
      sodium: 300,

      potassium: 120,
      calcium: 22,
      iron: 0.9,
      magnesium: 18,
      phosphorus: 75,
      zinc: 0.8,
      copper: 0.08,
      manganese: 0.25,

      vitaminA: 25,
      vitaminC: 1.5,
      vitaminE: 0.4,
      vitaminK: 2,

      vitaminB1: 0.06,
      vitaminB2: 0.08,
      vitaminB3: 2.2,
      vitaminB5: 0.5,
      vitaminB6: 0.15,
      vitaminB9: 12,
      vitaminB12: 0.15,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // MUTTON BIRYANI — COOKED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_006':
        NutritionRecord(
      calories: 190,
      protein: 8.0,
      carbohydrates: 19.0,
      fats: 9.0,
      fiber: 1.0,
      sugar: 0.8,

      saturatedFat: 3.0,
      transFat: 0.1,
      cholesterol: 35,
      sodium: 320,

      potassium: 125,
      calcium: 20,
      iron: 1.1,
      magnesium: 18,
      phosphorus: 85,
      zinc: 1.2,
      copper: 0.1,
      manganese: 0.25,

      vitaminA: 20,
      vitaminC: 1,
      vitaminE: 0.4,
      vitaminK: 2,

      vitaminB1: 0.06,
      vitaminB2: 0.09,
      vitaminB3: 2.4,
      vitaminB5: 0.5,
      vitaminB6: 0.15,
      vitaminB9: 10,
      vitaminB12: 0.8,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // EGG BIRYANI — COOKED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_007':
        NutritionRecord(
      calories: 175,
      protein: 7.0,
      carbohydrates: 21.0,
      fats: 6.0,
      fiber: 1.0,
      sugar: 0.8,

      saturatedFat: 1.8,
      transFat: 0.05,
      cholesterol: 75,
      sodium: 300,

      potassium: 115,
      calcium: 28,
      iron: 1.0,
      magnesium: 17,
      phosphorus: 80,
      zinc: 0.75,
      copper: 0.08,
      manganese: 0.25,

      vitaminA: 65,
      vitaminC: 1,
      vitaminD: 0.5,
      vitaminE: 0.5,
      vitaminK: 2,

      vitaminB1: 0.06,
      vitaminB2: 0.12,
      vitaminB3: 1.4,
      vitaminB5: 0.5,
      vitaminB6: 0.12,
      vitaminB9: 15,
      vitaminB12: 0.4,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // LEMON RICE — COOKED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_008':
        NutritionRecord(
      calories: 175,
      protein: 3.0,
      carbohydrates: 28.0,
      fats: 5.0,
      fiber: 1.2,
      sugar: 1.0,

      saturatedFat: 0.8,
      transFat: 0,
      cholesterol: 0,
      sodium: 180,

      potassium: 65,
      calcium: 18,
      iron: 0.6,
      magnesium: 16,
      phosphorus: 48,
      zinc: 0.5,
      copper: 0.08,
      manganese: 0.4,

      vitaminA: 5,
      vitaminC: 4,
      vitaminE: 0.5,
      vitaminK: 1,

      vitaminB1: 0.05,
      vitaminB2: 0.03,
      vitaminB3: 0.8,
      vitaminB5: 0.2,
      vitaminB6: 0.1,
      vitaminB9: 10,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // CURD RICE — PREPARED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_009':
        NutritionRecord(
      calories: 140,
      protein: 3.5,
      carbohydrates: 23.0,
      fats: 3.0,
      fiber: 0.5,
      sugar: 2.0,

      saturatedFat: 1.5,
      transFat: 0,
      cholesterol: 8,
      sodium: 45,

      potassium: 75,
      calcium: 70,
      iron: 0.25,
      magnesium: 13,
      phosphorus: 65,
      zinc: 0.5,
      copper: 0.03,
      manganese: 0.2,

      vitaminA: 25,
      vitaminC: 0.5,
      vitaminD: 0.05,
      vitaminE: 0.1,
      vitaminK: 0.5,

      vitaminB1: 0.04,
      vitaminB2: 0.1,
      vitaminB3: 0.7,
      vitaminB5: 0.3,
      vitaminB6: 0.05,
      vitaminB9: 8,
      vitaminB12: 0.2,

      preparationState: 'Prepared',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // TAMARIND RICE — COOKED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_010':
        NutritionRecord(
      calories: 180,
      protein: 3.0,
      carbohydrates: 29.0,
      fats: 5.0,
      fiber: 1.3,
      sugar: 2.0,

      saturatedFat: 0.8,
      transFat: 0,
      cholesterol: 0,
      sodium: 250,

      potassium: 80,
      calcium: 25,
      iron: 0.7,
      magnesium: 18,
      phosphorus: 50,
      zinc: 0.55,
      copper: 0.1,
      manganese: 0.45,

      vitaminA: 5,
      vitaminC: 1,
      vitaminE: 0.5,
      vitaminK: 2,

      vitaminB1: 0.05,
      vitaminB2: 0.03,
      vitaminB3: 0.8,
      vitaminB5: 0.2,
      vitaminB6: 0.1,
      vitaminB9: 10,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // COCONUT RICE — COOKED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_011':
        NutritionRecord(
      calories: 180,
      protein: 3.0,
      carbohydrates: 27.0,
      fats: 7.0,
      fiber: 1.3,
      sugar: 1.0,

      saturatedFat: 4.5,
      transFat: 0,
      cholesterol: 0,
      sodium: 160,

      potassium: 85,
      calcium: 12,
      iron: 0.7,
      magnesium: 25,
      phosphorus: 55,
      zinc: 0.6,
      copper: 0.12,
      manganese: 0.5,

      vitaminA: 0,
      vitaminC: 1,
      vitaminE: 0.3,
      vitaminK: 1,

      vitaminB1: 0.06,
      vitaminB2: 0.03,
      vitaminB3: 0.9,
      vitaminB5: 0.25,
      vitaminB6: 0.1,
      vitaminB9: 10,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // VEG FRIED RICE — COOKED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_012':
        NutritionRecord(
      calories: 170,
      protein: 3.5,
      carbohydrates: 27.0,
      fats: 5.0,
      fiber: 1.5,
      sugar: 1.5,

      saturatedFat: 0.8,
      transFat: 0,
      cholesterol: 0,
      sodium: 350,

      potassium: 100,
      calcium: 18,
      iron: 0.7,
      magnesium: 18,
      phosphorus: 55,
      zinc: 0.55,
      copper: 0.08,
      manganese: 0.35,

      vitaminA: 90,
      vitaminC: 5,
      vitaminE: 0.5,
      vitaminK: 7,

      vitaminB1: 0.06,
      vitaminB2: 0.04,
      vitaminB3: 1.0,
      vitaminB5: 0.25,
      vitaminB6: 0.12,
      vitaminB9: 18,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // EGG FRIED RICE — COOKED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_013':
        NutritionRecord(
      calories: 190,
      protein: 5.0,
      carbohydrates: 25.0,
      fats: 7.0,
      fiber: 1.0,
      sugar: 1.0,

      saturatedFat: 1.5,
      transFat: 0.05,
      cholesterol: 65,
      sodium: 350,

      potassium: 90,
      calcium: 25,
      iron: 0.8,
      magnesium: 16,
      phosphorus: 75,
      zinc: 0.7,
      copper: 0.08,
      manganese: 0.3,

      vitaminA: 55,
      vitaminC: 1.5,
      vitaminD: 0.4,
      vitaminE: 0.5,
      vitaminK: 2,

      vitaminB1: 0.06,
      vitaminB2: 0.1,
      vitaminB3: 1.1,
      vitaminB5: 0.4,
      vitaminB6: 0.1,
      vitaminB9: 14,
      vitaminB12: 0.35,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // SCHEZWAN RICE — COOKED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_014':
        NutritionRecord(
      calories: 180,
      protein: 4.0,
      carbohydrates: 26.0,
      fats: 6.0,
      fiber: 1.5,
      sugar: 2.0,

      saturatedFat: 1.0,
      transFat: 0,
      cholesterol: 0,
      sodium: 500,

      potassium: 100,
      calcium: 20,
      iron: 0.7,
      magnesium: 18,
      phosphorus: 55,
      zinc: 0.55,
      copper: 0.08,
      manganese: 0.35,

      vitaminA: 80,
      vitaminC: 5,
      vitaminE: 0.5,
      vitaminK: 6,

      vitaminB1: 0.06,
      vitaminB2: 0.04,
      vitaminB3: 1.0,
      vitaminB5: 0.25,
      vitaminB6: 0.12,
      vitaminB9: 15,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // DAL KHICHDI — COOKED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_015':
        NutritionRecord(
      calories: 120,
      protein: 4.5,
      carbohydrates: 20.0,
      fats: 2.0,
      fiber: 2.0,
      sugar: 0.8,

      saturatedFat: 0.5,
      transFat: 0,
      cholesterol: 0,
      sodium: 120,

      potassium: 130,
      calcium: 25,
      iron: 1.0,
      magnesium: 25,
      phosphorus: 70,
      zinc: 0.7,
      copper: 0.12,
      manganese: 0.3,

      vitaminA: 30,
      vitaminC: 2,
      vitaminE: 0.2,
      vitaminK: 2,

      vitaminB1: 0.08,
      vitaminB2: 0.04,
      vitaminB3: 0.8,
      vitaminB5: 0.25,
      vitaminB6: 0.1,
      vitaminB9: 25,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // VEGETABLE KHICHDI — COOKED
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_016':
        NutritionRecord(
      calories: 110,
      protein: 4.0,
      carbohydrates: 19.0,
      fats: 1.8,
      fiber: 2.5,
      sugar: 1.2,

      saturatedFat: 0.4,
      transFat: 0,
      cholesterol: 0,
      sodium: 110,

      potassium: 150,
      calcium: 28,
      iron: 1.0,
      magnesium: 26,
      phosphorus: 65,
      zinc: 0.65,
      copper: 0.12,
      manganese: 0.3,

      vitaminA: 100,
      vitaminC: 5,
      vitaminE: 0.3,
      vitaminK: 8,

      vitaminB1: 0.08,
      vitaminB2: 0.05,
      vitaminB3: 0.75,
      vitaminB5: 0.25,
      vitaminB6: 0.12,
      vitaminB9: 28,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // ROTI
    // Reference basis: 1 piece / 40 g
    // Estimated reference value
    // ==========================================================

    'food_017':
        NutritionRecord(
      calories: 110,
      protein: 3.5,
      carbohydrates: 18.0,
      fats: 2.5,
      fiber: 2.5,
      sugar: 0.5,

      saturatedFat: 0.4,
      transFat: 0,
      cholesterol: 0,
      sodium: 120,

      potassium: 90,
      calcium: 14,
      iron: 1.2,
      magnesium: 25,
      phosphorus: 70,
      zinc: 0.6,
      copper: 0.1,
      manganese: 0.5,

      vitaminE: 0.2,
      vitaminK: 0.5,

      vitaminB1: 0.08,
      vitaminB2: 0.03,
      vitaminB3: 1.0,
      vitaminB5: 0.15,
      vitaminB6: 0.08,
      vitaminB9: 12,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // CHAPATI
    // Reference basis: 1 piece / 40 g
    // Estimated reference value
    // ==========================================================

    'food_018':
        NutritionRecord(
      calories: 104,
      protein: 3.0,
      carbohydrates: 18.0,
      fats: 2.0,
      fiber: 2.5,
      sugar: 0.4,

      saturatedFat: 0.3,
      transFat: 0,
      cholesterol: 0,
      sodium: 110,

      potassium: 85,
      calcium: 14,
      iron: 1.1,
      magnesium: 24,
      phosphorus: 65,
      zinc: 0.55,
      copper: 0.09,
      manganese: 0.45,

      vitaminE: 0.15,
      vitaminK: 0.4,

      vitaminB1: 0.07,
      vitaminB2: 0.03,
      vitaminB3: 0.9,
      vitaminB5: 0.15,
      vitaminB6: 0.07,
      vitaminB9: 11,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // NAAN
    // Reference basis: 1 piece / 90 g
    // Estimated reference value
    // ==========================================================

    'food_019':
        NutritionRecord(
      calories: 260,
      protein: 8.0,
      carbohydrates: 45.0,
      fats: 5.0,
      fiber: 2.0,
      sugar: 3.0,

      saturatedFat: 1.5,
      transFat: 0.05,
      cholesterol: 5,
      sodium: 450,

      potassium: 110,
      calcium: 55,
      iron: 2.0,
      magnesium: 22,
      phosphorus: 85,
      zinc: 0.8,
      copper: 0.1,
      manganese: 0.4,

      vitaminA: 15,
      vitaminE: 0.4,
      vitaminK: 1,

      vitaminB1: 0.15,
      vitaminB2: 0.1,
      vitaminB3: 2.0,
      vitaminB5: 0.4,
      vitaminB6: 0.12,
      vitaminB9: 35,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // BUTTER NAAN
    // Reference basis: 1 piece / 90 g
    // Estimated reference value
    // ==========================================================

    'food_020':
        NutritionRecord(
      calories: 310,
      protein: 8.0,
      carbohydrates: 44.0,
      fats: 10.0,
      fiber: 2.0,
      sugar: 3.0,

      saturatedFat: 4.5,
      transFat: 0.15,
      cholesterol: 20,
      sodium: 470,

      potassium: 110,
      calcium: 55,
      iron: 2.0,
      magnesium: 22,
      phosphorus: 90,
      zinc: 0.8,
      copper: 0.1,
      manganese: 0.4,

      vitaminA: 70,
      vitaminD: 0.1,
      vitaminE: 0.5,
      vitaminK: 1.5,

      vitaminB1: 0.15,
      vitaminB2: 0.1,
      vitaminB3: 2.0,
      vitaminB5: 0.4,
      vitaminB6: 0.12,
      vitaminB9: 35,
      vitaminB12: 0.1,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // GARLIC NAAN
    // Reference basis: 1 piece / 90 g
    // Estimated reference value
    // ==========================================================

    'food_021':
        NutritionRecord(
      calories: 290,
      protein: 8.0,
      carbohydrates: 43.0,
      fats: 8.0,
      fiber: 2.0,
      sugar: 2.5,

      saturatedFat: 3.0,
      transFat: 0.1,
      cholesterol: 12,
      sodium: 450,

      potassium: 125,
      calcium: 55,
      iron: 2.0,
      magnesium: 23,
      phosphorus: 90,
      zinc: 0.8,
      copper: 0.1,
      manganese: 0.4,

      vitaminA: 45,
      vitaminC: 1,
      vitaminE: 0.4,
      vitaminK: 2,

      vitaminB1: 0.16,
      vitaminB2: 0.1,
      vitaminB3: 2.0,
      vitaminB5: 0.4,
      vitaminB6: 0.15,
      vitaminB9: 35,
      vitaminB12: 0.08,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // TANDOORI ROTI
    // Reference basis: 1 piece / 50 g
    // Estimated reference value
    // ==========================================================

    'food_022':
        NutritionRecord(
      calories: 120,
      protein: 3.5,
      carbohydrates: 22.0,
      fats: 1.5,
      fiber: 2.5,
      sugar: 0.5,

      saturatedFat: 0.2,
      transFat: 0,
      cholesterol: 0,
      sodium: 150,

      potassium: 95,
      calcium: 16,
      iron: 1.4,
      magnesium: 27,
      phosphorus: 75,
      zinc: 0.65,
      copper: 0.1,
      manganese: 0.5,

      vitaminE: 0.15,
      vitaminK: 0.5,

      vitaminB1: 0.09,
      vitaminB2: 0.03,
      vitaminB3: 1.1,
      vitaminB5: 0.18,
      vitaminB6: 0.08,
      vitaminB9: 14,

      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // BHATURA
    // Reference basis: 1 piece / 90 g
    // Estimated reference value
    // ==========================================================

    'food_023':
        NutritionRecord(
      calories: 300,
      protein: 7.0,
      carbohydrates: 42.0,
      fats: 11.0,
      fiber: 2.0,
      sugar: 2.0,

      saturatedFat: 2.5,
      transFat: 0.1,
      cholesterol: 5,
      sodium: 350,

      potassium: 100,
      calcium: 40,
      iron: 1.8,
      magnesium: 20,
      phosphorus: 80,
      zinc: 0.7,
      copper: 0.08,
      manganese: 0.3,

      vitaminA: 10,
      vitaminE: 1.0,
      vitaminK: 1,

      vitaminB1: 0.12,
      vitaminB2: 0.08,
      vitaminB3: 1.8,
      vitaminB5: 0.35,
      vitaminB6: 0.1,
      vitaminB9: 25,

      preparationState: 'Fried',
      source: 'Estimated reference value',
      verified: false,
    ),
    // ==========================================================
    // TOOR DAL — COOKED
    // Reference basis: 100 g
    //
    // Marked estimate until mapped to the exact IFCT record/form.
    // ==========================================================

    // ==========================================================
    // FOOD 024 — TOOR DAL
    // Reference basis: 100 g cooked
    // Marked unverified until mapped to an exact applicable
    // ICMR-NIN IFCT preparation.
    // ==========================================================

    'food_024':
        NutritionRecord(
      calories: 116,
      protein: 7.0,
      carbohydrates: 20.0,
      fats: 0.4,
      fiber: 4.0,
      sugar: 1.0,
      saturatedFat: 0,
      transFat: 0,
      cholesterol: 0,
      sodium: 2,
      potassium: 139,
      calcium: 27,
      iron: 1.8,
      magnesium: 48,
      phosphorus: 112,
      zinc: 1.0,
      copper: 0.20,
      manganese: 0.50,
      preparationState: 'Cooked',
      source: 'ICMR-NIN IFCT 2017 / reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 025 — MOONG DAL
    // Reference basis: 100 g cooked
    // USDA FoodData Central
    // ==========================================================

    'food_025':
        NutritionRecord(
      calories: 105,
      protein: 7.02,
      carbohydrates: 19.15,
      fats: 0.38,
      fiber: 7.60,
      sugar: 2.0,
      saturatedFat: 0.05,
      transFat: 0,
      cholesterol: 0,
      sodium: 2,
      potassium: 266,
      calcium: 27,
      iron: 1.40,
      magnesium: 48,
      phosphorus: 99,
      zinc: 0.84,
      copper: 0.21,
      manganese: 0.26,
      selenium: 2.5,
      vitaminB1: 0.16,
      vitaminB2: 0.06,
      vitaminB3: 0.58,
      vitaminB6: 0.19,
      vitaminB9: 159,
      preparationState: 'Cooked',
      source: 'USDA FoodData Central',
      verified: true,
    ),

    // ==========================================================
    // FOOD 026 — CHANA DAL
    // Reference basis: 100 g cooked
    // Kept unverified because preparation-specific values vary.
    // ==========================================================

    'food_026':
        NutritionRecord(
      calories: 120,
      protein: 7.0,
      carbohydrates: 20.0,
      fats: 2.0,
      fiber: 5.0,
      sugar: 1.3,
      saturatedFat: 0.3,
      transFat: 0,
      cholesterol: 0,
      sodium: 2,
      potassium: 291,
      calcium: 49,
      iron: 2.1,
      magnesium: 48,
      phosphorus: 168,
      zinc: 1.53,
      copper: 0.35,
      manganese: 0.70,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 027 — DAL TADKA
    // Reference basis: 100 g prepared
    // Recipe-dependent.
    // ==========================================================

    'food_027':
        NutritionRecord(
      calories: 110,
      protein: 7.0,
      carbohydrates: 14.0,
      fats: 3.0,
      fiber: 4.0,
      sugar: 1.0,
      saturatedFat: 0.5,
      transFat: 0,
      cholesterol: 0,
      sodium: 250,
      potassium: 180,
      calcium: 25,
      iron: 1.5,
      magnesium: 30,
      phosphorus: 90,
      zinc: 0.8,
      copper: 0.15,
      manganese: 0.40,
      preparationState: 'Prepared',
      source: 'Estimated standard Indian preparation',
      verified: false,
    ),

    // ==========================================================
    // FOOD 028 — DAL FRY
    // Reference basis: 100 g prepared
    // Recipe-dependent.
    // ==========================================================

    'food_028':
        NutritionRecord(
      calories: 125,
      protein: 7.0,
      carbohydrates: 15.0,
      fats: 4.0,
      fiber: 4.0,
      sugar: 1.0,
      saturatedFat: 0.7,
      transFat: 0,
      cholesterol: 0,
      sodium: 250,
      potassium: 180,
      calcium: 25,
      iron: 1.5,
      magnesium: 30,
      phosphorus: 90,
      zinc: 0.8,
      copper: 0.15,
      manganese: 0.40,
      preparationState: 'Prepared',
      source: 'Estimated standard Indian preparation',
      verified: false,
    ),

    // ==========================================================
    // FOOD 029 — DAL MAKHANI
    // Reference basis: 100 g prepared
    // Recipe-dependent because cream/butter/oil vary.
    // ==========================================================

    'food_029':
        NutritionRecord(
      calories: 140,
      protein: 7.0,
      carbohydrates: 15.0,
      fats: 6.0,
      fiber: 4.0,
      sugar: 1.5,
      saturatedFat: 2.5,
      transFat: 0,
      cholesterol: 10,
      sodium: 250,
      potassium: 200,
      calcium: 35,
      iron: 1.7,
      magnesium: 35,
      phosphorus: 100,
      zinc: 0.9,
      copper: 0.18,
      manganese: 0.45,
      preparationState: 'Prepared',
      source: 'Estimated standard Indian preparation',
      verified: false,
    ),

    // ==========================================================
    // FOOD 030 — RAJMA
    // Reference basis: 100 g cooked
    // USDA FoodData Central
    // ==========================================================

    'food_030':
        NutritionRecord(
      calories: 127,
      protein: 8.67,
      carbohydrates: 22.8,
      fats: 0.50,
      fiber: 7.40,
      sugar: 0.32,
      saturatedFat: 0.07,
      transFat: 0,
      cholesterol: 0,
      sodium: 2,
      potassium: 403,
      calcium: 28,
      iron: 2.94,
      magnesium: 45,
      phosphorus: 142,
      zinc: 1.07,
      copper: 0.242,
      manganese: 0.477,
      selenium: 1.2,
      vitaminC: 1.2,
      vitaminE: 0.03,
      vitaminK: 8.4,
      vitaminB1: 0.16,
      vitaminB2: 0.058,
      vitaminB3: 0.578,
      vitaminB6: 0.12,
      vitaminB9: 130,
      preparationState: 'Cooked',
      source: 'USDA FoodData Central',
      verified: true,
    ),

    // ==========================================================
    // FOOD 031 — CHOLE
    // Reference basis: 100 g cooked
    // USDA FoodData Central
    // ==========================================================

    'food_031':
        NutritionRecord(
      calories: 164,
      protein: 8.86,
      carbohydrates: 27.42,
      fats: 2.59,
      fiber: 7.60,
      sugar: 4.80,
      saturatedFat: 0.27,
      transFat: 0,
      cholesterol: 0,
      sodium: 7,
      potassium: 291,
      calcium: 49,
      iron: 2.89,
      magnesium: 48,
      phosphorus: 168,
      zinc: 1.53,
      copper: 0.656,
      manganese: 1.03,
      selenium: 3.7,
      vitaminA: 1,
      vitaminC: 1.3,
      vitaminE: 0.35,
      vitaminK: 4,
      vitaminB1: 0.116,
      vitaminB2: 0.063,
      vitaminB3: 0.526,
      vitaminB6: 0.139,
      vitaminB9: 172,
      preparationState: 'Cooked',
      source: 'USDA FoodData Central',
      verified: true,
    ),

    // ==========================================================
    // FOOD 032 — KADHI
    // Reference basis: 100 g prepared
    // Recipe-dependent: yogurt, besan and oil proportions vary.
    // ==========================================================

    'food_032':
        NutritionRecord(
      calories: 120,
      protein: 4.0,
      carbohydrates: 10.0,
      fats: 7.0,
      fiber: 1.0,
      sugar: 2.0,
      saturatedFat: 2.0,
      transFat: 0,
      cholesterol: 8,
      sodium: 250,
      potassium: 130,
      calcium: 70,
      iron: 0.7,
      magnesium: 15,
      phosphorus: 70,
      zinc: 0.5,
      copper: 0.05,
      manganese: 0.15,
      vitaminA: 35,
      vitaminC: 1.0,
      vitaminD: 0.05,
      vitaminE: 0.2,
      vitaminK: 1.0,
      vitaminB1: 0.05,
      vitaminB2: 0.10,
      vitaminB3: 0.6,
      vitaminB5: 0.3,
      vitaminB6: 0.05,
      vitaminB9: 12,
      vitaminB12: 0.2,
      preparationState: 'Prepared',
      source: 'Estimated standard Indian preparation',
      verified: false,
    ),


    'food_033':
        NutritionRecord(
      calories: 77,
      protein: 2.0,
      carbohydrates: 17.5,
      fats: 0.1,
      fiber: 2.2,
      sugar: 0.8,

      sodium: 6,
      potassium: 425,
      calcium: 12,
      iron: 0.81,
      magnesium: 23,
      phosphorus: 57,
      zinc: 0.30,
      copper: 0.11,
      manganese: 0.15,

      vitaminC: 19.7,
      vitaminB1: 0.081,
      vitaminB2: 0.032,
      vitaminB3: 1.061,
      vitaminB5: 0.296,
      vitaminB6: 0.298,
      vitaminB9: 15,

      preparationState: 'Raw',
      source: 'USDA FoodData Central',
      verified: true,
    ),

    // ==========================================================
    // CARROT — RAW
    // ==========================================================

    'food_034':
        NutritionRecord(
      calories: 41,
      protein: 0.93,
      carbohydrates: 9.58,
      fats: 0.24,
      fiber: 2.8,
      sugar: 4.74,

      sodium: 69,
      potassium: 320,
      calcium: 33,
      iron: 0.30,
      magnesium: 12,
      phosphorus: 35,
      zinc: 0.24,
      copper: 0.045,
      manganese: 0.143,

      vitaminA: 835,
      vitaminC: 5.9,
      vitaminE: 0.66,
      vitaminK: 13.2,

      vitaminB1: 0.066,
      vitaminB2: 0.058,
      vitaminB3: 0.983,
      vitaminB5: 0.273,
      vitaminB6: 0.138,
      vitaminB9: 19,

      preparationState: 'Raw',
      source: 'USDA FoodData Central',
      verified: true,
    ),

    // ==========================================================
    // SPINACH — RAW
    // ==========================================================

    'food_035':
        NutritionRecord(
      calories: 23,
      protein: 2.86,
      carbohydrates: 3.63,
      fats: 0.39,
      fiber: 2.2,
      sugar: 0.42,

      sodium: 79,
      potassium: 558,
      calcium: 99,
      iron: 2.71,
      magnesium: 79,
      phosphorus: 49,
      zinc: 0.53,
      copper: 0.130,
      manganese: 0.897,

      vitaminA: 469,
      vitaminC: 28.1,
      vitaminE: 2.03,
      vitaminK: 482.9,

      vitaminB1: 0.078,
      vitaminB2: 0.189,
      vitaminB3: 0.724,
      vitaminB5: 0.065,
      vitaminB6: 0.195,
      vitaminB9: 194,

      preparationState: 'Raw',
      source: 'USDA FoodData Central',
      verified: true,
    ),

    // ==========================================================
    // TOMATO — RAW
    // ==========================================================

    'food_036':
        NutritionRecord(
      calories: 18,
      protein: 0.88,
      carbohydrates: 3.89,
      fats: 0.20,
      fiber: 1.2,
      sugar: 2.63,

      sodium: 5,
      potassium: 237,
      calcium: 10,
      iron: 0.27,
      magnesium: 11,
      phosphorus: 24,
      zinc: 0.17,
      copper: 0.059,
      manganese: 0.114,

      vitaminA: 42,
      vitaminC: 13.7,
      vitaminE: 0.54,
      vitaminK: 7.9,

      vitaminB1: 0.037,
      vitaminB2: 0.020,
      vitaminB3: 0.594,
      vitaminB5: 0.089,
      vitaminB6: 0.080,
      vitaminB9: 15,

      preparationState: 'Raw',
      source: 'USDA FoodData Central',
      verified: true,
    ),
        // ==========================================================
    // CABBAGE — RAW
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_037':
        NutritionRecord(
      calories: 25,
      protein: 1.28,
      carbohydrates: 5.8,
      fats: 0.1,
      fiber: 2.5,
      sugar: 3.2,

      saturatedFat: 0.02,
      transFat: 0,
      cholesterol: 0,
      sodium: 18,

      potassium: 170,
      calcium: 40,
      iron: 0.47,
      magnesium: 12,
      phosphorus: 26,
      zinc: 0.18,
      copper: 0.019,
      manganese: 0.16,

      vitaminA: 5,
      vitaminC: 36.6,
      vitaminE: 0.15,
      vitaminK: 76,

      vitaminB1: 0.061,
      vitaminB2: 0.040,
      vitaminB3: 0.234,
      vitaminB5: 0.212,
      vitaminB6: 0.124,
      vitaminB9: 43,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // CAULIFLOWER — RAW
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_038':
        NutritionRecord(
      calories: 25,
      protein: 1.92,
      carbohydrates: 4.97,
      fats: 0.28,
      fiber: 2.0,
      sugar: 1.91,

      saturatedFat: 0.13,
      transFat: 0,
      cholesterol: 0,
      sodium: 30,

      potassium: 299,
      calcium: 22,
      iron: 0.42,
      magnesium: 15,
      phosphorus: 44,
      zinc: 0.27,
      copper: 0.039,
      manganese: 0.155,

      vitaminA: 0,
      vitaminC: 48.2,
      vitaminE: 0.08,
      vitaminK: 15.5,

      vitaminB1: 0.05,
      vitaminB2: 0.06,
      vitaminB3: 0.507,
      vitaminB5: 0.667,
      vitaminB6: 0.184,
      vitaminB9: 57,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // BROCCOLI — RAW
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_039':
        NutritionRecord(
      calories: 34,
      protein: 2.82,
      carbohydrates: 6.64,
      fats: 0.37,
      fiber: 2.6,
      sugar: 1.7,

      saturatedFat: 0.114,
      transFat: 0,
      cholesterol: 0,
      sodium: 33,

      potassium: 316,
      calcium: 47,
      iron: 0.73,
      magnesium: 21,
      phosphorus: 66,
      zinc: 0.41,
      copper: 0.049,
      manganese: 0.21,

      vitaminA: 31,
      vitaminC: 89.2,
      vitaminE: 0.78,
      vitaminK: 101.6,

      vitaminB1: 0.071,
      vitaminB2: 0.117,
      vitaminB3: 0.639,
      vitaminB5: 0.573,
      vitaminB6: 0.175,
      vitaminB9: 63,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // CUCUMBER — RAW
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_040':
        NutritionRecord(
      calories: 15,
      protein: 0.65,
      carbohydrates: 3.63,
      fats: 0.11,
      fiber: 0.5,
      sugar: 1.67,

      saturatedFat: 0.037,
      transFat: 0,
      cholesterol: 0,
      sodium: 2,

      potassium: 147,
      calcium: 16,
      iron: 0.28,
      magnesium: 13,
      phosphorus: 24,
      zinc: 0.20,
      copper: 0.041,
      manganese: 0.079,

      vitaminA: 5,
      vitaminC: 2.8,
      vitaminE: 0.03,
      vitaminK: 16.4,

      vitaminB1: 0.027,
      vitaminB2: 0.033,
      vitaminB3: 0.098,
      vitaminB5: 0.259,
      vitaminB6: 0.04,
      vitaminB9: 7,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // ONION — RAW
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_041':
        NutritionRecord(
      calories: 40,
      protein: 1.1,
      carbohydrates: 9.34,
      fats: 0.1,
      fiber: 1.7,
      sugar: 4.24,

      saturatedFat: 0.042,
      transFat: 0,
      cholesterol: 0,
      sodium: 4,

      potassium: 146,
      calcium: 23,
      iron: 0.21,
      magnesium: 10,
      phosphorus: 29,
      zinc: 0.17,
      copper: 0.039,
      manganese: 0.129,

      vitaminA: 0,
      vitaminC: 7.4,
      vitaminE: 0.02,
      vitaminK: 0.4,

      vitaminB1: 0.046,
      vitaminB2: 0.027,
      vitaminB3: 0.116,
      vitaminB5: 0.123,
      vitaminB6: 0.12,
      vitaminB9: 19,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // CAPSICUM — RAW
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_042':
        NutritionRecord(
      calories: 31,
      protein: 1.0,
      carbohydrates: 6.0,
      fats: 0.3,
      fiber: 2.1,
      sugar: 4.2,

      saturatedFat: 0.03,
      transFat: 0,
      cholesterol: 0,
      sodium: 4,

      potassium: 211,
      calcium: 7,
      iron: 0.43,
      magnesium: 12,
      phosphorus: 26,
      zinc: 0.25,
      copper: 0.066,
      manganese: 0.112,

      vitaminA: 157,
      vitaminC: 80.4,
      vitaminE: 0.37,
      vitaminK: 7.4,

      vitaminB1: 0.054,
      vitaminB2: 0.085,
      vitaminB3: 0.979,
      vitaminB5: 0.099,
      vitaminB6: 0.224,
      vitaminB9: 46,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // BRINJAL / EGGPLANT — RAW
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_043':
        NutritionRecord(
      calories: 25,
      protein: 0.98,
      carbohydrates: 5.88,
      fats: 0.18,
      fiber: 3.0,
      sugar: 3.53,

      saturatedFat: 0.034,
      transFat: 0,
      cholesterol: 0,
      sodium: 2,

      potassium: 229,
      calcium: 9,
      iron: 0.23,
      magnesium: 14,
      phosphorus: 24,
      zinc: 0.16,
      copper: 0.081,
      manganese: 0.232,

      vitaminA: 1,
      vitaminC: 2.2,
      vitaminE: 0.3,
      vitaminK: 3.5,

      vitaminB1: 0.039,
      vitaminB2: 0.037,
      vitaminB3: 0.649,
      vitaminB5: 0.281,
      vitaminB6: 0.084,
      vitaminB9: 22,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // LADY'S FINGER / OKRA — RAW
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_044':
        NutritionRecord(
      calories: 33,
      protein: 1.93,
      carbohydrates: 7.45,
      fats: 0.19,
      fiber: 3.2,
      sugar: 1.48,

      saturatedFat: 0.045,
      transFat: 0,
      cholesterol: 0,
      sodium: 7,

      potassium: 299,
      calcium: 82,
      iron: 0.62,
      magnesium: 57,
      phosphorus: 61,
      zinc: 0.58,
      copper: 0.109,
      manganese: 0.788,

      vitaminA: 36,
      vitaminC: 23,
      vitaminE: 0.27,
      vitaminK: 31.3,

      vitaminB1: 0.2,
      vitaminB2: 0.06,
      vitaminB3: 1.0,
      vitaminB5: 0.245,
      vitaminB6: 0.215,
      vitaminB9: 60,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // BOTTLE GOURD — RAW
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_045':
        NutritionRecord(
      calories: 14,
      protein: 0.62,
      carbohydrates: 3.4,
      fats: 0.02,
      fiber: 0.5,
      sugar: 1.2,

      saturatedFat: 0.005,
      transFat: 0,
      cholesterol: 0,
      sodium: 2,

      potassium: 150,
      calcium: 26,
      iron: 0.2,
      magnesium: 11,
      phosphorus: 13,
      zinc: 0.12,
      copper: 0.026,
      manganese: 0.08,

      vitaminA: 2,
      vitaminC: 10.1,
      vitaminE: 0.01,
      vitaminK: 0.3,

      vitaminB1: 0.029,
      vitaminB2: 0.022,
      vitaminB3: 0.32,
      vitaminB5: 0.15,
      vitaminB6: 0.04,
      vitaminB9: 6,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // BITTER GOURD — RAW
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_046':
        NutritionRecord(
      calories: 17,
      protein: 1.0,
      carbohydrates: 3.7,
      fats: 0.17,
      fiber: 2.8,
      sugar: 0.6,

      saturatedFat: 0.03,
      transFat: 0,
      cholesterol: 0,
      sodium: 5,

      potassium: 296,
      calcium: 19,
      iron: 0.43,
      magnesium: 17,
      phosphorus: 31,
      zinc: 0.8,
      copper: 0.034,
      manganese: 0.089,

      vitaminA: 24,
      vitaminC: 84,
      vitaminE: 0.7,
      vitaminK: 4.8,

      vitaminB1: 0.04,
      vitaminB2: 0.04,
      vitaminB3: 0.4,
      vitaminB5: 0.19,
      vitaminB6: 0.043,
      vitaminB9: 72,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // DRUMSTICK / MORINGA POD — RAW
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_047':
        NutritionRecord(
      calories: 37,
      protein: 2.1,
      carbohydrates: 8.5,
      fats: 0.2,
      fiber: 3.2,
      sugar: 1.6,

      saturatedFat: 0.05,
      transFat: 0,
      cholesterol: 0,
      sodium: 42,

      potassium: 461,
      calcium: 30,
      iron: 0.36,
      magnesium: 45,
      phosphorus: 50,
      zinc: 0.45,
      copper: 0.11,
      manganese: 0.26,

      vitaminA: 4,
      vitaminC: 141,
      vitaminE: 0.3,
      vitaminK: 0.8,

      vitaminB1: 0.05,
      vitaminB2: 0.07,
      vitaminB3: 0.62,
      vitaminB5: 0.79,
      vitaminB6: 0.12,
      vitaminB9: 44,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // SWEET CORN — RAW
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_048':
        NutritionRecord(
      calories: 86,
      protein: 3.27,
      carbohydrates: 18.7,
      fats: 1.35,
      fiber: 2.0,
      sugar: 6.26,

      saturatedFat: 0.23,
      transFat: 0,
      cholesterol: 0,
      sodium: 15,

      potassium: 270,
      calcium: 2,
      iron: 0.52,
      magnesium: 37,
      phosphorus: 89,
      zinc: 0.46,
      copper: 0.054,
      manganese: 0.163,

      vitaminA: 9,
      vitaminC: 6.8,
      vitaminE: 0.07,
      vitaminK: 0.3,

      vitaminB1: 0.155,
      vitaminB2: 0.055,
      vitaminB3: 1.77,
      vitaminB5: 0.717,
      vitaminB6: 0.093,
      vitaminB9: 42,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // BANANA
    // Reference: approximately 118 g edible portion
    // ==========================================================

    'food_049':
        NutritionRecord(
      calories: 105,
      protein: 1.30,
      carbohydrates: 27.0,
      fats: 0.39,
      fiber: 3.1,
      sugar: 14.4,

      sodium: 1,
      potassium: 422,
      calcium: 6,
      iron: 0.31,
      magnesium: 32,
      phosphorus: 26,
      zinc: 0.18,
      copper: 0.092,
      manganese: 0.319,

      vitaminC: 10.3,
      vitaminA: 4,
      vitaminE: 0.12,
      vitaminK: 0.6,

      vitaminB1: 0.037,
      vitaminB2: 0.086,
      vitaminB3: 0.785,
      vitaminB5: 0.394,
      vitaminB6: 0.433,
      vitaminB9: 24,

      preparationState: 'Raw',
      source: 'USDA FoodData Central',
      verified: true,
    ),

    // ==========================================================
    // APPLE
    // Reference: approximately 180 g edible portion
    // ==========================================================

    'food_050':
        NutritionRecord(
      calories: 95,
      protein: 0.47,
      carbohydrates: 25.1,
      fats: 0.31,
      fiber: 4.4,
      sugar: 18.9,

      sodium: 2,
      potassium: 195,
      calcium: 11,
      iron: 0.22,
      magnesium: 9,
      phosphorus: 20,
      zinc: 0.07,
      copper: 0.049,
      manganese: 0.047,

      vitaminC: 8.4,
      vitaminE: 0.33,
      vitaminK: 4.0,

      vitaminB1: 0.039,
      vitaminB2: 0.047,
      vitaminB3: 0.166,
      vitaminB5: 0.111,
      vitaminB6: 0.073,
      vitaminB9: 5,

      preparationState: 'Raw',
      source: 'USDA FoodData Central',
          verified: true,
    ),

  
        // ==========================================================
    // FOOD 051 — ORANGE
    // Reference basis: 100 g
    // ==========================================================

    'food_051':
        NutritionRecord(
      calories: 47,
      protein: 0.94,
      carbohydrates: 11.75,
      fats: 0.12,
      fiber: 2.4,
      sugar: 9.35,

      saturatedFat: 0.015,
      transFat: 0,
      cholesterol: 0,
      sodium: 0,

      potassium: 181,
      calcium: 40,
      iron: 0.1,
      magnesium: 10,
      phosphorus: 14,
      zinc: 0.07,
      copper: 0.045,
      manganese: 0.025,
      selenium: 0.5,
      iodine: 2,

      vitaminA: 11,
      vitaminC: 53.2,
      vitaminD: 0,
      vitaminE: 0.18,
      vitaminK: 0,

      vitaminB1: 0.087,
      vitaminB2: 0.04,
      vitaminB3: 0.282,
      vitaminB5: 0.25,
      vitaminB6: 0.06,
      vitaminB7: 0,
      vitaminB9: 34,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 052 — MANGO
    // ==========================================================

    'food_052':
        NutritionRecord(
      calories: 60,
      protein: 0.82,
      carbohydrates: 15.0,
      fats: 0.38,
      fiber: 1.6,
      sugar: 13.66,

      saturatedFat: 0.092,
      transFat: 0,
      cholesterol: 0,
      sodium: 1,

      potassium: 168,
      calcium: 11,
      iron: 0.16,
      magnesium: 10,
      phosphorus: 14,
      zinc: 0.09,
      copper: 0.111,
      manganese: 0.063,
      selenium: 0.6,
      iodine: 1,

      vitaminA: 54,
      vitaminC: 36.4,
      vitaminD: 0,
      vitaminE: 0.9,
      vitaminK: 4.2,

      vitaminB1: 0.028,
      vitaminB2: 0.038,
      vitaminB3: 0.669,
      vitaminB5: 0.197,
      vitaminB6: 0.119,
      vitaminB7: 0,
      vitaminB9: 43,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 053 — GUAVA
    // ==========================================================

    'food_053':
        NutritionRecord(
      calories: 68,
      protein: 2.55,
      carbohydrates: 14.32,
      fats: 0.95,
      fiber: 5.4,
      sugar: 8.92,

      saturatedFat: 0.272,
      transFat: 0,
      cholesterol: 0,
      sodium: 2,

      potassium: 417,
      calcium: 18,
      iron: 0.26,
      magnesium: 22,
      phosphorus: 40,
      zinc: 0.23,
      copper: 0.23,
      manganese: 0.15,
      selenium: 0.6,
      iodine: 2,

      vitaminA: 31,
      vitaminC: 228.3,
      vitaminD: 0,
      vitaminE: 0.73,
      vitaminK: 2.6,

      vitaminB1: 0.067,
      vitaminB2: 0.04,
      vitaminB3: 1.084,
      vitaminB5: 0.451,
      vitaminB6: 0.11,
      vitaminB7: 0,
      vitaminB9: 49,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 054 — PAPAYA
    // ==========================================================

    'food_054':
        NutritionRecord(
      calories: 43,
      protein: 0.47,
      carbohydrates: 10.82,
      fats: 0.26,
      fiber: 1.7,
      sugar: 7.82,

      saturatedFat: 0.081,
      transFat: 0,
      cholesterol: 0,
      sodium: 8,

      potassium: 182,
      calcium: 20,
      iron: 0.25,
      magnesium: 21,
      phosphorus: 10,
      zinc: 0.08,
      copper: 0.045,
      manganese: 0.04,
      selenium: 0.6,
      iodine: 2,

      vitaminA: 47,
      vitaminC: 60.9,
      vitaminD: 0,
      vitaminE: 0.3,
      vitaminK: 2.6,

      vitaminB1: 0.023,
      vitaminB2: 0.027,
      vitaminB3: 0.357,
      vitaminB5: 0.191,
      vitaminB6: 0.038,
      vitaminB7: 0,
      vitaminB9: 37,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 055 — WATERMELON
    // ==========================================================

    'food_055':
        NutritionRecord(
      calories: 30,
      protein: 0.61,
      carbohydrates: 7.55,
      fats: 0.15,
      fiber: 0.4,
      sugar: 6.2,

      saturatedFat: 0.016,
      transFat: 0,
      cholesterol: 0,
      sodium: 1,

      potassium: 112,
      calcium: 7,
      iron: 0.24,
      magnesium: 10,
      phosphorus: 11,
      zinc: 0.1,
      copper: 0.042,
      manganese: 0.038,
      selenium: 0.4,
      iodine: 1,

      vitaminA: 28,
      vitaminC: 8.1,
      vitaminD: 0,
      vitaminE: 0.05,
      vitaminK: 0.1,

      vitaminB1: 0.033,
      vitaminB2: 0.021,
      vitaminB3: 0.178,
      vitaminB5: 0.221,
      vitaminB6: 0.045,
      vitaminB7: 0,
      vitaminB9: 3,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 056 — MUSKMELON
    // ==========================================================

    'food_056':
        NutritionRecord(
      calories: 34,
      protein: 0.84,
      carbohydrates: 8.16,
      fats: 0.19,
      fiber: 0.9,
      sugar: 7.86,

      saturatedFat: 0.051,
      transFat: 0,
      cholesterol: 0,
      sodium: 16,

      potassium: 267,
      calcium: 9,
      iron: 0.21,
      magnesium: 12,
      phosphorus: 15,
      zinc: 0.18,
      copper: 0.04,
      manganese: 0.04,
      selenium: 0.4,
      iodine: 1,

      vitaminA: 169,
      vitaminC: 36.7,
      vitaminD: 0,
      vitaminE: 0.05,
      vitaminK: 2.7,

      vitaminB1: 0.041,
      vitaminB2: 0.019,
      vitaminB3: 0.734,
      vitaminB5: 0.105,
      vitaminB6: 0.072,
      vitaminB7: 0,
      vitaminB9: 21,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 057 — GRAPES
    // ==========================================================

    'food_057':
        NutritionRecord(
      calories: 69,
      protein: 0.72,
      carbohydrates: 18.1,
      fats: 0.16,
      fiber: 0.9,
      sugar: 15.48,

      saturatedFat: 0.054,
      transFat: 0,
      cholesterol: 0,
      sodium: 2,

      potassium: 191,
      calcium: 10,
      iron: 0.36,
      magnesium: 7,
      phosphorus: 20,
      zinc: 0.07,
      copper: 0.127,
      manganese: 0.071,
      selenium: 0.1,
      iodine: 1,

      vitaminA: 3,
      vitaminC: 3.2,
      vitaminD: 0,
      vitaminE: 0.19,
      vitaminK: 14.6,

      vitaminB1: 0.069,
      vitaminB2: 0.07,
      vitaminB3: 0.188,
      vitaminB5: 0.05,
      vitaminB6: 0.086,
      vitaminB7: 0,
      vitaminB9: 2,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 058 — POMEGRANATE
    // ==========================================================

    'food_058':
        NutritionRecord(
      calories: 83,
      protein: 1.67,
      carbohydrates: 18.7,
      fats: 1.17,
      fiber: 4.0,
      sugar: 13.67,

      saturatedFat: 0.12,
      transFat: 0,
      cholesterol: 0,
      sodium: 3,

      potassium: 236,
      calcium: 10,
      iron: 0.3,
      magnesium: 12,
      phosphorus: 36,
      zinc: 0.35,
      copper: 0.158,
      manganese: 0.119,
      selenium: 0.5,
      iodine: 1,

      vitaminA: 0,
      vitaminC: 10.2,
      vitaminD: 0,
      vitaminE: 0.6,
      vitaminK: 16.4,

      vitaminB1: 0.067,
      vitaminB2: 0.053,
      vitaminB3: 0.293,
      vitaminB5: 0.377,
      vitaminB6: 0.075,
      vitaminB7: 0,
      vitaminB9: 38,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 059 — PINEAPPLE
    // ==========================================================

    'food_059':
        NutritionRecord(
      calories: 50,
      protein: 0.54,
      carbohydrates: 13.12,
      fats: 0.12,
      fiber: 1.4,
      sugar: 9.85,

      saturatedFat: 0.009,
      transFat: 0,
      cholesterol: 0,
      sodium: 1,

      potassium: 109,
      calcium: 13,
      iron: 0.29,
      magnesium: 12,
      phosphorus: 8,
      zinc: 0.12,
      copper: 0.11,
      manganese: 0.927,
      selenium: 0.1,
      iodine: 1,

      vitaminA: 3,
      vitaminC: 47.8,
      vitaminD: 0,
      vitaminE: 0.02,
      vitaminK: 0.7,

      vitaminB1: 0.079,
      vitaminB2: 0.032,
      vitaminB3: 0.5,
      vitaminB5: 0.213,
      vitaminB6: 0.112,
      vitaminB7: 0,
      vitaminB9: 18,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 060 — CHIKOO / SAPOTA
    // ==========================================================

    'food_060':
        NutritionRecord(
      calories: 83,
      protein: 0.44,
      carbohydrates: 19.96,
      fats: 1.1,
      fiber: 5.3,
      sugar: 14.65,

      saturatedFat: 0.33,
      transFat: 0,
      cholesterol: 0,
      sodium: 12,

      potassium: 193,
      calcium: 21,
      iron: 0.8,
      magnesium: 12,
      phosphorus: 12,
      zinc: 0.1,
      copper: 0.086,
      manganese: 0.059,
      selenium: 0.6,
      iodine: 1,

      vitaminA: 3,
      vitaminC: 14.7,
      vitaminD: 0,
      vitaminE: 0.44,
      vitaminK: 2,

      vitaminB1: 0.058,
      vitaminB2: 0.02,
      vitaminB3: 0.2,
      vitaminB5: 0.252,
      vitaminB6: 0.037,
      vitaminB7: 0,
      vitaminB9: 14,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 061 — KIWI
    // ==========================================================

    'food_061':
        NutritionRecord(
      calories: 61,
      protein: 1.14,
      carbohydrates: 14.66,
      fats: 0.52,
      fiber: 3.0,
      sugar: 8.99,

      saturatedFat: 0.025,
      transFat: 0,
      cholesterol: 0,
      sodium: 3,

      potassium: 312,
      calcium: 34,
      iron: 0.31,
      magnesium: 17,
      phosphorus: 34,
      zinc: 0.14,
      copper: 0.13,
      manganese: 0.098,
      selenium: 0.2,
      iodine: 2,

      vitaminA: 4,
      vitaminC: 92.7,
      vitaminD: 0,
      vitaminE: 1.5,
      vitaminK: 40.3,

      vitaminB1: 0.027,
      vitaminB2: 0.025,
      vitaminB3: 0.341,
      vitaminB5: 0.183,
      vitaminB6: 0.063,
      vitaminB7: 0,
      vitaminB9: 25,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 062 — PEAR
    // ==========================================================

    'food_062':
        NutritionRecord(
      calories: 57,
      protein: 0.36,
      carbohydrates: 15.23,
      fats: 0.14,
      fiber: 3.1,
      sugar: 9.75,

      saturatedFat: 0.022,
      transFat: 0,
      cholesterol: 0,
      sodium: 1,

      potassium: 116,
      calcium: 9,
      iron: 0.18,
      magnesium: 7,
      phosphorus: 12,
      zinc: 0.1,
      copper: 0.082,
      manganese: 0.048,
      selenium: 0.1,
      iodine: 1,

      vitaminA: 1,
      vitaminC: 4.3,
      vitaminD: 0,
      vitaminE: 0.12,
      vitaminK: 4.4,

      vitaminB1: 0.012,
      vitaminB2: 0.026,
      vitaminB3: 0.161,
      vitaminB5: 0.049,
      vitaminB6: 0.029,
      vitaminB7: 0,
      vitaminB9: 7,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 063 — STRAWBERRY
    // ==========================================================

    'food_063':
        NutritionRecord(
      calories: 32,
      protein: 0.67,
      carbohydrates: 7.68,
      fats: 0.3,
      fiber: 2.0,
      sugar: 4.89,

      saturatedFat: 0.015,
      transFat: 0,
      cholesterol: 0,
      sodium: 1,

      potassium: 153,
      calcium: 16,
      iron: 0.41,
      magnesium: 13,
      phosphorus: 24,
      zinc: 0.14,
      copper: 0.048,
      manganese: 0.386,
      selenium: 0.4,
      iodine: 1,

      vitaminA: 1,
      vitaminC: 58.8,
      vitaminD: 0,
      vitaminE: 0.29,
      vitaminK: 2.2,

      vitaminB1: 0.024,
      vitaminB2: 0.022,
      vitaminB3: 0.386,
      vitaminB5: 0.125,
      vitaminB6: 0.047,
      vitaminB7: 0,
      vitaminB9: 24,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 064 — AMLA
    // ==========================================================

    'food_064':
        NutritionRecord(
      calories: 44,
      protein: 0.88,
      carbohydrates: 10.18,
      fats: 0.58,
      fiber: 4.3,
      sugar: 4.35,

      saturatedFat: 0.1,
      transFat: 0,
      cholesterol: 0,
      sodium: 1,

      potassium: 198,
      calcium: 25,
      iron: 0.31,
      magnesium: 10,
      phosphorus: 21,
      zinc: 0.12,
      copper: 0.07,
      manganese: 0.1,
      selenium: 0.5,
      iodine: 1,

      vitaminA: 15,
      vitaminC: 252,
      vitaminD: 0,
      vitaminE: 0.7,
      vitaminK: 0,

      vitaminB1: 0.03,
      vitaminB2: 0.01,
      vitaminB3: 0.3,
      vitaminB5: 0.2,
      vitaminB6: 0.08,
      vitaminB7: 0,
      vitaminB9: 6,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 065 — DATES
    // ==========================================================

    'food_065':
        NutritionRecord(
      calories: 282,
      protein: 2.45,
      carbohydrates: 75.0,
      fats: 0.39,
      fiber: 8.0,
      sugar: 63.35,

      saturatedFat: 0.032,
      transFat: 0,
      cholesterol: 0,
      sodium: 2,

      potassium: 656,
      calcium: 39,
      iron: 1.02,
      magnesium: 43,
      phosphorus: 62,
      zinc: 0.29,
      copper: 0.206,
      manganese: 0.262,
      selenium: 3,
      iodine: 2,

      vitaminA: 7,
      vitaminC: 0.4,
      vitaminD: 0,
      vitaminE: 0.05,
      vitaminK: 2.7,

      vitaminB1: 0.052,
      vitaminB2: 0.066,
      vitaminB3: 1.274,
      vitaminB5: 0.589,
      vitaminB6: 0.165,
      vitaminB7: 0,
      vitaminB9: 19,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 066 — JAMUN
    // ==========================================================

    'food_066':
        NutritionRecord(
      calories: 60,
      protein: 0.72,
      carbohydrates: 15.0,
      fats: 0.23,
      fiber: 0.6,
      sugar: 10.0,

      saturatedFat: 0.05,
      transFat: 0,
      cholesterol: 0,
      sodium: 1,

      potassium: 79,
      calcium: 15,
      iron: 1.4,
      magnesium: 15,
      phosphorus: 17,
      zinc: 0.2,
      copper: 0.2,
      manganese: 0.1,
      selenium: 0.5,
      iodine: 1,

      vitaminA: 3,
      vitaminC: 18,
      vitaminD: 0,
      vitaminE: 0.1,
      vitaminK: 2.6,

      vitaminB1: 0.03,
      vitaminB2: 0.01,
      vitaminB3: 0.26,
      vitaminB5: 0.16,
      vitaminB6: 0.04,
      vitaminB7: 0,
      vitaminB9: 14,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 067 — DRAGON FRUIT
    // ==========================================================

    'food_067':
        NutritionRecord(
      calories: 57,
      protein: 1.1,
      carbohydrates: 13.0,
      fats: 0.14,
      fiber: 3.0,
      sugar: 7.7,

      saturatedFat: 0.04,
      transFat: 0,
      cholesterol: 0,
      sodium: 1,

      potassium: 116,
      calcium: 18,
      iron: 0.74,
      magnesium: 40,
      phosphorus: 36,
      zinc: 0.32,
      copper: 0.08,
      manganese: 0.13,
      selenium: 0.6,
      iodine: 1,

      vitaminA: 0,
      vitaminC: 4,
      vitaminD: 0,
      vitaminE: 0.08,
      vitaminK: 0,

      vitaminB1: 0.04,
      vitaminB2: 0.05,
      vitaminB3: 0.43,
      vitaminB5: 0.25,
      vitaminB6: 0.05,
      vitaminB7: 0,
      vitaminB9: 7,
      vitaminB12: 0,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 068 — WHOLE MILK
    // Reference basis: 100 ml
    // ==========================================================

    'food_068':
        NutritionRecord(
      calories: 61,
      protein: 3.15,
      carbohydrates: 4.8,
      fats: 3.25,
      fiber: 0,
      sugar: 4.8,

      saturatedFat: 1.86,
      transFat: 0.11,
      cholesterol: 10,
      sodium: 43,

      potassium: 132,
      calcium: 113,
      iron: 0.03,
      magnesium: 10,
      phosphorus: 84,
      zinc: 0.37,
      copper: 0.01,
      manganese: 0.004,
      selenium: 3.7,
      iodine: 15,

      vitaminA: 31,
      vitaminC: 0,
      vitaminD: 0.05,
      vitaminE: 0.07,
      vitaminK: 0.3,

      vitaminB1: 0.04,
      vitaminB2: 0.18,
      vitaminB3: 0.09,
      vitaminB5: 0.37,
      vitaminB6: 0.04,
      vitaminB7: 0.5,
      vitaminB9: 5,
      vitaminB12: 0.45,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 069 — SKIM MILK
    // ==========================================================

    'food_069':
        NutritionRecord(
      calories: 34,
      protein: 3.4,
      carbohydrates: 5.0,
      fats: 0.1,
      fiber: 0,
      sugar: 5.0,

      saturatedFat: 0.06,
      transFat: 0,
      cholesterol: 2,
      sodium: 43,

      potassium: 150,
      calcium: 122,
      iron: 0.03,
      magnesium: 11,
      phosphorus: 95,
      zinc: 0.4,
      copper: 0.01,
      manganese: 0.004,
      selenium: 3.5,
      iodine: 15,

      vitaminA: 2,
      vitaminC: 0,
      vitaminD: 0.05,
      vitaminE: 0.01,
      vitaminK: 0.1,

      vitaminB1: 0.04,
      vitaminB2: 0.18,
      vitaminB3: 0.09,
      vitaminB5: 0.37,
      vitaminB6: 0.04,
      vitaminB7: 0.5,
      vitaminB9: 5,
      vitaminB12: 0.45,

      preparationState: 'Raw',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 070 — CURD
    // ==========================================================

    'food_070':
        NutritionRecord(
      calories: 61,
      protein: 3.47,
      carbohydrates: 4.66,
      fats: 3.25,
      fiber: 0,
      sugar: 4.66,

      saturatedFat: 2.1,
      transFat: 0.1,
      cholesterol: 13,
      sodium: 46,

      potassium: 155,
      calcium: 121,
      iron: 0.05,
      magnesium: 12,
      phosphorus: 95,
      zinc: 0.59,
      copper: 0.01,
      manganese: 0.01,
      selenium: 2.2,
      iodine: 20,

      vitaminA: 27,
      vitaminC: 0.5,
      vitaminD: 0.05,
      vitaminE: 0.06,
      vitaminK: 0.2,

      vitaminB1: 0.03,
      vitaminB2: 0.142,
      vitaminB3: 0.075,
      vitaminB5: 0.314,
      vitaminB6: 0.032,
      vitaminB7: 0.4,
      vitaminB9: 7,
      vitaminB12: 0.37,

      preparationState: 'Fermented',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 071 — GREEK YOGURT
    // ==========================================================

    'food_071':
        NutritionRecord(
      calories: 59,
      protein: 10.0,
      carbohydrates: 3.6,
      fats: 0.4,
      fiber: 0,
      sugar: 3.2,

      saturatedFat: 0.1,
      transFat: 0,
      cholesterol: 5,
      sodium: 36,

      potassium: 141,
      calcium: 110,
      iron: 0.05,
      magnesium: 11,
      phosphorus: 135,
      zinc: 0.5,
      copper: 0.01,
      manganese: 0.01,
      selenium: 9.7,
      iodine: 25,

      vitaminA: 2,
      vitaminC: 0.5,
      vitaminD: 0.1,
      vitaminE: 0.01,
      vitaminK: 0.1,

      vitaminB1: 0.03,
      vitaminB2: 0.14,
      vitaminB3: 0.1,
      vitaminB5: 0.6,
      vitaminB6: 0.05,
      vitaminB7: 0.4,
      vitaminB9: 7,
      vitaminB12: 0.7,

      preparationState: 'Fermented',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 072 — PANEER
    // ==========================================================

    'food_072':
        NutritionRecord(
      calories: 265,
      protein: 18.3,
      carbohydrates: 1.2,
      fats: 20.8,
      fiber: 0,
      sugar: 1.2,

      saturatedFat: 13.0,
      transFat: 0.7,
      cholesterol: 56,
      sodium: 22,

      potassium: 104,
      calcium: 208,
      iron: 2.16,
      magnesium: 8,
      phosphorus: 138,
      zinc: 2.7,
      copper: 0.02,
      manganese: 0.01,
      selenium: 14,
      iodine: 20,

      vitaminA: 210,
      vitaminC: 0,
      vitaminD: 0.4,
      vitaminE: 0.2,
      vitaminK: 2,

      vitaminB1: 0.02,
      vitaminB2: 0.2,
      vitaminB3: 0.1,
      vitaminB5: 0.2,
      vitaminB6: 0.07,
      vitaminB7: 2.5,
      vitaminB9: 6,
      vitaminB12: 1.2,

      preparationState: 'Fresh',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 073 — CHEDDAR CHEESE
    // ==========================================================

    'food_073':
        NutritionRecord(
      calories: 403,
      protein: 24.9,
      carbohydrates: 1.3,
      fats: 33.1,
      fiber: 0,
      sugar: 0.5,

      saturatedFat: 21.1,
      transFat: 1.0,
      cholesterol: 105,
      sodium: 621,

      potassium: 98,
      calcium: 721,
      iron: 0.68,
      magnesium: 28,
      phosphorus: 512,
      zinc: 3.11,
      copper: 0.03,
      manganese: 0.01,
      selenium: 28,
      iodine: 38,

      vitaminA: 265,
      vitaminC: 0,
      vitaminD: 0.6,
      vitaminE: 0.29,
      vitaminK: 2.4,

      vitaminB1: 0.03,
      vitaminB2: 0.429,
      vitaminB3: 0.04,
      vitaminB5: 0.41,
      vitaminB6: 0.07,
      vitaminB7: 2.6,
      vitaminB9: 27,
      vitaminB12: 1.1,

      preparationState: 'Fresh',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 074 — BUTTER
    // ==========================================================

    'food_074':
        NutritionRecord(
      calories: 717,
      protein: 0.85,
      carbohydrates: 0.06,
      fats: 81.11,
      fiber: 0,
      sugar: 0.06,

      saturatedFat: 51.37,
      transFat: 3.28,
      cholesterol: 215,
      sodium: 11,

      potassium: 24,
      calcium: 24,
      iron: 0.02,
      magnesium: 2,
      phosphorus: 24,
      zinc: 0.09,
      copper: 0,
      manganese: 0,
      selenium: 1,
      iodine: 2,

      vitaminA: 684,
      vitaminC: 0,
      vitaminD: 1.5,
      vitaminE: 2.32,
      vitaminK: 7,

      vitaminB1: 0.005,
      vitaminB2: 0.034,
      vitaminB3: 0.042,
      vitaminB5: 0.11,
      vitaminB6: 0.003,
      vitaminB7: 0,
      vitaminB9: 3,
      vitaminB12: 0.17,

      preparationState: 'Fresh',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 075 — GHEE
    // ==========================================================

    'food_075':
        NutritionRecord(
      calories: 900,
      protein: 0,
      carbohydrates: 0,
      fats: 100,
      fiber: 0,
      sugar: 0,

      saturatedFat: 62.9,
      transFat: 4.0,
      cholesterol: 256,
      sodium: 0,

      potassium: 0,
      calcium: 0,
      iron: 0,
      magnesium: 0,
      phosphorus: 0,
      zinc: 0,
      copper: 0,
      manganese: 0,
      selenium: 0,
      iodine: 0,

      vitaminA: 840,
      vitaminC: 0,
      vitaminD: 1.8,
      vitaminE: 2.8,
      vitaminK: 8.6,

      vitaminB1: 0,
      vitaminB2: 0,
      vitaminB3: 0,
      vitaminB5: 0,
      vitaminB6: 0,
      vitaminB7: 0,
      vitaminB9: 0,
      vitaminB12: 0,

      preparationState: 'Clarified',
      source: 'Estimated reference value',
      verified: false,
    ),
      
          // ==========================================================
    // FOOD 076 — CHICKEN BREAST
    // Reference basis: 100 g
    // Estimated reference value
    // ==========================================================

    'food_076':
        NutritionRecord(
      calories: 165,
      protein: 31.0,
      carbohydrates: 0,
      fats: 3.6,
      fiber: 0,
      sugar: 0,
      saturatedFat: 1.0,
      cholesterol: 85,
      sodium: 74,
      potassium: 256,
      phosphorus: 220,
      magnesium: 29,
      iron: 1.0,
      zinc: 1.0,
      selenium: 27,
      vitaminB3: 13.7,
      vitaminB5: 1.0,
      vitaminB6: 0.6,
      vitaminB12: 0.3,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 077 — CHICKEN THIGH
    // ==========================================================

    'food_077':
        NutritionRecord(
      calories: 209,
      protein: 26.0,
      carbohydrates: 0,
      fats: 11.0,
      fiber: 0,
      sugar: 0,
      saturatedFat: 3.0,
      cholesterol: 93,
      sodium: 82,
      potassium: 221,
      phosphorus: 190,
      magnesium: 23,
      iron: 1.1,
      zinc: 2.4,
      selenium: 24,
      vitaminB3: 6.5,
      vitaminB5: 1.0,
      vitaminB6: 0.4,
      vitaminB12: 0.4,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 078 — CHICKEN CURRY
    // Reference basis: 100 g
    // ==========================================================

    'food_078':
        NutritionRecord(
      calories: 170,
      protein: 12.0,
      carbohydrates: 7.0,
      fats: 10.0,
      fiber: 1.5,
      sugar: 2.0,
      saturatedFat: 2.5,
      cholesterol: 45,
      sodium: 320,
      potassium: 180,
      calcium: 25,
      iron: 1.2,
      magnesium: 20,
      phosphorus: 110,
      zinc: 1.2,
      vitaminA: 45,
      vitaminC: 3,
      vitaminE: 1.0,
      vitaminK: 4,
      vitaminB3: 3.5,
      vitaminB6: 0.2,
      vitaminB9: 15,
      vitaminB12: 0.2,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 079 — CHICKEN TIKKA
    // ==========================================================

    'food_079':
        NutritionRecord(
      calories: 180,
      protein: 25.0,
      carbohydrates: 4.0,
      fats: 7.0,
      fiber: 0.5,
      sugar: 1.5,
      saturatedFat: 2.0,
      cholesterol: 70,
      sodium: 360,
      potassium: 230,
      calcium: 30,
      iron: 1.1,
      magnesium: 25,
      phosphorus: 180,
      zinc: 1.8,
      vitaminA: 30,
      vitaminC: 1,
      vitaminE: 0.5,
      vitaminB3: 8.0,
      vitaminB6: 0.5,
      vitaminB9: 10,
      vitaminB12: 0.3,
      preparationState: 'Grilled',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 080 — CHICKEN 65
    // ==========================================================

    'food_080':
        NutritionRecord(
      calories: 280,
      protein: 18.0,
      carbohydrates: 12.0,
      fats: 18.0,
      fiber: 0.8,
      sugar: 1.5,
      saturatedFat: 4.0,
      transFat: 0.1,
      cholesterol: 75,
      sodium: 520,
      potassium: 200,
      calcium: 25,
      iron: 1.4,
      magnesium: 22,
      phosphorus: 160,
      zinc: 1.5,
      vitaminA: 25,
      vitaminC: 2,
      vitaminE: 1.0,
      vitaminB3: 6.0,
      vitaminB6: 0.3,
      vitaminB12: 0.3,
      preparationState: 'Fried',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 081 — CHICKEN KEBAB
    // ==========================================================

    'food_081':
        NutritionRecord(
      calories: 190,
      protein: 24.0,
      carbohydrates: 3.0,
      fats: 9.0,
      fiber: 0.5,
      sugar: 1.0,
      saturatedFat: 2.5,
      cholesterol: 70,
      sodium: 300,
      potassium: 220,
      calcium: 25,
      iron: 1.2,
      magnesium: 24,
      phosphorus: 170,
      zinc: 1.8,
      vitaminA: 25,
      vitaminC: 2,
      vitaminB3: 7.0,
      vitaminB6: 0.4,
      vitaminB12: 0.3,
      preparationState: 'Grilled',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 082 — CHICKEN SOUP
    // ==========================================================

    'food_082':
        NutritionRecord(
      calories: 75,
      protein: 6.5,
      carbohydrates: 5.0,
      fats: 3.0,
      fiber: 0.8,
      sugar: 1.2,
      saturatedFat: 0.8,
      cholesterol: 20,
      sodium: 300,
      potassium: 120,
      calcium: 15,
      iron: 0.6,
      magnesium: 12,
      phosphorus: 70,
      zinc: 0.6,
      vitaminA: 40,
      vitaminC: 3,
      vitaminB3: 2.5,
      vitaminB6: 0.2,
      vitaminB9: 8,
      vitaminB12: 0.1,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 083 — BOILED EGG
    // ==========================================================

    'food_083':
        NutritionRecord(
      calories: 155,
      protein: 12.6,
      carbohydrates: 1.1,
      fats: 10.6,
      fiber: 0,
      sugar: 1.1,
      saturatedFat: 3.3,
      cholesterol: 373,
      sodium: 124,
      potassium: 126,
      calcium: 50,
      iron: 1.2,
      magnesium: 10,
      phosphorus: 172,
      zinc: 1.1,
      selenium: 30.7,
      iodine: 53,
      vitaminA: 160,
      vitaminD: 2.0,
      vitaminE: 1.1,
      vitaminB2: 0.5,
      vitaminB5: 1.4,
      vitaminB6: 0.1,
      vitaminB9: 44,
      vitaminB12: 1.1,
      preparationState: 'Boiled',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 084 — EGG OMELETTE
    // ==========================================================

    'food_084':
        NutritionRecord(
      calories: 170,
      protein: 11.0,
      carbohydrates: 2.0,
      fats: 13.0,
      fiber: 0,
      sugar: 1.0,
      saturatedFat: 3.5,
      cholesterol: 300,
      sodium: 180,
      potassium: 120,
      calcium: 50,
      iron: 1.2,
      magnesium: 10,
      phosphorus: 160,
      zinc: 1.0,
      vitaminA: 150,
      vitaminD: 1.8,
      vitaminE: 1.0,
      vitaminB2: 0.4,
      vitaminB5: 1.2,
      vitaminB6: 0.1,
      vitaminB9: 35,
      vitaminB12: 0.9,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 085 — EGG BHURJI
    // ==========================================================

    'food_085':
        NutritionRecord(
      calories: 190,
      protein: 11.0,
      carbohydrates: 4.0,
      fats: 14.0,
      fiber: 0.8,
      sugar: 2.0,
      saturatedFat: 4.0,
      cholesterol: 300,
      sodium: 250,
      potassium: 170,
      calcium: 55,
      iron: 1.3,
      magnesium: 14,
      phosphorus: 165,
      zinc: 1.1,
      vitaminA: 180,
      vitaminC: 4,
      vitaminD: 1.8,
      vitaminE: 1.2,
      vitaminB2: 0.4,
      vitaminB6: 0.15,
      vitaminB9: 40,
      vitaminB12: 0.9,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 086 — EGG CURRY
    // ==========================================================

    'food_086':
        NutritionRecord(
      calories: 175,
      protein: 9.5,
      carbohydrates: 6.0,
      fats: 12.0,
      fiber: 1.2,
      sugar: 2.0,
      saturatedFat: 3.0,
      cholesterol: 220,
      sodium: 300,
      potassium: 170,
      calcium: 50,
      iron: 1.3,
      magnesium: 15,
      phosphorus: 130,
      zinc: 1.0,
      vitaminA: 150,
      vitaminC: 3,
      vitaminD: 1.5,
      vitaminE: 1.0,
      vitaminB2: 0.35,
      vitaminB6: 0.15,
      vitaminB9: 30,
      vitaminB12: 0.7,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 087 — FISH CURRY
    // ==========================================================

    'food_087':
        NutritionRecord(
      calories: 150,
      protein: 18.0,
      carbohydrates: 5.0,
      fats: 6.0,
      fiber: 1.0,
      sugar: 1.5,
      saturatedFat: 2.0,
      cholesterol: 55,
      sodium: 280,
      potassium: 240,
      calcium: 35,
      iron: 1.0,
      magnesium: 25,
      phosphorus: 160,
      zinc: 1.0,
      vitaminA: 35,
      vitaminC: 4,
      vitaminD: 2.0,
      vitaminE: 1.0,
      vitaminB3: 4.0,
      vitaminB6: 0.3,
      vitaminB12: 2.0,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 088 — FISH FRY
    // ==========================================================

    'food_088':
        NutritionRecord(
      calories: 220,
      protein: 20.0,
      carbohydrates: 8.0,
      fats: 12.0,
      fiber: 0.8,
      sugar: 0.5,
      saturatedFat: 2.5,
      cholesterol: 60,
      sodium: 380,
      potassium: 230,
      calcium: 30,
      iron: 1.0,
      magnesium: 24,
      phosphorus: 170,
      zinc: 1.1,
      vitaminD: 3.0,
      vitaminE: 1.2,
      vitaminB3: 4.5,
      vitaminB6: 0.3,
      vitaminB12: 2.0,
      preparationState: 'Fried',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 089 — PRAWNS
    // ==========================================================

    'food_089':
        NutritionRecord(
      calories: 99,
      protein: 24.0,
      carbohydrates: 0.2,
      fats: 0.3,
      fiber: 0,
      sugar: 0,
      saturatedFat: 0.1,
      cholesterol: 189,
      sodium: 111,
      potassium: 259,
      calcium: 70,
      iron: 0.5,
      magnesium: 39,
      phosphorus: 180,
      zinc: 1.6,
      selenium: 39,
      vitaminE: 1.3,
      vitaminB3: 2.0,
      vitaminB6: 0.1,
      vitaminB12: 1.1,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 090 — ROHU FISH
    // ==========================================================

    'food_090':
        NutritionRecord(
      calories: 97,
      protein: 18.0,
      carbohydrates: 0,
      fats: 3.0,
      fiber: 0,
      sugar: 0,
      saturatedFat: 0.8,
      cholesterol: 55,
      sodium: 65,
      potassium: 280,
      calcium: 40,
      iron: 0.8,
      magnesium: 25,
      phosphorus: 170,
      zinc: 0.8,
      vitaminD: 2.0,
      vitaminE: 0.7,
      vitaminB3: 3.5,
      vitaminB6: 0.3,
      vitaminB12: 2.0,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 091 — SALMON
    // ==========================================================

    'food_091':
        NutritionRecord(
      calories: 208,
      protein: 20.4,
      carbohydrates: 0,
      fats: 13.4,
      fiber: 0,
      sugar: 0,
      saturatedFat: 3.1,
      cholesterol: 59,
      sodium: 59,
      potassium: 363,
      calcium: 12,
      iron: 0.3,
      magnesium: 25,
      phosphorus: 252,
      zinc: 0.6,
      selenium: 36.5,
      vitaminA: 58,
      vitaminD: 11.0,
      vitaminE: 3.6,
      vitaminB3: 8.0,
      vitaminB5: 1.0,
      vitaminB6: 0.6,
      vitaminB12: 3.2,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 092 — POMFRET
    // ==========================================================

    'food_092':
        NutritionRecord(
      calories: 130,
      protein: 19.0,
      carbohydrates: 0,
      fats: 6.0,
      fiber: 0,
      sugar: 0,
      saturatedFat: 1.5,
      cholesterol: 55,
      sodium: 70,
      potassium: 280,
      calcium: 35,
      iron: 0.7,
      magnesium: 28,
      phosphorus: 170,
      zinc: 0.7,
      vitaminD: 3.0,
      vitaminE: 1.0,
      vitaminB3: 4.5,
      vitaminB6: 0.3,
      vitaminB12: 2.5,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 093 — MACKEREL
    // ==========================================================

    'food_093':
        NutritionRecord(
      calories: 205,
      protein: 18.6,
      carbohydrates: 0,
      fats: 13.9,
      fiber: 0,
      sugar: 0,
      saturatedFat: 3.3,
      cholesterol: 70,
      sodium: 90,
      potassium: 314,
      calcium: 12,
      iron: 1.6,
      magnesium: 76,
      phosphorus: 217,
      zinc: 0.6,
      selenium: 44,
      vitaminD: 16.1,
      vitaminE: 1.5,
      vitaminB3: 8.6,
      vitaminB6: 0.4,
      vitaminB12: 19.0,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 094 — SARDINES
    // ==========================================================

    'food_094':
        NutritionRecord(
      calories: 208,
      protein: 24.6,
      carbohydrates: 0,
      fats: 11.5,
      fiber: 0,
      sugar: 0,
      saturatedFat: 1.5,
      cholesterol: 142,
      sodium: 307,
      potassium: 397,
      calcium: 382,
      iron: 2.9,
      magnesium: 39,
      phosphorus: 490,
      zinc: 1.3,
      selenium: 52,
      vitaminD: 4.8,
      vitaminE: 2.0,
      vitaminB3: 5.2,
      vitaminB6: 0.2,
      vitaminB12: 8.9,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 095 — CRAB
    // ==========================================================

    'food_095':
        NutritionRecord(
      calories: 97,
      protein: 20.0,
      carbohydrates: 0,
      fats: 1.5,
      fiber: 0,
      sugar: 0,
      saturatedFat: 0.2,
      cholesterol: 53,
      sodium: 395,
      potassium: 301,
      calcium: 59,
      iron: 0.8,
      magnesium: 49,
      phosphorus: 280,
      zinc: 7.6,
      selenium: 40,
      vitaminE: 1.0,
      vitaminB3: 2.0,
      vitaminB6: 0.1,
      vitaminB12: 9.8,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 096 — MUTTON
    // ==========================================================

    'food_096':
        NutritionRecord(
      calories: 234,
      protein: 25.0,
      carbohydrates: 0,
      fats: 15.0,
      fiber: 0,
      sugar: 0,
      saturatedFat: 6.0,
      cholesterol: 80,
      sodium: 70,
      potassium: 310,
      calcium: 12,
      iron: 2.0,
      magnesium: 22,
      phosphorus: 180,
      zinc: 4.5,
      selenium: 20,
      vitaminB3: 5.5,
      vitaminB5: 0.6,
      vitaminB6: 0.2,
      vitaminB12: 2.3,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 097 — MUTTON CURRY
    // ==========================================================

    'food_097':
        NutritionRecord(
      calories: 220,
      protein: 18.0,
      carbohydrates: 6.0,
      fats: 14.0,
      fiber: 1.5,
      sugar: 1.5,
      saturatedFat: 5.0,
      cholesterol: 65,
      sodium: 300,
      potassium: 230,
      calcium: 25,
      iron: 2.0,
      magnesium: 20,
      phosphorus: 150,
      zinc: 3.5,
      vitaminA: 35,
      vitaminC: 3,
      vitaminE: 1.0,
      vitaminK: 3,
      vitaminB3: 4.5,
      vitaminB6: 0.3,
      vitaminB9: 10,
      vitaminB12: 2.0,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 098 — MUTTON BIRYANI
    // ==========================================================

    'food_098':
        NutritionRecord(
      calories: 190,
      protein: 8.0,
      carbohydrates: 19.0,
      fats: 9.0,
      fiber: 1.0,
      sugar: 0.8,
      saturatedFat: 3.0,
      transFat: 0.1,
      cholesterol: 35,
      sodium: 320,
      potassium: 125,
      calcium: 20,
      iron: 1.1,
      magnesium: 18,
      phosphorus: 85,
      zinc: 1.2,
      vitaminA: 20,
      vitaminC: 1,
      vitaminE: 0.4,
      vitaminK: 2,
      vitaminB1: 0.06,
      vitaminB2: 0.09,
      vitaminB3: 2.4,
      vitaminB5: 0.5,
      vitaminB6: 0.15,
      vitaminB9: 10,
      vitaminB12: 0.8,
      preparationState: 'Cooked',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 099 — MUTTON KEBAB
    // ==========================================================

    'food_099':
        NutritionRecord(
      calories: 250,
      protein: 20.0,
      carbohydrates: 5.0,
      fats: 16.0,
      fiber: 0.5,
      sugar: 1.0,
      saturatedFat: 6.0,
      cholesterol: 70,
      sodium: 350,
      potassium: 220,
      calcium: 20,
      iron: 2.0,
      magnesium: 20,
      phosphorus: 160,
      zinc: 3.5,
      vitaminA: 25,
      vitaminC: 1,
      vitaminE: 0.8,
      vitaminB3: 4.5,
      vitaminB6: 0.3,
      vitaminB12: 2.0,
      preparationState: 'Grilled',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 100 — IDLI
    // Reference basis: 1 medium idli / approximately 40 g
    // ==========================================================

    'food_100':
        NutritionRecord(
      calories: 145,
      protein: 5.0,
      carbohydrates: 30.0,
      fats: 1.0,
      fiber: 2.0,
      sugar: 0.5,
      saturatedFat: 0.25,
      transFat: 0,
      cholesterol: 0,
      sodium: 350,
      potassium: 112.5,
      calcium: 30,
      iron: 1.25,
      magnesium: 20,
      phosphorus: 87.5,
      zinc: 0.75,
      copper: 0.08,
      manganese: 0.45,
      selenium: 18,
      iodine: 0,
      vitaminA: 0,
      vitaminC: 0,
      vitaminD: 0,
      vitaminE: 0.10,
      vitaminK: 0,
      vitaminB1: 0.10,
      vitaminB2: 0.05,
      vitaminB3: 1.0,
      vitaminB5: 0,
      vitaminB6: 0.075,
      vitaminB7: 0,
      vitaminB9: 25,
      vitaminB12: 0,
      preparationState: 'Steamed',
      source: 'Estimated reference value; normalized from 40 g serving',
      verified: false,
    ),

    // ==========================================================
    // FOOD 101 — MINI IDLI
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_101':
        NutritionRecord(
      calories: 145,
      protein: 5,
      carbohydrates: 30,
      fats: 1,
      fiber: 2,
      sugar: 0.5,
      saturatedFat: 0.25,
      sodium: 350,
      potassium: 112.5,
      calcium: 30,
      iron: 1.25,
      magnesium: 20,
      phosphorus: 87.5,
      zinc: 0.75,
      copper: 0.08,
      manganese: 0.45,
      selenium: 18,
      vitaminB1: 0.1,
      vitaminB2: 0.05,
      vitaminB3: 1,
      vitaminB6: 0.075,
      vitaminB9: 25,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 102 — RAVA IDLI
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_102':
        NutritionRecord(
      calories: 133,
      protein: 4.2,
      carbohydrates: 23.3,
      fats: 2.5,
      fiber: 1.2,
      sugar: 0.7,
      saturatedFat: 0.5,
      sodium: 420,
      potassium: 95,
      calcium: 28,
      iron: 1.4,
      magnesium: 22,
      phosphorus: 75,
      zinc: 0.7,
      copper: 0.08,
      manganese: 0.35,
      selenium: 18,
      vitaminB1: 0.08,
      vitaminB2: 0.05,
      vitaminB3: 1.2,
      vitaminB5: 0.3,
      vitaminB6: 0.08,
      vitaminB9: 28,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 103 — PLAIN DOSA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_103':
        NutritionRecord(
      calories: 168,
      protein: 3.9,
      carbohydrates: 29,
      fats: 3.7,
      fiber: 1,
      sugar: 0.4,
      saturatedFat: 0.7,
      sodium: 180,
      potassium: 85,
      calcium: 20,
      iron: 1.5,
      magnesium: 18,
      phosphorus: 70,
      zinc: 0.55,
      copper: 0.08,
      manganese: 0.35,
      selenium: 15,
      vitaminB1: 0.08,
      vitaminB2: 0.04,
      vitaminB3: 1,
      vitaminB5: 0.2,
      vitaminB6: 0.07,
      vitaminB9: 18,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 104 — MASALA DOSA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_104':
        NutritionRecord(
      calories: 200,
      protein: 4,
      carbohydrates: 27,
      fats: 8,
      fiber: 2,
      sugar: 1,
      saturatedFat: 2,
      sodium: 300,
      potassium: 150,
      calcium: 28,
      iron: 1.3,
      magnesium: 22,
      phosphorus: 75,
      zinc: 0.65,
      copper: 0.12,
      manganese: 0.4,
      selenium: 15,
      vitaminB1: 0.07,
      vitaminB2: 0.05,
      vitaminB3: 1,
      vitaminB5: 0.3,
      vitaminB6: 0.08,
      vitaminB9: 20,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 105 — MYSORE MASALA DOSA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_105':
        NutritionRecord(
      calories: 206,
      protein: 4.4,
      carbohydrates: 26.3,
      fats: 8.1,
      fiber: 1.9,
      sugar: 1.2,
      saturatedFat: 2.1,
      sodium: 320,
      potassium: 145,
      calcium: 30,
      iron: 1.4,
      magnesium: 22,
      phosphorus: 78,
      zinc: 0.65,
      copper: 0.12,
      manganese: 0.4,
      selenium: 15,
      vitaminB1: 0.07,
      vitaminB2: 0.05,
      vitaminB3: 1,
      vitaminB5: 0.3,
      vitaminB6: 0.08,
      vitaminB9: 20,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 106 — RAVA DOSA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_106':
        NutritionRecord(
      calories: 155,
      protein: 3.2,
      carbohydrates: 24.5,
      fats: 4.5,
      fiber: 1,
      sugar: 0.5,
      saturatedFat: 1,
      sodium: 260,
      potassium: 90,
      calcium: 22,
      iron: 1.6,
      magnesium: 20,
      phosphorus: 78,
      zinc: 0.65,
      copper: 0.08,
      manganese: 0.4,
      selenium: 16,
      vitaminB1: 0.1,
      vitaminB2: 0.04,
      vitaminB3: 1.3,
      vitaminB5: 0.3,
      vitaminB6: 0.08,
      vitaminB9: 18,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 107 — PODI DOSA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_107':
        NutritionRecord(
      calories: 183,
      protein: 4.2,
      carbohydrates: 25.8,
      fats: 5.8,
      fiber: 2,
      sugar: 0.5,
      saturatedFat: 1,
      sodium: 320,
      potassium: 150,
      calcium: 45,
      iron: 1.8,
      magnesium: 35,
      phosphorus: 85,
      zinc: 0.8,
      copper: 0.18,
      manganese: 0.65,
      selenium: 16,
      vitaminB1: 0.12,
      vitaminB2: 0.05,
      vitaminB3: 1.4,
      vitaminB5: 0.35,
      vitaminB6: 0.11,
      vitaminB9: 32,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 108 — SET DOSA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_108':
        NutritionRecord(
      calories: 150,
      protein: 3.8,
      carbohydrates: 26.3,
      fats: 3.1,
      fiber: 1.3,
      sugar: 0.7,
      saturatedFat: 0.7,
      sodium: 190,
      potassium: 95,
      calcium: 22,
      iron: 1.4,
      magnesium: 20,
      phosphorus: 72,
      zinc: 0.6,
      copper: 0.08,
      manganese: 0.4,
      selenium: 15,
      vitaminB1: 0.08,
      vitaminB2: 0.04,
      vitaminB3: 1,
      vitaminB5: 0.2,
      vitaminB6: 0.07,
      vitaminB9: 20,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 109 — UTTAPAM
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_109':
        NutritionRecord(
      calories: 150,
      protein: 4.2,
      carbohydrates: 25,
      fats: 3.3,
      fiber: 1.8,
      sugar: 1,
      saturatedFat: 0.6,
      sodium: 220,
      potassium: 120,
      calcium: 25,
      iron: 1.4,
      magnesium: 23,
      phosphorus: 75,
      zinc: 0.65,
      copper: 0.1,
      manganese: 0.45,
      selenium: 15,
      vitaminB1: 0.09,
      vitaminB2: 0.05,
      vitaminB3: 1.1,
      vitaminB5: 0.25,
      vitaminB6: 0.08,
      vitaminB9: 22,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 110 — VADA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_110':
        NutritionRecord(
      calories: 225,
      protein: 6.7,
      carbohydrates: 25,
      fats: 11.7,
      fiber: 2.5,
      sugar: 1,
      saturatedFat: 2,
      sodium: 280,
      potassium: 180,
      calcium: 45,
      iron: 2.2,
      magnesium: 50,
      phosphorus: 120,
      zinc: 0.9,
      copper: 0.2,
      manganese: 0.7,
      selenium: 8,
      vitaminB1: 0.15,
      vitaminB2: 0.06,
      vitaminB3: 1.4,
      vitaminB5: 0.4,
      vitaminB6: 0.12,
      vitaminB9: 75,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 111 — MEDU VADA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_111':
        NutritionRecord(
      calories: 233,
      protein: 6.7,
      carbohydrates: 25,
      fats: 11.7,
      fiber: 2.5,
      sugar: 1,
      saturatedFat: 2,
      sodium: 290,
      potassium: 180,
      calcium: 45,
      iron: 2.2,
      magnesium: 50,
      phosphorus: 120,
      zinc: 0.9,
      copper: 0.2,
      manganese: 0.7,
      selenium: 8,
      vitaminB1: 0.15,
      vitaminB2: 0.06,
      vitaminB3: 1.4,
      vitaminB5: 0.4,
      vitaminB6: 0.12,
      vitaminB9: 75,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 112 — SAMBAR
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_112':
        NutritionRecord(
      calories: 70,
      protein: 3,
      carbohydrates: 10,
      fats: 2,
      fiber: 3,
      sugar: 2,
      sodium: 400,
      potassium: 180,
      calcium: 35,
      iron: 1.2,
      magnesium: 28,
      phosphorus: 55,
      zinc: 0.55,
      copper: 0.1,
      manganese: 0.25,
      vitaminB1: 0.05,
      vitaminB2: 0.03,
      vitaminB3: 0.7,
      vitaminB5: 0.2,
      vitaminB6: 0.08,
      vitaminB9: 35,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 113 — RASAM
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_113':
        NutritionRecord(
      calories: 27.5,
      protein: 1,
      carbohydrates: 4,
      fats: 0.75,
      fiber: 0.75,
      sugar: 1,
      sodium: 420,
      potassium: 95,
      calcium: 18,
      iron: 0.5,
      magnesium: 10,
      phosphorus: 20,
      zinc: 0.25,
      copper: 0.05,
      manganese: 0.15,
      vitaminB1: 0.02,
      vitaminB2: 0.015,
      vitaminB3: 0.35,
      vitaminB5: 0.1,
      vitaminB6: 0.03,
      vitaminB9: 16,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 114 — UPMA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_114':
        NutritionRecord(
      calories: 150,
      protein: 3,
      carbohydrates: 24,
      fats: 4,
      fiber: 2,
      sugar: 1,
      sodium: 260,
      potassium: 100,
      calcium: 20,
      iron: 1,
      magnesium: 25,
      phosphorus: 60,
      zinc: 0.55,
      copper: 0.1,
      manganese: 0.45,
      selenium: 25,
      vitaminB1: 0.08,
      vitaminB2: 0.04,
      vitaminB3: 1.2,
      vitaminB5: 0.25,
      vitaminB6: 0.08,
      vitaminB9: 20,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 115 — POHA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_115':
        NutritionRecord(
      calories: 158,
      protein: 3,
      carbohydrates: 25,
      fats: 5,
      fiber: 1.7,
      sugar: 1.2,
      sodium: 250,
      potassium: 120,
      calcium: 20,
      iron: 1.2,
      magnesium: 24,
      phosphorus: 65,
      zinc: 0.6,
      copper: 0.1,
      manganese: 0.45,
      selenium: 12,
      vitaminB1: 0.1,
      vitaminB2: 0.04,
      vitaminB3: 1.2,
      vitaminB5: 0.25,
      vitaminB6: 0.08,
      vitaminB9: 22,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 116 — SAMOSA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_116':
        NutritionRecord(
      calories: 225,
      protein: 4.4,
      carbohydrates: 27.5,
      fats: 11.3,
      fiber: 2.5,
      sugar: 1.5,
      saturatedFat: 2.8,
      sodium: 380,
      potassium: 150,
      calcium: 30,
      iron: 1.8,
      magnesium: 28,
      phosphorus: 65,
      zinc: 0.6,
      copper: 0.08,
      manganese: 0.25,
      vitaminB1: 0.06,
      vitaminB2: 0.04,
      vitaminB3: 1.1,
      vitaminB5: 0.2,
      vitaminB6: 0.08,
      vitaminB9: 25,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 117 — KACHORI
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_117':
        NutritionRecord(
      calories: 286,
      protein: 5.7,
      carbohydrates: 35.7,
      fats: 14.3,
      fiber: 2.9,
      sugar: 1.5,
      saturatedFat: 3.2,
      sodium: 400,
      potassium: 170,
      calcium: 35,
      iron: 2,
      magnesium: 32,
      phosphorus: 75,
      zinc: 0.7,
      copper: 0.1,
      manganese: 0.3,
      vitaminB1: 0.07,
      vitaminB2: 0.04,
      vitaminB3: 1.3,
      vitaminB5: 0.25,
      vitaminB6: 0.09,
      vitaminB9: 28,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 118 — ONION PAKORA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_118':
        NutritionRecord(
      calories: 280,
      protein: 5,
      carbohydrates: 25,
      fats: 17,
      fiber: 3,
      sugar: 4,
      saturatedFat: 3,
      sodium: 380,
      potassium: 220,
      calcium: 45,
      iron: 1.8,
      magnesium: 25,
      phosphorus: 90,
      zinc: 0.7,
      copper: 0.1,
      manganese: 0.3,
      vitaminB1: 0.08,
      vitaminB2: 0.05,
      vitaminB3: 1.5,
      vitaminB5: 0.25,
      vitaminB6: 0.12,
      vitaminB9: 45,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 119 — PANEER PAKORA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_119':
        NutritionRecord(
      calories: 290,
      protein: 10,
      carbohydrates: 16,
      fats: 19,
      fiber: 1.5,
      sugar: 2,
      saturatedFat: 9,
      cholesterol: 25,
      sodium: 420,
      potassium: 150,
      calcium: 180,
      iron: 1.6,
      magnesium: 28,
      phosphorus: 160,
      zinc: 1.5,
      copper: 0.1,
      manganese: 0.15,
      selenium: 10,
      iodine: 20,
      vitaminA: 90,
      vitaminD: 0.2,
      vitaminE: 1,
      vitaminK: 4,
      vitaminB1: 0.05,
      vitaminB2: 0.15,
      vitaminB3: 0.7,
      vitaminB5: 0.4,
      vitaminB6: 0.05,
      vitaminB9: 20,
      vitaminB12: 0.35,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 120 — BHEL PURI
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_120':
        NutritionRecord(
      calories: 147,
      protein: 3.3,
      carbohydrates: 23.3,
      fats: 4,
      fiber: 2.7,
      sugar: 3.5,
      sodium: 300,
      potassium: 170,
      calcium: 35,
      iron: 1.7,
      magnesium: 28,
      phosphorus: 65,
      zinc: 0.7,
      copper: 0.12,
      manganese: 0.4,
      vitaminB1: 0.1,
      vitaminB2: 0.05,
      vitaminB3: 1,
      vitaminB5: 0.2,
      vitaminB6: 0.08,
      vitaminB9: 35,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 121 — PANI PURI
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_121':
        NutritionRecord(
      calories: 150,
      protein: 3,
      carbohydrates: 24,
      fats: 4,
      fiber: 2,
      sugar: 2,
      sodium: 500,
      potassium: 120,
      calcium: 30,
      iron: 1.5,
      magnesium: 25,
      phosphorus: 55,
      zinc: 0.55,
      copper: 0.1,
      manganese: 0.35,
      vitaminB1: 0.07,
      vitaminB2: 0.04,
      vitaminB3: 0.9,
      vitaminB5: 0.2,
      vitaminB6: 0.07,
      vitaminB9: 30,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 122 — VADA PAV
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_122':
        NutritionRecord(
      calories: 193,
      protein: 4.7,
      carbohydrates: 26.7,
      fats: 7.3,
      fiber: 2,
      sugar: 2,
      saturatedFat: 1.5,
      sodium: 450,
      potassium: 170,
      calcium: 35,
      iron: 1.8,
      magnesium: 30,
      phosphorus: 65,
      zinc: 0.7,
      copper: 0.1,
      manganese: 0.35,
      vitaminB1: 0.09,
      vitaminB2: 0.05,
      vitaminB3: 1.2,
      vitaminB5: 0.2,
      vitaminB6: 0.09,
      vitaminB9: 35,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 123 — PAV BHAJI
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_123':
        NutritionRecord(
      calories: 140,
      protein: 3.6,
      carbohydrates: 19.2,
      fats: 5.2,
      fiber: 2.4,
      sugar: 3,
      saturatedFat: 1.8,
      sodium: 420,
      potassium: 230,
      calcium: 38,
      iron: 1.6,
      magnesium: 28,
      phosphorus: 65,
      zinc: 0.6,
      copper: 0.12,
      manganese: 0.3,
      vitaminA: 180,
      vitaminC: 8,
      vitaminE: 0.5,
      vitaminK: 8,
      vitaminB1: 0.08,
      vitaminB2: 0.05,
      vitaminB3: 1,
      vitaminB5: 0.25,
      vitaminB6: 0.1,
      vitaminB9: 35,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 124 — ALOO TIKKI
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_124':
        NutritionRecord(
      calories: 180,
      protein: 3,
      carbohydrates: 25,
      fats: 7,
      fiber: 2.5,
      sugar: 1.5,
      saturatedFat: 1.5,
      sodium: 300,
      potassium: 320,
      calcium: 20,
      iron: 1.2,
      magnesium: 23,
      phosphorus: 60,
      zinc: 0.5,
      copper: 0.08,
      manganese: 0.2,
      vitaminC: 8,
      vitaminB1: 0.07,
      vitaminB2: 0.03,
      vitaminB3: 1.2,
      vitaminB5: 0.25,
      vitaminB6: 0.2,
      vitaminB9: 15,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 125 — VEG MOMOS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_125':
        NutritionRecord(
      calories: 180,
      protein: 6,
      carbohydrates: 28,
      fats: 4.5,
      fiber: 2,
      sugar: 1.5,
      sodium: 450,
      potassium: 140,
      calcium: 25,
      iron: 1.3,
      magnesium: 20,
      phosphorus: 65,
      zinc: 0.55,
      copper: 0.08,
      manganese: 0.25,
      vitaminA: 80,
      vitaminC: 4,
      vitaminK: 4,
      vitaminB1: 0.08,
      vitaminB2: 0.04,
      vitaminB3: 1,
      vitaminB5: 0.2,
      vitaminB6: 0.08,
      vitaminB9: 22,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 126 — CHICKEN MOMOS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_126':
        NutritionRecord(
      calories: 220,
      protein: 12,
      carbohydrates: 24,
      fats: 8,
      fiber: 1.2,
      sugar: 1,
      saturatedFat: 2,
      cholesterol: 25,
      sodium: 500,
      potassium: 170,
      calcium: 20,
      iron: 1.3,
      magnesium: 20,
      phosphorus: 90,
      zinc: 0.9,
      copper: 0.06,
      manganese: 0.15,
      selenium: 18,
      vitaminB1: 0.06,
      vitaminB2: 0.08,
      vitaminB3: 3,
      vitaminB5: 0.4,
      vitaminB6: 0.12,
      vitaminB9: 15,
      vitaminB12: 0.15,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 127 — BANANA CHIPS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_127':
        NutritionRecord(
      calories: 540,
      protein: 3,
      carbohydrates: 60,
      fats: 30,
      fiber: 4,
      sugar: 25,
      saturatedFat: 10,
      sodium: 8,
      potassium: 480,
      calcium: 18,
      iron: 1.5,
      magnesium: 40,
      phosphorus: 95,
      zinc: 0.8,
      copper: 0.18,
      manganese: 0.5,
      vitaminA: 2,
      vitaminC: 10,
      vitaminE: 0.7,
      vitaminK: 1,
      vitaminB1: 0.1,
      vitaminB2: 0.06,
      vitaminB3: 0.8,
      vitaminB5: 0.3,
      vitaminB6: 0.3,
      vitaminB9: 14,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 128 — CHIVDA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_128':
        NutritionRecord(
      calories: 460,
      protein: 8,
      carbohydrates: 62,
      fats: 19,
      fiber: 3,
      sugar: 4,
      saturatedFat: 3,
      sodium: 500,
      potassium: 200,
      calcium: 35,
      iron: 2,
      magnesium: 35,
      phosphorus: 100,
      zinc: 1,
      copper: 0.15,
      manganese: 0.5,
      vitaminB1: 0.1,
      vitaminB2: 0.05,
      vitaminB3: 2,
      vitaminB5: 0.35,
      vitaminB6: 0.12,
      vitaminB9: 25,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 129 — MURUKKU
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_129':
        NutritionRecord(
      calories: 500,
      protein: 8,
      carbohydrates: 50,
      fats: 30,
      fiber: 3,
      sugar: 2,
      saturatedFat: 6,
      sodium: 450,
      potassium: 120,
      calcium: 40,
      iron: 2,
      magnesium: 38,
      phosphorus: 110,
      zinc: 0.9,
      copper: 0.12,
      manganese: 0.45,
      vitaminB1: 0.12,
      vitaminB2: 0.05,
      vitaminB3: 1.5,
      vitaminB5: 0.3,
      vitaminB6: 0.1,
      vitaminB9: 28,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 130 — ALMONDS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_130':
        NutritionRecord(
      calories: 579,
      protein: 21.2,
      carbohydrates: 21.6,
      fats: 49.9,
      fiber: 12.5,
      sugar: 4.4,
      saturatedFat: 3.8,
      sodium: 1,
      potassium: 733,
      calcium: 269,
      iron: 3.7,
      magnesium: 270,
      phosphorus: 481,
      zinc: 3.1,
      copper: 1.03,
      manganese: 2.18,
      selenium: 4.1,
      vitaminE: 25.6,
      vitaminB3: 3.6,
      vitaminB5: 0.47,
      vitaminB6: 0.14,
      vitaminB9: 44,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 131 — CASHEWS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_131':
        NutritionRecord(
      calories: 553,
      protein: 18,
      carbohydrates: 30,
      fats: 44,
      fiber: 3.3,
      sugar: 5.9,
      saturatedFat: 7.8,
      sodium: 12,
      potassium: 660,
      calcium: 37,
      iron: 6.7,
      magnesium: 292,
      phosphorus: 593,
      zinc: 5.8,
      copper: 2.2,
      manganese: 1.66,
      selenium: 19.9,
      vitaminE: 0.9,
      vitaminB1: 0.42,
      vitaminB2: 0.06,
      vitaminB3: 1.06,
      vitaminB5: 0.86,
      vitaminB6: 0.42,
      vitaminB9: 25,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 132 — WALNUTS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_132':
        NutritionRecord(
      calories: 654,
      protein: 15,
      carbohydrates: 14,
      fats: 65,
      fiber: 6.7,
      sugar: 2.6,
      saturatedFat: 6.1,
      sodium: 2,
      potassium: 441,
      calcium: 98,
      iron: 2.9,
      magnesium: 158,
      phosphorus: 346,
      zinc: 3.1,
      copper: 1.59,
      manganese: 3.41,
      selenium: 4.9,
      vitaminE: 0.7,
      vitaminB1: 0.34,
      vitaminB2: 0.15,
      vitaminB3: 1.13,
      vitaminB5: 0.57,
      vitaminB9: 98,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 133 — PISTACHIOS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_133':
        NutritionRecord(
      calories: 560,
      protein: 20,
      carbohydrates: 28,
      fats: 45,
      fiber: 10,
      sugar: 7.7,
      saturatedFat: 5.4,
      sodium: 1,
      potassium: 1025,
      calcium: 105,
      iron: 3.9,
      magnesium: 121,
      phosphorus: 490,
      zinc: 2.2,
      copper: 1.3,
      manganese: 1.2,
      selenium: 7,
      vitaminE: 2.9,
      vitaminK: 13.2,
      vitaminB1: 0.87,
      vitaminB2: 0.16,
      vitaminB3: 1.3,
      vitaminB5: 0.52,
      vitaminB6: 1.12,
      vitaminB9: 51,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 134 — PEANUTS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_134':
        NutritionRecord(
      calories: 567,
      protein: 26,
      carbohydrates: 16,
      fats: 49,
      fiber: 8.5,
      sugar: 4.7,
      saturatedFat: 6.8,
      sodium: 18,
      potassium: 705,
      calcium: 92,
      iron: 4.6,
      magnesium: 168,
      phosphorus: 376,
      zinc: 3.3,
      copper: 1.14,
      manganese: 1.93,
      selenium: 7.2,
      vitaminE: 8.3,
      vitaminB1: 0.64,
      vitaminB2: 0.14,
      vitaminB3: 12.1,
      vitaminB5: 1.77,
      vitaminB6: 0.35,
      vitaminB9: 240,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 135 — RAISINS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_135':
        NutritionRecord(
      calories: 299,
      protein: 3.1,
      carbohydrates: 79,
      fats: 0.5,
      fiber: 3.7,
      sugar: 59.2,
      sodium: 11,
      potassium: 749,
      calcium: 50,
      iron: 1.9,
      magnesium: 32,
      phosphorus: 101,
      zinc: 0.22,
      copper: 0.32,
      manganese: 0.3,
      vitaminC: 2.3,
      vitaminE: 0.1,
      vitaminK: 3.5,
      vitaminB1: 0.11,
      vitaminB2: 0.13,
      vitaminB3: 1.1,
      vitaminB5: 0.72,
      vitaminB6: 0.17,
      vitaminB9: 5,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 136 — CHIA SEEDS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_136':
        NutritionRecord(
      calories: 486,
      protein: 16.5,
      carbohydrates: 42.1,
      fats: 30.7,
      fiber: 34.4,
      sugar: 0,
      saturatedFat: 3.3,
      sodium: 16,
      potassium: 407,
      calcium: 631,
      iron: 7.7,
      magnesium: 335,
      phosphorus: 860,
      zinc: 4.6,
      copper: 0.92,
      manganese: 2.72,
      selenium: 55.2,
      vitaminE: 0.5,
      vitaminB1: 0.62,
      vitaminB2: 0.17,
      vitaminB3: 8.8,
      vitaminB5: 0.2,
      vitaminB6: 0,
      vitaminB9: 49,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 137 — FLAX SEEDS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_137':
        NutritionRecord(
      calories: 534,
      protein: 18,
      carbohydrates: 29,
      fats: 42,
      fiber: 27,
      sugar: 1.6,
      saturatedFat: 3.7,
      sodium: 30,
      potassium: 813,
      calcium: 255,
      iron: 5.7,
      magnesium: 392,
      phosphorus: 642,
      zinc: 4.3,
      copper: 1.2,
      manganese: 2.48,
      selenium: 25.4,
      vitaminE: 0.31,
      vitaminK: 4.3,
      vitaminB1: 1.64,
      vitaminB2: 0.16,
      vitaminB3: 3.1,
      vitaminB5: 0.99,
      vitaminB6: 0.47,
      vitaminB9: 87,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 138 — SUNFLOWER SEEDS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_138':
        NutritionRecord(
      calories: 584,
      protein: 21,
      carbohydrates: 20,
      fats: 51,
      fiber: 8.6,
      sugar: 2.6,
      saturatedFat: 4.5,
      sodium: 9,
      potassium: 645,
      calcium: 78,
      iron: 5.25,
      magnesium: 325,
      phosphorus: 660,
      zinc: 5,
      copper: 1.8,
      manganese: 1.95,
      selenium: 53,
      vitaminE: 35.2,
      vitaminK: 1.3,
      vitaminB1: 1.48,
      vitaminB2: 0.36,
      vitaminB3: 8.34,
      vitaminB5: 1.13,
      vitaminB6: 1.35,
      vitaminB9: 227,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 139 — PUMPKIN SEEDS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_139':
        NutritionRecord(
      calories: 559,
      protein: 30,
      carbohydrates: 11,
      fats: 49,
      fiber: 6,
      sugar: 1.4,
      saturatedFat: 8.7,
      sodium: 7,
      potassium: 919,
      calcium: 46,
      iron: 8.8,
      magnesium: 592,
      phosphorus: 1233,
      zinc: 7.64,
      copper: 1.34,
      manganese: 4.54,
      selenium: 9.4,
      vitaminE: 2.2,
      vitaminK: 7.3,
      vitaminB1: 0.27,
      vitaminB2: 0.15,
      vitaminB3: 4.99,
      vitaminB5: 0.75,
      vitaminB6: 0.14,
      vitaminB9: 58,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 140 — TEA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_140':
        NutritionRecord(
      calories: 20,
      protein: 0.8,
      carbohydrates: 2.5,
      fats: 0.5,
      fiber: 0,
      sugar: 2.4,
      sodium: 25,
      potassium: 90,
      calcium: 25,
      iron: 0.1,
      magnesium: 7,
      phosphorus: 15,
      zinc: 0.1,
      copper: 0.01,
      manganese: 0.05,
      vitaminB1: 0.01,
      vitaminB2: 0.04,
      vitaminB3: 0.1,
      vitaminB5: 0.1,
      vitaminB6: 0.02,
      vitaminB9: 2,
      vitaminB12: 0.1,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 141 — COFFEE
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_141':
        NutritionRecord(
      calories: 2.5,
      protein: 0.15,
      carbohydrates: 0.2,
      fats: 0.05,
      fiber: 0,
      sugar: 0,
      sodium: 2,
      potassium: 49,
      calcium: 5,
      iron: 0.05,
      magnesium: 6,
      phosphorus: 7,
      zinc: 0.02,
      copper: 0.01,
      manganese: 0.03,
      vitaminB1: 0,
      vitaminB2: 0.01,
      vitaminB3: 0.19,
      vitaminB5: 0.25,
      vitaminB6: 0.01,
      vitaminB9: 2,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 142 — GREEN TEA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_142':
        NutritionRecord(
      calories: 1,
      protein: 0,
      carbohydrates: 0,
      fats: 0,
      fiber: 0,
      sugar: 0,
      sodium: 1,
      potassium: 8,
      calcium: 1,
      iron: 0.02,
      magnesium: 1,
      phosphorus: 1,
      zinc: 0,
      copper: 0,
      manganese: 0.18,
      vitaminC: 0.1,
      vitaminE: 0.01,
      vitaminK: 0.3,
      vitaminB1: 0,
      vitaminB2: 0,
      vitaminB3: 0.1,
      vitaminB5: 0,
      vitaminB6: 0,
      vitaminB9: 1,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 143 — COLD COFFEE
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_143':
        NutritionRecord(
      calories: 60,
      protein: 2,
      carbohydrates: 8,
      fats: 2.5,
      fiber: 0,
      sugar: 6.5,
      saturatedFat: 1.6,
      cholesterol: 8,
      sodium: 35,
      potassium: 110,
      calcium: 75,
      iron: 0.05,
      magnesium: 8,
      phosphorus: 65,
      zinc: 0.25,
      copper: 0.02,
      manganese: 0.01,
      iodine: 12,
      vitaminA: 25,
      vitaminD: 0.2,
      vitaminE: 0.1,
      vitaminK: 0.2,
      vitaminB1: 0.02,
      vitaminB2: 0.08,
      vitaminB3: 0.1,
      vitaminB5: 0.4,
      vitaminB6: 0.03,
      vitaminB9: 4,
      vitaminB12: 0.2,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 144 — BUTTERMILK
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_144':
        NutritionRecord(
      calories: 24,
      protein: 1.2,
      carbohydrates: 2,
      fats: 0.8,
      fiber: 0,
      sugar: 2,
      saturatedFat: 0.5,
      cholesterol: 3,
      sodium: 60,
      potassium: 120,
      calcium: 120,
      iron: 0,
      magnesium: 11,
      phosphorus: 90,
      zinc: 0.35,
      copper: 0.01,
      manganese: 0.005,
      selenium: 2.5,
      iodine: 20,
      vitaminA: 10,
      vitaminD: 0.1,
      vitaminE: 0.05,
      vitaminK: 0.1,
      vitaminB1: 0.02,
      vitaminB2: 0.04,
      vitaminB3: 0.08,
      vitaminB5: 0.3,
      vitaminB6: 0.03,
      vitaminB9: 5,
      vitaminB12: 0.35,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 145 — LASSI
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_145':
        NutritionRecord(
      calories: 64,
      protein: 2.4,
      carbohydrates: 8,
      fats: 2.4,
      fiber: 0,
      sugar: 7,
      saturatedFat: 1.5,
      cholesterol: 8,
      sodium: 45,
      potassium: 120,
      calcium: 100,
      iron: 0.05,
      magnesium: 10,
      phosphorus: 80,
      zinc: 0.4,
      copper: 0.01,
      manganese: 0.01,
      selenium: 2.5,
      iodine: 18,
      vitaminA: 18,
      vitaminD: 0.1,
      vitaminE: 0.05,
      vitaminK: 0.1,
      vitaminB1: 0.02,
      vitaminB2: 0.07,
      vitaminB3: 0.1,
      vitaminB5: 0.35,
      vitaminB6: 0.03,
      vitaminB9: 5,
      vitaminB12: 0.3,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 146 — MANGO SHAKE
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_146':
        NutritionRecord(
      calories: 73.3,
      protein: 2,
      carbohydrates: 11.7,
      fats: 2,
      fiber: 0.7,
      sugar: 10,
      saturatedFat: 1.2,
      cholesterol: 6,
      sodium: 25,
      potassium: 120,
      calcium: 65,
      iron: 0.1,
      magnesium: 10,
      phosphorus: 55,
      zinc: 0.25,
      copper: 0.03,
      manganese: 0.05,
      selenium: 1.5,
      vitaminA: 55,
      vitaminC: 5,
      vitaminD: 0.1,
      vitaminE: 0.4,
      vitaminK: 0.8,
      vitaminB1: 0.03,
      vitaminB2: 0.05,
      vitaminB3: 0.2,
      vitaminB5: 0.25,
      vitaminB6: 0.04,
      vitaminB9: 8,
      vitaminB12: 0.15,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 147 — COCONUT WATER
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_147':
        NutritionRecord(
      calories: 18,
      protein: 0.8,
      carbohydrates: 3.6,
      fats: 0.2,
      fiber: 0.4,
      sugar: 3.2,
      sodium: 22,
      potassium: 250,
      calcium: 24,
      iron: 0.3,
      magnesium: 25,
      phosphorus: 20,
      zinc: 0.1,
      copper: 0.04,
      manganese: 0.14,
      vitaminC: 2.5,
      vitaminE: 0.1,
      vitaminB1: 0.03,
      vitaminB2: 0.06,
      vitaminB3: 0.1,
      vitaminB5: 0.05,
      vitaminB6: 0.03,
      vitaminB9: 3,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 148 — COCA-COLA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_148':
        NutritionRecord(
      calories: 42,
      protein: 0,
      carbohydrates: 10.6,
      fats: 0,
      fiber: 0,
      sugar: 10.6,
      sodium: 11,
      potassium: 2,
      calcium: 0,
      iron: 0,
      magnesium: 1,
      phosphorus: 17,
      zinc: 0,
      copper: 0,
      manganese: 0,
      vitaminB9: 0,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 149 — PEPSI
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_149':
        NutritionRecord(
      calories: 41,
      protein: 0,
      carbohydrates: 11,
      fats: 0,
      fiber: 0,
      sugar: 11,
      sodium: 11,
      potassium: 1,
      calcium: 0,
      iron: 0,
      magnesium: 1,
      phosphorus: 17,
      zinc: 0,
      copper: 0,
      manganese: 0,
      vitaminB9: 0,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 150 — SPRITE
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_150':
        NutritionRecord(
      calories: 40,
      protein: 0,
      carbohydrates: 10,
      fats: 0,
      fiber: 0,
      sugar: 10,
      sodium: 11,
      potassium: 1,
      calcium: 0,
      iron: 0,
      magnesium: 1,
      phosphorus: 0,
      zinc: 0,
      copper: 0,
      manganese: 0,
      vitaminB9: 0,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 151 — PARLE-G
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_151':
        NutritionRecord(
      calories: 450,
      protein: 6.5,
      carbohydrates: 70,
      fats: 15,
      fiber: 2.5,
      sugar: 25,
      saturatedFat: 7,
      sodium: 300,
      potassium: 120,
      calcium: 20,
      iron: 3,
      magnesium: 20,
      phosphorus: 80,
      zinc: 0.6,
      copper: 0.08,
      manganese: 0.3,
      vitaminA: 0,
      vitaminE: 1,
      vitaminB1: 0.15,
      vitaminB2: 0.1,
      vitaminB3: 1.5,
      vitaminB5: 0.3,
      vitaminB6: 0.08,
      vitaminB9: 25,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 152 — MARIE GOLD
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_152':
        NutritionRecord(
      calories: 460,
      protein: 8,
      carbohydrates: 76,
      fats: 12,
      fiber: 2.8,
      sugar: 20,
      saturatedFat: 5,
      sodium: 300,
      potassium: 120,
      calcium: 25,
      iron: 4,
      magnesium: 22,
      phosphorus: 90,
      zinc: 0.7,
      copper: 0.1,
      manganese: 0.35,
      vitaminE: 0.8,
      vitaminB1: 0.15,
      vitaminB2: 0.08,
      vitaminB3: 2,
      vitaminB5: 0.3,
      vitaminB6: 0.07,
      vitaminB9: 30,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 153 — GOOD DAY
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_153':
        NutritionRecord(
      calories: 500,
      protein: 7.2,
      carbohydrates: 64,
      fats: 24,
      fiber: 2,
      sugar: 24,
      saturatedFat: 12,
      sodium: 280,
      potassium: 120,
      calcium: 25,
      iron: 2.5,
      magnesium: 25,
      phosphorus: 100,
      zinc: 0.7,
      copper: 0.1,
      manganese: 0.3,
      vitaminE: 2,
      vitaminB1: 0.12,
      vitaminB2: 0.08,
      vitaminB3: 1.8,
      vitaminB5: 0.35,
      vitaminB6: 0.08,
      vitaminB9: 28,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 154 — BOURBON
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_154':
        NutritionRecord(
      calories: 483,
      protein: 5,
      carbohydrates: 66.7,
      fats: 20,
      fiber: 2.7,
      sugar: 30,
      saturatedFat: 10,
      sodium: 220,
      potassium: 90,
      calcium: 20,
      iron: 2,
      magnesium: 20,
      phosphorus: 80,
      zinc: 0.6,
      copper: 0.08,
      manganese: 0.25,
      vitaminE: 1.5,
      vitaminB1: 0.1,
      vitaminB2: 0.07,
      vitaminB3: 1.5,
      vitaminB5: 0.25,
      vitaminB6: 0.06,
      vitaminB9: 25,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 155 — OREO
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_155':
        NutritionRecord(
      calories: 482,
      protein: 5.5,
      carbohydrates: 75.5,
      fats: 19.1,
      fiber: 4.5,
      sugar: 43.6,
      saturatedFat: 8,
      sodium: 430,
      potassium: 190,
      calcium: 40,
      iron: 2.6,
      magnesium: 35,
      phosphorus: 110,
      zinc: 0.8,
      copper: 0.15,
      manganese: 0.3,
      vitaminE: 1.1,
      vitaminB1: 0.1,
      vitaminB2: 0.08,
      vitaminB3: 1.5,
      vitaminB5: 0.3,
      vitaminB6: 0.08,
      vitaminB9: 25,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 156 — CADBURY DAIRY MILK
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_156':
        NutritionRecord(
      calories: 532,
      protein: 7.2,
      carbohydrates: 60,
      fats: 30,
      fiber: 2,
      sugar: 56,
      saturatedFat: 18,
      cholesterol: 18,
      sodium: 80,
      potassium: 380,
      calcium: 200,
      iron: 1.1,
      magnesium: 65,
      phosphorus: 230,
      zinc: 1.8,
      copper: 0.3,
      manganese: 0.4,
      selenium: 6,
      iodine: 20,
      vitaminA: 35,
      vitaminD: 0.2,
      vitaminE: 1.2,
      vitaminK: 7,
      vitaminB1: 0.08,
      vitaminB2: 0.4,
      vitaminB3: 0.7,
      vitaminB5: 0.4,
      vitaminB6: 0.08,
      vitaminB9: 25,
      vitaminB12: 0.3,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 157 — CADBURY 5 STAR
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_157':
        NutritionRecord(
      calories: 468,
      protein: 5,
      carbohydrates: 59,
      fats: 22.7,
      fiber: 2.3,
      sugar: 47,
      saturatedFat: 13,
      cholesterol: 10,
      sodium: 95,
      potassium: 300,
      calcium: 115,
      iron: 1.2,
      magnesium: 55,
      phosphorus: 170,
      zinc: 1.2,
      copper: 0.2,
      manganese: 0.3,
      selenium: 4,
      vitaminA: 20,
      vitaminE: 0.8,
      vitaminK: 4,
      vitaminB1: 0.05,
      vitaminB2: 0.25,
      vitaminB3: 0.5,
      vitaminB5: 0.25,
      vitaminB6: 0.05,
      vitaminB9: 18,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 158 — KITKAT
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_158':
        NutritionRecord(
      calories: 510,
      protein: 6.1,
      carbohydrates: 65.9,
      fats: 24.4,
      fiber: 2.4,
      sugar: 45,
      saturatedFat: 13,
      cholesterol: 8,
      sodium: 180,
      potassium: 300,
      calcium: 90,
      iron: 1.8,
      magnesium: 55,
      phosphorus: 170,
      zinc: 1.2,
      copper: 0.2,
      manganese: 0.25,
      selenium: 5,
      vitaminA: 10,
      vitaminE: 0.9,
      vitaminK: 3,
      vitaminB1: 0.08,
      vitaminB2: 0.25,
      vitaminB3: 0.9,
      vitaminB5: 0.3,
      vitaminB6: 0.08,
      vitaminB9: 22,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 159 — MUNCH
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_159':
        NutritionRecord(
      calories: 500,
      protein: 6.1,
      carbohydrates: 60.6,
      fats: 24.2,
      fiber: 2.1,
      sugar: 35,
      saturatedFat: 13,
      cholesterol: 7,
      sodium: 150,
      potassium: 280,
      calcium: 85,
      iron: 1.6,
      magnesium: 50,
      phosphorus: 160,
      zinc: 1.1,
      copper: 0.2,
      manganese: 0.25,
      selenium: 5,
      vitaminA: 8,
      vitaminE: 0.8,
      vitaminK: 3,
      vitaminB1: 0.07,
      vitaminB2: 0.22,
      vitaminB3: 0.8,
      vitaminB5: 0.28,
      vitaminB6: 0.07,
      vitaminB9: 20,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 160 — SNICKERS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_160':
        NutritionRecord(
      calories: 488,
      protein: 9.6,
      carbohydrates: 60,
      fats: 24,
      fiber: 3,
      sugar: 48,
      saturatedFat: 8.5,
      cholesterol: 5,
      sodium: 240,
      potassium: 450,
      calcium: 100,
      iron: 2,
      magnesium: 85,
      phosphorus: 180,
      zinc: 1.7,
      copper: 0.3,
      manganese: 0.5,
      selenium: 5,
      vitaminA: 15,
      vitaminE: 2,
      vitaminK: 3,
      vitaminB1: 0.1,
      vitaminB2: 0.2,
      vitaminB3: 2.5,
      vitaminB5: 0.45,
      vitaminB6: 0.2,
      vitaminB9: 80,
      vitaminB12: 0.1,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 161 — GULAB JAMUN
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_161':
        NutritionRecord(
      calories: 350,
      protein: 6,
      carbohydrates: 56,
      fats: 12,
      fiber: 1,
      sugar: 40,
      saturatedFat: 6,
      cholesterol: 20,
      sodium: 130,
      potassium: 110,
      calcium: 100,
      iron: 1,
      magnesium: 20,
      phosphorus: 90,
      zinc: 0.7,
      copper: 0.05,
      manganese: 0.1,
      vitaminA: 40,
      vitaminD: 0.1,
      vitaminE: 0.2,
      vitaminB1: 0.05,
      vitaminB2: 0.12,
      vitaminB3: 0.4,
      vitaminB5: 0.3,
      vitaminB6: 0.04,
      vitaminB9: 8,
      vitaminB12: 0.2,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 162 — RASGULLA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_162':
        NutritionRecord(
      calories: 250,
      protein: 4,
      carbohydrates: 54,
      fats: 1,
      fiber: 0,
      sugar: 48,
      saturatedFat: 0.5,
      cholesterol: 4,
      sodium: 40,
      potassium: 65,
      calcium: 120,
      iron: 0.3,
      magnesium: 8,
      phosphorus: 70,
      zinc: 0.5,
      copper: 0.02,
      manganese: 0.02,
      iodine: 10,
      vitaminA: 8,
      vitaminD: 0.1,
      vitaminE: 0.05,
      vitaminB1: 0.03,
      vitaminB2: 0.08,
      vitaminB3: 0.1,
      vitaminB5: 0.2,
      vitaminB6: 0.02,
      vitaminB9: 4,
      vitaminB12: 0.15,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 163 — JALEBI
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_163':
        NutritionRecord(
      calories: 400,
      protein: 3.3,
      carbohydrates: 83,
      fats: 10,
      fiber: 0.7,
      sugar: 55,
      saturatedFat: 3,
      sodium: 180,
      potassium: 80,
      calcium: 30,
      iron: 1,
      magnesium: 10,
      phosphorus: 40,
      zinc: 0.3,
      copper: 0.05,
      manganese: 0.1,
      vitaminA: 0,
      vitaminE: 0.2,
      vitaminB1: 0.05,
      vitaminB2: 0.03,
      vitaminB3: 0.3,
      vitaminB5: 0.1,
      vitaminB6: 0.02,
      vitaminB9: 5,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 164 — KAJU KATLI
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_164':
        NutritionRecord(
      calories: 500,
      protein: 10,
      carbohydrates: 50,
      fats: 25,
      fiber: 2.5,
      sugar: 35,
      saturatedFat: 5,
      sodium: 15,
      potassium: 400,
      calcium: 45,
      iron: 5,
      magnesium: 145,
      phosphorus: 290,
      zinc: 2.5,
      copper: 1.1,
      manganese: 0.9,
      selenium: 4,
      vitaminE: 1.2,
      vitaminB1: 0.15,
      vitaminB2: 0.1,
      vitaminB3: 1.2,
      vitaminB5: 0.5,
      vitaminB6: 0.2,
      vitaminB9: 25,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 165 — MYSORE PAK
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_165':
        NutritionRecord(
      calories: 525,
      protein: 7.5,
      carbohydrates: 50,
      fats: 32.5,
      fiber: 2.5,
      sugar: 30,
      saturatedFat: 7.5,
      cholesterol: 15,
      sodium: 120,
      potassium: 180,
      calcium: 60,
      iron: 2.5,
      magnesium: 45,
      phosphorus: 120,
      zinc: 1,
      copper: 0.15,
      manganese: 0.3,
      vitaminA: 70,
      vitaminE: 2,
      vitaminB1: 0.1,
      vitaminB2: 0.05,
      vitaminB3: 0.8,
      vitaminB5: 0.3,
      vitaminB6: 0.08,
      vitaminB9: 25,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 166 — PASTA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_166':
        NutritionRecord(
      calories: 157,
      protein: 5.8,
      carbohydrates: 30.9,
      fats: 0.9,
      fiber: 1.8,
      sugar: 0.6,
      sodium: 1,
      potassium: 44,
      calcium: 21,
      iron: 1.3,
      magnesium: 53,
      phosphorus: 189,
      zinc: 1.5,
      copper: 0.2,
      manganese: 0.9,
      selenium: 26,
      vitaminE: 0.1,
      vitaminB1: 0.08,
      vitaminB2: 0.04,
      vitaminB3: 1,
      vitaminB5: 0.4,
      vitaminB6: 0.1,
      vitaminB9: 74,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 167 — PASTA ALFREDO
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_167':
        NutritionRecord(
      calories: 190,
      protein: 7,
      carbohydrates: 20,
      fats: 9,
      fiber: 1.5,
      sugar: 2,
      saturatedFat: 4,
      cholesterol: 20,
      sodium: 280,
      potassium: 120,
      calcium: 90,
      iron: 1.5,
      magnesium: 20,
      phosphorus: 110,
      zinc: 0.9,
      copper: 0.1,
      manganese: 0.25,
      selenium: 20,
      vitaminA: 70,
      vitaminD: 0.2,
      vitaminE: 0.8,
      vitaminK: 3,
      vitaminB1: 0.07,
      vitaminB2: 0.08,
      vitaminB3: 0.8,
      vitaminB5: 0.4,
      vitaminB6: 0.08,
      vitaminB9: 35,
      vitaminB12: 0.2,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 168 — PIZZA
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_168':
        NutritionRecord(
      calories: 250,
      protein: 10,
      carbohydrates: 33,
      fats: 8,
      fiber: 2,
      sugar: 3.5,
      saturatedFat: 3,
      cholesterol: 15,
      sodium: 600,
      potassium: 180,
      calcium: 180,
      iron: 2,
      magnesium: 25,
      phosphorus: 170,
      zinc: 1.5,
      copper: 0.12,
      manganese: 0.3,
      selenium: 20,
      vitaminA: 60,
      vitaminD: 0.2,
      vitaminE: 1.2,
      vitaminK: 3,
      vitaminB1: 0.1,
      vitaminB2: 0.15,
      vitaminB3: 2.2,
      vitaminB5: 0.5,
      vitaminB6: 0.15,
      vitaminB9: 45,
      vitaminB12: 0.3,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 169 — CHICKEN TACO
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_169':
        NutritionRecord(
      calories: 233,
      protein: 13.3,
      carbohydrates: 20,
      fats: 11.1,
      fiber: 2.2,
      sugar: 2,
      saturatedFat: 3.5,
      cholesterol: 35,
      sodium: 550,
      potassium: 220,
      calcium: 50,
      iron: 1.8,
      magnesium: 28,
      phosphorus: 120,
      zinc: 1.4,
      copper: 0.1,
      manganese: 0.2,
      selenium: 18,
      vitaminA: 35,
      vitaminC: 2,
      vitaminE: 1,
      vitaminK: 3,
      vitaminB1: 0.06,
      vitaminB2: 0.08,
      vitaminB3: 4,
      vitaminB5: 0.5,
      vitaminB6: 0.18,
      vitaminB9: 30,
      vitaminB12: 0.25,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 170 — SUSHI
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_170':
        NutritionRecord(
      calories: 145,
      protein: 5,
      carbohydrates: 22,
      fats: 4,
      fiber: 1,
      sugar: 2,
      sodium: 300,
      potassium: 120,
      calcium: 20,
      iron: 0.8,
      magnesium: 18,
      phosphorus: 70,
      zinc: 0.6,
      copper: 0.08,
      manganese: 0.15,
      selenium: 25,
      iodine: 25,
      vitaminA: 20,
      vitaminD: 1,
      vitaminE: 0.4,
      vitaminK: 2,
      vitaminB1: 0.05,
      vitaminB2: 0.06,
      vitaminB3: 1.2,
      vitaminB5: 0.3,
      vitaminB6: 0.12,
      vitaminB9: 15,
      vitaminB12: 0.8,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 171 — BURGER
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_171':
        NutritionRecord(
      calories: 233,
      protein: 11.1,
      carbohydrates: 22.2,
      fats: 11.1,
      fiber: 1.7,
      sugar: 3,
      saturatedFat: 4,
      cholesterol: 35,
      sodium: 500,
      potassium: 190,
      calcium: 90,
      iron: 2.2,
      magnesium: 25,
      phosphorus: 140,
      zinc: 1.4,
      copper: 0.12,
      manganese: 0.2,
      selenium: 20,
      vitaminA: 45,
      vitaminD: 0.1,
      vitaminE: 1,
      vitaminK: 3,
      vitaminB1: 0.08,
      vitaminB2: 0.12,
      vitaminB3: 2.5,
      vitaminB5: 0.4,
      vitaminB6: 0.15,
      vitaminB9: 30,
      vitaminB12: 0.25,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 172 — FRENCH FRIES
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_172':
        NutritionRecord(
      calories: 312,
      protein: 3.4,
      carbohydrates: 41,
      fats: 15,
      fiber: 3.8,
      sugar: 0.3,
      saturatedFat: 3,
      sodium: 210,
      potassium: 550,
      calcium: 18,
      iron: 0.8,
      magnesium: 30,
      phosphorus: 105,
      zinc: 0.35,
      copper: 0.12,
      manganese: 0.25,
      vitaminC: 6.5,
      vitaminE: 1,
      vitaminK: 3,
      vitaminB1: 0.12,
      vitaminB2: 0.04,
      vitaminB3: 1.7,
      vitaminB5: 0.35,
      vitaminB6: 0.25,
      vitaminB9: 16,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 173 — OATS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_173':
        NutritionRecord(
      calories: 389,
      protein: 16.9,
      carbohydrates: 66.3,
      fats: 6.9,
      fiber: 10.6,
      sugar: 0.9,
      saturatedFat: 1.2,
      sodium: 2,
      potassium: 429,
      calcium: 54,
      iron: 4.72,
      magnesium: 177,
      phosphorus: 523,
      zinc: 3.97,
      copper: 0.63,
      manganese: 4.9,
      selenium: 28.9,
      vitaminE: 0.42,
      vitaminB1: 0.76,
      vitaminB2: 0.14,
      vitaminB3: 0.96,
      vitaminB5: 1.35,
      vitaminB6: 0.12,
      vitaminB9: 56,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 174 — OATS PORRIDGE
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_174':
        NutritionRecord(
      calories: 64,
      protein: 2.4,
      carbohydrates: 10.8,
      fats: 1.2,
      fiber: 1.6,
      sugar: 1.2,
      saturatedFat: 0.3,
      sodium: 35,
      potassium: 80,
      calcium: 40,
      iron: 1,
      magnesium: 25,
      phosphorus: 60,
      zinc: 0.6,
      copper: 0.08,
      manganese: 0.8,
      vitaminB1: 0.12,
      vitaminB2: 0.05,
      vitaminB3: 0.3,
      vitaminB5: 0.2,
      vitaminB6: 0.05,
      vitaminB9: 15,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 175 — BOILED CORN
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_175':
        NutritionRecord(
      calories: 96,
      protein: 3.4,
      carbohydrates: 21,
      fats: 1.5,
      fiber: 2.4,
      sugar: 4.5,
      sodium: 1,
      potassium: 218,
      calcium: 2,
      iron: 0.5,
      magnesium: 37,
      phosphorus: 77,
      zinc: 0.62,
      copper: 0.05,
      manganese: 0.15,
      selenium: 0.6,
      vitaminA: 9,
      vitaminC: 5.5,
      vitaminE: 0.07,
      vitaminK: 0.4,
      vitaminB1: 0.09,
      vitaminB2: 0.06,
      vitaminB3: 1.8,
      vitaminB5: 0.7,
      vitaminB6: 0.06,
      vitaminB9: 42,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 176 — PEANUT BUTTER
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_176':
        NutritionRecord(
      calories: 588,
      protein: 25,
      carbohydrates: 20,
      fats: 50,
      fiber: 6,
      sugar: 9,
      saturatedFat: 10,
      sodium: 450,
      potassium: 650,
      calcium: 43,
      iron: 1.9,
      magnesium: 154,
      phosphorus: 358,
      zinc: 3.3,
      copper: 0.49,
      manganese: 1.7,
      selenium: 4.1,
      vitaminE: 9.1,
      vitaminB1: 0.11,
      vitaminB2: 0.13,
      vitaminB3: 13,
      vitaminB5: 1.77,
      vitaminB6: 0.44,
      vitaminB9: 92,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 177 — WHOLE WHEAT BREAD
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_177':
        NutritionRecord(
      calories: 250,
      protein: 10,
      carbohydrates: 43.3,
      fats: 3.3,
      fiber: 6.7,
      sugar: 4,
      saturatedFat: 0.6,
      sodium: 450,
      potassium: 230,
      calcium: 100,
      iron: 2.5,
      magnesium: 80,
      phosphorus: 180,
      zinc: 1.5,
      copper: 0.18,
      manganese: 1.2,
      selenium: 30,
      vitaminE: 1,
      vitaminK: 4,
      vitaminB1: 0.25,
      vitaminB2: 0.18,
      vitaminB3: 4,
      vitaminB5: 0.55,
      vitaminB6: 0.2,
      vitaminB9: 45,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 178 — PEANUT BUTTER TOAST
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_178':
        NutritionRecord(
      calories: 291,
      protein: 12.7,
      carbohydrates: 32.7,
      fats: 12.7,
      fiber: 5.5,
      sugar: 4,
      saturatedFat: 2.5,
      sodium: 300,
      potassium: 350,
      calcium: 65,
      iron: 2,
      magnesium: 70,
      phosphorus: 220,
      zinc: 1.5,
      copper: 0.2,
      manganese: 0.8,
      selenium: 18,
      vitaminE: 2.8,
      vitaminK: 2,
      vitaminB1: 0.18,
      vitaminB2: 0.12,
      vitaminB3: 3,
      vitaminB5: 0.6,
      vitaminB6: 0.16,
      vitaminB9: 35,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 179 — FRUIT BOWL
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_179':
        NutritionRecord(
      calories: 60,
      protein: 0.8,
      carbohydrates: 14,
      fats: 0.4,
      fiber: 2,
      sugar: 10,
      sodium: 5,
      potassium: 140,
      calcium: 20,
      iron: 0.3,
      magnesium: 10,
      phosphorus: 18,
      zinc: 0.1,
      copper: 0.05,
      manganese: 0.05,
      vitaminA: 50,
      vitaminC: 15,
      vitaminE: 0.3,
      vitaminK: 4,
      vitaminB1: 0.03,
      vitaminB2: 0.03,
      vitaminB3: 0.2,
      vitaminB5: 0.1,
      vitaminB6: 0.05,
      vitaminB9: 8,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),

    // ==========================================================
    // FOOD 180 — MIXED SPROUTS
    // Reference basis: 100 g (or approximately 100 ml for beverages)
    // Estimated reference value for detailed micronutrients
    // ==========================================================

    'food_180':
        NutritionRecord(
      calories: 83,
      protein: 6,
      carbohydrates: 13.3,
      fats: 0.7,
      fiber: 4,
      sugar: 1.5,
      sodium: 20,
      potassium: 220,
      calcium: 35,
      iron: 1.5,
      magnesium: 45,
      phosphorus: 100,
      zinc: 0.9,
      copper: 0.18,
      manganese: 0.35,
      selenium: 2,
      vitaminA: 15,
      vitaminC: 10,
      vitaminE: 0.3,
      vitaminK: 20,
      vitaminB1: 0.12,
      vitaminB2: 0.1,
      vitaminB3: 1,
      vitaminB5: 0.3,
      vitaminB6: 0.15,
      vitaminB9: 90,
      preparationState: 'Standard',
      source: 'Estimated reference value',
      verified: false,
    ),
  };
  // ============================================================
  // FIND RECORD
  // ============================================================

  static NutritionRecord? findByFoodId(
    String foodId,
  ) {
    return records[foodId];
  }

  // ============================================================
  // HAS RECORD
  // ============================================================

  static bool contains(
    String foodId,
  ) {
    return records.containsKey(
      foodId,
    );
  }

  // ============================================================
  // ALL RECORDS
  // ============================================================

  static List<NutritionRecord>
      get allRecords {
    return List.unmodifiable(
      records.values,
    );
  }
}