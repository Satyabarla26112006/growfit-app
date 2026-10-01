class FoodLogModel {
  final String id;
  final String date;
  final String foodId;
  final String foodName;
  final String mealType;

  final double quantity;
  final String servingUnit;

  // ============================================================
  // CORE NUTRITION
  // ============================================================

  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double fiber;
  final double sugar;

  // ============================================================
  // ADDITIONAL NUTRITION
  // ============================================================

  final double addedSugar;
  final double saturatedFat;
  final double transFat;
  final double cholesterol;
  final double sodium;

  // ============================================================
  // MINERALS
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
  // DATA INFORMATION
  // ============================================================

  final String preparationState;
  final String source;
  final String? sourceId;
  final bool nutritionDataVerified;

  final DateTime loggedAt;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  const FoodLogModel({
    required this.id,
    required this.date,
    required this.foodId,
    required this.foodName,
    required this.mealType,
    required this.quantity,
    required this.servingUnit,

    required this.calories,
    required this.protein,
    required this.carbs,
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
    this.nutritionDataVerified = false,

    required this.loggedAt,
  });

  // ============================================================
  // COPY WITH
  // ============================================================

  FoodLogModel copyWith({
    String? id,
    String? date,
    String? foodId,
    String? foodName,
    String? mealType,
    double? quantity,
    String? servingUnit,

    double? calories,
    double? protein,
    double? carbs,
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

    String? preparationState,
    String? source,
    String? sourceId,
    bool? nutritionDataVerified,

    DateTime? loggedAt,
  }) {
    return FoodLogModel(
      id: id ?? this.id,
      date: date ?? this.date,
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      mealType: mealType ?? this.mealType,
      quantity: quantity ?? this.quantity,
      servingUnit:
          servingUnit ?? this.servingUnit,

      calories:
          calories ?? this.calories,
      protein:
          protein ?? this.protein,
      carbs:
          carbs ?? this.carbs,
      fats:
          fats ?? this.fats,
      fiber:
          fiber ?? this.fiber,
      sugar:
          sugar ?? this.sugar,

      addedSugar:
          addedSugar ?? this.addedSugar,
      saturatedFat:
          saturatedFat ?? this.saturatedFat,
      transFat:
          transFat ?? this.transFat,
      cholesterol:
          cholesterol ?? this.cholesterol,
      sodium:
          sodium ?? this.sodium,

      potassium:
          potassium ?? this.potassium,
      calcium:
          calcium ?? this.calcium,
      iron:
          iron ?? this.iron,
      magnesium:
          magnesium ?? this.magnesium,
      phosphorus:
          phosphorus ?? this.phosphorus,
      zinc:
          zinc ?? this.zinc,
      copper:
          copper ?? this.copper,
      manganese:
          manganese ?? this.manganese,
      selenium:
          selenium ?? this.selenium,
      iodine:
          iodine ?? this.iodine,

      vitaminA:
          vitaminA ?? this.vitaminA,
      vitaminC:
          vitaminC ?? this.vitaminC,
      vitaminD:
          vitaminD ?? this.vitaminD,
      vitaminE:
          vitaminE ?? this.vitaminE,
      vitaminK:
          vitaminK ?? this.vitaminK,

      vitaminB1:
          vitaminB1 ?? this.vitaminB1,
      vitaminB2:
          vitaminB2 ?? this.vitaminB2,
      vitaminB3:
          vitaminB3 ?? this.vitaminB3,
      vitaminB5:
          vitaminB5 ?? this.vitaminB5,
      vitaminB6:
          vitaminB6 ?? this.vitaminB6,
      vitaminB7:
          vitaminB7 ?? this.vitaminB7,
      vitaminB9:
          vitaminB9 ?? this.vitaminB9,
      vitaminB12:
          vitaminB12 ?? this.vitaminB12,

      preparationState:
          preparationState ??
              this.preparationState,
      source:
          source ?? this.source,
      sourceId:
          sourceId ?? this.sourceId,
      nutritionDataVerified:
          nutritionDataVerified ??
              this.nutritionDataVerified,

      loggedAt:
          loggedAt ?? this.loggedAt,
    );
  }

  // ============================================================
  // JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'foodId': foodId,
      'foodName': foodName,
      'mealType': mealType,
      'quantity': quantity,
      'servingUnit': servingUnit,

      'calories': calories,
      'protein': protein,
      'carbs': carbs,
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

      'preparationState':
          preparationState,
      'source': source,
      'sourceId': sourceId,
      'nutritionDataVerified':
          nutritionDataVerified,

      'loggedAt':
          loggedAt.toIso8601String(),
    };
  }

  // ============================================================
  // FROM JSON
  // ============================================================

  factory FoodLogModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FoodLogModel(
      id:
          json['id'] as String? ?? '',
      date:
          json['date'] as String? ?? '',
      foodId:
          json['foodId'] as String? ?? '',
      foodName:
          json['foodName'] as String? ?? '',
      mealType:
          json['mealType'] as String? ?? '',
      quantity:
          (json['quantity'] as num?)
                  ?.toDouble() ??
              0,
      servingUnit:
          json['servingUnit'] as String? ??
              'g',

      calories:
          (json['calories'] as num?)
                  ?.toDouble() ??
              0,
      protein:
          (json['protein'] as num?)
                  ?.toDouble() ??
              0,
      carbs:
          (json['carbs'] as num?)
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

      preparationState:
          json['preparationState']
                  as String? ??
              'Standard',

      source:
          json['source'] as String? ??
              'Not specified',

      sourceId:
          json['sourceId'] as String?,

      nutritionDataVerified:
          json['nutritionDataVerified']
                  as bool? ??
              false,

      loggedAt:
          DateTime.tryParse(
                json['loggedAt']
                        as String? ??
                    '',
              ) ??
              DateTime.now(),
    );
  }
}