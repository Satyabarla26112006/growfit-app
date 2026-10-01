import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/attendance_model.dart';

class AttendanceService {
  AttendanceService._();

  static const String _storageKey =
      'growfit_attendance';

  static final List<AttendanceModel> _records = [];

  static bool _initialized = false;
  static Future<void>? _initialization;

  // ============================================================
  // INITIALIZE
  // ============================================================

  static Future<void> initialize() {
    return _initialization ??= _load();
  }

  static Future<void> _load() async {
    if (_initialized) {
      return;
    }

    final prefs =
        await SharedPreferences.getInstance();

    final saved =
        prefs.getStringList(_storageKey);

    _records.clear();

    if (saved != null) {
      for (final value in saved) {
        try {
          final decoded =
              jsonDecode(value);

          if (decoded is Map<String, dynamic>) {
            _records.add(
              AttendanceModel.fromJson(decoded),
            );
          }
        } catch (_) {
          // Ignore invalid saved attendance.
        }
      }
    }

    _sortRecords();

    _initialized = true;
  }

  // ============================================================
  // SAVE
  // ============================================================

  static Future<void> _save() async {
    final prefs =
        await SharedPreferences.getInstance();

    final values = _records
        .map(
          (record) =>
              jsonEncode(record.toJson()),
        )
        .toList();

    await prefs.setStringList(
      _storageKey,
      values,
    );
  }

  // ============================================================
  // ALL RECORDS
  // ============================================================

  static List<AttendanceModel> get records {
    _sortRecords();

    return List.unmodifiable(
      _records,
    );
  }

  static List<AttendanceModel> get all {
    return records;
  }

  // ============================================================
  // TODAY
  // ============================================================

  static AttendanceModel? get today {
    return getForDate(
      DateTime.now(),
    );
  }

  static AttendanceModel? getTodayAttendance() {
    return today;
  }

  // ============================================================
  // GET FOR DATE
  // ============================================================

  static AttendanceModel? getForDate(
    DateTime date,
  ) {
    final key = _dateKey(date);

    for (final record in _records) {
      if (dateKey(record.date) == key) {
        return record;
      }
    }

    return null;
  }

  // ============================================================
  // PRESENT CHECK
  // ============================================================

  static bool isPresent(
    DateTime date,
  ) {
    return getForDate(date)?.isWorkoutDay == true;
  }

  // ============================================================
  // MARK DATE PRESENT
  // ============================================================

  static Future<void> markDatePresent(
    DateTime date, {
    AttendanceType type = AttendanceType.home,
    String? workoutId,
    String? workoutName,
    int? workoutCount,
    double? caloriesBurned,
    int? durationSeconds,
    String? note,
  }) async {
    final normalizedDate =
        _dateOnly(date);

    final index =
        _indexForDate(normalizedDate);

    final existing =
        index == -1
            ? null
            : _records[index];

    final record =
        AttendanceModel(
      id: existing?.id ??
          'attendance_${dateKey(normalizedDate)}',
      date: normalizedDate,
      type: type,
      workoutId:
          workoutId ?? existing?.workoutId,
      workoutName:
          workoutName ?? existing?.workoutName,
      workoutCount:
          workoutCount ??
          existing?.workoutCount ??
          0,
      caloriesBurned:
          caloriesBurned ??
          existing?.caloriesBurned ??
          0,
      durationSeconds:
          durationSeconds ??
          existing?.durationSeconds ??
          0,
      manuallyMarked:
          true,
      note:
          note ?? existing?.note,
    );

    if (index == -1) {
      _records.add(record);
    } else {
      _records[index] = record;
    }

    _sortRecords();

    await _save();
  }

  // ============================================================
  // RECORD WORKOUT
  // ============================================================

  static Future<void> recordWorkout({
    required DateTime date,
    required String workoutId,
    required String workoutName,
    required String category,
    double caloriesBurned = 0,
    int durationSeconds = 0,
  }) async {
    final normalizedDate =
        _dateOnly(date);

    final type =
        _attendanceTypeForCategory(
      category,
    );

    final index =
        _indexForDate(normalizedDate);

    final existing =
        index == -1
            ? null
            : _records[index];

    final record =
        AttendanceModel(
      id: existing?.id ??
          'attendance_${dateKey(normalizedDate)}',
      date: normalizedDate,
      type: type,
      workoutId: workoutId,
      workoutName: workoutName,
      workoutCount:
          (existing?.workoutCount ?? 0) + 1,
      caloriesBurned:
          (existing?.caloriesBurned ?? 0) +
          caloriesBurned,
      durationSeconds:
          (existing?.durationSeconds ?? 0) +
          durationSeconds,
      manuallyMarked: false,
      note: existing?.note,
    );

    if (index == -1) {
      _records.add(record);
    } else {
      _records[index] = record;
    }

    _sortRecords();

    await _save();
  }

  // ============================================================
  // MARK REST DAY
  // ============================================================

  static Future<void> markRestDay(
    DateTime date, {
    String? note,
  }) async {
    final normalizedDate =
        _dateOnly(date);

    final index =
        _indexForDate(normalizedDate);

    final existing =
        index == -1
            ? null
            : _records[index];

    final record =
        AttendanceModel(
      id: existing?.id ??
          'attendance_${dateKey(normalizedDate)}',
      date: normalizedDate,
      type: AttendanceType.rest,
      workoutId: null,
      workoutName: null,
      workoutCount: 0,
      caloriesBurned: 0,
      durationSeconds: 0,
      manuallyMarked: true,
      note: note,
    );

    if (index == -1) {
      _records.add(record);
    } else {
      _records[index] = record;
    }

    _sortRecords();

    await _save();
  }

  // ============================================================
  // TOGGLE DATE
  // ============================================================

  static Future<bool> toggleDate(
    DateTime date,
  ) async {
    final existing =
        getForDate(date);

    if (existing != null &&
        existing.isWorkoutDay) {
      final index =
          _indexForDate(date);

      if (index != -1) {
        _records.removeAt(index);
      }

      await _save();
      return false;
    }

    await markDatePresent(
      date,
      type: AttendanceType.home,
    );

    return true;
  }

  // ============================================================
  // REMOVE DATE
  // ============================================================

  static Future<bool> removeDate(
    DateTime date,
  ) async {
    final index =
        _indexForDate(date);

    if (index == -1) {
      return false;
    }

    _records.removeAt(index);

    await _save();

    return true;
  }

  // ============================================================
  // CLEAR ALL
  // ============================================================

  static Future<void> clearAll() async {
    _records.clear();
    await _save();
  }

  static Future<void> clearHistory() {
    return clearAll();
  }

  // ============================================================
  // COUNTS
  // ============================================================

  static int get attendanceCount {
    return _uniqueWorkoutDates.length;
  }

  static int get gymDayCount {
    return _uniqueDatesForType(
      AttendanceType.gym,
    ).length;
  }

  static int get homeDayCount {
    return _uniqueDatesForType(
      AttendanceType.home,
    ).length;
  }

  static int get restDayCount {
    return _uniqueDatesForType(
      AttendanceType.rest,
    ).length;
  }

  static int get totalWorkoutDays {
    return attendanceCount;
  }

  // ============================================================
  // ATTENDANCE PERCENTAGE
  // ============================================================

  static double get attendancePercentage {
    final dates =
        _records
            .where(
              (record) =>
                  record.isWorkoutDay,
            )
            .map(
              (record) =>
                  dateKey(record.date),
            )
            .toSet();

    if (dates.isEmpty) {
      return 0;
    }

    final firstDate =
        _earliestRecordDate;

    if (firstDate == null) {
      return 0;
    }

    final today =
        _dateOnly(DateTime.now());

    final totalDays =
        today
            .difference(firstDate)
            .inDays +
        1;

    if (totalDays <= 0) {
      return 0;
    }

    return (dates.length /
            totalDays *
            100)
        .clamp(0.0, 100.0);
  }

  // ============================================================
  // STREAK
  // ============================================================

  static int get currentStreak {
    final workoutDates =
        _records
            .where(
              (record) =>
                  record.isWorkoutDay,
            )
            .map(
              (record) =>
                  _dateOnly(record.date),
            )
            .toSet();

    if (workoutDates.isEmpty) {
      return 0;
    }

    var cursor =
        _dateOnly(DateTime.now());

    if (!workoutDates.contains(cursor)) {
      cursor = cursor.subtract(
        const Duration(days: 1),
      );
    }

    var streak = 0;

    while (workoutDates.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(
        const Duration(days: 1),
      );
    }

    return streak;
  }

  static int get longestStreak {
    final dates =
        _records
            .where(
              (record) =>
                  record.isWorkoutDay,
            )
            .map(
              (record) =>
                  _dateOnly(record.date),
            )
            .toSet()
            .toList();

    if (dates.isEmpty) {
      return 0;
    }

    dates.sort();

    var longest = 1;
    var current = 1;

    for (var i = 1; i < dates.length; i++) {
      final difference =
          dates[i]
              .difference(
                dates[i - 1],
              )
              .inDays;

      if (difference == 1) {
        current++;
        if (current > longest) {
          longest = current;
        }
      } else {
        current = 1;
      }
    }

    return longest;
  }

  // ============================================================
  // DATE RANGE
  // ============================================================

  static List<AttendanceModel> getForDateRange(
    DateTime start,
    DateTime end,
  ) {
    final startDate =
        _dateOnly(start);

    final endDate =
        _dateOnly(end);

    return _records.where(
      (record) {
        final date =
            _dateOnly(record.date);

        return !date.isBefore(startDate) &&
            !date.isAfter(endDate);
      },
    ).toList();
  }

  static List<AttendanceModel> getForMonth(
    int year,
    int month,
  ) {
    return _records.where(
      (record) =>
          record.date.year == year &&
          record.date.month == month,
    ).toList();
  }

  // ============================================================
  // TYPE FOR DATE
  // ============================================================

  static AttendanceType? typeForDate(
    DateTime date,
  ) {
    return getForDate(date)?.type;
  }

  // ============================================================
  // DATE KEY HELPERS
  // ============================================================

  static String dateKey(
    DateTime date,
  ) {
    final year =
        date.year.toString();

    final month =
        date.month
            .toString()
            .padLeft(2, '0');

    final day =
        date.day
            .toString()
            .padLeft(2, '0');

    return '$year-$month-$day';
  }

  static DateTime parseDateKey(
    String value,
  ) {
    final parts =
        value.trim().split('-');

    if (parts.length == 3) {
      final year =
          int.tryParse(parts[0]);

      final month =
          int.tryParse(parts[1]);

      final day =
          int.tryParse(parts[2]);

      if (year != null &&
          month != null &&
          day != null) {
        return DateTime(
          year,
          month,
          day,
        );
      }
    }

    return DateTime.now();
  }

  // ============================================================
  // PRIVATE HELPERS
  // ============================================================

  static AttendanceType
      _attendanceTypeForCategory(
    String category,
  ) {
    final normalized =
        category.trim().toLowerCase();

    if (normalized.contains('gym')) {
      return AttendanceType.gym;
    }

    if (normalized.contains('home')) {
      return AttendanceType.home;
    }

    return AttendanceType.home;
  }

  static int _indexForDate(
    DateTime date,
  ) {
    final key =
        dateKey(date);

    return _records.indexWhere(
      (record) =>
          dateKey(record.date) == key,
    );
  }

  static Set<String> get _uniqueWorkoutDates {
    return _records
        .where(
          (record) =>
              record.isWorkoutDay,
        )
        .map(
          (record) =>
              dateKey(record.date),
        )
        .toSet();
  }

  static Set<String>
      _uniqueDatesForType(
    AttendanceType type,
  ) {
    return _records
        .where(
          (record) =>
              record.type == type,
        )
        .map(
          (record) =>
              dateKey(record.date),
        )
        .toSet();
  }

  static DateTime? get
      _earliestRecordDate {
    if (_records.isEmpty) {
      return null;
    }

    final dates =
        _records
            .map(
              (record) =>
                  _dateOnly(record.date),
            )
            .toList();

    dates.sort();

    return dates.first;
  }

  static void _sortRecords() {
    _records.sort(
      (a, b) =>
          b.date.compareTo(a.date),
    );
  }

  static DateTime _dateOnly(
    DateTime date,
  ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  static String _dateKey(
    DateTime date,
  ) {
    return dateKey(date);
  }
}
