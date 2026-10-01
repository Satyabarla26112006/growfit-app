import 'package:shared_preferences/shared_preferences.dart';

class WaterIntakeService {
  WaterIntakeService._();

  static SharedPreferences? _prefs;

  static const String _goalKey = 'water_daily_goal_ml';
  static const String _dateKey = 'water_entry_date';
  static const String _entriesKey = 'water_entries';

  static const int defaultGoalMl = 3000;

  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    _resetIfNewDay();
  }

  static int get dailyGoalMl {
    return _prefs?.getInt(_goalKey) ?? defaultGoalMl;
  }

  static Future<void> setDailyGoal(int goalMl) async {
    if (goalMl <= 0) {
      return;
    }

    await _ensureInitialized();
    await _prefs!.setInt(_goalKey, goalMl);
  }

  static int get todayConsumedMl {
    return _getEntries()
        .fold<int>(0, (sum, entry) => sum + entry.amountMl);
  }

  static double get progress {
    final goal = dailyGoalMl;

    if (goal <= 0) {
      return 0;
    }

    final value = todayConsumedMl / goal;

    if (value < 0) {
      return 0;
    }

    if (value > 1) {
      return 1;
    }

    return value;
  }

  static int get remainingMl {
    final remaining = dailyGoalMl - todayConsumedMl;

    return remaining < 0 ? 0 : remaining;
  }

  static List<WaterEntry> get todayEntries {
    return List.unmodifiable(_getEntries());
  }

  static Future<bool> addWater(int amountMl) async {
    if (amountMl <= 0) {
      return false;
    }

    await _ensureInitialized();
    _resetIfNewDay();

    final entries = _getEntries();

    entries.add(
      WaterEntry(
        amountMl: amountMl,
        timestamp: DateTime.now(),
      ),
    );

    await _saveEntries(entries);
    return true;
  }

  static Future<bool> removeLastWater() async {
    await _ensureInitialized();
    _resetIfNewDay();

    final entries = _getEntries();

    if (entries.isEmpty) {
      return false;
    }

    entries.removeLast();
    await _saveEntries(entries);

    return true;
  }

  static Future<void> clearToday() async {
    await _ensureInitialized();

    await _prefs!.remove(_entriesKey);
    await _prefs!.setString(_dateKey, _todayKey());
  }

  static Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await initialize();
    }
  }

  static void _resetIfNewDay() {
    if (_prefs == null) {
      return;
    }

    final savedDate = _prefs!.getString(_dateKey);
    final today = _todayKey();

    if (savedDate == today) {
      return;
    }

    _prefs!.setString(_dateKey, today);
    _prefs!.remove(_entriesKey);
  }

  static String _todayKey() {
    final now = DateTime.now();

    final year = now.year.toString();

    final month = now.month
        .toString()
        .padLeft(2, '0');

    final day = now.day
        .toString()
        .padLeft(2, '0');

    return '$year-$month-$day';
  }

  static List<WaterEntry> _getEntries() {
    final raw = _prefs?.getStringList(_entriesKey) ?? <String>[];

    final entries = <WaterEntry>[];

    for (final item in raw) {
      final entry = WaterEntry.fromStorage(item);

      if (entry != null) {
        entries.add(entry);
      }
    }

    return entries;
  }

  static Future<void> _saveEntries(
    List<WaterEntry> entries,
  ) async {
    final raw = entries
        .map((entry) => entry.toStorage())
        .toList();

    await _prefs!.setStringList(
      _entriesKey,
      raw,
    );

    await _prefs!.setString(
      _dateKey,
      _todayKey(),
    );
  }
}

class WaterEntry {
  const WaterEntry({
    required this.amountMl,
    required this.timestamp,
  });

  final int amountMl;
  final DateTime timestamp;

  String toStorage() {
    return '$amountMl|${timestamp.millisecondsSinceEpoch}';
  }

  static WaterEntry? fromStorage(String value) {
    try {
      final parts = value.split('|');

      if (parts.length != 2) {
        return null;
      }

      final amount = int.parse(parts[0]);

      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(
        int.parse(parts[1]),
      );

      return WaterEntry(
        amountMl: amount,
        timestamp: timestamp,
      );
    } catch (_) {
      return null;
    }
  }
}
