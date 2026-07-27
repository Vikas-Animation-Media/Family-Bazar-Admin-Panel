import 'dart:async';

import 'package:dio/dio.dart';
import 'package:family_bazar_admin_panel/src/core/const/app_strings.dart';
import 'package:family_bazar_admin_panel/src/core/utils/helpers/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class BaseController extends GetxController {
  final RxBool isLoading = false.obs;
  bool _isShowingSuccessMessage = false;

  /// Core wrapper for executing tasks with automated loading state and error handling
  Future<void> runWithLoading(Future<void> Function() task, {String message = 'Processing...'}) async {
    if (isClosed) return; // Abort immediately if the controller is already destroyed
    bool hasError = false;
    _isShowingSuccessMessage = false;

    try {
      // Wait until the current UI frame is finished before starting the loader
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isClosed) isLoading(true); // Double-check before mutating state in a new frame
      });
      await task();
    } on DioException catch (e, stackTrace) {
      hasError = true;
      _handleException(e, stackTrace, isNetworkError: true);
    } catch (e, stackTrace) {
      hasError = true;
      _handleException(e, stackTrace, isNetworkError: false);
    } finally {
      if (isClosed) return; // defensive check before mutating UI state after a long-running async task
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isClosed) return;

        isLoading(false);
        // Only close active dialogs (like loading overlays) if no error or success dialog took over
        if (!hasError && !_isShowingSuccessMessage && Get.isDialogOpen == true) {
          Get.back();
        }
      });
    }
  }

  void _handleException(dynamic e, StackTrace stackTrace, {required bool isNetworkError}) {
    if (isClosed) return;

    Sentry.captureException(
      e,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('error_type', isNetworkError ? 'network' : 'business_logic');
        scope.setContexts('Controller Context', {'controller': runtimeType.toString()});
      },
    );
    debugPrint('--- [BASE CONTROLLER] EXCEPTION CAUGHT ---');
    debugPrint('Type: ${e.runtimeType}');
    debugPrint('Message: ${e.toString()}');
    debugPrint('StackTrace: $stackTrace');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed) return;
      String cleanMessage = 'An unexpected error occurred.';

      if (isNetworkError && e is DioException) {
        cleanMessage = _parseNetworkError(e);
      } else {
        cleanMessage = e.toString().replaceAll('Exception: ', '').trim();
      }

      // Delegating to our centralized DialogHelper
      DialogHelper.showError(message: cleanMessage);
    });
  }

  String _parseNetworkError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return AppStrings.connectionTimeout;
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return AppStrings.receiveTimeout;
    } else if (e.type == DioExceptionType.sendTimeout) {
      return AppStrings.sendTimeout;
    } else if (e.response != null) {
      // Attempt to extract server-provided error message payload
      try {
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        }
      } catch (_) {}

      // Standardize common HTTP status codes
      switch (e.response?.statusCode) {
        case 400:
          return AppStrings.msg400;
        case 401:
          return AppStrings.msg401;
        case 403:
          return AppStrings.msg403;
        case 404:
          return AppStrings.msg404;
        case 405:
          return AppStrings.msg405;
        case 408:
          return AppStrings.msg408;
        case 409:
          return AppStrings.msg409;
        case 413:
          return AppStrings.msg413;
        case 415:
          return AppStrings.msg415;
        case 422:
          return AppStrings.msg422;
        case 429:
          return AppStrings.msg429;
        case 500:
          return AppStrings.msg500;
        case 502:
          return AppStrings.msg502;
        case 503:
          return AppStrings.msg503;
        case 504:
          return AppStrings.msg504;
        case 505:
          return AppStrings.msg505;
        case 522:
          return AppStrings.msg522;
        default:
          return '${AppStrings.errorMsgDefault}: ${e.response?.statusCode}';
      }
    }
    return 'A network error occurred. Please check your internet connection.';
  }

  void successMessage({required String title, required String message, VoidCallback? onPressed}) {
    _isShowingSuccessMessage = true;
    DialogHelper.showSuccess(title: title, message: message, onPressed: onPressed);
  }

  void errorMessage({String? title, required String message, VoidCallback? onPressed}) {
    DialogHelper.showError(title: title, message: message, onPressed: onPressed);
  }
}
