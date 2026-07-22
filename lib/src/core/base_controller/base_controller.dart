import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

abstract class BaseController extends GetxController {
  final RxBool isLoading = false.obs;
  final _isShowingSuccessMessage = false;

  Future<void> runWithLoading(Future<void> Function() task, {
    String message = "",
  }) async {
    bool hasError = false;
    _isShowingSuccessMessage = false;

    try {
      WidgetsBinding.instance.addPostFrameCallback(
            (_) => isLoading(true),
      ); // Wait until the current UI frame is finished before starting the loader to avoid "setState() during build" errors.

      await task();
    }
    onDioException
    catch (e, stacktrace) {
    hasError = true;

    }
  }

  void _handleException(dynamic e, StackTrace stackTrace,
      {required bool isNetworkError}) {
    debugPrint('--- [BASE CONTROLLER] EXCEPTION CAUGHT ---');
    debugPrint('Type: ${e.runtimeType}');
    debugPrint('Message: ${e.toString()}');
    debugPrint('StackTrace: $stackTrace');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      String cleanMessage = e.message ?? "An unexpected error occurred.";
      if (isNetworkError && e is DioException) {
        cleanMessage = _parseNetworkError(e);
      } else {
        cleanMessage = e.toString().replaceAll('Exception', '').trim();
      }
    });
  }

  String _parseNetworkError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Please check your network stability.';
    } else if (e.response != null && e.response?.data != null) {
      // Attempt to extract server-provided error message payload
      try {
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          return e.response!.data['message'].toString();
        }
      } catch (_) {}
      return 'Server error: ${e.response?.statusCode}';
    }
    return 'A network error occurred. Please try again.';
  }
}
