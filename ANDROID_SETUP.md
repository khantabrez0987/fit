# Android SDK Setup Guide

## Quick Setup (Recommended)

### Option 1: Install Android Studio (Easiest)
1. Download Android Studio: https://developer.android.com/studio
2. Install and launch Android Studio
3. Complete the setup wizard (installs SDK automatically)
4. Run these commands:
   ```bash
   flutter doctor --android-licenses
   flutter doctor
   ```
5. Build APK:
   ```bash
   flutter build apk
   ```

### Option 2: Manual Java + SDK Setup

#### Step 1: Install Java JDK
1. Download: https://adoptium.net/temurin/releases/?version=21&os=mac&arch=aarch64&package=jdk
   - Choose "macOS" → "aarch64" → "JDK"
2. Open the downloaded .dmg file
3. Double-click the .pkg installer
4. Follow the installation wizard

#### Step 2: Verify Java Installation
```bash
java -version
```
Should show Java version 17 or 21

#### Step 3: Install SDK Components
```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Accept licenses
yes | sdkmanager --licenses

# Install required SDK components
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

#### Step 4: Build APK
```bash
flutter build apk
```

## Current Status

✅ Android SDK command-line tools downloaded  
✅ ANDROID_HOME configured in ~/.zshrc  
❌ Java JDK needs to be installed  
❌ SDK components need to be installed  

## After Installation

Once Java is installed, run:
```bash
source ~/.zshrc
flutter doctor
flutter build apk
```

The APK will be created at: `build/app/outputs/flutter-apk/app-release.apk`

