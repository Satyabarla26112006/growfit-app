import '../data/food_data.dart';
import '../models/food_log_model.dart';
import '../models/food_model.dart';

class DailyNutritionService {
  DailyNutritionService._();

  // ============================================================
  // TODAY TOTALS — CORE
  // ============================================================

  static double calories = 0;
  static double protein = 0;
  static double carbohydrates = 0;
  static double fats = 0;
  static double fiber = 0;
  static double sugar = 0;

  // ============================================================
  // TODAY TOTALS — SUGAR / FAT / OTHER
  // ============================================================

  static double addedSugar = 0;
  static double saturatedFat = 0;
  static double transFat = 0;
  static double cholesterol = 0;
  static double sodium = 0;

  // ============================================================
  // TODAY TOTALS — MINERALS
  // ============================================================

  static double potassium = 0;
  static double calcium = 0;
  static double iron = 0;
  static double magnesium = 0;
  static double phosphorus = 0;
  static double zinc = 0;
  static double copper = 0;
  static double manganese = 0;
  static double selenium = 0;
  static double iodine = 0;

  // ============================================================
  // TODAY TOTALS — VITAMINS
  // ============================================================

  static double vitaminA = 0;
  static double vitaminC = 0;
  static double vitaminD = 0;
  static double vitaminE = 0;
  static double vitaminK = 0;

  static double vitaminB1 = 0;
  static double vitaminB2 = 0;
  static double vitaminB3 = 0;
  static double vitaminB5 = 0;
  static double vitaminB6 = 0;
  static double vitaminB7 = 0;
  static double vitaminB9 = 0;
  static double vitaminB12 = 0;

  // ============================================================
  // MEAL TOTALS — CALORIES
  // ============================================================

  static double breakfastCalories = 0;
  static double lunchCalories = 0;
  static double dinnerCalories = 0;
  static double snackCalories = 0;

  // ============================================================
  // RECENT FOODS
  // ============================================================

  static final List<String> _recentFoodIds = [];

  static List<FoodModel> get recentFoods {
    final result = <FoodModel>[];

    for (final id in _recentFoodIds) {
      final food = FoodData.findById(id);

      if (food != null) {
        result.add(food);
      }
    }

    return List.unmodifiable(result);
  }

  // ============================================================
  // REMEMBER FOOD
  // ============================================================

  static void _rememberFood(
    FoodModel food,
  ) {
    _recentFoodIds.remove(food.id);

    _recentFoodIds.insert(
      0,
      food.id,
    );

    if (_recentFoodIds.length > 12) {
      _recentFoodIds.removeLast();
    }
  }

  // ============================================================
  // ADD FOOD LOG
  // ============================================================

  static void addFoodLog(
    FoodLogModel log,
  ) {
    calories += log.calories;
    protein += log.protein;
    carbohydrates += log.carbs;
    fats += log.fats;
    fiber += log.fiber;
    sugar += log.sugar;

    addedSugar += log.addedSugar;
    saturatedFat += log.saturatedFat;
    transFat += log.transFat;
    cholesterol += log.cholesterol;
    sodium += log.sodium;

    potassium += log.potassium;
    calcium += log.calcium;
    iron += log.iron;
    magnesium += log.magnesium;
    phosphorus += log.phosphorus;
    zinc += log.zinc;
    copper += log.copper;
    manganese += log.manganese;
    selenium += log.selenium;
    iodine += log.iodine;

    vitaminA += log.vitaminA;
    vitaminC += log.vitaminC;
    vitaminD += log.vitaminD;
    vitaminE += log.vitaminE;
    vitaminK += log.vitaminK;

    vitaminB1 += log.vitaminB1;
    vitaminB2 += log.vitaminB2;
    vitaminB3 += log.vitaminB3;
    vitaminB5 += log.vitaminB5;
    vitaminB6 += log.vitaminB6;
    vitaminB7 += log.vitaminB7;
    vitaminB9 += log.vitaminB9;
    vitaminB12 += log.vitaminB12;

    final food = FoodData.findById(
      log.foodId,
    );

    if (food != null) {
      _rememberFood(food);
    }

    _addMealCalories(
      log.mealType,
      log.calories,
    );
  }

  // ============================================================
  // ADD FOOD DIRECTLY
  // ============================================================

  static void addFood({
    required FoodModel food,
    required double quantity,
    required String meal,
  }) {
    if (quantity <= 0 ||
        food.servingSize <= 0) {
      return;
    }

    final multiplier =
        quantity /
            food.servingSize;

    // ------------------------------------------------------------
    // CORE NUTRITION
    // ------------------------------------------------------------

    final addedCalories =
        food.calories *
            multiplier;

    final addedProtein =
        food.protein *
            multiplier;

    final addedCarbs =
        food.carbohydrates *
            multiplier;

    final addedFats =
        food.fats *
            multiplier;

    final addedFiber =
        food.fiber *
            multiplier;

    final addedTotalSugar =
        food.sugar *
            multiplier;

    // ------------------------------------------------------------
    // ADDITIONAL NUTRITION
    // ------------------------------------------------------------

    final addedAddedSugar =
        food.addedSugar *
            multiplier;

    final addedSaturatedFat =
        food.saturatedFat *
            multiplier;

    final addedTransFat =
        food.transFat *
            multiplier;

    final addedCholesterol =
        food.cholesterol *
            multiplier;

    final addedSodium =
        food.sodium *
            multiplier;

    // ------------------------------------------------------------
    // MINERALS
    // ------------------------------------------------------------

    final addedPotassium =
        food.potassium *
            multiplier;

    final addedCalcium =
        food.calcium *
            multiplier;

    final addedIron =
        food.iron *
            multiplier;

    final addedMagnesium =
        food.magnesium *
            multiplier;

    final addedPhosphorus =
        food.phosphorus *
            multiplier;

    final addedZinc =
        food.zinc *
            multiplier;

    final addedCopper =
        food.copper *
            multiplier;

    final addedManganese =
        food.manganese *
            multiplier;

    final addedSelenium =
        food.selenium *
            multiplier;

    final addedIodine =
        food.iodine *
            multiplier;

    // ------------------------------------------------------------
    // VITAMINS
    // ------------------------------------------------------------

    final addedVitaminA =
        food.vitaminA *
            multiplier;

    final addedVitaminC =
        food.vitaminC *
            multiplier;

    final addedVitaminD =
        food.vitaminD *
            multiplier;

    final addedVitaminE =
        food.vitaminE *
            multiplier;

    final addedVitaminK =
        food.vitaminK *
            multiplier;

    final addedVitaminB1 =
        food.vitaminB1 *
            multiplier;

    final addedVitaminB2 =
        food.vitaminB2 *
            multiplier;

    final addedVitaminB3 =
        food.vitaminB3 *
            multiplier;

    final addedVitaminB5 =
        food.vitaminB5 *
            multiplier;

    final addedVitaminB6 =
        food.vitaminB6 *
            multiplier;

    final addedVitaminB7 =
        food.vitaminB7 *
            multiplier;

    final addedVitaminB9 =
        food.vitaminB9 *
            multiplier;

    final addedVitaminB12 =
        food.vitaminB12 *
            multiplier;

    // ============================================================
    // UPDATE CORE TOTALS
    // ============================================================

    calories += addedCalories;
    protein += addedProtein;
    carbohydrates += addedCarbs;
    fats += addedFats;
    fiber += addedFiber;
    sugar += addedTotalSugar;

    // ============================================================
    // UPDATE ADDITIONAL TOTALS
    // ============================================================

    addedSugar += addedAddedSugar;
    saturatedFat += addedSaturatedFat;
    transFat += addedTransFat;
    cholesterol += addedCholesterol;
    sodium += addedSodium;

    // ============================================================
    // UPDATE MINERAL TOTALS
    // ============================================================

    potassium += addedPotassium;
    calcium += addedCalcium;
    iron += addedIron;
    magnesium += addedMagnesium;
    phosphorus += addedPhosphorus;
    zinc += addedZinc;
    copper += addedCopper;
    manganese += addedManganese;
    selenium += addedSelenium;
    iodine += addedIodine;

    // ============================================================
    // UPDATE VITAMIN TOTALS
    // ============================================================

    vitaminA += addedVitaminA;
    vitaminC += addedVitaminC;
    vitaminD += addedVitaminD;
    vitaminE += addedVitaminE;
    vitaminK += addedVitaminK;

    vitaminB1 += addedVitaminB1;
    vitaminB2 += addedVitaminB2;
    vitaminB3 += addedVitaminB3;
    vitaminB5 += addedVitaminB5;
    vitaminB6 += addedVitaminB6;
    vitaminB7 += addedVitaminB7;
    vitaminB9 += addedVitaminB9;
    vitaminB12 += addedVitaminB12;

    // ============================================================
    // RECENT FOOD
    // ============================================================

    _rememberFood(food);

    // ============================================================
    // MEAL CALORIES
    // ============================================================

    _addMealCalories(
      meal,
      addedCalories,
    );
  }

  // ============================================================
  // REMOVE FOOD LOG
  // ============================================================

  static void removeFoodLog(
    FoodLogModel log,
  ) {
    calories -= log.calories;
    protein -= log.protein;
    carbohydrates -= log.carbs;
    fats -= log.fats;
    fiber -= log.fiber;
    sugar -= log.sugar;

    addedSugar -= log.addedSugar;
    saturatedFat -= log.saturatedFat;
    transFat -= log.transFat;
    cholesterol -= log.cholesterol;
    sodium -= log.sodium;

    potassium -= log.potassium;
    calcium -= log.calcium;
    iron -= log.iron;
    magnesium -= log.magnesium;
    phosphorus -= log.phosphorus;
    zinc -= log.zinc;
    copper -= log.copper;
    manganese -= log.manganese;
    selenium -= log.selenium;
    iodine -= log.iodine;

    vitaminA -= log.vitaminA;
    vitaminC -= log.vitaminC;
    vitaminD -= log.vitaminD;
    vitaminE -= log.vitaminE;
    vitaminK -= log.vitaminK;

    vitaminB1 -= log.vitaminB1;
    vitaminB2 -= log.vitaminB2;
    vitaminB3 -= log.vitaminB3;
    vitaminB5 -= log.vitaminB5;
    vitaminB6 -= log.vitaminB6;
    vitaminB7 -= log.vitaminB7;
    vitaminB9 -= log.vitaminB9;
    vitaminB12 -= log.vitaminB12;

    _removeMealCalories(
      log.mealType,
      log.calories,
    );

    _preventNegativeValues();
  }

  // ============================================================
  // ADD MEAL CALORIES
  // ============================================================

  static void _addMealCalories(
    String meal,
    double value,
  ) {
    switch (meal.toLowerCase()) {
      case 'breakfast':
        breakfastCalories += value;
        break;

      case 'lunch':
        lunchCalories += value;
        break;

      case 'dinner':
        dinnerCalories += value;
        break;

      case 'snack':
      case 'snacks':
        snackCalories += value;
        break;
    }
  }

  // ============================================================
  // REMOVE MEAL CALORIES
  // ============================================================

  static void _removeMealCalories(
    String meal,
    double value,
  ) {
    switch (meal.toLowerCase()) {
      case 'breakfast':
        breakfastCalories -= value;
        break;

      case 'lunch':
        lunchCalories -= value;
        break;

      case 'dinner':
        dinnerCalories -= value;
        break;

      case 'snack':
      case 'snacks':
        snackCalories -= value;
        break;
    }
  }

  // ============================================================
  // PREVENT NEGATIVE VALUES
  // ============================================================

  static void _preventNegativeValues() {
    calories =
        _positiveOrZero(
      calories,
    );

    protein =
        _positiveOrZero(
      protein,
    );

    carbohydrates =
        _positiveOrZero(
      carbohydrates,
    );

    fats =
        _positiveOrZero(
      fats,
    );

    fiber =
        _positiveOrZero(
      fiber,
    );

    sugar =
        _positiveOrZero(
      sugar,
    );

    addedSugar =
        _positiveOrZero(
      addedSugar,
    );

    saturatedFat =
        _positiveOrZero(
      saturatedFat,
    );

    transFat =
        _positiveOrZero(
      transFat,
    );

    cholesterol =
        _positiveOrZero(
      cholesterol,
    );

    sodium =
        _positiveOrZero(
      sodium,
    );

    potassium =
        _positiveOrZero(
      potassium,
    );

    calcium =
        _positiveOrZero(
      calcium,
    );

    iron =
        _positiveOrZero(
      iron,
    );

    magnesium =
        _positiveOrZero(
      magnesium,
    );

    phosphorus =
        _positiveOrZero(
      phosphorus,
    );

    zinc =
        _positiveOrZero(
      zinc,
    );

    copper =
        _positiveOrZero(
      copper,
    );

    manganese =
        _positiveOrZero(
      manganese,
    );

    selenium =
        _positiveOrZero(
      selenium,
    );

    iodine =
        _positiveOrZero(
      iodine,
    );

    vitaminA =
        _positiveOrZero(
      vitaminA,
    );

    vitaminC =
        _positiveOrZero(
      vitaminC,
    );

    vitaminD =
        _positiveOrZero(
      vitaminD,
    );

    vitaminE =
        _positiveOrZero(
      vitaminE,
    );

    vitaminK =
        _positiveOrZero(
      vitaminK,
    );

    vitaminB1 =
        _positiveOrZero(
      vitaminB1,
    );

    vitaminB2 =
        _positiveOrZero(
      vitaminB2,
    );

    vitaminB3 =
        _positiveOrZero(
      vitaminB3,
    );

    vitaminB5 =
        _positiveOrZero(
      vitaminB5,
    );

    vitaminB6 =
        _positiveOrZero(
      vitaminB6,
    );

    vitaminB7 =
        _positiveOrZero(
      vitaminB7,
    );

    vitaminB9 =
        _positiveOrZero(
      vitaminB9,
    );

    vitaminB12 =
        _positiveOrZero(
      vitaminB12,
    );

    breakfastCalories =
        _positiveOrZero(
      breakfastCalories,
    );

    lunchCalories =
        _positiveOrZero(
      lunchCalories,
    );

    dinnerCalories =
        _positiveOrZero(
      dinnerCalories,
    );

    snackCalories =
        _positiveOrZero(
      snackCalories,
    );
  }

  // ============================================================
  // POSITIVE OR ZERO
  // ============================================================

  static double _positiveOrZero(
    double value,
  ) {
    return value < 0 ? 0 : value;
  }

  // ============================================================
  // RESET TODAY
  // ============================================================

  static void resetToday() {
    calories = 0;
    protein = 0;
    carbohydrates = 0;
    fats = 0;
    fiber = 0;
    sugar = 0;

    addedSugar = 0;
    saturatedFat = 0;
    transFat = 0;
    cholesterol = 0;
    sodium = 0;

    potassium = 0;
    calcium = 0;
    iron = 0;
    magnesium = 0;
    phosphorus = 0;
    zinc = 0;
    copper = 0;
    manganese = 0;
    selenium = 0;
    iodine = 0;

    vitaminA = 0;
    vitaminC = 0;
    vitaminD = 0;
    vitaminE = 0;
    vitaminK = 0;

    vitaminB1 = 0;
    vitaminB2 = 0;
    vitaminB3 = 0;
    vitaminB5 = 0;
    vitaminB6 = 0;
    vitaminB7 = 0;
    vitaminB9 = 0;
    vitaminB12 = 0;

    breakfastCalories = 0;
    lunchCalories = 0;
    dinnerCalories = 0;
    snackCalories = 0;
  }

  // ============================================================
  // CORE TOTAL GETTERS
  // ============================================================

  static double get totalCalories {
    return calories;
  }

  static double get totalProtein {
    return protein;
  }

  static double get totalCarbohydrates {
    return carbohydrates;
  }

  static double get totalFats {
    return fats;
  }

  static double get totalFiber {
    return fiber;
  }

  static double get totalSugar {
    return sugar;
  }

  // ============================================================
  // ADDITIONAL TOTAL GETTERS
  // ============================================================

  static double get totalAddedSugar {
    return addedSugar;
  }

  static double get totalSaturatedFat {
    return saturatedFat;
  }

  static double get totalTransFat {
    return transFat;
  }

  static double get totalCholesterol {
    return cholesterol;
  }

  static double get totalSodium {
    return sodium;
  }

  // ============================================================
  // MINERAL GETTERS
  // ============================================================

  static double get totalPotassium {
    return potassium;
  }

  static double get totalCalcium {
    return calcium;
  }

  static double get totalIron {
    return iron;
  }

  static double get totalMagnesium {
    return magnesium;
  }

  static double get totalPhosphorus {
    return phosphorus;
  }

  static double get totalZinc {
    return zinc;
  }

  static double get totalCopper {
    return copper;
  }

  static double get totalManganese {
    return manganese;
  }

  static double get totalSelenium {
    return selenium;
  }

  static double get totalIodine {
    return iodine;
  }

  // ============================================================
  // VITAMIN GETTERS
  // ============================================================

  static double get totalVitaminA {
    return vitaminA;
  }

  static double get totalVitaminC {
    return vitaminC;
  }

  static double get totalVitaminD {
    return vitaminD;
  }

  static double get totalVitaminE {
    return vitaminE;
  }

  static double get totalVitaminK {
    return vitaminK;
  }

  static double get totalVitaminB1 {
    return vitaminB1;
  }

  static double get totalVitaminB2 {
    return vitaminB2;
  }

  static double get totalVitaminB3 {
    return vitaminB3;
  }

  static double get totalVitaminB5 {
    return vitaminB5;
  }

  static double get totalVitaminB6 {
    return vitaminB6;
  }

  static double get totalVitaminB7 {
    return vitaminB7;
  }

  static double get totalVitaminB9 {
    return vitaminB9;
  }

  static double get totalVitaminB12 {
    return vitaminB12;
  }
}