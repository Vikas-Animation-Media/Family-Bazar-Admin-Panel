import 'package:dio/dio.dart';
import 'package:family_bazar_admin_panel/src/core/const/api_constants.dart';
import 'package:family_bazar_admin_panel/src/core/const/app_colors.dart';
import 'package:family_bazar_admin_panel/src/core/const/app_constants.dart';
import 'package:family_bazar_admin_panel/src/core/utils/storage/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;
  late final Dio _dio;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor for logging, auth headers, and global error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          try {
            if (Get.isRegistered<StorageService>()) {
              final StorageService storage = Get.find<StorageService>();
              final token = storage.getString('auth_token');

              // If the user is logged in, attach the Bearer token to this request
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            }
          } catch (e) {
            // Failsafe gracefully if StorageService isn't initialized yet on boot
            debugPrint("--- [API CLIENT] Interceptor Auth Warning: Failed to attach token - $e ---");
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Global Error Routing: Catch expired or invalid tokens
          if (e.response?.statusCode == 401) {
            try {
              if (Get.isRegistered<StorageService>()) {
                final StorageService storage = Get.find<StorageService>();
                await storage.clearAll();
              }
              Get.offAllNamed('AppRoutes.auth'); // Force the user back to the Auth screen

              // Show a snackbar explaining the session expired
              Get.snackbar(
                'Session Expired',
                'Please log in again to continue.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.error,
                colorText: AppColors.textPrimaryLight,
              );
            } catch (clearError) {
              debugPrint("--- [API CLIENT] Failed to clear session on 401: $clearError ---");
            }
          }

          return handler.next(e);
        },
      ),
    );

    // Logging interceptor (Disable in production)
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  Dio get dio => _dio;
}