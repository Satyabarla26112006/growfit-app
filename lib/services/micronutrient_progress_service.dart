import '../models/food_log_model.dart';
import 'nutrition_daily_value_service.dart';

class MicronutrientProgress {
  final String keyName;
  final String name;
  final double consumed;
  final double dailyValue;
  final String unit;
  final bool isMicrogram;

  const MicronutrientProgress({
    required this.keyName,
    required this.name,
    required this.consumed,
    required this.dailyValue,
    required this.unit,
    required this.isMicrogram,
  });

  double get fraction {
    if (dailyValue <= 0) return 0;
    return (consumed / dailyValue).clamp(0.0, 1.0);
  }

  double get percentage {
    if (dailyValue <= 0) return 0;
    return consumed / dailyValue * 100;
  }

  String get status {
    if (percentage < 50) return 'Low';
    if (percentage < 80) return 'Building';
    return 'Strong';
  }
}

class MicronutrientProgressService {
  MicronutrientProgressService._();

  static List<MicronutrientProgress> vitamins(
    List<FoodLogModel> logs,
  ) {
    final totals = _Totals.fromLogs(logs);

    return [
      _item(
        keyName: 'vitaminA',
        name: 'Vitamin A',
        consumed: totals.vitaminA,
        dailyValue: NutritionDailyValueService.vitaminAMcgRae,
        unit: 'mcg',
        isMicrogram: true,
      ),
      _item(
        keyName: 'vitaminC',
        name: 'Vitamin C',
        consumed: totals.vitaminC,
        dailyValue: NutritionDailyValueService.vitaminCMg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'vitaminD',
        name: 'Vitamin D',
        consumed: totals.vitaminD,
        dailyValue: NutritionDailyValueService.vitaminDMcg,
        unit: 'mcg',
        isMicrogram: true,
      ),
      _item(
        keyName: 'vitaminE',
        name: 'Vitamin E',
        consumed: totals.vitaminE,
        dailyValue: NutritionDailyValueService.vitaminEMg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'vitaminK',
        name: 'Vitamin K',
        consumed: totals.vitaminK,
        dailyValue: NutritionDailyValueService.vitaminKMcg,
        unit: 'mcg',
        isMicrogram: true,
      ),
      _item(
        keyName: 'vitaminB1',
        name: 'Vitamin B1',
        consumed: totals.vitaminB1,
        dailyValue: NutritionDailyValueService.vitaminB1Mg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'vitaminB2',
        name: 'Vitamin B2',
        consumed: totals.vitaminB2,
        dailyValue: NutritionDailyValueService.vitaminB2Mg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'vitaminB3',
        name: 'Vitamin B3',
        consumed: totals.vitaminB3,
        dailyValue: NutritionDailyValueService.vitaminB3Mg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'vitaminB6',
        name: 'Vitamin B6',
        consumed: totals.vitaminB6,
        dailyValue: NutritionDailyValueService.vitaminB6Mg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'vitaminB9',
        name: 'Vitamin B9',
        consumed: totals.vitaminB9,
        dailyValue: NutritionDailyValueService.vitaminB9McgDfe,
        unit: 'mcg',
        isMicrogram: true,
      ),
      _item(
        keyName: 'vitaminB12',
        name: 'Vitamin B12',
        consumed: totals.vitaminB12,
        dailyValue: NutritionDailyValueService.vitaminB12Mcg,
        unit: 'mcg',
        isMicrogram: true,
      ),
    ];
  }

  static List<MicronutrientProgress> minerals(
    List<FoodLogModel> logs,
  ) {
    final totals = _Totals.fromLogs(logs);

    return [
      _item(
        keyName: 'calcium',
        name: 'Calcium',
        consumed: totals.calcium,
        dailyValue: NutritionDailyValueService.calciumMg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'iron',
        name: 'Iron',
        consumed: totals.iron,
        dailyValue: NutritionDailyValueService.ironMg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'magnesium',
        name: 'Magnesium',
        consumed: totals.magnesium,
        dailyValue: NutritionDailyValueService.magnesiumMg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'potassium',
        name: 'Potassium',
        consumed: totals.potassium,
        dailyValue: NutritionDailyValueService.potassiumMg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'phosphorus',
        name: 'Phosphorus',
        consumed: totals.phosphorus,
        dailyValue: NutritionDailyValueService.phosphorusMg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'zinc',
        name: 'Zinc',
        consumed: totals.zinc,
        dailyValue: NutritionDailyValueService.zincMg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'copper',
        name: 'Copper',
        consumed: totals.copper,
        dailyValue: NutritionDailyValueService.copperMg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'manganese',
        name: 'Manganese',
        consumed: totals.manganese,
        dailyValue: NutritionDailyValueService.manganeseMg,
        unit: 'mg',
        isMicrogram: false,
      ),
      _item(
        keyName: 'selenium',
        name: 'Selenium',
        consumed: totals.selenium,
        dailyValue: NutritionDailyValueService.seleniumMcg,
        unit: 'mcg',
        isMicrogram: true,
      ),
      _item(
        keyName: 'iodine',
        name: 'Iodine',
        consumed: totals.iodine,
        dailyValue: NutritionDailyValueService.iodineMcg,
        unit: 'mcg',
        isMicrogram: true,
      ),
    ];
  }

  static MicronutrientProgress _item({
    required String keyName,
    required String name,
    required double consumed,
    required double dailyValue,
    required String unit,
    required bool isMicrogram,
  }) {
    return MicronutrientProgress(
      keyName: keyName,
      name: name,
      consumed: consumed,
      dailyValue: dailyValue,
      unit: unit,
      isMicrogram: isMicrogram,
    );
  }
}

class _Totals {
  final double vitaminA;
  final double vitaminC;
  final double vitaminD;
  final double vitaminE;
  final double vitaminK;
  final double vitaminB1;
  final double vitaminB2;
  final double vitaminB3;
  final double vitaminB6;
  final double vitaminB9;
  final double vitaminB12;
  final double calcium;
  final double iron;
  final double magnesium;
  final double potassium;
  final double phosphorus;
  final double zinc;
  final double copper;
  final double manganese;
  final double selenium;
  final double iodine;

  const _Totals({
    required this.vitaminA,
    required this.vitaminC,
    required this.vitaminD,
    required this.vitaminE,
    required this.vitaminK,
    required this.vitaminB1,
    required this.vitaminB2,
    required this.vitaminB3,
    required this.vitaminB6,
    required this.vitaminB9,
    required this.vitaminB12,
    required this.calcium,
    required this.iron,
    required this.magnesium,
    required this.potassium,
    required this.phosphorus,
    required this.zinc,
    required this.copper,
    required this.manganese,
    required this.selenium,
    required this.iodine,
  });

  factory _Totals.fromLogs(
    List<FoodLogModel> logs,
  ) {
    var vitaminA = 0.0;
    var vitaminC = 0.0;
    var vitaminD = 0.0;
    var vitaminE = 0.0;
    var vitaminK = 0.0;
    var vitaminB1 = 0.0;
    var vitaminB2 = 0.0;
    var vitaminB3 = 0.0;
    var vitaminB6 = 0.0;
    var vitaminB9 = 0.0;
    var vitaminB12 = 0.0;
    var calcium = 0.0;
    var iron = 0.0;
    var magnesium = 0.0;
    var potassium = 0.0;
    var phosphorus = 0.0;
    var zinc = 0.0;
    var copper = 0.0;
    var manganese = 0.0;
    var selenium = 0.0;
    var iodine = 0.0;

    for (final log in logs) {
      vitaminA += log.vitaminA;
      vitaminC += log.vitaminC;
      vitaminD += log.vitaminD;
      vitaminE += log.vitaminE;
      vitaminK += log.vitaminK;
      vitaminB1 += log.vitaminB1;
      vitaminB2 += log.vitaminB2;
      vitaminB3 += log.vitaminB3;
      vitaminB6 += log.vitaminB6;
      vitaminB9 += log.vitaminB9;
      vitaminB12 += log.vitaminB12;
      calcium += log.calcium;
      iron += log.iron;
      magnesium += log.magnesium;
      potassium += log.potassium;
      phosphorus += log.phosphorus;
      zinc += log.zinc;
      copper += log.copper;
      manganese += log.manganese;
      selenium += log.selenium;
      iodine += log.iodine;
    }

    return _Totals(
      vitaminA: vitaminA,
      vitaminC: vitaminC,
      vitaminD: vitaminD,
      vitaminE: vitaminE,
      vitaminK: vitaminK,
      vitaminB1: vitaminB1,
      vitaminB2: vitaminB2,
      vitaminB3: vitaminB3,
      vitaminB6: vitaminB6,
      vitaminB9: vitaminB9,
      vitaminB12: vitaminB12,
      calcium: calcium,
      iron: iron,
      magnesium: magnesium,
      potassium: potassium,
      phosphorus: phosphorus,
      zinc: zinc,
      copper: copper,
      manganese: manganese,
      selenium: selenium,
      iodine: iodine,
    );
  }
}
