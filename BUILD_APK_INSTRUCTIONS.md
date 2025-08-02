# LHDN Mobile App - APK Build Instructions

## STATUS: API READY ✅
- Backend API is functional at: `https://apps.urusfail.com/api/`
- Test endpoints working: `/api/debug`, `/api/test`, `/api/auth-test`
- Authentication tested and working: `/api/auth-manual-test`
- Flutter project is complete and ready for compilation

## Flutter Installation & Setup (CARA MUDAH dengan VS Code)

### Step 1: Install Flutter melalui VS Code ⚡ MUDAH!
1. Buka **VS Code**
2. Tekan `Ctrl + Shift + P`
3. Type: **"Flutter: New Project"**
4. VS Code akan auto download dan install Flutter untuk anda!
5. Follow arahan yang keluar di VS Code

### Step 2: Install Android Studio
1. Download dari: https://developer.android.com/studio
2. Install dengan default settings
3. Buka Android Studio → More Actions → SDK Manager
4. Install Android SDK (API 21 atau lebih tinggi)

### Step 3: Accept Android Licenses
```bash
flutter doctor --android-licenses
```
Type 'y' untuk semua license

### Step 4: Verify Installation
```bash
flutter doctor
```
All checkmarks should be green ✅

## Building the APK (DALAM VS CODE)

### Step 1: Buka Project dalam VS Code
```bash
# Buka VS Code di folder project
code c:\xampp\htdocs\LHDN\lhdn_mobile_app
```

### Step 2: Install Flutter Extension (jika belum ada)
1. Dalam VS Code tekan `Ctrl + Shift + X` 
2. Search "Flutter" dan install extension
3. Restart VS Code

### Step 3: Get Dependencies
```bash
flutter pub get
```

### Step 4: Build APK dalam VS Code
1. Tekan `Ctrl + Shift + P`
2. Type: **"Flutter: Build APK"**
3. Pilih "Release" untuk production
4. ATAU guna terminal:
```bash
flutter build apk --release
```

## APK Location
After successful build, the APK will be located at:
- **Debug**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Release**: `build/app/outputs/flutter-apk/app-release.apk`

## Installation on Android Device
1. Enable "Unknown Sources" in Android Settings → Security
2. Transfer APK to your Android device
3. Tap the APK file to install
4. Launch "LHDN System" app

## API Configuration ✅
The app is pre-configured to connect to:
```
Base URL: https://apps.urusfail.com/api/
```

## App Features
- ✅ Expenses Management (CRUD)
- ✅ Direct Sales Management (CRUD)  
- ✅ Dashboard with statistics
- ✅ Authentication (Login/Logout)
- ✅ Material 3 Design
- ✅ Responsive layout

## Troubleshooting

### If "flutter" command not found:
- Restart command prompt after adding Flutter to PATH
- Verify PATH includes `C:\flutter\bin`

### If Android build fails:
- Run `flutter doctor` and fix any issues
- Ensure Android SDK is properly installed
- Accept Android licenses with `flutter doctor --android-licenses`

### If app crashes on startup:
- Check internet connection
- Verify API endpoint is accessible: https://apps.urusfail.com/api/debug

## Next Steps After APK Build
1. Install APK on Android device
2. Test login with existing LHDN system credentials
3. Verify expenses and direct sales functionality
4. The mobile app shares the same database as the web system

## Important Notes
- The mobile app uses the SAME database as your web system
- No changes were made to your existing web application
- All data is synchronized between web and mobile
- API endpoints are secured with Laravel Sanctum authentication

---
**Status**: Ready for APK compilation! 🚀
