import 'package:flutter/material.dart';

import '../../models/food_model.dart';
import 'meal_summary_screen.dart';

class MealSelectionScreen extends StatefulWidget {
  const MealSelectionScreen({
    super.key,
    required this.food,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  final FoodModel food;
  final double quantity;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;

  @override
  State<MealSelectionScreen> createState() =>
      _MealSelectionScreenState();
}

class _MealSelectionScreenState extends State<MealSelectionScreen> {
  String selectedMeal = 'Breakfast';

  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _text => Theme.of(context).colorScheme.onSurface;
  Color get _muted => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _secondary => Theme.of(context).colorScheme.secondary;
  Color get _border => Theme.of(context).colorScheme.outline;

  final meals = const [
    ('Breakfast', Icons.wb_sunny_rounded, Color(0xFFE0B35A)),
    ('Lunch', Icons.light_mode_rounded, Color(0xFF5FB9B0)),
    ('Dinner', Icons.nightlight_round, Color(0xFF8C73C9)),
    ('Snack', Icons.cookie_rounded, Color(0xFFC98977)),
  ];

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealSummaryScreen(
          food: widget.food,
          quantity: widget.quantity,
          calories: widget.calories,
          protein: widget.protein,
          carbs: widget.carbs,
          fats: widget.fats,
          mealType: selectedMeal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Select Meal',
          style: TextStyle(
            color: _text,
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
                  Text(
                    'When did you eat this?',
                    style: TextStyle(
                      color: _text,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose the meal where you want to add this food.',
                    style: TextStyle(color: _muted),
                  ),
                  const SizedBox(height: 25),
                  ...meals.map(
                    (meal) => _mealCard(
                      name: meal.$1,
                      icon: meal.$2,
                      color: meal.$3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _selectedFoodCard(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _continue,
                  child: const Text(
                    'Review Food',
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

  Widget _mealCard({
    required String name,
    required IconData icon,
    required Color color,
  }) {
    final selected = selectedMeal == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMeal = name;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.10)
              : _surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? color
                : _border.withValues(alpha: 0.45),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 27),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: _text,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? color : _muted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectedFoodCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _border.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Food',
            style: TextStyle(
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.food.name,
            style: TextStyle(
              color: _text,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${widget.quantity.round()} ${widget.food.servingUnit} • ${widget.calories.round()} kcal',
            style: TextStyle(
              color: _secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
