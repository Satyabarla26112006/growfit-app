import 'package:flutter/material.dart';

import '../../models/food_log_model.dart';
import '../../services/attendance_service.dart';
import '../../services/daily_history_service.dart';

class DailyHistoryScreen extends StatefulWidget {
  const DailyHistoryScreen({
    super.key,
    this.initialDate,
  });

  final DateTime? initialDate;

  @override
  State<DailyHistoryScreen> createState() =>
      _DailyHistoryScreenState();
}

class _DailyHistoryScreenState
    extends State<DailyHistoryScreen> {
  late DateTime selectedDate;

  Color get _background => Theme.of(context).scaffoldBackgroundColor;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _muted =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.58);
  Color get _primary => Theme.of(context).colorScheme.primary;
  Color get _secondary => Theme.of(context).colorScheme.secondary;
  Color get _success => Theme.of(context).colorScheme.tertiary;

  @override
  void initState() {
    super.initState();

    selectedDate =
        widget.initialDate ??
        DateTime.now();

    AttendanceService.initialize();
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              surface: Theme.of(context).colorScheme.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) {
      return;
    }

    setState(() {
      selectedDate = picked;
    });
  }

  // ============================================================
  // DATE TEXT
  // ============================================================

  String _dateText() {
    final now = DateTime.now();

    if (_sameDay(
      selectedDate,
      now,
    )) {
      return 'Today';
    }

    final yesterday =
        now.subtract(
      const Duration(days: 1),
    );

    if (_sameDay(
      selectedDate,
      yesterday,
    )) {
      return 'Yesterday';
    }

    return '${_monthName(selectedDate.month)} '
        '${selectedDate.day}, '
        '${selectedDate.year}';
  }

  bool _sameDay(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  String _monthName(
    int month,
  ) {
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

    return months[month - 1];
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final logs =
        DailyHistoryService
            .getLogsForDate(
      selectedDate,
    );

    final calories =
        DailyHistoryService
            .caloriesForDate(
      selectedDate,
    );

    final protein =
        DailyHistoryService
            .proteinForDate(
      selectedDate,
    );

    final carbs =
        DailyHistoryService
            .carbsForDate(
      selectedDate,
    );

    final fats =
        DailyHistoryService
            .fatsForDate(
      selectedDate,
    );

    final attended =
        AttendanceService.isPresent(
      selectedDate,
    );

    return Scaffold(
      backgroundColor:
          _background,

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,

        title: const Text(
          'Daily History',
          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.w800,
          ),
        ),

        actions: [
          IconButton(
            onPressed: _selectDate,
            icon: Icon(
              Icons.calendar_month_rounded,
              color:
                  _primary,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.fromLTRB(
            18,
            8,
            18,
            30,
          ),
          children: [
            _dateCard(),

            const SizedBox(height: 16),

            _attendanceCard(
              attended: attended,
            ),

            const SizedBox(height: 16),

            _streakCard(),

            const SizedBox(height: 18),

            _nutritionCard(
              calories: calories,
              protein: protein,
              carbs: carbs,
              fats: fats,
            ),

            const SizedBox(height: 20),

            if (logs.isEmpty)
              _emptyState()
            else
              ..._buildMealSections(
                logs,
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DATE CARD
  // ============================================================

  Widget _dateCard() {
    return GestureDetector(
      onTap: _selectDate,

      child: Container(
        padding:
            const EdgeInsets.all(20),

        decoration: BoxDecoration(
          gradient:
              LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.16),
              Theme.of(context).colorScheme.surface,
            ],
          ),

          borderRadius:
              BorderRadius.circular(22),

          border: Border.all(
            color:
                _primary
                    .withValues(
              alpha: 0.35,
            ),
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,

              decoration:
                  BoxDecoration(
                color:
                    _primary
                        .withValues(
                  alpha: 0.14,
                ),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),

              child: Icon(
                Icons.calendar_today_rounded,
                color:
                    _primary,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECTED DAY',
                    style: TextStyle(
                      color:
                          _muted,
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _dateText(),
                    style:
                        TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color:
                  _muted,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ATTENDANCE CARD
  // ============================================================

  Widget _attendanceCard({
    required bool attended,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color:
            _surface,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: attended
              ? _success
                  .withValues(
                  alpha: 0.25,
                )
              : Theme.of(context).colorScheme.outline,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,

            decoration:
                BoxDecoration(
              color: attended
                  ? _success.withValues(
                      alpha: 0.13,
                    )
                  : _muted.withValues(
                      alpha: 0.12,
                    ),
              shape:
                  BoxShape.circle,
            ),

            child: Icon(
              attended
                  ? Icons
                      .check_rounded
                  : Icons
                      .remove_rounded,
              color: attended
                  ? _success
                  : _muted,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  attended
                      ? 'Attendance Complete'
                      : 'No Attendance',
                  style:
                      TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  attended
                      ? 'You logged activity on this day.'
                      : 'No food activity was recorded.',
                  style:
                      TextStyle(
                    color:
                        _muted,
                    fontSize: 11,
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
  // STREAK CARD
  // ============================================================

  Widget _streakCard() {
    return Container(
      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient:
            LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
            Theme.of(context).colorScheme.surface,
          ],
        ),

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color:
              _primary
                  .withValues(
            alpha: 0.20,
          ),
        ),
      ),

      child: Row(
        children: [
          _streakItem(
            Icons.local_fire_department_rounded,
            '${AttendanceService.currentStreak}',
            'Current',
            Theme.of(context).colorScheme.tertiary,
          ),

          _verticalDivider(),

          _streakItem(
            Icons.emoji_events_rounded,
            '${AttendanceService.longestStreak}',
            'Best',
            _primary,
          ),

          _verticalDivider(),

          _streakItem(
            Icons.calendar_month_rounded,
            '${AttendanceService.attendanceCount}',
            'Days',
            _secondary,
          ),
        ],
      ),
    );
  }

  Widget _streakItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 22,
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style:
                TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            style:
                TextStyle(
              color:
                  _muted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 55,
      color:
          Theme.of(context).colorScheme.outline,
    );
  }

  // ============================================================
  // NUTRITION
  // ============================================================

  Widget _nutritionCard({
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color:
            _surface,
        borderRadius:
            BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'DAILY NUTRITION',
            style: TextStyle(
              color:
                  _muted,
              fontSize: 10,
              fontWeight:
                  FontWeight.w700,
              letterSpacing: 1.3,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            '${calories.round()} kcal',
            style:
                TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _macro(
                  'Protein',
                  protein,
                  _primary,
                ),
              ),
              Expanded(
                child: _macro(
                  'Carbs',
                  carbs,
                  _secondary,
                ),
              ),
              Expanded(
                child: _macro(
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

  Widget _macro(
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
          style:
              TextStyle(
            color:
                _muted,
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
  // MEAL SECTIONS
  // ============================================================

  List<Widget> _buildMealSections(
    List<FoodLogModel> logs,
  ) {
    final sections =
        <Widget>[];

    final breakfast =
        _mealLogs(
      logs,
      'breakfast',
    );

    final lunch =
        _mealLogs(
      logs,
      'lunch',
    );

    final dinner =
        _mealLogs(
      logs,
      'dinner',
    );

    final snacks =
        logs.where((log) {
      final meal =
          log.mealType.toLowerCase();

      return meal == 'snack' ||
          meal == 'snacks';
    }).toList();

    if (breakfast.isNotEmpty) {
      sections.add(
        _mealSection(
          'Breakfast',
          breakfast,
          Theme.of(context).colorScheme.tertiary,
          Icons.wb_sunny_rounded,
        ),
      );
    }

    if (lunch.isNotEmpty) {
      sections.add(
        _mealSection(
          'Lunch',
          lunch,
          _primary,
          Icons.light_mode_rounded,
        ),
      );
    }

    if (dinner.isNotEmpty) {
      sections.add(
        _mealSection(
          'Dinner',
          dinner,
          Theme.of(context).colorScheme.secondary,
          Icons.restaurant_rounded,
        ),
      );
    }

    if (snacks.isNotEmpty) {
      sections.add(
        _mealSection(
          'Snacks',
          snacks,
          _secondary,
          Icons.nightlight_round,
        ),
      );
    }

    return sections;
  }

  List<FoodLogModel> _mealLogs(
    List<FoodLogModel> logs,
    String meal,
  ) {
    return logs
        .where(
          (log) =>
              log.mealType
                  .toLowerCase() ==
              meal,
        )
        .toList();
  }

  // ============================================================
  // MEAL SECTION
  // ============================================================

  Widget _mealSection(
    String title,
    List<FoodLogModel> logs,
    Color color,
    IconData icon,
  ) {
    final total =
        logs.fold<double>(
      0,
      (sum, log) =>
          sum + log.calories,
    );

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color:
            _surface,
        borderRadius:
            BorderRadius.circular(22),
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
                      color.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                child: Icon(
                  icon,
                  color: color,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style:
                      TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              Text(
                '${total.round()} kcal',
                style:
                    TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.82),
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Divider(
            color:
                Theme.of(context).colorScheme.outlineVariant,
          ),

          for (final log in logs)
            _foodRow(log),
        ],
      ),
    );
  }

  // ============================================================
  // FOOD ROW
  // ============================================================

  Widget _foodRow(
    FoodLogModel log,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 11,
      ),

      child: Row(
        children: [
          Icon(
            Icons.restaurant_rounded,
            color:
                _primary,
            size: 20,
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
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '${log.quantity.round()} ${log.servingUnit}',
                  style:
                      TextStyle(
                    color:
                        _muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '${log.calories.round()} kcal',
            style:
                TextStyle(
              color:
                  _secondary,
              fontSize: 12,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _emptyState() {
    return Container(
      padding:
          const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color:
            _surface,
        borderRadius:
            BorderRadius.circular(22),
      ),

      child: Column(
        children: [
          Icon(
            Icons.history_rounded,
            color:
                _muted,
            size: 48,
          ),

          const SizedBox(height: 15),

          const Text(
            'No Food Logged',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'There is no food history for '
            '${_dateText().toLowerCase()}.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  _muted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}