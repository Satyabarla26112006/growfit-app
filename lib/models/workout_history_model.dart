class WorkoutHistoryModel {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final String category;
  final String muscleGroup;

  final DateTime completedAt;

  final int durationSeconds;
  final int completedSets;
  final int totalSets;
  final int repetitions;

  final int estimatedCalories;

  final bool completed;

  const WorkoutHistoryModel({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.category,
    required this.muscleGroup,
    required this.completedAt,
    required this.durationSeconds,
    required this.completedSets,
    required this.totalSets,
    required this.repetitions,
    required this.estimatedCalories,
    this.completed = true,
  });

  // ============================================================
  // COMPLETION PERCENTAGE
  // ============================================================

  double get completionPercentage {
    if (totalSets <= 0) {
      return 0;
    }

    final value =
        completedSets / totalSets;

    return value
        .clamp(
          0.0,
          1.0,
        )
        .toDouble();
  }

  // ============================================================
  // DURATION LABEL
  // ============================================================

  String get durationLabel {
    final minutes =
        durationSeconds ~/ 60;

    final seconds =
        durationSeconds % 60;

    if (minutes <= 0) {
      return '${seconds}s';
    }

    if (seconds <= 0) {
      return '${minutes}m';
    }

    return '${minutes}m ${seconds}s';
  }

  // ============================================================
  // DATE LABEL
  // ============================================================

  String get dateLabel {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[completedAt.month - 1]} '
        '${completedAt.day}, '
        '${completedAt.year}';
  }

  // ============================================================
  // COPY WITH
  // ============================================================

  WorkoutHistoryModel copyWith({
    String? id,
    String? exerciseId,
    String? exerciseName,
    String? category,
    String? muscleGroup,
    DateTime? completedAt,
    int? durationSeconds,
    int? completedSets,
    int? totalSets,
    int? repetitions,
    int? estimatedCalories,
    bool? completed,
  }) {
    return WorkoutHistoryModel(
      id: id ?? this.id,
      exerciseId:
          exerciseId ?? this.exerciseId,
      exerciseName:
          exerciseName ?? this.exerciseName,
      category:
          category ?? this.category,
      muscleGroup:
          muscleGroup ?? this.muscleGroup,
      completedAt:
          completedAt ?? this.completedAt,
      durationSeconds:
          durationSeconds ??
              this.durationSeconds,
      completedSets:
          completedSets ??
              this.completedSets,
      totalSets:
          totalSets ?? this.totalSets,
      repetitions:
          repetitions ?? this.repetitions,
      estimatedCalories:
          estimatedCalories ??
              this.estimatedCalories,
      completed:
          completed ?? this.completed,
    );
  }

  // ============================================================
  // JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'exerciseName':
          exerciseName,
      'category': category,
      'muscleGroup':
          muscleGroup,
      'completedAt':
          completedAt.toIso8601String(),
      'durationSeconds':
          durationSeconds,
      'completedSets':
          completedSets,
      'totalSets':
          totalSets,
      'repetitions':
          repetitions,
      'estimatedCalories':
          estimatedCalories,
      'completed':
          completed,
    };
  }

  // ============================================================
  // FROM JSON
  // ============================================================

  factory WorkoutHistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkoutHistoryModel(
      id:
          json['id']
                  as String? ??
              '',

      exerciseId:
          json['exerciseId']
                  as String? ??
              '',

      exerciseName:
          json['exerciseName']
                  as String? ??
              '',

      category:
          json['category']
                  as String? ??
              '',

      muscleGroup:
          json['muscleGroup']
                  as String? ??
              '',

      completedAt:
          DateTime.tryParse(
                json['completedAt']
                        as String? ??
                    '',
              ) ??
              DateTime.now(),

      durationSeconds:
          (json['durationSeconds']
                      as num?)
                  ?.toInt() ??
              0,

      completedSets:
          (json['completedSets']
                      as num?)
                  ?.toInt() ??
              0,

      totalSets:
          (json['totalSets']
                      as num?)
                  ?.toInt() ??
              0,

      repetitions:
          (json['repetitions']
                      as num?)
                  ?.toInt() ??
              0,

      estimatedCalories:
          (json['estimatedCalories']
                      as num?)
                  ?.toInt() ??
              0,

      completed:
          json['completed']
                  as bool? ??
              true,
    );
  }
}