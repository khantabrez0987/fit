# Java Version Compatibility Issue

## Problem
Your system has Java 25.0.1 installed, but the Kotlin compiler in Gradle doesn't recognize Java version "25.0.1" yet, causing build failures.

## Solution

You need to install Java 21 (LTS) or Java 17. Here are your options:

### Option 1: Install Java 21 via Download (Recommended)
1. Download Java 21 from: https://adoptium.net/temurin/releases/?version=21&os=mac&arch=aarch64&package=jdk
2. Open the `.dmg` file
3. Install the `.pkg` file
4. After installation, set Flutter to use Java 21:
   ```bash
   flutter config --jdk-dir="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home"
   flutter build apk
   ```

### Option 2: Use Homebrew (if installed)
```bash
brew install --cask temurin@21
flutter config --jdk-dir="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home"
flutter build apk
```

### Option 3: Keep Java 25 and Work Around
The build files have been updated to use Java 17 compatibility mode, but you'll still need to either:
- Downgrade to Java 21/17, OR
- Wait for Kotlin/Gradle updates to support Java 25

## Quick Fix Command
After installing Java 21:
```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
flutter config --jdk-dir="$JAVA_HOME"
flutter build apk
```

