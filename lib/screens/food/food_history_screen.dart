import 'package:flutter/material.dart';

import '../../models/food_log_model.dart';
import '../../services/daily_nutrition_service.dart';
import '../../services/food_log_service.dart';

class FoodHistoryScreen extends StatefulWidget {
  const FoodHistoryScreen({
    super.key,
  });

  @override
  State<FoodHistoryScreen> createState() =>
      _FoodHistoryScreenState();
}

class _FoodHistoryScreenState
    extends State<FoodHistoryScreen> {
  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _surfaceElevated =>
      Theme.of(context).colorScheme.surfaceContainerHighest;
  Color get _primary => Theme.of(context).colorScheme.primary;
  Color get _secondary => Theme.of(context).colorScheme.secondary;
  Color get _success => Theme.of(context).colorScheme.tertiary;
  Color get _textPrimary => Theme.of(context).colorScheme.onSurface;
  Color get _textSecondary =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.60);
  Color get _border => Theme.of(context).colorScheme.outlineVariant;
  Color get _error => Theme.of(context).colorScheme.error;

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  void _deleteFood(FoodLogModel log) {
    final deleted =
        FoodLogService.deleteLog(log.id);

    if (!deleted) {
      return;
    }

    _refresh();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${log.foodName} removed from today',
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // CONFIRM DELETE
  // ============================================================

  void _confirmDelete(FoodLogModel log) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              _surface,
          title: Text(
            'Remove Food?',
            style: TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Remove ${log.foodName} from today\'s food history?',
            style: TextStyle(
              color: _textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: _textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _deleteFood(log);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _error,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // EDIT QUANTITY
  // ============================================================

  void _editFood(FoodLogModel log) {
    final controller =
        TextEditingController(
      text: log.quantity
          .toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              _surface,

          title: Text(
            'Edit ${log.foodName}',
            style: TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),

          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Quantity',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: controller,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: TextStyle(
                  color: _textPrimary,
                ),
                decoration:
                    InputDecoration(
                  suffixText:
                      log.servingUnit,
                  suffixStyle:
                      TextStyle(
                    color: _textSecondary,
                  ),
                  filled: true,
                  fillColor:
                      _surfaceElevated,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: _textSecondary,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final newQuantity =
                    double.tryParse(
                  controller.text.trim(),
                );

                if (newQuantity == null ||
                    newQuantity <= 0) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter a valid quantity.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(
                  dialogContext,
                );

                _updateFoodQuantity(
                  log,
                  newQuantity,
                );
              },
              child: const Text(
                'Save',
              ),
            ),
          ],
        );
      },
    ).whenComplete(
      controller.dispose,
    );
  }

  // ============================================================
  // UPDATE FOOD
  // ============================================================

  void _updateFoodQuantity(
    FoodLogModel oldLog,
    double newQuantity,
  ) {
    final oldQuantity =
        oldLog.quantity;

    if (oldQuantity <= 0) {
      return;
    }

    final multiplier =
        newQuantity / oldQuantity;

    final updatedLog =
        oldLog.copyWith(
      quantity: newQuantity,
      calories:
          oldLog.calories * multiplier,
      protein:
          oldLog.protein * multiplier,
      carbs:
          oldLog.carbs * multiplier,
      fats:
          oldLog.fats * multiplier,
      fiber:
          oldLog.fiber * multiplier,
    );

    // Remove old nutrition first.
    DailyNutritionService.removeFoodLog(
      oldLog,
    );

    // Add updated nutrition.
    DailyNutritionService.addFoodLog(
      updatedLog,
    );

    // Replace history record.
    final updated =
        FoodLogService.updateLog(
      updatedLog,
    );

    if (!updated) {
      // Safety fallback.
      DailyNutritionService.removeFoodLog(
        updatedLog,
      );

      DailyNutritionService.addFoodLog(
        oldLog,
      );

      return;
    }

    _refresh();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${oldLog.foodName} updated',
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final logs =
        FoodLogService.getTodayLogs();

    return Scaffold(
      backgroundColor:
          _background,

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: _textPrimary,
          ),
        ),

        title: Text(
          'Food History',
          style: TextStyle(
            color: _textPrimary,
            fontWeight:
                FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        child: logs.isEmpty
            ? _emptyState()
            : ListView(
                padding:
                    const EdgeInsets.fromLTRB(
                  18,
                  10,
                  18,
                  30,
                ),
                children: [
                  _summaryCard(logs),

                  const SizedBox(height: 18),

                  _mealSection(
                    title: 'Breakfast',
                    icon:
                        Icons.wb_sunny_rounded,
                    iconColor:
                        _success,
                    logs: logs
                        .where(
                          (log) =>
                              log.mealType
                                  .toLowerCase() ==
                              'breakfast',
                        )
                        .toList(),
                  ),

                  _mealSection(
                    title: 'Lunch',
                    icon:
                        Icons.light_mode_rounded,
                    iconColor:
                        _secondary,
                    logs: logs
                        .where(
                          (log) =>
                              log.mealType
                                  .toLowerCase() ==
                              'lunch',
                        )
                        .toList(),
                  ),

                  _mealSection(
                    title: 'Dinner',
                    icon:
                        Icons.restaurant_rounded,
                    iconColor:
                        _secondary,
                    logs: logs
                        .where(
                          (log) =>
                              log.mealType
                                  .toLowerCase() ==
                              'dinner',
                        )
                        .toList(),
                  ),

                  _mealSection(
                    title: 'Snacks',
                    icon:
                        Icons.nightlight_round,
                    iconColor:
                        _primary,
                    logs: logs
                        .where((log) {
                          final meal =
                              log.mealType
                                  .toLowerCase();

                          return meal == 'snack' ||
                              meal == 'snacks';
                        })
                        .toList(),
                  ),
                ],
              ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration:
                  BoxDecoration(
                color:
                    _secondary
                        .withValues(
                  alpha: 0.14,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu_rounded,
                color: _secondary,
                size: 42,
              ),
            ),

            const SizedBox(height: 22),

            Text(
              'No Food Logged Yet',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: _textPrimary,
                fontSize: 22,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Start tracking your meals to see your food history here.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    _textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 26),

            SizedBox(
              height: 52,
              child:
                  ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.add_rounded,
                ),
                label: const Text(
                  'Add Food',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w800,
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
  // SUMMARY CARD
  // ============================================================

  Widget _summaryCard(
    List<FoodLogModel> logs,
  ) {
    final calories =
        logs.fold<double>(
      0,
      (total, log) =>
          total + log.calories,
    );

    final protein =
        logs.fold<double>(
      0,
      (total, log) =>
          total + log.protein,
    );

    final carbs =
        logs.fold<double>(
      0,
      (total, log) =>
          total + log.carbs,
    );

    final fats =
        logs.fold<double>(
      0,
      (total, log) =>
          total + log.fats,
    );

    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          colors: [
            _secondary.withValues(alpha: 0.24),
            _primary.withValues(alpha: 0.10),
          ],
        ),
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color:
              _secondary
                  .withValues(
            alpha: 0.35,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'TODAY',
            style: TextStyle(
              color:
                  _textSecondary,
              fontSize: 11,
              fontWeight:
                  FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '${calories.round()} kcal',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 30,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '${logs.length} food ${logs.length == 1 ? 'item' : 'items'} logged',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _summaryMacro(
                  'Protein',
                  protein,
                  _secondary,
                ),
              ),
              Expanded(
                child: _summaryMacro(
                  'Carbs',
                  carbs,
                  _primary,
                ),
              ),
              Expanded(
                child: _summaryMacro(
                  'Fats',
                  fats,
                  _success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryMacro(
    String title,
    double value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: _textSecondary,
            fontSize: 11,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          '${value.toStringAsFixed(1)}g',
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MEAL SECTION
  // ============================================================

  Widget _mealSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<FoodLogModel> logs,
  }) {
    if (logs.isEmpty) {
      return const SizedBox.shrink();
    }

    final mealCalories =
        logs.fold<double>(
      0,
      (total, log) =>
          total + log.calories,
    );

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration:
          BoxDecoration(
        color:
            _surface,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color:
              _border.withValues(alpha: 0.40),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration:
                    BoxDecoration(
                  color:
                      iconColor.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style:
                      TextStyle(
                    color: _textPrimary,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              Text(
                '${mealCalories.round()} kcal',
                style:
                    TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Divider(
            color: _border,
          ),

          const SizedBox(height: 4),

          for (final log in logs)
            _foodItem(log),
        ],
      ),
    );
  }

  // ============================================================
  // FOOD ITEM
  // ============================================================

  Widget _foodItem(
    FoodLogModel log,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration:
                BoxDecoration(
              color:
                  _surfaceElevated,
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),
            child: Icon(
              Icons.restaurant_rounded,
              color: _secondary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  log.foodName,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${log.quantity.round()} ${log.servingUnit} • '
                  '${log.protein.toStringAsFixed(1)}g protein',
                  style:
                      TextStyle(
                    color: _textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                '${log.calories.round()}',
                style:
                    TextStyle(
                  color: _primary,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'kcal',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),

          const SizedBox(width: 6),

          PopupMenuButton<String>(
            color:
                _surfaceElevated,
            icon: Icon(
              Icons.more_vert_rounded,
              color: _textSecondary,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                _editFood(log);
              }

              if (value == 'delete') {
                _confirmDelete(log);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_rounded,
                      color:
                          _secondary,
                      size: 19,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Edit',
                      style: TextStyle(
                        color: _textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      color:
                          _error,
                      size: 19,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: _textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}