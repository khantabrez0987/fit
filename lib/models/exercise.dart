class Exercise {
  final String id;
  final String name;
  final String description;
  final String category; // strength, cardio, flexibility, etc.
  final String muscleGroups; // primary muscle groups worked
  final String equipment; // required equipment
  final String difficulty; // beginner, intermediate, advanced
  final String? imageUrl;
  final String? videoUrl;
  final List<String> instructions;
  final List<String> tips;
  final int? caloriesPerMinute; // estimated calories burned per minute

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.muscleGroups,
    required this.equipment,
    required this.difficulty,
    this.imageUrl,
    this.videoUrl,
    required this.instructions,
    required this.tips,
    this.caloriesPerMinute,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'muscleGroups': muscleGroups,
      'equipment': equipment,
      'difficulty': difficulty,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'instructions': instructions,
      'tips': tips,
      'caloriesPerMinute': caloriesPerMinute,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      muscleGroups: json['muscleGroups'],
      equipment: json['equipment'],
      difficulty: json['difficulty'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      instructions: List<String>.from(json['instructions']),
      tips: List<String>.from(json['tips']),
      caloriesPerMinute: json['caloriesPerMinute'],
    );
  }
}

class ExerciseSet {
  final String id;
  final String exerciseId;
  final int reps;
  final double weight; // in kg
  final int duration; // in seconds (for time-based exercises)
  final int restTime; // in seconds
  final String notes;
  final DateTime completedAt;

  ExerciseSet({
    required this.id,
    required this.exerciseId,
    required this.reps,
    required this.weight,
    required this.duration,
    required this.restTime,
    required this.notes,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'reps': reps,
      'weight': weight,
      'duration': duration,
      'restTime': restTime,
      'notes': notes,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      id: json['id'],
      exerciseId: json['exerciseId'],
      reps: json['reps'],
      weight: json['weight'].toDouble(),
      duration: json['duration'],
      restTime: json['restTime'],
      notes: json['notes'],
      completedAt: DateTime.parse(json['completedAt']),
    );
  }
}
