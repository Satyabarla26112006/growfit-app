import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'food_detail_screen.dart';

import '../../data/food_data.dart';
import '../../models/food_model.dart';
import '../../services/daily_nutrition_service.dart';
import '../../services/food_log_service.dart';
import '../../services/food_log_builder_service.dart';

class FoodHomeScreen extends StatefulWidget {
  const FoodHomeScreen({
    super.key,
  });

  @override
  State<FoodHomeScreen> createState() =>
      _FoodHomeScreenState();
}

class _FoodHomeScreenState
    extends State<FoodHomeScreen> {
  String selectedMeal = 'Breakfast';
  String selectedCategory = 'All';
  String searchQuery = '';

  bool loading = true;

  final TextEditingController searchController =
      TextEditingController();

  static const List<String> meals = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
  ];

  static const Map<String, double> mealGoals = {
    'Breakfast': 500,
    'Lunch': 700,
    'Dinner': 700,
    'Snacks': 300,
  };

  static const Map<String, IconData> mealIcons = {
    'Breakfast': Icons.wb_sunny_rounded,
    'Lunch': Icons.light_mode_rounded,
    'Dinner': Icons.restaurant_rounded,
    'Snacks': Icons.nightlight_round,
  };


  static const List<String> categories = [
    'All',
    'Breakfast',
    'Rice & Grains',
    'Dal & Legumes',
    'Vegetables',
    'Fruits',
    'Dairy',
    'Protein',
    'Chicken',
    'Fish',
    'Meat',
    'Nuts & Seeds',
    'Beverages',
    'Biscuits',
    'Chocolates',
    'Sweets',
    'Snacks',
    'South Indian',
    'International',
  ];

  Map<String, Color> get _mealColors => {
    'Breakfast': _warning,
    'Lunch': _secondary,
    'Dinner': _primary,
    'Snacks': _primary.withValues(alpha: 0.78),
  };


  Color get _background => Theme.of(context).scaffoldBackgroundColor;

  Color get _surface => Theme.of(context).colorScheme.surface;

  Color get _surfaceElevated =>
      Theme.of(context).colorScheme.surfaceContainerHighest;

  Color get _text => Theme.of(context).colorScheme.onSurface;

  Color get _muted =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.58);

  Color get _onSurfaceVariant =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  Color get _primary => Theme.of(context).colorScheme.primary;
  Color get _secondary => Theme.of(context).colorScheme.secondary;
  Color get _warning => Theme.of(context).brightness == Brightness.dark
      ? AppColors.darkWarning
      : AppColors.lightWarning;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await FoodLogService.initialize();

    DailyNutritionService.resetToday();

    final logs =
        FoodLogService.getTodayLogs();

    for (final log in logs) {
      DailyNutritionService.addFoodLog(
        log,
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      loading = false;
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // MEAL CALORIES
  // ============================================================

  double mealCalories(
    String meal,
  ) {
    switch (meal.toLowerCase()) {
      case 'breakfast':
        return DailyNutritionService
            .breakfastCalories;

      case 'lunch':
        return DailyNutritionService
            .lunchCalories;

      case 'dinner':
        return DailyNutritionService
            .dinnerCalories;

      case 'snack':
      case 'snacks':
        return DailyNutritionService
            .snackCalories;

      default:
        return 0;
    }
  }

  // ============================================================
  // MEAL FOOD FILTER
  // ============================================================

  List<FoodModel> foodsForMeal(
    String meal,
  ) {
    final normalized =
        meal.toLowerCase();

    return FoodData.foods.where(
      (food) {
        final name =
            food.name.toLowerCase();

        final category =
            food.category.toLowerCase();

        if (normalized ==
            'breakfast') {
          return category ==
                  'breakfast' ||
              name.contains('idli') ||
              name.contains('dosa') ||
              name.contains('upma') ||
              name.contains('poha') ||
              name.contains('oats') ||
              name.contains('egg') ||
              name.contains('omelette') ||
              name.contains('bread') ||
              name.contains('toast') ||
              name.contains('pancake') ||
              name.contains('cornflakes') ||
              name.contains('muesli') ||
              name.contains('fruit bowl') ||
              name.contains('sprouts');
        }

        if (normalized ==
            'lunch') {
          return
              category ==
                      'rice & grains' ||
                  category ==
                      'dal & legumes' ||
                  category ==
                      'vegetables' ||
                  category ==
                      'protein' ||
                  category == 'fish' ||
                  category == 'meat' ||
                  name.contains('rice') ||
                  name.contains('biryani') ||
                  name.contains('pulao') ||
                  name.contains('roti') ||
                  name.contains('chapati') ||
                  name.contains('naan') ||
                  name.contains('dal') ||
                  name.contains('curry') ||
                  name.contains('chicken') ||
                  name.contains('fish') ||
                  name.contains('mutton') ||
                  name.contains('paneer');
        }

        if (normalized ==
            'dinner') {
          return
              category ==
                      'rice & grains' ||
                  category ==
                      'dal & legumes' ||
                  category ==
                      'vegetables' ||
                  category ==
                      'protein' ||
                  category == 'fish' ||
                  category == 'meat' ||
                  name.contains('rice') ||
                  name.contains('roti') ||
                  name.contains('chapati') ||
                  name.contains('naan') ||
                  name.contains('dal') ||
                  name.contains('curry') ||
                  name.contains('chicken') ||
                  name.contains('fish') ||
                  name.contains('mutton') ||
                  name.contains('paneer') ||
                  name.contains('tofu');
        }

        if (normalized ==
                'snacks' ||
            normalized ==
                'snack') {
          return
              category == 'snacks' ||
                  category ==
                      'biscuits' ||
                  category ==
                      'chocolates' ||
                  category == 'sweets' ||
                  category ==
                      'beverages' ||
                  category == 'fruits' ||
                  category ==
                      'nuts & seeds' ||
                  name.contains('samosa') ||
                  name.contains('kachori') ||
                  name.contains('pakora') ||
                  name.contains('chips') ||
                  name.contains('bhel') ||
                  name.contains('momos') ||
                  name.contains('biscuit') ||
                  name.contains('chocolate') ||
                  name.contains('tea') ||
                  name.contains('coffee') ||
                  name.contains('juice') ||
                  name.contains('shake');
        }

        return false;
      },
    ).toList();
  }

  // ============================================================
  // MEAL SEARCH
  // ============================================================

  List<FoodModel> mealSearchResults(
    String meal,
  ) {
    final foods =
        foodsForMeal(meal);

    final query =
        searchQuery
            .trim()
            .toLowerCase();

    if (query.isEmpty) {
      return foods;
    }

    return foods.where(
      (food) {
        return food.name
                .toLowerCase()
                .contains(query) ||
            food.category
                .toLowerCase()
                .contains(query);
      },
    ).toList();
  }

  // ============================================================
  // ALL FOOD SEARCH
  // ============================================================

  List<FoodModel> get filteredFoods {
    final query =
        searchQuery
            .trim()
            .toLowerCase();

    Iterable<FoodModel> result =
        FoodData.foods;

    if (selectedCategory !=
        'All') {
      result = result.where(
        (food) {
          return food.category
                  .toLowerCase() ==
              selectedCategory
                  .toLowerCase();
        },
      );
    }

    if (query.isNotEmpty) {
      result = result.where(
        (food) {
          return food.name
                  .toLowerCase()
                  .contains(query) ||
              food.category
                  .toLowerCase()
                  .contains(query);
        },
      );
    }

    return result.toList();
  }

  // ============================================================
  // RECENT FOODS
  // ============================================================

  List<FoodModel> get recentFoods {
    final logs =
        FoodLogService.allLogs.toList();

    logs.sort(
      (a, b) =>
          b.loggedAt.compareTo(
        a.loggedAt,
      ),
    );

    final result =
        <FoodModel>[];

    final seen =
        <String>{};

    for (final log in logs) {
      if (seen.contains(
        log.foodId,
      )) {
        continue;
      }

      final food =
          FoodData.findById(
        log.foodId,
      );

      if (food == null) {
        continue;
      }

      seen.add(
        log.foodId,
      );

      result.add(food);

      if (result.length >= 6) {
        break;
      }
    }

    return result;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    if (loading) {
      return Scaffold(
        backgroundColor: _background,
        body:
            Center(
          child:
              CircularProgressIndicator(
            color:
                _secondary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          _background,

      appBar: AppBar(
        backgroundColor: _background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        leading:
            IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          icon:
              Icon(
            Icons
                .arrow_back_rounded,
            color:
                _text,
          ),
        ),

        title:
            Text(
          'Food',
          style:
              TextStyle(
            color:
                _text,
            fontSize:
                22,
            fontWeight:
                FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        child:
            ListView(
          physics:
              const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(18, 4, 18, 30),

          children: [
            heroCard(),

            const SizedBox(
              height: 16,
            ),

            searchBar(),

            const SizedBox(
              height: 20,
            ),

            mealsSection(),

            const SizedBox(
              height: 20,
            ),

            recentSection(),

            const SizedBox(
              height: 20,
            ),

            browseSection(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget heroCard() {
    return Container(
      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          colors: [
            _surfaceElevated,
            _surface,
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        border:
            Border.all(
          color:
              _secondary.withValues(
            alpha: 0.3,
          ),
        ),
      ),

      child:
          Row(
        children: [
          Icon(
            Icons
                .restaurant_menu_rounded,
            color:
                _secondary,
            size:
                32,
          ),

          SizedBox(
            width:
                14,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Track Your Food',
                  style:
                      TextStyle(
                    color:
                        _text,
                    fontSize:
                        20,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                SizedBox(
                  height:
                      4,
                ),

                Text(
                  'Choose a meal and add food to your day.',
                  style:
                      TextStyle(
                    color:
                        _onSurfaceVariant,
                    fontSize:
                        11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget searchBar() {
    return TextField(
      controller:
          searchController,

      onChanged:
          (value) {
        setState(() {
          searchQuery =
              value;
        });
      },

      style:
          TextStyle(
        color:
            _text,
      ),

      decoration:
          InputDecoration(
        hintText:
            'Search food...',

        hintStyle:
            TextStyle(
          color:
              _onSurfaceVariant,
        ),

        prefixIcon:
            Icon(
          Icons.search_rounded,
          color:
              _secondary,
        ),

        suffixIcon:
            searchQuery.isEmpty
                ? null
                : IconButton(
                    onPressed:
                        () {
                      searchController
                          .clear();

                      setState(() {
                        searchQuery =
                            '';
                      });
                    },
                    icon:
                        Icon(
                      Icons.close_rounded,
                      color:
                          _onSurfaceVariant,
                    ),
                  ),

        filled:
            true,

        fillColor:
            _surface,

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }

  // ============================================================
  // MEALS
  // ============================================================

  Widget mealsSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          "Today's Meals",
          style:
              TextStyle(
            color:
                _text,
            fontSize:
                20,
            fontWeight:
                FontWeight.w800,
          ),
        ),

        const SizedBox(
          height:
              12,
        ),

        ...meals.map(
          mealCard,
        ),
      ],
    );
  }

  Widget mealCard(
    String meal,
  ) {
    final calories =
        mealCalories(meal);

    final goal =
        mealGoals[meal] ?? 0;

    final color =
        _mealColors[meal] ??
            _secondary;

    return GestureDetector(
      onTap: () async {
        selectedMeal =
            meal;

        searchQuery =
            '';

        searchController
            .clear();

        setState(() {});

        await showMealPicker(
          meal,
        );
      },

      child:
          Container(
        margin:
            const EdgeInsets.only(
          bottom:
              10,
        ),

        padding:
            const EdgeInsets.all(
          15,
        ),

        decoration:
            BoxDecoration(
          color:
              _surface,

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          border:
              Border.all(
            color:
                color.withValues(
              alpha: 0.22,
            ),
          ),
        ),

        child:
            Row(
          children: [
            Container(
              width:
                  44,

              height:
                  44,

              decoration:
                  BoxDecoration(
                color:
                    color.withValues(
                  alpha: 0.12,
                ),

                borderRadius:
                    BorderRadius.circular(
                  13,
                ),
              ),

              child:
                  Icon(
                mealIcons[meal],
                color:
                    color,
              ),
            ),

            const SizedBox(
              width:
                  12,
            ),

            Expanded(
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    meal,
                    style:
                        TextStyle(
                      color:
                          _text,
                      fontSize:
                          15,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const SizedBox(
                    height:
                        4,
                  ),

                  Text(
                    '${calories.round()} / ${goal.round()} kcal',
                    style:
                        TextStyle(
                      color:
                          _onSurfaceVariant,
                      fontSize:
                          10,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons
                  .add_circle_outline_rounded,
              color:
                  color,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // RECENT
  // ============================================================

  Widget recentSection() {
    final foods =
        recentFoods;

    if (foods.isEmpty) {
      return const SizedBox
          .shrink();
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          'Recent Foods',
          style:
              TextStyle(
            color:
                _text,
            fontSize:
                20,
            fontWeight:
                FontWeight.w800,
          ),
        ),

        const SizedBox(
          height:
              10,
        ),

        ...foods.map(
          (food) {
            return foodTile(
              food,
              selectedMeal,
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // BROWSE
  // ============================================================

  Widget browseSection() {
    final foods =
        filteredFoods;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          'Browse Foods',
          style:
              TextStyle(
            color:
                _text,
            fontSize:
                20,
            fontWeight:
                FontWeight.w800,
          ),
        ),

        const SizedBox(
          height:
              10,
        ),

        SizedBox(
          height:
              40,

          child:
              ListView.separated(
            scrollDirection:
                Axis.horizontal,

            itemCount:
                categories.length,

            separatorBuilder:
                (_, index) =>
                    const SizedBox(
              width:
                  8,
            ),

            itemBuilder:
                (
              context,
              index,
            ) {
              final category =
                  categories[index];

              final selected =
                  selectedCategory ==
                      category;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory =
                        category;
                  });
                },

                child:
                    Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal:
                        14,
                  ),

                  alignment:
                      Alignment.center,

                  decoration:
                      BoxDecoration(
                    color:
                        selected
                            ? _secondary.withValues(
                                alpha:
                                    0.18,
                              )
                            : _surface,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),

                    border:
                        Border.all(
                      color:
                          selected
                              ? _secondary
                              : _onSurfaceVariant,
                    ),
                  ),

                  child:
                      Text(
                    category,
                    style:
                        TextStyle(
                      color:
                          selected
                              ? _secondary
                              : _onSurfaceVariant,
                      fontSize:
                          10,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(
          height:
              14,
        ),

        if (foods.isEmpty)
          Padding(
            padding:
                EdgeInsets.all(
              30,
            ),

            child:
                Center(
              child:
                  Text(
                'No food found',
                style:
                    TextStyle(
                  color:
                      _onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...foods
              .take(50)
              .map(
            (food) {
              return foodTile(
                food,
                selectedMeal,
              );
            },
          ),
      ],
    );
  }

  // ============================================================
  // FOOD TILE
  // ============================================================

  Widget foodTile(
    FoodModel food,
    String meal,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FoodDetailScreen(
              food: food,
              meal: meal,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: _secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.restaurant_rounded, color: _secondary, size: 20),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: _text, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${food.calories.round()} kcal • ${food.servingSize.round()} ${food.servingUnit}',
                    style: TextStyle(color: _muted, fontSize: 10),
                  ),
                ],
              ),
            ),
            Icon(Icons.add_circle_outline_rounded, color: _secondary),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MEAL PICKER
  // ============================================================

  Future<void> showMealPicker(
    String meal,
  ) async {
    final selectedFood =
        await showModalBottomSheet<FoodModel>(
      context:
          context,

      backgroundColor:
          _surface,

      isScrollControlled:
          true,

      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top:
              Radius.circular(
            26,
          ),
        ),
      ),

      builder:
          (sheetContext) {
        final foods =
            mealSearchResults(
          meal,
        );

        return SafeArea(
          child:
              Padding(
            padding:
                const EdgeInsets
                    .fromLTRB(
              18,
              14,
              18,
              18,
            ),

            child:
                Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                Container(
                  width:
                      42,

                  height:
                      4,

                  decoration:
                      BoxDecoration(
                    color:
                        _onSurfaceVariant,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                ),

                const SizedBox(
                  height:
                      14,
                ),

                Row(
                  children: [
                    Expanded(
                      child:
                          Text(
                        'Add to $meal',
                        style:
                            TextStyle(
                          color:
                              _text,
                          fontSize:
                              19,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(
                          sheetContext,
                        );
                      },

                      icon:
                          Icon(
                        Icons
                            .close_rounded,
                        color:
                            _onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                Align(
                  alignment:
                      Alignment.centerLeft,

                  child:
                      Text(
                    '${foods.length} foods available',
                    style:
                        TextStyle(
                      color:
                          _onSurfaceVariant,
                      fontSize:
                          10,
                    ),
                  ),
                ),

                const SizedBox(
                  height:
                      10,
                ),

                SizedBox(
                  height:
                      MediaQuery.of(
                            sheetContext,
                          ).size.height *
                      0.62,

                  child:
                      ListView.builder(
                    itemCount:
                        foods.length,

                    itemBuilder:
                        (
                      context,
                      index,
                    ) {
                      final food =
                          foods[index];

                      return ListTile(
                        contentPadding:
                            const EdgeInsets
                                .symmetric(
                          vertical:
                              3,
                        ),

                        leading:
                            CircleAvatar(
                          backgroundColor:
                              _surfaceElevated,

                          child:
                              Icon(
                            Icons
                                .restaurant_rounded,
                            color:
                                _secondary,
                          ),
                        ),

                        title:
                            Text(
                          food.name,
                          style:
                              TextStyle(
                            color:
                                _text,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        subtitle:
                            Text(
                          '${food.calories.round()} kcal • '
                          '${food.servingSize.round()} ${food.servingUnit}',
                          style:
                              TextStyle(
                            color:
                                _onSurfaceVariant,
                            fontSize:
                                10,
                          ),
                        ),

                        trailing:
                            Icon(
                          Icons
                              .add_circle_outline_rounded,
                          color:
                              _secondary,
                        ),

                        onTap: () {
                          Navigator.pop(
                            sheetContext,
                            food,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedFood == null ||
        !mounted) {
      return;
    }

    await quantityDialog(
      selectedFood,
      meal,
    );
  }

  // ============================================================
  // QUANTITY
  // ============================================================

  Future<void> quantityDialog(
    FoodModel food,
    String meal,
  ) async {
    final controller =
        TextEditingController(
      text: food.servingUnit == 'piece'
          ? '1'
          : food.servingSize.toStringAsFixed(0),
    );

    double calories = food.calories;

    bool added = false;

    try {
      added = await showModalBottomSheet<bool>(
            context: context,
            backgroundColor:
                _surface,
            isScrollControlled: true,
            shape:
                const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            builder:
                (sheetContext) {
              return StatefulBuilder(
                builder: (
                  innerContext,
                  setSheetState,
                ) {
                  void updatePreview(
                    String value,
                  ) {
                    final quantity =
                        double.tryParse(
                              value.trim(),
                            ) ??
                            0;

                    final effective =
                        food.servingUnit == 'piece'
                            ? quantity *
                                food.servingSize
                            : quantity;

                    if (food.servingSize <= 0) {
                      return;
                    }

                    final multiplier =
                        effective /
                            food.servingSize;

                    setSheetState(() {
                      calories =
                          food.calories *
                              multiplier;
                    });
                  }

                  void addFood() {
                    final quantity =
                        double.tryParse(
                      controller.text.trim(),
                    );

                    if (quantity == null ||
                        quantity <= 0 ||
                        food.servingSize <= 0) {
                      return;
                    }

                    final now =
                        DateTime.now();

                    try {
                      final log =
                          FoodLogBuilderService.build(
                        food: food,
                        meal: meal,
                        quantityInput: quantity,
                        loggedAt: now,
                      );

                      FoodLogService.addLog(
                        log,
                      );

                      DailyNutritionService.addFoodLog(
                        log,
                      );

                      Navigator.of(
                        sheetContext,
                      ).pop(true);
                    } catch (_) {
                      // Keep the quantity sheet open
                      // if validation/build fails.
                    }
                  }

                  return SafeArea(
                    child:
                        Padding(
                      padding:
                          EdgeInsets.fromLTRB(
                        18,
                        15,
                        18,
                        MediaQuery.of(
                              sheetContext,
                            ).viewInsets.bottom +
                            20,
                      ),

                      child:
                          Column(
                        mainAxisSize:
                            MainAxisSize.min,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Center(
                            child:
                                Container(
                              width:
                                  42,
                              height:
                                  4,
                              decoration:
                                  BoxDecoration(
                                color:
                                    _onSurfaceVariant,
                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height:
                                16,
                          ),

                          Text(
                            food.name,
                            style:
                                TextStyle(
                              color:
                                  _text,
                              fontSize:
                                  21,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),

                          const SizedBox(
                            height:
                                4,
                          ),

                          Text(
                            'Adding to $meal',
                            style:
                                TextStyle(
                              color:
                                  _onSurfaceVariant,
                              fontSize:
                                  11,
                            ),
                          ),

                          const SizedBox(
                            height:
                                17,
                          ),

                          TextField(
                            controller:
                                controller,
                            onChanged:
                                updatePreview,
                            keyboardType:
                                const TextInputType
                                    .numberWithOptions(
                              decimal:
                                  true,
                            ),
                            style:
                                TextStyle(
                              color:
                                  _text,
                            ),
                            decoration:
                                InputDecoration(
                              labelText:
                                  food.servingUnit ==
                                          'piece'
                                      ? 'Quantity'
                                      : 'Amount',
                              labelStyle:
                                  TextStyle(
                                color:
                                    _onSurfaceVariant,
                              ),
                              suffixText:
                                  food.servingUnit,
                              filled:
                                  true,
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

                          const SizedBox(
                            height:
                                14,
                          ),

                          Container(
                            width:
                                double.infinity,
                            padding:
                                const EdgeInsets.all(
                              14,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  _surfaceElevated,
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                            ),
                            child:
                                Row(
                              children: [
                                Icon(
                                  Icons
                                      .local_fire_department_rounded,
                                  color:
                                      _warning,
                                ),

                                const SizedBox(
                                  width:
                                      10,
                                ),

                                Text(
                                  'Calories',
                                  style:
                                      TextStyle(
                                    color:
                                        _onSurfaceVariant,
                                    fontSize:
                                        12,
                                  ),
                                ),

                                const Spacer(),

                                Text(
                                  '${calories.round()} kcal',
                                  style:
                                      TextStyle(
                                    color:
                                        _text,
                                    fontSize:
                                        15,
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height:
                                18,
                          ),

                          SizedBox(
                            width:
                                double.infinity,
                            height:
                                54,
                            child:
                                ElevatedButton.icon(
                              onPressed:
                                  addFood,

                              icon:
                                  Icon(
                                Icons
                                    .add_rounded,
                              ),

                              label:
                                  Text(
                                'Add to $meal',
                                style:
                                    TextStyle(
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
                },
              );
            },
          ) ??
          false;
    } finally {
      controller.dispose();
    }

    // This executes after the modal route has
    // fully closed.
    if (!added ||
        !mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        backgroundColor:
            _surfaceElevated,
        content:
            Text(
          '${food.name} added to $meal',
          style:
              TextStyle(
            color:
                _text,
          ),
        ),
        duration:
            const Duration(
          seconds: 2,
        ),
      ),
    );
  }
}