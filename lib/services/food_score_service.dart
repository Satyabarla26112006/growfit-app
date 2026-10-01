import '../data/nutrition_data.dart';

class FoodScoreResult {
  final int score;
  final List<String> positives;
  final List<String> cautions;

  const FoodScoreResult({
    required this.score,
    required this.positives,
    required this.cautions,
  });
}

class FoodScoreService {
  FoodScoreService._();

  static FoodScoreResult calculate(NutritionRecord nutrition) {
    var score = 60.0;
    final positives = <String>[];
    final cautions = <String>[];

    if (nutrition.protein >= 20) {
      score += 10;
      positives.add('High protein');
    } else if (nutrition.protein >= 8) {
      score += 5;
      positives.add('Good protein source');
    }

    if (nutrition.fiber >= 6) {
      score += 10;
      positives.add('High fiber');
    } else if (nutrition.fiber >= 3) {
      score += 5;
      positives.add('Good source of fiber');
    }

    if (nutrition.potassium >= 350) {
      score += 4;
      positives.add('Good potassium content');
    } else if (nutrition.potassium >= 200) {
      score += 2;
      positives.add('Provides potassium');
    }

    if (nutrition.calcium >= 120) {
      score += 4;
      positives.add('Good calcium content');
    } else if (nutrition.calcium >= 100) {
      score += 2;
      positives.add('Provides calcium');
    }

    if (nutrition.iron >= 2) {
      score += 4;
      positives.add('Good iron content');
    } else if (nutrition.iron >= 1) {
      score += 2;
      positives.add('Provides iron');
    }

    if (nutrition.vitaminC >= 20) {
      score += 4;
      positives.add('Good vitamin C content');
    } else if (nutrition.vitaminC >= 10) {
      score += 2;
      positives.add('Provides vitamin C');
    }

    if (nutrition.sodium >= 800) {
      score -= 14;
      cautions.add('Very high in sodium');
    } else if (nutrition.sodium >= 400) {
      score -= 7;
      cautions.add('High in sodium');
    } else if (nutrition.sodium >= 200) {
      score -= 3;
      cautions.add('Moderate sodium');
    }

    if (nutrition.saturatedFat >= 6) {
      score -= 10;
      cautions.add('High in saturated fat');
    } else if (nutrition.saturatedFat >= 3) {
      score -= 5;
      cautions.add('Contains notable saturated fat');
    }

    if (nutrition.addedSugar >= 10) {
      score -= 12;
      cautions.add('High in added sugar');
    } else if (nutrition.addedSugar >= 5) {
      score -= 6;
      cautions.add('Contains added sugar');
    }

    if (nutrition.transFat > 0.5) {
      score -= 15;
      cautions.add('Contains trans fat');
    } else if (nutrition.transFat > 0) {
      score -= 8;
      cautions.add('Contains some trans fat');
    }

    final finalScore = score.clamp(0, 100).round();

    if (positives.isEmpty) {
      positives.add('Nutrition depends on your portion and daily targets');
    }
    if (cautions.isEmpty) {
      cautions.add('No major caution flagged from the available data');
    }

    return FoodScoreResult(
      score: finalScore,
      positives: positives,
      cautions: cautions,
    );
  }
}
