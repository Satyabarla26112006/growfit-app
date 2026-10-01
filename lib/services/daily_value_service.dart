class DailyValueService {
  DailyValueService._();

  // ============================================================
  // OFFICIAL DAILY VALUES
  //
  // These are reference Daily Values used for %DV calculation.
  //
  // Amount units:
  // g  = grams
  // mg = milligrams
  // mcg = micrograms
  //
  // Vitamin A  = mcg RAE
  // Vitamin D  = mcg
  // Vitamin E  = mg alpha-tocopherol
  // Vitamin K  = mcg
  // Vitamin B9 = mcg DFE
  // Vitamin B12 = mcg
  // ============================================================

  static const double calories = 2000;
  static const double totalFat = 78;
  static const double saturatedFat = 20;
  static const double cholesterol = 300;
  static const double sodium = 2300;

  static const double totalCarbohydrates = 275;
  static const double fiber = 28;
  static const double addedSugar = 50;
  static const double protein = 50;

  // ============================================================
  // VITAMINS
  // ============================================================

  static const double vitaminA = 900;
  static const double vitaminC = 90;
  static const double vitaminD = 20;
  static const double vitaminE = 15;
  static const double vitaminK = 120;

  static const double vitaminB1 = 1.2;
  static const double vitaminB2 = 1.3;
  static const double vitaminB3 = 16;
  static const double vitaminB5 = 5;
  static const double vitaminB6 = 1.7;
  static const double vitaminB7 = 30;
  static const double vitaminB9 = 400;
  static const double vitaminB12 = 2.4;

  // ============================================================
  // MINERALS
  // ============================================================

  static const double calcium = 1300;
  static const double iron = 18;
  static const double magnesium = 420;
  static const double phosphorus = 1250;
  static const double potassium = 4700;
  static const double zinc = 11;
  static const double copper = 0.9;
  static const double manganese = 2.3;
  static const double selenium = 55;
  static const double iodine = 150;

  // ============================================================
  // GENERIC %DV
  // ============================================================

  static double percent(
    double amount,
    double dailyValue,
  ) {
    if (amount <= 0 ||
        dailyValue <= 0) {
      return 0;
    }

    return (amount /
            dailyValue) *
        100;
  }

  // ============================================================
  // ROUND %DV
  // ============================================================

  static int percentRounded(
    double amount,
    double dailyValue,
  ) {
    return percent(
      amount,
      dailyValue,
    ).round();
  }

  // ============================================================
  // CORE NUTRIENTS
  // ============================================================

  static int proteinPercent(
    double grams,
  ) {
    return percentRounded(
      grams,
      protein,
    );
  }

  static int carbsPercent(
    double grams,
  ) {
    return percentRounded(
      grams,
      totalCarbohydrates,
    );
  }

  static int fatPercent(
    double grams,
  ) {
    return percentRounded(
      grams,
      totalFat,
    );
  }

  static int saturatedFatPercent(
    double grams,
  ) {
    return percentRounded(
      grams,
      saturatedFat,
    );
  }

  static int fiberPercent(
    double grams,
  ) {
    return percentRounded(
      grams,
      fiber,
    );
  }

  static int addedSugarPercent(
    double grams,
  ) {
    return percentRounded(
      grams,
      addedSugar,
    );
  }

  static int cholesterolPercent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      cholesterol,
    );
  }

  static int sodiumPercent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      sodium,
    );
  }

  // ============================================================
  // VITAMIN %DV
  // ============================================================

  static int vitaminAPercent(
    double microgramsRae,
  ) {
    return percentRounded(
      microgramsRae,
      vitaminA,
    );
  }

  static int vitaminCPercent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      vitaminC,
    );
  }

  static int vitaminDPercent(
    double micrograms,
  ) {
    return percentRounded(
      micrograms,
      vitaminD,
    );
  }

  static int vitaminEPercent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      vitaminE,
    );
  }

  static int vitaminKPercent(
    double micrograms,
  ) {
    return percentRounded(
      micrograms,
      vitaminK,
    );
  }

  static int vitaminB1Percent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      vitaminB1,
    );
  }

  static int vitaminB2Percent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      vitaminB2,
    );
  }

  static int vitaminB3Percent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      vitaminB3,
    );
  }

  static int vitaminB5Percent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      vitaminB5,
    );
  }

  static int vitaminB6Percent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      vitaminB6,
    );
  }

  static int vitaminB7Percent(
    double micrograms,
  ) {
    return percentRounded(
      micrograms,
      vitaminB7,
    );
  }

  static int vitaminB9Percent(
    double microgramsDfe,
  ) {
    return percentRounded(
      microgramsDfe,
      vitaminB9,
    );
  }

  static int vitaminB12Percent(
    double micrograms,
  ) {
    return percentRounded(
      micrograms,
      vitaminB12,
    );
  }

  // ============================================================
  // MINERAL %DV
  // ============================================================

  static int calciumPercent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      calcium,
    );
  }

  static int ironPercent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      iron,
    );
  }

  static int magnesiumPercent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      magnesium,
    );
  }

  static int phosphorusPercent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      phosphorus,
    );
  }

  static int potassiumPercent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      potassium,
    );
  }

  static int zincPercent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      zinc,
    );
  }

  static int copperPercent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      copper,
    );
  }

  static int manganesePercent(
    double milligrams,
  ) {
    return percentRounded(
      milligrams,
      manganese,
    );
  }

  static int seleniumPercent(
    double micrograms,
  ) {
    return percentRounded(
      micrograms,
      selenium,
    );
  }

  static int iodinePercent(
    double micrograms,
  ) {
    return percentRounded(
      micrograms,
      iodine,
    );
  }
}