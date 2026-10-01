import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/calorie_service.dart';
import '../../services/user_service.dart';
import 'activity_level_screen.dart';
import 'bmi_screen.dart';
import 'goals_screen.dart';

class CalculationScreen extends StatefulWidget {
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

  const CalculationScreen({
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
  });

  @override
  State<CalculationScreen> createState() =>
      _CalculationScreenState();
}

class _CalculationScreenState
    extends State<CalculationScreen> {
  double progress = 0.0;
  bool finished = false;
  bool saving = false;

  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _text => Theme.of(context).colorScheme.onSurface;
  Color get _muted => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _primary => Theme.of(context).colorScheme.primary;

  late NutritionTargets nutritionTargets;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  // ============================================================
  // CALCULATE NUTRITION
  // ============================================================

  Future<void> _calculate() async {
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(
        const Duration(milliseconds: 120),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        progress = i / 10;
      });
    }

    nutritionTargets =
        CalorieService.calculateNutritionTargets(
      weight: widget.currentWeight,
      height: widget.height,
      age: widget.age,

      // Temporary until gender is added.
      isMale: true,

      activityLevel: widget.activityLevel,
      goal: widget.goal,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      finished = true;
    });
  }

  // ============================================================
  // CONVERT GOAL
  // ============================================================

  FitnessGoal _convertGoal() {
    final goalName = widget.goal.name;

    return FitnessGoal.values.firstWhere(
      (goal) => goal.name == goalName,
      orElse: () =>
          FitnessGoal.maintainWeight,
    );
  }

  // ============================================================
  // CONVERT ACTIVITY LEVEL
  // ============================================================

  ActivityLevel _convertActivityLevel() {
    final activityName =
        widget.activityLevel.name;

    return ActivityLevel.values.firstWhere(
      (level) => level.name == activityName,
      orElse: () =>
          ActivityLevel.moderatelyActive,
    );
  }

  // ============================================================
  // CONVERT WEEKLY TARGET
  // ============================================================

  WeeklyTarget _convertWeeklyTarget() {
    if (widget.weeklyTarget == 0.25) {
      return WeeklyTarget.zeroPoint25Kg;
    }

    if (widget.weeklyTarget == 0.5) {
      return WeeklyTarget.zeroPoint5Kg;
    }

    return WeeklyTarget.custom;
  }

  // ============================================================
  // SAVE USER
  // ============================================================

  Future<void> _saveUser() async {
    final user = UserModel(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),

      name: widget.name,

      age: widget.age,

      height: widget.height,

      currentWeight:
          widget.currentWeight,

      goalWeight:
          widget.goalWeight,

      goal: _convertGoal(),

      weeklyTarget:
          _convertWeeklyTarget(),

      activityLevel:
          _convertActivityLevel(),

      habits: List<String>.from(
        widget.habits,
      ),

      nutritionPreferences:
          List<String>.from(
        widget.nutritionPreferences,
      ),

      targetCalories:
          nutritionTargets.calories,

      targetProtein:
          nutritionTargets.protein,

      targetCarbs:
          nutritionTargets.carbohydrates,

      targetFats:
          nutritionTargets.fats,

      // UserModel automatically uses
      // the Free subscription by default.

      createdAt:
          DateTime.now(),

      updatedAt: null,
    );

    await UserService.saveUser(user);
  }

  // ============================================================
  // NEXT
  // ============================================================

  Future<void> _next() async {
    if (saving) {
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      // Save the completed onboarding profile.
      await _saveUser();

      if (!mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BmiScreen(
            name: widget.name,
            age: widget.age,
            height: widget.height,
            currentWeight:
                widget.currentWeight,
            goalWeight:
                widget.goalWeight,
            goal: widget.goal,
            weeklyTarget:
                widget.weeklyTarget,
            habits:
                widget.habits,
            nutritionPreferences:
                widget.nutritionPreferences,
            mealPlanAssistance:
                widget.mealPlanAssistance,
            activityLevel:
                widget.activityLevel,
            calories:
                nutritionTargets.calories,
            protein:
                nutritionTargets.protein,
            carbs:
                nutritionTargets.carbohydrates,
            fats:
                nutritionTargets.fats,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                // ==================================================
                // ICON
                // ==================================================

                Icon(
                  Icons.auto_awesome_rounded,
                  color:
                      _primary,
                  size: 58,
                ),

                const SizedBox(height: 28),

                // ==================================================
                // TITLE
                // ==================================================

                Text(
                  'Creating Your Plan',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color:
                        _text,
                    fontSize: 29,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 12),

                // ==================================================
                // DESCRIPTION
                // ==================================================

                Text(
                  finished
                      ? 'Your personalized results are ready.'
                      : 'Analyzing your information...',
                  textAlign:
                      TextAlign.center,
                  style:
                      TextStyle(
                    color:
                        _muted,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 35),

                // ==================================================
                // PROGRESS BAR
                // ==================================================

                LinearProgressIndicator(
                  value: progress,
                  minHeight: 7,
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                  backgroundColor:
                      _surface,
                  color:
                      _primary,
                ),

                const SizedBox(height: 12),

                // ==================================================
                // PERCENTAGE
                // ==================================================

                Text(
                  '${(progress * 100).round()}%',
                  style:
                      TextStyle(
                    color:
                        _primary,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 40),

                // ==================================================
                // CONTINUE
                // ==================================================

                if (finished)
                  SizedBox(
                    width:
                        double.infinity,
                    height: 56,
                    child:
                        ElevatedButton(
                      onPressed:
                          saving
                              ? null
                              : _next,
                      child: saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2.5,
                              ),
                            )
                          : const Text(
                              'See My Results',
                            ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}