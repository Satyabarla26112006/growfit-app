import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/health_reading_model.dart';

class HealthReadingService {
  HealthReadingService._();

  static const String _storageKey =
      'growfit_health_readings';

  static final List<HealthReadingModel> _readings = [];

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final prefs =
        await SharedPreferences.getInstance();

    final raw =
        prefs.getString(_storageKey);

    _readings.clear();

    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded =
            jsonDecode(raw);

        if (decoded is List) {
          for (final item in decoded) {
            if (item is Map<String, dynamic>) {
              _readings.add(
                HealthReadingModel.fromJson(item),
              );
            } else if (item is Map) {
              _readings.add(
                HealthReadingModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              );
            }
          }
        }
      } catch (_) {
        _readings.clear();
      }
    }

    _sort();
    _initialized = true;
  }

  static List<HealthReadingModel> get allReadings =>
      List.unmodifiable(_readings);

  static List<HealthReadingModel> get bloodPressureReadings {
    return _readings
        .where(
          (reading) =>
              reading.type ==
                  HealthReadingType.bloodPressure &&
              reading.systolic != null &&
              reading.diastolic != null,
        )
        .toList(growable: false);
  }

  static List<HealthReadingModel> get bloodGlucoseReadings {
    return _readings
        .where(
          (reading) =>
              reading.type ==
                  HealthReadingType.bloodGlucose &&
              reading.glucoseMgDl != null,
        )
        .toList(growable: false);
  }

  static HealthReadingModel? get latestBloodPressure {
    final readings =
        bloodPressureReadings;

    if (readings.isEmpty) {
      return null;
    }

    return readings.first;
  }

  static HealthReadingModel? get latestBloodGlucose {
    final readings =
        bloodGlucoseReadings;

    if (readings.isEmpty) {
      return null;
    }

    return readings.first;
  }

  static Future<void> add(
    HealthReadingModel reading,
  ) async {
    _validate(reading);

    _readings.removeWhere(
      (existing) =>
          existing.id == reading.id,
    );

    _readings.add(reading);
    _sort();

    await _save();
  }

  static Future<void> delete(
    String id,
  ) async {
    _readings.removeWhere(
      (reading) => reading.id == id,
    );

    await _save();
  }

  static List<HealthReadingModel> forDate(
    DateTime date,
  ) {
    return _readings
        .where(
          (reading) =>
              _sameDate(
                reading.recordedAt,
                date,
              ),
        )
        .toList(growable: false);
  }

  static List<HealthReadingModel> bloodPressureForDate(
    DateTime date,
  ) {
    return forDate(date)
        .where(
          (reading) =>
              reading.type ==
                  HealthReadingType.bloodPressure &&
              reading.systolic != null &&
              reading.diastolic != null,
        )
        .toList(growable: false);
  }

  static List<HealthReadingModel> bloodGlucoseForDate(
    DateTime date,
  ) {
    return forDate(date)
        .where(
          (reading) =>
              reading.type ==
                  HealthReadingType.bloodGlucose &&
              reading.glucoseMgDl != null,
        )
        .toList(growable: false);
  }

  static double? averageSystolic({
    DateTime? from,
    DateTime? to,
  }) {
    final values = bloodPressureReadings
        .where(
          (reading) =>
              _withinRange(
                reading.recordedAt,
                from,
                to,
              ),
        )
        .map(
          (reading) => reading.systolic!,
        )
        .toList();

    if (values.isEmpty) {
      return null;
    }

    return values.reduce(
          (sum, value) => sum + value,
        ) /
        values.length;
  }

  static double? averageDiastolic({
    DateTime? from,
    DateTime? to,
  }) {
    final values = bloodPressureReadings
        .where(
          (reading) =>
              _withinRange(
                reading.recordedAt,
                from,
                to,
              ),
        )
        .map(
          (reading) => reading.diastolic!,
        )
        .toList();

    if (values.isEmpty) {
      return null;
    }

    return values.reduce(
          (sum, value) => sum + value,
        ) /
        values.length;
  }

  static double? averageGlucose({
    DateTime? from,
    DateTime? to,
  }) {
    final values = bloodGlucoseReadings
        .where(
          (reading) =>
              _withinRange(
                reading.recordedAt,
                from,
                to,
              ),
        )
        .map(
          (reading) => reading.glucoseMgDl!,
        )
        .toList();

    if (values.isEmpty) {
      return null;
    }

    return values.reduce(
          (sum, value) => sum + value,
        ) /
        values.length;
  }

  static BloodPressureClassification classifyBloodPressure(
    HealthReadingModel reading,
  ) {
    final systolic =
        reading.systolic;
    final diastolic =
        reading.diastolic;

    if (systolic == null ||
        diastolic == null) {
      return const BloodPressureClassification(
        label: 'Incomplete',
        needsAttention: false,
        urgent: false,
      );
    }

    if (systolic > 180 ||
        diastolic > 120) {
      return const BloodPressureClassification(
        label: 'Severe',
        needsAttention: true,
        urgent: true,
      );
    }

    if (systolic >= 140 ||
        diastolic >= 90) {
      return const BloodPressureClassification(
        label: 'Stage 2',
        needsAttention: true,
        urgent: false,
      );
    }

    if (systolic >= 130 ||
        diastolic >= 80) {
      return const BloodPressureClassification(
        label: 'Stage 1',
        needsAttention: true,
        urgent: false,
      );
    }

    if (systolic >= 120 &&
        diastolic < 80) {
      return const BloodPressureClassification(
        label: 'Elevated',
        needsAttention: false,
        urgent: false,
      );
    }

    return const BloodPressureClassification(
      label: 'Normal',
      needsAttention: false,
      urgent: false,
    );
  }

  static BloodGlucoseClassification classifyBloodGlucose(
    HealthReadingModel reading,
  ) {
    final glucose =
        reading.glucoseMgDl;

    if (glucose == null) {
      return const BloodGlucoseClassification(
        label: 'Incomplete',
        needsAttention: false,
        urgent: false,
      );
    }

    if (glucose < 54) {
      return const BloodGlucoseClassification(
        label: 'Very low',
        needsAttention: true,
        urgent: true,
      );
    }

    if (glucose < 70) {
      return const BloodGlucoseClassification(
        label: 'Low',
        needsAttention: true,
        urgent: true,
      );
    }

    if (glucose > 180) {
      return const BloodGlucoseClassification(
        label: 'High',
        needsAttention: true,
        urgent: false,
      );
    }

    return const BloodGlucoseClassification(
      label: 'In range',
      needsAttention: false,
      urgent: false,
    );
  }

  static Future<void> clearAll() async {
    _readings.clear();
    await _save();
  }

  static void _validate(
    HealthReadingModel reading,
  ) {
    if (reading.type ==
        HealthReadingType.bloodPressure) {
      if (reading.systolic == null ||
          reading.diastolic == null) {
        throw ArgumentError(
          'Blood pressure requires systolic and diastolic values.',
        );
      }

      if (reading.systolic! <= 0 ||
          reading.diastolic! <= 0) {
        throw ArgumentError(
          'Blood pressure values must be greater than zero.',
        );
      }
    }

    if (reading.type ==
        HealthReadingType.bloodGlucose) {
      if (reading.glucoseMgDl == null) {
        throw ArgumentError(
          'Blood glucose requires a glucose value.',
        );
      }

      if (reading.glucoseMgDl! <= 0) {
        throw ArgumentError(
          'Blood glucose must be greater than zero.',
        );
      }
    }
  }

  static bool _withinRange(
    DateTime value,
    DateTime? from,
    DateTime? to,
  ) {
    if (from != null &&
        value.isBefore(from)) {
      return false;
    }

    if (to != null &&
        value.isAfter(to)) {
      return false;
    }

    return true;
  }

  static bool _sameDate(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  static void _sort() {
    _readings.sort(
      (a, b) =>
          b.recordedAt.compareTo(
        a.recordedAt,
      ),
    );
  }

  static Future<void> _save() async {
    final prefs =
        await SharedPreferences.getInstance();

    final encoded =
        _readings
            .map(
              (reading) =>
                  reading.toJson(),
            )
            .toList();

    await prefs.setString(
      _storageKey,
      jsonEncode(encoded),
    );
  }
}
