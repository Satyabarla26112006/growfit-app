import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../services/nutrition_progress_service.dart';
import '../../models/user_model.dart';
import '../../models/weight_model.dart';
import '../../services/attendance_service.dart';
import '../../services/daily_history_service.dart';
import '../../services/user_service.dart';
import '../../services/weight_service.dart';
import '../../services/workout_history_service.dart';
import '../../services/health_nutrition_guidance_service.dart';
import '../../services/micronutrient_progress_service.dart';
import '../../services/nutrition_recommendation_service.dart';
import '../health/health_readings_card.dart';
import 'weight_entry_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({
    super.key,
  });

  @override
  State<ProgressScreen> createState() =>
      _ProgressScreenState();
}

class _ProgressScreenState
    extends State<ProgressScreen> {
  // ============================================================
  // THEME TOKENS
  // ============================================================

  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _surfaceElevated =>
      Theme.of(context).colorScheme.surfaceContainerHighest;
  Color get _primary => Theme.of(context).colorScheme.primary;
  Color get _secondary => Theme.of(context).colorScheme.secondary;
  Color get _success =>
      Theme.of(context).colorScheme.brightness == Brightness.dark
          ? Color(0xFF7DB36A)
          : Color(0xFF167A4A);
  Color get _warning =>
      Theme.of(context).colorScheme.brightness == Brightness.dark
          ? Color(0xFFD6A84E)
          : Color(0xFFE09A2D);
  Color get _text => Theme.of(context).colorScheme.onSurface;
  Color get _muted => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _border => Theme.of(context).colorScheme.outline;

  bool _loading = true;

  UserModel? _user;

  DateTime _selectedDate =
      DateTime.now();

  DateTime _displayedMonth =
      DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> _initialize() async {
    await WeightService.initialize();
    await AttendanceService.initialize();
    await WorkoutHistoryService.initialize();

    _user = UserService.getUser();

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
    });
  }

  // ============================================================
  // GOAL WEIGHT
  // ============================================================

  double? get _goalWeight {
    return _user?.goalWeight;
  }

  // ============================================================
  // PROFILE CURRENT WEIGHT
  // ============================================================

  double? get _profileCurrentWeight {
    final value =
        _user?.currentWeight;

    if (value == null ||
        value <= 0) {
      return null;
    }

    return value;
  }

  // ============================================================
  // ADD WEIGHT
  // ============================================================

  Future<void> _addWeight() async {
    final result =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WeightEntryScreen(
          goalWeight:
              _goalWeight,
        ),
      ),
    );

    if (result == true &&
        mounted) {
      await WeightService.initialize();

      setState(() {
        _user =
            UserService.getUser();
      });
    }
  }

  // ============================================================
  // TOGGLE ATTENDANCE
  // ============================================================

  Future<void> _toggleAttendance(
    DateTime date,
  ) async {
    final today =
        _dateOnly(
      DateTime.now(),
    );

    if (date.isAfter(today)) {
      return;
    }

    final marked =
        await AttendanceService
            .toggleDate(
      date,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedDate =
          date;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          marked
              ? 'Attendance marked for ${_formatDate(date)}'
              : 'Attendance removed for ${_formatDate(date)}',
        ),
        duration:
            Duration(
          seconds: 1,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_loading) {
      return Scaffold(
        backgroundColor:
            _background,
        body: Center(
          child:
              CircularProgressIndicator(
            color:
                _secondary,
          ),
        ),
      );
    }

    final entries =
        WeightService.entries;

    final current =
        WeightService.currentWeight ??
            _profileCurrentWeight;

    final starting =
        WeightService.startingWeight ??
            _profileCurrentWeight;

    final change =
        entries.length >= 2
            ? WeightService.totalChange
            : 0.0;

    final goal =
        _goalWeight;

    final goalProgress =
        _calculateGoalProgress(
      current:
          current,
      starting:
          starting,
      goal:
          goal,
    );

    return Scaffold(
      backgroundColor:
          _background,

      appBar:
          AppBar(
        backgroundColor:
            Colors.transparent,
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
          'Progress',
          style:
              TextStyle(
            color:
                _text,
            fontWeight:
                FontWeight.w800,
          ),
        ),

        actions: [
          IconButton(
            tooltip:
                'Record Weight',
            onPressed:
                _addWeight,

            icon:
                Icon(
              Icons.add_rounded,
              color:
                  _secondary,
            ),
          ),
        ],
      ),

      body:
          SafeArea(
        child:
            ListView(
          physics:
              BouncingScrollPhysics(),

          padding:
              EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),

          children: [
            _header(),

            SizedBox(
              height: 18,
            ),

            _summaryCard(
              current:
                  current,
              goal:
                  goal,
              change:
                  change,
            ),

            SizedBox(
              height: 18,
            ),

            _weightGraph(
              entries,
            ),

            SizedBox(
              height: 18,
            ),

            _goalProgressCard(
              current:
                  current,
              starting:
                  starting,
              goal:
                  goal,
              progress:
                  goalProgress,
            ),

            SizedBox(
              height: 18,
            ),

            _todayNutritionCard(),

            SizedBox(
              height: 18,
            ),

            _macroDonutCard(),

            SizedBox(
              height: 18,
            ),

            _healthNutritionGuidanceCard(),

            SizedBox(
              height: 18,
            ),

            _healthReadingsCard(),

            SizedBox(
              height: 18,
            ),

            _micronutrientProgressCard(),

            SizedBox(
              height: 18,
            ),

            _smartNutritionRecommendationsCard(),

            SizedBox(
              height: 18,
            ),

            _nutritionProgressCard(),

            SizedBox(
              height: 18,
            ),

            _workoutProgressCard(),

            SizedBox(
              height: 18,
            ),

            _calendarCard(
              entries,
            ),

            SizedBox(
              height: 18,
            ),

            _selectedDayCard(
              entries,
            ),

            SizedBox(
              height: 18,
            ),

            _attendanceCard(),

            SizedBox(
              height: 18,
            ),

            if (entries.isEmpty)
              _emptyState()
            else
              _historyCard(
                entries,
              ),

            SizedBox(
              height: 20,
            ),

            _addWeightButton(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header() {
    return Container(
      padding:
          EdgeInsets.all(21),

      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            _surfaceElevated,
            _surface,
            _surfaceElevated,
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
            alpha:
                0.28,
          ),
        ),
      ),

      child:
          Row(
        children: [
          _HeaderIcon(),

          SizedBox(
            width:
                14,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  'Your Progress',
                  style:
                      TextStyle(
                    color:
                        _text,
                    fontSize:
                        22,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                SizedBox(
                  height:
                      5,
                ),

                Text(
                  'Track your weight, nutrition, consistency and daily activity.',
                  style:
                      TextStyle(
                    color:
                        _muted,
                    fontSize:
                        12,
                    height:
                        1.4,
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
  // SUMMARY
  // ============================================================

  Widget _summaryCard({
    required double? current,
    required double? goal,
    required double change,
  }) {
    final hasCurrent =
        current != null &&
            current > 0;

    final hasGoal =
        goal != null &&
            goal > 0;

    final difference =
        hasCurrent && hasGoal
            ? current - goal
            : 0.0;

    final differenceColor =
        difference.abs() <
                0.1
            ? _success
            : difference > 0
                ? _warning
                : _success;

    return Container(
      padding:
          EdgeInsets.all(20),

      decoration:
          BoxDecoration(
        color:
            _surface,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border:
            Border.all(
          color:
              _border.withValues(
            alpha:
                0.4,
          ),
        ),
      ),

      child:
          Column(
        children: [
          Row(
            children: [
              Expanded(
                child:
                    _summaryValue(
                  title:
                      'Current',
                  value:
                      hasCurrent
                          ? '${current.toStringAsFixed(1)} kg'
                          : '—',
                  color:
                      _secondary,
                  icon:
                      Icons
                          .monitor_weight_rounded,
                ),
              ),

              _divider(),

              Expanded(
                child:
                    _summaryValue(
                  title:
                      'Goal',
                  value:
                      hasGoal
                          ? '${goal.toStringAsFixed(1)} kg'
                          : '—',
                  color:
                      _primary,
                  icon:
                      Icons.flag_rounded,
                ),
              ),

              _divider(),

              Expanded(
                child:
                    _summaryValue(
                  title:
                      'Change',
                  value:
                      change == 0
                          ? '—'
                          : '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} kg',
                  color:
                      change == 0
                          ? _muted
                          : change < 0
                              ? _success
                              : _warning,
                  icon:
                      change < 0
                          ? Icons
                              .trending_down_rounded
                          : change > 0
                              ? Icons
                                  .trending_up_rounded
                              : Icons
                                  .remove_rounded,
                ),
              ),
            ],
          ),

          if (hasCurrent &&
              hasGoal) ...[
            SizedBox(
              height: 18,
            ),

            Container(
              width:
                  double.infinity,

              padding:
                  EdgeInsets.all(
                12,
              ),

              decoration:
                  BoxDecoration(
                color:
                    differenceColor
                        .withValues(
                  alpha:
                      0.08,
                ),

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),

              child:
                  Text(
                difference.abs() <
                        0.1
                    ? 'You are at your goal weight.'
                    : difference > 0
                        ? '${difference.toStringAsFixed(1)} kg left to reach your goal.'
                        : '${difference.abs().toStringAsFixed(1)} kg below your goal weight.',
                textAlign:
                    TextAlign.center,

                style:
                    TextStyle(
                  color:
                      differenceColor,

                  fontSize:
                      11,

                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY VALUE
  // ============================================================

  Widget _summaryValue({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color:
              color,
          size:
              20,
        ),

        SizedBox(
          height: 7,
        ),

        Text(
          title,
          style:
              TextStyle(
            color:
                _muted,
            fontSize:
                9,
          ),
        ),

        SizedBox(
          height: 4,
        ),

        Text(
          value,
          textAlign:
              TextAlign.center,
          style:
              TextStyle(
            color:
                _text,
            fontSize:
                13,
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _divider() {
    return Container(
      width:
          1,
      height:
          48,
      color:
          _border,
    );
  }

  // ============================================================
  // WEIGHT GRAPH
  // ============================================================

  Widget _weightGraph(
    List<WeightEntry> entries,
  ) {
    if (entries.isEmpty) {
      return _graphEmptyCard();
    }

    final sorted =
        [...entries]
          ..sort(
            (a, b) =>
                a.date.compareTo(
              b.date,
            ),
          );

    final recent =
        sorted.length > 30
            ? sorted.sublist(
                sorted.length - 30,
              )
            : sorted;

    final minWeight =
        recent
            .map(
              (entry) =>
                  entry.weight,
            )
            .reduce(
              math.min,
            );

    final maxWeight =
        recent
            .map(
              (entry) =>
                  entry.weight,
            )
            .reduce(
              math.max,
            );

    return Container(
      padding:
          EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            _surface,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border:
            Border.all(
          color:
              _border.withValues(
            alpha:
                0.4,
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
                Icons
                    .show_chart_rounded,
                color:
                    _primary,
                size:
                    22,
              ),

              SizedBox(
                width: 8,
              ),

              Expanded(
                child:
                    Text(
                  'Weight Progress',
                  style:
                      TextStyle(
                    color:
                        _text,
                    fontSize:
                        17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              Text(
                '${recent.length} entries',
                style:
                    TextStyle(
                  color:
                      _muted,
                  fontSize:
                      10,
                ),
              ),
            ],
          ),

          SizedBox(
            height: 18,
          ),

          SizedBox(
            height: 190,

            child:
                CustomPaint(
              painter:
                  WeightGraphPainter(
                entries: recent,
                minWeight: minWeight,
                maxWeight: maxWeight,
                lineColor: _secondary,
                pointColor: _primary,
                pointInnerColor: _surface,
                gridColor: _border,
              ),

              child:
                  const SizedBox
                      .expand(),
            ),
          ),

          SizedBox(
            height: 8,
          ),

          Row(
            children: [
              Text(
                _shortDate(
                  recent.first.date,
                ),
                style:
                    TextStyle(
                  color:
                      _muted,
                  fontSize:
                      9,
                ),
              ),

              Spacer(),

              Text(
                _shortDate(
                  recent.last.date,
                ),
                style:
                    TextStyle(
                  color:
                      _muted,
                  fontSize:
                      9,
                ),
              ),
            ],
          ),

          SizedBox(
            height: 12,
          ),

          Row(
            children: [
              _graphLegend(
                _secondary,
                'Weight',
              ),

              SizedBox(
                width: 14,
              ),

              _graphLegend(
                _primary,
                'Measurements',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY GRAPH
  // ============================================================

  Widget _graphEmptyCard() {
    return Container(
      padding:
          EdgeInsets.all(28),

      decoration:
          BoxDecoration(
        color:
            _surface,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border:
            Border.all(
          color:
              _border.withValues(
            alpha:
                0.4,
          ),
        ),
      ),

      child:
          Column(
        children: [
          Icon(
            Icons
                .show_chart_rounded,
            color:
                _secondary,
            size:
                44,
          ),

          SizedBox(
            height: 13,
          ),

          Text(
            'Your weight graph will appear here',
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              color:
                  _text,
              fontSize:
                  16,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          SizedBox(
            height: 7,
          ),

          Text(
            'Record your first weight measurement to start tracking your progress.',
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              color:
                  _muted,
              fontSize:
                  11,
              height:
                  1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GRAPH LEGEND
  // ============================================================

  Widget _graphLegend(
    Color color,
    String text,
  ) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,

      children: [
        Container(
          width: 7,
          height: 7,
          decoration:
              BoxDecoration(
            color:
                color,
            shape:
                BoxShape.circle,
          ),
        ),

        SizedBox(
          width: 5,
        ),

        Text(
          text,
          style:
              TextStyle(
            color:
                _muted,
            fontSize:
                9,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // GOAL PROGRESS
  // ============================================================

  Widget _goalProgressCard({
    required double? current,
    required double? starting,
    required double? goal,
    required double progress,
  }) {
    if (goal == null ||
        goal <= 0) {
      return Container(
        padding:
            EdgeInsets.all(
          21,
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
            Row(
          children: [
            Icon(
              Icons.flag_outlined,
              color:
                  _primary,
            ),

            SizedBox(
              width: 10,
            ),

            Expanded(
              child:
                  Text(
                'Set a goal weight to see your goal progress.',
                style:
                    TextStyle(
                  color:
                      _muted,
                  fontSize:
                      12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final percent =
        (progress * 100)
            .round();

    return Container(
      padding:
          EdgeInsets.all(21),

      decoration:
          BoxDecoration(
        color:
            _surface,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border:
            Border.all(
          color:
              _primary.withValues(
            alpha:
                0.12,
          ),
        ),
      ),

      child:
          Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.flag_rounded,
                color:
                    _primary,
              ),

              SizedBox(
                width: 9,
              ),

              Expanded(
                child:
                    Text(
                  'Goal Progress',
                  style:
                      TextStyle(
                    color:
                        _text,
                    fontSize:
                        16,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              Text(
                '$percent%',
                style:
                    TextStyle(
                  color:
                      _primary,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),

          SizedBox(
            height: 18,
          ),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),

            child:
                LinearProgressIndicator(
              value:
                  progress
                      .clamp(
                0.0,
                1.0,
              )
                      .toDouble(),

              minHeight:
                  10,

              backgroundColor:
                  _border,

              color:
                  _primary,
            ),
          ),

          SizedBox(
            height: 15,
          ),

          Row(
            children: [
              Expanded(
                child:
                    Text(
                  current != null
                      ? 'Current: ${current.toStringAsFixed(1)} kg'
                      : 'Current: —',

                  style:
                      TextStyle(
                    color:
                        _muted,
                    fontSize:
                        11,
                  ),
                ),
              ),

              Text(
                'Goal: ${goal.toStringAsFixed(1)} kg',
                style:
                    TextStyle(
                  color:
                      _muted,
                  fontSize:
                      11,
                ),
              ),
            ],
          ),

          if (starting != null) ...[
            SizedBox(
              height: 8,
            ),

            Align(
              alignment:
                  Alignment.centerLeft,

              child:
                  Text(
                'Starting: ${starting.toStringAsFixed(1)} kg',

                style:
                    TextStyle(
                  color:
                      _muted,
                  fontSize:
                      10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }


  // ============================================================
  // SELECTED DAY NUTRITION TARGETS
  // ============================================================

  Widget _todayNutritionCard() {
    final user = _user;

    if (user == null) {
      return SizedBox.shrink();
    }

    final targets =
        NutritionProgressService.targetsForUser(user);

    final progress =
        NutritionProgressService.calculate(
      date: _selectedDate,
      targets: targets,
    );

    final hasTargets =
        targets.calories > 0 ||
        targets.protein > 0 ||
        targets.carbohydrates > 0 ||
        targets.fats > 0;

    final selectedDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    final today = DateTime.now();

    final todayOnly = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final isToday = selectedDate == todayOnly;

    final title = isToday
        ? 'Today\'s Nutrition'
        : 'Nutrition for ${_formatDate(_selectedDate)}';

    if (!hasTargets) {
      return Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _border.withValues(
              alpha: 0.4,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.track_changes_rounded,
                  color: _secondary,
                  size: 22,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: _text,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _secondary.withValues(
                  alpha: 0.08,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: _secondary,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Nutrition targets are not set yet. Complete your nutrition setup to see your daily targets and progress.',
                      style: TextStyle(
                        color: _text,
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _border.withValues(
            alpha: 0.4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.track_changes_rounded,
                color: _secondary,
                size: 22,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: _text,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _secondary.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  isToday ? 'TODAY' : 'DAY',
                  style: TextStyle(
                    color: _secondary,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            'Consumed compared with your daily nutrition targets.',
            style: TextStyle(
              color: _muted,
              fontSize: 10,
              height: 1.35,
            ),
          ),
          SizedBox(height: 18),
          _nutritionTargetRow(
            title: 'Calories',
            consumed: progress.calories.consumed,
            target: progress.calories.target,
            unit: 'kcal',
            icon: Icons.local_fire_department_rounded,
            color: _warning,
          ),
          SizedBox(height: 14),
          _nutritionTargetRow(
            title: 'Protein',
            consumed: progress.protein.consumed,
            target: progress.protein.target,
            unit: 'g',
            icon: Icons.fitness_center_rounded,
            color: _secondary,
          ),
          SizedBox(height: 14),
          _nutritionTargetRow(
            title: 'Carbs',
            consumed: progress.carbohydrates.consumed,
            target: progress.carbohydrates.target,
            unit: 'g',
            icon: Icons.grain_rounded,
            color: _primary,
          ),
          SizedBox(height: 14),
          _nutritionTargetRow(
            title: 'Fat',
            consumed: progress.fats.consumed,
            target: progress.fats.target,
            unit: 'g',
            icon: Icons.water_drop_rounded,
            color: _success,
          ),
          SizedBox(height: 14),
          _nutritionTargetRow(
            title: 'Fiber',
            consumed: progress.fiber.consumed,
            target: progress.fiber.target,
            unit: 'g',
            icon: Icons.eco_rounded,
            color: _primary,
          ),
          SizedBox(height: 14),
          _nutritionTargetRow(
            title: 'Sugar',
            consumed: progress.sugar.consumed,
            target: progress.sugar.target,
            unit: 'g',
            icon: Icons.cookie_rounded,
            color: _secondary,
          ),
          SizedBox(height: 14),
          _nutritionTargetRow(
            title: 'Sodium',
            consumed: progress.sodium.consumed,
            target: progress.sodium.target,
            unit: 'mg',
            icon: Icons.water_rounded,
            color: _warning,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NUTRITION TARGET ROW
  // ============================================================

  Widget _nutritionTargetRow({
    required String title,
    required double consumed,
    required double target,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    final hasTarget = target > 0;

    final rawProgress = hasTarget
        ? consumed / target
        : 0.0;

    final progressValue = rawProgress.clamp(
      0.0,
      1.0,
    );

    final percentage = hasTarget
        ? rawProgress * 100
        : 0.0;

    final isOver =
        hasTarget && consumed > target;

    final progressColor = isOver
        ? _warning
        : color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(
                  alpha: 0.10,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 17,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: _text,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              hasTarget
                  ? '${_formatNutritionNumber(consumed)} / ${_formatNutritionNumber(target)} $unit'
                  : '${_formatNutritionNumber(consumed)} $unit',
              style: TextStyle(
                color: _text,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: 7,
            backgroundColor: _border,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor,
            ),
          ),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            if (hasTarget)
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: progressColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            if (hasTarget)
              SizedBox(width: 6),
            Expanded(
              child: Text(
                !hasTarget
                    ? 'Target not available'
                    : isOver
                        ? 'Above target'
                        : consumed >= target * 0.8
                            ? 'On track'
                            : 'Below target',
                style: TextStyle(
                  color: !hasTarget
                      ? _muted
                      : isOver
                          ? _warning
                          : consumed >= target * 0.8
                              ? _success
                              : _muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (hasTarget)
              Text(
                isOver
                    ? '+${_formatNutritionNumber(consumed - target)} $unit'
                    : '${_formatNutritionNumber(target - consumed)} $unit left',
                style: TextStyle(
                  color: _muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // NUTRITION NUMBER FORMATTER
  // ============================================================

  String _formatNutritionNumber(double value) {
    if (value.abs() >= 100) {
      return value.toStringAsFixed(0);
    }

    if (value.abs() >= 10) {
      return value.toStringAsFixed(1);
    }

    return value.toStringAsFixed(1);
  }

  // ============================================================
  // MACRO DONUT
  // ============================================================

  Widget _macroDonutCard() {
    final date = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    final logs = DailyHistoryService.getLogsForDate(date);

    double protein = 0;
    double carbs = 0;
    double fats = 0;

    for (final log in logs) {
      protein += log.protein;
      carbs += log.carbs;
      fats += log.fats;
    }

    final proteinCalories = protein * 4;
    final carbCalories = carbs * 4;
    final fatCalories = fats * 9;

    final totalMacroCalories =
        proteinCalories + carbCalories + fatCalories;

    final proteinPercent = totalMacroCalories > 0
        ? proteinCalories / totalMacroCalories
        : 0.0;

    final carbPercent = totalMacroCalories > 0
        ? carbCalories / totalMacroCalories
        : 0.0;

    final fatPercent = totalMacroCalories > 0
        ? fatCalories / totalMacroCalories
        : 0.0;

    final titleDate = _sameDate(date, DateTime.now())
        ? 'Today'
        : _formatDate(_selectedDate);

    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _border.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pie_chart_rounded,
                color: _secondary,
                size: 22,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Macro Breakdown',
                  style: TextStyle(
                    color: _text,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                titleDate.toUpperCase(),
                style: TextStyle(
                  color: _muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            'Protein, carbohydrates and fat from your logged foods.',
            style: TextStyle(
              color: _muted,
              fontSize: 10,
              height: 1.35,
            ),
          ),
          SizedBox(height: 20),
          if (totalMacroCalories <= 0)
            _macroEmptyState()
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 155,
                  height: 155,
                  child: CustomPaint(
                    painter: MacroDonutPainter(
                      proteinFraction: proteinPercent,
                      carbFraction: carbPercent,
                      fatFraction: fatPercent,
                      proteinColor: _secondary,
                      carbColor: _primary,
                      fatColor: _warning,
                      backgroundColor: _border,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${totalMacroCalories.round()}',
                            style: TextStyle(
                              color: _text,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'macro kcal',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    children: [
                      _macroLegendRow(
                        title: 'Protein',
                        grams: protein,
                        percentage: proteinPercent,
                        color: _secondary,
                      ),
                      SizedBox(height: 13),
                      _macroLegendRow(
                        title: 'Carbs',
                        grams: carbs,
                        percentage: carbPercent,
                        color: _primary,
                      ),
                      SizedBox(height: 13),
                      _macroLegendRow(
                        title: 'Fat',
                        grams: fats,
                        percentage: fatPercent,
                        color: _warning,
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

  Widget _macroLegendRow({
    required String title,
    required double grams,
    required double percentage,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: _text,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          '${grams.toStringAsFixed(1)} g',
          style: TextStyle(
            color: _text,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(width: 8),
        SizedBox(
          width: 34,
          child: Text(
            '${(percentage * 100).round()}%',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _muted,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _macroEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: _surfaceElevated,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.pie_chart_outline_rounded,
            color: _muted,
            size: 38,
          ),
          SizedBox(height: 10),
          Text(
            'No macros logged yet',
            style: TextStyle(
              color: _text,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Add food to see your macro breakdown.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _muted,
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEALTH NUTRITION GUIDANCE
  // ============================================================

  Widget _healthNutritionGuidanceCard() {
    final date = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    final logs =
        DailyHistoryService.getLogsForDate(date);

    final guidance =
        HealthNutritionGuidanceService.generate(
      logs: logs,
    );

    final titleDate =
        _sameDate(date, DateTime.now())
            ? 'Today'
            : _formatDate(_selectedDate);

    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _border.withValues(
            alpha: 0.4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.health_and_safety_rounded,
                color: _primary,
                size: 22,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Heart & Blood Sugar',
                  style: TextStyle(
                    color: _text,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                titleDate.toUpperCase(),
                style: TextStyle(
                  color: _muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            'General nutrition guidance from your logged foods.',
            style: TextStyle(
              color: _muted,
              fontSize: 10,
              height: 1.35,
            ),
          ),
          SizedBox(height: 16),
          if (guidance.isEmpty)
            _healthGuidanceEmptyState()
          else
            ...List.generate(
              guidance.length,
              (index) {
                final item = guidance[index];

                return Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        index == guidance.length - 1
                            ? 0
                            : 12,
                  ),
                  child:
                      _healthGuidanceItem(item),
                );
              },
            ),
          SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: _surfaceElevated,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: _muted,
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This section provides general nutrition education and '
                    'does not diagnose or treat high or low blood pressure '
                    'or blood glucose.',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 9,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _healthGuidanceItem(
    HealthNutritionGuidance item,
  ) {
    final accent = item.caution
        ? _warning
        : _success;

    final icon = item.caution
        ? Icons.warning_amber_rounded
        : Icons.check_circle_rounded;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: accent.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: accent,
                size: 19,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        color: _text,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      item.message,
                      style: TextStyle(
                        color: _text,
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (item.foods.isNotEmpty) ...[
            SizedBox(height: 11),
            Text(
              'FOOD IDEAS',
              style: TextStyle(
                color: _muted,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.7,
              ),
            ),
            SizedBox(height: 7),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: item.foods.map(
                (food) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _surfaceElevated,
                      borderRadius:
                          BorderRadius.circular(9),
                    ),
                    child: Text(
                      food.name,
                      style:
                          TextStyle(
                        color:
                            _text,
                        fontSize: 9,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _healthGuidanceEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: _surfaceElevated,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(
            Icons.health_and_safety_outlined,
            color: _muted,
            size: 36,
          ),
          SizedBox(height: 9),
          Text(
            'No health guidance yet',
            style: TextStyle(
              color: _text,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Log more foods to get nutrition-based heart and blood-sugar guidance.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _muted,
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEALTH READINGS
  // ============================================================

  Widget _healthReadingsCard() {
    return HealthReadingsCard(
      onAddReading: _openHealthReadingSheet,
    );
  }

  Future<void> _openHealthReadingSheet() async {
    final result =
        await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          _surface,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) =>
          HealthReadingEntrySheet(),
    );

    if (result == true &&
        mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // VITAMINS & MINERALS
  // ============================================================

  Widget _micronutrientProgressCard() {
    final date = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    final logs =
        DailyHistoryService.getLogsForDate(date);

    final vitamins =
        MicronutrientProgressService.vitamins(logs);

    final minerals =
        MicronutrientProgressService.minerals(logs);

    final all = [
      ...vitamins,
      ...minerals,
    ];

    final lowCount =
        all.where((item) => item.percentage < 50).length;

    final titleDate =
        _sameDate(date, DateTime.now())
            ? 'Today'
            : _formatDate(_selectedDate);

    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _border.withValues(
            alpha: 0.4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medication_liquid_rounded,
                color: _secondary,
                size: 22,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Vitamins & Minerals',
                  style: TextStyle(
                    color: _text,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                titleDate.toUpperCase(),
                style: TextStyle(
                  color: _muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            'General Daily Value coverage from your logged foods.',
            style: TextStyle(
              color: _muted,
              fontSize: 10,
              height: 1.35,
            ),
          ),
          SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _surfaceElevated,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.insights_rounded,
                  color: _primary,
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lowCount == 0
                        ? 'Your logged foods currently cover 50%+ of every displayed micronutrient Daily Value.'
                        : '$lowCount displayed micronutrient${lowCount == 1 ? '' : 's'} are below 50% of Daily Value.',
                    style: TextStyle(
                      color: _text,
                      fontSize: 10,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18),
          Text(
            'VITAMINS',
            style: TextStyle(
              color: _muted,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 9),
          _micronutrientGrid(vitamins),
          SizedBox(height: 18),
          Text(
            'MINERALS',
            style: TextStyle(
              color: _muted,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 9),
          _micronutrientGrid(minerals),
          SizedBox(height: 13),
          Text(
            'Daily Value is a standard reference for nutrition-label style guidance, not a personalized medical or nutrient prescription.',
            style: TextStyle(
              color: _muted,
              fontSize: 9,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _micronutrientGrid(
    List<MicronutrientProgress> items,
  ) {
    return Column(
      children: List.generate(
        (items.length / 2).ceil(),
        (rowIndex) {
          final firstIndex = rowIndex * 2;
          final secondIndex = firstIndex + 1;

          final first = items[firstIndex];
          final second =
              secondIndex < items.length
                  ? items[secondIndex]
                  : null;

          return Padding(
            padding: EdgeInsets.only(
              bottom:
                  rowIndex == (items.length / 2).ceil() - 1
                      ? 0
                      : 8,
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:
                      _micronutrientTile(first),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: second == null
                      ? SizedBox()
                      : _micronutrientTile(second),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _micronutrientTile(
    MicronutrientProgress item,
  ) {
    final isLow = item.percentage < 50;
    final isBuilding =
        item.percentage >= 50 &&
        item.percentage < 80;

    final statusColor = isLow
        ? _warning
        : isBuilding
            ? _primary
            : _success;

    final amountText =
        '${_formatMicroAmount(item.consumed)} ${item.unit}';

    final dvText =
        '${item.percentage.round()}% DV';

    return Container(
      padding: EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: statusColor.withValues(
            alpha: 0.10,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _text,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                dvText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            amountText,
            style: TextStyle(
              color: _text,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 7),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: item.fraction,
              minHeight: 5,
              backgroundColor:
                  _border,
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                statusColor,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            item.status,
            style: TextStyle(
              color: statusColor,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMicroAmount(
    double value,
  ) {
    if (value <= 0) {
      return '0';
    }

    if (value >= 100) {
      return value.toStringAsFixed(0);
    }

    if (value >= 10) {
      return value.toStringAsFixed(1);
    }

    if (value >= 1) {
      return value.toStringAsFixed(2);
    }

    return value.toStringAsFixed(2);
  }

  // ============================================================
  // SMART NUTRITION RECOMMENDATIONS
  // ============================================================

  Widget _smartNutritionRecommendationsCard() {
    final date = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    final logs =
        DailyHistoryService.getLogsForDate(date);

    final user = _user;

    if (user == null) {
      return SizedBox.shrink();
    }

    final targets =
        NutritionProgressService.targetsForUser(user);

    final recommendations =
        NutritionRecommendationService.generate(
      logs: logs,
      targets: targets,
    );

    final titleDate =
        _sameDate(date, DateTime.now())
            ? 'Today'
            : _formatDate(_selectedDate);

    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _border.withValues(
            alpha: 0.4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: _secondary,
                size: 22,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Smart Food Recommendations',
                  style: TextStyle(
                    color: _text,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                titleDate.toUpperCase(),
                style: TextStyle(
                  color: _muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            'Suggestions are based on the biggest nutrition gaps in your logged foods.',
            style: TextStyle(
              color: _muted,
              fontSize: 10,
              height: 1.35,
            ),
          ),
          SizedBox(height: 16),
          ...List.generate(
            recommendations.length,
            (index) {
              final recommendation =
                  recommendations[index];

              return Padding(
                padding: EdgeInsets.only(
                  bottom:
                      index == recommendations.length - 1
                          ? 0
                          : 12,
                ),
                child:
                    _smartRecommendationItem(
                  recommendation,
                ),
              );
            },
          ),
          SizedBox(height: 13),
          Text(
            'Food suggestions are general nutrition guidance, not a medical prescription.',
            style: TextStyle(
              color: _muted,
              fontSize: 9,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _smartRecommendationItem(
    NutritionRecommendation recommendation,
  ) {
    final accent = recommendation.positive
        ? _success
        : _secondary;

    final icon = recommendation.positive
        ? Icons.check_circle_rounded
        : Icons.restaurant_menu_rounded;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: accent.withValues(alpha: 0.11),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: accent,
                size: 18,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.title,
                      style: TextStyle(
                        color: _text,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      recommendation.message,
                      style: TextStyle(
                        color: _text,
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (recommendation.foods.isNotEmpty) ...[
            SizedBox(height: 11),
            Text(
              'TRY NEXT',
              style: TextStyle(
                color: _muted,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.7,
              ),
            ),
            SizedBox(height: 7),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children:
                  recommendation.foods.map(
                (food) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _surfaceElevated,
                      borderRadius:
                          BorderRadius.circular(9),
                    ),
                    child: Text(
                      food.name,
                      style:
                          TextStyle(
                        color: _text,
                        fontSize: 9,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // NUTRITION PROGRESS
  // ============================================================

  Widget _nutritionProgressCard() {
    final today =
        DateTime.now();

    final dates =
        List<DateTime>.generate(
      7,
      (index) {
        final daysAgo =
            6 - index;

        return DateTime(
          today.year,
          today.month,
          today.day -
              daysAgo,
        );
      },
    );

    final calories =
        dates
            .map(
              DailyHistoryService
                  .caloriesForDate,
            )
            .toList();

    final protein =
        dates
            .map(
              DailyHistoryService
                  .proteinForDate,
            )
            .toList();

    final carbs =
        dates
            .map(
              DailyHistoryService
                  .carbsForDate,
            )
            .toList();

    final fats =
        dates
            .map(
              DailyHistoryService
                  .fatsForDate,
            )
            .toList();

    final fiber =
        dates
            .map(
              DailyHistoryService
                  .fiberForDate,
            )
            .toList();

    final sugar =
        dates
            .map(
              _sugarForDate,
            )
            .toList();

    return Container(
      padding:
          EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            _surface,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border:
            Border.all(
          color:
              _border.withValues(
            alpha:
                0.4,
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
                Icons
                    .donut_large_rounded,
                color:
                    _secondary,
                size:
                    22,
              ),

              SizedBox(
                width: 8,
              ),

              Expanded(
                child:
                    Text(
                  'Nutrition Progress',
                  style:
                      TextStyle(
                    color:
                        _text,
                    fontSize:
                        17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              Text(
                '7 DAYS',
                style:
                    TextStyle(
                  color:
                      _muted,
                  fontSize:
                      9,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),

          SizedBox(
            height: 6,
          ),

          Text(
            'Your daily nutrition history.',
            style:
                TextStyle(
              color:
                  _muted,
              fontSize:
                  10,
            ),
          ),

          SizedBox(
            height: 18,
          ),

          _nutritionMetricChart(
            title:
                'Calories',
            unit:
                'kcal',
            values:
                calories,
            color:
                _warning,
          ),

          SizedBox(
            height: 18,
          ),

          _nutritionMetricChart(
            title:
                'Protein',
            unit:
                'g',
            values:
                protein,
            color:
                _secondary,
          ),

          SizedBox(
            height: 18,
          ),

          _nutritionMetricChart(
            title:
                'Carbs',
            unit:
                'g',
            values:
                carbs,
            color:
                _primary,
          ),

          SizedBox(
            height: 18,
          ),

          _nutritionMetricChart(
            title:
                'Fats',
            unit:
                'g',
            values:
                fats,
            color:
                _success,
          ),

          SizedBox(
            height: 18,
          ),

          _nutritionMetricChart(
            title:
                'Fiber',
            unit:
                'g',
            values:
                fiber,
            color:
                _primary,
          ),

          SizedBox(
            height: 18,
          ),

          _nutritionMetricChart(
            title:
                'Sugar',
            unit:
                'g',
            values:
                sugar,
            color:
                _secondary,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NUTRITION CHART
  // ============================================================

  Widget _nutritionMetricChart({
    required String title,
    required String unit,
    required List<double> values,
    required Color color,
  }) {
    final maxValue =
        values.isEmpty
            ? 1.0
            : values.reduce(
                math.max,
              );

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Row(
          children: [
            Text(
              title,
              style:
                  TextStyle(
                color:
                    _text,
                fontSize:
                    12,
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            Spacer(),

            Text(
              '${_average(values).toStringAsFixed(0)} $unit avg',

              style:
                  TextStyle(
                color:
                    _muted,
                fontSize:
                    9,
              ),
            ),
          ],
        ),

        SizedBox(
          height: 8,
        ),

        SizedBox(
          height:
              90,

          child:
              CustomPaint(
            painter:
                NutritionBarPainter(
              values: values,
              maxValue: maxValue,
              color: color,
              backgroundColor: _surfaceElevated,
            ),

            child:
                SizedBox.expand(),
          ),
        ),

        SizedBox(
          height: 4,
        ),

        Row(
          children:
              List.generate(
            values.length,
            (index) {
              final date =
                  DateTime.now()
                      .subtract(
                Duration(
                  days:
                      values.length -
                          1 -
                          index,
                ),
              );

              return Expanded(
                child:
                    Text(
                  _weekday(
                    date,
                  ),
                  textAlign:
                      TextAlign.center,

                  style:
                      TextStyle(
                    color:
                        _muted,
                    fontSize:
                        8,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // AVERAGE
  // ============================================================

  double _average(
    List<double> values,
  ) {
    if (values.isEmpty) {
      return 0;
    }

    final total =
        values.fold<double>(
      0,
      (
        sum,
        value,
      ) =>
          sum + value,
    );

    return total /
        values.length;
  }

  // ============================================================
  // SUGAR
  // ============================================================

  double _sugarForDate(
    DateTime date,
  ) {
    final logs =
        DailyHistoryService
            .getLogsForDate(
      date,
    );

    return logs.fold<double>(
      0,
      (
        total,
        log,
      ) =>
          total + log.sugar,
    );
  }

  // ============================================================
  // WEEKDAY
  // ============================================================

  String _weekday(
    DateTime date,
  ) {
    const days = [
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
      'S',
    ];

    return days[
      date.weekday - 1
    ];
  }

  // ============================================================
  // CALENDAR
  // ============================================================

  Widget _calendarCard(
    List<WeightEntry> entries,
  ) {
    final firstDay =
        DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    );

    final daysInMonth =
        DateTime(
      _displayedMonth.year,
      _displayedMonth.month +
          1,
      0,
    ).day;

    final leadingDays =
        firstDay.weekday - 1;

    final today =
        DateTime.now();

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    bool hasWeight(
      int day,
    ) {
      return entries.any(
        (entry) =>
            entry.date.year ==
                _displayedMonth
                    .year &&
            entry.date.month ==
                _displayedMonth
                    .month &&
            entry.date.day ==
                day,
      );
    }

    bool hasFood(
      int day,
    ) {
      return DailyHistoryService
          .hasFoodForDate(
        DateTime(
          _displayedMonth.year,
          _displayedMonth.month,
          day,
        ),
      );
    }

    bool isPresent(
      int day,
    ) {
      return AttendanceService
          .isPresent(
        DateTime(
          _displayedMonth.year,
          _displayedMonth.month,
          day,
        ),
      );
    }

    return Container(
      padding:
          EdgeInsets.all(16),

      decoration:
          BoxDecoration(
        color:
            _surface,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border:
            Border.all(
          color:
              _border.withValues(
            alpha:
                0.4,
          ),
        ),
      ),

      child:
          Column(
        children: [
          Row(
            children: [
              Icon(
                Icons
                    .calendar_month_rounded,
                color:
                    _secondary,
                size:
                    21,
              ),

              SizedBox(
                width: 8,
              ),

              Expanded(
                child:
                    Text(
                  'Progress Calendar',
                  style:
                      TextStyle(
                    color:
                        _text,
                    fontSize:
                        16,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              IconButton(
                tooltip:
                    'Choose date',

                onPressed:
                    () async {
                  final picked =
                      await showDatePicker(
                    context:
                        context,
                    initialDate:
                        _selectedDate,
                    firstDate:
                        DateTime(
                      2020,
                    ),
                    lastDate:
                        DateTime.now(),

                    builder:
                        (
                      context,
                      child,
                    ) {
                      return Theme(
                        data:
                            Theme.of(
                          context,
                        ).copyWith(
                          colorScheme:
                              ColorScheme.dark(
                            primary:
                                _secondary,
                            surface:
                                _surface,
                          ),
                        ),

                        child:
                            child ??
                                const SizedBox
                                    .shrink(),
                      );
                    },
                  );

                  if (picked ==
                          null ||
                      !mounted) {
                    return;
                  }

                  setState(() {
                    _selectedDate =
                        picked;

                    _displayedMonth =
                        DateTime(
                      picked.year,
                      picked.month,
                      1,
                    );
                  });
                },

                icon:
                    Icon(
                  Icons.event_rounded,
                  color:
                      _muted,
                ),
              ),
            ],
          ),

          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _displayedMonth =
                        DateTime(
                      _displayedMonth
                          .year,
                      _displayedMonth
                              .month -
                          1,
                      1,
                    );
                  });
                },

                icon:
                    Icon(
                  Icons
                      .chevron_left_rounded,
                  color:
                      _text,
                ),
              ),

              Expanded(
                child:
                    Text(
                  '${months[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                  textAlign:
                      TextAlign.center,

                  style:
                      TextStyle(
                    color:
                        _text,
                    fontSize:
                        17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              IconButton(
                onPressed:
                    () {
                  final next =
                      DateTime(
                    _displayedMonth
                        .year,
                    _displayedMonth
                            .month +
                        1,
                    1,
                  );

                  final currentMonth =
                      DateTime(
                    today.year,
                    today.month,
                    1,
                  );

                  if (next.isAfter(
                    currentMonth,
                  )) {
                    return;
                  }

                  setState(() {
                    _displayedMonth =
                        next;
                  });
                },

                icon:
                    Icon(
                  Icons
                      .chevron_right_rounded,
                  color:
                      _text,
                ),
              ),
            ],
          ),

          Row(
            children:
                const [
              'M',
              'T',
              'W',
              'T',
              'F',
              'S',
              'S',
            ].map(
              (day) {
                return Expanded(
                  child:
                      Center(
                    child:
                        Text(
                      day,
                      style:
                          TextStyle(
                        color:
                            _muted,
                        fontSize:
                            11,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),

          SizedBox(
            height: 8,
          ),

          GridView.builder(
            shrinkWrap:
                true,

            physics:
                NeverScrollableScrollPhysics(),

            itemCount:
                leadingDays +
                    daysInMonth,

            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  7,

              mainAxisSpacing:
                  6,

              crossAxisSpacing:
                  4,
            ),

            itemBuilder:
                (
              context,
              index,
            ) {
              if (index <
                  leadingDays) {
                return SizedBox();
              }

              final day =
                  index -
                      leadingDays +
                      1;

              final date =
                  DateTime(
                _displayedMonth
                    .year,
                _displayedMonth
                    .month,
                day,
              );

              final isSelected =
                  _sameDate(
                date,
                _selectedDate,
              );

              final isToday =
                  _sameDate(
                date,
                today,
              );

              final isFuture =
                  date.isAfter(
                _dateOnly(
                  today,
                ),
              );

              final weighted =
                  hasWeight(
                day,
              );

              final foodLogged =
                  hasFood(
                day,
              );

              final present =
                  isPresent(
                day,
              );

              return GestureDetector(
                onTap:
                    isFuture
                        ? null
                        : () {
                            setState(() {
                              _selectedDate =
                                  date;
                            });
                          },

                onLongPress:
                    isFuture
                        ? null
                        : () async {
                            await _toggleAttendance(
                              date,
                            );
                          },

                child:
                    Container(
                  decoration:
                      BoxDecoration(
                    color:
                        isSelected
                            ? _secondary
                            : Colors
                                .transparent,

                    shape:
                        BoxShape.circle,

                    border:
                        isToday &&
                                !isSelected
                            ? Border.all(
                                color:
                                    _primary,
                                width:
                                    1.2,
                              )
                            : null,
                  ),

                  child:
                      Stack(
                    alignment:
                        Alignment.center,

                    children: [
                      Text(
                        '$day',

                        style:
                            TextStyle(
                          color:
                              isSelected
                                  ? _text
                                  : isFuture
                                      ? _border
                                      : isToday
                                          ? _primary
                                          : _text,

                          fontSize:
                              12,

                          fontWeight:
                              isSelected ||
                                      isToday
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                        ),
                      ),

                      Positioned(
                        bottom:
                            4,

                        child:
                            Row(
                          mainAxisSize:
                              MainAxisSize.min,

                          children: [
                            if (weighted)
                              _dot(
                                _secondary,
                              ),

                            if (foodLogged)
                              _dot(
                                _primary,
                              ),

                            if (present)
                              _dot(
                                _success,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(
            height: 12,
          ),

          Row(
            children: [
              _legend(
                _secondary,
                'Weight',
              ),

              SizedBox(
                width: 12,
              ),

              _legend(
                _primary,
                'Food',
              ),

              SizedBox(
                width: 12,
              ),

              _legend(
                _success,
                'Present',
              ),
            ],
          ),

          SizedBox(
            height: 10,
          ),

          Align(
            alignment:
                Alignment.centerLeft,

            child:
                Text(
              'Tap a date to select it • Long press to mark attendance',

              style:
                  TextStyle(
                color:
                    _muted,
                fontSize:
                    9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DOT
  // ============================================================

  Widget _dot(
    Color color,
  ) {
    return Container(
      width: 4,
      height: 4,

      margin:
          EdgeInsets.symmetric(
        horizontal: 1,
      ),

      decoration:
          BoxDecoration(
        color:
            color,
        shape:
            BoxShape.circle,
      ),
    );
  }

  // ============================================================
  // LEGEND
  // ============================================================

  Widget _legend(
    Color color,
    String text,
  ) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,

      children: [
        Container(
          width: 6,
          height: 6,

          decoration:
              BoxDecoration(
            color:
                color,
            shape:
                BoxShape.circle,
          ),
        ),

        SizedBox(
          width: 4,
        ),

        Text(
          text,
          style:
              TextStyle(
            color:
                _muted,
            fontSize:
                9,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SELECTED DAY
  // ============================================================

  Widget _selectedDayCard(
    List<WeightEntry> entries,
  ) {
    final selectedWeight =
        _weightForDate(
      entries,
      _selectedDate,
    );

    final calories =
        DailyHistoryService
            .caloriesForDate(
      _selectedDate,
    );

    final protein =
        DailyHistoryService
            .proteinForDate(
      _selectedDate,
    );

    final carbs =
        DailyHistoryService
            .carbsForDate(
      _selectedDate,
    );

    final fats =
        DailyHistoryService
            .fatsForDate(
      _selectedDate,
    );

    final fiber =
        DailyHistoryService
            .fiberForDate(
      _selectedDate,
    );

    final sugar =
        _sugarForDate(
      _selectedDate,
    );

    final hasFood =
        DailyHistoryService
            .hasFoodForDate(
      _selectedDate,
    );

    final present =
        AttendanceService.isPresent(
      _selectedDate,
    );

    return Container(
      padding:
          EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            _surface,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border:
            Border.all(
          color:
              _border.withValues(
            alpha:
                0.4,
          ),
        ),
      ),

      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            _formatDate(
              _selectedDate,
            ),

            style:
                TextStyle(
              color:
                  _text,
              fontSize:
                  17,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          SizedBox(
            height: 14,
          ),

          Row(
            children: [
              Expanded(
                child:
                    _selectedDayStat(
                  icon:
                      Icons
                          .monitor_weight_rounded,
                  title:
                      'Weight',
                  value:
                      selectedWeight ==
                              null
                          ? '—'
                          : '${selectedWeight.toStringAsFixed(1)} kg',
                  color:
                      _secondary,
                ),
              ),

              SizedBox(
                width: 8,
              ),

              Expanded(
                child:
                    _selectedDayStat(
                  icon:
                      Icons
                          .local_fire_department_rounded,
                  title:
                      'Calories',
                  value:
                      '${calories.round()} kcal',
                  color:
                      _warning,
                ),
              ),

              SizedBox(
                width: 8,
              ),

              Expanded(
                child:
                    _selectedDayStat(
                  icon:
                      Icons
                          .restaurant_rounded,
                  title:
                      'Food',
                  value:
                      hasFood
                          ? 'Logged'
                          : 'None',
                  color:
                      _primary,
                ),
              ),

              SizedBox(
                width: 8,
              ),

              Expanded(
                child:
                    _selectedDayStat(
                  icon:
                      Icons
                          .check_circle_rounded,
                  title:
                      'Status',
                  value:
                      present
                          ? 'Present'
                          : '—',
                  color:
                      _success,
                ),
              ),
            ],
          ),

          if (hasFood) ...[
            SizedBox(
              height: 14,
            ),

            Container(
              width:
                  double.infinity,

              padding:
                  EdgeInsets.all(
                13,
              ),

              decoration:
                  BoxDecoration(
                color:
                    _surfaceElevated,

                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),

              child:
                  Row(
                children: [
                  _miniNutrition(
                    'P',
                    protein,
                    _secondary,
                  ),

                  _miniNutrition(
                    'C',
                    carbs,
                    _primary,
                  ),

                  _miniNutrition(
                    'F',
                    fats,
                    _success,
                  ),

                  _miniNutrition(
                    'Fiber',
                    fiber,
                    _primary,
                  ),

                  _miniNutrition(
                    'Sugar',
                    sugar,
                    _secondary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // MINI NUTRITION
  // ============================================================

  Widget _miniNutrition(
    String title,
    double value,
    Color color,
  ) {
    return Expanded(
      child:
          Column(
        children: [
          Text(
            value
                .toStringAsFixed(
              0,
            ),

            style:
                TextStyle(
              color:
                  color,
              fontSize:
                  13,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          SizedBox(
            height: 2,
          ),

          Text(
            title,

            style:
                TextStyle(
              color:
                  _muted,
              fontSize:
                  8,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SELECTED DAY STAT
  // ============================================================

  Widget _selectedDayStat({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding:
          EdgeInsets.all(
        9,
      ),

      decoration:
          BoxDecoration(
        color:
            _surfaceElevated,

        borderRadius:
            BorderRadius.circular(
          14,
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
                18,
          ),

          SizedBox(
            height: 5,
          ),

          Text(
            title,
            style:
                TextStyle(
              color:
                  _muted,
              fontSize:
                  8,
            ),
          ),

          SizedBox(
            height: 3,
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
                  _text,
              fontSize:
                  9,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WEIGHT FOR DATE
  // ============================================================

  double? _weightForDate(
    List<WeightEntry> entries,
    DateTime date,
  ) {
    WeightEntry? latest;

    for (final entry
        in entries) {
      if (!_sameDate(
        entry.date,
        date,
      )) {
        continue;
      }

      if (latest == null ||
          entry.date.isAfter(
            latest.date,
          )) {
        latest =
            entry;
      }
    }

    return latest?.weight;
  }

  // ============================================================
  // ATTENDANCE
  // ============================================================

  Widget _attendanceCard() {
    return Container(
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

        border:
            Border.all(
          color:
              _success.withValues(
            alpha:
                0.18,
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
                Icons
                    .check_circle_rounded,
                color:
                    _success,
                size:
                    22,
              ),

              SizedBox(
                width: 8,
              ),

              Expanded(
                child:
                    Text(
                  'Consistency',
                  style:
                      TextStyle(
                    color:
                        _text,
                    fontSize:
                        17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 15,
          ),

          Row(
            children: [
              Expanded(
                child:
                    _attendanceStat(
                  title:
                      'Attendance',
                  value:
                      '${AttendanceService.attendanceCount}',
                ),
              ),

              _verticalSmallDivider(),

              Expanded(
                child:
                    _attendanceStat(
                  title:
                      'Current Streak',
                  value:
                      '${AttendanceService.currentStreak}',
                ),
              ),

              _verticalSmallDivider(),

              Expanded(
                child:
                    _attendanceStat(
                  title:
                      'Best Streak',
                  value:
                      '${AttendanceService.longestStreak}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ATTENDANCE STAT
  // ============================================================

  Widget _attendanceStat({
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value,

          style:
              TextStyle(
            color:
                _success,
            fontSize:
                22,
            fontWeight:
                FontWeight.w900,
          ),
        ),

        SizedBox(
          height: 4,
        ),

        Text(
          title,
          textAlign:
              TextAlign.center,

          style:
              TextStyle(
            color:
                _muted,
            fontSize:
                9,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SMALL DIVIDER
  // ============================================================

  Widget _verticalSmallDivider() {
    return Container(
      width: 1,
      height: 45,
      color:
          _border,
    );
  }

  // ============================================================
  // HISTORY
  // ============================================================

  Widget _historyCard(
    List<WeightEntry> entries,
  ) {
    final sorted =
        [...entries]
          ..sort(
            (a, b) =>
                b.date.compareTo(
              a.date,
            ),
          );

    final visible =
        sorted.take(10).toList();

    return Container(
      padding:
          EdgeInsets.all(
        20,
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
          Row(
            children: [
              Expanded(
                child:
                    Text(
                  'Weight History',
                  style:
                      TextStyle(
                    color:
                        _text,
                    fontSize:
                        17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              Text(
                '${entries.length}',
                style:
                    TextStyle(
                  color:
                      _muted,
                  fontSize:
                      11,
                ),
              ),
            ],
          ),

          SizedBox(
            height: 15,
          ),

          ...visible.map(
            (
              entry,
            ) {
              return Padding(
                padding:
                    EdgeInsets.only(
                  bottom: 12,
                ),

                child:
                    Row(
                  children: [
                    Container(
                      width:
                          42,
                      height:
                          42,

                      decoration:
                          BoxDecoration(
                        color:
                            _secondary.withValues(
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
                            .monitor_weight_rounded,
                        color:
                            _secondary,
                        size:
                            21,
                      ),
                    ),

                    SizedBox(
                      width: 11,
                    ),

                    Expanded(
                      child:
                          Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            '${entry.weight.toStringAsFixed(1)} kg',

                            style:
                                TextStyle(
                              color:
                                  _text,
                              fontSize:
                                  14,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),

                          SizedBox(
                            height: 3,
                          ),

                          Text(
                            _formatDate(
                              entry.date,
                            ),

                            style:
                                TextStyle(
                              color:
                                  _muted,
                              fontSize:
                                  10,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      _weightChangeFromPrevious(
                        entries,
                        entry,
                      ),

                      style:
                          TextStyle(
                        color:
                            _historyChangeColor(
                          entries,
                          entry,
                        ),

                        fontSize:
                            11,

                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HISTORY CHANGE
  // ============================================================

  String _weightChangeFromPrevious(
    List<WeightEntry> entries,
    WeightEntry entry,
  ) {
    final sorted =
        [...entries]
          ..sort(
            (a, b) =>
                a.date.compareTo(
              b.date,
            ),
          );

    final index =
        sorted.indexOf(
      entry,
    );

    if (index <= 0) {
      return '';
    }

    final difference =
        entry.weight -
            sorted[index - 1].weight;

    if (difference == 0) {
      return '—';
    }

    return '${difference > 0 ? '+' : ''}${difference.toStringAsFixed(1)} kg';
  }

  // ============================================================
  // HISTORY COLOR
  // ============================================================

  Color _historyChangeColor(
    List<WeightEntry> entries,
    WeightEntry entry,
  ) {
    final sorted =
        [...entries]
          ..sort(
            (a, b) =>
                a.date.compareTo(
              b.date,
            ),
          );

    final index =
        sorted.indexOf(
      entry,
    );

    if (index <= 0) {
      return _muted;
    }

    final difference =
        entry.weight -
            sorted[index - 1].weight;

    if (difference < 0) {
      return _success;
    }

    if (difference > 0) {
      return _warning;
    }

    return _muted;
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _emptyState() {
    return Container(
      padding:
          EdgeInsets.all(
        24,
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
          Icon(
            Icons
                .insights_outlined,
            color:
                _secondary,
            size:
                44,
          ),

          SizedBox(
            height: 13,
          ),

          Text(
            'No weight history yet',
            style:
                TextStyle(
              color:
                  _text,
              fontSize:
                  17,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          SizedBox(
            height: 6,
          ),

          Text(
            'Record your weight regularly to see your history and graph grow.',
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              color:
                  _muted,
              fontSize:
                  11,
              height:
                  1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADD WEIGHT BUTTON
  // ============================================================

  Widget _addWeightButton() {
    return SizedBox(
      height:
          56,

      width:
          double.infinity,

      child:
          ElevatedButton.icon(
        onPressed:
            _addWeight,

        icon:
            Icon(
          Icons.add_rounded,
        ),

        label:
            Text(
          'Record Weight',
          style:
              TextStyle(
            fontSize:
                16,
            fontWeight:
                FontWeight.w800,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GOAL PROGRESS CALCULATION
  // ============================================================

  double _calculateGoalProgress({
    required double? current,
    required double? starting,
    required double? goal,
  }) {
    if (current == null ||
        starting == null ||
        goal == null) {
      return 0;
    }

    if (starting <= 0 ||
        current <= 0 ||
        goal <= 0) {
      return 0;
    }

    final totalDistance =
        (starting - goal)
            .abs();

    if (totalDistance <=
        0.0001) {
      return 1;
    }

    final remainingDistance =
        (current - goal)
            .abs();

    final completed =
        totalDistance -
            remainingDistance;

    final progress =
        completed /
            totalDistance;

    if (progress < 0) {
      return 0;
    }

    if (progress > 1) {
      return 1;
    }

    return progress;
  }

  // ============================================================
  // DATE HELPERS
  // ============================================================

  DateTime _dateOnly(
    DateTime date,
  ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  bool _sameDate(
    DateTime first,
    DateTime second,
  ) {
    return first.year ==
            second.year &&
        first.month ==
            second.month &&
        first.day ==
            second.day;
  }

  String _formatDate(
    DateTime date,
  ) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} '
        '${date.day}, '
        '${date.year}';
  }

  String _shortDate(
    DateTime date,
  ) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} '
        '${date.day}';
  }
  Widget _workoutProgressCard() {
    final workouts =
        WorkoutHistoryService.completedWorkoutCount;

    final calories =
        WorkoutHistoryService.totalCalories;

    final seconds =
        WorkoutHistoryService.totalDurationSeconds;

    final streak =
        WorkoutHistoryService.currentStreak;

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    final timeText = minutes > 0
        ? '${minutes}m'
        : '${remainingSeconds}s';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _border.withValues(
            alpha: 0.4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fitness_center_rounded,
                color: _secondary,
                size: 22,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Workout Progress',
                  style: TextStyle(
                    color: _text,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'ALL TIME',
                style: TextStyle(
                  color: _muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          SizedBox(height: 6),

          Text(
            'Your completed workout activity.',
            style: TextStyle(
              color: _muted,
              fontSize: 10,
            ),
          ),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _workoutMetric(
                  icon: Icons.check_circle_rounded,
                  title: 'Workouts',
                  value: '$workouts',
                  color: _secondary,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _workoutMetric(
                  icon: Icons.timer_outlined,
                  title: 'Time',
                  value: timeText,
                  color: _primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _workoutMetric(
                  icon: Icons.local_fire_department_rounded,
                  title: 'Calories',
                  value: '$calories',
                  color: _warning,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _workoutMetric(
                  icon: Icons.bolt_rounded,
                  title: 'Streak',
                  value: '$streak day${streak == 1 ? '' : 's'}',
                  color: _success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _workoutMetric({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _surfaceElevated,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _muted,
                    fontSize: 9,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _text,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}

// ================================================================
// HEADER ICON
// ================================================================

class _HeaderIcon
    extends StatelessWidget {
  const _HeaderIcon();

  @override
  Widget build(
    BuildContext context,
  ) {
    final secondary = Theme.of(context).colorScheme.secondary;

    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.insights_rounded,
        color: secondary,
        size: 32,
      ),
    );
  }
}

// =================================================================
// MACRO DONUT PAINTER
// =================================================================


class MacroDonutPainter extends CustomPainter {
  final double proteinFraction;
  final double carbFraction;
  final double fatFraction;
  final Color proteinColor;
  final Color carbColor;
  final Color fatColor;
  final Color backgroundColor;

  const MacroDonutPainter({
    required this.proteinFraction,
    required this.carbFraction,
    required this.fatFraction,
    required this.proteinColor,
    required this.carbColor,
    required this.fatColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 10;
    const strokeWidth = 18.0;

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..color = backgroundColor;

    canvas.drawCircle(center, radius, backgroundPaint);

    final values = <double>[
      proteinFraction,
      carbFraction,
      fatFraction,
    ];
    final colors = <Color>[
      proteinColor,
      carbColor,
      fatColor,
    ];

    var startAngle = -math.pi / 2;

    for (var index = 0; index < values.length; index++) {
      final fraction = values[index].clamp(0.0, 1.0);
      if (fraction <= 0) {
        continue;
      }

      final sweepAngle = fraction * math.pi * 2;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..color = colors[index];

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant MacroDonutPainter oldDelegate) {
    return oldDelegate.proteinFraction != proteinFraction ||
        oldDelegate.carbFraction != carbFraction ||
        oldDelegate.fatFraction != fatFraction ||
        oldDelegate.proteinColor != proteinColor ||
        oldDelegate.carbColor != carbColor ||
        oldDelegate.fatColor != fatColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

class WeightGraphPainter extends CustomPainter {
  final List<WeightEntry> entries;
  final double minWeight;
  final double maxWeight;
  final Color lineColor;
  final Color pointColor;
  final Color pointInnerColor;
  final Color gridColor;

  const WeightGraphPainter({
    required this.entries,
    required this.minWeight,
    required this.maxWeight,
    required this.lineColor,
    required this.pointColor,
    required this.pointInnerColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) {
      return;
    }

    final chartLeft = 10.0;
    final chartRight = size.width - 10;
    final chartTop = 12.0;
    final chartBottom = size.height - 18;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;

    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = gridColor;

    for (int i = 0; i < 4; i++) {
      final y = chartTop + (chartHeight * i / 3);
      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartRight, y),
        gridPaint,
      );
    }

    final range = maxWeight - minWeight;
    final safeRange = range.abs() < 0.001 ? 1.0 : range;
    final points = <Offset>[];

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final x = entries.length == 1
          ? chartLeft + chartWidth / 2
          : chartLeft + chartWidth * i / (entries.length - 1);
      final normalized = (entry.weight - minWeight) / safeRange;
      final y = chartBottom - chartHeight * normalized;
      points.add(Offset(x, y));
    }

    if (points.length > 1) {
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);

      for (int i = 1; i < points.length; i++) {
        final previous = points[i - 1];
        final current = points[i];
        final middle = (previous.dx + current.dx) / 2;
        path.cubicTo(
          middle,
          previous.dy,
          middle,
          current.dy,
          current.dx,
          current.dy,
        );
      }

      final linePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = lineColor;

      canvas.drawPath(path, linePaint);
    }

    final outerPaint = Paint()..color = pointColor;
    final innerPaint = Paint()..color = pointInnerColor;

    for (final point in points) {
      canvas.drawCircle(point, 5, outerPaint);
      canvas.drawCircle(point, 2, innerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant WeightGraphPainter oldDelegate) {
    return oldDelegate.entries != entries ||
        oldDelegate.minWeight != minWeight ||
        oldDelegate.maxWeight != maxWeight ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.pointColor != pointColor ||
        oldDelegate.pointInnerColor != pointInnerColor ||
        oldDelegate.gridColor != gridColor;
  }
}

class NutritionBarPainter extends CustomPainter {
  final List<double> values;
  final double maxValue;
  final Color color;
  final Color backgroundColor;

  const NutritionBarPainter({
    required this.values,
    required this.maxValue,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }

    final backgroundPaint = Paint()..color = backgroundColor;
    final top = 8.0;
    final bottom = 8.0;
    final chartHeight = size.height - top - bottom;
    final gap = 6.0;
    final totalGap = gap * (values.length - 1);
    final barWidth = (size.width - totalGap) / values.length;
    final safeMax = maxValue <= 0 ? 1.0 : maxValue;

    for (int i = 0; i < values.length; i++) {
      final x = i * (barWidth + gap);
      final background = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, top, barWidth, chartHeight),
        const Radius.circular(5),
      );
      canvas.drawRRect(background, backgroundPaint);

      final normalized = (values[i] / safeMax).clamp(0.0, 1.0);
      final barHeight = chartHeight * normalized;
      if (barHeight <= 0) {
        continue;
      }

      final barTop = top + chartHeight - barHeight;
      final paint = Paint()..color = color;
      final bar = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, barTop, barWidth, barHeight),
        const Radius.circular(5),
      );
      canvas.drawRRect(bar, paint);
    }
  }

  @override
  bool shouldRepaint(covariant NutritionBarPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
