import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../services/exercise_service.dart';

class WorkoutProvider extends ChangeNotifier {
  final ExerciseService _exerciseService = ExerciseService();
  
  List<Exercise> _exercises = [];
  List<Workout> _workouts = [];
  List<WorkoutSession> _workoutSessions = [];
  WorkoutSession? _currentSession;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Exercise> get exercises => _exercises;
  List<Workout> get workouts => _workouts;
  List<WorkoutSession> get workoutSessions => _workoutSessions;
  WorkoutSession? get currentSession => _currentSession;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize data
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await loadExercises();
      await loadWorkouts();
      await loadWorkoutSessions();
    } catch (e) {
      _setError('Failed to initialize workout data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load exercises
  Future<void> loadExercises() async {
    try {
      _exercises = await _exerciseService.getAllExercises();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load exercises: $e');
    }
  }

  // Load workouts
  Future<void> loadWorkouts() async {
    try {
      _workouts = await _exerciseService.getAllWorkouts();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load workouts: $e');
    }
  }

  // Load workout sessions
  Future<void> loadWorkoutSessions() async {
    try {
      _workoutSessions = await _exerciseService.getWorkoutSessions();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load workout sessions: $e');
    }
  }

  // Get exercises by category
  List<Exercise> getExercisesByCategory(String category) {
    return _exercises.where((exercise) => exercise.category.toLowerCase() == category.toLowerCase()).toList();
  }

  // Get exercises by difficulty
  List<Exercise> getExercisesByDifficulty(String difficulty) {
    return _exercises.where((exercise) => exercise.difficulty.toLowerCase() == difficulty.toLowerCase()).toList();
  }

  // Get exercises by muscle group
  List<Exercise> getExercisesByMuscleGroup(String muscleGroup) {
    return _exercises.where((exercise) => 
      exercise.muscleGroups.toLowerCase().contains(muscleGroup.toLowerCase())
    ).toList();
  }

  // Search exercises
  List<Exercise> searchExercises(String query) {
    if (query.isEmpty) return _exercises;
    return _exercises.where((exercise) => 
      exercise.name.toLowerCase().contains(query.toLowerCase()) ||
      exercise.description.toLowerCase().contains(query.toLowerCase()) ||
      exercise.muscleGroups.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Start workout session
  Future<void> startWorkoutSession(String workoutId) async {
    try {
      final workout = _workouts.firstWhere((w) => w.id == workoutId);
      _currentSession = WorkoutSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        workoutId: workoutId,
        workoutName: workout.name,
        startTime: DateTime.now(),
        duration: 0,
        caloriesBurned: 0,
        completedSets: [],
        notes: '',
        isCompleted: false,
      );
      notifyListeners();
    } catch (e) {
      _setError('Failed to start workout session: $e');
    }
  }

  // Complete exercise set
  Future<void> completeExerciseSet(ExerciseSet exerciseSet) async {
    if (_currentSession != null) {
      _currentSession!.completedSets.add(exerciseSet);
      notifyListeners();
    }
  }

  // End workout session
  Future<void> endWorkoutSession() async {
    if (_currentSession != null) {
      _currentSession = WorkoutSession(
        id: _currentSession!.id,
        workoutId: _currentSession!.workoutId,
        workoutName: _currentSession!.workoutName,
        startTime: _currentSession!.startTime,
        endTime: DateTime.now(),
        duration: DateTime.now().difference(_currentSession!.startTime).inMinutes,
        caloriesBurned: _calculateCaloriesBurned(),
        completedSets: _currentSession!.completedSets,
        notes: _currentSession!.notes,
        isCompleted: true,
      );
      
      _workoutSessions.add(_currentSession!);
      _currentSession = null;
      notifyListeners();
    }
  }

  // Calculate calories burned
  int _calculateCaloriesBurned() {
    if (_currentSession == null) return 0;
    
    int totalCalories = 0;
    for (final set in _currentSession!.completedSets) {
      final exercise = _exercises.firstWhere((e) => e.id == set.exerciseId);
      if (exercise.caloriesPerMinute != null) {
        totalCalories += (exercise.caloriesPerMinute! * (set.duration / 60)).round();
      }
    }
    return totalCalories;
  }

  // Get today's workout sessions
  List<WorkoutSession> getTodaySessions() {
    final today = DateTime.now();
    return _workoutSessions.where((session) => 
      session.startTime.year == today.year &&
      session.startTime.month == today.month &&
      session.startTime.day == today.day
    ).toList();
  }

  // Get this week's workout sessions
  List<WorkoutSession> getThisWeekSessions() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    return _workoutSessions.where((session) => 
      session.startTime.isAfter(weekStart) && session.startTime.isBefore(weekEnd)
    ).toList();
  }

  // Get workout statistics
  Map<String, dynamic> getWorkoutStats() {
    final thisWeekSessions = getThisWeekSessions();
    final totalDuration = thisWeekSessions.fold(0, (sum, session) => sum + session.duration);
    final totalCalories = thisWeekSessions.fold(0, (sum, session) => sum + session.caloriesBurned);
    
    return {
      'sessionsThisWeek': thisWeekSessions.length,
      'totalDuration': totalDuration,
      'totalCalories': totalCalories,
      'averageDuration': thisWeekSessions.isNotEmpty ? totalDuration / thisWeekSessions.length : 0,
    };
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
