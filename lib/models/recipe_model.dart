class RecipeIngredient {
  final String name;
  final double quantity;
  final String unit;

  const RecipeIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }

  factory RecipeIngredient.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecipeIngredient(
      name: json['name'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String? ?? '',
    );
  }
}

class RecipeModel {
  final String id;
  final String name;
  final String description;
  final String category;

  final int preparationMinutes;
  final int cookingMinutes;
  final int servings;

  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double fiber;

  final List<RecipeIngredient> ingredients;
  final List<String> instructions;

  final String? imageUrl;

  final bool isVegetarian;
  final bool isVegan;
  final bool isPremium;

  const RecipeModel({
    required this.id,
    required this.name,
    this.description = '',
    this.category = '',
    this.preparationMinutes = 0,
    this.cookingMinutes = 0,
    this.servings = 1,
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fats = 0,
    this.fiber = 0,
    this.ingredients = const [],
    this.instructions = const [],
    this.imageUrl,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isPremium = false,
  });

  // ============================================================
  // TOTAL TIME
  // ============================================================

  int get totalTimeMinutes {
    return preparationMinutes + cookingMinutes;
  }

  // ============================================================
  // COPY
  // ============================================================

  RecipeModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? preparationMinutes,
    int? cookingMinutes,
    int? servings,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    double? fiber,
    List<RecipeIngredient>? ingredients,
    List<String>? instructions,
    String? imageUrl,
    bool? isVegetarian,
    bool? isVegan,
    bool? isPremium,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      preparationMinutes:
          preparationMinutes ?? this.preparationMinutes,
      cookingMinutes:
          cookingMinutes ?? this.cookingMinutes,
      servings: servings ?? this.servings,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      fiber: fiber ?? this.fiber,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      isVegetarian:
          isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  // ============================================================
  // JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'preparationMinutes': preparationMinutes,
      'cookingMinutes': cookingMinutes,
      'servings': servings,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'fiber': fiber,
      'ingredients':
          ingredients.map((item) => item.toJson()).toList(),
      'instructions': instructions,
      'imageUrl': imageUrl,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'isPremium': isPremium,
    };
  }

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      preparationMinutes:
          json['preparationMinutes'] as int? ?? 0,
      cookingMinutes:
          json['cookingMinutes'] as int? ?? 0,
      servings: json['servings'] as int? ?? 1,
      calories:
          (json['calories'] as num?)?.toDouble() ?? 0,
      protein:
          (json['protein'] as num?)?.toDouble() ?? 0,
      carbs:
          (json['carbs'] as num?)?.toDouble() ?? 0,
      fats:
          (json['fats'] as num?)?.toDouble() ?? 0,
      fiber:
          (json['fiber'] as num?)?.toDouble() ?? 0,
      ingredients:
          (json['ingredients'] as List<dynamic>? ?? [])
              .map(
                (item) => RecipeIngredient.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList(),
      instructions:
          List<String>.from(json['instructions'] ?? []),
      imageUrl: json['imageUrl'] as String?,
      isVegetarian:
          json['isVegetarian'] as bool? ?? false,
      isVegan: json['isVegan'] as bool? ?? false,
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }
}