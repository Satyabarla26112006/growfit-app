import 'package:flutter/material.dart';

import 'activity_level_screen.dart';
import 'goals_screen.dart';
import 'meal_plan_assistance_screen.dart';

class NutritionPreferencesScreen extends StatefulWidget {
  final String name;
  final int age;
  final double height;
  final double currentWeight;
  final double goalWeight;
  final GrowFitGoal goal;
  final double weeklyTarget;
  final GrowFitActivityLevel activityLevel;
  final List<String> habits;

  const NutritionPreferencesScreen({
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
  });

  @override
  State<NutritionPreferencesScreen> createState() =>
      _NutritionPreferencesScreenState();
}

class _NutritionPreferencesScreenState
    extends State<NutritionPreferencesScreen> {
  final Set<String> selected = {};

  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _text => Theme.of(context).colorScheme.onSurface;
  Color get _muted => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _primary => Theme.of(context).colorScheme.primary;

  final preferences = const [
    'Track Calories',
    'Track Macros',
    'Eat More Protein',
    'Eat More Vegetables',
    'Reduce Sugar',
    'Drink More Water',
    'High Protein Diet',
    'Balanced Diet',
  ];

  void _next() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealPlanAssistanceScreen(
          name: widget.name,
          age: widget.age,
          height: widget.height,
          currentWeight: widget.currentWeight,
          goalWeight: widget.goalWeight,
          goal: widget.goal,
          weeklyTarget: widget.weeklyTarget,
          activityLevel: widget.activityLevel,
          habits: widget.habits,
          nutritionPreferences: selected.toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text('Nutrition'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'What do you want to focus on?',
                  style: TextStyle(
                    color: _text,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Choose your nutrition preferences.',
                  style: TextStyle(
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 25),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: preferences.map(
                    (item) {
                      final selectedItem = selected.contains(item);

                      return FilterChip(
                        label: Text(item),
                        selected: selectedItem,
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              selected.add(item);
                            } else {
                              selected.remove(item);
                            }
                          });
                        },
                        selectedColor:
                            _primary.withValues(alpha: 0.14),
                        checkmarkColor: _primary,
                        labelStyle: TextStyle(
                          color: selectedItem ? _text : _muted,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: _surface,
                        side: BorderSide(
                          color: selectedItem
                              ? _primary
                              : Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.35),
                        ),
                      );
                    },
                  ).toList(),
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
}
