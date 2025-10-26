import 'package:flutter/material.dart';
import '../models/nutrition.dart';

class NutritionProvider extends ChangeNotifier {
  List<FoodItem> _foodItems = [];
  List<Meal> _meals = [];
  List<NutritionLog> _nutritionLogs = [];
  UserNutritionGoals _goals = UserNutritionGoals.defaultGoals();
  bool _isLoading = false;
  String? _error;

  // Getters
  List<FoodItem> get foodItems => _foodItems;
  List<Meal> get meals => _meals;
  List<NutritionLog> get nutritionLogs => _nutritionLogs;
  UserNutritionGoals get goals => _goals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize data
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await loadFoodItems();
      await loadMeals();
      await loadNutritionLogs();
    } catch (e) {
      _setError('Failed to initialize nutrition data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load food items
  Future<void> loadFoodItems() async {
    try {
      // In a real app, this would load from a database or API
      _foodItems = _getDefaultFoodItems();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load food items: $e');
    }
  }

  // Load meals
  Future<void> loadMeals() async {
    try {
      _meals = _getDefaultMeals();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load meals: $e');
    }
  }

  // Load nutrition logs
  Future<void> loadNutritionLogs() async {
    try {
      _nutritionLogs = _getDefaultNutritionLogs();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load nutrition logs: $e');
    }
  }

  // Get today's nutrition log
  NutritionLog? getTodayLog() {
    final today = DateTime.now();
    try {
      return _nutritionLogs.firstWhere((log) => 
        log.date.year == today.year &&
        log.date.month == today.month &&
        log.date.day == today.day
      );
    } catch (e) {
      return null;
    }
  }

  // Add food to today's log
  Future<void> addFoodToLog(String foodId, double quantity, String mealType) async {
    try {
      final food = _foodItems.firstWhere((f) => f.id == foodId);
      final today = DateTime.now();
      
      // Find or create today's log
      NutritionLog? todayLog = getTodayLog();
      bool isNewLog = false;
      if (todayLog == null) {
        todayLog = NutritionLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: today,
          meals: [],
          totalCalories: 0,
          totalProtein: 0,
          totalCarbs: 0,
          totalFat: 0,
          waterIntake: 0,
        );
        _nutritionLogs.add(todayLog);
        isNewLog = true;
      }

      // Add food to the log
      final foodEntry = FoodEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        foodId: foodId,
        foodName: food.name,
        quantity: quantity,
        unit: food.unit,
        calories: (food.caloriesPerUnit * quantity).round(),
        protein: (food.proteinPerUnit * quantity).roundToDouble(),
        carbs: (food.carbsPerUnit * quantity).roundToDouble(),
        fat: (food.fatPerUnit * quantity).roundToDouble(),
        mealType: mealType,
        loggedAt: DateTime.now(),
      );

      // Create new meals list with the added food
      final updatedMeals = List<FoodEntry>.from(todayLog.meals)..add(foodEntry);
      
      // Calculate totals
      final totalCalories = updatedMeals.fold(0, (sum, meal) => sum + meal.calories);
      final totalProtein = updatedMeals.fold(0.0, (sum, meal) => sum + meal.protein);
      final totalCarbs = updatedMeals.fold(0.0, (sum, meal) => sum + meal.carbs);
      final totalFat = updatedMeals.fold(0.0, (sum, meal) => sum + meal.fat);

      // Create new NutritionLog with updated data
      final updatedLog = NutritionLog(
        id: todayLog.id,
        date: todayLog.date,
        meals: updatedMeals,
        totalCalories: totalCalories,
        totalProtein: totalProtein,
        totalCarbs: totalCarbs,
        totalFat: totalFat,
        waterIntake: todayLog.waterIntake,
      );

      // Replace the old log with the new one (only if it's not a new log)
      if (!isNewLog) {
        final logIndex = _nutritionLogs.indexWhere((log) => log.id == todayLog!.id);
        if (logIndex != -1) {
          _nutritionLogs[logIndex] = updatedLog;
        }
      } else {
        // For new logs, just add the updated log
        _nutritionLogs[_nutritionLogs.length - 1] = updatedLog;
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to add food to log: $e');
    }
  }

  // Update nutrition goals
  void updateGoals(UserNutritionGoals newGoals) {
    _goals = newGoals;
    notifyListeners();
  }

  // Get nutrition progress
  Map<String, dynamic> getNutritionProgress() {
    final todayLog = getTodayLog();
    if (todayLog == null) {
      return {
        'calories': {'consumed': 0, 'goal': _goals.dailyCalories, 'percentage': 0.0},
        'protein': {'consumed': 0, 'goal': _goals.dailyProtein, 'percentage': 0.0},
        'carbs': {'consumed': 0, 'goal': _goals.dailyCarbs, 'percentage': 0.0},
        'fat': {'consumed': 0, 'goal': _goals.dailyFat, 'percentage': 0.0},
        'water': {'consumed': 0, 'goal': _goals.dailyWater, 'percentage': 0.0},
      };
    }

    return {
      'calories': {
        'consumed': todayLog.totalCalories,
        'goal': _goals.dailyCalories,
        'percentage': (todayLog.totalCalories / _goals.dailyCalories * 100).clamp(0, 100),
      },
      'protein': {
        'consumed': todayLog.totalProtein,
        'goal': _goals.dailyProtein,
        'percentage': (todayLog.totalProtein / _goals.dailyProtein * 100).clamp(0, 100),
      },
      'carbs': {
        'consumed': todayLog.totalCarbs,
        'goal': _goals.dailyCarbs,
        'percentage': (todayLog.totalCarbs / _goals.dailyCarbs * 100).clamp(0, 100),
      },
      'fat': {
        'consumed': todayLog.totalFat,
        'goal': _goals.dailyFat,
        'percentage': (todayLog.totalFat / _goals.dailyFat * 100).clamp(0, 100),
      },
      'water': {
        'consumed': todayLog.waterIntake,
        'goal': _goals.dailyWater,
        'percentage': (todayLog.waterIntake / _goals.dailyWater * 100).clamp(0, 100),
      },
    };
  }

  // Search food items
  List<FoodItem> searchFoodItems(String query) {
    if (query.isEmpty) return _foodItems;
    return _foodItems.where((food) => 
      food.name.toLowerCase().contains(query.toLowerCase()) ||
      food.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Get food items by category
  List<FoodItem> getFoodItemsByCategory(String category) {
    return _foodItems.where((food) => food.category.toLowerCase() == category.toLowerCase()).toList();
  }

  // Helper methods
  void _updateTotals(NutritionLog log) {
    // NutritionLog is immutable, so we need to create a new instance
    // This is handled in the addFoodToLog method by creating a new log
  }

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

  // Default data methods
  List<FoodItem> _getDefaultFoodItems() {
    return [
      FoodItem(
        id: '1',
        name: 'Chicken Breast',
        category: 'Protein',
        caloriesPerUnit: 165,
        proteinPerUnit: 31,
        carbsPerUnit: 0,
        fatPerUnit: 3.6,
        unit: '100g',
        description: 'Lean protein source',
      ),
      FoodItem(
        id: '2',
        name: 'Brown Rice',
        category: 'Carbs',
        caloriesPerUnit: 111,
        proteinPerUnit: 2.6,
        carbsPerUnit: 23,
        fatPerUnit: 0.9,
        unit: '100g',
        description: 'Whole grain carbohydrate',
      ),
      FoodItem(
        id: '3',
        name: 'Avocado',
        category: 'Healthy Fats',
        caloriesPerUnit: 160,
        proteinPerUnit: 2,
        carbsPerUnit: 9,
        fatPerUnit: 15,
        unit: '100g',
        description: 'Healthy monounsaturated fats',
      ),
      FoodItem(
        id: '4',
        name: 'Banana',
        category: 'Fruits',
        caloriesPerUnit: 89,
        proteinPerUnit: 1.1,
        carbsPerUnit: 23,
        fatPerUnit: 0.3,
        unit: '100g',
        description: 'Natural energy source',
      ),
      FoodItem(
        id: '5',
        name: 'Greek Yogurt',
        category: 'Dairy',
        caloriesPerUnit: 59,
        proteinPerUnit: 10,
        carbsPerUnit: 3.6,
        fatPerUnit: 0.4,
        unit: '100g',
        description: 'High protein dairy product',
      ),
    ];
  }

  List<Meal> _getDefaultMeals() {
    return [
      Meal(
        id: '1',
        name: 'Breakfast',
        description: 'Start your day right',
        imageUrl: null,
        foods: [],
      ),
      Meal(
        id: '2',
        name: 'Lunch',
        description: 'Midday fuel',
        imageUrl: null,
        foods: [],
      ),
      Meal(
        id: '3',
        name: 'Dinner',
        description: 'Evening meal',
        imageUrl: null,
        foods: [],
      ),
      Meal(
        id: '4',
        name: 'Snacks',
        description: 'Healthy snacks',
        imageUrl: null,
        foods: [],
      ),
    ];
  }

  List<NutritionLog> _getDefaultNutritionLogs() {
    return [];
  }
}
