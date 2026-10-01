// ============================================================
// EXERCISE MODEL
// ============================================================

class ExerciseModel {
  final String id;
  final String name;
  final String category;
  final String muscleGroup;
  final ExerciseEquipment equipment;
  final ExerciseDifficulty difficulty;

  final int durationMinutes;
  final double caloriesPerMinute;

  final String description;
  final List<String> instructions;

  final int sets;
  final int repetitions;
  final int restSeconds;

  final bool isPopular;
  final bool isFeatured;

  // ============================================================
  // IMAGE
  // ============================================================

  /// Local asset path for the exercise demonstration image.
  ///
  /// Example:
  /// assets/exercises/push_ups.png
  final String? imageAsset;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    required this.durationMinutes,
    required this.caloriesPerMinute,
    required this.description,
    required this.instructions,
    required this.sets,
    required this.repetitions,
    required this.restSeconds,
    this.isPopular = false,
    this.isFeatured = false,
    this.imageAsset,
  });

  // ============================================================
  // HAS IMAGE
  // ============================================================

  bool get hasImage {
    return imageAsset != null &&
        imageAsset!.trim().isNotEmpty;
  }

  // ============================================================
  // EQUIPMENT NAME
  // ============================================================

  String get equipmentName {
    switch (equipment) {
      case ExerciseEquipment.none:
        return 'No Equipment';

      case ExerciseEquipment.dumbbells:
        return 'Dumbbells';

      case ExerciseEquipment.kettlebell:
        return 'Kettlebell';

      case ExerciseEquipment.barbell:
        return 'Barbell';

      case ExerciseEquipment.pullUpBar:
        return 'Pull-Up Bar';

      case ExerciseEquipment.machine:
        return 'Machine';

      case ExerciseEquipment.cable:
        return 'Cable';
    }
  }

  // ============================================================
  // DIFFICULTY NAME
  // ============================================================

  String get difficultyName {
    switch (difficulty) {
      case ExerciseDifficulty.beginner:
        return 'Beginner';

      case ExerciseDifficulty.intermediate:
        return 'Intermediate';

      case ExerciseDifficulty.advanced:
        return 'Advanced';
    }
  }

  // ============================================================
  // DURATION TEXT
  // ============================================================

  String get durationText {
    return '$durationMinutes min';
  }

  // ============================================================
  // CALORIE TEXT
  // ============================================================

  String get caloriesText {
    final calories =
        durationMinutes *
        caloriesPerMinute;

    return '${calories.toStringAsFixed(0)} kcal';
  }

  // ============================================================
  // SETS TEXT
  // ============================================================

  String get setsText {
    return '$sets sets';
  }

  // ============================================================
  // REPETITIONS TEXT
  // ============================================================

  String get repetitionsText {
    if (repetitions <= 1) {
      return 'Hold';
    }

    return '$repetitions reps';
  }

  // ============================================================
  // REST TEXT
  // ============================================================

  String get restText {
    if (restSeconds < 60) {
      return '$restSeconds sec rest';
    }

    final minutes =
        restSeconds ~/ 60;

    final seconds =
        restSeconds % 60;

    if (seconds == 0) {
      return '$minutes min rest';
    }

    return '$minutes min $seconds sec rest';
  }

  // ============================================================
  // BODYWEIGHT
  // ============================================================

  bool get isBodyweight {
    return equipment ==
        ExerciseEquipment.none;
  }

  // ============================================================
  // TIMED EXERCISE
  // ============================================================

  bool get isTimed {
    return repetitions <= 1;
  }

  // ============================================================
  // ESTIMATED CALORIES
  // ============================================================

  double get estimatedCalories {
    return durationMinutes *
        caloriesPerMinute;
  }

  // ============================================================
  // COPY WITH
  // ============================================================

  ExerciseModel copyWith({
    String? id,
    String? name,
    String? category,
    String? muscleGroup,
    ExerciseEquipment? equipment,
    ExerciseDifficulty? difficulty,
    int? durationMinutes,
    double? caloriesPerMinute,
    String? description,
    List<String>? instructions,
    int? sets,
    int? repetitions,
    int? restSeconds,
    bool? isPopular,
    bool? isFeatured,
    String? imageAsset,
  }) {
    return ExerciseModel(
      id:
          id ?? this.id,
      name:
          name ?? this.name,
      category:
          category ?? this.category,
      muscleGroup:
          muscleGroup ?? this.muscleGroup,
      equipment:
          equipment ?? this.equipment,
      difficulty:
          difficulty ?? this.difficulty,
      durationMinutes:
          durationMinutes ??
          this.durationMinutes,
      caloriesPerMinute:
          caloriesPerMinute ??
          this.caloriesPerMinute,
      description:
          description ??
          this.description,
      instructions:
          instructions ??
          this.instructions,
      sets:
          sets ?? this.sets,
      repetitions:
          repetitions ??
          this.repetitions,
      restSeconds:
          restSeconds ??
          this.restSeconds,
      isPopular:
          isPopular ??
          this.isPopular,
      isFeatured:
          isFeatured ??
          this.isFeatured,
      imageAsset:
          imageAsset ??
          this.imageAsset,
    );
  }

  // ============================================================
  // DEBUG
  // ============================================================

  @override
  String toString() {
    return 'ExerciseModel('
        'id: $id, '
        'name: $name, '
        'category: $category, '
        'muscleGroup: $muscleGroup, '
        'equipment: $equipmentName, '
        'difficulty: $difficultyName, '
        'duration: $durationText, '
        'sets: $sets, '
        'repetitions: $repetitions, '
        'imageAsset: $imageAsset'
        ')';
  }
}

// ============================================================
// EXERCISE EQUIPMENT
// ============================================================

enum ExerciseEquipment {
  none,
  dumbbells,
  kettlebell,
  barbell,
  pullUpBar,
  machine,
  cable,
}

// ============================================================
// EXERCISE DIFFICULTY
// ============================================================

enum ExerciseDifficulty {
  beginner,
  intermediate,
  advanced,
}