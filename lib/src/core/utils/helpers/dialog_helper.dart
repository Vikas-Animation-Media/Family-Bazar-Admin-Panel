import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogHelper {
  DialogHelper._();

  static bool _isDialogOpen = false; // State lock to prevent OOM through dialog stacking
  static void showError({String? title, required String message, VoidCallback? onPressed}) {
    if (Get.overlayContext == null) return;
  }

  static void _showDialog({
    required String title,
    required String message,
    required Color titleColor,
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    /// Prevent multiple dialogs from stacking and causing an OOM or UI freeze
    if (_isDialogOpen) Get.back(); // Dismiss the existing dialog before showing the new one

    _isDialogOpen = true;

    Get.defaultDialog(
      title: "",
      titleStyle: const TextStyle(fontSize: 0),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      barrierDismissible: false,
      onWillPop: () async => false, // Prevent Android hardware back button bypass
      content: Column(
        mainAxisSize: .min,
        children: [
          Icon(icon, color: titleColor, size: 40),
          const SizedBox(height: 16),
          Text(title,
            style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.bold, color: titleColor),)
        ]
      )
    );
  }
}
