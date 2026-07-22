import 'package:family_bazar_admin_panel/src/core/global_widgets/layout/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 1. CONTEXT EXTENSIONS (Layout, Dimensions & Theme)
extension UIContextExt on BuildContext {
  // --- Screen Information ---
  bool get isMobile => ResponsiveLayout.isMobile(this);
  bool get isTablet => ResponsiveLayout.isTablet(this);
  bool get isDesktop => ResponsiveLayout.isDesktop(this);

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // --- Responsive Sizing Generators ---
  double responsiveSize(double mobileSize, double desktopSize) => isMobile ? mobileSize.sp : desktopSize;
  double responsiveWidth(double mobileWidth, double desktopWidth) => isMobile ? mobileWidth.w : desktopWidth;
  double responsiveHeight(double mobileHeight, double desktopHeight) => isMobile ? mobileHeight.h : desktopHeight;

  BorderRadius responsiveRadius(double mobileRadius, double desktopRadius) =>
      BorderRadius.circular(isMobile ? mobileRadius.r : desktopRadius);
}

/// 2. DATA TYPE EXTENSIONS (Int, String)
extension IntExt on int {
  /// Converts large numbers to K or M formats (e.g., 1500 -> 1.5K)
  String formatAsK() {
    if (this >= 1000000) {
      return this % 1000000 == 0
          ? '${(this / 1000000).toStringAsFixed(0)}M'
          : '${(this / 1000000).toStringAsFixed(2)}M';
    } else if (this >= 1000) {
      return this % 1000 == 0 ? '${(this / 1000).toStringAsFixed(0)}K' : '${(this / 1000).toStringAsFixed(2)}K';
    } else {
      return toString();
    }
  }
}

extension StringExtensions on String {
  /// Capitalizes the first letter safely
  String get capitalizeFirst {
    if (trim().isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  /// Converts to fixed string safely. Returns "0.00" on failure.
  String toFixedString() {
    final parsedDouble = double.tryParse(this);
    if (parsedDouble == null) return "0.00";
    return parsedDouble.toStringAsFixed(2);
  }

  /// Removes HTML elements safely for displaying raw text
  String removeHtmlTags() {
    if (trim().isEmpty) return "";
    String formatted = replaceAll(RegExp(r'<br\s*/?>'), "\n")
        .replaceAll(RegExp(r'</p>'), "\n")
        .replaceAll(RegExp(r'</div>'), "\n");
    formatted = formatted.replaceAll(RegExp(r'<[^>]*>'), "");
    formatted = formatted.replaceAll("&nbsp;", " ");
    return formatted.trim();
  }

  String replaceBackslash() => replaceAll(RegExp(r'\n'), "");

  /// Converts Hex String to Color
  Color toColor() {
    try {
      var hexColor = replaceAll("#", "");
      if (hexColor.length == 6) hexColor = "FF$hexColor";
      if (hexColor.length == 8) return Color(int.parse("0x$hexColor"));
    } catch (_) {
      return Colors.grey;
    }
    return Colors.grey;
  }
}
