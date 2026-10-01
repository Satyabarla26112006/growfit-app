import 'package:flutter/material.dart';

import 'goals_screen.dart';
import 'habits_screen.dart';

enum GrowFitActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extremelyActive,
}

class ActivityLevelScreen extends StatefulWidget {
  final String name;
  final int age;
  final double height;
  final double currentWeight;
  final double goalWeight;
  final GrowFitGoal goal;
  final double weeklyTarget;

  const ActivityLevelScreen({
    super.key,
    required this.name,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.goalWeight,
    required this.goal,
    required this.weeklyTarget,
  });

  @override
  State<ActivityLevelScreen> createState() =>
      _ActivityLevelScreenState();
}

class _ActivityLevelScreenState
    extends State<ActivityLevelScreen> {
  GrowFitActivityLevel? selected;

  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _text => Theme.of(context).colorScheme.onSurface;
  Color get _muted => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _primary => Theme.of(context).colorScheme.primary;

  final levels = const [
    (
      GrowFitActivityLevel.sedentary,
      'Sedentary',
      'Little or no exercise',
    ),
    (
      GrowFitActivityLevel.lightlyActive,
      'Lightly Active',
      'Light exercise 1–3 days per week',
    ),
    (
      GrowFitActivityLevel.moderatelyActive,
      'Moderately Active',
      'Exercise 3–5 days per week',
    ),
    (
      GrowFitActivityLevel.veryActive,
      'Very Active',
      'Hard exercise 6–7 days per week',
    ),
    (
      GrowFitActivityLevel.extremelyActive,
      'Extremely Active',
      'Very hard training or physical job',
    ),
  ];

  void _next() {
    if (selected == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HabitsScreen(
          name: widget.name,
          age: widget.age,
          height: widget.height,
          currentWeight: widget.currentWeight,
          goalWeight: widget.goalWeight,
          goal: widget.goal,
          weeklyTarget: widget.weeklyTarget,
          activityLevel: selected!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text('Activity Level'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'How active are you?',
                  style: TextStyle(
                    color: _text,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'This helps us calculate your daily energy needs.',
                  style: TextStyle(
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 25),
                ...levels.map(
                  (level) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = level.$1;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: selected == level.$1
                            ? _primary.withValues(alpha: 0.12)
                            : _surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected == level.$1
                              ? _primary
                              : _primary.withValues(
                                  alpha: 0.08,
                                ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level.$2,
                                  style: TextStyle(
                                    color: _text,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  level.$3,
                                  style: TextStyle(
                                    color: _muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            selected == level.$1
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: selected == level.$1
                                ? _primary
                                : _muted,
                          ),
                        ],
                      ),
                    ),
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
                onPressed: selected == null ? null : _next,
                child: const Text('Continue'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
