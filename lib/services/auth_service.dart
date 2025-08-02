import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class AuthService extends ChangeNotifier {
  final ApiService _apiService;
  
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  
  AuthService({required ApiService apiService}) : _apiService = apiService {
    _initializeAuth();
  }
  
  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  
  // Initialize Auth State
  Future<void> _initializeAuth() async {
    _isLoggedIn = StorageService.isLoggedIn();
    _currentUser = StorageService.getUserData();
    notifyListeners();
  }
  
  // Login
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      
      final response = await _apiService.post(
        Constants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );
      
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
      
      if (apiResponse.success && apiResponse.data != null) {
        final data = apiResponse.data!;
        final token = data['token'] as String;
        final userData = data['user'] as Map<String, dynamic>;
        
        // Save auth data
        await StorageService.saveAuthToken(token);
        
        // Create and save user
        _currentUser = UserModel.fromJson(userData);
        await StorageService.saveUserData(_currentUser!);
        
        _isLoggedIn = true;
        await StorageService.setLoggedIn(true);
        
        notifyListeners();
      }
      
      return apiResponse;
    } on ApiException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: e.message,
        errors: e.errors,
      );
    } finally {
      _setLoading(false);
    }
  }
  
  // Register
  Future<ApiResponse<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      _setLoading(true);
      
      final response = await _apiService.post(
        Constants.registerEndpoint,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
      
      if (apiResponse.success && apiResponse.data != null) {
        final data = apiResponse.data!;
        final token = data['token'] as String;
        final userData = data['user'] as Map<String, dynamic>;
        
        // Save auth data
        await StorageService.saveAuthToken(token);
        
        // Create and save user
        _currentUser = UserModel.fromJson(userData);
        await StorageService.saveUserData(_currentUser!);
        
        _isLoggedIn = true;
        await StorageService.setLoggedIn(true);
        
        notifyListeners();
      }
      
      return apiResponse;
    } on ApiException catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: e.message,
        errors: e.errors,
      );
    } finally {
      _setLoading(false);
    }
  }
  
  // Logout
  Future<ApiResponse<void>> logout() async {
    try {
      _setLoading(true);
      
      // Call API logout endpoint
      try {
        await _apiService.post(Constants.logoutEndpoint);
      } catch (e) {
        // Continue with local logout even if API call fails
        if (kDebugMode) {
          print('API logout failed: $e');
        }
      }
      
      // Clear local auth data
      await StorageService.clearAuth();
      
      _currentUser = null;
      _isLoggedIn = false;
      
      notifyListeners();
      
      return ApiResponse<void>(
        success: true,
        message: Constants.logoutSuccessMessage,
      );
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Logout failed: ${e.toString()}',
      );
    } finally {
      _setLoading(false);
    }
  }
  
  // Refresh User Data
  Future<ApiResponse<UserModel>> refreshUser() async {
    try {
      _setLoading(true);
      
      final response = await _apiService.get(Constants.userEndpoint);
      
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
      
      if (apiResponse.success && apiResponse.data != null) {
        _currentUser = UserModel.fromJson(apiResponse.data!);
        await StorageService.saveUserData(_currentUser!);
        notifyListeners();
        
        return ApiResponse<UserModel>(
          success: true,
          message: 'User data refreshed',
          data: _currentUser,
        );
      }
      
      return ApiResponse<UserModel>(
        success: false,
        message: apiResponse.message,
      );
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        await logout();
      }
      
      return ApiResponse<UserModel>(
        success: false,
        message: e.message,
      );
    } finally {
      _setLoading(false);
    }
  }
  
  // Check Authentication Status
  Future<bool> checkAuthStatus() async {
    final token = StorageService.getAuthToken();
    if (token == null) {
      await logout();
      return false;
    }
    
    try {
      final refreshResult = await refreshUser();
      return refreshResult.success;
    } catch (e) {
      await logout();
      return false;
    }
  }
  
  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  // Force logout (for unauthorized responses)
  Future<void> forceLogout() async {
    await StorageService.clearAuth();
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
