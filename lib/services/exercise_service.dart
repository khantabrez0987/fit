import '../models/exercise.dart';
import '../models/workout.dart';

class ExerciseService {
  // Get all exercises
  Future<List<Exercise>> getAllExercises() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _getDefaultExercises();
  }

  // Get all workouts
  Future<List<Workout>> getAllWorkouts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getDefaultWorkouts();
  }

  // Get workout sessions
  Future<List<WorkoutSession>> getWorkoutSessions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  // Get exercises by category
  Future<List<Exercise>> getExercisesByCategory(String category) async {
    final allExercises = await getAllExercises();
    return allExercises.where((exercise) => 
      exercise.category.toLowerCase() == category.toLowerCase()
    ).toList();
  }

  // Get exercises by difficulty
  Future<List<Exercise>> getExercisesByDifficulty(String difficulty) async {
    final allExercises = await getAllExercises();
    return allExercises.where((exercise) => 
      exercise.difficulty.toLowerCase() == difficulty.toLowerCase()
    ).toList();
  }

  // Search exercises
  Future<List<Exercise>> searchExercises(String query) async {
    final allExercises = await getAllExercises();
    if (query.isEmpty) return allExercises;
    
    return allExercises.where((exercise) => 
      exercise.name.toLowerCase().contains(query.toLowerCase()) ||
      exercise.description.toLowerCase().contains(query.toLowerCase()) ||
      exercise.muscleGroups.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Default exercises data
  List<Exercise> _getDefaultExercises() {
    return [
      // Strength Exercises
      Exercise(
        id: '1',
        name: 'Push-ups',
        description: 'A classic bodyweight exercise that targets the chest, shoulders, and triceps.',
        category: 'Strength',
        muscleGroups: 'Chest, Shoulders, Triceps, Core',
        equipment: 'Bodyweight',
        difficulty: 'Beginner',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
        videoUrl: 'https://www.youtube.com/watch?v=IODxDxX7oi4',
        instructions: [
          'Start in a plank position with hands slightly wider than shoulders',
          'Keep your body in a straight line from head to heels',
          'Lower your chest towards the ground by bending your elbows',
          'Push back up to the starting position',
          'Keep your core engaged throughout the movement'
        ],
        tips: [
          'Keep your elbows at a 45-degree angle to your body',
          'Don\'t let your hips sag or pike up',
          'Breathe out as you push up, breathe in as you lower down',
          'Start with modified push-ups on your knees if needed'
        ],
        caloriesPerMinute: 8,
      ),
      Exercise(
        id: '2',
        name: 'Squats',
        description: 'A fundamental lower body exercise that targets the quadriceps, glutes, and hamstrings.',
        category: 'Strength',
        muscleGroups: 'Quadriceps, Glutes, Hamstrings, Core',
        equipment: 'Bodyweight',
        difficulty: 'Beginner',
        imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
        videoUrl: 'https://www.youtube.com/watch?v=YaXPRqUwItQ',
        instructions: [
          'Stand with feet shoulder-width apart',
          'Keep your chest up and core engaged',
          'Lower your body by bending at the hips and knees',
          'Go down until your thighs are parallel to the ground',
          'Push through your heels to return to standing'
        ],
        tips: [
          'Keep your knees in line with your toes',
          'Don\'t let your knees cave inward',
          'Keep your weight on your heels',
          'Look straight ahead, not down'
        ],
        caloriesPerMinute: 10,
      ),
      Exercise(
        id: '3',
        name: 'Plank',
        description: 'An isometric exercise that strengthens the core and improves stability.',
        category: 'Strength',
        muscleGroups: 'Core, Shoulders, Glutes',
        equipment: 'Bodyweight',
        difficulty: 'Beginner',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
        videoUrl: 'https://www.youtube.com/watch?v=pSHjTRCQxIw',
        instructions: [
          'Start in a push-up position',
          'Lower down to your forearms',
          'Keep your body in a straight line',
          'Engage your core and hold the position',
          'Breathe normally throughout the hold'
        ],
        tips: [
          'Don\'t let your hips sag or pike up',
          'Keep your head in a neutral position',
          'Engage your glutes to help maintain position',
          'Start with shorter holds and build up'
        ],
        caloriesPerMinute: 5,
      ),
      Exercise(
        id: '4',
        name: 'Lunges',
        description: 'A unilateral exercise that targets the legs and glutes while improving balance.',
        category: 'Strength',
        muscleGroups: 'Quadriceps, Glutes, Hamstrings, Calves',
        equipment: 'Bodyweight',
        difficulty: 'Beginner',
        imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
        videoUrl: 'https://www.youtube.com/watch?v=3XDriUn0uCU',
        instructions: [
          'Stand with feet hip-width apart',
          'Step forward with one leg',
          'Lower your body until both knees are at 90 degrees',
          'Push through your front heel to return to starting position',
          'Repeat with the other leg'
        ],
        tips: [
          'Keep your front knee over your ankle',
          'Don\'t let your knee go past your toes',
          'Keep your torso upright',
          'Control the movement, don\'t bounce'
        ],
        caloriesPerMinute: 9,
      ),
      Exercise(
        id: '5',
        name: 'Mountain Climbers',
        description: 'A dynamic exercise that combines cardio and strength training.',
        category: 'Cardio',
        muscleGroups: 'Core, Shoulders, Legs',
        equipment: 'Bodyweight',
        difficulty: 'Intermediate',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
        videoUrl: 'https://www.youtube.com/watch?v=nmwgirgXLYM',
        instructions: [
          'Start in a plank position',
          'Bring one knee towards your chest',
          'Quickly switch legs, bringing the other knee to your chest',
          'Continue alternating legs at a fast pace',
          'Keep your core engaged throughout'
        ],
        tips: [
          'Maintain a straight line from head to heels',
          'Keep your hips level',
          'Land softly on your toes',
          'Start slow and increase speed gradually'
        ],
        caloriesPerMinute: 12,
      ),
      Exercise(
        id: '6',
        name: 'Burpees',
        description: 'A full-body exercise that combines a squat, push-up, and jump.',
        category: 'Cardio',
        muscleGroups: 'Full Body',
        equipment: 'Bodyweight',
        difficulty: 'Advanced',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
        videoUrl: 'https://www.youtube.com/watch?v=TU8QYVW0gDU',
        instructions: [
          'Start standing with feet shoulder-width apart',
          'Squat down and place your hands on the ground',
          'Jump your feet back into a plank position',
          'Do a push-up',
          'Jump your feet back to squat position',
          'Jump up with arms overhead'
        ],
        tips: [
          'Keep your core engaged throughout',
          'Land softly on your feet',
          'Modify by stepping instead of jumping if needed',
          'Focus on form over speed'
        ],
        caloriesPerMinute: 15,
      ),
      Exercise(
        id: '7',
        name: 'Jumping Jacks',
        description: 'A simple cardio exercise that gets your heart rate up.',
        category: 'Cardio',
        muscleGroups: 'Legs, Shoulders, Core',
        equipment: 'Bodyweight',
        difficulty: 'Beginner',
        imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
        videoUrl: 'https://www.youtube.com/watch?v=UpH7rm0cYbM',
        instructions: [
          'Stand with feet together and arms at your sides',
          'Jump up, spreading your feet shoulder-width apart',
          'Simultaneously raise your arms overhead',
          'Jump back to starting position',
          'Repeat at a steady pace'
        ],
        tips: [
          'Land softly on the balls of your feet',
          'Keep your knees slightly bent',
          'Maintain good posture',
          'Breathe rhythmically'
        ],
        caloriesPerMinute: 8,
      ),
      Exercise(
        id: '8',
        name: 'High Knees',
        description: 'A cardio exercise that improves coordination and gets your heart rate up.',
        category: 'Cardio',
        muscleGroups: 'Legs, Core',
        equipment: 'Bodyweight',
        difficulty: 'Beginner',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
        videoUrl: 'https://www.youtube.com/watch?v=oDdkytliOqE',
        instructions: [
          'Stand with feet hip-width apart',
          'Run in place, bringing knees up high',
          'Pump your arms as you would when running',
          'Land softly on the balls of your feet',
          'Maintain a steady rhythm'
        ],
        tips: [
          'Keep your core engaged',
          'Land softly to protect your joints',
          'Maintain good posture',
          'Start slow and increase intensity'
        ],
        caloriesPerMinute: 10,
      ),
      Exercise(
        id: '9',
        name: 'Dead Bug',
        description: 'A core stability exercise that improves coordination and core strength.',
        category: 'Strength',
        muscleGroups: 'Core',
        equipment: 'Bodyweight',
        difficulty: 'Beginner',
        imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
        videoUrl: 'https://www.youtube.com/watch?v=g_BYB0OD-0Q',
        instructions: [
          'Lie on your back with arms extended toward ceiling',
          'Bend hips and knees to 90 degrees',
          'Lower right arm and left leg toward floor',
          'Return to starting position',
          'Repeat with opposite arm and leg'
        ],
        tips: [
          'Keep your lower back pressed to the floor',
          'Move slowly and with control',
          'Don\'t let your back arch',
          'Focus on core engagement'
        ],
        caloriesPerMinute: 4,
      ),
      Exercise(
        id: '10',
        name: 'Glute Bridges',
        description: 'A hip-dominant exercise that targets the glutes and hamstrings.',
        category: 'Strength',
        muscleGroups: 'Glutes, Hamstrings, Core',
        equipment: 'Bodyweight',
        difficulty: 'Beginner',
        imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
        videoUrl: 'https://www.youtube.com/watch?v=wPM8icPu6H8',
        instructions: [
          'Lie on your back with knees bent and feet flat',
          'Engage your core and squeeze your glutes',
          'Lift your hips up until your body forms a straight line',
          'Hold for a moment at the top',
          'Lower back down with control'
        ],
        tips: [
          'Don\'t overextend your back at the top',
          'Squeeze your glutes at the top',
          'Keep your feet hip-width apart',
          'Breathe out as you lift up'
        ],
        caloriesPerMinute: 6,
      ),
      // Yoga/Stretching Exercises
      Exercise(
        id: '11',
        name: 'Downward Dog',
        description: 'A yoga pose that stretches the entire body and builds strength.',
        category: 'Flexibility',
        muscleGroups: 'Full Body',
        equipment: 'Bodyweight',
        difficulty: 'Beginner',
        imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
        videoUrl: 'https://www.youtube.com/watch?v=BIQdWA8_apg',
        instructions: [
          'Start on hands and knees',
          'Tuck your toes and lift your hips up',
          'Straighten your legs as much as comfortable',
          'Keep your arms straight and shoulders away from ears',
          'Hold the position and breathe deeply'
        ],
        tips: [
          'Keep your spine long',
          'Don\'t worry if your heels don\'t touch the ground',
          'Bend your knees slightly if needed',
          'Focus on lengthening your spine'
        ],
        caloriesPerMinute: 3,
      ),
      Exercise(
        id: '12',
        name: 'Warrior III',
        description: 'A balancing yoga pose that strengthens the legs and core.',
        category: 'Flexibility',
        muscleGroups: 'Legs, Core, Glutes',
        equipment: 'Bodyweight',
        difficulty: 'Intermediate',
        imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
        videoUrl: 'https://www.youtube.com/watch?v=5aVH0OqJN5Y',
        instructions: [
          'Stand on one leg',
          'Hinge forward at the hip while lifting the other leg back',
          'Extend your arms forward for balance',
          'Keep your standing leg straight',
          'Hold the position and breathe'
        ],
        tips: [
          'Keep your core engaged',
          'Don\'t lock your standing knee',
          'Start with a shorter hold and build up',
          'Use a wall for support if needed'
        ],
        caloriesPerMinute: 4,
      ),
    ];
  }

  // Default workouts data
  List<Workout> _getDefaultWorkouts() {
    return [
      Workout(
        id: '1',
        name: 'Beginner Full Body',
        description: 'A complete workout for beginners that targets all major muscle groups.',
        category: 'Strength',
        difficulty: 'Beginner',
        estimatedDuration: 30,
        exercises: [
          WorkoutExercise(
            id: '1',
            exerciseId: '1',
            exerciseName: 'Push-ups',
            order: 1,
            sets: 3,
            reps: 10,
            weight: 0,
            duration: 0,
            restTime: 60,
            notes: 'Modify on knees if needed',
          ),
          WorkoutExercise(
            id: '2',
            exerciseId: '2',
            exerciseName: 'Squats',
            order: 2,
            sets: 3,
            reps: 15,
            weight: 0,
            duration: 0,
            restTime: 60,
            notes: 'Keep knees in line with toes',
          ),
          WorkoutExercise(
            id: '3',
            exerciseId: '3',
            exerciseName: 'Plank',
            order: 3,
            sets: 3,
            reps: 1,
            weight: 0,
            duration: 30,
            restTime: 60,
            notes: 'Hold for 30 seconds',
          ),
          WorkoutExercise(
            id: '4',
            exerciseId: '4',
            exerciseName: 'Lunges',
            order: 4,
            sets: 3,
            reps: 12,
            weight: 0,
            duration: 0,
            restTime: 60,
            notes: '6 per leg',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now(),
      ),
      Workout(
        id: '2',
        name: 'Cardio Blast',
        description: 'High-intensity cardio workout to get your heart pumping.',
        category: 'Cardio',
        difficulty: 'Intermediate',
        estimatedDuration: 25,
        exercises: [
          WorkoutExercise(
            id: '5',
            exerciseId: '7',
            exerciseName: 'Jumping Jacks',
            order: 1,
            sets: 4,
            reps: 1,
            weight: 0,
            duration: 60,
            restTime: 30,
            notes: '1 minute of jumping jacks',
          ),
          WorkoutExercise(
            id: '6',
            exerciseId: '8',
            exerciseName: 'High Knees',
            order: 2,
            sets: 4,
            reps: 1,
            weight: 0,
            duration: 45,
            restTime: 30,
            notes: '45 seconds of high knees',
          ),
          WorkoutExercise(
            id: '7',
            exerciseId: '5',
            exerciseName: 'Mountain Climbers',
            order: 3,
            sets: 4,
            reps: 1,
            weight: 0,
            duration: 30,
            restTime: 30,
            notes: '30 seconds of mountain climbers',
          ),
          WorkoutExercise(
            id: '8',
            exerciseId: '6',
            exerciseName: 'Burpees',
            order: 4,
            sets: 3,
            reps: 8,
            weight: 0,
            duration: 0,
            restTime: 60,
            notes: 'Modify if needed',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
      ),
      Workout(
        id: '3',
        name: 'Core Strength',
        description: 'Focused workout to build a strong core.',
        category: 'Strength',
        difficulty: 'Intermediate',
        estimatedDuration: 20,
        exercises: [
          WorkoutExercise(
            id: '9',
            exerciseId: '3',
            exerciseName: 'Plank',
            order: 1,
            sets: 4,
            reps: 1,
            weight: 0,
            duration: 45,
            restTime: 60,
            notes: 'Hold for 45 seconds',
          ),
          WorkoutExercise(
            id: '10',
            exerciseId: '9',
            exerciseName: 'Dead Bug',
            order: 2,
            sets: 3,
            reps: 12,
            weight: 0,
            duration: 0,
            restTime: 45,
            notes: '6 per side',
          ),
          WorkoutExercise(
            id: '11',
            exerciseId: '10',
            exerciseName: 'Glute Bridges',
            order: 3,
            sets: 3,
            reps: 15,
            weight: 0,
            duration: 0,
            restTime: 45,
            notes: 'Squeeze glutes at top',
          ),
          WorkoutExercise(
            id: '12',
            exerciseId: '5',
            exerciseName: 'Mountain Climbers',
            order: 4,
            sets: 3,
            reps: 1,
            weight: 0,
            duration: 30,
            restTime: 45,
            notes: '30 seconds',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now(),
      ),
      Workout(
        id: '4',
        name: 'Yoga Flow',
        description: 'Gentle yoga sequence for flexibility and relaxation.',
        category: 'Flexibility',
        difficulty: 'Beginner',
        estimatedDuration: 30,
        exercises: [
          WorkoutExercise(
            id: '13',
            exerciseId: '11',
            exerciseName: 'Downward Dog',
            order: 1,
            sets: 3,
            reps: 1,
            weight: 0,
            duration: 60,
            restTime: 30,
            notes: 'Hold for 1 minute',
          ),
          WorkoutExercise(
            id: '14',
            exerciseId: '12',
            exerciseName: 'Warrior III',
            order: 2,
            sets: 2,
            reps: 1,
            weight: 0,
            duration: 30,
            restTime: 30,
            notes: '30 seconds per side',
          ),
          WorkoutExercise(
            id: '15',
            exerciseId: '3',
            exerciseName: 'Plank',
            order: 3,
            sets: 2,
            reps: 1,
            weight: 0,
            duration: 45,
            restTime: 30,
            notes: 'Hold for 45 seconds',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
