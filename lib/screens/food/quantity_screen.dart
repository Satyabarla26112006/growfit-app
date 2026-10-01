import 'package:flutter/material.dart';

import '../../models/food_model.dart';
import '../../services/daily_nutrition_service.dart';
import '../../services/food_log_service.dart';
import '../../services/food_log_builder_service.dart';

class QuantityScreen extends StatefulWidget {
  const QuantityScreen({
    super.key,
    required this.food,
    required this.meal,
  });

  final FoodModel food;
  final String meal;

  @override
  State<QuantityScreen> createState() => _QuantityScreenState();
}

class _QuantityScreenState extends State<QuantityScreen> {
  late final TextEditingController _quantityController;

  double _calories = 0;

  Color get _background =>
      Theme.of(context).scaffoldBackgroundColor;

  Color get _surface =>
      Theme.of(context).colorScheme.surface;

  Color get _surfaceElevated =>
      Theme.of(context).colorScheme.surfaceContainerHighest;

  Color get _text =>
      Theme.of(context).colorScheme.onSurface;

  Color get _muted =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  Color get _primary =>
      Theme.of(context).colorScheme.primary;

  Color get _warning =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFD6A84E)
          : const Color(0xFFE09A2D);

  @override
  void initState() {
    super.initState();

    final food = widget.food;

    _quantityController = TextEditingController(
      text: food.servingUnit == 'piece'
          ? '1'
          : food.servingSize.toStringAsFixed(0),
    );

    _calories = food.calories;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _updatePreview(String value) {
    final quantity = double.tryParse(value.trim()) ?? 0;
    final food = widget.food;

    if (food.servingSize <= 0) {
      return;
    }

    final effective = food.servingUnit == 'piece'
        ? quantity * food.servingSize
        : quantity;

    final multiplier = effective / food.servingSize;

    setState(() {
      _calories = food.calories * multiplier;
    });
  }

  void _addFood() {
    final quantity = double.tryParse(
      _quantityController.text.trim(),
    );

    final food = widget.food;

    if (quantity == null ||
        quantity <= 0 ||
        food.servingSize <= 0) {
      return;
    }

    final now = DateTime.now();

    try {
      final log = FoodLogBuilderService.build(
        food: food,
        meal: widget.meal,
        quantityInput: quantity,
        loggedAt: now,
      );

      FoodLogService.addLog(log);
      DailyNutritionService.addFoodLog(log);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _surfaceElevated,
          content: Text(
            '${food.name} added to ${widget.meal}',
            style: TextStyle(
              color: _text,
            ),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, true);
    } catch (_) {
      // Keep this screen open if validation/building fails.
    }
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: _text,
          ),
        ),
        title: Text(
          'Add Food',
          style: TextStyle(
            color: _text,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            18,
            8,
            18,
            30,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _surfaceElevated,
                    _surface,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _primary.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _primary.withValues(alpha: 0.10),
                      ),
                    ),
                    child: Icon(
                      Icons.restaurant_rounded,
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
                          food.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _text,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Adding to ${widget.meal}',
                          style: TextStyle(
                            color: _muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              food.servingUnit == 'piece'
                  ? 'Quantity'
                  : 'Amount',
              style: TextStyle(
                color: _text,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _quantityController,
              onChanged: _updatePreview,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: TextStyle(
                color: _text,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: _surface,
                suffixText: food.servingUnit,
                suffixStyle: TextStyle(
                  color: _muted,
                  fontWeight: FontWeight.w700,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: _muted.withValues(alpha: 0.14),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: _muted.withValues(alpha: 0.14),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: _primary,
                    width: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _surfaceElevated,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _muted.withValues(alpha: 0.10),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _warning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.local_fire_department_rounded,
                      color: _warning,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calories',
                          style: TextStyle(
                            color: _muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Estimated for this amount',
                          style: TextStyle(
                            color:
                                _muted.withValues(alpha: 0.80),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${_calories.round()} kcal',
                    style: TextStyle(
                      color: _text,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _addFood,
                icon: const Icon(
                  Icons.add_rounded,
                ),
                label: Text(
                  'Add to ${widget.meal}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}