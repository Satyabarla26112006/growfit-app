import 'package:flutter/material.dart';

import '../../models/exercise_model.dart';
import '../../models/workout_model.dart';
import 'start_workout_screen.dart';

/// Shows either a complete WorkoutModel or the legacy ExerciseModel detail.
///
/// Workout discovery now opens the complete plan while the existing exercise
/// library remains compatible with the legacy `exercise:` constructor.
class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({
    super.key,
    this.workout,
    this.exercise,
  }) : assert(
          workout != null || exercise != null,
          'Provide either workout or exercise.',
        );

  final WorkoutModel? workout;
  final ExerciseModel? exercise;

  bool get _isWorkout => workout != null;

  WorkoutModel get _workout => workout!;
  ExerciseModel get _exercise => exercise!;

  @override
  Widget build(BuildContext context) {
    return _isWorkout
        ? _WorkoutPlanDetail(workout: _workout)
        : _ExerciseDetail(exercise: _exercise);
  }
}

class _WorkoutPlanDetail extends StatelessWidget {
  const _WorkoutPlanDetail({
    required this.workout,
  });

  final WorkoutModel workout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        title: const Text(
          'Workout Details',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
          children: [
            _WorkoutHero(workout: workout),
            const SizedBox(height: 14),
            _WorkoutStats(workout: workout),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'About This Workout',
              icon: workout.category.icon,
              child: Text(
                workout.description.isEmpty
                    ? 'A structured ${workout.environmentLabel.toLowerCase()} workout.'
                    : workout.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.68),
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'Workout Overview',
              icon: Icons.dashboard_customize_rounded,
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.place_rounded,
                    title: 'Environment',
                    value: workout.environmentLabel,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: workout.category.icon,
                    title: 'Category',
                    value: workout.categoryLabel,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.speed_rounded,
                    title: 'Difficulty',
                    value: workout.difficultyLabel,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.schedule_rounded,
                    title: 'Estimated time',
                    value: workout.durationLabel,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'Exercise Sequence',
              icon: Icons.format_list_numbered_rounded,
              child: Column(
                children: [
                  if (workout.exercises.isEmpty)
                    Text(
                      'Exercises are not available for this workout.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.62),
                      ),
                    )
                  else
                    ...List.generate(
                      workout.exercises.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index == workout.exercises.length - 1
                              ? 0
                              : 10,
                        ),
                        child: _ExercisePlanTile(
                          index: index,
                          exercise: workout.exercises[index],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: workout.exercises.isEmpty
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => StartWorkoutScreen(
                              workout: workout,
                            ),
                          ),
                        );
                      },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text(
                  'Start Full Workout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
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

class _WorkoutHero extends StatelessWidget {
  const _WorkoutHero({
    required this.workout,
  });

  final WorkoutModel workout;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withValues(alpha: 0.20),
            scheme.surfaceContainerHighest.withValues(alpha: 0.75),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: primary.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              workout.category.icon,
              color: primary,
              size: 31,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            workout.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${workout.environmentLabel} • ${workout.categoryLabel}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutStats extends StatelessWidget {
  const _WorkoutStats({
    required this.workout,
  });

  final WorkoutModel workout;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.timer_outlined,
            label: 'TIME',
            value: '${workout.durationMinutes} min',
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department_rounded,
            label: 'CALORIES',
            value: '${workout.estimatedCalories} kcal',
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _StatCard(
            icon: Icons.format_list_numbered_rounded,
            label: 'EXERCISES',
            value: '${workout.exerciseCount}',
          ),
        ),
      ],
    );
  }
}

class _ExercisePlanTile extends StatelessWidget {
  const _ExercisePlanTile({
    required this.index,
    required this.exercise,
  });

  final int index;
  final ExerciseModel exercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final dosage = exercise.repetitions == 1
        ? '${exercise.sets} sets • Hold'
        : '${exercise.sets} sets • ${exercise.repetitions} reps';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: scheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.11),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dosage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.62),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${exercise.muscleGroup} • ${exercise.equipmentName} • ${exercise.restSeconds}s rest',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.48),
                    fontWeight: FontWeight.w600,
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scheme.onSurface.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: scheme.primary,
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.48),
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: scheme.primary,
          size: 19,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.55),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: scheme.onSurface.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: scheme.primary,
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

/// Existing single-exercise detail flow retained for the exercise library.
class _ExerciseDetail extends StatelessWidget {
  const _ExerciseDetail({
    required this.exercise,
  });

  final ExerciseModel exercise;

  void _startWorkout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StartWorkoutScreen(
          exercise: exercise,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        title: const Text(
          'Exercise Details',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          children: [
            _exerciseHero(context),
            const SizedBox(height: 18),
            _exerciseStats(context),
            const SizedBox(height: 18),
            _SectionCard(
              title: 'About This Exercise',
              icon: Icons.info_outline_rounded,
              child: Text(
                exercise.description.isEmpty
                    ? 'No description available.'
                    : exercise.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.68),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              title: 'Workout Plan',
              icon: Icons.fitness_center_rounded,
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.repeat_rounded,
                    title: 'Sets',
                    value: '${exercise.sets}',
                  ),
                  const SizedBox(height: 11),
                  _InfoRow(
                    icon: Icons.format_list_numbered_rounded,
                    title: 'Repetitions',
                    value: exercise.repetitions == 1
                        ? 'Hold'
                        : '${exercise.repetitions}',
                  ),
                  const SizedBox(height: 11),
                  _InfoRow(
                    icon: Icons.hourglass_bottom_rounded,
                    title: 'Rest',
                    value: '${exercise.restSeconds} sec',
                  ),
                  const SizedBox(height: 11),
                  _InfoRow(
                    icon: Icons.sports_gymnastics_rounded,
                    title: 'Equipment',
                    value: exercise.equipmentName,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              title: 'How To Perform',
              icon: Icons.menu_book_rounded,
              child: exercise.instructions.isEmpty
                  ? Text(
                      'Follow a comfortable and controlled movement pattern.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.64),
                        height: 1.5,
                      ),
                    )
                  : Column(
                      children: List.generate(
                        exercise.instructions.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: index == exercise.instructions.length - 1
                                ? 0
                                : 12,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      scheme.primary.withValues(alpha: 0.10),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: scheme.primary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  exercise.instructions[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: scheme.onSurface
                                            .withValues(alpha: 0.70),
                                        height: 1.5,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _startWorkout(context),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text(
                  'Start Exercise',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _exerciseHero(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.18),
            scheme.surfaceContainerHighest.withValues(alpha: 0.80),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: scheme.primary.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              _categoryIcon(exercise.category),
              color: scheme.primary,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            exercise.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '${exercise.category} • ${exercise.muscleGroup}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _exerciseStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.timer_outlined,
            label: 'TIME',
            value: '${exercise.durationMinutes} min',
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department_rounded,
            label: 'CALORIES',
            value: '${exercise.estimatedCalories.round()} kcal',
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _StatCard(
            icon: Icons.speed_rounded,
            label: 'LEVEL',
            value: exercise.difficultyName,
          ),
        ),
      ],
    );
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'beginner':
        return Icons.directions_walk_rounded;
      case 'strength':
        return Icons.fitness_center_rounded;
      case 'cardio':
        return Icons.directions_run_rounded;
      case 'home workout':
        return Icons.home_rounded;
      case 'gym workout':
        return Icons.sports_gymnastics_rounded;
      case 'stretching':
        return Icons.self_improvement_rounded;
      default:
        return Icons.fitness_center_rounded;
    }
  }
}
