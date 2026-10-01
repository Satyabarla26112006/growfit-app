import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/weight_model.dart';

class WeightService {
  WeightService._();

  // ============================================================
  // STORAGE
  // ============================================================

  static const String _storageKey =
      'growfit_weight_history';

  static final List<WeightEntry> _entries =
      [];

  static bool _initialized =
      false;

  static Future<void>? _initialization;

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
        await SharedPreferences.getInstance();

    final savedData =
        prefs.getStringList(
      _storageKey,
    );

    if (savedData != null) {
      _entries.clear();

      for (final value in savedData) {
        try {
          final decoded =
              jsonDecode(value);

          if (decoded
              is Map<String, dynamic>) {
            _entries.add(
              WeightEntry.fromJson(
                decoded,
              ),
            );
          }
        } catch (_) {
          // Ignore invalid saved entries.
        }
      }

      _sortEntries();
    }

    _initialized = true;
  }

  // ============================================================
  // SORT
  // ============================================================

  static void _sortEntries() {
    _entries.sort(
      (a, b) =>
          a.date.compareTo(
        b.date,
      ),
    );
  }

  // ============================================================
  // SAVE
  // ============================================================

  static Future<void> _save() async {
    final prefs =
        await SharedPreferences.getInstance();

    final data =
        _entries.map(
      (entry) =>
          jsonEncode(
        entry.toJson(),
      ),
    ).toList();

    await prefs.setStringList(
      _storageKey,
      data,
    );
  }

  // ============================================================
  // ADD WEIGHT
  // ============================================================

  static Future<void> addWeight(
    double weight,
  ) async {
    await initialize();

    if (weight <= 0) {
      return;
    }

    final now =
        DateTime.now();

    final entry =
        WeightEntry(
      id:
          now.microsecondsSinceEpoch
              .toString(),

      weight:
          weight,

      date:
          now,
    );

    _entries.add(
      entry,
    );

    _sortEntries();

    await _save();
  }

  // ============================================================
  // REMOVE WEIGHT
  // ============================================================

  static Future<void> removeWeight(
    String id,
  ) async {
    await initialize();

    _entries.removeWhere(
      (entry) =>
          entry.id == id,
    );

    await _save();
  }

  // ============================================================
  // ALL ENTRIES
  // ============================================================

  static List<WeightEntry>
      get entries {
    final copy =
        List<WeightEntry>.from(
      _entries,
    );

    copy.sort(
      (a, b) =>
          a.date.compareTo(
        b.date,
      ),
    );

    return List.unmodifiable(
      copy,
    );
  }

  // ============================================================
  // CURRENT WEIGHT
  // ============================================================

  static double? get currentWeight {
    if (_entries.isEmpty) {
      return null;
    }

    return _entries.last.weight;
  }

  // ============================================================
  // STARTING WEIGHT
  // ============================================================

  static double? get startingWeight {
    if (_entries.isEmpty) {
      return null;
    }

    return _entries.first.weight;
  }

  // ============================================================
  // PREVIOUS WEIGHT
  // ============================================================

  static double? get previousWeight {
    if (_entries.length < 2) {
      return null;
    }

    return _entries[
      _entries.length - 2
    ].weight;
  }

  // ============================================================
  // TOTAL CHANGE
  // ============================================================

  static double get totalChange {
    if (_entries.length < 2) {
      return 0;
    }

    return _entries.last.weight -
        _entries.first.weight;
  }

  // ============================================================
  // CHANGE FROM PREVIOUS ENTRY
  // ============================================================

  static double
      get changeFromPrevious {
    if (_entries.length < 2) {
      return 0;
    }

    return _entries.last.weight -
        _entries[
          _entries.length - 2
        ].weight;
  }

  // ============================================================
  // WEIGHT CHANGE LABEL
  // ============================================================

  static String get changeLabel {
    final change =
        totalChange;

    if (change < 0) {
      return 'Lost '
          '${change.abs().toStringAsFixed(1)} kg';
    }

    if (change > 0) {
      return 'Gained '
          '${change.toStringAsFixed(1)} kg';
    }

    return 'No change';
  }

  // ============================================================
  // PROGRESS TOWARD GOAL
  // ============================================================

  static double progressToGoal({
    required double goalWeight,
  }) {
    if (_entries.isEmpty) {
      return 0;
    }

    final start =
        _entries.first.weight;

    final current =
        _entries.last.weight;

    final totalDistance =
        (start - goalWeight).abs();

    if (totalDistance <= 0) {
      return 1;
    }

    final completedDistance =
        (start - current).abs();

    final progress =
        completedDistance /
            totalDistance;

    if (progress < 0) {
      return 0;
    }

    if (progress > 1) {
      return 1;
    }

    return progress;
  }

  // ============================================================
  // WEIGHT STATUS
  // ============================================================

  static String weightStatus({
    required double goalWeight,
  }) {
    if (_entries.isEmpty) {
      return 'No weight recorded';
    }

    final current =
        _entries.last.weight;

    if ((current - goalWeight)
            .abs() <
        0.1) {
      return 'Goal reached';
    }

    if (current > goalWeight) {
      return 'You are '
          '${(current - goalWeight).toStringAsFixed(1)} '
          'kg from your goal';
    }

    return 'You are '
        '${(goalWeight - current).toStringAsFixed(1)} '
        'kg below your goal';
  }

  // ============================================================
  // ENTRY COUNT
  // ============================================================

  static int get entryCount {
    return _entries.length;
  }

  // ============================================================
  // CLEAR HISTORY
  // ============================================================

  static Future<void> clearHistory() async {
    await initialize();

    _entries.clear();

    await _save();
  }
}