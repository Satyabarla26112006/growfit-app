import 'package:flutter/material.dart';

import 'activity_level_screen.dart';
import 'goals_screen.dart';

class TargetScreen extends StatefulWidget {
  final String name;
  final int age;
  final double height;
  final double currentWeight;
  final double goalWeight;
  final GrowFitGoal goal;

  const TargetScreen({
    super.key,
    required this.name,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.goalWeight,
    required this.goal,
  });

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  double? selectedTarget;

  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _text => Theme.of(context).colorScheme.onSurface;
  Color get _muted => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _primary => Theme.of(context).colorScheme.primary;

  // ============================================================
  // TARGET VALUES
  // ============================================================

  List<double> get availableTargets {
    switch (widget.goal) {
      case GrowFitGoal.loseWeight:
      case GrowFitGoal.gainWeight:
      case GrowFitGoal.gainMuscle:
        return const [
          0.25,
          0.5,
        ];

      case GrowFitGoal.maintainWeight:
      case GrowFitGoal.improveFitness:
        return const [
          0.0,
        ];
    }
  }

  // ============================================================
  // TITLE
  // ============================================================

  String get title {
    switch (widget.goal) {
      case GrowFitGoal.loseWeight:
        return 'How fast do you want to lose weight?';

      case GrowFitGoal.gainWeight:
        return 'How fast do you want to gain weight?';

      case GrowFitGoal.gainMuscle:
        return 'Choose your weekly target';

      case GrowFitGoal.maintainWeight:
        return 'Choose your weekly target';

      case GrowFitGoal.improveFitness:
        return 'Choose your weekly target';
    }
  }

  // ============================================================
  // DESCRIPTION
  // ============================================================

  String get description {
    switch (widget.goal) {
      case GrowFitGoal.loseWeight:
        return 'Choose a realistic weekly rate that you can maintain consistently.';

      case GrowFitGoal.gainWeight:
        return 'Choose a gradual weekly rate for healthy weight gain.';

      case GrowFitGoal.gainMuscle:
        return 'A gradual target helps support sustainable progress.';

      case GrowFitGoal.maintainWeight:
        return 'Your goal is to maintain your current weight while improving your fitness.';

      case GrowFitGoal.improveFitness:
        return 'Focus on consistent activity and overall fitness progress.';
    }
  }

  // ============================================================
  // NEXT
  // ============================================================

  void _next() {
    if (selectedTarget == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActivityLevelScreen(
          name: widget.name,
          age: widget.age,
          height: widget.height,
          currentWeight: widget.currentWeight,
          goalWeight: widget.goalWeight,
          goal: widget.goal,
          weeklyTarget: selectedTarget!,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        elevation: 0,
        title: const Text(
          'Weekly Target',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: [
                  Icon(
                    Icons.speed_rounded,
                    color: _primary,
                    size: 52,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    title,
                    style: TextStyle(
                      color: _text,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      color: _muted,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ...availableTargets.map(
                    (target) => _targetCard(target),
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
                      selectedTarget == null ? null : _next,
                  child: const Text(
                    'Continue',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TARGET CARD
  // ============================================================

  Widget _targetCard(double target) {
    final selected = selectedTarget == target;
    final isMaintain = target == 0;

    final String targetTitle = isMaintain
        ? 'Maintain weight'
        : '${target.toStringAsFixed(2)} kg per week';

    final String targetDescription = isMaintain
        ? 'Keep your current weight stable'
        : widget.goal == GrowFitGoal.loseWeight
            ? 'Gradual and sustainable weight loss'
            : widget.goal == GrowFitGoal.gainWeight
                ? 'Gradual and sustainable weight gain'
                : 'A steady target for your fitness journey';

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTarget = target;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
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
                isMaintain
                    ? Icons.balance_rounded
                    : Icons.trending_flat_rounded,
                color: _primary,
                size: 25,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    targetTitle,
                    style: TextStyle(
                      color: _text,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    targetDescription,
                    style: TextStyle(
                      color: _muted,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
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
