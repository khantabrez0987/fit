class AppConstants {
  // App Info
  static const String appName = 'Fitness App';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyThemeMode = 'theme_mode';
  
  // Default Values
  static const double defaultHeight = 170.0; // cm
  static const double defaultWeight = 70.0; // kg
  static const String defaultFitnessLevel = 'beginner';
  
  // BMI Categories
  static const double bmiUnderweight = 18.5;
  static const double bmiNormal = 25.0;
  static const double bmiOverweight = 30.0;
  
  // Workout Constants
  static const int defaultRestTime = 60; // seconds
  static const int defaultSets = 3;
  static const int defaultReps = 10;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Network
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}

