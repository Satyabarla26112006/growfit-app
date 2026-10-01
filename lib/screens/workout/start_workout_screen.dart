import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/exercise_model.dart';
import '../../models/workout_model.dart';
import '../../services/attendance_service.dart';
import '../../services/workout_history_service.dart';

/// Workout runner supporting both:
/// 1. a complete WorkoutModel sequence, and
/// 2. the existing single ExerciseModel flow.
///
/// Step 6 adds execution polish:
/// - exercise-by-exercise progression
/// - automatic configurable rest countdowns
/// - pause/resume during rest
/// - previous/skip exercise controls for workout plans
/// - accurate completed-set tracking
/// - clearer completion and transition feedback
class StartWorkoutScreen extends StatefulWidget {
  const StartWorkoutScreen({
    super.key,
    this.workout,
    this.exercise,
  }) : assert(
          workout != null || exercise != null,
          'Provide either workout or exercise.',
        );

  final WorkoutModel? workout;
  final ExerciseModel? exercise;

  bool get isWorkoutMode => workout != null;

  @override
  State<StartWorkoutScreen> createState() => _StartWorkoutScreenState();
}

class _StartWorkoutScreenState extends State<StartWorkoutScreen> {
  Timer? _sessionTimer;
  Timer? _restTimer;

  int _elapsedSeconds = 0;
  int _exerciseIndex = 0;
  int _currentSet = 1;
  int _completedSets = 0;

  int _restSecondsLeft = 0;
  bool _restActive = false;

  bool _isRunning = false;
  bool _isFinished = false;
  bool _savingWorkout = false;

  List<ExerciseModel> get _exercises => widget.workout?.exercises ??
      <ExerciseModel>[widget.exercise!];

  ExerciseModel get _currentExercise => _exercises[_exerciseIndex];

  bool get _isLastExercise => _exerciseIndex >= _exercises.length - 1;

  bool get _isFirstExercise => _exerciseIndex == 0;

  int get _totalSets => _exercises.fold<int>(
        0,
        (sum, exercise) => sum + exercise.sets,
      );

  int get _remainingExercises => _exercises.length - _exerciseIndex - 1;

  ExerciseModel? get _nextExercise {
    if (_isLastExercise) {
      return null;
    }
    return _exercises[_exerciseIndex + 1];
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          _elapsedSeconds++;
        });
      },
    );
  }

  void _pauseSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  void _toggleTimer() {
    if (_isFinished || _savingWorkout) {
      return;
    }

    if (_isRunning) {
      _pauseSessionTimer();
      if (_restActive) {
        _pauseRestTimer();
      }

      setState(() {
        _isRunning = false;
      });
      return;
    }

    _startSessionTimer();

    if (_restActive) {
      _startRestTimer();
    }

    setState(() {
      _isRunning = true;
    });
  }

  void _completeSet() {
    if (!_isRunning ||
        _isFinished ||
        _savingWorkout ||
        _restActive ||
        _currentExercise.sets <= 0) {
      return;
    }

    setState(() {
      _completedSets++;
    });

    final isLastSetOfExercise = _currentSet >= _currentExercise.sets;

    if (!isLastSetOfExercise) {
      setState(() {
        _currentSet++;
      });

      _beginRest(_currentExercise.restSeconds);
      return;
    }

    if (!_isLastExercise) {
      setState(() {
        _exerciseIndex++;
        _currentSet = 1;
      });

      _beginRest(_exercises[_exerciseIndex - 1].restSeconds);
      _showTransitionMessage(
        'Next: ${_currentExercise.name}',
      );
      return;
    }

    _finishWorkout();
  }

  void _beginRest(int seconds) {
    final duration = seconds.clamp(0, 180);
    if (duration <= 0 || !_isRunning) {
      return;
    }

    _restTimer?.cancel();

    setState(() {
      _restSecondsLeft = duration;
      _restActive = true;
    });

    _startRestTimer();
  }

  void _startRestTimer() {
    _restTimer?.cancel();

    if (_restSecondsLeft <= 0) {
      _finishRest();
      return;
    }

    _restTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (!_isRunning) {
          timer.cancel();
          return;
        }

        if (_restSecondsLeft <= 1) {
          timer.cancel();
          _finishRest();
          return;
        }

        setState(() {
          _restSecondsLeft--;
        });
      },
    );
  }

  void _pauseRestTimer() {
    _restTimer?.cancel();
    _restTimer = null;
  }

  void _finishRest() {
    _restTimer?.cancel();
    _restTimer = null;

    if (!mounted) {
      return;
    }

    setState(() {
      _restSecondsLeft = 0;
      _restActive = false;
    });

    _showTransitionMessage(
      'Rest complete',
    );
  }

  void _skipRest() {
    if (!_restActive || _savingWorkout) {
      return;
    }

    _finishRest();
  }

  Future<void> _skipExercise() async {
    if (widget.workout == null ||
        _isLastExercise ||
        _savingWorkout ||
        _isFinished) {
      return;
    }

    final shouldSkip = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final scheme = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: scheme.surface,
          title: const Text(
            'Skip this exercise?',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: Text(
            'Move to ${_exercises[_exerciseIndex + 1].name}. '
            'Completed sets will still be counted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Keep Going'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Skip'),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldSkip != true) {
      return;
    }

    _restTimer?.cancel();

    setState(() {
      _restActive = false;
      _restSecondsLeft = 0;
      _exerciseIndex++;
      _currentSet = 1;
    });

    _showTransitionMessage(
      'Skipped. Next: ${_currentExercise.name}',
    );
  }

  void _previousExercise() {
    if (widget.workout == null ||
        _isFirstExercise ||
        _savingWorkout ||
        _isFinished) {
      return;
    }

    _restTimer?.cancel();

    setState(() {
      _restActive = false;
      _restSecondsLeft = 0;
      _exerciseIndex--;
      _currentSet = 1;
    });

    _showTransitionMessage(
      'Back to ${_currentExercise.name}',
    );
  }

  void _showTransitionMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1200),
          content: Text(message),
        ),
      );
  }

  Future<void> _finishWorkout() async {
    if (_isFinished || _savingWorkout) {
      return;
    }

    _sessionTimer?.cancel();
    _restTimer?.cancel();

    setState(() {
      _isRunning = false;
      _restActive = false;
      _restSecondsLeft = 0;
      _savingWorkout = true;
    });

    try {
      await WorkoutHistoryService.initialize();

      final now = DateTime.now();

      if (widget.workout != null) {
        final workout = widget.workout!;

        await WorkoutHistoryService.addWorkout(
          exerciseId: workout.id,
          exerciseName: workout.title,
          category: workout.environmentLabel,
          muscleGroup: workout.categoryLabel,
          completedAt: now,
          durationSeconds: _elapsedSeconds,
          completedSets: _completedSets,
          totalSets: _totalSets,
          repetitions: 0,
          estimatedCalories: workout.estimatedCalories,
          completed: true,
        );

        await AttendanceService.initialize();
        await AttendanceService.recordWorkout(
          date: now,
          workoutId: workout.id,
          workoutName: workout.title,
          category: workout.environmentLabel,
          caloriesBurned: workout.estimatedCalories.toDouble(),
          durationSeconds: _elapsedSeconds,
        );
      } else {
        final exercise = widget.exercise!;

        await WorkoutHistoryService.addWorkout(
          exerciseId: exercise.id,
          exerciseName: exercise.name,
          category: exercise.category,
          muscleGroup: exercise.muscleGroup,
          completedAt: now,
          durationSeconds: _elapsedSeconds,
          completedSets: _completedSets.clamp(0, exercise.sets),
          totalSets: exercise.sets,
          repetitions: exercise.repetitions,
          estimatedCalories: exercise.estimatedCalories.round(),
          completed: true,
        );

        await AttendanceService.recordWorkout(
          date: now,
          workoutId: exercise.id,
          workoutName: exercise.name,
          category: exercise.category,
          caloriesBurned: exercise.estimatedCalories.toDouble(),
          durationSeconds: _elapsedSeconds,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _savingWorkout = false;
        _isFinished = true;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _savingWorkout = false;
        _isRunning = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Workout could not be saved. Please try again.',
          ),
        ),
      );
    }
  }

  Future<bool> _confirmLeave() async {
    if (_isFinished) {
      return true;
    }

    if (!_isRunning &&
        _elapsedSeconds == 0 &&
        _completedSets == 0) {
      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final scheme = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: scheme.surface,
          title: const Text(
            'Leave workout?',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: const Text(
            'Your current session will not be saved as completed.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Stay'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _handleBack() async {
    if (!mounted) {
      return;
    }

    final shouldLeave = await _confirmLeave();

    if (!mounted || !shouldLeave) {
      return;
    }

    _sessionTimer?.cancel();
    _restTimer?.cancel();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _currentExercise;
    final plan = widget.workout;
    final scheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Scaffold(
        backgroundColor: scheme.surface,
        appBar: AppBar(
          backgroundColor: scheme.surface,
          elevation: 0,
          leading: IconButton(
            onPressed: _handleBack,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: Text(
            plan?.title ?? exercise.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          actions: [
            if (_isRunning)
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Color(0xFF22C55E),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: SafeArea(
          child: _isFinished
              ? _finishedView()
              : _workoutView(),
        ),
      ),
    );
  }

  Widget _workoutView() {
    final exercise = _currentExercise;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
      children: [
        if (widget.workout != null) ...[
          _planProgress(),
          const SizedBox(height: 12),
        ],
        _exerciseHeader(exercise),
        const SizedBox(height: 12),
        if (_restActive) ...[
          _restCard(),
          const SizedBox(height: 12),
        ],
        _timerCard(),
        const SizedBox(height: 12),
        _setProgress(exercise),
        const SizedBox(height: 12),
        _exerciseInfo(exercise),
        const SizedBox(height: 12),
        _instructionCard(exercise),
        if (_nextExercise != null) ...[
          const SizedBox(height: 12),
          _nextExerciseCard(_nextExercise!),
        ],
        const SizedBox(height: 20),
        _mainButton(),
        const SizedBox(height: 10),
        _secondaryButton(exercise),
        if (widget.workout != null) ...[
          const SizedBox(height: 8),
          _navigationButtons(),
        ],
      ],
    );
  }

  Widget _planProgress() {
    final total = _exercises.length;
    final current = _exerciseIndex + 1;
    final progress = total == 0
        ? 0.0
        : (current / total).clamp(0.0, 1.0).toDouble();
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: scheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Workout Progress',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '$current / $total',
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _remainingExercises == 0
                  ? 'Final exercise'
                  : '$_remainingExercises exercises remaining',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.52),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _exerciseHeader(ExerciseModel exercise) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.18),
            scheme.surfaceContainerHighest.withValues(alpha: 0.78),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: scheme.primary.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Icon(
              _categoryIcon(exercise.category),
              color: scheme.primary,
              size: 35,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            exercise.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${exercise.muscleGroup} • ${exercise.difficultyName}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _restCard() {
    final scheme = Theme.of(context).colorScheme;
    final seconds = _restSecondsLeft;
    final totalRest = _currentExercise.restSeconds.clamp(1, 180);
    final progress = (seconds / totalRest).clamp(0.0, 1.0).toDouble();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.self_improvement_rounded,
                color: scheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'REST',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Text(
                '${seconds}s',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recover, breathe, then continue.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.60),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: _skipRest,
                child: const Text('Skip'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timerCard() {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: scheme.onSurface.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        children: [
          Text(
            'SESSION TIME',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 1.4,
              fontWeight: FontWeight.w900,
              color: scheme.onSurface.withValues(alpha: 0.48),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            _formatDuration(_elapsedSeconds),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isRunning
                    ? Icons.pause_circle_rounded
                    : Icons.play_circle_rounded,
                color: scheme.primary,
                size: 20,
              ),
              const SizedBox(width: 7),
              Text(
                _restActive
                    ? 'Rest in progress'
                    : _isRunning
                        ? 'Workout in progress'
                        : 'Ready to start',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.60),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _setProgress(ExerciseModel exercise) {
    final scheme = Theme.of(context).colorScheme;
    final sets = exercise.sets;
    final completedForExercise = _completedSetsForCurrentExercise();
    final currentDisplay = completedForExercise >= sets
        ? sets
        : _currentSet;
    final progress =
        sets <= 0 ? 0.0 : (currentDisplay / sets).clamp(0.0, 1.0).toDouble();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Set Progress',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '$currentDisplay / $sets',
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            exercise.repetitions == 1
                ? 'Hold • ${exercise.restSeconds}s rest'
                : '${exercise.repetitions} reps • ${exercise.restSeconds}s rest',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.50),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  int _completedSetsForCurrentExercise() {
    var completed = 0;

    for (var index = 0; index < _exerciseIndex; index++) {
      completed += _exercises[index].sets;
    }

    final currentSets = _completedSets - completed;
    return currentSets.clamp(0, _currentExercise.sets);
  }

  Widget _exerciseInfo(ExerciseModel exercise) {
    return Row(
      children: [
        Expanded(
          child: _SmallStat(
            icon: Icons.repeat_rounded,
            label: 'SETS',
            value: '${exercise.sets}',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SmallStat(
            icon: Icons.list_alt_rounded,
            label: 'REPS',
            value: exercise.repetitions == 1
                ? 'Hold'
                : '${exercise.repetitions}',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SmallStat(
            icon: Icons.local_fire_department_rounded,
            label: 'KCAL',
            value: '${exercise.estimatedCalories.round()}',
          ),
        ),
      ],
    );
  }

  Widget _instructionCard(ExerciseModel exercise) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How To Perform',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 13),
          if (exercise.instructions.isEmpty)
            Text(
              'Follow a controlled movement pattern and maintain good form.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.62),
                height: 1.5,
              ),
            )
          else
            ...List.generate(
              exercise.instructions.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom:
                      index == exercise.instructions.length - 1 ? 0 : 11,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 27,
                      height: 27,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        exercise.instructions[index],
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                              color:
                                  scheme.onSurface.withValues(alpha: 0.68),
                              height: 1.5,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _nextExerciseCard(ExerciseModel exercise) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: scheme.primary.withValues(alpha: 0.11),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_forward_rounded,
            color: scheme.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UP NEXT',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${exercise.muscleGroup} • ${exercise.sets} sets',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.54),
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

  Widget _mainButton() {
    if (_savingWorkout) {
      return const SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: null,
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _toggleTimer,
        icon: Icon(
          _isRunning
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
        ),
        label: Text(
          _isRunning ? 'Pause Workout' : 'Start Workout',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  Widget _secondaryButton(ExerciseModel exercise) {
    final enabled =
        _isRunning && !_savingWorkout && !_restActive;

    final lastSet = _currentSet >= exercise.sets;

    final String label;
    if (lastSet && _isLastExercise) {
      label = 'Complete Workout';
    } else if (lastSet) {
      label = 'Complete Exercise';
    } else {
      label = 'Complete Set';
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: enabled ? _completeSet : null,
        icon: Icon(
          lastSet
              ? Icons.check_circle_outline_rounded
              : Icons.done_rounded,
        ),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _navigationButtons() {
    final canPrevious =
        !_isFirstExercise && !_isFinished && !_savingWorkout;
    final canSkip =
        !_isLastExercise && !_isFinished && !_savingWorkout;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: canPrevious ? _previousExercise : null,
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Previous'),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: canSkip ? _skipExercise : null,
            icon: const Icon(Icons.skip_next_rounded, size: 18),
            label: const Text('Skip'),
          ),
        ),
      ],
    );
  }

  Widget _finishedView() {
    final scheme = Theme.of(context).colorScheme;
    final title = widget.workout?.title ?? widget.exercise!.name;
    final calories = widget.workout?.estimatedCalories ??
        widget.exercise!.estimatedCalories.round();

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.24),
                ),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF22C55E),
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Workout Complete!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.58),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.50),
                borderRadius: BorderRadius.circular(21),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _finishStat(
                      title: 'Time',
                      value: _formatDuration(_elapsedSeconds),
                      icon: Icons.timer_outlined,
                    ),
                  ),
                  _verticalDivider(),
                  Expanded(
                    child: _finishStat(
                      title: widget.workout != null
                          ? 'Sets'
                          : 'Sets',
                      value: '$_completedSets / $_totalSets',
                      icon: Icons.repeat_rounded,
                    ),
                  ),
                  _verticalDivider(),
                  Expanded(
                    child: _finishStat(
                      title: 'Calories',
                      value: '$calories',
                      icon: Icons.local_fire_department_rounded,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.cloud_done_rounded,
                    color: Color(0xFF22C55E),
                    size: 19,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Workout saved to your history and attendance.',
                      style: TextStyle(
                        color: Color(0xFF22C55E),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Done',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _finishStat({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(
          icon,
          color: scheme.primary,
          size: 21,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: scheme.onSurface.withValues(alpha: 0.48),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 50,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remaining.toString().padLeft(2, '0')}';
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

class _SmallStat extends StatelessWidget {
  const _SmallStat({
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
        vertical: 13,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(16),
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
