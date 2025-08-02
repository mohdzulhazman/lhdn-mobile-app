import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/constants.dart';
import 'storage_service.dart';

class ApiService {
  late Dio _dio;
  
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: Duration(milliseconds: Constants.connectTimeout),
        receiveTimeout: Duration(milliseconds: Constants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to headers
          final token = await StorageService.getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          if (kDebugMode) {
            print('REQUEST: ${options.method} ${options.uri}');
            print('HEADERS: ${options.headers}');
            if (options.data != null) {
              print('DATA: ${options.data}');
            }
          }
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
            print('DATA: ${response.data}');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print('ERROR: ${error.response?.statusCode} ${error.requestOptions.uri}');
            print('ERROR DATA: ${error.response?.data}');
          }
          
          // Handle token expiration
          if (error.response?.statusCode == 401) {
            _handleUnauthorized();
          }
          
          handler.next(error);
        },
      ),
    );
  }
  
  void _handleUnauthorized() async {
    await StorageService.clearAuth();
    // TODO: Navigate to login screen
  }
  
  // GET Request
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // POST Request
  Future<Response> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.post(endpoint, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // PUT Request
  Future<Response> put(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.put(endpoint, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // DELETE Request
  Future<Response> delete(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(endpoint, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // File Upload
  Future<Response> uploadFile(String endpoint, File file, {Map<String, dynamic>? data}) async {
    try {
      FormData formData = FormData.fromMap({
        'attachment': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        ...?data,
      });
      
      return await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // Error Handler
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: Constants.networkErrorMessage,
          statusCode: -1,
        );
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? -1;
        final data = error.response?.data;
        
        String message = Constants.serverErrorMessage;
        
        if (data is Map<String, dynamic>) {
          if (data.containsKey('message')) {
            message = data['message'];
          } else if (data.containsKey('errors')) {
            // Handle validation errors
            final errors = data['errors'] as Map<String, dynamic>;
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              message = firstError.first;
            }
          }
        }
        
        return ApiException(
          message: message,
          statusCode: statusCode,
          errors: data is Map<String, dynamic> ? data['errors'] : null,
        );
      
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled',
          statusCode: -1,
        );
      
      case DioExceptionType.unknown:
      default:
        if (error.error is SocketException) {
          return ApiException(
            message: Constants.networkErrorMessage,
            statusCode: -1,
          );
        }
        return ApiException(
          message: error.message ?? Constants.serverErrorMessage,
          statusCode: -1,
        );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors;
  
  ApiException({
    required this.message,
    required this.statusCode,
    this.errors,
  });
  
  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }
  
  bool get isUnauthorized => statusCode == 401;
  bool get isValidationError => statusCode == 422;
  bool get isServerError => statusCode >= 500;
  bool get isNetworkError => statusCode == -1;
}

// API Response Model
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  
  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });
  
  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJson) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJson != null ? fromJson(json['data']) : json['data'],
      errors: json['errors'],
    );
  }
}
