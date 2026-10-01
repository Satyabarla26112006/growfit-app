import '../models/user_model.dart';

class AiService {
  AiService._();

  // ============================================================
  // GENERAL FITNESS RESPONSE
  // ============================================================

  static String getFitnessAdvice({
    required UserModel user,
    required String question,
  }) {
    final query = question.trim().toLowerCase();

    if (query.isEmpty) {
      return 'Ask me something about nutrition, workouts, calories, or your fitness goal.';
    }

    if (_containsAny(query, [
      'protein',
      'proteins',
    ])) {
      return _proteinAdvice(user);
    }

    if (_containsAny(query, [
      'calorie',
      'calories',
      'kcal',
    ])) {
      return _calorieAdvice(user);
    }

    if (_containsAny(query, [
      'weight',
      'lose weight',
      'fat loss',
      'weight loss',
    ])) {
      return _weightAdvice(user);
    }

    if (_containsAny(query, [
      'muscle',
      'bulk',
      'muscle gain',
      'build muscle',
    ])) {
      return _muscleAdvice(user);
    }

    if (_containsAny(query, [
      'workout',
      'exercise',
      'training',
      'gym',
    ])) {
      return _workoutAdvice(user);
    }

    if (_containsAny(query, [
      'diet',
      'food',
      'meal',
      'eat',
      'nutrition',
    ])) {
      return _nutritionAdvice(user);
    }

    if (_containsAny(query, [
      'water',
      'hydration',
      'drink',
    ])) {
      return _hydrationAdvice(user);
    }

    return _generalAdvice(user);
  }

  // ============================================================
  // PROTEIN
  // ============================================================

  static String _proteinAdvice(UserModel user) {
    final target = user.targetProtein;

    if (target != null && target > 0) {
      return 'Your current protein target is approximately '
          '${target.toStringAsFixed(0)} g per day. '
          'Spread protein across your meals using foods such as '
          'eggs, chicken, fish, paneer, dal, milk, curd, and soya.';
    }

    return 'Aim to include a good protein source in every major meal. '
        'Eggs, chicken, fish, paneer, dal, milk, curd, and soya '
        'are useful options.';
  }

  // ============================================================
  // CALORIES
  // ============================================================

  static String _calorieAdvice(UserModel user) {
    final target = user.targetCalories;

    if (target != null && target > 0) {
      return 'Your current daily calorie target is approximately '
          '${target.toStringAsFixed(0)} kcal. '
          'Try to stay reasonably close to your target while focusing '
          'on nutritious foods and consistent meals.';
    }

    return 'Your calorie target should be calculated using your age, '
        'height, weight, activity level, and fitness goal.';
  }

  // ============================================================
  // WEIGHT
  // ============================================================

  static String _weightAdvice(UserModel user) {
    switch (user.goal) {
      case FitnessGoal.loseWeight:
        return 'For weight loss, focus on a sustainable calorie deficit, '
            'adequate protein, resistance training, daily movement, '
            'and consistent sleep. Avoid extreme crash diets.';

      case FitnessGoal.gainWeight:
        return 'For healthy weight gain, maintain a moderate calorie '
            'surplus and prioritize protein-rich, nutrient-dense foods. '
            'Strength training can help direct weight gain toward muscle.';

      case FitnessGoal.gainMuscle:
        return 'For muscle gain, combine progressive resistance training '
            'with enough calories, protein, carbohydrates, recovery, '
            'and consistent sleep.';

      case FitnessGoal.maintainWeight:
        return 'For weight maintenance, aim for a balanced diet, '
            'regular activity, adequate protein, and calories around '
            'your maintenance needs.';

      case FitnessGoal.improveFitness:
        return 'For improving fitness, combine strength training, '
            'cardiovascular exercise, mobility work, balanced nutrition, '
            'and sufficient recovery.';
    }
  }

  // ============================================================
  // MUSCLE
  // ============================================================

  static String _muscleAdvice(UserModel user) {
    return 'For muscle growth, prioritize progressive overload, '
        'adequate protein, enough total calories, quality carbohydrates, '
        'and recovery. Train consistently rather than trying to maximize '
        'every workout.';
  }

  // ============================================================
  // WORKOUT
  // ============================================================

  static String _workoutAdvice(UserModel user) {
    switch (user.activityLevel) {
      case ActivityLevel.sedentary:
        return 'Start with manageable activity such as walking and '
            'beginner strength sessions. Increase training gradually.';

      case ActivityLevel.lightlyActive:
        return 'A balanced combination of strength training and cardio '
            'can help you progress. Increase volume gradually.';

      case ActivityLevel.moderatelyActive:
        return 'Maintain a consistent training schedule with strength '
            'training, cardio, mobility, and adequate recovery.';

      case ActivityLevel.veryActive:
        return 'Because your activity level is high, prioritize recovery, '
            'hydration, adequate calories, and sufficient protein.';

      case ActivityLevel.extremelyActive:
        return 'With very high activity levels, recovery and nutrition '
            'are especially important. Monitor fatigue and avoid '
            'excessive training volume.';
    }
  }

  // ============================================================
  // NUTRITION
  // ============================================================

  static String _nutritionAdvice(UserModel user) {
    return 'Build your meals around a protein source, vegetables or fruit, '
        'a suitable carbohydrate source, and healthy fats. '
        'Choose mostly minimally processed foods and adjust portions '
        'according to your goal.';
  }

  // ============================================================
  // HYDRATION
  // ============================================================

  static String _hydrationAdvice(UserModel user) {
    return 'Stay hydrated throughout the day and drink more when '
        'you exercise or are exposed to hot weather. Your exact fluid '
        'needs depend on body size, activity, climate, and diet.';
  }

  // ============================================================
  // GENERAL
  // ============================================================

  static String _generalAdvice(UserModel user) {
    return 'Your current goal is ${user.goalName}. '
        'Stay consistent with nutrition, exercise, recovery, '
        'and progress tracking. Small improvements repeated over time '
        'can produce meaningful results.';
  }

  // ============================================================
  // KEYWORD HELPER
  // ============================================================

  static bool _containsAny(
    String text,
    List<String> keywords,
  ) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  // ============================================================
  // QUICK QUESTIONS
  // ============================================================

  static List<String> get quickQuestions {
    return const [
      'How much protein should I eat?',
      'How many calories should I eat?',
      'How can I lose weight?',
      'How can I gain muscle?',
      'What should I eat?',
      'What workout should I do?',
      'How much water should I drink?',
    ];
  }
}