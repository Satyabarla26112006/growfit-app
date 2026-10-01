import 'package:flutter/material.dart';

import '../../data/exercise_data.dart';
import '../../models/exercise_model.dart';
import 'workout_detail_screen.dart';

/// Step 8: unified exercise library.
///
/// Uses the existing ExerciseData catalog as the single source of truth and
/// keeps the existing ExerciseModel -> WorkoutDetailScreen flow intact.
class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({
    super.key,
    this.initialCategory,
  });

  final String? initialCategory;

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late final TextEditingController _searchController;

  String _query = '';
  String _category = 'All';
  String _difficulty = 'All';
  String _muscle = 'All';
  String _equipment = 'All';

  static const List<String> _categories = [
    'All',
    'Beginner',
    'Strength',
    'Cardio',
    'Home Workout',
    'Gym Workout',
    'Stretching',
  ];

  static const List<String> _difficulties = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  static const List<String> _muscles = [
    'All',
    'Full Body',
    'Chest',
    'Back',
    'Shoulders',
    'Biceps',
    'Triceps',
    'Legs',
    'Glutes',
    'Core',
    'Hamstrings',
    'Quadriceps',
  ];

  static const List<String> _equipmentOptions = [
    'All',
    'No Equipment',
    'Dumbbells',
    'Barbell',
    'Kettlebell',
    'Machine',
    'Cable',
    'Pull-Up Bar',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    final initial = widget.initialCategory;
    if (initial != null && _categories.contains(initial)) {
      _category = initial;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ExerciseModel> get _filteredExercises {
    final query = _query.trim().toLowerCase();

    return ExerciseData.all.where((exercise) {
      if (query.isNotEmpty) {
        final haystack = [
          exercise.name,
          exercise.category,
          exercise.muscleGroup,
          exercise.equipmentName,
          exercise.difficultyName,
          exercise.description,
        ].join(' ').toLowerCase();

        if (!haystack.contains(query)) {
          return false;
        }
      }

      if (_category != 'All' &&
          exercise.category.toLowerCase() != _category.toLowerCase()) {
        return false;
      }

      if (_difficulty != 'All' &&
          exercise.difficultyName.toLowerCase() !=
              _difficulty.toLowerCase()) {
        return false;
      }

      if (_muscle != 'All' &&
          exercise.muscleGroup.toLowerCase() != _muscle.toLowerCase()) {
        return false;
      }

      if (_equipment != 'All' &&
          exercise.equipmentName.toLowerCase() != _equipment.toLowerCase()) {
        return false;
      }

      return true;
    }).toList(growable: false);
  }

  bool get _hasFilters =>
      _query.trim().isNotEmpty ||
      _category != 'All' ||
      _difficulty != 'All' ||
      _muscle != 'All' ||
      _equipment != 'All';

  void _clearFilters() {
    setState(() {
      _query = '';
      _category = 'All';
      _difficulty = 'All';
      _muscle = 'All';
      _equipment = 'All';
      _searchController.clear();
    });
  }

  void _openExercise(ExerciseModel exercise) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutDetailScreen(exercise: exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final exercises = _filteredExercises;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        title: Text(
          'Exercise Library',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          if (_hasFilters)
            IconButton(
              tooltip: 'Clear filters',
              onPressed: _clearFilters,
              icon: Icon(
                Icons.filter_alt_off_rounded,
                color: colors.primary,
              ),
            ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                child: _headerCard(context),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _searchField(context),
              ),
            ),
            SliverToBoxAdapter(
              child: _filterSection(context),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 30),
              sliver: exercises.isEmpty
                  ? SliverToBoxAdapter(
                      child: _emptyState(context),
                    )
                  : SliverList.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        return _exerciseCard(context, exercises[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCard(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary.withValues(alpha: isDark ? 0.24 : 0.14),
            colors.secondary.withValues(alpha: isDark ? 0.14 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: colors.primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Train with intention',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${ExerciseData.all.length} exercises in your library',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.62),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_outward_rounded,
            color: colors.primary.withValues(alpha: 0.72),
          ),
        ],
      ),
    );
  }

  Widget _searchField(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search exercise, muscle, equipment...',
        prefixIcon: Icon(Icons.search_rounded, color: colors.primary),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: colors.onSurface.withValues(alpha: 0.07),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: colors.primary.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _filterSection(BuildContext context) {
    final exercises = _filteredExercises;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 0, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterRow(
            context,
            label: 'Category',
            selected: _category,
            items: _categories,
            onChanged: (value) => setState(() => _category = value),
          ),
          _filterRow(
            context,
            label: 'Level',
            selected: _difficulty,
            items: _difficulties,
            onChanged: (value) => setState(() => _difficulty = value),
          ),
          _filterRow(
            context,
            label: 'Muscle',
            selected: _muscle,
            items: _muscles,
            onChanged: (value) => setState(() => _muscle = value),
          ),
          _filterRow(
            context,
            label: 'Equipment',
            selected: _equipment,
            items: _equipmentOptions,
            onChanged: (value) => setState(() => _equipment = value),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, right: 20),
            child: Text(
              '${exercises.length} ${exercises.length == 1 ? 'exercise' : 'exercises'} found',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.50),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterRow(
    BuildContext context, {
    required String label,
    required String selected,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: SizedBox(
        height: 36,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 72,
              child: Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                padding: const EdgeInsets.only(right: 20),
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item == selected;

                  return GestureDetector(
                    onTap: () => onChanged(item),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primary.withValues(alpha: 0.13)
                            : colors.surfaceContainerHighest.withValues(
                                alpha: 0.62,
                              ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? colors.primary.withValues(alpha: 0.50)
                              : colors.onSurface.withValues(alpha: 0.07),
                        ),
                      ),
                      child: Text(
                        item,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? colors.primary
                              : colors.onSurface.withValues(alpha: 0.62),
                          fontWeight:
                              isSelected ? FontWeight.w900 : FontWeight.w700,
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

  Widget _exerciseCard(BuildContext context, ExerciseModel exercise) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final dosage = exercise.repetitions <= 1
        ? '${exercise.sets} sets • Hold'
        : '${exercise.sets} sets • ${exercise.repetitions} reps';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => _openExercise(exercise),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: colors.onSurface.withValues(alpha: 0.07),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(
                    _categoryIcon(exercise.category),
                    color: colors.primary,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              exercise.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: colors.onSurface.withValues(alpha: 0.34),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${exercise.muscleGroup} • ${exercise.category}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.56),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _tag(context, exercise.difficultyName),
                          _tag(context, exercise.equipmentName),
                          _tag(context, dosage),
                          _tag(context, '${exercise.restSeconds}s rest'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tag(BuildContext context, String text) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall?.copyWith(
          fontSize: 9,
          color: colors.onSurface.withValues(alpha: 0.64),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.onSurface.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 40,
            color: colors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'No exercises found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try a different search or clear one of the filters.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.56),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reset filters'),
          ),
        ],
      ),
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
