import 'package:flutter/material.dart';

import 'activity_level_screen.dart';
import 'goals_screen.dart';
import 'your_plan_screen.dart';

class BmiScreen extends StatelessWidget {
  final String name;
  final int age;
  final double height;
  final double currentWeight;
  final double goalWeight;
  final GrowFitGoal goal;
  final double weeklyTarget;
  final List<String> habits;
  final List<String> nutritionPreferences;
  final String mealPlanAssistance;
  final GrowFitActivityLevel activityLevel;

  final double calories;
  final double protein;
  final double carbs;
  final double fats;

  const BmiScreen({
    super.key,
    required this.name,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.goalWeight,
    required this.goal,
    required this.weeklyTarget,
    required this.habits,
    required this.nutritionPreferences,
    required this.mealPlanAssistance,
    required this.activityLevel,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  // ============================================================
  // BMI CALCULATION
  // ============================================================

  double get bmi {
    if (height <= 0 || currentWeight <= 0) {
      return 0;
    }

    final heightMeters = height / 100;

    return currentWeight /
        (heightMeters * heightMeters);
  }

  // ============================================================
  // BMI CATEGORY
  // ============================================================

  String get category {
    // Adult BMI categories are not appropriate for
    // children/teenagers without age- and sex-specific
    // BMI percentile data.
    if (age < 20) {
      return 'Requires age-based assessment';
    }

    if (bmi <= 0) {
      return 'Not Available';
    }

    if (bmi < 18.5) {
      return 'Underweight';
    }

    if (bmi < 25) {
      return 'Normal';
    }

    if (bmi < 30) {
      return 'Overweight';
    }

    return 'Obese';
  }

  // ============================================================
  // NEXT
  // ============================================================

  void _next(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => YourPlanScreen(
          name: name,
          age: age,
          height: height,
          currentWeight: currentWeight,
          goalWeight: goalWeight,
          goal: goal,
          weeklyTarget: weeklyTarget,
          habits: habits,
          nutritionPreferences:
              nutritionPreferences,
          mealPlanAssistance:
              mealPlanAssistance,
          activityLevel: activityLevel,
          calories: calories,
          protein: protein,
          carbs: carbs,
          fats: fats,
          bmi: bmi,
          bmiCategory: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasValidBmi = bmi > 0;

    final background =
        Theme.of(context).scaffoldBackgroundColor;
    final surface =
        Theme.of(context).colorScheme.surface;
    final text =
        Theme.of(context).colorScheme.onSurface;
    final muted =
        Theme.of(context).colorScheme.onSurfaceVariant;
    final primary =
        Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Your BMI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),

            Text(
              'Your BMI',
              style: TextStyle(
                color: muted,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              hasValidBmi
                  ? bmi.toStringAsFixed(1)
                  : '--',
              style: TextStyle(
                color: primary,
                fontSize: 58,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              category,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: text,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surface,
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Text(
                age < 20
                    ? 'BMI is calculated from your height and weight. '
                      'For people under 20, BMI should be interpreted '
                      'using age- and sex-specific growth charts.'
                    : 'BMI is a general screening measure based on '
                      'height and weight. It does not directly measure '
                      'body fat or overall health.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  height: 1.5,
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: hasValidBmi
                    ? () => _next(context)
                    : null,
                child: const Text('View My Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
