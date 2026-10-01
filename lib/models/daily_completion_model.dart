class DailyCompletionModel {
  final String date;
  final bool attendance;
  final bool foodLogged;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;

  const DailyCompletionModel({
    required this.date,
    required this.attendance,
    required this.foodLogged,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  bool get completed {
    return attendance && foodLogged;
  }

  double get completionPercentage {
    int completedItems = 0;

    if (attendance) {
      completedItems++;
    }

    if (foodLogged) {
      completedItems++;
    }

    return completedItems / 2;
  }
}