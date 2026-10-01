enum AchievementType {
  calories,
  workout,
  weight,
  streak,
  nutrition,
  attendance,
  milestone,
  special,
}

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final AchievementType type;

  final String icon;
  final int target;
  final int progress;

  final bool isUnlocked;
  final DateTime? unlockedAt;

  final bool isPremium;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.icon = '🏆',
    this.target = 1,
    this.progress = 0,
    this.isUnlocked = false,
    this.unlockedAt,
    this.isPremium = false,
  });

  // ============================================================
  // PROGRESS
  // ============================================================

  double get progressPercentage {
    if (target <= 0) {
      return 0;
    }

    final value = progress / target;

    if (value > 1) {
      return 1;
    }

    return value;
  }

  int get progressPercent {
    return (progressPercentage * 100).round();
  }

  bool get isCompleted {
    return progress >= target;
  }

  // ============================================================
  // TYPE NAME
  // ============================================================

  String get typeName {
    switch (type) {
      case AchievementType.calories:
        return 'Calories';

      case AchievementType.workout:
        return 'Workout';

      case AchievementType.weight:
        return 'Weight';

      case AchievementType.streak:
        return 'Streak';

      case AchievementType.nutrition:
        return 'Nutrition';

      case AchievementType.attendance:
        return 'Attendance';

      case AchievementType.milestone:
        return 'Milestone';

      case AchievementType.special:
        return 'Special';
    }
  }

  // ============================================================
  // COPY
  // ============================================================

  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    AchievementType? type,
    String? icon,
    int? target,
    int? progress,
    bool? isUnlocked,
    DateTime? unlockedAt,
    bool? isPremium,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  // ============================================================
  // JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'icon': icon,
      'target': target,
      'progress': progress,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'isPremium': isPremium,
    };
  }

  factory AchievementModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final typeValue =
        json['type'] as String? ?? 'milestone';

    final type = AchievementType.values.firstWhere(
      (value) => value.name == typeValue,
      orElse: () => AchievementType.milestone,
    );

    return AchievementModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: type,
      icon: json['icon'] as String? ?? '🏆',
      target: json['target'] as int? ?? 1,
      progress: json['progress'] as int? ?? 0,
      isUnlocked:
          json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(
              json['unlockedAt'] as String,
            )
          : null,
      isPremium:
          json['isPremium'] as bool? ?? false,
    );
  }
}