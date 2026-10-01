import 'package:flutter/material.dart';

import '../../models/food_model.dart';
import '../../services/daily_nutrition_service.dart';
import '../../services/food_log_builder_service.dart';
import '../../services/food_log_service.dart';

class MealSummaryScreen extends StatelessWidget {
  const MealSummaryScreen({
    super.key,
    required this.food,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.mealType,
  });

  final FoodModel food;
  final double quantity;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final String mealType;

  // ============================================================
  // SAVE FOOD
  // ============================================================

  void _save(BuildContext context) {
    final now = DateTime.now();

    try {
      // ----------------------------------------------------------
      // 1. BUILD THE FOOD LOG FROM THE CENTRALIZED NUTRITION PIPELINE
      // ----------------------------------------------------------
      //
      // FoodLogBuilderService -> FoodNutritionService -> NutritionData
      //
      // This keeps saved nutrition consistent with the same source used
      // by the detailed Food flow.
      final foodLog = FoodLogBuilderService.build(
        food: food,
        meal: mealType,
        quantityInput: quantity,
        loggedAt: now,
      );

      // ----------------------------------------------------------
      // 2. SAVE FOOD HISTORY
      // ----------------------------------------------------------

      FoodLogService.addLog(foodLog);

      // ----------------------------------------------------------
      // 3. UPDATE LIVE DAILY TOTALS
      // ----------------------------------------------------------

      DailyNutritionService.addFoodLog(foodLog);

      // ----------------------------------------------------------
      // 4. SUCCESS MESSAGE
      // ----------------------------------------------------------

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${food.name} added to $mealType',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // ----------------------------------------------------------
      // 5. RETURN TO HOME
      // ----------------------------------------------------------

      Navigator.popUntil(
        context,
        (route) => route.isFirst,
      );
    } on ArgumentError catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message?.toString() ?? 'Invalid food quantity.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Meal Summary',
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _heroCard(scheme),

                  const SizedBox(height: 20),

                  _nutritionGrid(scheme),

                  const SizedBox(height: 20),

                  _mealInfo(scheme),

                  const SizedBox(height: 20),

                  _note(scheme),
                ],
              ),
            ),

            // ====================================================
            // ADD TO TODAY
            // ====================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                24,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _save(context),

                  icon: Icon(
                    Icons.check_rounded,
                  ),

                  label: const Text(
                    'Add to Today',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
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
  // HERO CARD
  // ============================================================

  Widget _heroCard(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.secondary.withValues(alpha: 0.20),
            scheme.surfaceContainerHighest,
          ],
        ),

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color: scheme.secondary
              .withValues(alpha: 0.35),
        ),
      ),

      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,

            decoration: BoxDecoration(
              color: scheme.secondary
                  .withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),

            child: Icon(
              Icons.restaurant_rounded,
              color: scheme.secondary,
              size: 34,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            food.name,
            textAlign: TextAlign.center,

            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            '${quantity.round()} ${food.servingUnit}',
            style: TextStyle(
              color: scheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            '${calories.round()}',

            style: TextStyle(
              color: scheme.primary,
              fontSize: 40,
              fontWeight: FontWeight.w900,
            ),
          ),

          Text(
            'CALORIES',

            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NUTRITION GRID
  // ============================================================

  Widget _nutritionGrid(ColorScheme scheme) {
    return Row(
      children: [
        Expanded(
          child: _nutritionBox(
            'Protein',
            '${protein.toStringAsFixed(1)}g',
            scheme.secondary,
            scheme,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _nutritionBox(
            'Carbs',
            '${carbs.toStringAsFixed(1)}g',
            scheme.primary,
            scheme,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _nutritionBox(
            'Fats',
            '${fats.toStringAsFixed(1)}g',
            scheme.tertiary,
            scheme,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // NUTRITION BOX
  // ============================================================

  Widget _nutritionBox(
    String title,
    String value,
    Color color,
    ColorScheme scheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),

      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius:
            BorderRadius.circular(17),
      ),

      child: Column(
        children: [
          Text(
            value,

            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,

            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MEAL INFO
  // ============================================================

  Widget _mealInfo(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Icon(
            Icons.restaurant_menu_rounded,
            color: scheme.secondary,
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Text(
              'Meal',

              style: TextStyle(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),

          Text(
            mealType,

            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NOTE
  // ============================================================

  Widget _note(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.45),
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            Icons.info_outline_rounded,
            color: scheme.primary,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              'Nutrition values are calculated from the food database and the selected serving size.',
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}