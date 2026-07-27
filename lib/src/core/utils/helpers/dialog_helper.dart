import 'package:family_bazar_admin_panel/src/core/const/app_colors.dart';
import 'package:family_bazar_admin_panel/src/core/const/app_strings.dart';
import 'package:family_bazar_admin_panel/src/core/utils/extensions/style_extensions.dart'; // Added for context extensions
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelper {
  // Private constructor to prevent instantiation of this utility class
  DialogHelper._();

  // State lock to prevent OOM through dialog stacking
  static bool _isDialogActive = false;
  static bool _isOfflineDialogActive = false;

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
    // Prevent multiple dialogs from stacking and causing an OOM or UI freeze
    if (_isDialogActive || _isOfflineDialogActive) {
      if (Get.isDialogOpen == true) Get.back(); // Dismiss the existing dialog before showing the new one
    }

    _isDialogActive = true;

    Get.dialog(
      PopScope(
        canPop: false, // Strict block preventing back-button bypass
        child: Builder(
          builder: (context) {
            final double dialogWidth = context.responsiveWidth(context.screenWidth * 0.85, 400);
            return Dialog(
              backgroundColor: context.isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              shape: RoundedRectangleBorder(borderRadius: context.responsiveRadius(16, 20)),
              child: Container(
                width: dialogWidth,
                padding: EdgeInsets.symmetric(
                  vertical: context.responsiveHeight(24, 30),
                  horizontal: context.responsiveWidth(20, 24),
                ),
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    Icon(icon, color: titleColor, size: context.responsiveSize(45, 55)),
                    SizedBox(height: context.responsiveHeight(16, 20)),
                    Text(
                      title,
                      style: context.titleStyleActive.copyWith(color: titleColor),
                      textAlign: .center,
                    ),
                    SizedBox(height: context.responsiveHeight(12, 16)),
                    Text(
                      message,
                      textAlign: .center,
                      style: context.bodyTextStyle.copyWith(color: titleColor),
                    ),
                    SizedBox(height: context.responsiveHeight(24, 30)),
                    SizedBox(
                      width: .infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _isDialogActive = false;
                          if (Get.isDialogOpen == true) {
                            Get.back();
                          }
                          if (onPressed != null) onPressed();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: titleColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: context.responsiveHeight(14, 16)),
                          shape: RoundedRectangleBorder(borderRadius: context.responsiveRadius(8, 12)),
                        ),
                        child: const Text(AppStrings.close),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      barrierDismissible: false,
    ).then((_) {
      _isDialogActive = false; // Ensure the lock is released if the dialog is dismissed by any systemic means
    });
  }

  static void showOfflineDialog() {
    if (_isOfflineDialogActive) return;
    if (_isDialogActive && Get.isDialogOpen == true) {
      Get.back();
      _isDialogActive = false;
    }

    _isOfflineDialogActive = true;
    Get.dialog(
      PopScope(
        canPop: false, // Strict block preventing back-button bypass
        child: Builder(
          builder: (context) {
            final double dialogWidth = context.responsiveWidth(context.screenWidth * 0.85, 450);
            return Dialog(
              backgroundColor: context.isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              shape: RoundedRectangleBorder(
                borderRadius: context.responsiveRadius(16, 20),
                side: BorderSide(
                  color: context.isDark ? AppColors.error.withValues(alpha: 0.5) : AppColors.error,
                  width: 1.5,
                ),
              ),
              child: Container(
                width: dialogWidth,
                padding: EdgeInsets.all(context.responsiveSize(24, 30)),
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    Icon(Icons.wifi_off, color: AppColors.error, size: context.responsiveSize(50, 60)),
                    SizedBox(height: context.responsiveHeight(16, 20)),
                    Text(
                      'Connection Lost',
                      style: context.mainHeadingTextStyle.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.responsiveHeight(12, 16)),
                    Text(
                      'This application requires an active internet connection to process utility modules. Please restore your connection to continue.',
                      style: context.bodyTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      barrierDismissible: false,
    ).then((_) {
      _isOfflineDialogActive = false;
    });
  }

  /// Utility to safely dismiss the offline dialog once connection restores
  static void dismissOfflineDialog() {
    if(_isOfflineDialogActive && Get.isDialogOpen == true) {
      Get.back();
      _isOfflineDialogActive = false;
    }
  }
}
