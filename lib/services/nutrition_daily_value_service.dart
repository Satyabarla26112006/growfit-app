class NutritionDailyValueService {
  NutritionDailyValueService._();

  // Standard FDA Daily Values used for general nutrition-label style %DV.
  // These are separate from GrowFit's personalized daily targets.
  static const double calories = 2000;
  static const double totalFatGrams = 78;
  static const double saturatedFatGrams = 20;
  static const double cholesterolMg = 300;
  static const double sodiumMg = 2300;
  static const double totalCarbohydrateGrams = 275;
  static const double dietaryFiberGrams = 28;
  static const double addedSugarGrams = 50;
  static const double potassiumMg = 4700;
  static const double calciumMg = 1300;
  static const double ironMg = 18;
  static const double magnesiumMg = 420;
  static const double phosphorusMg = 1250;
  static const double zincMg = 11;
  static const double copperMg = 0.9;
  static const double manganeseMg = 2.3;
  static const double seleniumMcg = 55;
  static const double iodineMcg = 150;
  static const double vitaminAMcgRae = 900;
  static const double vitaminCMg = 90;
  static const double vitaminDMcg = 20;
  static const double vitaminEMg = 15;
  static const double vitaminKMcg = 120;
  static const double vitaminB1Mg = 1.2;
  static const double vitaminB2Mg = 1.3;
  static const double vitaminB3Mg = 16;
  static const double vitaminB5Mg = 5;
  static const double vitaminB6Mg = 1.7;
  static const double vitaminB7Mcg = 30;
  static const double vitaminB9McgDfe = 400;
  static const double vitaminB12Mcg = 2.4;
  static const double proteinGrams = 50;

  static int? percent(double amount, double dailyValue) {
    if (dailyValue <= 0 || amount <= 0) return 0;
    return (amount / dailyValue * 100).round();
  }

  static String percentLabel(double amount, double dailyValue) {
    return '${percent(amount, dailyValue) ?? 0}% DV';
  }

  static int? caloriesPercent(double amount) {
    return percent(amount, calories);
  }

  static int? totalFatPercent(double amount) =>
      percent(amount, totalFatGrams);

  static int? saturatedFatPercent(double amount) =>
      percent(amount, saturatedFatGrams);

  static int? cholesterolPercent(double amount) =>
      percent(amount, cholesterolMg);

  static int? sodiumPercent(double amount) =>
      percent(amount, sodiumMg);

  static int? carbohydratePercent(double amount) =>
      percent(amount, totalCarbohydrateGrams);

  static int? fiberPercent(double amount) =>
      percent(amount, dietaryFiberGrams);

  static int? addedSugarPercent(double amount) =>
      percent(amount, addedSugarGrams);

  static int? potassiumPercent(double amount) =>
      percent(amount, potassiumMg);

  static int? calciumPercent(double amount) =>
      percent(amount, calciumMg);

  static int? ironPercent(double amount) =>
      percent(amount, ironMg);

  static int? magnesiumPercent(double amount) =>
      percent(amount, magnesiumMg);

  static int? phosphorusPercent(double amount) =>
      percent(amount, phosphorusMg);

  static int? zincPercent(double amount) =>
      percent(amount, zincMg);

  static int? copperPercent(double amount) =>
      percent(amount, copperMg);

  static int? manganesePercent(double amount) =>
      percent(amount, manganeseMg);

  static int? seleniumPercent(double amount) =>
      percent(amount, seleniumMcg);

  static int? iodinePercent(double amount) =>
      percent(amount, iodineMcg);

  static int? vitaminAPercent(double amount) =>
      percent(amount, vitaminAMcgRae);

  static int? vitaminCPercent(double amount) =>
      percent(amount, vitaminCMg);

  static int? vitaminDPercent(double amount) =>
      percent(amount, vitaminDMcg);

  static int? vitaminEPercent(double amount) =>
      percent(amount, vitaminEMg);

  static int? vitaminKPercent(double amount) =>
      percent(amount, vitaminKMcg);

  static int? vitaminB1Percent(double amount) =>
      percent(amount, vitaminB1Mg);

  static int? vitaminB2Percent(double amount) =>
      percent(amount, vitaminB2Mg);

  static int? vitaminB3Percent(double amount) =>
      percent(amount, vitaminB3Mg);

  static int? vitaminB5Percent(double amount) =>
      percent(amount, vitaminB5Mg);

  static int? vitaminB6Percent(double amount) =>
      percent(amount, vitaminB6Mg);

  static int? vitaminB7Percent(double amount) =>
      percent(amount, vitaminB7Mcg);

  static int? vitaminB9Percent(double amount) =>
      percent(amount, vitaminB9McgDfe);

  static int? vitaminB12Percent(double amount) =>
      percent(amount, vitaminB12Mcg);
}
