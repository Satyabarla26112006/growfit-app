class ProgressFormatService {
  ProgressFormatService._();

  static String calories(double value) {
    return '${value.round()} kcal';
  }

  static String grams(double value) {
    return '${value.toStringAsFixed(1)} g';
  }

  static String percentage(double value) {
    return '${(value * 100).round()}%';
  }

  static String days(int value) {
    return '$value ${value == 1 ? 'day' : 'days'}';
  }

  static String streak(int value) {
    return '$value ${value == 1 ? 'day' : 'days'}';
  }
}