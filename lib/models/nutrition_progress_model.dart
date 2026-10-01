enum NutritionProgressStatus {
  low,
  onTrack,
  high,
}

class NutritionProgressModel {
  final double consumed;
  final double target;

  const NutritionProgressModel({
    required this.consumed,
    required this.target,
  });

  // ============================================================
  // REMAINING
  // ============================================================

  double get remaining {
    if (target <= 0) {
      return 0;
    }

    final value = target - consumed;

    return value > 0 ? value : 0;
  }

  // ============================================================
  // PERCENTAGE
  // ============================================================

  double get percentage {
    if (target <= 0) {
      return 0;
    }

    final value = consumed / target;

    if (value < 0) {
      return 0;
    }

    if (value > 1) {
      return 1;
    }

    return value;
  }

  // ============================================================
  // RAW PERCENTAGE
  // ============================================================

  double get percentageValue {
    if (target <= 0) {
      return 0;
    }

    return (consumed / target) * 100;
  }

  // ============================================================
  // STATUS
  // ============================================================

  NutritionProgressStatus get status {
    if (target <= 0) {
      return NutritionProgressStatus.low;
    }

    final ratio = consumed / target;

    if (ratio < 0.8) {
      return NutritionProgressStatus.low;
    }

    if (ratio <= 1.0) {
      return NutritionProgressStatus.onTrack;
    }

    return NutritionProgressStatus.high;
  }

  // ============================================================
  // FACTORY
  // ============================================================

  factory NutritionProgressModel.fromValues({
    required double consumed,
    required double target,
  }) {
    return NutritionProgressModel(
      consumed: consumed < 0 ? 0 : consumed,
      target: target < 0 ? 0 : target,
    );
  }
}