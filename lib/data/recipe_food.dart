import '../models/recipe_model.dart';

class RecipeData {
  RecipeData._();

  static const List<RecipeModel> recipes = [
    // ============================================================
    // BREAKFAST
    // ============================================================

    RecipeModel(
      id: 'recipe_001',
      name: 'High Protein Oats Bowl',
      description: 'A simple high-protein breakfast with oats, milk, banana and nuts.',
      category: 'Breakfast',
      preparationMinutes: 5,
      cookingMinutes: 5,
      servings: 1,
      calories: 520,
      protein: 24,
      carbs: 67,
      fats: 18,
      fiber: 9,
      ingredients: [
        RecipeIngredient(
          name: 'Oats',
          quantity: 60,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Milk',
          quantity: 250,
          unit: 'ml',
        ),
        RecipeIngredient(
          name: 'Banana',
          quantity: 100,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Peanuts',
          quantity: 20,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Chia Seeds',
          quantity: 10,
          unit: 'g',
        ),
      ],
      instructions: [
        'Add oats and milk to a bowl.',
        'Cook or soak until the oats become soft.',
        'Add sliced banana.',
        'Add peanuts and chia seeds.',
        'Mix well and serve.',
      ],
      isVegetarian: true,
      isVegan: false,
    ),

    RecipeModel(
      id: 'recipe_002',
      name: 'Egg Bhurji',
      description: 'Indian-style scrambled eggs with vegetables and spices.',
      category: 'Breakfast',
      preparationMinutes: 5,
      cookingMinutes: 10,
      servings: 1,
      calories: 320,
      protein: 22,
      carbs: 10,
      fats: 21,
      fiber: 3,
      ingredients: [
        RecipeIngredient(
          name: 'Whole Eggs',
          quantity: 3,
          unit: 'pieces',
        ),
        RecipeIngredient(
          name: 'Onion',
          quantity: 50,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Tomato',
          quantity: 50,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Green Chilli',
          quantity: 1,
          unit: 'piece',
        ),
        RecipeIngredient(
          name: 'Oil',
          quantity: 5,
          unit: 'g',
        ),
      ],
      instructions: [
        'Heat oil in a pan.',
        'Add chopped onion and green chilli.',
        'Add tomato and cook for a few minutes.',
        'Add beaten eggs.',
        'Mix continuously until cooked.',
        'Serve hot.',
      ],
      isVegetarian: true,
    ),

    // ============================================================
    // LUNCH
    // ============================================================

    RecipeModel(
      id: 'recipe_003',
      name: 'Chicken Rice Bowl',
      description: 'Balanced Indian-style chicken and rice meal.',
      category: 'Lunch',
      preparationMinutes: 10,
      cookingMinutes: 20,
      servings: 1,
      calories: 610,
      protein: 43,
      carbs: 70,
      fats: 15,
      fiber: 4,
      ingredients: [
        RecipeIngredient(
          name: 'Chicken Breast',
          quantity: 150,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'White Rice',
          quantity: 180,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Mixed Vegetables',
          quantity: 100,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Oil',
          quantity: 5,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Spices',
          quantity: 5,
          unit: 'g',
        ),
      ],
      instructions: [
        'Cook the rice separately.',
        'Season the chicken with spices.',
        'Cook chicken until fully done.',
        'Add mixed vegetables.',
        'Place rice in a bowl.',
        'Add chicken and vegetables on top.',
      ],
    ),

    RecipeModel(
      id: 'recipe_004',
      name: 'Paneer Roti Bowl',
      description: 'Vegetarian protein-rich meal with paneer and roti.',
      category: 'Lunch',
      preparationMinutes: 10,
      cookingMinutes: 15,
      servings: 1,
      calories: 570,
      protein: 29,
      carbs: 55,
      fats: 25,
      fiber: 7,
      ingredients: [
        RecipeIngredient(
          name: 'Paneer',
          quantity: 100,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Roti',
          quantity: 2,
          unit: 'pieces',
        ),
        RecipeIngredient(
          name: 'Mixed Vegetables',
          quantity: 100,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Curd',
          quantity: 100,
          unit: 'g',
        ),
      ],
      instructions: [
        'Cut paneer into small cubes.',
        'Cook paneer with vegetables and spices.',
        'Prepare two rotis.',
        'Serve paneer with rotis and curd.',
      ],
      isVegetarian: true,
    ),

    // ============================================================
    // SNACKS
    // ============================================================

    RecipeModel(
      id: 'recipe_005',
      name: 'Peanut Banana Shake',
      description: 'High-calorie shake suitable for muscle-gain diets.',
      category: 'Snack',
      preparationMinutes: 5,
      cookingMinutes: 0,
      servings: 1,
      calories: 480,
      protein: 17,
      carbs: 62,
      fats: 19,
      fiber: 6,
      ingredients: [
        RecipeIngredient(
          name: 'Banana',
          quantity: 150,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Milk',
          quantity: 300,
          unit: 'ml',
        ),
        RecipeIngredient(
          name: 'Peanuts',
          quantity: 25,
          unit: 'g',
        ),
      ],
      instructions: [
        'Add banana to a blender.',
        'Add milk and peanuts.',
        'Blend until smooth.',
        'Serve immediately.',
      ],
      isVegetarian: true,
    ),

    RecipeModel(
      id: 'recipe_006',
      name: 'Greek Yogurt Fruit Bowl',
      description: 'Light protein-rich snack with yogurt and fresh fruit.',
      category: 'Snack',
      preparationMinutes: 5,
      cookingMinutes: 0,
      servings: 1,
      calories: 250,
      protein: 15,
      carbs: 32,
      fats: 6,
      fiber: 5,
      ingredients: [
        RecipeIngredient(
          name: 'Greek Yogurt',
          quantity: 200,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Banana',
          quantity: 50,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Apple',
          quantity: 50,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Chia Seeds',
          quantity: 5,
          unit: 'g',
        ),
      ],
      instructions: [
        'Add Greek yogurt to a bowl.',
        'Add chopped fruits.',
        'Sprinkle chia seeds.',
        'Mix and serve.',
      ],
      isVegetarian: true,
    ),

    // ============================================================
    // DINNER
    // ============================================================

    RecipeModel(
      id: 'recipe_007',
      name: 'Chicken Roti Dinner',
      description: 'Simple high-protein Indian dinner.',
      category: 'Dinner',
      preparationMinutes: 10,
      cookingMinutes: 20,
      servings: 1,
      calories: 540,
      protein: 42,
      carbs: 48,
      fats: 18,
      fiber: 6,
      ingredients: [
        RecipeIngredient(
          name: 'Chicken Breast',
          quantity: 150,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Roti',
          quantity: 2,
          unit: 'pieces',
        ),
        RecipeIngredient(
          name: 'Vegetables',
          quantity: 100,
          unit: 'g',
        ),
      ],
      instructions: [
        'Cook seasoned chicken until fully done.',
        'Prepare two rotis.',
        'Cook vegetables separately.',
        'Serve together.',
      ],
    ),

    RecipeModel(
      id: 'recipe_008',
      name: 'Moong Dal Khichdi',
      description: 'Comforting vegetarian meal made with rice and moong dal.',
      category: 'Dinner',
      preparationMinutes: 10,
      cookingMinutes: 25,
      servings: 2,
      calories: 390,
      protein: 16,
      carbs: 63,
      fats: 8,
      fiber: 10,
      ingredients: [
        RecipeIngredient(
          name: 'Moong Dal',
          quantity: 60,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Rice',
          quantity: 60,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Mixed Vegetables',
          quantity: 100,
          unit: 'g',
        ),
        RecipeIngredient(
          name: 'Oil',
          quantity: 5,
          unit: 'g',
        ),
      ],
      instructions: [
        'Wash rice and moong dal.',
        'Add rice, dal and vegetables to a pressure cooker.',
        'Add water and spices.',
        'Cook until soft.',
        'Add a small amount of oil before serving.',
      ],
      isVegetarian: true,
    ),
  ];

  // ============================================================
  // SEARCH
  // ============================================================

  static List<RecipeModel> search(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return recipes;
    }

    return recipes.where((recipe) {
      return recipe.name.toLowerCase().contains(normalizedQuery) ||
          recipe.category.toLowerCase().contains(normalizedQuery) ||
          recipe.description.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  static List<RecipeModel> byCategory(String category) {
    return recipes.where((recipe) {
      return recipe.category.toLowerCase() ==
          category.toLowerCase();
    }).toList();
  }

  // ============================================================
  // VEGETARIAN
  // ============================================================

  static List<RecipeModel> get vegetarianRecipes {
    return recipes.where((recipe) => recipe.isVegetarian).toList();
  }

  // ============================================================
  // VEGAN
  // ============================================================

  static List<RecipeModel> get veganRecipes {
    return recipes.where((recipe) => recipe.isVegan).toList();
  }

  // ============================================================
  // PREMIUM
  // ============================================================

  static List<RecipeModel> get premiumRecipes {
    return recipes.where((recipe) => recipe.isPremium).toList();
  }

  // ============================================================
  // FIND BY ID
  // ============================================================

  static RecipeModel? findById(String id) {
    for (final recipe in recipes) {
      if (recipe.id == id) {
        return recipe;
      }
    }

    return null;
  }
}