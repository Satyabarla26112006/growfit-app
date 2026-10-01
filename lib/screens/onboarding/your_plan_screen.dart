import 'package:flutter/material.dart';

import 'activity_level_screen.dart';
import 'goals_screen.dart';
import 'subscription_screen.dart';

class YourPlanScreen extends StatelessWidget {
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

  final double bmi;
  final String bmiCategory;

  const YourPlanScreen({
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
    required this.bmi,
    required this.bmiCategory,
  });

  String get goalName {
    switch (goal) {
      case GrowFitGoal.loseWeight:
        return 'Lose Weight';
      case GrowFitGoal.gainWeight:
        return 'Gain Weight';
      case GrowFitGoal.gainMuscle:
        return 'Gain Muscle';
      case GrowFitGoal.maintainWeight:
        return 'Maintain Weight';
      case GrowFitGoal.improveFitness:
        return 'Improve Fitness';
    }
  }

  void _next(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubscriptionScreen(
          name: name,
          goalName: goalName,
          calories: calories,
          protein: protein,
          carbs: carbs,
          fats: fats,
          bmi: bmi,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final background =
        Theme.of(context).scaffoldBackgroundColor;

    final text =
        Theme.of(context).colorScheme.onSurface;

    final muted =
        Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Your Plan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Great job, $name!',
            style: TextStyle(
              color: text,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Here is the foundation of your GrowFit plan.',
            style: TextStyle(
              color: muted,
            ),
          ),

          const SizedBox(height: 25),

          _card(
            context,
            Icons.flag_rounded,
            'Your Goal',
            goalName,
          ),

          _card(
            context,
            Icons.local_fire_department_rounded,
            'Daily Calories',
            '${calories.round()} kcal',
          ),

          _card(
            context,
            Icons.fitness_center_rounded,
            'Protein',
            '${protein.round()} g',
          ),

          _card(
            context,
            Icons.grain_rounded,
            'Carbohydrates',
            '${carbs.round()} g',
          ),

          _card(
            context,
            Icons.water_drop_rounded,
            'Fats',
            '${fats.round()} g',
          ),

          _card(
            context,
            Icons.monitor_weight_rounded,
            'BMI',
            '${bmi.toStringAsFixed(1)} • $bmiCategory',
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () => _next(context),
              child: const Text('Choose My GrowFit Plan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    final surface =
        Theme.of(context).colorScheme.surface;

    final primary =
        Theme.of(context).colorScheme.primary;

    final text =
        Theme.of(context).colorScheme.onSurface;

    final muted =
        Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: muted,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
