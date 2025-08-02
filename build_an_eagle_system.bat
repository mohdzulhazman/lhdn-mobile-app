@echo off
echo ==========================================
echo   AN EAGLE SYSTEM - Mobile App Builder
echo ==========================================
echo.

echo [1/5] Checking Flutter installation...
flutter --version
if %ERRORLEVEL% neq 0 (
    echo ERROR: Flutter not found! Please install Flutter first.
    echo Visit: https://flutter.dev/docs/get-started/install/windows
    pause
    exit /b 1
)

echo.
echo [2/5] Cleaning previous builds...
flutter clean

echo.
echo [3/5] Getting dependencies...
flutter pub get

echo.
echo [4/5] Running Flutter doctor...
flutter doctor

echo.
echo [5/5] Building Release APK...
echo This may take 5-10 minutes...
flutter build apk --release

echo.
if %ERRORLEVEL% equ 0 (
    echo ==========================================
    echo           BUILD SUCCESS! 
    echo ==========================================
    echo.
    echo APK Location:
    echo %CD%\build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo App Name: An Eagle System
    echo Login: admin@lhdn.gov.com / admin123
    echo API: https://apps.urusfail.com/api/
    echo.
    echo Next Steps:
    echo 1. Transfer APK to Android device
    echo 2. Enable Unknown Sources
    echo 3. Install APK
    echo 4. Test login with provided credentials
    echo.
    echo Build completed successfully!
) else (
    echo ==========================================
    echo           BUILD FAILED!
    echo ==========================================
    echo.
    echo Please check the error messages above.
    echo Common solutions:
    echo - Install Android Studio
    echo - Run: flutter doctor --android-licenses
    echo - Check internet connection
)

echo.
pause
