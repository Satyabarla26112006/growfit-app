import 'package:flutter/material.dart';

import '../../data/workout_data.dart';
import '../../models/workout_model.dart';
import 'workout_history_screen.dart';
import 'workout_detail_screen.dart';
import 'exercise_screen.dart';

/// GrowFit workout discovery screen.
///
/// This screen is intentionally data-driven. It reads the curated workout
/// catalog instead of maintaining a second hard-coded list in the UI.
class WorkoutHomeScreen extends StatefulWidget {
  const WorkoutHomeScreen({super.key});

  @override
  State<WorkoutHomeScreen> createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen> {
  WorkoutEnvironment _environment = WorkoutEnvironment.gym;
  WorkoutCategory _category = WorkoutCategory.allWorkouts;
  String _query = '';

  static const List<WorkoutCategory> _gymCategories = [
    WorkoutCategory.allWorkouts,
    WorkoutCategory.push,
    WorkoutCategory.pull,
    WorkoutCategory.legs,
    WorkoutCategory.strength,
    WorkoutCategory.cardio,
    WorkoutCategory.hiit,
  ];

  static const List<WorkoutCategory> _homeCategories = [
    WorkoutCategory.allWorkouts,
    WorkoutCategory.push,
    WorkoutCategory.pull,
    WorkoutCategory.legs,
    WorkoutCategory.strength,
    WorkoutCategory.cardio,
    WorkoutCategory.hiit,
  ];

  List<WorkoutCategory> get _categories =>
      _environment == WorkoutEnvironment.gym
          ? _gymCategories
          : _homeCategories;

  List<WorkoutModel> get _environmentWorkouts {
    final source = WorkoutData.byEnvironment(_environment);

    if (_category == WorkoutCategory.allWorkouts) {
      return source;
    }

    return source
        .where((workout) => workout.category == _category)
        .toList(growable: false);
  }

  List<WorkoutModel> get _filteredWorkouts {
    final query = _query.trim().toLowerCase();
    final source = _environmentWorkouts;

    if (query.isEmpty) {
      return source;
    }

    return source.where((workout) {
      return workout.title.toLowerCase().contains(query) ||
          workout.description.toLowerCase().contains(query) ||
          workout.categoryLabel.toLowerCase().contains(query) ||
          workout.difficultyLabel.toLowerCase().contains(query) ||
          workout.exercises.any(
            (exercise) => exercise.name.toLowerCase().contains(query),
          );
    }).toList(growable: false);
  }

  List<WorkoutModel> get _featuredWorkouts {
    final source = _environmentWorkouts
        .where((workout) => workout.isFeatured)
        .toList(growable: false);

    return source.isEmpty ? _environmentWorkouts.take(4).toList() : source;
  }

  void _setEnvironment(WorkoutEnvironment environment) {
    if (_environment == environment) {
      return;
    }

    setState(() {
      _environment = environment;
      _category = WorkoutCategory.allWorkouts;
    });
  }

  void _setCategory(WorkoutCategory category) {
    setState(() {
      _category = category;
    });
  }

  void _openWorkout(WorkoutModel workout) {
    if (workout.exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This workout does not have exercises yet.'),
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _WorkoutPreviewSheet(
        workout: workout,
        onOpenWorkout: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WorkoutDetailScreen(
                workout: workout,
              ),
            ),
          );
        },
        onOpenExercise: (exerciseIndex) {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WorkoutDetailScreen(
                exercise: workout.exercises[exerciseIndex],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openExerciseLibrary() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ExerciseScreen(),
      ),
    );
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const WorkoutHistoryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final background = theme.scaffoldBackgroundColor;
    final surface = colors.surface;
    final primary = colors.primary;
    final text = colors.onSurface;
    final muted = text.withValues(alpha: 0.62);
    final workouts = _filteredWorkouts;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        title: Text(
          'Workouts',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Exercise library',
            onPressed: _openExerciseLibrary,
            icon: Icon(Icons.menu_book_rounded, color: primary),
          ),
          IconButton(
            tooltip: 'Workout history',
            onPressed: _openHistory,
            icon: Icon(Icons.history_rounded, color: primary),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _introCard(
                    context,
                    primary: primary,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 18),
                  _environmentToggle(
                    context,
                    primary: primary,
                    surface: surface,
                    text: text,
                    muted: muted,
                  ),
                  const SizedBox(height: 18),
                  _searchField(
                    context,
                    primary: primary,
                    surface: surface,
                    muted: muted,
                  ),
                  const SizedBox(height: 18),
                  _sectionHeader(
                    context,
                    title: 'Training focus',
                    subtitle: '${_environment.label} workouts',
                  ),
                  const SizedBox(height: 12),
                  _categoryStrip(
                    context,
                    primary: primary,
                    surface: surface,
                    text: text,
                    muted: muted,
                  ),
                  const SizedBox(height: 24),
                  _sectionHeader(
                    context,
                    title: 'Featured',
                    subtitle: '${_featuredWorkouts.length} plans',
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 202,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _featuredWorkouts.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 285,
                          child: _featuredCard(
                            context,
                            _featuredWorkouts[index],
                            primary: primary,
                            isDark: isDark,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 26),
                  _sectionHeader(
                    context,
                    title: _category == WorkoutCategory.allWorkouts
                        ? 'All workouts'
                        : _category.label,
                    subtitle: '${workouts.length} available',
                  ),
                  const SizedBox(height: 12),
                  if (workouts.isEmpty)
                    _emptyState(
                      context,
                      primary: primary,
                      muted: muted,
                    )
                  else
                    ...workouts.map(
                      (workout) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _workoutCard(
                          context,
                          workout,
                          primary: primary,
                          surface: surface,
                          text: text,
                          muted: muted,
                        ),
                      ),
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _introCard(
    BuildContext context, {
    required Color primary,
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = colors.onPrimary;
    final secondary = colors.onPrimary.withValues(alpha: 0.76);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary,
            Color.lerp(primary, isDark ? colors.surface : colors.onPrimary, 0.32)!,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: colors.onPrimary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.bolt_rounded,
              color: colors.onPrimary,
              size: 32,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Train with purpose.',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Real plans. Real exercise sequences. Built around your training environment.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: secondary,
                    height: 1.45,
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

  Widget _environmentToggle(
    BuildContext context, {
    required Color primary,
    required Color surface,
    required Color text,
    required Color muted,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: text.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          _environmentButton(
            context,
            environment: WorkoutEnvironment.gym,
            icon: Icons.fitness_center_rounded,
            primary: primary,
            text: text,
            muted: muted,
          ),
          _environmentButton(
            context,
            environment: WorkoutEnvironment.home,
            icon: Icons.home_rounded,
            primary: primary,
            text: text,
            muted: muted,
          ),
        ],
      ),
    );
  }

  Widget _environmentButton(
    BuildContext context, {
    required WorkoutEnvironment environment,
    required IconData icon,
    required Color primary,
    required Color text,
    required Color muted,
  }) {
    final selected = _environment == environment;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _setEnvironment(environment),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: selected ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? Theme.of(context).colorScheme.onPrimary : muted,
              ),
              const SizedBox(width: 8),
              Text(
                environment.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected ? Theme.of(context).colorScheme.onPrimary : text,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchField(
    BuildContext context, {
    required Color primary,
    required Color surface,
    required Color muted,
  }) {
    return TextField(
      onChanged: (value) => setState(() => _query = value),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search workouts or exercises',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  setState(() => _query = '');
                },
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: muted),
        prefixIconColor: primary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: primary.withValues(alpha: 0.55)),
        ),
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _categoryStrip(
    BuildContext context, {
    required Color primary,
    required Color surface,
    required Color text,
    required Color muted,
  }) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final selected = _category == category;

          return ChoiceChip(
            label: Text(category.label),
            avatar: Icon(
              category.icon,
              size: 17,
              color: selected ? Theme.of(context).colorScheme.onPrimary : muted,
            ),
            selected: selected,
            onSelected: (_) => _setCategory(category),
            selectedColor: primary,
            backgroundColor: surface,
            labelStyle: TextStyle(
              color: selected ? Theme.of(context).colorScheme.onPrimary : text,
              fontWeight: FontWeight.w800,
            ),
            side: BorderSide(
              color: selected
                  ? primary
                  : text.withValues(alpha: 0.08),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          );
        },
      ),
    );
  }

  Widget _featuredCard(
    BuildContext context,
    WorkoutModel workout, {
    required Color primary,
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final accent = Color.lerp(primary, colors.onSurface, 0.12)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _openWorkout(workout),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.surfaceContainerHighest,
                Color.lerp(
                  colors.surfaceContainerHighest,
                  primary,
                  isDark ? 0.15 : 0.06,
                )!,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: primary.withValues(alpha: 0.20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      workout.category.icon,
                      color: primary,
                    ),
                  ),
                  const Spacer(),
                  _tag(
                    context,
                    workout.environmentLabel,
                    background: primary.withValues(alpha: 0.10),
                    foreground: primary,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                workout.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                workout.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.60),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _miniStat(
                    context,
                    Icons.schedule_rounded,
                    '${workout.durationMinutes} min',
                    primary,
                  ),
                  const SizedBox(width: 12),
                  _miniStat(
                    context,
                    Icons.local_fire_department_rounded,
                    '${workout.estimatedCalories} kcal',
                    primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _workoutCard(
    BuildContext context,
    WorkoutModel workout, {
    required Color primary,
    required Color surface,
    required Color text,
    required Color muted,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _openWorkout(workout),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: text.withValues(alpha: 0.07)),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  workout.category.icon,
                  color: primary,
                  size: 25,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      workout.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: muted,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 7,
                      runSpacing: 6,
                      children: [
                        _tag(
                          context,
                          workout.difficultyLabel,
                          background: primary.withValues(alpha: 0.09),
                          foreground: primary,
                        ),
                        _tag(
                          context,
                          '${workout.exerciseCount} exercises',
                          background: text.withValues(alpha: 0.06),
                          foreground: muted,
                        ),
                        _tag(
                          context,
                          '${workout.durationMinutes} min',
                          background: text.withValues(alpha: 0.06),
                          foreground: muted,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.chevron_right_rounded,
                color: muted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(
    BuildContext context,
    String label, {
    required Color background,
    required Color foreground,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _miniStat(
    BuildContext context,
    IconData icon,
    String label,
    Color primary,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: primary),
        const SizedBox(width: 5),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _emptyState(
    BuildContext context, {
    required Color primary,
    required Color muted,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 34, color: primary),
          const SizedBox(height: 10),
          Text(
            'No workouts found',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Try another category or search term.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutPreviewSheet extends StatelessWidget {
  const _WorkoutPreviewSheet({
    required this.workout,
    required this.onOpenWorkout,
    required this.onOpenExercise,
  });

  final WorkoutModel workout;
  final VoidCallback onOpenWorkout;
  final ValueChanged<int> onOpenExercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final primary = colors.primary;

    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 720),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(workout.category.icon, color: primary),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${workout.environmentLabel} • ${workout.difficultyLabel} • ${workout.durationMinutes} min',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.58),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              child: Text(
                workout.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.66),
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: _sheetStat(
                      context,
                      icon: Icons.fitness_center_rounded,
                      label: '${workout.exerciseCount} exercises',
                      primary: primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _sheetStat(
                      context,
                      icon: Icons.local_fire_department_rounded,
                      label: '${workout.estimatedCalories} kcal',
                      primary: primary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: onOpenWorkout,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('View Full Workout'),
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                itemCount: workout.exercises.length,
                separatorBuilder: (_, _) => const SizedBox(height: 9),
                itemBuilder: (context, index) {
                  final exercise = workout.exercises[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => onOpenExercise(index),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colors.onSurface.withValues(alpha: 0.035),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.10),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: primary,
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${exercise.sets} sets • ${exercise.repetitions} reps • ${exercise.restSeconds}s rest',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colors.onSurface.withValues(alpha: 0.58),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: colors.onSurface.withValues(alpha: 0.42),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetStat(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color primary,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
