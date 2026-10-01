class DietPlanModel {
  final String id;
  final String name;
  final String description;
  final String goal;

  final int dailyCalories;
  final double protein;
  final double carbohydrates;
  final double fats;

  final List<String> breakfast;
  final List<String> lunch;
  final List<String> snacks;
  final List<String> dinner;

  final bool isPremium;

  const DietPlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.goal,
    required this.dailyCalories,
    required this.protein,
    required this.carbohydrates,
    required this.fats,
    required this.breakfast,
    required this.lunch,
    required this.snacks,
    required this.dinner,
    this.isPremium = false,
  });
}

class DietPlanData {
  DietPlanData._();

  // ============================================================
  // WEIGHT LOSS
  // ============================================================

  static const DietPlanModel weightLossPlan = DietPlanModel(
    id: 'diet_001',
    name: 'Balanced Weight Loss',
    description:
        'A balanced calorie-controlled Indian diet designed to support gradual weight loss.',
    goal: 'Lose Weight',
    dailyCalories: 1800,
    protein: 130,
    carbohydrates: 190,
    fats: 55,
    breakfast: [
      'Oats with milk and banana',
      '2 egg whites + 1 whole egg',
    ],
    lunch: [
      'Rice or 2 rotis',
      'Dal',
      'Chicken or paneer',
      'Vegetables',
      'Curd',
    ],
    snacks: [
      'Fruit',
      'Green tea',
      'Roasted chana',
    ],
    dinner: [
      '2 rotis',
      'Chicken or paneer',
      'Large serving of vegetables',
    ],
  );

  // ============================================================
  // MUSCLE GAIN
  // ============================================================

  static const DietPlanModel muscleGainPlan = DietPlanModel(
    id: 'diet_002',
    name: 'Muscle Gain',
    description:
        'High-protein calorie-surplus plan designed to support muscle growth.',
    goal: 'Gain Muscle',
    dailyCalories: 2800,
    protein: 160,
    carbohydrates: 340,
    fats: 80,
    breakfast: [
      'Oats',
      'Milk',
      'Banana',
      'Peanuts',
      '3 whole eggs',
    ],
    lunch: [
      'Rice',
      'Chicken',
      'Dal',
      'Vegetables',
      'Curd',
    ],
    snacks: [
      'Banana shake',
      'Peanuts',
      'Fruit',
    ],
    dinner: [
      'Rice or 3 rotis',
      'Chicken or paneer',
      'Vegetables',
      'Curd',
    ],
  );

  // ============================================================
  // MAINTENANCE
  // ============================================================

  static const DietPlanModel maintenancePlan = DietPlanModel(
    id: 'diet_003',
    name: 'Healthy Maintenance',
    description:
        'A balanced everyday diet designed to maintain body weight and fitness.',
    goal: 'Maintain Weight',
    dailyCalories: 2200,
    protein: 120,
    carbohydrates: 270,
    fats: 65,
    breakfast: [
      'Oats with milk',
      '2 eggs',
      'One fruit',
    ],
    lunch: [
      'Rice or roti',
      'Dal',
      'Chicken or paneer',
      'Vegetables',
      'Curd',
    ],
    snacks: [
      'Fruit',
      'Nuts',
      'Curd',
    ],
    dinner: [
      '2 rotis',
      'Dal or chicken',
      'Vegetables',
    ],
  );

  // ============================================================
  // WEIGHT GAIN
  // ============================================================

  static const DietPlanModel weightGainPlan = DietPlanModel(
    id: 'diet_004',
    name: 'Healthy Weight Gain',
    description:
        'Calorie-surplus meal plan focused on nutrient-dense foods.',
    goal: 'Gain Weight',
    dailyCalories: 3000,
    protein: 140,
    carbohydrates: 390,
    fats: 85,
    breakfast: [
      'Oats with milk',
      'Banana',
      'Peanuts',
      '3 eggs',
    ],
    lunch: [
      'Large serving of rice',
      'Chicken or paneer',
      'Dal',
      'Vegetables',
      'Curd',
    ],
    snacks: [
      'Banana peanut shake',
      'Nuts',
      'Fruit',
    ],
    dinner: [
      'Rice or 3 rotis',
      'Chicken or paneer',
      'Dal',
      'Vegetables',
    ],
  );

  // ============================================================
  // VEGETARIAN
  // ============================================================

  static const DietPlanModel vegetarianPlan = DietPlanModel(
    id: 'diet_005',
    name: 'High Protein Vegetarian',
    description:
        'Vegetarian meal plan focused on protein-rich Indian foods.',
    goal: 'Improve Fitness',
    dailyCalories: 2200,
    protein: 120,
    carbohydrates: 280,
    fats: 65,
    breakfast: [
      'Oats with milk',
      'Banana',
      'Peanuts',
    ],
    lunch: [
      'Rice',
      'Dal',
      'Paneer',
      'Vegetables',
      'Curd',
    ],
    snacks: [
      'Greek yogurt',
      'Fruit',
      'Roasted chana',
    ],
    dinner: [
      '2 rotis',
      'Paneer',
      'Dal',
      'Vegetables',
    ],
  );

  // ============================================================
  // PREMIUM PLAN
  // ============================================================

  static const DietPlanModel premiumPlan = DietPlanModel(
    id: 'diet_006',
    name: 'Advanced Personalized Plan',
    description:
        'Advanced meal planning with higher personalization options.',
    goal: 'Personalized',
    dailyCalories: 2400,
    protein: 150,
    carbohydrates: 290,
    fats: 70,
    breakfast: [
      'Personalized breakfast based on user preferences',
    ],
    lunch: [
      'Personalized lunch based on calorie and macro targets',
    ],
    snacks: [
      'Personalized snack options',
    ],
    dinner: [
      'Personalized dinner based on daily targets',
    ],
    isPremium: true,
  );

  // ============================================================
  // ALL PLANS
  // ============================================================

  static const List<DietPlanModel> plans = [
    weightLossPlan,
    muscleGainPlan,
    maintenancePlan,
    weightGainPlan,
    vegetarianPlan,
    premiumPlan,
  ];

  // ============================================================
  // SEARCH
  // ============================================================

  static List<DietPlanModel> search(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return plans;
    }

    return plans.where((plan) {
      return plan.name.toLowerCase().contains(normalizedQuery) ||
          plan.goal.toLowerCase().contains(normalizedQuery) ||
          plan.description.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  // ============================================================
  // PREMIUM PLANS
  // ============================================================

  static List<DietPlanModel> get premiumPlans {
    return plans.where((plan) => plan.isPremium).toList();
  }

  // ============================================================
  // FREE PLANS
  // ============================================================

  static List<DietPlanModel> get freePlans {
    return plans.where((plan) => !plan.isPremium).toList();
  }

  // ============================================================
  // FIND BY ID
  // ============================================================

  static DietPlanModel? findById(String id) {
    for (final plan in plans) {
      if (plan.id == id) {
        return plan;
      }
    }

    return null;
  }
}