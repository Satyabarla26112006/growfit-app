import '../models/exercise_model.dart';

class ExerciseData {
  ExerciseData._();

  // ============================================================
  // ALL EXERCISES
  // ============================================================

  static const List<ExerciseModel> all = [
    // ==========================================================
    // BEGINNER
    // ==========================================================

    ExerciseModel(
      id: 'beginner_squats',
      name: 'Bodyweight Squats',
      category: 'Beginner',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 5,
      description:
          'A simple lower-body exercise for building basic leg strength.',
      instructions: [
        'Stand with your feet about shoulder-width apart.',
        'Keep your chest up and your back neutral.',
        'Bend your knees and lower your hips.',
        'Push through your feet to return to standing.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 45,
      isPopular: true,
      isFeatured: true,
    ),

    ExerciseModel(
      id: 'beginner_wall_pushups',
      name: 'Wall Push-Ups',
      category: 'Beginner',
      muscleGroup: 'Chest',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 4,
      description:
          'A beginner-friendly pushing exercise using a wall for support.',
      instructions: [
        'Stand facing a wall.',
        'Place your hands on the wall at shoulder height.',
        'Bend your elbows and move your chest toward the wall.',
        'Push back to the starting position.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 45,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'beginner_glute_bridge',
      name: 'Glute Bridge',
      category: 'Beginner',
      muscleGroup: 'Glutes',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 6,
      caloriesPerMinute: 4,
      description:
          'A floor exercise that targets the glutes and posterior chain.',
      instructions: [
        'Lie on your back with your knees bent.',
        'Place your feet flat on the floor.',
        'Lift your hips while squeezing your glutes.',
        'Lower your hips slowly.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 45,
    ),

    ExerciseModel(
      id: 'beginner_marching',
      name: 'March in Place',
      category: 'Beginner',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 8,
      caloriesPerMinute: 4,
      description:
          'A low-impact movement for warming up and improving basic fitness.',
      instructions: [
        'Stand tall with your feet hip-width apart.',
        'Lift one knee toward your waist.',
        'Lower it and lift the opposite knee.',
        'Continue at a comfortable pace.',
      ],
      sets: 2,
      repetitions: 30,
      restSeconds: 30,
      isFeatured: true,
    ),

    ExerciseModel(
      id: 'beginner_knee_pushups',
      name: 'Knee Push-Ups',
      category: 'Beginner',
      muscleGroup: 'Chest',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 6,
      caloriesPerMinute: 5,
      description:
          'A modified push-up variation for beginners building upper-body strength.',
      instructions: [
        'Start on your hands and knees.',
        'Keep your body in a straight line from knees to shoulders.',
        'Lower your chest toward the floor.',
        'Push back up while maintaining control.',
      ],
      sets: 3,
      repetitions: 8,
      restSeconds: 60,
    ),

    // ==========================================================
    // STRENGTH
    // ==========================================================

    ExerciseModel(
      id: 'strength_pushups',
      name: 'Push-Ups',
      category: 'Strength',
      muscleGroup: 'Chest',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 7,
      caloriesPerMinute: 7,
      description:
          'A classic upper-body movement targeting the chest, shoulders and triceps.',
      instructions: [
        'Start in a high plank position.',
        'Place your hands slightly wider than shoulder-width.',
        'Lower your chest toward the floor.',
        'Push through your hands to return to the top.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 60,
      isPopular: true,
      isFeatured: true,
    ),

    ExerciseModel(
      id: 'strength_lunges',
      name: 'Forward Lunges',
      category: 'Strength',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 7,
      description:
          'A unilateral leg exercise that trains the quads, glutes and balance.',
      instructions: [
        'Stand tall with your feet together.',
        'Step one foot forward.',
        'Lower your hips until both knees are bent.',
        'Push through the front foot to return.',
        'Repeat on the other side.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 60,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'strength_plank',
      name: 'Plank',
      category: 'Strength',
      muscleGroup: 'Core',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 5,
      caloriesPerMinute: 5,
      description:
          'An isometric core exercise that develops trunk stability.',
      instructions: [
        'Start on your forearms and toes.',
        'Keep your body in a straight line.',
        'Brace your core.',
        'Hold the position without dropping your hips.',
      ],
      sets: 3,
      repetitions: 1,
      restSeconds: 45,
      isPopular: true,
      isFeatured: true,
    ),

    ExerciseModel(
      id: 'strength_dumbbell_curl',
      name: 'Dumbbell Biceps Curl',
      category: 'Strength',
      muscleGroup: 'Biceps',
      equipment: ExerciseEquipment.dumbbells,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 5,
      description:
          'An isolated arm exercise targeting the biceps.',
      instructions: [
        'Stand tall holding a dumbbell in each hand.',
        'Keep your elbows close to your body.',
        'Curl the dumbbells toward your shoulders.',
        'Lower the weights slowly.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 60,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'strength_shoulder_press',
      name: 'Dumbbell Shoulder Press',
      category: 'Strength',
      muscleGroup: 'Shoulders',
      equipment: ExerciseEquipment.dumbbells,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 6,
      description:
          'An overhead pressing movement for shoulder strength.',
      instructions: [
        'Hold dumbbells at shoulder height.',
        'Keep your core tight.',
        'Press the dumbbells overhead.',
        'Lower them under control.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 60,
      isFeatured: true,
    ),

    ExerciseModel(
      id: 'strength_goblet_squat',
      name: 'Goblet Squat',
      category: 'Strength',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.kettlebell,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 7,
      description:
          'A weighted squat variation for lower-body strength.',
      instructions: [
        'Hold a kettlebell or dumbbell close to your chest.',
        'Stand with a comfortable stance.',
        'Lower into a squat.',
        'Drive through your feet to stand.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 60,
    ),

    ExerciseModel(
      id: 'strength_bench_press',
      name: 'Bench Press',
      category: 'Strength',
      muscleGroup: 'Chest',
      equipment: ExerciseEquipment.barbell,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 10,
      caloriesPerMinute: 6,
      description:
          'A compound pressing exercise for chest and upper-body strength.',
      instructions: [
        'Lie on a bench with your feet firmly on the floor.',
        'Grip the bar slightly wider than shoulder-width.',
        'Lower the bar toward your chest.',
        'Press the bar back to the starting position.',
      ],
      sets: 3,
      repetitions: 8,
      restSeconds: 90,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'strength_pullups',
      name: 'Pull-Ups',
      category: 'Strength',
      muscleGroup: 'Back',
      equipment: ExerciseEquipment.pullUpBar,
      difficulty: ExerciseDifficulty.advanced,
      durationMinutes: 8,
      caloriesPerMinute: 8,
      description:
          'A demanding bodyweight pulling exercise for the back and arms.',
      instructions: [
        'Grip the pull-up bar firmly.',
        'Start from a controlled hanging position.',
        'Pull your chest toward the bar.',
        'Lower yourself slowly.',
      ],
      sets: 3,
      repetitions: 6,
      restSeconds: 90,
      isPopular: true,
    ),

    // ==========================================================
    // CARDIO
    // ==========================================================

    ExerciseModel(
      id: 'cardio_jumping_jacks',
      name: 'Jumping Jacks',
      category: 'Cardio',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 10,
      caloriesPerMinute: 9,
      description:
          'A simple full-body cardio movement that raises your heart rate quickly.',
      instructions: [
        'Stand with your feet together.',
        'Jump while moving your arms overhead.',
        'Land with your feet apart.',
        'Jump back to the starting position.',
      ],
      sets: 3,
      repetitions: 30,
      restSeconds: 30,
      isPopular: true,
      isFeatured: true,
    ),

    ExerciseModel(
      id: 'cardio_high_knees',
      name: 'High Knees',
      category: 'Cardio',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 10,
      description:
          'A high-energy cardio exercise using alternating knee drives.',
      instructions: [
        'Stand tall.',
        'Drive one knee toward your chest.',
        'Quickly switch legs.',
        'Pump your arms naturally as you move.',
      ],
      sets: 3,
      repetitions: 30,
      restSeconds: 30,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'cardio_mountain_climbers',
      name: 'Mountain Climbers',
      category: 'Cardio',
      muscleGroup: 'Core',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 10,
      description:
          'A fast-paced exercise combining cardio with core stability.',
      instructions: [
        'Start in a high plank position.',
        'Bring one knee toward your chest.',
        'Quickly switch legs.',
        'Keep your hips controlled.',
      ],
      sets: 3,
      repetitions: 30,
      restSeconds: 45,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'cardio_burpees',
      name: 'Burpees',
      category: 'Cardio',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.advanced,
      durationMinutes: 8,
      caloriesPerMinute: 12,
      description:
          'A demanding full-body movement for cardiovascular conditioning.',
      instructions: [
        'Stand tall.',
        'Squat down and place your hands on the floor.',
        'Jump your feet back into a plank.',
        'Return your feet toward your hands.',
        'Stand and jump upward.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 60,
      isPopular: true,
      isFeatured: true,
    ),

    ExerciseModel(
      id: 'cardio_skater',
      name: 'Skater Jumps',
      category: 'Cardio',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 7,
      caloriesPerMinute: 9,
      description:
          'A lateral cardio movement that also challenges balance and leg strength.',
      instructions: [
        'Stand on one leg.',
        'Jump laterally to the opposite side.',
        'Land softly on the other leg.',
        'Continue alternating sides.',
      ],
      sets: 3,
      repetitions: 20,
      restSeconds: 45,
    ),

    // ==========================================================
    // HOME WORKOUT
    // ==========================================================

    ExerciseModel(
      id: 'home_pushups',
      name: 'Home Push-Ups',
      category: 'Home Workout',
      muscleGroup: 'Chest',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 7,
      caloriesPerMinute: 7,
      description:
          'A no-equipment upper-body exercise you can perform at home.',
      instructions: [
        'Start in a high plank.',
        'Keep your core tight.',
        'Lower your chest.',
        'Push back up.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 60,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'home_air_squats',
      name: 'Air Squats',
      category: 'Home Workout',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 6,
      caloriesPerMinute: 6,
      description:
          'A practical lower-body movement requiring no equipment.',
      instructions: [
        'Stand with your feet shoulder-width apart.',
        'Sit your hips back and bend your knees.',
        'Keep your chest lifted.',
        'Return to standing.',
      ],
      sets: 3,
      repetitions: 15,
      restSeconds: 45,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'home_plank',
      name: 'Home Plank',
      category: 'Home Workout',
      muscleGroup: 'Core',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 5,
      description:
          'A core stability exercise that can be performed almost anywhere.',
      instructions: [
        'Set up on your forearms and toes.',
        'Keep your body straight.',
        'Brace your core.',
        'Hold the position.',
      ],
      sets: 3,
      repetitions: 1,
      restSeconds: 45,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'home_reverse_lunges',
      name: 'Reverse Lunges',
      category: 'Home Workout',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 7,
      caloriesPerMinute: 6,
      description:
          'A controlled home-friendly leg exercise with no equipment.',
      instructions: [
        'Stand tall.',
        'Step one foot backward.',
        'Lower your hips with control.',
        'Push through the front foot.',
        'Switch sides.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 45,
    ),

    ExerciseModel(
      id: 'home_mountain_climbers',
      name: 'Mountain Climbers',
      category: 'Home Workout',
      muscleGroup: 'Core',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 6,
      caloriesPerMinute: 10,
      description:
          'A home cardio and core exercise that needs no equipment.',
      instructions: [
        'Start in a high plank.',
        'Drive one knee inward.',
        'Switch legs quickly.',
        'Maintain a strong plank position.',
      ],
      sets: 3,
      repetitions: 20,
      restSeconds: 45,
    ),

    // ==========================================================
    // GYM WORKOUT
    // ==========================================================

    ExerciseModel(
      id: 'gym_barbell_squat',
      name: 'Barbell Squat',
      category: 'Gym Workout',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.barbell,
      difficulty: ExerciseDifficulty.advanced,
      durationMinutes: 10,
      caloriesPerMinute: 8,
      description:
          'A foundational compound lift for lower-body strength.',
      instructions: [
        'Set the bar securely on your upper back.',
        'Stand with a stable stance.',
        'Brace your core.',
        'Lower into a squat.',
        'Drive upward through your feet.',
      ],
      sets: 4,
      repetitions: 8,
      restSeconds: 120,
      isPopular: true,
      isFeatured: true,
    ),

    ExerciseModel(
      id: 'gym_lat_pulldown',
      name: 'Lat Pulldown',
      category: 'Gym Workout',
      muscleGroup: 'Back',
      equipment: ExerciseEquipment.machine,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 8,
      caloriesPerMinute: 5,
      description:
          'A gym machine exercise for the upper back and lats.',
      instructions: [
        'Sit comfortably at the machine.',
        'Grip the bar wider than shoulder-width.',
        'Pull the bar toward your upper chest.',
        'Return slowly.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 75,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'gym_cable_row',
      name: 'Seated Cable Row',
      category: 'Gym Workout',
      muscleGroup: 'Back',
      equipment: ExerciseEquipment.cable,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 5,
      description:
          'A horizontal pulling exercise for back strength.',
      instructions: [
        'Sit upright with your feet supported.',
        'Grip the handle.',
        'Pull toward your torso.',
        'Squeeze your shoulder blades.',
        'Return slowly.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 75,
    ),

    ExerciseModel(
      id: 'gym_leg_press',
      name: 'Leg Press',
      category: 'Gym Workout',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.machine,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 8,
      caloriesPerMinute: 6,
      description:
          'A machine-based lower-body strength exercise.',
      instructions: [
        'Sit into the machine with your back supported.',
        'Place your feet firmly on the platform.',
        'Lower the platform under control.',
        'Push back without locking your knees.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 90,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'gym_triceps_pushdown',
      name: 'Cable Triceps Pushdown',
      category: 'Gym Workout',
      muscleGroup: 'Triceps',
      equipment: ExerciseEquipment.cable,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 7,
      caloriesPerMinute: 4,
      description:
          'An isolation movement for strengthening the triceps.',
      instructions: [
        'Stand facing the cable machine.',
        'Grip the attachment.',
        'Keep your elbows close to your sides.',
        'Push the handle downward.',
        'Return slowly.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 60,
    ),

    ExerciseModel(
      id: 'gym_chest_fly',
      name: 'Machine Chest Fly',
      category: 'Gym Workout',
      muscleGroup: 'Chest',
      equipment: ExerciseEquipment.machine,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 7,
      caloriesPerMinute: 4,
      description:
          'A controlled machine exercise for the chest.',
      instructions: [
        'Adjust the machine seat.',
        'Hold the handles with your elbows slightly bent.',
        'Bring the handles together.',
        'Return with control.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 60,
    ),

    // ==========================================================
    // STRETCHING
    // ==========================================================

    ExerciseModel(
      id: 'stretch_hamstring',
      name: 'Standing Hamstring Stretch',
      category: 'Stretching',
      muscleGroup: 'Hamstrings',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 2,
      description:
          'A gentle stretch for the muscles along the back of the thigh.',
      instructions: [
        'Stand tall and place one heel slightly forward.',
        'Keep the extended leg mostly straight.',
        'Hinge gently at the hips.',
        'Hold the stretch comfortably.',
        'Switch sides.',
      ],
      sets: 2,
      repetitions: 1,
      restSeconds: 20,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'stretch_quad',
      name: 'Standing Quad Stretch',
      category: 'Stretching',
      muscleGroup: 'Quadriceps',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 2,
      description:
          'A basic standing stretch for the front of the thigh.',
      instructions: [
        'Stand tall and hold a stable surface if needed.',
        'Bend one knee.',
        'Bring your heel toward your glutes.',
        'Hold gently.',
        'Switch sides.',
      ],
      sets: 2,
      repetitions: 1,
      restSeconds: 20,
    ),

    ExerciseModel(
      id: 'stretch_shoulder',
      name: 'Cross-Body Shoulder Stretch',
      category: 'Stretching',
      muscleGroup: 'Shoulders',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 4,
      caloriesPerMinute: 2,
      description:
          'A simple upper-body stretch for shoulder mobility.',
      instructions: [
        'Bring one arm across your chest.',
        'Use the opposite arm to gently pull it closer.',
        'Keep your shoulder relaxed.',
        'Hold comfortably.',
        'Switch sides.',
      ],
      sets: 2,
      repetitions: 1,
      restSeconds: 20,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'stretch_cat_cow',
      name: 'Cat-Cow',
      category: 'Stretching',
      muscleGroup: 'Back',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 2,
      description:
          'A gentle mobility exercise for the spine.',
      instructions: [
        'Start on your hands and knees.',
        'Round your back gently.',
        'Then move into a comfortable extended position.',
        'Move slowly with your breathing.',
      ],
      sets: 2,
      repetitions: 10,
      restSeconds: 20,
      isFeatured: true,
    ),

    ExerciseModel(
      id: 'stretch_child_pose',
      name: 'Child\'s Pose',
      category: 'Stretching',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 1,
      description:
          'A relaxing stretch that can help with recovery and mobility.',
      instructions: [
        'Start on your hands and knees.',
        'Move your hips back toward your heels.',
        'Extend your arms forward.',
        'Relax and breathe steadily.',
      ],
      sets: 2,
      repetitions: 1,
      restSeconds: 20,
    ),

    ExerciseModel(
      id: 'stretch_cobra',
      name: 'Cobra Stretch',
      category: 'Stretching',
      muscleGroup: 'Core',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 4,
      caloriesPerMinute: 1,
      description:
          'A gentle extension stretch for the front of the body.',
      instructions: [
        'Lie face down.',
        'Place your hands near your shoulders.',
        'Press gently through your hands.',
        'Lift your chest without forcing the movement.',
        'Hold comfortably.',
      ],
      sets: 2,
      repetitions: 1,
      restSeconds: 20,
    ),

    // ==========================================================
    // EXPANDED GYM LIBRARY
    // ==========================================================

    ExerciseModel(
      id: 'gym_incline_barbell_press',
      name: 'Incline Barbell Press',
      category: 'Gym Workout',
      muscleGroup: 'Chest',
      equipment: ExerciseEquipment.barbell,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 9,
      caloriesPerMinute: 6,
      description: 'An upper-chest focused compound press performed on an incline bench.',
      instructions: [
        'Set the bench to a moderate incline.',
        'Grip the bar slightly wider than shoulder-width.',
        'Lower the bar toward the upper chest with control.',
        'Press the bar back up without losing your setup.',
      ],
      sets: 4,
      repetitions: 8,
      restSeconds: 120,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'gym_incline_dumbbell_press',
      name: 'Incline Dumbbell Press',
      category: 'Gym Workout',
      muscleGroup: 'Chest',
      equipment: ExerciseEquipment.dumbbells,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 6,
      description: 'A unilateral-friendly pressing movement that emphasizes the upper chest.',
      instructions: [
        'Lie back on an incline bench with a dumbbell in each hand.',
        'Start with the weights near chest level.',
        'Press the dumbbells upward and slightly inward.',
        'Lower them slowly to a comfortable range.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 90,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'gym_dumbbell_lateral_raise',
      name: 'Dumbbell Lateral Raise',
      category: 'Gym Workout',
      muscleGroup: 'Shoulders',
      equipment: ExerciseEquipment.dumbbells,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 6,
      caloriesPerMinute: 4,
      description: 'An isolation exercise for the lateral deltoids.',
      instructions: [
        'Stand tall with dumbbells beside your thighs.',
        'Keep a soft bend in your elbows.',
        'Raise the dumbbells outward to about shoulder height.',
        'Lower them slowly without swinging.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 60,
    ),

    ExerciseModel(
      id: 'gym_overhead_press',
      name: 'Barbell Overhead Press',
      category: 'Gym Workout',
      muscleGroup: 'Shoulders',
      equipment: ExerciseEquipment.barbell,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 6,
      description: 'A compound vertical press for shoulders and upper-body strength.',
      instructions: [
        'Start with the bar at upper-chest height.',
        'Brace your core and keep your glutes engaged.',
        'Press the bar vertically overhead.',
        'Lower it under control to the starting position.',
      ],
      sets: 4,
      repetitions: 8,
      restSeconds: 120,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'gym_cable_crossover',
      name: 'Cable Crossover',
      category: 'Gym Workout',
      muscleGroup: 'Chest',
      equipment: ExerciseEquipment.cable,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 7,
      caloriesPerMinute: 5,
      description: 'A cable fly variation that trains the chest through a controlled range.',
      instructions: [
        'Set both cable handles around chest height.',
        'Stand centered and take a stable staggered stance.',
        'Bring the handles together in front of the chest.',
        'Return slowly while keeping tension on the chest.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 60,
    ),

    ExerciseModel(
      id: 'gym_close_grip_bench',
      name: 'Close-Grip Bench Press',
      category: 'Gym Workout',
      muscleGroup: 'Triceps',
      equipment: ExerciseEquipment.barbell,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 6,
      description: 'A compound press with a narrower grip to emphasize the triceps.',
      instructions: [
        'Lie on the bench with a grip slightly inside shoulder-width.',
        'Unrack the bar with a stable upper back.',
        'Lower the bar toward the lower chest.',
        'Press up while keeping the elbows controlled.',
      ],
      sets: 3,
      repetitions: 8,
      restSeconds: 90,
    ),

    ExerciseModel(
      id: 'gym_cable_triceps_overhead',
      name: 'Cable Overhead Triceps Extension',
      category: 'Gym Workout',
      muscleGroup: 'Triceps',
      equipment: ExerciseEquipment.cable,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 6,
      caloriesPerMinute: 4,
      description: 'An overhead cable isolation exercise for the triceps.',
      instructions: [
        'Face away from the cable stack with the handle behind your head.',
        'Keep your upper arms stable.',
        'Extend your elbows until your arms are straight.',
        'Return slowly to the stretched position.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 60,
    ),

    ExerciseModel(
      id: 'gym_barbell_row',
      name: 'Barbell Row',
      category: 'Gym Workout',
      muscleGroup: 'Back',
      equipment: ExerciseEquipment.barbell,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 9,
      caloriesPerMinute: 6,
      description: 'A compound horizontal pull for the upper back and lats.',
      instructions: [
        'Hinge at the hips with a neutral spine.',
        'Hold the bar slightly wider than shoulder-width.',
        'Pull the bar toward your lower ribs.',
        'Lower it with control without losing your position.',
      ],
      sets: 4,
      repetitions: 8,
      restSeconds: 120,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'gym_one_arm_dumbbell_row',
      name: 'One-Arm Dumbbell Row',
      category: 'Gym Workout',
      muscleGroup: 'Back',
      equipment: ExerciseEquipment.dumbbells,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 7,
      caloriesPerMinute: 5,
      description: 'A supported unilateral row for the lats and upper back.',
      instructions: [
        'Support one hand and knee on a bench.',
        'Let the dumbbell hang under the shoulder.',
        'Pull the weight toward your hip.',
        'Lower it slowly and repeat on the other side.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 75,
    ),

    ExerciseModel(
      id: 'gym_face_pull',
      name: 'Cable Face Pull',
      category: 'Gym Workout',
      muscleGroup: 'Shoulders',
      equipment: ExerciseEquipment.cable,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 6,
      caloriesPerMinute: 4,
      description: 'A cable pulling exercise for the rear shoulders and upper back.',
      instructions: [
        'Set the rope attachment around face height.',
        'Grip the rope and step back to create tension.',
        'Pull toward your face while opening the hands.',
        'Return slowly while keeping the shoulders controlled.',
      ],
      sets: 3,
      repetitions: 15,
      restSeconds: 60,
    ),

    ExerciseModel(
      id: 'gym_preacher_curl',
      name: 'Preacher Curl',
      category: 'Gym Workout',
      muscleGroup: 'Biceps',
      equipment: ExerciseEquipment.dumbbells,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 6,
      caloriesPerMinute: 4,
      description: 'A supported curl variation that limits momentum during elbow flexion.',
      instructions: [
        'Set your upper arms securely against the pad.',
        'Start with the weight under control.',
        'Curl toward the shoulder without lifting the upper arm.',
        'Lower slowly to near full extension.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 60,
    ),

    ExerciseModel(
      id: 'gym_hammer_curl',
      name: 'Dumbbell Hammer Curl',
      category: 'Gym Workout',
      muscleGroup: 'Biceps',
      equipment: ExerciseEquipment.dumbbells,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 6,
      caloriesPerMinute: 4,
      description: 'A neutral-grip curl that trains the biceps and forearms.',
      instructions: [
        'Stand tall with your palms facing each other.',
        'Keep the elbows close to your sides.',
        'Curl the dumbbells without rotating the wrists.',
        'Lower them slowly.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 60,
    ),

    ExerciseModel(
      id: 'gym_deadlift',
      name: 'Barbell Deadlift',
      category: 'Gym Workout',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.barbell,
      difficulty: ExerciseDifficulty.advanced,
      durationMinutes: 10,
      caloriesPerMinute: 9,
      description: 'A compound hinge movement for the posterior chain and total-body strength.',
      instructions: [
        'Stand with the bar over the middle of your feet.',
        'Brace your trunk and set your back neutral.',
        'Drive through the floor as the hips and shoulders rise together.',
        'Stand tall and lower the bar under control.',
      ],
      sets: 4,
      repetitions: 5,
      restSeconds: 150,
      isPopular: true,
      isFeatured: true,
    ),

    ExerciseModel(
      id: 'gym_romanian_deadlift',
      name: 'Romanian Deadlift',
      category: 'Gym Workout',
      muscleGroup: 'Hamstrings',
      equipment: ExerciseEquipment.barbell,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 7,
      description: 'A controlled hip-hinge movement emphasizing the hamstrings and glutes.',
      instructions: [
        'Hold the bar in front of your thighs.',
        'Push your hips back while keeping the bar close.',
        'Lower until you feel strong hamstring tension.',
        'Drive the hips forward to stand tall.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 90,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'gym_walking_lunges',
      name: 'Walking Lunges',
      category: 'Gym Workout',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.dumbbells,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 7,
      description: 'A loaded unilateral leg exercise for strength, balance and control.',
      instructions: [
        'Hold the dumbbells by your sides.',
        'Step forward into a controlled lunge.',
        'Push through the front foot to step through.',
        'Continue alternating legs.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 75,
    ),

    ExerciseModel(
      id: 'gym_leg_extension',
      name: 'Leg Extension',
      category: 'Gym Workout',
      muscleGroup: 'Quadriceps',
      equipment: ExerciseEquipment.machine,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 6,
      caloriesPerMinute: 4,
      description: 'A machine-based isolation exercise for the quadriceps.',
      instructions: [
        'Adjust the seat and shin pad to fit your legs.',
        'Brace your torso against the backrest.',
        'Extend the knees until the legs are nearly straight.',
        'Lower slowly and repeat.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 60,
    ),

    ExerciseModel(
      id: 'gym_seated_leg_curl',
      name: 'Seated Leg Curl',
      category: 'Gym Workout',
      muscleGroup: 'Hamstrings',
      equipment: ExerciseEquipment.machine,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 6,
      caloriesPerMinute: 4,
      description: 'A machine-based hamstring isolation exercise.',
      instructions: [
        'Adjust the seat and pad so the knees align with the machine pivot.',
        'Brace against the backrest.',
        'Curl the lower legs down and back.',
        'Return the pads slowly.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 60,
    ),

    ExerciseModel(
      id: 'gym_hip_thrust',
      name: 'Barbell Hip Thrust',
      category: 'Gym Workout',
      muscleGroup: 'Glutes',
      equipment: ExerciseEquipment.barbell,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 6,
      description: 'A loaded hip-extension movement with strong glute emphasis.',
      instructions: [
        'Set your upper back against a stable bench.',
        'Place the padded bar across the hips.',
        'Drive through the feet and extend the hips.',
        'Pause briefly at the top and lower with control.',
      ],
      sets: 4,
      repetitions: 10,
      restSeconds: 90,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'gym_hack_squat',
      name: 'Hack Squat',
      category: 'Gym Workout',
      muscleGroup: 'Quadriceps',
      equipment: ExerciseEquipment.machine,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 7,
      description: 'A machine squat variation emphasizing the quads and glutes.',
      instructions: [
        'Set your back and shoulders firmly against the pads.',
        'Place your feet comfortably on the platform.',
        'Lower under control as the knees and hips bend.',
        'Drive through the platform to return to the top.',
      ],
      sets: 4,
      repetitions: 10,
      restSeconds: 90,
    ),

    // ==========================================================
    // EXPANDED HOME LIBRARY
    // ==========================================================

    ExerciseModel(
      id: 'home_incline_pushups',
      name: 'Incline Push-Ups',
      category: 'Home Workout',
      muscleGroup: 'Chest',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 6,
      caloriesPerMinute: 5,
      description: 'A scaled push-up using a stable elevated surface.',
      instructions: [
        'Place your hands on a stable elevated surface.',
        'Walk your feet back into a straight-body position.',
        'Lower your chest toward the surface.',
        'Press away while keeping the body aligned.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 45,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'home_diamond_pushups',
      name: 'Diamond Push-Ups',
      category: 'Home Workout',
      muscleGroup: 'Triceps',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.advanced,
      durationMinutes: 6,
      caloriesPerMinute: 7,
      description: 'A narrow-hand push-up variation with greater triceps demand.',
      instructions: [
        'Start in a strong high plank.',
        'Place the hands close together under the chest.',
        'Lower with the elbows controlled.',
        'Press the floor away to return.',
      ],
      sets: 3,
      repetitions: 8,
      restSeconds: 75,
    ),

    ExerciseModel(
      id: 'home_decline_pushups',
      name: 'Decline Push-Ups',
      category: 'Home Workout',
      muscleGroup: 'Chest',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.advanced,
      durationMinutes: 6,
      caloriesPerMinute: 7,
      description: 'A harder push-up variation with the feet elevated on a stable surface.',
      instructions: [
        'Place your feet on a stable low platform.',
        'Set your hands slightly wider than shoulder-width.',
        'Lower the chest with control.',
        'Press back up while maintaining a straight line.',
      ],
      sets: 3,
      repetitions: 8,
      restSeconds: 75,
    ),

    ExerciseModel(
      id: 'home_pike_pushups',
      name: 'Pike Push-Ups',
      category: 'Home Workout',
      muscleGroup: 'Shoulders',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 6,
      caloriesPerMinute: 6,
      description: 'A bodyweight press variation that emphasizes the shoulders.',
      instructions: [
        'Start in a downward-dog-like pike position.',
        'Bend the elbows and lower the head toward the floor.',
        'Keep the hips high as you press back up.',
        'Move under control through the full range.',
      ],
      sets: 3,
      repetitions: 8,
      restSeconds: 60,
    ),

    ExerciseModel(
      id: 'home_superman',
      name: 'Superman',
      category: 'Home Workout',
      muscleGroup: 'Back',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 4,
      description: 'A floor-based posterior-chain movement for the back and glutes.',
      instructions: [
        'Lie face down with arms extended.',
        'Brace gently through the trunk.',
        'Lift the arms and legs a small distance from the floor.',
        'Pause briefly and lower with control.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 45,
    ),

    ExerciseModel(
      id: 'home_towel_rows',
      name: 'Towel Rows',
      category: 'Home Workout',
      muscleGroup: 'Back',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 6,
      caloriesPerMinute: 5,
      description: 'A household-friendly pulling drill using a sturdy towel and safe setup.',
      instructions: [
        'Secure a towel only around a stable structure that can safely resist your force.',
        'Lean back while keeping a rigid body position.',
        'Pull your chest toward the anchor.',
        'Return slowly and keep the setup controlled.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 60,
    ),

    ExerciseModel(
      id: 'home_prone_y_raise',
      name: 'Prone Y Raise',
      category: 'Home Workout',
      muscleGroup: 'Shoulders',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 3,
      description: 'A low-load floor movement for the upper back and rear shoulders.',
      instructions: [
        'Lie face down with arms extended in a Y shape.',
        'Keep the neck relaxed.',
        'Lift the arms gently from the floor.',
        'Lower slowly and repeat.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 40,
    ),

    ExerciseModel(
      id: 'home_split_squats',
      name: 'Split Squats',
      category: 'Home Workout',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 7,
      caloriesPerMinute: 6,
      description: 'A unilateral squat pattern for quads, glutes and balance.',
      instructions: [
        'Take a staggered stance with one foot forward.',
        'Lower the back knee toward the floor.',
        'Keep most of the pressure through the front foot.',
        'Drive upward and switch sides.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 60,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'home_bulgarian_split_squats',
      name: 'Bulgarian Split Squats',
      category: 'Home Workout',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.advanced,
      durationMinutes: 8,
      caloriesPerMinute: 7,
      description: 'A single-leg strength movement using a stable elevated rear foot.',
      instructions: [
        'Place the rear foot on a stable low surface.',
        'Keep the front foot far enough forward for a comfortable range.',
        'Lower under control while keeping balance.',
        'Drive through the front foot to rise.',
      ],
      sets: 3,
      repetitions: 8,
      restSeconds: 75,
    ),

    ExerciseModel(
      id: 'home_single_leg_glute_bridge',
      name: 'Single-Leg Glute Bridge',
      category: 'Home Workout',
      muscleGroup: 'Glutes',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 6,
      caloriesPerMinute: 5,
      description: 'A unilateral bridge progression for glutes and hip stability.',
      instructions: [
        'Lie on your back with one foot planted.',
        'Extend the opposite leg.',
        'Lift the hips by driving through the planted foot.',
        'Lower with control and switch sides.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 45,
    ),

    ExerciseModel(
      id: 'home_calf_raises',
      name: 'Standing Calf Raises',
      category: 'Home Workout',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 3,
      description: 'A simple calf-strengthening movement requiring no equipment.',
      instructions: [
        'Stand tall with feet hip-width apart.',
        'Rise onto the balls of the feet.',
        'Pause briefly at the top.',
        'Lower slowly until the heels are down.',
      ],
      sets: 3,
      repetitions: 20,
      restSeconds: 30,
    ),

    ExerciseModel(
      id: 'home_step_ups',
      name: 'Step-Ups',
      category: 'Home Workout',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 7,
      caloriesPerMinute: 7,
      description: 'A practical lower-body and conditioning drill using a stable low step.',
      instructions: [
        'Use a stable low step or platform.',
        'Place one foot fully on the surface.',
        'Drive through that foot to stand up.',
        'Step down under control and alternate sides.',
      ],
      sets: 3,
      repetitions: 10,
      restSeconds: 45,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'home_high_knees',
      name: 'Home High Knees',
      category: 'Home Workout',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 6,
      caloriesPerMinute: 10,
      description: 'A space-efficient cardio drill that rapidly raises the heart rate.',
      instructions: [
        'Stand tall with an active core.',
        'Drive one knee upward.',
        'Quickly switch sides.',
        'Keep the movement light and rhythmic.',
      ],
      sets: 4,
      repetitions: 30,
      restSeconds: 30,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'home_butt_kicks',
      name: 'Butt Kicks',
      category: 'Home Workout',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 6,
      caloriesPerMinute: 8,
      description: 'A low-space cardio drill with alternating heel drives toward the glutes.',
      instructions: [
        'Stand tall with a light athletic stance.',
        'Drive one heel toward the glute.',
        'Switch legs continuously.',
        'Use your arms naturally and stay light on the feet.',
      ],
      sets: 4,
      repetitions: 30,
      restSeconds: 30,
    ),

    ExerciseModel(
      id: 'home_fast_feet',
      name: 'Fast Feet',
      category: 'Home Workout',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 5,
      caloriesPerMinute: 9,
      description: 'A quick-footwork conditioning drill requiring very little space.',
      instructions: [
        'Stand in a comfortable athletic stance.',
        'Take very small rapid steps in place.',
        'Keep the torso tall and relaxed.',
        'Maintain a quick but controlled rhythm.',
      ],
      sets: 5,
      repetitions: 20,
      restSeconds: 30,
    ),

    ExerciseModel(
      id: 'home_shadow_boxing',
      name: 'Shadow Boxing',
      category: 'Home Workout',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 8,
      caloriesPerMinute: 9,
      description: 'A no-equipment cardio drill combining footwork and controlled punches.',
      instructions: [
        'Adopt a balanced stance with hands up.',
        'Throw controlled straight punches into the air.',
        'Move the feet lightly between combinations.',
        'Keep the shoulders relaxed and return the hands to guard.',
      ],
      sets: 4,
      repetitions: 60,
      restSeconds: 45,
      isPopular: true,
    ),

    ExerciseModel(
      id: 'home_bear_crawl',
      name: 'Bear Crawl',
      category: 'Home Workout',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.intermediate,
      durationMinutes: 6,
      caloriesPerMinute: 8,
      description: 'A full-body crawling pattern that challenges shoulders, legs and core.',
      instructions: [
        'Start on hands and feet with knees hovering low.',
        'Move the opposite hand and foot together.',
        'Keep the hips controlled and close to level.',
        'Travel slowly for quality repetitions.',
      ],
      sets: 4,
      repetitions: 20,
      restSeconds: 45,
    ),

    ExerciseModel(
      id: 'home_squat_jumps',
      name: 'Squat Jumps',
      category: 'Home Workout',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.advanced,
      durationMinutes: 6,
      caloriesPerMinute: 10,
      description: 'An explosive bodyweight squat variation for lower-body power.',
      instructions: [
        'Lower into a controlled squat.',
        'Drive through the feet to jump upward.',
        'Land softly with bent knees.',
        'Reset before the next repetition.',
      ],
      sets: 4,
      repetitions: 10,
      restSeconds: 45,
    ),

    ExerciseModel(
      id: 'home_pushup_jacks',
      name: 'Push-Up Jacks',
      category: 'Home Workout',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.advanced,
      durationMinutes: 6,
      caloriesPerMinute: 11,
      description: 'A demanding bodyweight drill combining push-ups with rapid foot movement.',
      instructions: [
        'Start in a high plank.',
        'Perform a controlled push-up.',
        'Jump or step the feet wider and back in.',
        'Keep the trunk stable throughout the sequence.',
      ],
      sets: 3,
      repetitions: 8,
      restSeconds: 60,
    ),

    ExerciseModel(
      id: 'home_bear_crawl_shoulder_taps',
      name: 'Bear Crawl Shoulder Taps',
      category: 'Home Workout',
      muscleGroup: 'Core',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.advanced,
      durationMinutes: 6,
      caloriesPerMinute: 8,
      description: 'A core-intensive bear position drill with alternating shoulder taps.',
      instructions: [
        'Set up in a bear position with knees hovering.',
        'Lift one hand and tap the opposite shoulder.',
        'Place it down without shifting the hips excessively.',
        'Alternate sides slowly and deliberately.',
      ],
      sets: 3,
      repetitions: 12,
      restSeconds: 45,
    ),

    // ==========================================================
    // MOBILITY + YOGA
    // ==========================================================

    ExerciseModel(
      id: 'mobility_90_90',
      name: '90/90 Hip Switch',
      category: 'Mobility',
      muscleGroup: 'Glutes',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 2,
      description: 'A controlled hip-rotation drill for mobility and movement quality.',
      instructions: [
        'Sit with both knees bent in a 90/90 position.',
        'Keep the torso tall.',
        'Rotate the knees together toward the opposite side.',
        'Move slowly and stay within a comfortable range.',
      ],
      sets: 2,
      repetitions: 8,
      restSeconds: 20,
    ),

    ExerciseModel(
      id: 'mobility_world_greatest_stretch',
      name: 'World’s Greatest Stretch',
      category: 'Mobility',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 6,
      caloriesPerMinute: 2,
      description: 'A multi-joint mobility sequence for hips, thoracic spine and shoulders.',
      instructions: [
        'Step one foot forward into a lunge.',
        'Place both hands inside the front foot.',
        'Rotate the same-side arm upward.',
        'Return to the starting position and switch sides.',
      ],
      sets: 2,
      repetitions: 5,
      restSeconds: 20,
      isFeatured: true,
    ),

    ExerciseModel(
      id: 'mobility_deep_squat_hold',
      name: 'Deep Squat Hold',
      category: 'Mobility',
      muscleGroup: 'Legs',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 4,
      caloriesPerMinute: 2,
      description: 'A supported mobility hold for the hips and ankles.',
      instructions: [
        'Take a comfortable wide stance.',
        'Lower into a deep squat only as far as comfortable.',
        'Keep the chest lifted and heels grounded when possible.',
        'Breathe steadily while holding the position.',
      ],
      sets: 2,
      repetitions: 1,
      restSeconds: 30,
    ),

    ExerciseModel(
      id: 'yoga_cat_cow_flow',
      name: 'Cat-Cow Flow',
      category: 'Yoga',
      muscleGroup: 'Back',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 2,
      description: 'A gentle yoga-inspired spinal movement linked to breathing.',
      instructions: [
        'Start on hands and knees.',
        'Inhale as the chest opens and the spine extends comfortably.',
        'Exhale as the spine rounds gently.',
        'Move slowly with the breath.',
      ],
      sets: 2,
      repetitions: 8,
      restSeconds: 20,
    ),

    ExerciseModel(
      id: 'yoga_downward_dog',
      name: 'Downward-Facing Dog',
      category: 'Yoga',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 2,
      description: 'A foundational yoga posture for whole-body mobility and control.',
      instructions: [
        'Start on hands and knees.',
        'Lift the hips up and back.',
        'Press through the hands while lengthening the spine.',
        'Keep the knees softly bent when needed.',
      ],
      sets: 2,
      repetitions: 1,
      restSeconds: 30,
      isFeatured: true,
    ),

    ExerciseModel(
      id: 'yoga_child_pose_breathing',
      name: 'Child’s Pose Breathing',
      category: 'Yoga',
      muscleGroup: 'Full Body',
      equipment: ExerciseEquipment.none,
      difficulty: ExerciseDifficulty.beginner,
      durationMinutes: 5,
      caloriesPerMinute: 1,
      description: 'A gentle recovery posture paired with slow breathing.',
      instructions: [
        'Kneel and sit the hips back toward the heels.',
        'Extend the arms forward or rest them beside the body.',
        'Relax the shoulders and jaw.',
        'Take slow comfortable breaths.',
      ],
      sets: 2,
      repetitions: 1,
      restSeconds: 20,
    ),

  ];

  // ============================================================
  // SEARCH
  // ============================================================

  static List<ExerciseModel> search(
    String query,
  ) {
    final text =
        query.trim().toLowerCase();

    if (text.isEmpty) {
      return all;
    }

    return all.where(
      (exercise) {
        return exercise.name
                .toLowerCase()
                .contains(text) ||
            exercise.category
                .toLowerCase()
                .contains(text) ||
            exercise.muscleGroup
                .toLowerCase()
                .contains(text) ||
            exercise.equipmentName
                .toLowerCase()
                .contains(text) ||
            exercise.difficultyName
                .toLowerCase()
                .contains(text);
      },
    ).toList();
  }

  // ============================================================
  // BY CATEGORY
  // ============================================================

  static List<ExerciseModel> byCategory(
    String category,
  ) {
    final text =
        category.trim().toLowerCase();

    if (text.isEmpty) {
      return all;
    }

    return all.where(
      (exercise) =>
          exercise.category
              .toLowerCase() ==
          text,
    ).toList();
  }

  // ============================================================
  // BY MUSCLE GROUP
  // ============================================================

  static List<ExerciseModel> byMuscleGroup(
    String muscleGroup,
  ) {
    final text =
        muscleGroup.trim().toLowerCase();

    if (text.isEmpty) {
      return all;
    }

    return all.where(
      (exercise) =>
          exercise.muscleGroup
              .toLowerCase() ==
          text,
    ).toList();
  }

  // ============================================================
  // POPULAR
  // ============================================================

  static List<ExerciseModel>
      get popular {
    return all
        .where(
          (exercise) =>
              exercise.isPopular,
        )
        .toList();
  }

  // ============================================================
  // FEATURED
  // ============================================================

  static List<ExerciseModel>
      get featured {
    return all
        .where(
          (exercise) =>
              exercise.isFeatured,
        )
        .toList();
  }

  // ============================================================
  // BEGINNER
  // ============================================================

  static List<ExerciseModel>
      get beginner {
    return all
        .where(
          (exercise) =>
              exercise.difficulty ==
              ExerciseDifficulty
                  .beginner,
        )
        .toList();
  }

  // ============================================================
  // INTERMEDIATE
  // ============================================================

  static List<ExerciseModel>
      get intermediate {
    return all
        .where(
          (exercise) =>
              exercise.difficulty ==
              ExerciseDifficulty
                  .intermediate,
        )
        .toList();
  }

  // ============================================================
  // ADVANCED
  // ============================================================

  static List<ExerciseModel>
      get advanced {
    return all
        .where(
          (exercise) =>
              exercise.difficulty ==
              ExerciseDifficulty
                  .advanced,
        )
        .toList();
  }

  // ============================================================
  // FIND BY ID
  // ============================================================

  static ExerciseModel? findById(
    String id,
  ) {
    for (final exercise
        in all) {
      if (exercise.id == id) {
        return exercise;
      }
    }

    return null;
  }
}