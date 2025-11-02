#!/bin/bash

# Build APK Script for Fitness App
# Make sure Android SDK is installed before running

echo "🏋️ Building Fitness App APK..."
echo ""

# Check if Android SDK is available
if [ -z "$ANDROID_HOME" ]; then
    echo "❌ ANDROID_HOME is not set!"
    echo "Please install Android Studio or set ANDROID_HOME manually"
    exit 1
fi

if [ ! -d "$ANDROID_HOME" ]; then
    echo "❌ Android SDK not found at $ANDROID_HOME"
    echo "Please install Android Studio or set ANDROID_HOME to the correct path"
    exit 1
fi

echo "✓ Android SDK found at: $ANDROID_HOME"
echo ""

# Run Flutter doctor
echo "Checking Flutter setup..."
flutter doctor

echo ""
echo "Building APK..."
flutter build apk

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ APK built successfully!"
    echo "📱 APK location: build/app/outputs/flutter-apk/app-release.apk"
else
    echo ""
    echo "❌ APK build failed. Check the error messages above."
    exit 1
fi

