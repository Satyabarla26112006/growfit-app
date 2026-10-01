import 'package:flutter/material.dart';

import 'activity_level_screen.dart';
import 'calculation_screen.dart';
import 'goals_screen.dart';

class MealPlanAssistanceScreen extends StatefulWidget {
  final String name;
  final int age;
  final double height;
  final double currentWeight;
  final double goalWeight;
  final GrowFitGoal goal;
  final double weeklyTarget;
  final GrowFitActivityLevel activityLevel;
  final List<String> habits;
  final List<String> nutritionPreferences;

  const MealPlanAssistanceScreen({
    super.key,
    required this.name,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.goalWeight,
    required this.goal,
    required this.weeklyTarget,
    required this.activityLevel,
    required this.habits,
    required this.nutritionPreferences,
  });

  @override
  State<MealPlanAssistanceScreen> createState() =>
      _MealPlanAssistanceScreenState();
}

class _MealPlanAssistanceScreenState
    extends State<MealPlanAssistanceScreen> {
  String assistance = 'Personalized Plan';

  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _text => Theme.of(context).colorScheme.onSurface;
  Color get _muted => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _primary => Theme.of(context).colorScheme.primary;

  final options = const [
    (
      'Personalized Plan',
      'Get meal guidance based on your fitness goal.',
      Icons.auto_awesome_rounded,
    ),
    (
      'Simple Meal Ideas',
      'Get easy meal suggestions for everyday eating.',
      Icons.restaurant_rounded,
    ),
    (
      'I Will Plan Myself',
      'Track your nutrition while planning meals yourself.',
      Icons.edit_note_rounded,
    ),
  ];

  void _next() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CalculationScreen(
          name: widget.name,
          age: widget.age,
          height: widget.height,
          currentWeight: widget.currentWeight,
          goalWeight: widget.goalWeight,
          goal: widget.goal,
          weeklyTarget: widget.weeklyTarget,
          activityLevel: widget.activityLevel,
          habits: widget.habits,
          nutritionPreferences: widget.nutritionPreferences,
          mealPlanAssistance: assistance,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text('Meal Plan'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'How can GrowFit help with meals?',
                    style: TextStyle(
                      color: _text,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Choose the level of meal planning '
                    'assistance you want.',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ...options.map(
                    (option) => _optionCard(
                      title: option.$1,
                      description: option.$2,
                      icon: option.$3,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _next,
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    final selected = assistance == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          assistance = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: selected
              ? _primary.withValues(alpha: 0.12)
              : _surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? _primary
                : _primary.withValues(alpha: 0.08),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: _primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: _text,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      color: _muted,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              color: selected
                  ? _primary
                  : _muted,
            ),
          ],
        ),
      ),
    );
  }
}
