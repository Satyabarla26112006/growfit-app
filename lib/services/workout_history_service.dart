import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/workout_history_model.dart';

class WorkoutHistoryService {
  WorkoutHistoryService._();

  // ============================================================
  // STORAGE
  // ============================================================

  static const String _storageKey =
      'growfit_workout_history';

  static final List<WorkoutHistoryModel>
      _history = [];

  static bool _initialized =
      false;

  static Future<void>?
      _initialization;

  // ============================================================
  // INITIALIZE
  // ============================================================

  static Future<void> initialize() {
    return _initialization ??=
        _load();
  }

  static Future<void> _load() async {
    if (_initialized) {
      return;
    }

    final prefs =
        await SharedPreferences
            .getInstance();

    final saved =
        prefs.getStringList(
      _storageKey,
    );

    _history.clear();

    if (saved != null) {
      for (final value in saved) {
        try {
          final decoded =
              jsonDecode(value);

          if (decoded
              is Map<String, dynamic>) {
            _history.add(
              WorkoutHistoryModel
                  .fromJson(
                decoded,
              ),
            );
          }
        } catch (_) {
          // Ignore invalid history entries.
        }
      }
    }

    _sortHistory();

    _initialized = true;
  }

  // ============================================================
  // SAVE
  // ============================================================

  static Future<void> _save() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    final data = _history
        .map(
          (entry) =>
              jsonEncode(
            entry.toJson(),
          ),
        )
        .toList();

    await prefs.setStringList(
      _storageKey,
      data,
    );
  }

  // ============================================================
  // SORT
  // ============================================================

  static void _sortHistory() {
    _history.sort(
      (a, b) =>
          b.completedAt.compareTo(
        a.completedAt,
      ),
    );
  }

  // ============================================================
  // ADD WORKOUT
  // ============================================================

  static Future<void> addWorkout({
    required String exerciseId,
    required String exerciseName,
    required String category,
    required String muscleGroup,
    required DateTime completedAt,
    required int durationSeconds,
    required int completedSets,
    required int totalSets,
    required int repetitions,
    required int estimatedCalories,
    bool completed = true,
  }) async {
    final entry =
        WorkoutHistoryModel(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),

      exerciseId:
          exerciseId,

      exerciseName:
          exerciseName,

      category:
          category,

      muscleGroup:
          muscleGroup,

      completedAt:
          completedAt,

      durationSeconds:
          durationSeconds,

      completedSets:
          completedSets,

      totalSets:
          totalSets,

      repetitions:
          repetitions,

      estimatedCalories:
          estimatedCalories,

      completed:
          completed,
    );

    _history.add(
      entry,
    );

    _sortHistory();

    await _save();
  }

  // ============================================================
  // ALL HISTORY
  // ============================================================

  static List<WorkoutHistoryModel>
      get history {
    return List.unmodifiable(
      _history,
    );
  }

  // ============================================================
  // COUNT
  // ============================================================

  static int get workoutCount {
    return _history.length;
  }

  // ============================================================
  // COMPLETED COUNT
  // ============================================================

  static int get completedWorkoutCount {
    return _history
        .where(
          (entry) =>
              entry.completed,
        )
        .length;
  }

  // ============================================================
  // TOTAL CALORIES
  // ============================================================

  static int get totalCalories {
    return _history.fold<int>(
      0,
      (
        total,
        entry,
      ) =>
          total +
          entry.estimatedCalories,
    );
  }

  // ============================================================
  // TOTAL TIME
  // ============================================================

  static int get totalDurationSeconds {
    return _history.fold<int>(
      0,
      (
        total,
        entry,
      ) =>
          total +
          entry.durationSeconds,
    );
  }

  // ============================================================
  // TOTAL SETS
  // ============================================================

  static int get totalSets {
    return _history.fold<int>(
      0,
      (
        total,
        entry,
      ) =>
          total +
          entry.completedSets,
    );
  }

  // ============================================================
  // TOTAL REPS
  // ============================================================

  static int get totalRepetitions {
    return _history.fold<int>(
      0,
      (
        total,
        entry,
      ) =>
          total +
          (entry.completedSets *
              entry.repetitions),
    );
  }

  // ============================================================
  // LATEST WORKOUT
  // ============================================================

  static WorkoutHistoryModel?
      get latestWorkout {
    if (_history.isEmpty) {
      return null;
    }

    return _history.first;
  }

  // ============================================================
  // FIND BY ID
  // ============================================================

  static WorkoutHistoryModel?
      findById(
    String id,
  ) {
    for (final entry
        in _history) {
      if (entry.id == id) {
        return entry;
      }
    }

    return null;
  }

  // ============================================================
  // HISTORY FOR DATE
  // ============================================================

  static List<WorkoutHistoryModel>
      forDate(
    DateTime date,
  ) {
    return _history.where(
      (entry) {
        return entry.completedAt.year ==
                date.year &&
            entry.completedAt.month ==
                date.month &&
            entry.completedAt.day ==
                date.day;
      },
    ).toList();
  }

  // ============================================================
  // WORKOUT COUNT FOR DATE
  // ============================================================

  static int countForDate(
    DateTime date,
  ) {
    return forDate(date).length;
  }

  // ============================================================
  // HAS WORKOUT FOR DATE
  // ============================================================

  static bool hasWorkoutForDate(
    DateTime date,
  ) {
    return forDate(date).isNotEmpty;
  }

  // ============================================================
  // CALORIES FOR DATE
  // ============================================================

  static int caloriesForDate(
    DateTime date,
  ) {
    return forDate(
      date,
    ).fold<int>(
      0,
      (
        total,
        entry,
      ) =>
          total +
          entry.estimatedCalories,
    );
  }

  // ============================================================
  // DURATION FOR DATE
  // ============================================================

  static int durationForDate(
    DateTime date,
  ) {
    return forDate(
      date,
    ).fold<int>(
      0,
      (
        total,
        entry,
      ) =>
          total +
          entry.durationSeconds,
    );
  }

  // ============================================================
  // HISTORY FOR EXERCISE
  // ============================================================

  static List<WorkoutHistoryModel>
      forExercise(
    String exerciseId,
  ) {
    return _history
        .where(
          (entry) =>
              entry.exerciseId ==
              exerciseId,
        )
        .toList();
  }

  // ============================================================
  // EXERCISE COUNT
  // ============================================================

  static int exerciseCount(
    String exerciseId,
  ) {
    return forExercise(
      exerciseId,
    ).length;
  }

  // ============================================================
  // RECENT HISTORY
  // ============================================================

  static List<WorkoutHistoryModel>
      recent({
    int limit = 10,
  }) {
    if (limit <= 0) {
      return const [];
    }

    return _history
        .take(limit)
        .toList();
  }

  // ============================================================
  // LAST N DAYS COUNT
  // ============================================================

  static int countForLastDays(
    int days,
  ) {
    if (days <= 0) {
      return 0;
    }

    final today =
        DateTime.now();

    final start =
        DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(
      Duration(
        days: days - 1,
      ),
    );

    return _history.where(
      (entry) {
        return !entry.completedAt
                .isBefore(
              start,
            ) &&
            entry.completedAt
                .isBefore(
              DateTime.now()
                  .add(
                const Duration(
                  days: 1,
                ),
              ),
            );
      },
    ).length;
  }

  // ============================================================
  // CURRENT STREAK
  // ============================================================

  static int get currentStreak {
    if (_history.isEmpty) {
      return 0;
    }

    final dates =
        <DateTime>{};

    for (final entry
        in _history) {
      dates.add(
        DateTime(
          entry.completedAt.year,
          entry.completedAt.month,
          entry.completedAt.day,
        ),
      );
    }

    int streak = 0;

    DateTime day =
        DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    while (dates.contains(day)) {
      streak++;

      day = day.subtract(
        const Duration(
          days: 1,
        ),
      );
    }

    return streak;
  }

  // ============================================================
  // LONGEST STREAK
  // ============================================================

  static int get longestStreak {
    if (_history.isEmpty) {
      return 0;
    }

    final dates =
        <DateTime>{
      for (final entry
          in _history)
        DateTime(
          entry.completedAt.year,
          entry.completedAt.month,
          entry.completedAt.day,
        ),
    }.toList();

    dates.sort();

    int longest = 1;
    int current = 1;

    for (
      int i = 1;
      i < dates.length;
      i++
    ) {
      final difference =
          dates[i].difference(
        dates[i - 1],
      );

      if (difference.inDays ==
          1) {
        current++;
      } else if (difference.inDays ==
          0) {
        continue;
      } else {
        if (current > longest) {
          longest = current;
        }

        current = 1;
      }
    }

    if (current > longest) {
      longest = current;
    }

    return longest;
  }

  // ============================================================
  // REMOVE WORKOUT
  // ============================================================

  static Future<void> removeWorkout(
    String id,
  ) async {
    _history.removeWhere(
      (entry) =>
          entry.id == id,
    );

    await _save();
  }

  // ============================================================
  // CLEAR HISTORY
  // ============================================================

  static Future<void>
      clearHistory() async {
    _history.clear();

    await _save();
  }

  // ============================================================
  // REFRESH
  // ============================================================

  static Future<void> refresh() async {
    _initialized = false;
    _initialization = null;

    await initialize();
  }
}