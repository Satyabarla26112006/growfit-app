class FoodModel {
  final String id;
  final String name;
  final String category;

  // ============================================================
  // SERVING
  // ============================================================

  final String servingUnit;
  final double servingSize;

  // ============================================================
  // FOOD FORM / PREPARATION
  // ============================================================

  final String preparationState;

  // ============================================================
  // NUTRITION DATA SOURCE
  //
  // Examples:
  // ICMR-NIN IFCT 2017
  // USDA FoodData Central
  // Manufacturer Nutrition Label
  // Estimated Standard Recipe
  // ============================================================

  final String source;
  final String? sourceId;

  // ============================================================
  // DATA QUALITY
  //
  // true  = source-backed nutrition data
  // false = estimated / approximate / incomplete reference
  // ============================================================

  final bool nutritionDataVerified;

  // ============================================================
  // CORE NUTRITION
  // ============================================================

  final double calories;
  final double protein;
  final double carbohydrates;
  final double fats;
  final double fiber;

  // ============================================================
  // SUGAR / FAT / OTHER
  // ============================================================

  final double sugar;
  final double addedSugar;
  final double saturatedFat;
  final double transFat;
  final double cholesterol;
  final double sodium;

  // ============================================================
  // MINERALS
  //
  // mg:
  // sodium, potassium, calcium, iron, magnesium,
  // phosphorus, zinc, copper, manganese
  //
  // mcg:
  // selenium, iodine
  // ============================================================

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

  // ============================================================
  // VITAMINS
  //
  // Vitamin A = mcg RAE
  // Vitamin C = mg
  // Vitamin D = mcg
  // Vitamin E = mg
  // Vitamin K = mcg
  //
  // B1, B2, B3, B5, B6 = mg
  // B7, B9, B12 = mcg
  // ============================================================

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

  // ============================================================
  // FOOD FLAGS
  // ============================================================

  final bool isVegetarian;
  final bool isVegan;
  final bool isPopular;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  const FoodModel({
    required this.id,
    required this.name,
    required this.category,

    required this.servingUnit,
    required this.servingSize,

    this.preparationState = 'Standard',

    this.source = 'Not specified',
    this.sourceId,

    this.nutritionDataVerified = false,

    // Core nutrition
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fats,
    required this.fiber,

    // Sugar / fat
    this.sugar = 0,
    this.addedSugar = 0,
    this.saturatedFat = 0,
    this.transFat = 0,
    this.cholesterol = 0,
    this.sodium = 0,

    // Minerals
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

    // Vitamins
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

    // Flags
    this.isVegetarian = false,
    this.isVegan = false,
    this.isPopular = false,
  });

  // ============================================================
  // TOTAL MACROS
  // ============================================================

  double get totalMacros {
    return protein +
        carbohydrates +
        fats;
  }

  // ============================================================
  // CALORIES PER SERVING UNIT
  // ============================================================

  double get caloriesPerGram {
    if (servingSize <= 0) {
      return 0;
    }

    return calories / servingSize;
  }

  // ============================================================
  // INTERNAL SCALING
  // ============================================================

  double _scale(
    double value,
    double quantity,
  ) {
    if (servingSize <= 0 ||
        quantity <= 0) {
      return 0;
    }

    return value *
        quantity /
        servingSize;
  }

  // ============================================================
  // CORE NUTRITION FOR QUANTITY
  // ============================================================

  double caloriesFor(
    double quantity,
  ) {
    return _scale(
      calories,
      quantity,
    );
  }

  double proteinFor(
    double quantity,
  ) {
    return _scale(
      protein,
      quantity,
    );
  }

  double carbsFor(
    double quantity,
  ) {
    return _scale(
      carbohydrates,
      quantity,
    );
  }

  double fatsFor(
    double quantity,
  ) {
    return _scale(
      fats,
      quantity,
    );
  }

  double fiberFor(
    double quantity,
  ) {
    return _scale(
      fiber,
      quantity,
    );
  }

  double sugarFor(
    double quantity,
  ) {
    return _scale(
      sugar,
      quantity,
    );
  }

  double addedSugarFor(
    double quantity,
  ) {
    return _scale(
      addedSugar,
      quantity,
    );
  }

  double saturatedFatFor(
    double quantity,
  ) {
    return _scale(
      saturatedFat,
      quantity,
    );
  }

  double transFatFor(
    double quantity,
  ) {
    return _scale(
      transFat,
      quantity,
    );
  }

  double cholesterolFor(
    double quantity,
  ) {
    return _scale(
      cholesterol,
      quantity,
    );
  }

  double sodiumFor(
    double quantity,
  ) {
    return _scale(
      sodium,
      quantity,
    );
  }

  // ============================================================
  // MINERALS FOR QUANTITY
  // ============================================================

  double potassiumFor(
    double quantity,
  ) {
    return _scale(
      potassium,
      quantity,
    );
  }

  double calciumFor(
    double quantity,
  ) {
    return _scale(
      calcium,
      quantity,
    );
  }

  double ironFor(
    double quantity,
  ) {
    return _scale(
      iron,
      quantity,
    );
  }

  double magnesiumFor(
    double quantity,
  ) {
    return _scale(
      magnesium,
      quantity,
    );
  }

  double phosphorusFor(
    double quantity,
  ) {
    return _scale(
      phosphorus,
      quantity,
    );
  }

  double zincFor(
    double quantity,
  ) {
    return _scale(
      zinc,
      quantity,
    );
  }

  double copperFor(
    double quantity,
  ) {
    return _scale(
      copper,
      quantity,
    );
  }

  double manganeseFor(
    double quantity,
  ) {
    return _scale(
      manganese,
      quantity,
    );
  }

  double seleniumFor(
    double quantity,
  ) {
    return _scale(
      selenium,
      quantity,
    );
  }

  double iodineFor(
    double quantity,
  ) {
    return _scale(
      iodine,
      quantity,
    );
  }

  // ============================================================
  // VITAMINS FOR QUANTITY
  // ============================================================

  double vitaminAFor(
    double quantity,
  ) {
    return _scale(
      vitaminA,
      quantity,
    );
  }

  double vitaminCFor(
    double quantity,
  ) {
    return _scale(
      vitaminC,
      quantity,
    );
  }

  double vitaminDFor(
    double quantity,
  ) {
    return _scale(
      vitaminD,
      quantity,
    );
  }

  double vitaminEFor(
    double quantity,
  ) {
    return _scale(
      vitaminE,
      quantity,
    );
  }

  double vitaminKFor(
    double quantity,
  ) {
    return _scale(
      vitaminK,
      quantity,
    );
  }

  double vitaminB1For(
    double quantity,
  ) {
    return _scale(
      vitaminB1,
      quantity,
    );
  }

  double vitaminB2For(
    double quantity,
  ) {
    return _scale(
      vitaminB2,
      quantity,
    );
  }

  double vitaminB3For(
    double quantity,
  ) {
    return _scale(
      vitaminB3,
      quantity,
    );
  }

  double vitaminB5For(
    double quantity,
  ) {
    return _scale(
      vitaminB5,
      quantity,
    );
  }

  double vitaminB6For(
    double quantity,
  ) {
    return _scale(
      vitaminB6,
      quantity,
    );
  }

  double vitaminB7For(
    double quantity,
  ) {
    return _scale(
      vitaminB7,
      quantity,
    );
  }

  double vitaminB9For(
    double quantity,
  ) {
    return _scale(
      vitaminB9,
      quantity,
    );
  }

  double vitaminB12For(
    double quantity,
  ) {
    return _scale(
      vitaminB12,
      quantity,
    );
  }

  // ============================================================
  // COPY WITH
  // ============================================================

  FoodModel copyWith({
    String? id,
    String? name,
    String? category,
    String? servingUnit,
    double? servingSize,

    String? preparationState,
    String? source,
    String? sourceId,
    bool? nutritionDataVerified,

    double? calories,
    double? protein,
    double? carbohydrates,
    double? fats,
    double? fiber,

    double? sugar,
    double? addedSugar,
    double? saturatedFat,
    double? transFat,
    double? cholesterol,
    double? sodium,

    double? potassium,
    double? calcium,
    double? iron,
    double? magnesium,
    double? phosphorus,
    double? zinc,
    double? copper,
    double? manganese,
    double? selenium,
    double? iodine,

    double? vitaminA,
    double? vitaminC,
    double? vitaminD,
    double? vitaminE,
    double? vitaminK,

    double? vitaminB1,
    double? vitaminB2,
    double? vitaminB3,
    double? vitaminB5,
    double? vitaminB6,
    double? vitaminB7,
    double? vitaminB9,
    double? vitaminB12,

    bool? isVegetarian,
    bool? isVegan,
    bool? isPopular,
  }) {
    return FoodModel(
      id:
          id ?? this.id,
      name:
          name ?? this.name,
      category:
          category ?? this.category,
      servingUnit:
          servingUnit ??
              this.servingUnit,
      servingSize:
          servingSize ??
              this.servingSize,

      preparationState:
          preparationState ??
              this.preparationState,

      source:
          source ??
              this.source,
      sourceId:
          sourceId ??
              this.sourceId,

      nutritionDataVerified:
          nutritionDataVerified ??
              this.nutritionDataVerified,

      calories:
          calories ??
              this.calories,
      protein:
          protein ??
              this.protein,
      carbohydrates:
          carbohydrates ??
              this.carbohydrates,
      fats:
          fats ??
              this.fats,
      fiber:
          fiber ??
              this.fiber,

      sugar:
          sugar ??
              this.sugar,
      addedSugar:
          addedSugar ??
              this.addedSugar,
      saturatedFat:
          saturatedFat ??
              this.saturatedFat,
      transFat:
          transFat ??
              this.transFat,
      cholesterol:
          cholesterol ??
              this.cholesterol,
      sodium:
          sodium ??
              this.sodium,

      potassium:
          potassium ??
              this.potassium,
      calcium:
          calcium ??
              this.calcium,
      iron:
          iron ??
              this.iron,
      magnesium:
          magnesium ??
              this.magnesium,
      phosphorus:
          phosphorus ??
              this.phosphorus,
      zinc:
          zinc ??
              this.zinc,
      copper:
          copper ??
              this.copper,
      manganese:
          manganese ??
              this.manganese,
      selenium:
          selenium ??
              this.selenium,
      iodine:
          iodine ??
              this.iodine,

      vitaminA:
          vitaminA ??
              this.vitaminA,
      vitaminC:
          vitaminC ??
              this.vitaminC,
      vitaminD:
          vitaminD ??
              this.vitaminD,
      vitaminE:
          vitaminE ??
              this.vitaminE,
      vitaminK:
          vitaminK ??
              this.vitaminK,

      vitaminB1:
          vitaminB1 ??
              this.vitaminB1,
      vitaminB2:
          vitaminB2 ??
              this.vitaminB2,
      vitaminB3:
          vitaminB3 ??
              this.vitaminB3,
      vitaminB5:
          vitaminB5 ??
              this.vitaminB5,
      vitaminB6:
          vitaminB6 ??
              this.vitaminB6,
      vitaminB7:
          vitaminB7 ??
              this.vitaminB7,
      vitaminB9:
          vitaminB9 ??
              this.vitaminB9,
      vitaminB12:
          vitaminB12 ??
              this.vitaminB12,

      isVegetarian:
          isVegetarian ??
              this.isVegetarian,
      isVegan:
          isVegan ??
              this.isVegan,
      isPopular:
          isPopular ??
              this.isPopular,
    );
  }

  // ============================================================
  // JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,

      'servingUnit': servingUnit,
      'servingSize': servingSize,

      'preparationState':
          preparationState,

      'source': source,
      'sourceId': sourceId,
      'nutritionDataVerified':
          nutritionDataVerified,

      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fats': fats,
      'fiber': fiber,

      'sugar': sugar,
      'addedSugar': addedSugar,
      'saturatedFat': saturatedFat,
      'transFat': transFat,
      'cholesterol': cholesterol,
      'sodium': sodium,

      'potassium': potassium,
      'calcium': calcium,
      'iron': iron,
      'magnesium': magnesium,
      'phosphorus': phosphorus,
      'zinc': zinc,
      'copper': copper,
      'manganese': manganese,
      'selenium': selenium,
      'iodine': iodine,

      'vitaminA': vitaminA,
      'vitaminC': vitaminC,
      'vitaminD': vitaminD,
      'vitaminE': vitaminE,
      'vitaminK': vitaminK,

      'vitaminB1': vitaminB1,
      'vitaminB2': vitaminB2,
      'vitaminB3': vitaminB3,
      'vitaminB5': vitaminB5,
      'vitaminB6': vitaminB6,
      'vitaminB7': vitaminB7,
      'vitaminB9': vitaminB9,
      'vitaminB12': vitaminB12,

      'isVegetarian':
          isVegetarian,
      'isVegan':
          isVegan,
      'isPopular':
          isPopular,
    };
  }

  // ============================================================
  // FROM JSON
  // ============================================================

  factory FoodModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FoodModel(
      id:
          json['id'] as String? ??
              '',
      name:
          json['name'] as String? ??
              '',
      category:
          json['category'] as String? ??
              '',
      servingUnit:
          json['servingUnit']
                  as String? ??
              'g',
      servingSize:
          (json['servingSize'] as num?)
                  ?.toDouble() ??
              100,

      preparationState:
          json['preparationState']
                  as String? ??
              'Standard',

      source:
          json['source'] as String? ??
              'Not specified',

      sourceId:
          json['sourceId']
              as String?,

      nutritionDataVerified:
          json['nutritionDataVerified']
                  as bool? ??
              false,

      calories:
          (json['calories'] as num?)
                  ?.toDouble() ??
              0,
      protein:
          (json['protein'] as num?)
                  ?.toDouble() ??
              0,
      carbohydrates:
          (json['carbohydrates'] as num?)
                  ?.toDouble() ??
              0,
      fats:
          (json['fats'] as num?)
                  ?.toDouble() ??
              0,
      fiber:
          (json['fiber'] as num?)
                  ?.toDouble() ??
              0,

      sugar:
          (json['sugar'] as num?)
                  ?.toDouble() ??
              0,
      addedSugar:
          (json['addedSugar'] as num?)
                  ?.toDouble() ??
              0,
      saturatedFat:
          (json['saturatedFat'] as num?)
                  ?.toDouble() ??
              0,
      transFat:
          (json['transFat'] as num?)
                  ?.toDouble() ??
              0,
      cholesterol:
          (json['cholesterol'] as num?)
                  ?.toDouble() ??
              0,
      sodium:
          (json['sodium'] as num?)
                  ?.toDouble() ??
              0,

      potassium:
          (json['potassium'] as num?)
                  ?.toDouble() ??
              0,
      calcium:
          (json['calcium'] as num?)
                  ?.toDouble() ??
              0,
      iron:
          (json['iron'] as num?)
                  ?.toDouble() ??
              0,
      magnesium:
          (json['magnesium'] as num?)
                  ?.toDouble() ??
              0,
      phosphorus:
          (json['phosphorus'] as num?)
                  ?.toDouble() ??
              0,
      zinc:
          (json['zinc'] as num?)
                  ?.toDouble() ??
              0,
      copper:
          (json['copper'] as num?)
                  ?.toDouble() ??
              0,
      manganese:
          (json['manganese'] as num?)
                  ?.toDouble() ??
              0,
      selenium:
          (json['selenium'] as num?)
                  ?.toDouble() ??
              0,
      iodine:
          (json['iodine'] as num?)
                  ?.toDouble() ??
              0,

      vitaminA:
          (json['vitaminA'] as num?)
                  ?.toDouble() ??
              0,
      vitaminC:
          (json['vitaminC'] as num?)
                  ?.toDouble() ??
              0,
      vitaminD:
          (json['vitaminD'] as num?)
                  ?.toDouble() ??
              0,
      vitaminE:
          (json['vitaminE'] as num?)
                  ?.toDouble() ??
              0,
      vitaminK:
          (json['vitaminK'] as num?)
                  ?.toDouble() ??
              0,

      vitaminB1:
          (json['vitaminB1'] as num?)
                  ?.toDouble() ??
              0,
      vitaminB2:
          (json['vitaminB2'] as num?)
                  ?.toDouble() ??
              0,
      vitaminB3:
          (json['vitaminB3'] as num?)
                  ?.toDouble() ??
              0,
      vitaminB5:
          (json['vitaminB5'] as num?)
                  ?.toDouble() ??
              0,
      vitaminB6:
          (json['vitaminB6'] as num?)
                  ?.toDouble() ??
              0,
      vitaminB7:
          (json['vitaminB7'] as num?)
                  ?.toDouble() ??
              0,
      vitaminB9:
          (json['vitaminB9'] as num?)
                  ?.toDouble() ??
              0,
      vitaminB12:
          (json['vitaminB12'] as num?)
                  ?.toDouble() ??
              0,

      isVegetarian:
          json['isVegetarian']
                  as bool? ??
              false,
      isVegan:
          json['isVegan']
                  as bool? ??
              false,
      isPopular:
          json['isPopular']
                  as bool? ??
              false,
    );
  }
}