import 'package:family_bazar_admin_panel/src/core/const/app_constants.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget desktop;
  final Widget mobile;
  final Widget? tablet;

  const ResponsiveLayout({super.key, required this.desktop, required this.mobile, this.tablet});

  /// Evaluates screen width.
  /// Uses [MediaQuery.sizeOf] to prevent unnecessary rebuilds triggered by non-size
  /// MediaQuery changes (e.g., keyboard opening/closing).
  static bool isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < AppConstants.mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppConstants.mobileBreakpoint &&
      MediaQuery.sizeOf(context).width < AppConstants.tabletBreakpoint;

  static bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= AppConstants.tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder ensures the widget responds to parent constraints rather than
    // global screen size, allowing safe nesting without layout overflow crashes.
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;

        if(maxWidth >= AppConstants.tabletBreakpoint) {
          return desktop;
        } else if (maxWidth >= AppConstants.mobileBreakpoint) {
          return tablet ?? desktop;
        } else {
          return mobile;
        }
      }
    );
  }
}
