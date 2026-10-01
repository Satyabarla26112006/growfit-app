import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

import '../../models/user_model.dart';
import '../../models/health_reading_model.dart';
import '../../models/food_log_model.dart';
import '../../services/daily_nutrition_service.dart';
import '../../services/food_log_service.dart';
import '../../services/health_reading_service.dart';
import '../../services/user_service.dart';
import '../../services/water_intake_service.dart';
import '../../services/workout_history_service.dart';
import '../food/food_home_screen.dart';
import '../progress/weight_entry_screen.dart';
import '../workout/workout_home_screen.dart';
import '../water/water_intake_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  UserModel? user;

  // ============================================================
  // THEME TOKENS
  // ============================================================

  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _surfaceElevated =>
      Theme.of(context).colorScheme.surfaceContainerHighest;
  Color get _primary => Theme.of(context).colorScheme.primary;
  Color get _secondary => Theme.of(context).colorScheme.secondary;
  Color get _success => Theme.of(context).brightness == Brightness.dark
      ? AppColors.darkSuccess
      : AppColors.lightSuccess;
  Color get _warning => Theme.of(context).brightness == Brightness.dark
      ? AppColors.darkWarning
      : AppColors.lightWarning;
  Color get _error => Theme.of(context).brightness == Brightness.dark
      ? AppColors.darkError
      : AppColors.lightError;
  Color get _onSurface => Theme.of(context).colorScheme.onSurface;
  Color get _onSurfaceVariant => Theme.of(context).colorScheme.onSurfaceVariant;


  String bloodPressure = '120/80';
  String bloodSugar = '98';

  late final AnimationController _grainController;

  // ============================================================
  // LIVE NUTRITION
  // ============================================================

  double get caloriesConsumed =>
      DailyNutritionService.totalCalories;

  double get proteinConsumed =>
      DailyNutritionService.totalProtein;

  double get carbsConsumed =>
      DailyNutritionService.totalCarbohydrates;

  double get fatsConsumed =>
      DailyNutritionService.totalFats;

  double get fiberConsumed =>
      DailyNutritionService.totalFiber;

  double get sugarConsumed =>
      DailyNutritionService.totalSugar;

  HealthReadingModel? get latestBloodPressure =>
      HealthReadingService.latestBloodPressure;

  HealthReadingModel? get latestBloodGlucose =>
      HealthReadingService.latestBloodGlucose;

  String get displayedBloodPressure {
    final reading = latestBloodPressure;

    if (reading == null) {
      return bloodPressure;
    }

    return '${reading.systolic!.round()}/${reading.diastolic!.round()}';
  }

  String get displayedBloodSugar {
    final reading = latestBloodGlucose;

    if (reading == null) {
      return bloodSugar;
    }

    return reading.glucoseMgDl!.round().toString();
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    user = UserService.getUser();

    _grainController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 22,
      ),
    )..repeat();

    WaterIntakeService.initialize();
    HealthReadingService.initialize();
    WorkoutHistoryService.initialize();
    _initializeNutrition();
  }

  Future<void> _initializeNutrition() async {
    await FoodLogService.initialize();
    await WorkoutHistoryService.initialize();

    DailyNutritionService.resetToday();

    final todayLogs =
        FoodLogService.getTodayLogs();

    for (final log in todayLogs) {
      DailyNutritionService.addFoodLog(
        log,
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      user = UserService.getUser();
    });
  }

  @override
  void dispose() {
    _grainController.dispose();
    super.dispose();
  }

  // ============================================================
  // REFRESH
  // ============================================================

  void _refreshHome() {
    if (!mounted) {
      return;
    }

    setState(() {
      user = UserService.getUser();
    });
  }

  // ============================================================
  // FOOD
  // ============================================================

  Future<void> _openFood() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            FoodHomeScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    await _initializeNutrition();
  }

  // ============================================================
  // WORKOUT
  // ============================================================

  Future<void> _openWorkout() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WorkoutHomeScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    _refreshHome();
  }

  // ============================================================
  // WATER
  // ============================================================

  Future<void> _openWater() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WaterIntakeScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ============================================================
  // WEIGHT
  // ============================================================

  Future<void> _openWeight() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WeightEntryScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    _refreshHome();
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  void _openNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          _surface,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder:
          (sheetContext) {
        return SafeArea(
          child:
              Padding(
            padding:
                EdgeInsets.fromLTRB(
              20,
              12,
              20,
              28,
            ),
            child:
                Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                _sheetHandle(),

                SizedBox(
                  height: 22,
                ),

                Row(
                  children: [
                    Icon(
                      Icons
                          .notifications_rounded,
                      color:
                          _secondary,
                      size: 24,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Notifications',
                      style:
                          TextStyle(
                        color:
                            _onSurface,
                        fontSize:
                            20,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 22,
                ),

                Container(
                  width:
                      double.infinity,
                  padding:
                      EdgeInsets.all(
                    22,
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
                          _onSurfaceVariant.withValues(
                        alpha: 0.35,
                      ),
                    ),
                  ),
                  child:
                      Column(
                    children: [
                      Icon(
                        Icons
                            .notifications_none_rounded,
                        color:
                            _onSurfaceVariant,
                        size: 42,
                      ),

                      SizedBox(
                        height: 12,
                      ),

                      Text(
                        'No new notifications',
                        style:
                            TextStyle(
                          color:
                              _onSurface,
                          fontSize:
                              15,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),

                      SizedBox(
                        height: 6,
                      ),

                      Text(
                        'We\'ll let you know when something important happens.',
                        textAlign:
                            TextAlign.center,
                        style:
                            TextStyle(
                          color:
                              _onSurfaceVariant,
                          fontSize:
                              11,
                          height:
                              1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  height: 48,
                  child:
                      ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        sheetContext,
                      );
                    },
                    child:
                        Text(
                      'Close',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // QUICK ADD
  // ============================================================



  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final currentUser = user;

    if (currentUser == null) {
      return _noUserScreen();
    }

    final calorieGoal =
        currentUser.targetCalories ?? 0;

    final proteinGoal =
        currentUser.targetProtein ?? 0;

    final carbsGoal =
        currentUser.targetCarbs ?? 0;

    final fatsGoal =
        currentUser.targetFats ?? 0;

    final calorieProgress =
        _progressValue(
      caloriesConsumed,
      calorieGoal,
    );

    final proteinProgress =
        _progressValue(
      proteinConsumed,
      proteinGoal,
    );

    final carbsProgress =
        _progressValue(
      carbsConsumed,
      carbsGoal,
    );

    final fatsProgress =
        _progressValue(
      fatsConsumed,
      fatsGoal,
    );

    const fiberGoal =
        30.0;

    const sugarGoal =
        50.0;

    final fiberProgress =
        _progressValue(
      fiberConsumed,
      fiberGoal,
    );

    final sugarProgress =
        _progressValue(
      sugarConsumed,
      sugarGoal,
    );

    final remainingCalories =
        (calorieGoal -
                caloriesConsumed)
            .clamp(
          0.0,
          double.infinity,
        );

    return Scaffold(
      backgroundColor:
          _background,

      body:
          SafeArea(
        bottom:
            false,
        child:
            Stack(
          children: [
            SingleChildScrollView(
              physics:
                  BouncingScrollPhysics(),
              padding:
                  EdgeInsets.fromLTRB(
                20,
                16,
                20,
                28,
              ),
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _header(
                    currentUser,
                  ),

                  SizedBox(
                    height: 18,
                  ),

                  _todayCard(
                    goal:
                        calorieGoal,
                    consumed:
                        caloriesConsumed,
                    remaining:
                        remainingCalories,
                    exercise:
                        _todayWorkoutCalories(),
                    progress:
                        calorieProgress,
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  _macroDashboard(
                    proteinGoal,
                    carbsGoal,
                    fatsGoal,
                    proteinProgress,
                    carbsProgress,
                    fatsProgress,
                    fiberProgress,
                    sugarProgress,
                    fiberGoal,
                    sugarGoal,
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  _dailyInsight(
                    calorieGoal:
                        calorieGoal,
                    proteinGoal:
                        proteinGoal,
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  _todayMeals(),

                  SizedBox(
                    height: 16,
                  ),

                  _healthCheck(),

                  SizedBox(
                    height: 16,
                  ),

                  _goalSummary(
                    currentUser,
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  _quickActions(),

                  SizedBox(
                    height: 16,
                  ),

                  _waterCard(),

                  SizedBox(
                    height: 16,
                  ),

                  _activitySummary(
                    currentUser,
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  _grainArea(),

                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY USER
  // ============================================================

  Widget _noUserScreen() {
    return Scaffold(
      backgroundColor:
          _background,
      body:
          Center(
        child:
            Text(
          'No user profile found.',
          style:
              TextStyle(
            color:
                _onSurface,
            fontSize:
                16,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header(
    UserModel currentUser,
  ) {
    return Row(
      children: [
        _topButton(
          icon:
              Icons.menu_rounded,
          onTap:
              () {},
        ),

        SizedBox(
          width: 13,
        ),

        Expanded(
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning,',
                style:
                    TextStyle(
                  color:
                      _onSurfaceVariant,
                  fontSize:
                      13,
                ),
              ),

              SizedBox(
                height: 2,
              ),

              Text(
                '${currentUser.name} 👋',
                maxLines:
                    1,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    TextStyle(
                  color:
                      _onSurface,
                  fontSize:
                      25,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),
        ),

        Container(
          width:
              56,
          height:
              56,
          decoration:
              BoxDecoration(
            color:
                _surface,
            shape:
                BoxShape.circle,
            border:
                Border.all(
              color:
                  _secondary.withValues(
                alpha: 0.45,
              ),
            ),
          ),
          child:
              IconButton(
            onPressed:
                _openNotifications,
            icon:
                Icon(
              Icons
                  .notifications_none_rounded,
              color:
                  _onSurface,
              size:
                  27,
            ),
          ),
        ),
      ],
    );
  }

  Widget _topButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width:
          56,
      height:
          56,
      decoration:
          BoxDecoration(
        color:
            _surfaceElevated,
        borderRadius:
            BorderRadius.circular(
          17,
        ),
        border:
            Border.all(
          color:
              _secondary.withValues(
            alpha: 0.45,
          ),
        ),
      ),
      child:
          IconButton(
        onPressed:
            onTap,
        icon:
            Icon(
          icon,
          color:
              _onSurface,
          size:
              27,
        ),
      ),
    );
  }

  // ============================================================
  // TODAY'S WORKOUT CALORIES
  // ============================================================

  double _todayWorkoutCalories() {
    final today = DateTime.now();

    return WorkoutHistoryService.history
        .where((workout) {
          final date = workout.completedAt;
          return date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;
        })
        .fold<double>(
          0,
          (total, workout) =>
              total + workout.estimatedCalories,
        );
  }

  // ============================================================
  // TODAY CARD
  // ============================================================

  Widget _todayCard({
    required double goal,
    required double consumed,
    required double remaining,
    required double exercise,
    required double progress,
  }) {
    return Container(
      width:
          double.infinity,
      padding:
          EdgeInsets.all(
        18,
      ),
      decoration:
          BoxDecoration(
        color:
            _surface,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        border:
            Border.all(
          color:
              _secondary.withValues(
            alpha: 0.45,
          ),
        ),
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'TODAY',
            style:
                TextStyle(
              color:
                  _secondary,
              fontSize:
                  12,
              fontWeight:
                  FontWeight.w800,
              letterSpacing:
                  1.6,
            ),
          ),

          SizedBox(
            height: 13,
          ),

          Row(
            children: [
              SizedBox(
                width:
                    220,
                height:
                    220,
                child:
                    _calorieRing(
                  progress,
                  consumed,
                  remaining,
                ),
              ),

              SizedBox(
                width:
                    8,
              ),

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _todayMetric(
                      icon:
                          Icons
                              .flag_rounded,
                      color:
                          _secondary,
                      label:
                          'Goal',
                      value:
                          '${goal.toStringAsFixed(0)} kcal',
                    ),

                    SizedBox(
                      height: 24,
                    ),

                    _todayMetric(
                      icon:
                          Icons
                              .local_fire_department_rounded,
                      color:
                          _warning,
                      label:
                          'Food',
                      value:
                          '${consumed.toStringAsFixed(0)} kcal',
                    ),

                    SizedBox(
                      height: 24,
                    ),

                    _todayMetric(
                      icon:
                          Icons
                              .directions_run_rounded,
                      color:
                          _success,
                      label:
                          'Exercise',
                      value:
                          '+${exercise.toStringAsFixed(0)} kcal',
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

  // ============================================================
  // CALORIE RING
  // ============================================================

  Widget _calorieRing(
    double progress,
    double consumed,
    double remaining,
  ) {
    return CustomPaint(
      painter:
          _GradientRingPainter(
        progress:
            progress,
        strokeWidth:
            14,
        backgroundColor:
            _onSurface.withValues(alpha: 0.10),
        startColor:
            _secondary,
        middleColor:
            _primary,
        endColor:
            _secondary,
      ),
      child:
          Center(
        child:
            Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Text(
              'TOTAL CALORIES',
              style:
                  TextStyle(
                color:
                    _onSurfaceVariant,
                fontSize:
                    10,
                fontWeight:
                    FontWeight.w800,
                letterSpacing:
                    0.7,
              ),
            ),

            SizedBox(
              height: 7,
            ),

            Text(
              consumed.toStringAsFixed(
                0,
              ),
              style:
                  TextStyle(
                color:
                    _onSurface,
                fontSize:
                    38,
                fontWeight:
                    FontWeight.w900,
              ),
            ),

            Text(
              'kcal consumed',
              style:
                  TextStyle(
                color:
                    _onSurfaceVariant,
                fontSize:
                    10,
              ),
            ),

            Container(
              width:
                  95,
              margin:
                  EdgeInsets
                      .symmetric(
                vertical:
                    9,
              ),
              child:
                  Divider(
                color:
                    _onSurfaceVariant,
                height:
                    1,
              ),
            ),

            Text(
              'REMAINING',
              style:
                  TextStyle(
                color:
                    _primary,
                fontSize:
                    10,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            SizedBox(
              height:
                  3,
            ),

            Text(
              remaining.toStringAsFixed(
                0,
              ),
              style:
                  TextStyle(
                color:
                    _primary,
                fontSize:
                    28,
                fontWeight:
                    FontWeight.w900,
              ),
            ),

            Text(
              'kcal',
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
    );
  }

  // ============================================================
  // METRIC
  // ============================================================

  Widget _todayMetric({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color:
              color,
          size:
              25,
        ),

        SizedBox(
          width:
              10,
        ),

        Expanded(
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    TextStyle(
                  color:
                      _onSurfaceVariant,
                  fontSize:
                      12,
                ),
              ),

              SizedBox(
                height:
                    3,
              ),

              Text(
                value,
                maxLines:
                    1,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    TextStyle(
                  color:
                      _onSurface,
                  fontSize:
                      14,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MACROS
  // ============================================================

  Widget _macroDashboard(
    double proteinGoal,
    double carbsGoal,
    double fatsGoal,
    double proteinProgress,
    double carbsProgress,
    double fatsProgress,
    double fiberProgress,
    double sugarProgress,
    double fiberGoal,
    double sugarGoal,
  ) {
    return Container(
      width:
          double.infinity,
      padding:
          EdgeInsets.fromLTRB(
        16,
        17,
        16,
        18,
      ),
      decoration:
          BoxDecoration(
        color:
            _surface,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),
      child:
          Column(
        children: [
          Row(
            children: [
              Expanded(
                child:
                    _macroItem(
                  title:
                      'Protein',
                  consumed:
                      proteinConsumed,
                  goal:
                      proteinGoal,
                  progress:
                      proteinProgress,
                  icon:
                      Icons
                          .fitness_center_rounded,
                  color:
                      _primary,
                ),
              ),

              _verticalDivider(
                120,
              ),

              Expanded(
                child:
                    _macroItem(
                  title:
                      'Carbs',
                  consumed:
                      carbsConsumed,
                  goal:
                      carbsGoal,
                  progress:
                      carbsProgress,
                  icon:
                      Icons
                          .grain_rounded,
                  color:
                      _primary,
                ),
              ),

              _verticalDivider(
                120,
              ),

              Expanded(
                child:
                    _macroItem(
                  title:
                      'Fats',
                  consumed:
                      fatsConsumed,
                  goal:
                      fatsGoal,
                  progress:
                      fatsProgress,
                  icon:
                      Icons
                          .water_drop_rounded,
                  color:
                      _primary,
                ),
              ),
            ],
          ),

          SizedBox(
            height:
                10,
          ),

          Divider(
            color:
                _onSurfaceVariant,
            height:
                1,
          ),

          SizedBox(
            height:
                10,
          ),

          Row(
            children: [
              Expanded(
                child:
                    _macroItem(
                  title:
                      'Fiber',
                  consumed:
                      fiberConsumed,
                  goal:
                      fiberGoal,
                  progress:
                      fiberProgress,
                  icon:
                      Icons
                          .eco_rounded,
                  color:
                      _success,
                ),
              ),

              _verticalDivider(
                112,
              ),

              Expanded(
                child:
                    _macroItem(
                  title:
                      'Sugar',
                  consumed:
                      sugarConsumed,
                  goal:
                      sugarGoal,
                  progress:
                      sugarProgress,
                  icon:
                      Icons
                          .local_cafe_rounded,
                  color:
                      _secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroItem({
    required String title,
    required double consumed,
    required double goal,
    required double progress,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          title,
          style:
              TextStyle(
            color:
                _onSurface,
            fontSize:
                13,
            fontWeight:
                FontWeight.w600,
          ),
        ),

        SizedBox(
          height:
              5,
        ),

        Text(
          '${consumed.toStringAsFixed(0)}g / ${goal.toStringAsFixed(0)}g',
          style:
              TextStyle(
            color:
                _onSurface,
            fontSize:
                11,
            fontWeight:
                FontWeight.w800,
          ),
        ),

        SizedBox(
          height:
              9,
        ),

        SizedBox(
          width:
              68,
          height:
              68,
          child:
              Stack(
            alignment:
                Alignment.center,
            children: [
              SizedBox(
                width:
                    68,
                height:
                    68,
                child:
                    CircularProgressIndicator(
                  value:
                      1,
                  strokeWidth:
                      7,
                  backgroundColor:
                      Colors.transparent,
                  valueColor:
                      AlwaysStoppedAnimation<
                          Color>(
                    _surfaceElevated,
                  ),
                ),
              ),

              SizedBox(
                width:
                    68,
                height:
                    68,
                child:
                    CircularProgressIndicator(
                  value:
                      progress,
                  strokeWidth:
                      7,
                  strokeCap:
                      StrokeCap.round,
                  backgroundColor:
                      Colors.transparent,
                  valueColor:
                      AlwaysStoppedAnimation<
                          Color>(
                    color,
                  ),
                ),
              ),

              Icon(
                icon,
                color:
                    color,
                size:
                    17,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DAILY INSIGHT
  // ============================================================

  Widget _dailyInsight({
    required double calorieGoal,
    required double proteinGoal,
  }) {
    String title;
    String message;
    IconData icon;
    Color accent;

    if (calorieGoal > 0 &&
        caloriesConsumed >= calorieGoal) {
      title = 'Calorie target reached';
      message =
          'You have reached today\'s calorie target. Focus on hydration, '
          'balanced meals and your planned activity for the rest of the day.';
      icon = Icons.flag_rounded;
      accent = _primary;
    } else if (proteinGoal > 0 &&
        proteinConsumed < proteinGoal * 0.70) {
      final remaining =
          (proteinGoal - proteinConsumed)
              .clamp(0.0, double.infinity);

      title = 'Protein is your next priority';
      message =
          'You still have about ${remaining.toStringAsFixed(0)} g of '
          'protein left to reach your target. Add a balanced protein source '
          'to your next meal.';
      icon = Icons.fitness_center_rounded;
      accent = _secondary;
    } else if (fiberConsumed < 15) {
      title = 'Give your fiber a boost';
      message =
          'Your fiber intake is still early today. Add fruit, vegetables, '
          'legumes or whole grains to your next meal.';
      icon = Icons.eco_rounded;
      accent = _success;
    } else if (latestBloodPressure != null) {
      final classification =
          HealthReadingService.classifyBloodPressure(
        latestBloodPressure!,
      );

      title = 'Health reading updated';
      message =
          'Your latest blood pressure is '
          '$displayedBloodPressure. '
          'Check Progress for your full health and nutrition picture.';
      icon = Icons.monitor_heart_rounded;
      accent = classification.needsAttention
          ? _warning
          : _success;
    } else {
      title = 'Build a strong day';
      message =
          'Log your meals, stay hydrated and keep moving. GrowFit will '
          'use your activity and nutrition data to keep your progress on track.';
      icon = Icons.auto_awesome_rounded;
      accent = _secondary;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _surfaceElevated,
            _surface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: accent,
              size: 22,
            ),
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'TODAY\'S INSIGHT',
                  style: TextStyle(
                    color: _onSurfaceVariant,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: _onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: _onSurfaceVariant,
                    fontSize: 10,
                    height: 1.45,
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
  // TODAY'S MEALS
  // ============================================================

  Widget _todayMeals() {
    final logs =
        List<FoodLogModel>.from(
      FoodLogService.getTodayLogs(),
    )..sort(
        (a, b) =>
            b.loggedAt.compareTo(
          a.loggedAt,
        ),
      );

    final mealOrder = [
      'Breakfast',
      'Lunch',
      'Dinner',
      'Snacks',
    ];

    final mealCalories = <String, double>{
      for (final meal in mealOrder) meal: 0,
    };

    for (final log in logs) {
      final meal = _mealLabel(log.mealType);
      mealCalories[meal] =
          (mealCalories[meal] ?? 0) +
              log.calories;
    }

    final visibleLogs = logs.take(4).toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _secondary.withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _secondary.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.restaurant_rounded,
                  color: _secondary,
                  size: 21,
                ),
              ),
              SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Meals",
                      style: TextStyle(
                        color: _onSurface,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'A quick view of what you have logged today.',
                      style: TextStyle(
                        color: _onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              if (logs.isNotEmpty)
                Text(
                  '${logs.length} logged',
                  style: TextStyle(
                    color: _primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
            ],
          ),

          SizedBox(height: 15),

          if (logs.isEmpty)
            _todayMealsEmpty()
          else ...[
            SizedBox(
              height: 54,
              child: Row(
                children: mealOrder.map((meal) {
                  final calories =
                      mealCalories[meal] ?? 0;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 7),
                      child: _mealMiniStat(
                        label: _mealShortLabel(meal),
                        calories: calories,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 14),

            ...visibleLogs.map(_foodLogRow),

            if (logs.length > visibleLogs.length)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  '+ ${logs.length - visibleLogs.length} more food entr${logs.length - visibleLogs.length == 1 ? 'y' : 'ies'} today',
                  style: TextStyle(
                    color: _onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _todayMealsEmpty() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            Icons.add_circle_outline_rounded,
            color: _primary,
            size: 21,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'No food logged yet today. Add your first meal to start tracking.',
              style: TextStyle(
                color: _onSurfaceVariant,
                fontSize: 11,
                height: 1.35,
              ),
            ),
          ),
          GestureDetector(
            onTap: _openFood,
            child: Text(
              'ADD',
              style: TextStyle(
                color: _primary,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mealMiniStat({
    required String label,
    required double calories,
  }) {
    final hasCalories = calories > 0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _onSurfaceVariant,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3),
          Text(
            hasCalories
                ? '${calories.round()} kcal'
                : '—',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _onSurface,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _foodLogRow(
    FoodLogModel log,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _primary.withValues(
                alpha: 0.08,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              color: _primary,
              size: 17,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  log.foodName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '${_mealShortLabel(_mealLabel(log.mealType))} • ${_quantityText(log)}',
                  style: TextStyle(
                    color: _onSurfaceVariant,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            '${log.calories.round()} kcal',
            style: TextStyle(
              color: _onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  String _mealLabel(String mealType) {
    final value = mealType.trim().toLowerCase();
    switch (value) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      case 'snack':
      case 'snacks':
        return 'Snacks';
      default:
        return 'Snacks';
    }
  }

  String _mealShortLabel(String meal) {
    switch (meal) {
      case 'Breakfast':
        return 'BREAKFAST';
      case 'Lunch':
        return 'LUNCH';
      case 'Dinner':
        return 'DINNER';
      default:
        return 'SNACKS';
    }
  }

  String _quantityText(FoodLogModel log) {
    final quantity =
        log.quantity % 1 == 0
            ? log.quantity.toStringAsFixed(0)
            : log.quantity.toStringAsFixed(1);
    return '$quantity ${log.servingUnit}';
  }

  // ============================================================
  // HEALTH CHECK
  // ============================================================

  Widget _healthCheck() {
    return Container(
      width:
          double.infinity,
      padding:
          EdgeInsets.all(
        18,
      ),
      decoration:
          BoxDecoration(
        color:
            _surface,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'HEALTH CHECK',
            style:
                TextStyle(
              color:
                  _secondary,
              fontSize:
                  12,
              fontWeight:
                  FontWeight.w800,
              letterSpacing:
                  1.5,
            ),
          ),

          SizedBox(
            height:
                8,
          ),

          Text(
            'Enter your latest readings',
            style:
                TextStyle(
              color:
                  _onSurfaceVariant,
              fontSize:
                  12,
            ),
          ),

          SizedBox(
            height:
                15,
          ),

          Row(
            children: [
              Expanded(
                child:
                    _healthCard(
                  icon:
                      Icons
                          .favorite_rounded,
                  color:
                      _secondary,
                  title:
                      'Blood Pressure',
                  value:
                      displayedBloodPressure,
                  unit:
                      'mmHg',
                  buttonText:
                      'Enter BP',
                  status:
                      _bloodPressureStatus(),
                  statusColor:
                      _bloodPressureStatusColor(),
                  onTap:
                      _editBloodPressure,
                ),
              ),

              SizedBox(
                width:
                    12,
              ),

              Expanded(
                child:
                    _healthCard(
                  icon:
                      Icons
                          .water_drop_rounded,
                  color:
                      _primary,
                  title:
                      'Blood Sugar',
                  value:
                      displayedBloodSugar,
                  unit:
                      'mg/dL',
                  buttonText:
                      'Enter level',
                  status:
                      _bloodSugarStatus(),
                  statusColor:
                      _bloodSugarStatusColor(),
                  onTap:
                      _editBloodSugar,
                ),
              ),
            ],
          ),

          SizedBox(
            height:
                14,
          ),

          _bmiHealthCard(),
        ],
      ),
    );
  }

  Widget _healthCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String unit,
    required String buttonText,
    required String status,
    required Color statusColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding:
          EdgeInsets.all(
        14,
      ),
      decoration:
          BoxDecoration(
        color:
            _surfaceElevated,
        borderRadius:
            BorderRadius.circular(
          19,
        ),
        border:
            Border.all(
          color:
              color.withValues(
            alpha:
                0.24,
          ),
        ),
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color:
                    color,
                size:
                    20,
              ),

              SizedBox(
                width:
                    7,
              ),

              Expanded(
                child:
                    Text(
                  title,
                  maxLines:
                      1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      TextStyle(
                    color:
                        _onSurface,
                    fontSize:
                        11,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height:
                11,
          ),

          Container(
            width:
                double.infinity,
            padding:
                EdgeInsets
                    .symmetric(
              horizontal:
                  12,
              vertical:
                  13,
            ),
            decoration:
                BoxDecoration(
              color:
                  _surfaceElevated,
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
              border:
                  Border.all(
                color:
                    color.withValues(
                  alpha:
                      0.18,
                ),
              ),
            ),
            child:
                Text(
              value,
              style:
                  TextStyle(
                color:
                    _onSurface,
                fontSize:
                    16,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),

          SizedBox(
            height:
                6,
          ),

          Text(
            unit,
            style:
                TextStyle(
              color:
                  _onSurfaceVariant,
              fontSize:
                  9,
            ),
          ),

          SizedBox(
            height:
                8,
          ),

          Row(
            children: [
              Container(
                width:
                    7,
                height:
                    7,
                decoration:
                    BoxDecoration(
                  color:
                      statusColor,
                  shape:
                      BoxShape.circle,
                ),
              ),

              SizedBox(
                width:
                    6,
              ),

              Text(
                status,
                style:
                    TextStyle(
                  color:
                      statusColor,
                  fontSize:
                      10,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),

          SizedBox(
            height:
                7,
          ),

          SizedBox(
            width:
                double.infinity,
            height:
                32,
            child:
                OutlinedButton(
              onPressed:
                  onTap,
              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    color,
                side:
                    BorderSide(
                  color:
                      color.withValues(
                    alpha:
                        0.65,
                  ),
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
                padding:
                    EdgeInsets.zero,
              ),
              child:
                  Text(
                buttonText,
                style:
                    TextStyle(
                  fontSize:
                      10,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BLOOD PRESSURE STATUS
  // ============================================================

  String _bloodPressureStatus() {
    final parts =
        bloodPressure.split('/');

    if (parts.length != 2) {
      return 'Enter reading';
    }

    final systolic =
        double.tryParse(
      parts[0].trim(),
    );

    final diastolic =
        double.tryParse(
      parts[1].trim(),
    );

    if (systolic == null ||
        diastolic == null) {
      return 'Enter reading';
    }

    // Simple adult reference classification for UI purposes:
    // Low: systolic < 90 OR diastolic < 60
    // Normal: systolic < 130 AND diastolic < 80
    // High: systolic >= 130 OR diastolic >= 80
    if (systolic < 90 ||
        diastolic < 60) {
      return 'Low';
    }

    if (systolic < 130 &&
        diastolic < 80) {
      return 'Normal';
    }

    return 'High';
  }

  Color _bloodPressureStatusColor() {
    switch (_bloodPressureStatus()) {
      case 'Low':
        return _primary;

      case 'High':
        return _error;

      case 'Normal':
        return _success;

      default:
        return _onSurfaceVariant;
    }
  }

  // ============================================================
  // BLOOD SUGAR STATUS
  // ============================================================

  String _bloodSugarStatus() {
    final value =
        double.tryParse(
      bloodSugar.trim(),
    );

    if (value == null) {
      return 'Enter reading';
    }

    // UI reference assumes a fasting glucose reading.
    // Low: < 70 mg/dL
    // Normal: 70-99 mg/dL
    // High: >= 100 mg/dL
    if (value < 70) {
      return 'Low';
    }

    if (value < 100) {
      return 'Normal';
    }

    return 'High';
  }

  Color _bloodSugarStatusColor() {
    switch (_bloodSugarStatus()) {
      case 'Low':
        return _primary;

      case 'High':
        return _error;

      case 'Normal':
        return _success;

      default:
        return _onSurfaceVariant;
    }
  }

  // ============================================================
  // BMI
  // ============================================================

  Widget _bmiHealthCard() {
    final currentUser =
        user;

    if (currentUser == null) {
      return SizedBox();
    }

    return Container(
      width:
          double.infinity,
      padding:
          EdgeInsets.all(
        16,
      ),
      decoration:
          BoxDecoration(
        color:
            _surfaceElevated,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border:
            Border.all(
          color:
              _primary.withValues(
            alpha:
                0.20,
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
                  _primary.withValues(
                alpha:
                    0.10,
              ),
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
            ),
            child:
                Icon(
              Icons
                  .monitor_heart_rounded,
              color:
                  _primary,
              size:
                  23,
            ),
          ),

          SizedBox(
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
                  'BMI',
                  style:
                      TextStyle(
                    color:
                        _onSurfaceVariant,
                    fontSize:
                        11,
                  ),
                ),

                SizedBox(
                  height:
                      4,
                ),

                Text(
                  currentUser.bmi >
                          0
                      ? currentUser.bmi
                          .toStringAsFixed(
                          1,
                        )
                      : '--',
                  style:
                      TextStyle(
                    color:
                        _onSurface,
                    fontSize:
                        20,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                EdgeInsets
                    .symmetric(
              horizontal:
                  10,
              vertical:
                  7,
            ),
            decoration:
                BoxDecoration(
              color:
                  _success.withValues(
                alpha:
                    0.10,
              ),
              borderRadius:
                  BorderRadius.circular(
                10,
              ),
            ),
            child:
                Text(
              currentUser
                  .bmiCategory,
              style:
                  TextStyle(
                color:
                    _success,
                fontSize:
                    10,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BLOOD PRESSURE / BLOOD SUGAR — FIXED
  //
  // Root cause of the crash:
  // Previously a TextEditingController was created as a local
  // variable, handed to a TextField inside showDialog(), and then
  // manually disposed right after the dialog closed. If the field
  // had focus and Android's text-selection toolbar/handles overlay
  // was still attached (a dependent of the dialog's Theme/Overlay
  // InheritedWidgets) at the moment of teardown, Flutter's element
  // disposal assertion `_dependents.isEmpty` failed.
  //
  // Fix: the controller now lives inside a dedicated StatefulWidget
  // (_HealthInputDialog) whose own State creates it in initState()
  // and disposes it in dispose(). This ties the controller's
  // lifecycle directly to the dialog element's lifecycle instead of
  // an external variable, and we explicitly unfocus before popping
  // so no selection overlay is left dangling.
  // ============================================================

  Future<void> _editBloodPressure() async {
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return _HealthInputDialog(
          title: 'Blood Pressure',
          initialValue: displayedBloodPressure,
          hintText: 'Example: 120/80',
        );
      },
    );

    if (!mounted || result == null || result.isEmpty) {
      return;
    }

    final parts = result.split('/');

    if (parts.length != 2) {
      _showHomeMessage(
        'Enter blood pressure as systolic/diastolic, for example 120/80.',
      );
      return;
    }

    final systolic =
        double.tryParse(parts[0].trim());

    final diastolic =
        double.tryParse(parts[1].trim());

    if (systolic == null ||
        diastolic == null ||
        systolic <= 0 ||
        diastolic <= 0) {
      _showHomeMessage(
        'Enter valid blood pressure values.',
      );
      return;
    }

    try {
      await HealthReadingService.add(
        HealthReadingModel(
          id:
              'home_bp_${DateTime.now().microsecondsSinceEpoch}',
          recordedAt: DateTime.now(),
          type:
              HealthReadingType.bloodPressure,
          systolic: systolic,
          diastolic: diastolic,
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        bloodPressure =
            '${systolic.round()}/${diastolic.round()}';
      });
    } on ArgumentError catch (error) {
      _showHomeMessage(
        error.message?.toString() ??
            'Could not save blood pressure.',
      );
    }
  }

  Future<void> _editBloodSugar() async {
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return _HealthInputDialog(
          title: 'Blood Sugar',
          initialValue: displayedBloodSugar,
          hintText: 'Example: 98',
          keyboardType:
              TextInputType.numberWithOptions(decimal: true),
        );
      },
    );

    if (!mounted || result == null || result.isEmpty) {
      return;
    }

    final glucose =
        double.tryParse(result.trim());

    if (glucose == null || glucose <= 0) {
      _showHomeMessage(
        'Enter a valid blood glucose value.',
      );
      return;
    }

    try {
      await HealthReadingService.add(
        HealthReadingModel(
          id:
              'home_glucose_${DateTime.now().microsecondsSinceEpoch}',
          recordedAt: DateTime.now(),
          type:
              HealthReadingType.bloodGlucose,
          glucoseMgDl: glucose,
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        bloodSugar =
            glucose.round().toString();
      });
    } on ArgumentError catch (error) {
      _showHomeMessage(
        error.message?.toString() ??
            'Could not save blood glucose.',
      );
    }
  }

  void _showHomeMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration:
            Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // WEIGHT GOAL
  // ============================================================

  Widget _goalSummary(
    UserModel currentUser,
  ) {
    final current =
        currentUser.currentWeight;

    final goal =
        currentUser.goalWeight;

    final difference =
        (goal - current).abs();

    return Container(
      width:
          double.infinity,
      padding:
          EdgeInsets.all(
        18,
      ),
      decoration:
          BoxDecoration(
        color:
            _surface,
        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'WEIGHT GOAL',
            style:
                TextStyle(
              color:
                  _secondary,
              fontSize:
                  11,
              fontWeight:
                  FontWeight.w800,
              letterSpacing:
                  1.4,
            ),
          ),

          SizedBox(
            height:
                13,
          ),

          Row(
            children: [
              Expanded(
                child:
                    _weightValue(
                  'Current',
                  current,
                ),
              ),

              Container(
                width:
                    1,
                height:
                    45,
                color:
                    _onSurfaceVariant,
              ),

              Expanded(
                child:
                    _weightValue(
                  'Goal',
                  goal,
                ),
              ),
            ],
          ),

          SizedBox(
            height:
                14,
          ),

          Text(
            difference == 0
                ? 'You reached your goal!'
                : '${difference.toStringAsFixed(1)} kg to your goal',
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
    );
  }

  Widget _weightValue(
    String title,
    double value,
  ) {
    return Column(
      children: [
        Text(
          title,
          style:
              TextStyle(
            color:
                _onSurfaceVariant,
            fontSize:
                10,
          ),
        ),

        SizedBox(
          height:
              5,
        ),

        Text(
          '${value.toStringAsFixed(1)} kg',
          style:
              TextStyle(
            color:
                _onSurface,
            fontSize:
                18,
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
          child:
              _quickActionCard(
            icon:
                Icons
                    .restaurant_menu_rounded,
            label:
                'Food',
            color:
                _success,
            onTap:
                _openFood,
          ),
        ),

        SizedBox(
          width:
              10,
        ),

        Expanded(
          child:
              _quickActionCard(
            icon:
                Icons
                    .fitness_center_rounded,
            label:
                'Workout',
            color:
                _warning,
            onTap:
                _openWorkout,
          ),
        ),

        SizedBox(
          width:
              10,
        ),

        Expanded(
          child:
              _quickActionCard(
            icon:
                Icons
                    .monitor_weight_rounded,
            label:
                'Weight',
            color:
                _secondary,
            onTap:
                _openWeight,
          ),
        ),
      ],
    );
  }

  Widget _quickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap,
      child:
          Container(
        padding:
            EdgeInsets
                .symmetric(
          vertical:
              16,
          horizontal:
              8,
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
              alpha:
                  0.20,
            ),
          ),
        ),
        child:
            Column(
          children: [
            Icon(
              icon,
              color:
                  color,
              size:
                  26,
            ),

            SizedBox(
              height:
                  7,
            ),

            Text(
              label,
              style:
                  TextStyle(
                color:
                    _onSurface,
                fontSize:
                    11,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // WATER
  // ============================================================

  Widget _waterCard() {
    final consumed =
        WaterIntakeService.todayConsumedMl;

    final goal =
        WaterIntakeService.dailyGoalMl;

    final progress =
        WaterIntakeService.progress;

    return GestureDetector(
      onTap: _openWater,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _primary.withValues(
              alpha: 0.25,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _primary.withValues(
                  alpha: 0.10,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.water_drop_rounded,
                color: _primary,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Water Intake',
                    style: TextStyle(
                      color: _onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${(consumed / 1000).toStringAsFixed(1)} L / '
                    '${(goal / 1000).toStringAsFixed(1)} L',
                    style: TextStyle(
                      color: _onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10),
                    child:
                        LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor:
                          _surfaceElevated,
                      valueColor:
                          AlwaysStoppedAnimation<
                              Color>(
                        _primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: _onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACTIVITY
  // ============================================================

  Widget _activitySummary(
    UserModel currentUser,
  ) {
    return Container(
      width:
          double.infinity,
      padding:
          EdgeInsets.all(
        18,
      ),
      decoration:
          BoxDecoration(
        color:
            _surface,
        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),
      child:
          Row(
        children: [
          Container(
            width:
                46,
            height:
                46,
            decoration:
                BoxDecoration(
              color:
                  _success.withValues(
                alpha:
                    0.10,
              ),
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child:
                Icon(
              Icons
                  .directions_run_rounded,
              color:
                  _success,
              size:
                  24,
            ),
          ),

          SizedBox(
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
                  'Activity Level',
                  style:
                      TextStyle(
                    color:
                        _onSurfaceVariant,
                    fontSize:
                        10,
                  ),
                ),

                SizedBox(
                  height:
                      4,
                ),

                Text(
                  currentUser
                      .activityLevelName,
                  style:
                      TextStyle(
                    color:
                        _onSurface,
                    fontSize:
                        15,
                    fontWeight:
                        FontWeight.w800,
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
  // GRAIN
  // ============================================================

  Widget _grainArea() {
    return SizedBox(
      width:
          double.infinity,
      height:
          90,
      child:
          AnimatedBuilder(
        animation:
            _grainController,
        builder:
            (
          context,
          child,
        ) {
          return CustomPaint(
            painter:
                _NaturalGrainPainter(
              progress:
                  _grainController.value,
              particleColor:
                  _secondary,
              glowColor:
                  _secondary,
            ),
          );
        },
      ),
    );
  }

  Widget _sheetHandle() {
    return Container(
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
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  double _progressValue(
    double value,
    double goal,
  ) {
    if (goal <= 0) {
      return 0;
    }

    return (value / goal)
        .clamp(
          0.0,
          1.0,
        )
        .toDouble();
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _verticalDivider(
    double height,
  ) {
    return Container(
      width:
          1,
      height:
          height,
      color:
          _onSurfaceVariant,
    );
  }
}

// =================================================================
// SAFE HEALTH INPUT DIALOG
//
// A self-contained StatefulWidget so the TextEditingController's
// lifecycle is fully owned and managed by Flutter's element tree
// (created in initState, disposed in dispose) instead of being
// disposed manually from outside right after the dialog closes.
// This avoids tearing down the controller/text field while a
// selection-toolbar overlay might still be attached, which is what
// was triggering the `_dependents.isEmpty` assertion.
// =================================================================

class _HealthInputDialog extends StatefulWidget {
  final String title;
  final String initialValue;
  final String hintText;
  final TextInputType? keyboardType;

  const _HealthInputDialog({
    required this.title,
    required this.initialValue,
    required this.hintText,
    this.keyboardType,
  });

  @override
  State<_HealthInputDialog> createState() =>
      _HealthInputDialogState();
}

class _HealthInputDialogState
    extends State<_HealthInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cancel() {
    // Make sure the keyboard/selection toolbar is fully gone
    // before the dialog route is popped.
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  void _save() {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final surface = colors.surface;
    final onSurface = colors.onSurface;

    return AlertDialog(
      backgroundColor: surface,
      title: Text(
        widget.title,
        style: TextStyle(
          color: onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: TextField(
        controller: _controller,
        keyboardType: widget.keyboardType,
        style: TextStyle(color: onSurface),
        decoration: InputDecoration(
          hintText: widget.hintText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text('Save'),
        ),
      ],
    );
  }
}

// =================================================================
// NATURAL GRAIN
// =================================================================

class _NaturalGrainPainter
    extends CustomPainter {
  final double progress;
  final Color particleColor;
  final Color glowColor;

  _NaturalGrainPainter({
    required this.progress,
    required this.particleColor,
    required this.glowColor,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint =
        Paint()
          ..style =
              PaintingStyle.fill;

    const columns =
        24;

    const rows =
        6;

    final spacingX =
        size.width /
            columns;

    final spacingY =
        size.height /
            rows;

    for (int row = 0;
        row < rows;
        row++) {
      for (int column = 0;
          column < columns;
          column++) {
        final x =
            (column + 0.5) *
                spacingX;

        final y =
            (row + 0.5) *
                spacingY;

        final centerX =
            size.width *
                0.50;

        final centerY =
            size.height *
                0.46;

        final dx =
            (x - centerX) /
                (size.width *
                    0.54);

        final dy =
            (y - centerY) /
                (size.height *
                    0.72);

        final distance =
            math.sqrt(
          (dx * dx) +
              (dy * dy),
        );

        final density =
            math.max(
          0.0,
          1.0 - distance,
        );

        if (density <= 0) {
          continue;
        }

        final movement =
            math.sin(
          progress *
                  math.pi *
                  2 +
              column *
                  0.20 +
              row *
                  0.33,
        );

        final secondary =
            math.cos(
          progress *
                  math.pi *
                  2 +
              column *
                  0.16 +
              row *
                  0.27,
        );

        final particleX =
            x +
                movement *
                    1.2;

        final particleY =
            y +
                secondary *
                    1.0;

        final radius =
            0.55 +
                density *
                    1.10;

        final opacity =
            0.010 +
                density *
                    0.050;

        paint.color =
            particleColor.withValues(
          alpha:
              opacity,
        );

        canvas.drawCircle(
          Offset(
            particleX,
            particleY,
          ),
          radius,
          paint,
        );
      }
    }

    final glowCenter =
        Offset(
      size.width *
          0.50,
      size.height *
          0.40,
    );

    final glowRadius =
        size.width *
            0.46;

    final glowPaint =
        Paint()
          ..shader =
              RadialGradient(
            colors: [
              glowColor.withValues(
                alpha:
                    0.025,
              ),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center:
                  glowCenter,
              radius:
                  glowRadius,
            ),
          );

    canvas.drawRect(
      Offset.zero &
          Size(
        size.width,
        size.height,
      ),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _NaturalGrainPainter
        oldDelegate,
  ) {
    return oldDelegate.progress !=
        progress;
  }
}

// =================================================================
// CALORIE RING
// =================================================================

class _GradientRingPainter
    extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color startColor;
  final Color middleColor;
  final Color endColor;

  _GradientRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.startColor,
    required this.middleColor,
    required this.endColor,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center =
        Offset(
      size.width /
          2,
      size.height /
          2,
    );

    final radius =
        (size.width /
                2) -
            strokeWidth /
                2;

    final rect =
        Rect.fromCircle(
      center:
          center,
      radius:
          radius,
    );

    final backgroundPaint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth =
              strokeWidth
          ..strokeCap =
              StrokeCap.round
          ..color =
              backgroundColor;

    canvas.drawArc(
      rect,
      0,
      2 *
          math.pi,
      false,
      backgroundPaint,
    );

    if (progress <=
        0) {
      return;
    }

    final gradient =
        SweepGradient(
      startAngle:
          -math.pi / 2,
      endAngle:
          3 * math.pi / 2,
      colors: [startColor, middleColor, endColor],
    );

    final progressPaint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth =
              strokeWidth
          ..strokeCap =
              StrokeCap.round
          ..shader =
              gradient.createShader(
            rect,
          );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 *
          math.pi *
          progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _GradientRingPainter
        oldDelegate,
  ) {
    return oldDelegate.progress !=
            progress ||
        oldDelegate.strokeWidth !=
            strokeWidth;
  }
}
