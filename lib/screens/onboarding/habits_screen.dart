import 'package:flutter/material.dart';

import 'activity_level_screen.dart';
import 'goals_screen.dart';
import 'nutrition_preferences_screen.dart';

class HabitsScreen extends StatefulWidget {
  final String name;
  final int age;
  final double height;
  final double currentWeight;
  final double goalWeight;
  final GrowFitGoal goal;
  final double weeklyTarget;
  final GrowFitActivityLevel activityLevel;

  const HabitsScreen({
    super.key,
    required this.name,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.goalWeight,
    required this.goal,
    required this.weeklyTarget,
    required this.activityLevel,
  });

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final Set<String> selected = {};

  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _text => Theme.of(context).colorScheme.onSurface;
  Color get _muted => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _primary => Theme.of(context).colorScheme.primary;

  final habits = const [
    ('Running', Icons.directions_run_rounded),
    ('Gym', Icons.fitness_center_rounded),
    ('Yoga', Icons.self_improvement_rounded),
    ('Walking', Icons.directions_walk_rounded),
    ('Meditation', Icons.spa_rounded),
    ('Home Workout', Icons.home_rounded),
  ];

  void _next() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NutritionPreferencesScreen(
          name: widget.name,
          age: widget.age,
          height: widget.height,
          currentWeight: widget.currentWeight,
          goalWeight: widget.goalWeight,
          goal: widget.goal,
          weeklyTarget: widget.weeklyTarget,
          activityLevel: widget.activityLevel,
          habits: selected.toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text('Your Habits'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'What activities do you enjoy?',
                  style: TextStyle(
                    color: _text,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Select everything that applies to you.',
                  style: TextStyle(
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 25),
                ...habits.map(
                  (habit) => _habitCard(
                    habit.$1,
                    habit.$2,
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
    );
  }

  Widget _habitCard(
    String name,
    IconData icon,
  ) {
    final isSelected = selected.contains(name);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selected.remove(name);
          } else {
            selected.add(name);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? _primary.withValues(alpha: 0.12)
              : _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? _primary
                : _primary.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _primary,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              color: isSelected
                  ? _primary
                  : _muted,
            ),
          ],
        ),
      ),
    );
  }
}
