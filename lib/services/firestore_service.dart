import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/nutrition.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // Nutrition Logs Collection
  CollectionReference get _nutritionLogsCollection =>
      _firestore.collection('nutrition_logs');

  // User Goals Collection
  CollectionReference get _userGoalsCollection =>
      _firestore.collection('user_goals');

  // Food Items Collection
  CollectionReference get _foodItemsCollection =>
      _firestore.collection('food_items');

  // Save nutrition log to Firestore
  Future<void> saveNutritionLog(NutritionLog log) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      await _nutritionLogsCollection.doc('${_currentUserId}_${log.id}').set({
        'userId': _currentUserId,
        'date': Timestamp.fromDate(log.date),
        'meals': log.meals.map((meal) => meal.toJson()).toList(),
        'totalCalories': log.totalCalories,
        'totalProtein': log.totalProtein,
        'totalCarbs': log.totalCarbs,
        'totalFat': log.totalFat,
        'waterIntake': log.waterIntake,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save nutrition log: $e');
    }
  }

  // Get nutrition logs for a specific date range
  Future<List<NutritionLog>> getNutritionLogs({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      Query query = _nutritionLogsCollection
          .where('userId', isEqualTo: _currentUserId);

      if (startDate != null) {
        query = query.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      }
      if (endDate != null) {
        query = query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      final querySnapshot = await query.orderBy('date', descending: true).get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return NutritionLog(
          id: doc.id.split('_').last,
          date: (data['date'] as Timestamp).toDate(),
          meals: (data['meals'] as List)
              .map((meal) => FoodEntry.fromJson(meal))
              .toList(),
          totalCalories: data['totalCalories'],
          totalProtein: data['totalProtein'].toDouble(),
          totalCarbs: data['totalCarbs'].toDouble(),
          totalFat: data['totalFat'].toDouble(),
          waterIntake: data['waterIntake'].toDouble(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get nutrition logs: $e');
    }
  }

  // Get today's nutrition log
  Future<NutritionLog?> getTodayNutritionLog() async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final querySnapshot = await _nutritionLogsCollection
          .where('userId', isEqualTo: _currentUserId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThan: Timestamp.fromDate(endOfDay))
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      return NutritionLog(
        id: doc.id.split('_').last,
        date: (data['date'] as Timestamp).toDate(),
        meals: (data['meals'] as List)
            .map((meal) => FoodEntry.fromJson(meal))
            .toList(),
        totalCalories: data['totalCalories'],
        totalProtein: data['totalProtein'].toDouble(),
        totalCarbs: data['totalCarbs'].toDouble(),
        totalFat: data['totalFat'].toDouble(),
        waterIntake: data['waterIntake'].toDouble(),
      );
    } catch (e) {
      throw Exception('Failed to get today\'s nutrition log: $e');
    }
  }

  // Save user nutrition goals
  Future<void> saveUserGoals(UserNutritionGoals goals) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      await _userGoalsCollection.doc(_currentUserId).set({
        'userId': _currentUserId,
        'dailyCalories': goals.dailyCalories,
        'dailyProtein': goals.dailyProtein,
        'dailyCarbs': goals.dailyCarbs,
        'dailyFat': goals.dailyFat,
        'dailyWater': goals.dailyWater,
        'goal': goals.goal,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save user goals: $e');
    }
  }

  // Get user nutrition goals
  Future<UserNutritionGoals?> getUserGoals() async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      final doc = await _userGoalsCollection.doc(_currentUserId).get();
      
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return UserNutritionGoals(
        dailyCalories: data['dailyCalories'],
        dailyProtein: data['dailyProtein'].toDouble(),
        dailyCarbs: data['dailyCarbs'].toDouble(),
        dailyFat: data['dailyFat'].toDouble(),
        dailyWater: data['dailyWater'].toDouble(),
        goal: data['goal'],
      );
    } catch (e) {
      throw Exception('Failed to get user goals: $e');
    }
  }

  // Save food items (for admin or user custom foods)
  Future<void> saveFoodItem(FoodItem foodItem) async {
    try {
      await _foodItemsCollection.doc(foodItem.id).set(foodItem.toJson());
    } catch (e) {
      throw Exception('Failed to save food item: $e');
    }
  }

  // Get food items
  Future<List<FoodItem>> getFoodItems() async {
    try {
      final querySnapshot = await _foodItemsCollection.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FoodItem.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get food items: $e');
    }
  }

  // Delete nutrition log
  Future<void> deleteNutritionLog(String logId) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      await _nutritionLogsCollection.doc('${_currentUserId}_$logId').delete();
    } catch (e) {
      throw Exception('Failed to delete nutrition log: $e');
    }
  }

  // Update nutrition log
  Future<void> updateNutritionLog(NutritionLog log) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      await _nutritionLogsCollection.doc('${_currentUserId}_${log.id}').update({
        'meals': log.meals.map((meal) => meal.toJson()).toList(),
        'totalCalories': log.totalCalories,
        'totalProtein': log.totalProtein,
        'totalCarbs': log.totalCarbs,
        'totalFat': log.totalFat,
        'waterIntake': log.waterIntake,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update nutrition log: $e');
    }
  }
}

