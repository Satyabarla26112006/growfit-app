import 'subscription_model.dart';

enum WeeklyTarget {
  zeroPoint25Kg,
  zeroPoint5Kg,
  custom,
}

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extremelyActive,
}

enum FitnessGoal {
  loseWeight,
  gainWeight,
  gainMuscle,
  maintainWeight,
  improveFitness,
}

class UserModel {
  final String id;
  final String name;
  final int age;
  final double height;
  final double currentWeight;
  final double goalWeight;

  final FitnessGoal goal;
  final WeeklyTarget weeklyTarget;
  final ActivityLevel activityLevel;

  final List<String> habits;
  final List<String> nutritionPreferences;

  final double? targetCalories;
  final double? targetProtein;
  final double? targetCarbs;
  final double? targetFats;

  final SubscriptionModel subscription;

  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.goalWeight,
    this.goal = FitnessGoal.maintainWeight,
    this.weeklyTarget = WeeklyTarget.zeroPoint25Kg,
    this.activityLevel = ActivityLevel.moderatelyActive,
    this.habits = const [],
    this.nutritionPreferences = const [],
    this.targetCalories,
    this.targetProtein,
    this.targetCarbs,
    this.targetFats,
    this.subscription = const SubscriptionModel(),
    required this.createdAt,
    this.updatedAt,
  });

  // ============================================================
  // BMI
  // ============================================================

  double get bmi {
    if (height <= 0 || currentWeight <= 0) {
      return 0;
    }

    final heightInMeters = height / 100;

    return currentWeight /
        (heightInMeters * heightInMeters);
  }

  // ============================================================
  // BMI CATEGORY
  // ============================================================

  String get bmiCategory {
    if (bmi <= 0) {
      return 'Not Available';
    }

    if (bmi < 18.5) {
      return 'Underweight';
    }

    if (bmi < 25) {
      return 'Normal';
    }

    if (bmi < 30) {
      return 'Overweight';
    }

    return 'Obese';
  }

  // ============================================================
  // GOAL NAME
  // ============================================================

  String get goalName {
    switch (goal) {
      case FitnessGoal.loseWeight:
        return 'Lose Weight';

      case FitnessGoal.gainWeight:
        return 'Gain Weight';

      case FitnessGoal.gainMuscle:
        return 'Gain Muscle';

      case FitnessGoal.maintainWeight:
        return 'Maintain Weight';

      case FitnessGoal.improveFitness:
        return 'Improve Fitness';
    }
  }

  // ============================================================
  // ACTIVITY NAME
  // ============================================================

  String get activityLevelName {
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        return 'Sedentary';

      case ActivityLevel.lightlyActive:
        return 'Lightly Active';

      case ActivityLevel.moderatelyActive:
        return 'Moderately Active';

      case ActivityLevel.veryActive:
        return 'Very Active';

      case ActivityLevel.extremelyActive:
        return 'Extremely Active';
    }
  }

  // ============================================================
  // WEIGHT DIFFERENCE
  // ============================================================

  double get weightDifference {
    return (currentWeight - goalWeight).abs();
  }

  // ============================================================
  // COPY WITH
  // ============================================================

  UserModel copyWith({
    String? id,
    String? name,
    int? age,
    double? height,
    double? currentWeight,
    double? goalWeight,
    FitnessGoal? goal,
    WeeklyTarget? weeklyTarget,
    ActivityLevel? activityLevel,
    List<String>? habits,
    List<String>? nutritionPreferences,
    double? targetCalories,
    double? targetProtein,
    double? targetCarbs,
    double? targetFats,
    SubscriptionModel? subscription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      height: height ?? this.height,
      currentWeight:
          currentWeight ?? this.currentWeight,
      goalWeight:
          goalWeight ?? this.goalWeight,
      goal: goal ?? this.goal,
      weeklyTarget:
          weeklyTarget ?? this.weeklyTarget,
      activityLevel:
          activityLevel ?? this.activityLevel,
      habits: habits ?? this.habits,
      nutritionPreferences:
          nutritionPreferences ??
          this.nutritionPreferences,
      targetCalories:
          targetCalories ?? this.targetCalories,
      targetProtein:
          targetProtein ?? this.targetProtein,
      targetCarbs:
          targetCarbs ?? this.targetCarbs,
      targetFats:
          targetFats ?? this.targetFats,
      subscription:
          subscription ?? this.subscription,
      createdAt:
          createdAt ?? this.createdAt,
      updatedAt:
          updatedAt ?? this.updatedAt,
    );
  }

  // ============================================================
  // JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'height': height,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'goal': goal.name,
      'weeklyTarget': weeklyTarget.name,
      'activityLevel': activityLevel.name,
      'habits': habits,
      'nutritionPreferences':
          nutritionPreferences,
      'targetCalories': targetCalories,
      'targetProtein': targetProtein,
      'targetCarbs': targetCarbs,
      'targetFats': targetFats,
      'subscription':
          subscription.toJson(),
      'createdAt':
          createdAt.toIso8601String(),
      'updatedAt':
          updatedAt?.toIso8601String(),
    };
  }

  // ============================================================
  // FROM JSON
  // ============================================================

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final goalValue =
        json['goal'] as String? ??
        'maintainWeight';

    final goal =
        FitnessGoal.values.firstWhere(
      (value) => value.name == goalValue,
      orElse: () =>
          FitnessGoal.maintainWeight,
    );

    final targetValue =
        json['weeklyTarget'] as String? ??
        'zeroPoint25Kg';

    final weeklyTarget =
        WeeklyTarget.values.firstWhere(
      (value) => value.name == targetValue,
      orElse: () =>
          WeeklyTarget.zeroPoint25Kg,
    );

    final activityValue =
        json['activityLevel'] as String? ??
        'moderatelyActive';

    final activityLevel =
        ActivityLevel.values.firstWhere(
      (value) => value.name == activityValue,
      orElse: () =>
          ActivityLevel.moderatelyActive,
    );

    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      height:
          (json['height'] as num?)?.toDouble() ??
          0,
      currentWeight:
          (json['currentWeight'] as num?)
                  ?.toDouble() ??
              0,
      goalWeight:
          (json['goalWeight'] as num?)
                  ?.toDouble() ??
              0,
      goal: goal,
      weeklyTarget: weeklyTarget,
      activityLevel: activityLevel,
      habits: List<String>.from(
        json['habits'] ?? [],
      ),
      nutritionPreferences:
          List<String>.from(
        json['nutritionPreferences'] ?? [],
      ),
      targetCalories:
          (json['targetCalories'] as num?)
              ?.toDouble(),
      targetProtein:
          (json['targetProtein'] as num?)
              ?.toDouble(),
      targetCarbs:
          (json['targetCarbs'] as num?)
              ?.toDouble(),
      targetFats:
          (json['targetFats'] as num?)
              ?.toDouble(),
      subscription:
          json['subscription'] != null
              ? SubscriptionModel.fromJson(
                  Map<String, dynamic>.from(
                    json['subscription'],
                  ),
                )
              : const SubscriptionModel(),
      createdAt:
          DateTime.tryParse(
                json['createdAt']
                        as String? ??
                    '',
              ) ??
              DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(
                  json['updatedAt'] as String,
                )
              : null,
    );
  }
}