import 'package:family_bazar_admin_panel/src/core/const/app_colors.dart';
import 'package:family_bazar_admin_panel/src/core/const/app_strings.dart';
import 'package:family_bazar_admin_panel/src/core/utils/extensions/style_extensions.dart'; // Added for context extensions
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Added for .h, .w, .sp
import 'package:get/get.dart';

class DialogHelper {
  // Private constructor to prevent instantiation of this utility class
  DialogHelper._();

  // State lock to prevent OOM through dialog stacking
  static bool _isDialogActive = false;

  /// Displays an error dialog safely, preventing stacking
  static void showError({String? title, required String message, VoidCallback? onPressed}) {
    if (Get.overlayContext == null) return;
    _showGlobalDialog(
      // Ensure AppStrings is imported in your actual file
      title: title ?? "Alert", // Fallback if AppStrings is not available
      message: message,
      titleColor: AppColors.error,
      icon: Icons.error_outline,
      onPressed: onPressed,
    );
  }

  /// Displays a success dialog safely, preventing stacking
  static void showSuccess({required String title, required String message, VoidCallback? onPressed}) {
    if (Get.overlayContext == null) return;
    _showGlobalDialog(
      title: title,
      message: message,
      titleColor: AppColors.success,
      icon: Icons.check_circle_outline,
      onPressed: onPressed,
    );
  }

  /// Core dialog generation logic with concurrency lock
  static void _showGlobalDialog({
    required String title,
    required String message,
    required Color titleColor,
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    // Safely get context for our style extensions
    final context = Get.overlayContext;
    if (context == null) return;

    // Prevent multiple dialogs from stacking and causing an OOM or UI freeze
    if (_isDialogActive) {
      Get.back(); // Dismiss the existing dialog before showing the new one
    }

    _isDialogActive = true;

    Get.defaultDialog(
      title: "",
      titleStyle: const TextStyle(fontSize: 0),
      contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      barrierDismissible: false,
      onWillPop: () async => false, // Prevent Android hardware back button bypass
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: titleColor, size: context.responsiveSize(40, 40)),
          SizedBox(height: context.responsiveHeight(16, 16)),
          Text(
            title,
            style: context.titleStyleActive.copyWith(color: titleColor),
          ),
          SizedBox(height: context.responsiveHeight(12, 12)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.bodyTextStyle.copyWith(color: titleColor),
          ),
          SizedBox(height: context.responsiveHeight(20, 20)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _isDialogActive = false;
                if (Get.isDialogOpen ?? false) {
                  Get.back();
                }
                if (onPressed != null) onPressed();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: titleColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: context.responsiveHeight(12, 12)),
              ),
              child: const Text(AppStrings.close),
            ),
          ),
        ],
      ),
    ).then((_) {
      // Ensure the lock is released if the dialog is dismissed by any systemic means
      _isDialogActive = false;
    });
  }

  static void showOfflineDialog() {
    if (Get.isDialogOpen == true) return;

    Get.dialog(
      PopScope(
        canPop: false, // Strict block preventing back-button bypass
        child: Builder(
            builder: (context) {
              return AlertDialog(
                backgroundColor: context.isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: BorderSide(
                    color: context.isDark ? Colors.blueAccent : Colors.blue,
                    width: 1.w,
                  ),
                ),
                title: Row(
                  children: [
                    Icon(Icons.wifi_off, color: AppColors.error, size: 28.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'Connection Lost',
                        style: context.titleStyleActive.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
                content: Text(
                  'This application requires an active internet connection to process utility modules. Please restore your connection to continue.',
                  style: context.bodyTextStyle,
                ),
              );
            }
        ),
      ),
      barrierDismissible: false,
    );
  }
}