import 'package:flutter/material.dart';
import '../../services/attendance_service.dart';
import '../../services/daily_history_service.dart';
import '../food/daily_history_screen.dart';
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({
    super.key,
  });

  @override
  State<AttendanceScreen> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState
    extends State<AttendanceScreen> {
  DateTime displayedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  @override
  void initState() {
    super.initState();

    AttendanceService.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  // ============================================================
  // MONTH NAME
  // ============================================================

  String _monthName(int month) {
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
  // PREVIOUS MONTH
  // ============================================================

  void _previousMonth() {
    setState(() {
      displayedMonth = DateTime(
        displayedMonth.year,
        displayedMonth.month - 1,
        1,
      );
    });
  }

  // ============================================================
  // NEXT MONTH
  // ============================================================

  void _nextMonth() {
    final now = DateTime.now();

    final nextMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      1,
    );

    final currentMonth = DateTime(
      now.year,
      now.month,
      1,
    );

    if (nextMonth.isAfter(currentMonth)) {
      return;
    }

    setState(() {
      displayedMonth = nextMonth;
    });
  }

  // ============================================================
  // OPEN DAY
  // ============================================================

  void _openDay(DateTime date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DailyHistoryScreen(
          initialDate: date,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF020817),

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,

        title: const Text(
          'Attendance',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            18,
            8,
            18,
            30,
          ),
          children: [
            _summaryCard(),

            const SizedBox(height: 20),

            _calendarCard(),

            const SizedBox(height: 18),

            _legend(),

            const SizedBox(height: 18),

            _infoCard(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1A1034),
            Color(0xFF071A2C),
          ],
        ),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color:
              const Color(0xFF8B5CF6)
                  .withValues(alpha: 0.30),
        ),
      ),

      child: Row(
        children: [
          _stat(
            '${AttendanceService.currentStreak}',
            'Current',
            Icons.local_fire_department_rounded,
            const Color(0xFFFF9F43),
          ),

          _divider(),

          _stat(
            '${AttendanceService.longestStreak}',
            'Best',
            Icons.emoji_events_rounded,
            const Color(0xFF9B5CFF),
          ),

          _divider(),

          _stat(
            '${AttendanceService.attendanceCount}',
            'Days',
            Icons.check_circle_rounded,
            const Color(0xFF84CC16),
          ),
        ],
      ),
    );
  }

  Widget _stat(
    String value,
    String title,
    IconData icon,
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

          const SizedBox(height: 7),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 60,
      color: const Color(0xFF334155),
    );
  }

  // ============================================================
  // CALENDAR
  // ============================================================

  Widget _calendarCard() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF081226),
        borderRadius:
            BorderRadius.circular(22),
      ),

      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                ),
              ),

              Expanded(
                child: Text(
                  '${_monthName(displayedMonth.month)} '
                  '${displayedMonth.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              for (final day in [
                'M',
                'T',
                'W',
                'T',
                'F',
                'S',
                'S',
              ])
                Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          _calendarGrid(),
        ],
      ),
    );
  }

  // ============================================================
  // CALENDAR GRID
  // ============================================================

  Widget _calendarGrid() {
    final firstDay = DateTime(
      displayedMonth.year,
      displayedMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    ).day;

    final firstWeekday =
        firstDay.weekday - 1;

    final totalCells =
        ((firstWeekday + daysInMonth) / 7)
                .ceil() *
            7;

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),

      itemCount: totalCells,

      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 4,
      ),

      itemBuilder: (context, index) {
        if (index < firstWeekday) {
          return const SizedBox();
        }

        final day =
            index - firstWeekday + 1;

        if (day > daysInMonth) {
          return const SizedBox();
        }

        final date = DateTime(
          displayedMonth.year,
          displayedMonth.month,
          day,
        );

        final attended =
            AttendanceService.isPresent(
          date,
        );

        final hasFood =
            DailyHistoryService
                .hasFoodForDate(date);

        final today =
            _sameDay(
          date,
          DateTime.now(),
        );

        final isFuture =
            date.isAfter(
          DateTime.now(),
        );

        return GestureDetector(
          onTap: isFuture
              ? null
              : () => _openDay(date),

          child: Container(
            decoration: BoxDecoration(
              color: attended
                  ? const Color(0xFF84CC16)
                      .withValues(
                      alpha: 0.14,
                    )
                  : hasFood
                      ? const Color(0xFF22D3EE)
                          .withValues(
                          alpha: 0.10,
                        )
                      : today
                          ? const Color(
                              0xFF9B5CFF,
                            ).withValues(
                              alpha: 0.10,
                            )
                          : Colors.transparent,

              shape: BoxShape.circle,

              border: today
                  ? Border.all(
                      color:
                          const Color(
                        0xFF9B5CFF,
                      ),
                    )
                  : null,
            ),

            child: Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    '$day',
                    style: TextStyle(
                      color: isFuture
                          ? const Color(
                              0xFF334155,
                            )
                          : attended
                              ? const Color(
                                  0xFFB7F34A,
                                )
                              : Colors.white,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Container(
                    width: 4,
                    height: 4,
                    decoration:
                        BoxDecoration(
                      color: attended
                          ? const Color(
                              0xFF84CC16,
                            )
                          : hasFood
                              ? const Color(
                                  0xFF22D3EE,
                                )
                              : const Color(
                                  0xFF334155,
                                ),
                      shape:
                          BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // LEGEND
  // ============================================================

  Widget _legend() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF081226),
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          _legendItem(
            const Color(0xFF84CC16),
            'Attendance',
          ),

          const SizedBox(width: 18),

          _legendItem(
            const Color(0xFF22D3EE),
            'Food logged',
          ),

          const SizedBox(width: 18),

          _legendItem(
            const Color(0xFF334155),
            'No activity',
          ),
        ],
      ),
    );
  }

  Widget _legendItem(
    Color color,
    String text,
  ) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 6),

          Flexible(
            child: Text(
              text,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                color:
                    Color(0xFF64748B),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO
  // ============================================================

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: const Color(0xFF0B1224),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF334155),
        ),
      ),

      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.touch_app_rounded,
            color: Color(0xFF9B5CFF),
          ),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              'Tap any completed day to open its full daily nutrition history.',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SAME DAY
  // ============================================================

  bool _sameDay(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}