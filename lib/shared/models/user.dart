class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final DateTime dateOfBirth;
  final String gender;
  final double height; // in cm
  final double weight; // in kg
  final String fitnessLevel; // beginner, intermediate, advanced
  final List<String> goals;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.height,
    required this.weight,
    required this.fitnessLevel,
    required this.goals,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'height': height,
      'weight': weight,
      'fitnessLevel': fitnessLevel,
      'goals': goals,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
      fitnessLevel: json['fitnessLevel'],
      goals: List<String>.from(json['goals']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? gender,
    double? height,
    double? weight,
    String? fitnessLevel,
    List<String>? goals,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      goals: goals ?? this.goals,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get bmi {
    return weight / ((height / 100) * (height / 100));
  }

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }
}

