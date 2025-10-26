import 'exercise.dart';

class Workout {
  final String id;
  final String name;
  final String description;
  final String category; // strength, cardio, yoga, etc.
  final String difficulty; // beginner, intermediate, advanced
  final int estimatedDuration; // in minutes
  final List<WorkoutExercise> exercises;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.estimatedDuration,
    required this.exercises,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'estimatedDuration': estimatedDuration,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      difficulty: json['difficulty'],
      estimatedDuration: json['estimatedDuration'],
      exercises: (json['exercises'] as List)
          .map((e) => WorkoutExercise.fromJson(e))
          .toList(),
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class WorkoutExercise {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final int order;
  final int sets;
  final int reps;
  final double weight; // in kg
  final int duration; // in seconds
  final int restTime; // in seconds between sets
  final String notes;

  WorkoutExercise({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.order,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.duration,
    required this.restTime,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'order': order,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'duration': duration,
      'restTime': restTime,
      'notes': notes,
    };
  }

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'],
      exerciseId: json['exerciseId'],
      exerciseName: json['exerciseName'],
      order: json['order'],
      sets: json['sets'],
      reps: json['reps'],
      weight: json['weight'].toDouble(),
      duration: json['duration'],
      restTime: json['restTime'],
      notes: json['notes'],
    );
  }
}

class WorkoutSession {
  final String id;
  final String workoutId;
  final String workoutName;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration; // in minutes
  final int caloriesBurned;
  final List<ExerciseSet> completedSets;
  final String notes;
  final bool isCompleted;

  WorkoutSession({
    required this.id,
    required this.workoutId,
    required this.workoutName,
    required this.startTime,
    this.endTime,
    required this.duration,
    required this.caloriesBurned,
    required this.completedSets,
    required this.notes,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutId': workoutId,
      'workoutName': workoutName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'completedSets': completedSets.map((s) => s.toJson()).toList(),
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'],
      workoutId: json['workoutId'],
      workoutName: json['workoutName'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      duration: json['duration'],
      caloriesBurned: json['caloriesBurned'],
      completedSets: (json['completedSets'] as List)
          .map((s) => ExerciseSet.fromJson(s))
          .toList(),
      notes: json['notes'],
      isCompleted: json['isCompleted'],
    );
  }
}
