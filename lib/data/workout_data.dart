import '../models/exercise_model.dart';
import '../models/workout_model.dart';
import 'exercise_data.dart';

/// Curated GrowFit workout catalog.
///
/// Every workout is a deliberate sequence of exercises from ExerciseData.
/// The catalog keeps Gym and Home plans separate while preserving the
/// compatibility API already used by the existing app.
class WorkoutData {
  WorkoutData._();

  static final Map<String, ExerciseModel> _byId = {
    for (final exercise in ExerciseData.all) exercise.id: exercise,
  };

  static ExerciseModel _e(String id) {
    final exercise = _byId[id];
    if (exercise == null) {
      throw StateError('WorkoutData references missing exercise: $id');
    }
    return exercise;
  }

  static WorkoutModel _make({
    required String id,
    required String name,
    required WorkoutType type,
    required WorkoutCategory category,
    required WorkoutDifficulty difficulty,
    required List<String> exerciseIds,
    required int durationMinutes,
    required int caloriesBurned,
    String description = '',
    bool isFeatured = false,
    bool isPopular = false,
    bool isRecommended = false,
    int sortOrder = 0,
  }) {
    final exercises = exerciseIds.map(_e).toList(growable: false);

    return WorkoutModel(
      id: id,
      name: name,
      description: description,
      type: type,
      environment: type == WorkoutType.gym
          ? WorkoutEnvironment.gym
          : WorkoutEnvironment.home,
      category: category,
      difficulty: difficulty,
      exerciseIds: exerciseIds,
      exercises: exercises,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      estimatedCalories: caloriesBurned,
      isFeatured: isFeatured,
      isPopular: isPopular,
      isRecommended: isRecommended,
      sortOrder: sortOrder,
    );
  }

  // ============================================================
  // GYM WORKOUTS
  // ============================================================

  static final List<WorkoutModel> gymWorkouts = [
    _make(
      id: 'gym_push_foundation',
      name: 'Gym Push Foundation',
      type: WorkoutType.gym,
      category: WorkoutCategory.push,
      difficulty: WorkoutDifficulty.beginner,
      exerciseIds: const [
        'strength_bench_press',
        'gym_chest_fly',
        'strength_shoulder_press',
        'gym_triceps_pushdown',
      ],
      durationMinutes: 35,
      caloriesBurned: 245,
      description: 'A straightforward chest, shoulder and triceps session for building a strong pushing base.',
      isFeatured: true,
      isPopular: true,
      isRecommended: true,
      sortOrder: 1,
    ),
    _make(
      id: 'gym_push_hypertrophy',
      name: 'Gym Push Hypertrophy',
      type: WorkoutType.gym,
      category: WorkoutCategory.push,
      difficulty: WorkoutDifficulty.intermediate,
      exerciseIds: const [
        'strength_bench_press',
        'gym_chest_fly',
        'strength_shoulder_press',
        'gym_triceps_pushdown',
        'strength_pushups',
      ],
      durationMinutes: 45,
      caloriesBurned: 320,
      description: 'A higher-volume push day combining compound and isolation work.',
      isPopular: true,
      sortOrder: 2,
    ),
    _make(
      id: 'gym_pull_strength',
      name: 'Gym Pull Strength',
      type: WorkoutType.gym,
      category: WorkoutCategory.pull,
      difficulty: WorkoutDifficulty.intermediate,
      exerciseIds: const [
        'gym_lat_pulldown',
        'gym_cable_row',
        'strength_pullups',
        'strength_dumbbell_curl',
      ],
      durationMinutes: 40,
      caloriesBurned: 290,
      description: 'Back and biceps work built around vertical and horizontal pulling.',
      isFeatured: true,
      isPopular: true,
      sortOrder: 3,
    ),
    _make(
      id: 'gym_pull_back_volume',
      name: 'Gym Back Volume',
      type: WorkoutType.gym,
      category: WorkoutCategory.pull,
      difficulty: WorkoutDifficulty.advanced,
      exerciseIds: const [
        'strength_pullups',
        'gym_lat_pulldown',
        'gym_cable_row',
        'strength_dumbbell_curl',
      ],
      durationMinutes: 48,
      caloriesBurned: 340,
      description: 'A challenging pull session with emphasis on back volume and arm finishers.',
      isPopular: true,
      sortOrder: 4,
    ),
    _make(
      id: 'gym_legs_foundation',
      name: 'Gym Legs Foundation',
      type: WorkoutType.gym,
      category: WorkoutCategory.legs,
      difficulty: WorkoutDifficulty.intermediate,
      exerciseIds: const [
        'gym_barbell_squat',
        'gym_leg_press',
        'strength_lunges',
        'beginner_glute_bridge',
      ],
      durationMinutes: 42,
      caloriesBurned: 335,
      description: 'A lower-body session covering quads, glutes and overall leg strength.',
      isFeatured: true,
      isPopular: true,
      isRecommended: true,
      sortOrder: 5,
    ),
    _make(
      id: 'gym_legs_strength',
      name: 'Gym Legs Strength',
      type: WorkoutType.gym,
      category: WorkoutCategory.legs,
      difficulty: WorkoutDifficulty.advanced,
      exerciseIds: const [
        'gym_barbell_squat',
        'gym_leg_press',
        'strength_lunges',
        'strength_goblet_squat',
      ],
      durationMinutes: 48,
      caloriesBurned: 380,
      description: 'A heavier lower-body workout built around squat and leg-press patterns.',
      isPopular: true,
      sortOrder: 6,
    ),
    _make(
      id: 'gym_strength_full_body',
      name: 'Gym Full Body Strength',
      type: WorkoutType.gym,
      category: WorkoutCategory.strength,
      difficulty: WorkoutDifficulty.intermediate,
      exerciseIds: const [
        'gym_barbell_squat',
        'strength_bench_press',
        'gym_lat_pulldown',
        'gym_leg_press',
        'strength_dumbbell_curl',
      ],
      durationMinutes: 50,
      caloriesBurned: 395,
      description: 'A full-body strength session using major movement patterns from the gym floor.',
      isFeatured: true,
      isRecommended: true,
      sortOrder: 7,
    ),
    _make(
      id: 'gym_cardio_conditioning',
      name: 'Gym Cardio Conditioning',
      type: WorkoutType.gym,
      category: WorkoutCategory.cardio,
      difficulty: WorkoutDifficulty.intermediate,
      exerciseIds: const [
        'cardio_jumping_jacks',
        'cardio_high_knees',
        'cardio_mountain_climbers',
        'cardio_skater',
      ],
      durationMinutes: 28,
      caloriesBurned: 300,
      description: 'A gym-friendly conditioning circuit focused on steady cardiovascular work.',
      isPopular: true,
      sortOrder: 8,
    ),
    _make(
      id: 'gym_hiit_burn',
      name: 'Gym HIIT Burn',
      type: WorkoutType.gym,
      category: WorkoutCategory.hiit,
      difficulty: WorkoutDifficulty.advanced,
      exerciseIds: const [
        'cardio_high_knees',
        'cardio_burpees',
        'cardio_mountain_climbers',
        'cardio_skater',
      ],
      durationMinutes: 24,
      caloriesBurned: 315,
      description: 'Short, demanding intervals for high-intensity conditioning.',
      isFeatured: true,
      sortOrder: 9,
    ),
    _make(
      id: 'gym_all_body_reset',
      name: 'Gym Total Body Reset',
      type: WorkoutType.gym,
      category: WorkoutCategory.allWorkouts,
      difficulty: WorkoutDifficulty.beginner,
      exerciseIds: const [
        'strength_goblet_squat',
        'strength_bench_press',
        'gym_lat_pulldown',
        'strength_shoulder_press',
        'cardio_jumping_jacks',
      ],
      durationMinutes: 38,
      caloriesBurned: 285,
      description: 'A balanced gym session for days when you want a little of everything.',
      isRecommended: true,
      sortOrder: 10,
    ),
  ];

  // ============================================================
  // HOME WORKOUTS
  // ============================================================

  static final List<WorkoutModel> homeWorkouts = [
    _make(
      id: 'home_push_foundation',
      name: 'Home Push Foundation',
      type: WorkoutType.home,
      category: WorkoutCategory.push,
      difficulty: WorkoutDifficulty.beginner,
      exerciseIds: const [
        'beginner_wall_pushups',
        'beginner_knee_pushups',
        'home_pushups',
        'strength_pushups',
      ],
      durationMinutes: 28,
      caloriesBurned: 175,
      description: 'A home push progression using wall, knee and standard push-up variations.',
      isFeatured: true,
      isPopular: true,
      isRecommended: true,
      sortOrder: 21,
    ),
    _make(
      id: 'home_push_power',
      name: 'Home Push Power',
      type: WorkoutType.home,
      category: WorkoutCategory.push,
      difficulty: WorkoutDifficulty.intermediate,
      exerciseIds: const [
        'home_pushups',
        'strength_pushups',
        'beginner_knee_pushups',
        'home_plank',
      ],
      durationMinutes: 32,
      caloriesBurned: 210,
      description: 'A higher-repetition push workout that needs only floor space.',
      isPopular: true,
      sortOrder: 22,
    ),
    _make(
      id: 'home_pull_bar',
      name: 'Home Pull Bar Workout',
      type: WorkoutType.home,
      category: WorkoutCategory.pull,
      difficulty: WorkoutDifficulty.intermediate,
      exerciseIds: const [
        'strength_pullups',
        'strength_dumbbell_curl',
        'strength_plank',
        'home_reverse_lunges',
      ],
      durationMinutes: 30,
      caloriesBurned: 205,
      description: 'A home pull day for users with a pull-up bar and a pair of dumbbells.',
      isPopular: true,
      sortOrder: 23,
    ),
    _make(
      id: 'home_pull_minimal',
      name: 'Home Pull Minimal',
      type: WorkoutType.home,
      category: WorkoutCategory.pull,
      difficulty: WorkoutDifficulty.beginner,
      exerciseIds: const [
        'strength_pullups',
        'beginner_glute_bridge',
        'beginner_marching',
        'home_plank',
      ],
      durationMinutes: 26,
      caloriesBurned: 165,
      description: 'A compact home session for pulling strength with minimal setup.',
      sortOrder: 24,
    ),
    _make(
      id: 'home_legs_foundation',
      name: 'Home Legs Foundation',
      type: WorkoutType.home,
      category: WorkoutCategory.legs,
      difficulty: WorkoutDifficulty.beginner,
      exerciseIds: const [
        'home_air_squats',
        'home_reverse_lunges',
        'beginner_glute_bridge',
        'beginner_squats',
      ],
      durationMinutes: 31,
      caloriesBurned: 205,
      description: 'A no-machine lower-body session for quads, glutes and movement quality.',
      isFeatured: true,
      isPopular: true,
      isRecommended: true,
      sortOrder: 25,
    ),
    _make(
      id: 'home_legs_burn',
      name: 'Home Legs Burn',
      type: WorkoutType.home,
      category: WorkoutCategory.legs,
      difficulty: WorkoutDifficulty.intermediate,
      exerciseIds: const [
        'home_air_squats',
        'home_reverse_lunges',
        'strength_lunges',
        'cardio_skater',
      ],
      durationMinutes: 34,
      caloriesBurned: 255,
      description: 'A faster-paced leg workout blending strength and lateral conditioning.',
      isPopular: true,
      sortOrder: 26,
    ),
    _make(
      id: 'home_strength_full_body',
      name: 'Home Full Body Strength',
      type: WorkoutType.home,
      category: WorkoutCategory.strength,
      difficulty: WorkoutDifficulty.intermediate,
      exerciseIds: const [
        'home_pushups',
        'home_air_squats',
        'home_reverse_lunges',
        'home_plank',
        'beginner_glute_bridge',
      ],
      durationMinutes: 36,
      caloriesBurned: 250,
      description: 'A balanced home strength circuit covering push, legs, glutes and core.',
      isFeatured: true,
      isRecommended: true,
      sortOrder: 27,
    ),
    _make(
      id: 'home_cardio_steady',
      name: 'Home Cardio Flow',
      type: WorkoutType.home,
      category: WorkoutCategory.cardio,
      difficulty: WorkoutDifficulty.beginner,
      exerciseIds: const [
        'beginner_marching',
        'cardio_jumping_jacks',
        'cardio_high_knees',
        'cardio_skater',
      ],
      durationMinutes: 27,
      caloriesBurned: 235,
      description: 'A progressive cardio session that can be done in a small space.',
      isPopular: true,
      sortOrder: 28,
    ),
    _make(
      id: 'home_hiit_burn',
      name: 'Home HIIT Burn',
      type: WorkoutType.home,
      category: WorkoutCategory.hiit,
      difficulty: WorkoutDifficulty.advanced,
      exerciseIds: const [
        'cardio_high_knees',
        'cardio_burpees',
        'cardio_mountain_climbers',
        'cardio_jumping_jacks',
      ],
      durationMinutes: 23,
      caloriesBurned: 300,
      description: 'A short bodyweight HIIT session built for high effort and quick transitions.',
      isFeatured: true,
      isPopular: true,
      sortOrder: 29,
    ),
    _make(
      id: 'home_all_body',
      name: 'Home Total Body',
      type: WorkoutType.home,
      category: WorkoutCategory.allWorkouts,
      difficulty: WorkoutDifficulty.beginner,
      exerciseIds: const [
        'home_pushups',
        'home_air_squats',
        'beginner_glute_bridge',
        'cardio_jumping_jacks',
        'home_plank',
      ],
      durationMinutes: 34,
      caloriesBurned: 240,
      description: 'A practical full-body home workout for days when you want a complete session.',
      isRecommended: true,
      sortOrder: 30,
    ),
  ];

  // ============================================================
  // SPECIALIZED
  // ============================================================

  static final List<WorkoutModel> mobilityAndYoga = [
    _make(
      id: 'mobility_daily_reset',
      name: 'Daily Mobility Reset',
      type: WorkoutType.mobility,
      category: WorkoutCategory.mobility,
      difficulty: WorkoutDifficulty.beginner,
      exerciseIds: const [
        'stretch_cat_cow',
        'stretch_shoulder',
        'stretch_hamstring',
        'stretch_quad',
        'stretch_child_pose',
      ],
      durationMinutes: 20,
      caloriesBurned: 35,
      description: 'A gentle full-body mobility sequence for daily movement and recovery.',
      isFeatured: true,
      isRecommended: true,
      sortOrder: 41,
    ),
    _make(
      id: 'mobility_post_workout',
      name: 'Post Workout Mobility',
      type: WorkoutType.mobility,
      category: WorkoutCategory.mobility,
      difficulty: WorkoutDifficulty.beginner,
      exerciseIds: const [
        'stretch_quad',
        'stretch_hamstring',
        'stretch_shoulder',
        'stretch_cobra',
        'stretch_child_pose',
      ],
      durationMinutes: 18,
      caloriesBurned: 30,
      description: 'A slower mobility sequence designed to transition out of training.',
      isPopular: true,
      sortOrder: 42,
    ),
    _make(
      id: 'yoga_recovery_flow',
      name: 'Yoga Recovery Flow',
      type: WorkoutType.yoga,
      category: WorkoutCategory.yoga,
      difficulty: WorkoutDifficulty.beginner,
      exerciseIds: const [
        'stretch_cat_cow',
        'stretch_child_pose',
        'stretch_cobra',
        'stretch_hamstring',
        'stretch_shoulder',
      ],
      durationMinutes: 24,
      caloriesBurned: 38,
      description: 'A simple recovery-oriented flow using the existing mobility exercise library.',
      isFeatured: true,
      isPopular: true,
      sortOrder: 43,
    ),
    _make(
      id: 'yoga_beginner_flow',
      name: 'Yoga Beginner Flow',
      type: WorkoutType.yoga,
      category: WorkoutCategory.yoga,
      difficulty: WorkoutDifficulty.beginner,
      exerciseIds: const [
        'stretch_cat_cow',
        'stretch_cobra',
        'stretch_child_pose',
        'stretch_quad',
      ],
      durationMinutes: 19,
      caloriesBurned: 30,
      description: 'A short beginner flow centered on controlled movement and comfortable holds.',
      isRecommended: true,
      sortOrder: 44,
    ),
  ];

  static final List<WorkoutModel> workouts = [
    ...gymWorkouts,
    ...homeWorkouts,
    ...mobilityAndYoga,
  ];

  static List<WorkoutModel> get all => workouts;

  static List<WorkoutModel> get featured => workouts
      .where((workout) => workout.isFeatured)
      .toList(growable: false);

  static List<WorkoutModel> get popular => workouts
      .where((workout) => workout.isPopular)
      .toList(growable: false);

  static List<WorkoutModel> get recommended => workouts
      .where((workout) => workout.isRecommended)
      .toList(growable: false);

  static List<WorkoutModel> byType(WorkoutType type) => workouts
      .where((workout) => workout.type == type)
      .toList(growable: false);

  static List<WorkoutModel> byCategory(WorkoutCategory category) => workouts
      .where((workout) => workout.category == category)
      .toList(growable: false);

  static List<WorkoutModel> byEnvironment(WorkoutEnvironment environment) => workouts
      .where((workout) => workout.environment == environment)
      .toList(growable: false);

  static List<WorkoutModel> search(String query) {
    final text = query.trim().toLowerCase();
    if (text.isEmpty) {
      return all;
    }

    return workouts.where((workout) {
      return workout.title.toLowerCase().contains(text) ||
          workout.description.toLowerCase().contains(text) ||
          workout.category.label.toLowerCase().contains(text) ||
          workout.environment.label.toLowerCase().contains(text) ||
          workout.difficulty.label.toLowerCase().contains(text) ||
          workout.exercises.any(
            (exercise) => exercise.name.toLowerCase().contains(text),
          );
    }).toList(growable: false);
  }

  static WorkoutModel? byId(String id) {
    for (final workout in workouts) {
      if (workout.id == id) {
        return workout;
      }
    }
    return null;
  }
}
