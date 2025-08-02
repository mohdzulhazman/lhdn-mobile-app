# APK Build Instructions

This guide will help you build an Android APK file for the LHDN Mobile App.

## Prerequisites

1. **Flutter SDK** - Install Flutter from https://flutter.dev/docs/get-started/install
2. **Android Studio** - Download from https://developer.android.com/studio
3. **Android SDK** - Installed through Android Studio
4. **Java JDK** - Version 8 or higher

## Setup Steps

### 1. Install Flutter

#### Windows:
```powershell
# Download Flutter SDK and extract to C:\flutter
# Add C:\flutter\bin to your PATH environment variable

# Verify installation
flutter doctor
```

#### Alternative: If Flutter SDK is not available
You can still prepare the project structure and use online build services like Codemagic or GitHub Actions.

### 2. Configure Android Development

```bash
# Accept Android licenses
flutter doctor --android-licenses

# Verify Android setup
flutter doctor
```

### 3. Project Configuration

1. **Update API URL**
   
   Edit `lib/utils/constants.dart`:
   ```dart
   // For local development
   static const String baseUrl = 'http://10.0.2.2/api'; // Android emulator
   
   // For production
   static const String baseUrl = 'https://your-domain.com/api';
   ```

2. **Configure App Details**
   
   Edit `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <application
       android:label="LHDN Mobile"
       android:name="${applicationName}"
       android:icon="@mipmap/ic_launcher">
   ```

   Edit `android/app/build.gradle`:
   ```gradle
   android {
       compileSdkVersion 34
       
       defaultConfig {
           applicationId "com.lhdn.mobile"
           minSdkVersion 21
           targetSdkVersion 34
           versionCode 1
           versionName "1.0.0"
       }
   }
   ```

### 4. Build APK

#### Debug APK (for testing)
```bash
cd lhdn_mobile_app
flutter build apk --debug
```

#### Release APK (for production)
```bash
cd lhdn_mobile_app
flutter build apk --release
```

The APK will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

### 5. Alternative Build Methods

#### Using Android Studio
1. Open the project in Android Studio
2. Select "Build" > "Build Bundle(s) / APK(s)" > "Build APK(s)"
3. Wait for build to complete

#### Using Online Build Services

**Option 1: Codemagic**
1. Push code to GitHub repository
2. Connect repository to Codemagic
3. Configure build settings for Android
4. Download built APK

**Option 2: GitHub Actions**
Create `.github/workflows/build.yml`:
```yaml
name: Build APK
on: push
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    - run: flutter pub get
    - run: flutter build apk --release
    - uses: actions/upload-artifact@v2
      with:
        name: release-apk
        path: build/app/outputs/flutter-apk/app-release.apk
```

## Production Deployment

### 1. Code Signing (for Play Store)

Generate keystore:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=upload-keystore.jks
```

Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 2. Build Signed APK

```bash
flutter build apk --release
```

### 3. Build App Bundle (Recommended for Play Store)

```bash
flutter build appbundle --release
```

## Testing the APK

### Install on Device
```bash
# Enable Developer Options and USB Debugging on your Android device
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Test with Emulator
```bash
# Start Android emulator
flutter emulators --launch <emulator_id>

# Install and run
flutter install
```

## Troubleshooting

### Common Issues

**1. Flutter not found**
```bash
# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"  # Linux/Mac
# Or add C:\flutter\bin to PATH on Windows
```

**2. Android licenses not accepted**
```bash
flutter doctor --android-licenses
```

**3. Gradle build fails**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

**4. API connection issues**
- Update `baseUrl` in constants.dart
- For local testing, use your computer's IP address
- Ensure Laravel API is accessible from mobile device

### Build Optimization

**Reduce APK size:**
```bash
flutter build apk --release --split-per-abi
```

**Enable R8/ProGuard:**
```gradle
// android/app/build.gradle
buildTypes {
    release {
        minifyEnabled true
        useProguard true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        signingConfig signingConfigs.release
    }
}
```

## Final Notes

1. **Test thoroughly** on different devices and Android versions
2. **Update API endpoints** for production environment
3. **Implement proper error handling** for network requests
4. **Add proper app icons** in different resolutions
5. **Configure permissions** in AndroidManifest.xml as needed

The generated APK can be distributed directly or uploaded to Google Play Store for wider distribution.
