import 'package:flutter/material.dart';

import '../../models/workout_history_model.dart';
import '../../services/attendance_service.dart';
import '../../services/workout_history_service.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({
    super.key,
  });

  @override
  State<WorkoutHistoryScreen> createState() =>
      _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState
    extends State<WorkoutHistoryScreen> {
  bool _loading = true;

  List<WorkoutHistoryModel> _history = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ============================================================
  // LOAD DATA
  // ============================================================

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
    });

    await Future.wait([
      WorkoutHistoryService.initialize(),
      AttendanceService.initialize(),
    ]);

    if (!mounted) {
      return;
    }

    setState(() {
      _history = WorkoutHistoryService.history;
      _loading = false;
    });
  }

  // ============================================================
  // CLEAR WORKOUT HISTORY
  // ============================================================

  Future<void> _clearAll() async {
    if (_history.isEmpty) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final scheme = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            'Clear workout history?',
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            'Saved workout sessions will be removed. '
            'Attendance records remain available.',
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.68),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    await WorkoutHistoryService.clearHistory();

    if (!mounted) {
      return;
    }

    setState(() {
      _history = [];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Workout history cleared. Attendance was kept.',
        ),
      ),
    );
  }

  // ============================================================
  // DELETE ONE WORKOUT
  // ============================================================

  Future<void> _deleteWorkout(
    WorkoutHistoryModel workout,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final scheme = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            'Delete workout?',
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            'Remove ${workout.exerciseName} from workout history?',
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.68),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    await WorkoutHistoryService.removeWorkout(workout.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _history = WorkoutHistoryService.history;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Workout deleted from history.',
        ),
      ),
    );
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
        backgroundColor: scheme.surface,
        elevation: 0,
        title: Text(
          'Workout History',
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          if (!_loading && _history.isNotEmpty)
            IconButton(
              tooltip: 'Clear History',
              onPressed: _clearAll,
              icon: Icon(
                Icons.delete_sweep_rounded,
                color: scheme.primary,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(
                  color: scheme.primary,
                ),
              )
            : RefreshIndicator(
                color: scheme.primary,
                onRefresh: _loadData,
                child: _historyContent(),
              ),
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _historyContent() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(
        18,
        8,
        18,
        30,
      ),
      children: [
        _summaryCard(),
        const SizedBox(height: 14),
        _attendanceCard(),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  final scheme = Theme.of(context).colorScheme;
                  return Text(
                    'Recent Workouts',
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  );
                },
              ),
            ),
            if (_history.isNotEmpty)
              Text(
                '${_history.length} session${_history.length == 1 ? '' : 's'}',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.62),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_history.isEmpty)
          _emptyState()
        else
          ..._history.map(_historyCard),
      ],
    );
  }

  // ============================================================
  // WORKOUT SUMMARY
  // ============================================================

  Widget _summaryCard() {
    final scheme = Theme.of(context).colorScheme;
    final workouts = WorkoutHistoryService.completedWorkoutCount;
    final calories = WorkoutHistoryService.totalCalories;
    final seconds = WorkoutHistoryService.totalDurationSeconds;
    final streak = WorkoutHistoryService.currentStreak;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(scheme.primary, scheme.surface, 0.18)!,
            scheme.surfaceContainerHighest,
            scheme.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: scheme.primary.withValues(alpha: 0.24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Workout Stats',
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  icon: Icons.fitness_center_rounded,
                  title: 'Workouts',
                  value: '$workouts',
                  color: scheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _summaryItem(
                  icon: Icons.local_fire_department_rounded,
                  title: 'Calories',
                  value: '$calories',
                  color: scheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  icon: Icons.timer_outlined,
                  title: 'Total Time',
                  value: _formatTotalTime(seconds),
                  color: scheme.tertiary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _summaryItem(
                  icon: Icons.local_fire_department_rounded,
                  title: 'Workout Streak',
                  value: '$streak day${streak == 1 ? '' : 's'}',
                  color: scheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 7),
          Text(
            title,
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.55),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ATTENDANCE SUMMARY
  // ============================================================

  Widget _attendanceCard() {
    final scheme = Theme.of(context).colorScheme;
    final attendanceDays = AttendanceService.attendanceCount;
    final gymDays = AttendanceService.gymDayCount;
    final homeDays = AttendanceService.homeDayCount;
    final restDays = AttendanceService.restDayCount;
    final currentStreak = AttendanceService.currentStreak;
    final longestStreak = AttendanceService.longestStreak;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: scheme.primary.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  color: scheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Attendance Overview',
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _attendanceStat(
                  icon: Icons.event_available_rounded,
                  label: 'Workout Days',
                  value: '$attendanceDays',
                ),
              ),
              Expanded(
                child: _attendanceStat(
                  icon: Icons.fitness_center_rounded,
                  label: 'Gym',
                  value: '$gymDays',
                ),
              ),
              Expanded(
                child: _attendanceStat(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  value: '$homeDays',
                ),
              ),
              Expanded(
                child: _attendanceStat(
                  icon: Icons.hotel_rounded,
                  label: 'Rest',
                  value: '$restDays',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _streakStat(
                  title: 'Current streak',
                  value:
                      '$currentStreak day${currentStreak == 1 ? '' : 's'}',
                  icon: Icons.local_fire_department_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _streakStat(
                  title: 'Longest streak',
                  value:
                      '$longestStreak day${longestStreak == 1 ? '' : 's'}',
                  icon: Icons.emoji_events_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Attendance is recorded separately from workout history, so clearing history does not erase attendance.',
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.62),
              fontSize: 10,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(icon, color: scheme.primary, size: 18),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: scheme.onSurface.withValues(alpha: 0.62),
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _streakStat({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.62),
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 11,
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

  // ============================================================
  // HISTORY CARD
  // ============================================================

  Widget _historyCard(
    WorkoutHistoryModel workout,
  ) {
    final scheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(workout.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        await _deleteWorkout(workout);
        return false;
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete_rounded,
          color: scheme.onErrorContainer,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.48),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: scheme.onSurface.withValues(alpha: 0.10),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                _categoryIcon(workout.category),
                color: scheme.primary,
                size: 25,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.exerciseName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    workout.muscleGroup,
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.62),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 5,
                    children: [
                      _tag(workout.dateLabel),
                      _tag(workout.durationLabel),
                      _tag('${workout.completedSets} sets'),
                      _tag('${workout.estimatedCalories} kcal'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.62),
          fontSize: 8,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _emptyState() {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        24,
        28,
        24,
        30,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: scheme.onSurface.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fitness_center_rounded,
              color: scheme.primary,
              size: 38,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No workouts yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Complete a workout and it will appear here automatically.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.62),
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  String _formatTotalTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }

    if (minutes > 0) {
      return '${minutes}m';
    }

    return '${seconds}s';
  }

  IconData _categoryIcon(String category) {
    switch (category.trim().toLowerCase()) {
      case 'beginner':
        return Icons.directions_walk_rounded;
      case 'strength':
        return Icons.fitness_center_rounded;
      case 'cardio':
        return Icons.directions_run_rounded;
      case 'home workout':
      case 'home':
        return Icons.home_rounded;
      case 'gym workout':
      case 'gym':
        return Icons.sports_gymnastics_rounded;
      case 'stretching':
      case 'mobility':
      case 'yoga':
        return Icons.self_improvement_rounded;
      case 'push':
        return Icons.fitness_center_rounded;
      case 'pull':
        return Icons.rowing_rounded;
      case 'legs':
        return Icons.directions_run_rounded;
      case 'hiit':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.fitness_center_rounded;
    }
  }
}
