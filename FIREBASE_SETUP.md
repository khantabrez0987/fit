# 🔥 Firebase Setup Guide for Fitness App

This guide will help you set up Firebase for your Flutter fitness app to enable user authentication and cloud data storage.

## 📋 Prerequisites

- Flutter SDK installed
- Android Studio / VS Code
- Google account
- Firebase CLI (optional but recommended)

## 🚀 Step-by-Step Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `fitness-app` (or your preferred name)
4. Enable/disable Google Analytics (optional)
5. Click "Create project"

### 2. Add Flutter App to Firebase

1. In your Firebase project, click "Add app" and select Flutter
2. Enter your app details:
   - **App nickname**: `Fitness App`
   - **Android package name**: `com.example.fitness_app` (check your `android/app/build.gradle`)
   - **iOS bundle ID**: `com.example.fitnessApp` (check your `ios/Runner/Info.plist`)
3. Click "Register app"

### 3. Download Configuration Files

#### For Android:
1. Download `google-services.json`
2. Place it in `android/app/google-services.json`
3. Add to `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

#### For iOS:
1. Download `GoogleService-Info.plist`
2. Place it in `ios/Runner/GoogleService-Info.plist`
3. Add to `ios/Runner/Runner.xcodeproj` in Xcode

### 4. Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get started**
3. Go to **Sign-in method** tab
4. Enable **Email/Password** authentication
5. Optionally enable **Google** sign-in

### 5. Enable Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select a location for your database
5. Click **Done**

### 6. Set Up Security Rules (Important!)

In Firestore Database > Rules, replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Nutrition logs are user-specific
    match /nutrition_logs/{logId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // User goals are user-specific
    match /user_goals/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Food items are readable by all authenticated users
    match /food_items/{foodId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null; // Only authenticated users can add foods
    }
  }
}
```

### 7. Update Firebase Configuration

Replace the placeholder values in `lib/config/firebase_config.dart` with your actual Firebase configuration:

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Scroll down to **Your apps** section
3. Copy the configuration values
4. Update `firebase_config.dart` with your actual values

### 8. Test the Setup

Run your Flutter app:

```bash
flutter run
```

Try creating an account and logging in to verify everything works!

## 🔧 Troubleshooting

### Common Issues:

1. **"No Firebase App '[DEFAULT]' has been created"**
   - Make sure `Firebase.initializeApp()` is called in `main()`
   - Check that configuration files are in the correct locations

2. **"Permission denied" errors**
   - Check your Firestore security rules
   - Ensure user is authenticated before accessing data

3. **Build errors on Android**
   - Make sure `google-services.json` is in `android/app/`
   - Check that the Google Services plugin is applied

4. **Build errors on iOS**
   - Make sure `GoogleService-Info.plist` is added to Xcode project
   - Check bundle ID matches Firebase configuration

## 📱 Features Enabled

With Firebase setup, your fitness app now has:

- ✅ **User Authentication**: Sign up, sign in, password reset
- ✅ **Cloud Data Storage**: Nutrition logs saved to Firestore
- ✅ **User Profiles**: Personal information and goals
- ✅ **Data Persistence**: Data survives app reinstalls
- ✅ **Cross-device Sync**: Access data from multiple devices
- ✅ **Security**: User-specific data access rules

## 🚀 Next Steps

1. **Test Authentication**: Create accounts and sign in
2. **Test Data Storage**: Add nutrition logs and verify they save
3. **Customize UI**: Modify login/signup screens to match your design
4. **Add Features**: Implement password reset, profile pictures, etc.
5. **Deploy**: Set up production Firebase project for release

## 📚 Additional Resources

- [Firebase Flutter Documentation](https://firebase.flutter.dev/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Authentication](https://firebase.google.com/docs/auth/flutter/start)

---

**Note**: This setup is for development. For production, make sure to:
- Use production Firebase project
- Set up proper security rules
- Enable additional authentication methods
- Configure proper data validation




