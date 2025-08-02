# LHDN Mobile App

Mobile companion app for the LHDN system built with Flutter.

## Features

### 📱 Authentication
- User login and registration
- Secure token-based authentication
- Session management

### 💰 Expenses Management
- View expenses list with search and filters
- Detailed expense view with attachments
- Track expense categories and amounts

### 🛒 Direct Sales Management
- Sales records management
- Customer and product tracking
- Invoice generation support

### 📊 Dashboard
- Financial overview and statistics
- Quick action buttons
- Recent activity tracking

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Android SDK for Android builds
- Xcode for iOS builds (macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd lhdn_mobile_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint**
   Edit `lib/utils/constants.dart` to set your Laravel backend URL:
   ```dart
   static const String baseUrl = 'http://your-domain.com/api';
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── expense.dart
│   └── direct_sale.dart
├── screens/                  # UI screens
│   ├── auth/                # Authentication screens
│   ├── dashboard/           # Dashboard and home
│   ├── expenses/            # Expense management
│   └── sales/               # Sales management
├── services/                # Business logic
│   ├── api_service.dart     # HTTP client
│   ├── auth_service.dart    # Authentication
│   └── storage_service.dart # Local storage
├── utils/                   # Utilities
│   ├── app_router.dart      # Navigation
│   └── constants.dart       # App constants
└── widgets/                 # Reusable widgets
    ├── custom_button.dart
    ├── custom_text_field.dart
    └── loading_overlay.dart
```

## API Integration

The app communicates with the Laravel backend through RESTful APIs:

- **Authentication**: `/auth/login`, `/auth/register`, `/auth/logout`
- **Expenses**: `/expenses` (CRUD operations)
- **Sales**: `/direct-sales` (CRUD operations)
- **Dashboard**: `/dashboard/stats`

## State Management

- **Provider**: Used for authentication state and global app state
- **StatefulWidget**: Used for local component state
- **GoRouter**: For navigation and routing

## UI Components

### Custom Widgets
- `CustomButton`: Styled button with loading states
- `CustomTextField`: Consistent form input fields
- `LoadingOverlay`: Full-screen loading indicator

### Design System
- Material 3 design
- Consistent color scheme
- Responsive layouts
- Touch-friendly interface

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  go_router: ^14.0.2
  dio: ^5.4.0
  shared_preferences: ^2.2.2
```

## Development Notes

### Mock Data
Currently using mock data for demonstration. Real API integration points are marked with `// TODO:` comments.

### Features to Implement
- [ ] Real API integration
- [ ] File upload for expense receipts
- [ ] Offline data caching
- [ ] Push notifications
- [ ] Dark theme support
- [ ] Multi-language support

### Testing
```bash
# Run tests
flutter test

# Run integration tests
flutter test integration_test/
```

## Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Environment Configuration

Create different configurations for development and production:

1. **Development**: Use local Laravel server
2. **Production**: Use live server URL

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is part of the LHDN system. All rights reserved.

## Support

For technical support or questions, please contact the development team.
