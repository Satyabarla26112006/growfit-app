import 'package:shared_preferences/shared_preferences.dart';

class HealthMetricsService {
  HealthMetricsService._();

  // ============================================================
  // STORAGE KEYS
  // ============================================================

  static const String _bloodPressureKey =
      'growfit_blood_pressure';

  static const String _bloodSugarKey =
      'growfit_blood_sugar';

  // ============================================================
  // VALUES
  // ============================================================

  static String? _bloodPressure;
  static double? _bloodSugar;

  // ============================================================
  // INITIALIZE
  // ============================================================

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final prefs =
        await SharedPreferences.getInstance();

    _bloodPressure =
        prefs.getString(
      _bloodPressureKey,
    );

    final savedSugar =
        prefs.getDouble(
      _bloodSugarKey,
    );

    _bloodSugar =
        savedSugar;

    _initialized = true;
  }

  // ============================================================
  // GETTERS
  // ============================================================

  static String? get bloodPressure =>
      _bloodPressure;

  static double? get bloodSugar =>
      _bloodSugar;

  // ============================================================
  // SAVE BLOOD PRESSURE
  // ============================================================

  static Future<void> saveBloodPressure(
    String value,
  ) async {
    final trimmed =
        value.trim();

    if (trimmed.isEmpty) {
      return;
    }

    final parts =
        trimmed.split('/');

    if (parts.length != 2) {
      return;
    }

    final systolic =
        double.tryParse(
      parts[0].trim(),
    );

    final diastolic =
        double.tryParse(
      parts[1].trim(),
    );

    if (systolic == null ||
        diastolic == null) {
      return;
    }

    if (systolic <= 0 ||
        diastolic <= 0) {
      return;
    }

    _bloodPressure =
        '${systolic.round()}/${diastolic.round()}';

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.setString(
      _bloodPressureKey,
      _bloodPressure!,
    );
  }

  // ============================================================
  // SAVE BLOOD SUGAR
  // ============================================================

  static Future<void> saveBloodSugar(
    String value,
  ) async {
    final parsed =
        double.tryParse(
      value.trim(),
    );

    if (parsed == null) {
      return;
    }

    if (parsed < 0) {
      return;
    }

    _bloodSugar =
        parsed;

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.setDouble(
      _bloodSugarKey,
      parsed,
    );
  }

  // ============================================================
  // CLEAR BLOOD PRESSURE
  // ============================================================

  static Future<void>
      clearBloodPressure() async {
    _bloodPressure =
        null;

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.remove(
      _bloodPressureKey,
    );
  }

  // ============================================================
  // CLEAR BLOOD SUGAR
  // ============================================================

  static Future<void>
      clearBloodSugar() async {
    _bloodSugar =
        null;

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.remove(
      _bloodSugarKey,
    );
  }

  // ============================================================
  // CLEAR ALL
  // ============================================================

  static Future<void>
      clearAll() async {
    _bloodPressure =
        null;

    _bloodSugar =
        null;

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.remove(
      _bloodPressureKey,
    );

    await prefs.remove(
      _bloodSugarKey,
    );
  }

  // ============================================================
  // BLOOD PRESSURE STATUS
  // ============================================================

  static String
      bloodPressureStatus(
    String value,
  ) {
    final parts =
        value.split('/');

    if (parts.length != 2) {
      return 'Enter BP';
    }

    final systolic =
        double.tryParse(
      parts[0].trim(),
    );

    final diastolic =
        double.tryParse(
      parts[1].trim(),
    );

    if (systolic == null ||
        diastolic == null) {
      return 'Enter BP';
    }

    if (systolic < 120 &&
        diastolic < 80) {
      return 'Normal';
    }

    if (systolic < 130 &&
        diastolic < 80) {
      return 'Elevated';
    }

    return 'High';
  }

  // ============================================================
  // BLOOD SUGAR STATUS
  // ============================================================

  static String
      bloodSugarStatus(
    double value,
  ) {
    if (value < 70) {
      return 'Low';
    }

    if (value <= 99) {
      return 'Normal';
    }

    if (value <= 125) {
      return 'Elevated';
    }

    return 'High';
  }
}