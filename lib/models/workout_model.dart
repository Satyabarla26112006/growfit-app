import 'package:flutter/material.dart';

import 'exercise_model.dart';

enum WorkoutEnvironment {
  gym,
  home,
}

extension WorkoutEnvironmentX on WorkoutEnvironment {
  String get label => this == WorkoutEnvironment.gym ? 'Gym' : 'Home';

  String get key => this == WorkoutEnvironment.gym ? 'gym' : 'home';
}

enum WorkoutType {
  gym,
  home,
  mobility,
  yoga,
}

extension WorkoutTypeX on WorkoutType {
  String get label {
    switch (this) {
      case WorkoutType.gym:
        return 'Gym';
      case WorkoutType.home:
        return 'Home';
      case WorkoutType.mobility:
        return 'Mobility';
      case WorkoutType.yoga:
        return 'Yoga';
    }
  }
}

enum WorkoutCategory {
  push,
  pull,
  legs,
  strength,
  cardio,
  hiit,
  allWorkouts,
  mobility,
  yoga,
}

extension WorkoutCategoryX on WorkoutCategory {
  String get label {
    switch (this) {
      case WorkoutCategory.push:
        return 'Push';
      case WorkoutCategory.pull:
        return 'Pull';
      case WorkoutCategory.legs:
        return 'Legs';
      case WorkoutCategory.strength:
        return 'Strength';
      case WorkoutCategory.cardio:
        return 'Cardio';
      case WorkoutCategory.hiit:
        return 'HIIT';
      case WorkoutCategory.allWorkouts:
        return 'All Workouts';
      case WorkoutCategory.mobility:
        return 'Mobility';
      case WorkoutCategory.yoga:
        return 'Yoga';
    }
  }

  String get key {
    switch (this) {
      case WorkoutCategory.push:
        return 'push';
      case WorkoutCategory.pull:
        return 'pull';
      case WorkoutCategory.legs:
        return 'legs';
      case WorkoutCategory.strength:
        return 'strength';
      case WorkoutCategory.cardio:
        return 'cardio';
      case WorkoutCategory.hiit:
        return 'hiit';
      case WorkoutCategory.allWorkouts:
        return 'all_workouts';
      case WorkoutCategory.mobility:
        return 'mobility';
      case WorkoutCategory.yoga:
        return 'yoga';
    }
  }

  IconData get icon {
    switch (this) {
      case WorkoutCategory.push:
        return Icons.fitness_center_rounded;
      case WorkoutCategory.pull:
        return Icons.rowing_rounded;
      case WorkoutCategory.legs:
        return Icons.directions_run_rounded;
      case WorkoutCategory.strength:
        return Icons.sports_gymnastics_rounded;
      case WorkoutCategory.cardio:
        return Icons.favorite_rounded;
      case WorkoutCategory.hiit:
        return Icons.local_fire_department_rounded;
      case WorkoutCategory.allWorkouts:
        return Icons.grid_view_rounded;
      case WorkoutCategory.mobility:
        return Icons.accessibility_new_rounded;
      case WorkoutCategory.yoga:
        return Icons.self_improvement_rounded;
    }
  }
}

enum WorkoutDifficulty {
  beginner,
  intermediate,
  advanced,
}

extension WorkoutDifficultyX on WorkoutDifficulty {
  String get label {
    switch (this) {
      case WorkoutDifficulty.beginner:
        return 'Beginner';
      case WorkoutDifficulty.intermediate:
        return 'Intermediate';
      case WorkoutDifficulty.advanced:
        return 'Advanced';
    }
  }

  String get key {
    switch (this) {
      case WorkoutDifficulty.beginner:
        return 'beginner';
      case WorkoutDifficulty.intermediate:
        return 'intermediate';
      case WorkoutDifficulty.advanced:
        return 'advanced';
    }
  }
}

/// Supports both the original workout data API and the new
/// environment/category architecture.
class WorkoutModel {
  final String id;
  final String title;
  final String description;
  final WorkoutEnvironment environment;
  final WorkoutCategory category;
  final WorkoutDifficulty difficulty;
  final List<String> exerciseIds;
  final int durationMinutes;
  final int estimatedCalories;
  final String? imageAsset;
  final bool isFeatured;
  final bool isPopular;
  final bool isRecommended;
  final int sortOrder;

  /// Backward-compatible fields used by the existing workout_data.dart.
  final WorkoutType type;
  final List<ExerciseModel> exercises;

  WorkoutModel({
    this.id = '',
    String? title,
    String? name,
    this.description = '',
    WorkoutEnvironment? environment,
    WorkoutCategory? category,
    WorkoutDifficulty? difficulty,
    List<String>? exerciseIds,
    this.durationMinutes = 0,
    int? estimatedCalories,
    int? caloriesBurned,
    this.imageAsset,
    this.isFeatured = false,
    this.isPopular = false,
    this.isRecommended = false,
    this.sortOrder = 0,
    WorkoutType? type,
    List<ExerciseModel>? exercises,
  })  : title = title ?? name ?? '',
        environment = environment ??
            _environmentFromType(type ?? WorkoutType.home),
        category = category ?? WorkoutCategory.allWorkouts,
        difficulty = difficulty ?? WorkoutDifficulty.beginner,
        exerciseIds = exerciseIds ??
            _idsFromExercises(exercises ?? const <ExerciseModel>[]),
        estimatedCalories = estimatedCalories ?? caloriesBurned ?? 0,
        type = type ?? _typeFromEnvironment(environment ?? WorkoutEnvironment.home),
        exercises = exercises ?? const <ExerciseModel>[];

  int get exerciseCount => exercises.isNotEmpty
      ? exercises.length
      : exerciseIds.length;

  String get name => title;

  int get caloriesBurned => estimatedCalories;

  String get environmentLabel => environment.label;

  String get categoryLabel => category.label;

  String get difficultyLabel => difficulty.label;

  String get durationLabel => '$durationMinutes min';

  String get caloriesLabel => '$estimatedCalories kcal';

  String get subtitle =>
      '$difficultyLabel • $durationMinutes min • $exerciseCount exercises';

  WorkoutModel copyWith({
    String? id,
    String? title,
    String? description,
    WorkoutEnvironment? environment,
    WorkoutCategory? category,
    WorkoutDifficulty? difficulty,
    List<String>? exerciseIds,
    int? durationMinutes,
    int? estimatedCalories,
    String? imageAsset,
    bool? isFeatured,
    bool? isPopular,
    bool? isRecommended,
    int? sortOrder,
    WorkoutType? type,
    List<ExerciseModel>? exercises,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      environment: environment ?? this.environment,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      exerciseIds: exerciseIds ?? this.exerciseIds,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      estimatedCalories: estimatedCalories ?? this.estimatedCalories,
      imageAsset: imageAsset ?? this.imageAsset,
      isFeatured: isFeatured ?? this.isFeatured,
      isPopular: isPopular ?? this.isPopular,
      isRecommended: isRecommended ?? this.isRecommended,
      sortOrder: sortOrder ?? this.sortOrder,
      type: type ?? this.type,
      exercises: exercises ?? this.exercises,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': title,
      'description': description,
      'environment': environment.key,
      'category': category.key,
      'difficulty': difficulty.key,
      'exerciseIds': exerciseIds,
      'durationMinutes': durationMinutes,
      'estimatedCalories': estimatedCalories,
      'caloriesBurned': estimatedCalories,
      'type': type.name,
      'isFeatured': isFeatured,
      'isPopular': isPopular,
      'isRecommended': isRecommended,
      'sortOrder': sortOrder,
    };
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString() ?? '',
      environment: _environmentFromString(json['environment']?.toString()),
      category: _categoryFromString(json['category']?.toString()),
      difficulty: _difficultyFromString(json['difficulty']?.toString()),
      exerciseIds: _stringList(json['exerciseIds']),
      durationMinutes: _toInt(json['durationMinutes']),
      estimatedCalories: _toInt(
        json['estimatedCalories'] ?? json['caloriesBurned'],
      ),
      imageAsset: _nullableString(json['imageAsset']),
      isFeatured: json['isFeatured'] == true,
      isPopular: json['isPopular'] == true,
      isRecommended: json['isRecommended'] == true,
      sortOrder: _toInt(json['sortOrder']),
      type: _typeFromString(json['type']?.toString()),
    );
  }

  @override
  String toString() {
    return 'WorkoutModel('
        'id: $id, '
        'title: $title, '
        'type: ${type.label}, '
        'category: ${category.label}, '
        'difficulty: ${difficulty.label}, '
        'exercises: $exerciseCount, '
        'durationMinutes: $durationMinutes, '
        'estimatedCalories: $estimatedCalories'
        ')';
  }
}

const List<WorkoutCategory> gymWorkoutCategories = [
  WorkoutCategory.push,
  WorkoutCategory.pull,
  WorkoutCategory.legs,
  WorkoutCategory.strength,
  WorkoutCategory.cardio,
  WorkoutCategory.hiit,
  WorkoutCategory.allWorkouts,
];

const List<WorkoutCategory> homeWorkoutCategories = [
  WorkoutCategory.push,
  WorkoutCategory.pull,
  WorkoutCategory.legs,
  WorkoutCategory.strength,
  WorkoutCategory.cardio,
  WorkoutCategory.hiit,
  WorkoutCategory.allWorkouts,
];

const List<WorkoutCategory> specializedWorkoutCategories = [
  WorkoutCategory.mobility,
  WorkoutCategory.yoga,
];

List<String> _idsFromExercises(List<ExerciseModel> value) {
  return List.unmodifiable(
    value.map((exercise) => exercise.id),
  );
}

List<String> _stringList(dynamic value) {
  if (value is List) {
    return List.unmodifiable(
      value.map((item) => item.toString()),
    );
  }

  return const [];
}

String? _nullableString(dynamic value) {
  if (value == null) {
    return null;
  }

  final result = value.toString().trim();
  return result.isEmpty ? null : result;
}

int _toInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is double) {
    return value.round();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

WorkoutEnvironment _environmentFromType(
  WorkoutType type,
) {
  switch (type) {
    case WorkoutType.gym:
      return WorkoutEnvironment.gym;
    case WorkoutType.home:
    case WorkoutType.mobility:
    case WorkoutType.yoga:
      return WorkoutEnvironment.home;
  }
}

WorkoutType _typeFromEnvironment(
  WorkoutEnvironment environment,
) {
  return environment == WorkoutEnvironment.gym
      ? WorkoutType.gym
      : WorkoutType.home;
}

WorkoutEnvironment _environmentFromString(
  String? value,
) {
  return value?.toLowerCase().trim() == 'gym'
      ? WorkoutEnvironment.gym
      : WorkoutEnvironment.home;
}

WorkoutCategory _categoryFromString(
  String? value,
) {
  switch (value?.toLowerCase().trim()) {
    case 'push':
      return WorkoutCategory.push;
    case 'pull':
      return WorkoutCategory.pull;
    case 'legs':
    case 'leg':
      return WorkoutCategory.legs;
    case 'strength':
      return WorkoutCategory.strength;
    case 'cardio':
      return WorkoutCategory.cardio;
    case 'hiit':
      return WorkoutCategory.hiit;
    case 'mobility':
      return WorkoutCategory.mobility;
    case 'yoga':
      return WorkoutCategory.yoga;
    default:
      return WorkoutCategory.allWorkouts;
  }
}

WorkoutDifficulty _difficultyFromString(
  String? value,
) {
  switch (value?.toLowerCase().trim()) {
    case 'intermediate':
      return WorkoutDifficulty.intermediate;
    case 'advanced':
      return WorkoutDifficulty.advanced;
    default:
      return WorkoutDifficulty.beginner;
  }
}

WorkoutType _typeFromString(
  String? value,
) {
  switch (value?.toLowerCase().trim()) {
    case 'gym':
      return WorkoutType.gym;
    case 'mobility':
      return WorkoutType.mobility;
    case 'yoga':
      return WorkoutType.yoga;
    default:
      return WorkoutType.home;
  }
}
