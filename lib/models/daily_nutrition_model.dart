class DailyNutritionModel {
  final String date;

  final double calorieTarget;
  final double proteinTarget;
  final double carbsTarget;
  final double fatsTarget;

  final double caloriesConsumed;
  final double proteinConsumed;
  final double carbsConsumed;
  final double fatsConsumed;

  final double waterTarget;
  final double waterConsumed;

  const DailyNutritionModel({
    required this.date,
    required this.calorieTarget,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatsTarget,
    this.caloriesConsumed = 0,
    this.proteinConsumed = 0,
    this.carbsConsumed = 0,
    this.fatsConsumed = 0,
    this.waterTarget = 0,
    this.waterConsumed = 0,
  });

  // ============================================================
  // REMAINING CALORIES
  // ============================================================

  double get caloriesRemaining {
    final remaining =
        calorieTarget - caloriesConsumed;

    return remaining < 0 ? 0 : remaining;
  }

  // ============================================================
  // REMAINING MACROS
  // ============================================================

  double get proteinRemaining {
    final remaining =
        proteinTarget - proteinConsumed;

    return remaining < 0 ? 0 : remaining;
  }

  double get carbsRemaining {
    final remaining =
        carbsTarget - carbsConsumed;

    return remaining < 0 ? 0 : remaining;
  }

  double get fatsRemaining {
    final remaining =
        fatsTarget - fatsConsumed;

    return remaining < 0 ? 0 : remaining;
  }

  // ============================================================
  // CALORIE PROGRESS
  // ============================================================

  double get calorieProgress {
    if (calorieTarget <= 0) {
      return 0;
    }

    final progress =
        caloriesConsumed / calorieTarget;

    return progress.clamp(0.0, 1.0);
  }

  // ============================================================
  // MACRO PROGRESS
  // ============================================================

  double get proteinProgress {
    if (proteinTarget <= 0) {
      return 0;
    }

    return (proteinConsumed / proteinTarget)
        .clamp(0.0, 1.0);
  }

  double get carbsProgress {
    if (carbsTarget <= 0) {
      return 0;
    }

    return (carbsConsumed / carbsTarget)
        .clamp(0.0, 1.0);
  }

  double get fatsProgress {
    if (fatsTarget <= 0) {
      return 0;
    }

    return (fatsConsumed / fatsTarget)
        .clamp(0.0, 1.0);
  }

  // ============================================================
  // WATER PROGRESS
  // ============================================================

  double get waterProgress {
    if (waterTarget <= 0) {
      return 0;
    }

    return (waterConsumed / waterTarget)
        .clamp(0.0, 1.0);
  }

  // ============================================================
  // COPY WITH
  // ============================================================

  DailyNutritionModel copyWith({
    String? date,
    double? calorieTarget,
    double? proteinTarget,
    double? carbsTarget,
    double? fatsTarget,
    double? caloriesConsumed,
    double? proteinConsumed,
    double? carbsConsumed,
    double? fatsConsumed,
    double? waterTarget,
    double? waterConsumed,
  }) {
    return DailyNutritionModel(
      date: date ?? this.date,
      calorieTarget:
          calorieTarget ?? this.calorieTarget,
      proteinTarget:
          proteinTarget ?? this.proteinTarget,
      carbsTarget:
          carbsTarget ?? this.carbsTarget,
      fatsTarget:
          fatsTarget ?? this.fatsTarget,
      caloriesConsumed:
          caloriesConsumed ?? this.caloriesConsumed,
      proteinConsumed:
          proteinConsumed ?? this.proteinConsumed,
      carbsConsumed:
          carbsConsumed ?? this.carbsConsumed,
      fatsConsumed:
          fatsConsumed ?? this.fatsConsumed,
      waterTarget:
          waterTarget ?? this.waterTarget,
      waterConsumed:
          waterConsumed ?? this.waterConsumed,
    );
  }

  // ============================================================
  // JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'calorieTarget': calorieTarget,
      'proteinTarget': proteinTarget,
      'carbsTarget': carbsTarget,
      'fatsTarget': fatsTarget,
      'caloriesConsumed': caloriesConsumed,
      'proteinConsumed': proteinConsumed,
      'carbsConsumed': carbsConsumed,
      'fatsConsumed': fatsConsumed,
      'waterTarget': waterTarget,
      'waterConsumed': waterConsumed,
    };
  }

  // ============================================================
  // FROM JSON
  // ============================================================

  factory DailyNutritionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DailyNutritionModel(
      date:
          json['date'] as String? ?? '',

      calorieTarget:
          (json['calorieTarget'] as num?)
                  ?.toDouble() ??
              0,

      proteinTarget:
          (json['proteinTarget'] as num?)
                  ?.toDouble() ??
              0,

      carbsTarget:
          (json['carbsTarget'] as num?)
                  ?.toDouble() ??
              0,

      fatsTarget:
          (json['fatsTarget'] as num?)
                  ?.toDouble() ??
              0,

      caloriesConsumed:
          (json['caloriesConsumed'] as num?)
                  ?.toDouble() ??
              0,

      proteinConsumed:
          (json['proteinConsumed'] as num?)
                  ?.toDouble() ??
              0,

      carbsConsumed:
          (json['carbsConsumed'] as num?)
                  ?.toDouble() ??
              0,

      fatsConsumed:
          (json['fatsConsumed'] as num?)
                  ?.toDouble() ??
              0,

      waterTarget:
          (json['waterTarget'] as num?)
                  ?.toDouble() ??
              0,

      waterConsumed:
          (json['waterConsumed'] as num?)
                  ?.toDouble() ??
              0,
    );
  }
}