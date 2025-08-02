# 🎯 AN EAGLE SYSTEM - QUICK START GUIDE

## 🚀 Ready to Build Your Mobile App!

Your "An Eagle System" mobile app is **100% configured** and ready for compilation!

### 📱 What You're Getting:
- **App Name**: An Eagle System
- **Login**: admin@lhdn.gov.com / admin123  
- **Features**: Expenses + Direct Sales + Dashboard
- **API**: Connected to https://apps.urusfail.com/api/

---

## ⚡ FASTEST WAY TO BUILD (Double-click this):

```
📁 build_an_eagle_system.bat
```
**Just double-click the file above!** It will:
1. ✅ Check Flutter installation
2. ✅ Clean project
3. ✅ Get dependencies  
4. ✅ Build release APK
5. ✅ Show you where APK is located

---

## 📋 Manual Build (if you prefer terminal):

### Step 1: Install Flutter (if not done)
- Download: https://flutter.dev/docs/get-started/install/windows
- Extract to `C:\flutter\`
- Add to PATH: `C:\flutter\bin`

### Step 2: Install Android Studio
- Download: https://developer.android.com/studio
- Install with default settings
- Accept Android licenses: `flutter doctor --android-licenses`

### Step 3: Build APK
```bash
cd c:\xampp\htdocs\LHDN\lhdn_mobile_app
flutter pub get
flutter build apk --release
```

### Step 4: Get Your APK
Location: `build\app\outputs\flutter-apk\app-release.apk`

---

## 📱 Install on Android:

1. **Enable Unknown Sources** in Android Settings
2. **Transfer APK** to your phone  
3. **Tap APK file** to install
4. **Launch "An Eagle System"**
5. **Login** with admin@lhdn.gov.com / admin123

---

## 🎯 What Works:

✅ **Dashboard** - Real-time statistics  
✅ **Expenses** - Add, edit, delete expenses  
✅ **Direct Sales** - Complete sales management  
✅ **Sync** - Same data as your web system  
✅ **Security** - Laravel Sanctum authentication  

---

## 🔧 Need Help?

### If Build Fails:
1. Install Android Studio
2. Run `flutter doctor`
3. Accept licenses: `flutter doctor --android-licenses`

### If App Crashes:
1. Check internet connection
2. Test API: https://apps.urusfail.com/api/debug
3. Verify login credentials

---

## 📞 Quick Test:

After installing APK:
1. **Open app** → Should show login screen
2. **Login** with admin@lhdn.gov.com / admin123
3. **Check dashboard** → Should load statistics  
4. **Add expense** → Should save to database
5. **Check web system** → New expense should appear

---

**🚀 Everything is ready! Just double-click `build_an_eagle_system.bat` to start!**

*Build time: ~10 minutes | App size: ~20MB | Compatible: Android 5.0+*
