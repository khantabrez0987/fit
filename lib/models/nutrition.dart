class FoodItem {
  final String id;
  final String name;
  final String category;
  final int caloriesPerUnit;
  final double proteinPerUnit;
  final double carbsPerUnit;
  final double fatPerUnit;
  final String unit;
  final String description;
  final String? imageUrl;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.caloriesPerUnit,
    required this.proteinPerUnit,
    required this.carbsPerUnit,
    required this.fatPerUnit,
    required this.unit,
    required this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'caloriesPerUnit': caloriesPerUnit,
      'proteinPerUnit': proteinPerUnit,
      'carbsPerUnit': carbsPerUnit,
      'fatPerUnit': fatPerUnit,
      'unit': unit,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      caloriesPerUnit: json['caloriesPerUnit'],
      proteinPerUnit: json['proteinPerUnit'].toDouble(),
      carbsPerUnit: json['carbsPerUnit'].toDouble(),
      fatPerUnit: json['fatPerUnit'].toDouble(),
      unit: json['unit'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

class FoodEntry {
  final String id;
  final String foodId;
  final String foodName;
  final double quantity;
  final String unit;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String mealType;
  final DateTime loggedAt;

  FoodEntry({
    required this.id,
    required this.foodId,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.mealType,
    required this.loggedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodId': foodId,
      'foodName': foodName,
      'quantity': quantity,
      'unit': unit,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'mealType': mealType,
      'loggedAt': loggedAt.toIso8601String(),
    };
  }

  factory FoodEntry.fromJson(Map<String, dynamic> json) {
    return FoodEntry(
      id: json['id'],
      foodId: json['foodId'],
      foodName: json['foodName'],
      quantity: json['quantity'].toDouble(),
      unit: json['unit'],
      calories: json['calories'],
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
      mealType: json['mealType'],
      loggedAt: DateTime.parse(json['loggedAt']),
    );
  }
}

class Meal {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final List<FoodEntry> foods;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.foods,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'foods': foods.map((f) => f.toJson()).toList(),
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      foods: (json['foods'] as List)
          .map((f) => FoodEntry.fromJson(f))
          .toList(),
    );
  }
}

class NutritionLog {
  final String id;
  final DateTime date;
  final List<FoodEntry> meals;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double waterIntake; // in liters

  NutritionLog({
    required this.id,
    required this.date,
    required this.meals,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.waterIntake,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'meals': meals.map((m) => m.toJson()).toList(),
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
      'waterIntake': waterIntake,
    };
  }

  factory NutritionLog.fromJson(Map<String, dynamic> json) {
    return NutritionLog(
      id: json['id'],
      date: DateTime.parse(json['date']),
      meals: (json['meals'] as List)
          .map((m) => FoodEntry.fromJson(m))
          .toList(),
      totalCalories: json['totalCalories'],
      totalProtein: json['totalProtein'].toDouble(),
      totalCarbs: json['totalCarbs'].toDouble(),
      totalFat: json['totalFat'].toDouble(),
      waterIntake: json['waterIntake'].toDouble(),
    );
  }
}

class UserNutritionGoals {
  final int dailyCalories;
  final double dailyProtein; // in grams
  final double dailyCarbs; // in grams
  final double dailyFat; // in grams
  final double dailyWater; // in liters
  final String goal; // weight_loss, weight_gain, maintenance

  UserNutritionGoals({
    required this.dailyCalories,
    required this.dailyProtein,
    required this.dailyCarbs,
    required this.dailyFat,
    required this.dailyWater,
    required this.goal,
  });

  static UserNutritionGoals defaultGoals() {
    return UserNutritionGoals(
      dailyCalories: 2000,
      dailyProtein: 150,
      dailyCarbs: 250,
      dailyFat: 65,
      dailyWater: 2.5,
      goal: 'maintenance',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyCalories': dailyCalories,
      'dailyProtein': dailyProtein,
      'dailyCarbs': dailyCarbs,
      'dailyFat': dailyFat,
      'dailyWater': dailyWater,
      'goal': goal,
    };
  }

  factory UserNutritionGoals.fromJson(Map<String, dynamic> json) {
    return UserNutritionGoals(
      dailyCalories: json['dailyCalories'],
      dailyProtein: json['dailyProtein'].toDouble(),
      dailyCarbs: json['dailyCarbs'].toDouble(),
      dailyFat: json['dailyFat'].toDouble(),
      dailyWater: json['dailyWater'].toDouble(),
      goal: json['goal'],
    );
  }
}