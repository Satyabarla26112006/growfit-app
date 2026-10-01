import 'package:flutter/material.dart';

import 'target_screen.dart';

enum GrowFitGoal {
  loseWeight,
  gainWeight,
  gainMuscle,
  maintainWeight,
  improveFitness,
}

class GoalsScreen extends StatefulWidget {
  final String name;
  final int age;
  final double height;
  final double currentWeight;
  final double goalWeight;

  const GoalsScreen({
    super.key,
    required this.name,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.goalWeight,
  });

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  GrowFitGoal? selectedGoal;

  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _text => Theme.of(context).colorScheme.onSurface;
  Color get _muted => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _primary => Theme.of(context).colorScheme.primary;

  final goals = const [
    (
      GrowFitGoal.loseWeight,
      'Lose Weight',
      'Reduce body fat and reach a healthier weight.',
      Icons.trending_down_rounded,
    ),
    (
      GrowFitGoal.gainWeight,
      'Gain Weight',
      'Increase body weight in a healthy way.',
      Icons.trending_up_rounded,
    ),
    (
      GrowFitGoal.gainMuscle,
      'Gain Muscle',
      'Build strength and lean muscle.',
      Icons.fitness_center_rounded,
    ),
    (
      GrowFitGoal.maintainWeight,
      'Maintain Weight',
      'Maintain your current body weight.',
      Icons.balance_rounded,
    ),
    (
      GrowFitGoal.improveFitness,
      'Improve Fitness',
      'Become stronger, fitter and more active.',
      Icons.directions_run_rounded,
    ),
  ];

  void _next() {
    if (selectedGoal == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TargetScreen(
          name: widget.name,
          age: widget.age,
          height: widget.height,
          currentWeight: widget.currentWeight,
          goalWeight: widget.goalWeight,
          goal: selectedGoal!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text('Your Goal'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'What is your main goal?',
                    style: TextStyle(
                      color: _text,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Choose the goal that best describes what you want.',
                    style: TextStyle(
                      color: _muted,
                    ),
                  ),

                  const SizedBox(height: 24),

                  ...goals.map(
                    (goal) => _goalCard(
                      goal.$1,
                      goal.$2,
                      goal.$3,
                      goal.$4,
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
                  onPressed:
                      selectedGoal == null ? null : _next,
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goalCard(
    GrowFitGoal goal,
    String title,
    String description,
    IconData icon,
  ) {
    final selected = selectedGoal == goal;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoal = goal;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? _primary.withValues(alpha: 0.12)
              : _surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? _primary
                : _primary.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _primary,
              size: 28,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: _text,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: _muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
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
