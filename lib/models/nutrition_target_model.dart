class NutritionTargetModel {
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fats;
  final double fiber;
  final double sugar;
  final double sodium;

  const NutritionTargetModel({
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fats,
    required this.fiber,
    required this.sugar,
    required this.sodium,
  });

  NutritionTargetModel copyWith({
    double? calories,
    double? protein,
    double? carbohydrates,
    double? fats,
    double? fiber,
    double? sugar,
    double? sodium,
  }) {
    return NutritionTargetModel(
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbohydrates:
          carbohydrates ?? this.carbohydrates,
      fats: fats ?? this.fats,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      sodium: sodium ?? this.sodium,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fats': fats,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
    };
  }

  factory NutritionTargetModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NutritionTargetModel(
      calories:
          (json['calories'] as num?)?.toDouble() ?? 0,
      protein:
          (json['protein'] as num?)?.toDouble() ?? 0,
      carbohydrates:
          (json['carbohydrates'] as num?)?.toDouble() ?? 0,
      fats:
          (json['fats'] as num?)?.toDouble() ?? 0,
      fiber:
          (json['fiber'] as num?)?.toDouble() ?? 0,
      sugar:
          (json['sugar'] as num?)?.toDouble() ?? 0,
      sodium:
          (json['sodium'] as num?)?.toDouble() ?? 0,
    );
  }
}