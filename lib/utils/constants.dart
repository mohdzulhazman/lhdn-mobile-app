class Constants {
  // API Configuration
  static const String baseUrl = 'https://apps.urusfail.com/api';
  // Production URL for An Eagle System Mobile App
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String userEndpoint = '/user';
  static const String dashboardStatsEndpoint = '/dashboard/stats';
  static const String expensesEndpoint = '/expenses';
  static const String directSalesEndpoint = '/direct-sales';
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  
  // App Constants
  static const String appName = 'An Eagle System';
  static const String appVersion = '1.0.0';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  
  // Colors
  static const primaryColor = 0xFF667EEA;
  static const secondaryColor = 0xFF764BA2;
  static const successColor = 0xFF28A745;
  static const warningColor = 0xFFFFC107;
  static const errorColor = 0xFFDC3545;
  static const infoColor = 0xFF17A2B8;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Network Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Pagination
  static const int defaultPageSize = 15;
  static const int maxPageSize = 50;
  
  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedDocumentTypes = ['pdf'];
  
  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection';
  static const String serverErrorMessage = 'Server error. Please try again later';
  static const String unauthorizedMessage = 'Your session has expired. Please login again';
  static const String validationErrorMessage = 'Please check your input';
  
  // Success Messages
  static const String loginSuccessMessage = 'Login successful';
  static const String logoutSuccessMessage = 'Logout successful';
  static const String createSuccessMessage = 'Created successfully';
  static const String updateSuccessMessage = 'Updated successfully';
  static const String deleteSuccessMessage = 'Deleted successfully';
}
