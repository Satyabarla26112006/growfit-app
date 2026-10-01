import 'package:flutter/material.dart';

import '../../data/nutrition_data.dart';
import '../../models/food_model.dart';
import '../../services/daily_nutrition_service.dart';
import '../../services/food_log_builder_service.dart';
import '../../services/food_log_service.dart';
import '../../services/food_nutrition_service.dart';
import '../../services/food_score_service.dart';
import '../../services/nutrition_daily_value_service.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodModel food;
  final String meal;

  const FoodDetailScreen({
    super.key,
    required this.food,
    required this.meal,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _surfaceElevated =>
      Theme.of(context).colorScheme.surfaceContainerHighest;
  Color get _text => Theme.of(context).colorScheme.onSurface;
  Color get _muted => Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62);
  Color get _primary => Theme.of(context).colorScheme.primary;
  Color get _secondary => Theme.of(context).colorScheme.secondary;
  Color get _warning => Theme.of(context).colorScheme.error;
  Color get _border => Theme.of(context).colorScheme.outline.withValues(alpha: 0.45);

  late final TextEditingController _quantityController;

  late double _quantity;
  late double _effectiveGrams;

  bool _vitaminsExpanded = false;
  bool _mineralsExpanded = false;
  bool _otherExpanded = false;
  bool _showAllNutrients = false;

  @override
  void initState() {
    super.initState();

    final unit = widget.food.servingUnit.trim().toLowerCase();

    _quantity = unit == 'piece' ? 1 : widget.food.servingSize;

    _quantityController = TextEditingController(
      text: _formatNumber(_quantity),
    );

    _updateEffectiveAmount();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }

  String _formatNutrition(double value) {
    if (value == 0) return '0';
    if (value >= 100) return value.toStringAsFixed(0);
    if (value >= 10) return value.toStringAsFixed(1);
    return value.toStringAsFixed(2);
  }

  String _unit() => widget.food.servingUnit.trim().toLowerCase();


  bool _isDirectAmount() {
    return const {
      'g',
      'gm',
      'gram',
      'grams',
      'ml',
      'milliliter',
      'milliliters',
      'l',
      'liter',
      'liters',
    }.contains(_unit());
  }

  String _amountUnitLabel() {
    switch (_unit()) {
      case 'ml':
      case 'milliliter':
      case 'milliliters':
        return 'ml';
      case 'l':
      case 'liter':
      case 'liters':
        return 'L';
      case 'g':
      case 'gm':
      case 'gram':
      case 'grams':
        return 'g';
      default:
        return widget.food.servingUnit.trim().isEmpty
            ? 'serving'
            : widget.food.servingUnit.trim();
    }
  }

  void _updateEffectiveAmount() {
    // g/ml/L are already direct amounts. Only discrete units such as
    // pieces/slices need to be converted through servingSize.
    if (_isDirectAmount()) {
      _effectiveGrams = _quantity;
    } else {
      _effectiveGrams = _quantity * widget.food.servingSize;
    }
  }

  NutritionRecord _nutritionForCurrentQuantity() {
    if (_effectiveGrams <= 0) {
      return FoodNutritionService.nutritionForQuantity(
        food: widget.food,
        quantity: 0,
      );
    }

    // Always scale from the 100-unit reference record. Passing the raw
    // serving amount directly can double-apply servingSize for foods whose
    // FoodModel servingSize is already 250 ml, 200 ml, etc.
    final reference = FoodNutritionService.nutritionForQuantity(
      food: widget.food,
      quantity: 100,
    );
    final multiplier = _effectiveGrams / 100.0;

    return reference.scale(multiplier);
  }

  NutritionRecord _nutritionPer100g() {
    return FoodNutritionService.nutritionForQuantity(
      food: widget.food,
      quantity: 100,
    );
  }

  void _onQuantityChanged(String value) {
    final parsed = double.tryParse(value.trim());

    if (parsed == null || parsed <= 0) {
      setState(() {
        _quantity = 0;
        _effectiveGrams = 0;
      });
      return;
    }

    setState(() {
      _quantity = parsed;
      _updateEffectiveAmount();
    });
  }

  double get _quantityStep => _isDirectAmount() ? 10 : 1;

  void _changeQuantity(double delta) {
    final next = _quantity + delta;

    if (next <= 0) {
      setState(() {
        _quantity = 0;
        _effectiveGrams = 0;
        _quantityController.text = '0';
      });
      return;
    }

    setState(() {
      _quantity = next;
      _updateEffectiveAmount();
      _quantityController.text = _formatNumber(_quantity);
      _quantityController.selection = TextSelection.fromPosition(
        TextPosition(offset: _quantityController.text.length),
      );
    });
  }

  void _addFood() {
    if (_quantity <= 0 ||
        _effectiveGrams <= 0 ||
        widget.food.servingSize <= 0) {
      return;
    }

    final now = DateTime.now();

    try {
      final log = FoodLogBuilderService.build(
        food: widget.food,
        meal: widget.meal,
        quantityInput: _quantity,
        loggedAt: now,
      );

      FoodLogService.addLog(log);
      DailyNutritionService.addFoodLog(log);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.food.name} added to ${widget.meal}'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to add this food.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _nutritionForCurrentQuantity();
    final per100 = _nutritionPer100g();

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  _buildHeader(current),
                  _buildFoodScore(per100),
                  _buildNutritionFacts(current),
                  _buildVitaminSection(current),
                  _buildMineralSection(current),
                  _buildOtherSection(current),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 165),
                  ),
                ],
              ),
            ),
            _buildQuantitySection(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader(NutritionRecord nutrition) {
    final basedOn = _isDirectAmount()
        ? '${_formatNumber(_quantity)} ${_amountUnitLabel()}'
        : '${_formatNumber(_quantity)} ${widget.food.servingUnit}';

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _secondary.withValues(alpha: 0.22),
              _surface,
            ],
          ),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                _topIconButton(
                  Icons.arrow_back_rounded,
                  () => Navigator.pop(context),
                ),
                const Spacer(),
                _topIconButton(
                  Icons.share_rounded,
                  () {},
                ),
                const SizedBox(width: 4),
                _topIconButton(
                  Icons.more_vert_rounded,
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.food.name,
                style: TextStyle(
                  color: _text,
                  fontSize: 31,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    color: _secondary,
                    size: 27,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '${nutrition.calories.round()} Calories',
                    style: TextStyle(
                      color: _text,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Based on $basedOn',
                style: TextStyle(
                  color: _muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topIconButton(
    IconData icon,
    VoidCallback onPressed,
  ) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: _text,
        size: 25,
      ),
      splashRadius: 24,
    );
  }

  // ---------------------------------------------------------------------------
  // FOOD SCORE
  // ---------------------------------------------------------------------------

  Widget _buildFoodScore(NutritionRecord nutrition) {
    final result = FoodScoreService.calculate(nutrition);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Food Score',
                  style: TextStyle(
                    color: _text,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 9),
                _proBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _border.withValues(alpha: 0.45),
                ),
              ),
              child: Row(
                children: [
                  _scoreCircle(result.score),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _scoreLabel(result.score),
                      style: TextStyle(
                        color: _text,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _scoreCard(
                    title: 'What is good',
                    icon: Icons.thumb_up_alt_rounded,
                    iconColor: _primary,
                    background: _surfaceElevated,
                    items: result.positives,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _scoreCard(
                    title: 'What to watch',
                    icon: Icons.warning_amber_rounded,
                    iconColor: _warning,
                    background: _surfaceElevated,
                    items: result.cautions,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreCircle(int score) {
    return SizedBox(
      width: 78,
      height: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 7,
            backgroundColor: _border,
            valueColor: AlwaysStoppedAnimation<Color>(
              _secondary,
            ),
          ),
          Text(
            '$score',
            style: TextStyle(
              color: _text,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  String _scoreLabel(int score) {
    if (score >= 85) return 'Excellent nutrition profile';
    if (score >= 70) return 'Good nutrition profile';
    if (score >= 50) return 'Moderate nutrition profile';
    return 'Needs attention';
  }

  Widget _proBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _secondary,
            _primary,
          ],
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        'PRO',
        style: TextStyle(
          color: _text,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _scoreCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color background,
    required List<String> items,
  }) {
    return Container(
      height: 158,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 23,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: _text,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length > 3 ? 3 : items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• ${items[index]}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _muted,
                      fontSize: 11,
                      height: 1.25,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NUTRITION FACTS
  // ---------------------------------------------------------------------------

  Widget _buildNutritionFacts(NutritionRecord nutrition) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
        child: _sectionCard(
          title: 'Nutrition Facts',
          trailing: Text(
            '%DV based on 2,000 kcal',
            style: TextStyle(
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Column(
            children: [
              _nutritionRow(
                'Energy',
                '${nutrition.calories.round()} kcal',
                percent: NutritionDailyValueService.caloriesPercent(
                  nutrition.calories,
                ),
                emphasize: true,
              ),
              _nutritionRow(
                'Carbohydrates',
                '${_formatNutrition(nutrition.carbohydrates)} g',
                percent: NutritionDailyValueService.carbohydratePercent(
                  nutrition.carbohydrates,
                ),
              ),
              _nutritionRow(
                'Protein',
                '${_formatNutrition(nutrition.protein)} g',
              ),
              _nutritionRow(
                'Fat',
                '${_formatNutrition(nutrition.fats)} g',
                percent: NutritionDailyValueService.totalFatPercent(
                  nutrition.fats,
                ),
              ),
              _nutritionRow(
                'Fiber',
                '${_formatNutrition(nutrition.fiber)} g',
                percent: NutritionDailyValueService.fiberPercent(
                  nutrition.fiber,
                ),
              ),
              _nutritionRow(
                'Sugar',
                '${_formatNutrition(nutrition.sugar)} g',
              ),
              _nutritionRow(
                'Added Sugar',
                '${_formatNutrition(nutrition.addedSugar)} g',
                percent: NutritionDailyValueService.addedSugarPercent(
                  nutrition.addedSugar,
                ),
              ),
              const SizedBox(height: 10),
              _referenceNote(),
              const SizedBox(height: 8),
              _showAllToggle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _referenceNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: _secondary,
            size: 18,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Nutrition data uses 100 g as the reference basis. '
              'The values above are for your selected quantity.',
              style: TextStyle(
                color: _muted,
                fontSize: 11,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showAllToggle() {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        setState(() {
          _showAllNutrients = !_showAllNutrients;
          _vitaminsExpanded = _showAllNutrients;
          _mineralsExpanded = _showAllNutrients;
          _otherExpanded = _showAllNutrients;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _showAllNutrients
                  ? 'Hide all nutrients'
                  : 'Show all nutrients',
              style: TextStyle(
                color: _text,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 7),
            Icon(
              _showAllNutrients
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: _secondary,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // VITAMINS
  // ---------------------------------------------------------------------------

  Widget _buildVitaminSection(NutritionRecord nutrition) {
    return _buildExpandableSection(
      title: 'Vitamins',
      icon: Icons.water_drop_outlined,
      expanded: _vitaminsExpanded,
      onTap: () {
        setState(() {
          _vitaminsExpanded = !_vitaminsExpanded;
          _syncShowAllState();
        });
      },
      child: Column(
        children: [
          _nutritionRow(
            'Vitamin A',
            '${_formatNutrition(nutrition.vitaminA)} mcg',
            percent: NutritionDailyValueService.vitaminAPercent(
              nutrition.vitaminA,
            ),
          ),
          _nutritionRow(
            'Vitamin C',
            '${_formatNutrition(nutrition.vitaminC)} mg',
            percent: NutritionDailyValueService.vitaminCPercent(
              nutrition.vitaminC,
            ),
          ),
          _nutritionRow(
            'Vitamin D',
            '${_formatNutrition(nutrition.vitaminD)} mcg',
            percent: NutritionDailyValueService.vitaminDPercent(
              nutrition.vitaminD,
            ),
          ),
          _nutritionRow(
            'Vitamin E',
            '${_formatNutrition(nutrition.vitaminE)} mg',
            percent: NutritionDailyValueService.vitaminEPercent(
              nutrition.vitaminE,
            ),
          ),
          _nutritionRow(
            'Vitamin K',
            '${_formatNutrition(nutrition.vitaminK)} mcg',
            percent: NutritionDailyValueService.vitaminKPercent(
              nutrition.vitaminK,
            ),
          ),
          _nutritionRow(
            'Vitamin B1',
            '${_formatNutrition(nutrition.vitaminB1)} mg',
            percent: NutritionDailyValueService.vitaminB1Percent(
              nutrition.vitaminB1,
            ),
          ),
          _nutritionRow(
            'Vitamin B2',
            '${_formatNutrition(nutrition.vitaminB2)} mg',
            percent: NutritionDailyValueService.vitaminB2Percent(
              nutrition.vitaminB2,
            ),
          ),
          _nutritionRow(
            'Vitamin B3',
            '${_formatNutrition(nutrition.vitaminB3)} mg',
            percent: NutritionDailyValueService.vitaminB3Percent(
              nutrition.vitaminB3,
            ),
          ),
          _nutritionRow(
            'Vitamin B5',
            '${_formatNutrition(nutrition.vitaminB5)} mg',
            percent: NutritionDailyValueService.vitaminB5Percent(
              nutrition.vitaminB5,
            ),
          ),
          _nutritionRow(
            'Vitamin B6',
            '${_formatNutrition(nutrition.vitaminB6)} mg',
            percent: NutritionDailyValueService.vitaminB6Percent(
              nutrition.vitaminB6,
            ),
          ),
          _nutritionRow(
            'Vitamin B7',
            '${_formatNutrition(nutrition.vitaminB7)} mcg',
            percent: NutritionDailyValueService.vitaminB7Percent(
              nutrition.vitaminB7,
            ),
          ),
          _nutritionRow(
            'Vitamin B9',
            '${_formatNutrition(nutrition.vitaminB9)} mcg',
            percent: NutritionDailyValueService.vitaminB9Percent(
              nutrition.vitaminB9,
            ),
          ),
          _nutritionRow(
            'Vitamin B12',
            '${_formatNutrition(nutrition.vitaminB12)} mcg',
            percent: NutritionDailyValueService.vitaminB12Percent(
              nutrition.vitaminB12,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MINERALS
  // ---------------------------------------------------------------------------

  Widget _buildMineralSection(NutritionRecord nutrition) {
    return _buildExpandableSection(
      title: 'Minerals',
      icon: Icons.grain_rounded,
      expanded: _mineralsExpanded,
      onTap: () {
        setState(() {
          _mineralsExpanded = !_mineralsExpanded;
          _syncShowAllState();
        });
      },
      child: Column(
        children: [
          _nutritionRow(
            'Potassium',
            '${_formatNutrition(nutrition.potassium)} mg',
            percent: NutritionDailyValueService.potassiumPercent(
              nutrition.potassium,
            ),
          ),
          _nutritionRow(
            'Calcium',
            '${_formatNutrition(nutrition.calcium)} mg',
            percent: NutritionDailyValueService.calciumPercent(
              nutrition.calcium,
            ),
          ),
          _nutritionRow(
            'Iron',
            '${_formatNutrition(nutrition.iron)} mg',
            percent: NutritionDailyValueService.ironPercent(
              nutrition.iron,
            ),
          ),
          _nutritionRow(
            'Magnesium',
            '${_formatNutrition(nutrition.magnesium)} mg',
            percent: NutritionDailyValueService.magnesiumPercent(
              nutrition.magnesium,
            ),
          ),
          _nutritionRow(
            'Phosphorus',
            '${_formatNutrition(nutrition.phosphorus)} mg',
            percent: NutritionDailyValueService.phosphorusPercent(
              nutrition.phosphorus,
            ),
          ),
          _nutritionRow(
            'Zinc',
            '${_formatNutrition(nutrition.zinc)} mg',
            percent: NutritionDailyValueService.zincPercent(
              nutrition.zinc,
            ),
          ),
          _nutritionRow(
            'Copper',
            '${_formatNutrition(nutrition.copper)} mg',
            percent: NutritionDailyValueService.copperPercent(
              nutrition.copper,
            ),
          ),
          _nutritionRow(
            'Manganese',
            '${_formatNutrition(nutrition.manganese)} mg',
            percent: NutritionDailyValueService.manganesePercent(
              nutrition.manganese,
            ),
          ),
          _nutritionRow(
            'Selenium',
            '${_formatNutrition(nutrition.selenium)} mcg',
            percent: NutritionDailyValueService.seleniumPercent(
              nutrition.selenium,
            ),
          ),
          _nutritionRow(
            'Iodine',
            '${_formatNutrition(nutrition.iodine)} mcg',
            percent: NutritionDailyValueService.iodinePercent(
              nutrition.iodine,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // OTHER NUTRIENTS
  // ---------------------------------------------------------------------------

  Widget _buildOtherSection(NutritionRecord nutrition) {
    return _buildExpandableSection(
      title: 'Other Nutrients',
      icon: Icons.tune_rounded,
      expanded: _otherExpanded,
      onTap: () {
        setState(() {
          _otherExpanded = !_otherExpanded;
          _syncShowAllState();
        });
      },
      child: Column(
        children: [
          _nutritionRow(
            'Saturated Fat',
            '${_formatNutrition(nutrition.saturatedFat)} g',
            percent: NutritionDailyValueService.saturatedFatPercent(
              nutrition.saturatedFat,
            ),
          ),
          _nutritionRow(
            'Trans Fat',
            '${_formatNutrition(nutrition.transFat)} g',
          ),
          _nutritionRow(
            'Cholesterol',
            '${_formatNutrition(nutrition.cholesterol)} mg',
            percent: NutritionDailyValueService.cholesterolPercent(
              nutrition.cholesterol,
            ),
          ),
          _nutritionRow(
            'Sodium',
            '${_formatNutrition(nutrition.sodium)} mg',
            percent: NutritionDailyValueService.sodiumPercent(
              nutrition.sodium,
            ),
          ),
        ],
      ),
    );
  }

  void _syncShowAllState() {
    _showAllNutrients =
        _vitaminsExpanded &&
        _mineralsExpanded &&
        _otherExpanded;
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required bool expanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _border.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: _secondary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icon,
                          color: _secondary,
                          size: 19,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: _text,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: _muted,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 15),
                  child: child,
                ),
                crossFadeState: expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 180),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // QUANTITY
  // ---------------------------------------------------------------------------

  Widget _buildQuantitySection() {
    final unitLabel = widget.food.servingUnit.trim().isEmpty
        ? 'serving'
        : widget.food.servingUnit.trim();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: _surface,
        border: Border(
          top: BorderSide(
            color: _border.withValues(alpha: 0.55),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quantity',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      _quantityButton(
                        icon: Icons.remove_rounded,
                        onPressed: _quantity > _quantityStep
                            ? () => _changeQuantity(-_quantityStep)
                            : _quantity > 0
                                ? () => _changeQuantity(-_quantityStep)
                                : null,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          controller: _quantityController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textAlign: TextAlign.center,
                          onChanged: _onQuantityChanged,
                          style: TextStyle(
                            color: _text,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _surfaceElevated,
                            suffixText: unitLabel,
                            suffixStyle: TextStyle(
                              color: _muted,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 11,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      _quantityButton(
                        icon: Icons.add_rounded,
                        onPressed: () => _changeQuantity(_quantityStep),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total amount',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '${_formatNumber(_effectiveGrams)} ${_isDirectAmount() ? _amountUnitLabel() : 'g'}',
                    style: TextStyle(
                      color: _text,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _isDirectAmount()
                        ? 'direct ${_amountUnitLabel()} input'
                        : '${_formatNumber(widget.food.servingSize)} g per $unitLabel',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 57,
                child: ElevatedButton.icon(
                  onPressed: _quantity > 0 ? _addFood : null,
                  icon: Icon(
                    Icons.add_rounded,
                    size: 24,
                  ),
                  label: const Text(
                    'ADD FOOD',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    disabledBackgroundColor: _border,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
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

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 38,
      height: 48,
      child: Material(
        color: _surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Icon(
            icon,
            color: onPressed == null
                ? _muted
                : _text,
            size: 20,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SHARED UI
  // ---------------------------------------------------------------------------

  Widget _sectionCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _border.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: _text,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _nutritionRow(
    String name,
    String value, {
    int? percent,
    bool emphasize = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: _text,
                fontSize: emphasize ? 15 : 14,
                fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (percent != null && percent >= 0)
            SizedBox(
              width: 52,
              child: Text(
                '$percent%',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _text,
              fontSize: emphasize ? 15 : 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
