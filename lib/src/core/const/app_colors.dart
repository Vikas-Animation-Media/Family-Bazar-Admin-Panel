import 'package:flutter/material.dart';

@immutable
abstract final class AppColors {
  const AppColors._(); // Private constructor to prevent instantiation

  // ==========================================
  // BRAND COLORS (Extracted strictly from Logo)
  // ==========================================

  /// Primary Brand Color: Vibrant Orange (From Cart & Pin)
  /// Use for primary buttons, active icons, and major call-to-actions.
  static const Color primaryBrandOrange = Color(0xFFFF6B00);
  static const Color primaryOrangeLight = Color(0xFFFF8B33);
  static const Color primaryOrangeDark  = Color(0xFFCC5600);

  /// Secondary Brand Color: Deep Navy (From Cart Wheels & Structure)
  /// Use for app bars, side navigation panels, or primary text elements.
  static const Color secondaryBrandNavy = Color(0xFF0F172A);
  static const Color secondaryNavyLight = Color(0xFF1E293B);
  static const Color secondaryNavyDark  = Color(0xFF020617);

  /// Accent Color: Fresh Green (From Leaf Element)
  /// Use for highlights, success indicators, or organic UI elements.
  static const Color accentLeafGreen = Color(0xFF10B981);

  // ==========================================
  // BACKGROUNDS & SURFACES (Responsive Web Target)
  // ==========================================

  // LIGHT THEME
  static const Color backgroundLight = Color(0xFFF8FAFC); // Soft cool-gray for main canvas
  static const Color surfaceLight    = Color(0xFFFFFFFF); // Pure white for cards/dialogs

  // DARK THEME
  static const Color backgroundDark  = Color(0xFF0B1120); // Deepest navy for dark canvas
  static const Color surfaceDark     = Color(0xFF151F32); // Elevated navy for dark cards

  // ==========================================
  // SEMANTIC TYPOGRAPHY (Accessibility Focus)
  // ==========================================

  // LIGHT THEME TEXT
  static const Color textPrimaryLight   = Color(0xFF0F172A); // Almost black (High contrast)
  static const Color textSecondaryLight = Color(0xFF475569); // Medium slate for subtitles
  static const Color textHintLight      = Color(0xFF94A3B8); // Light slate for hints/disabled

  // DARK THEME TEXT
  static const Color textPrimaryDark    = Color(0xFFF8FAFC); // Off-white (High contrast)
  static const Color textSecondaryDark  = Color(0xFF94A3B8); // Medium slate for subtitles
  static const Color textHintDark       = Color(0xFF475569); // Darker slate for hints/disabled

  // ==========================================
  // STATUS INDICATORS (Global Safety Nets)
  // ==========================================
  static const Color success = accentLeafGreen; // Reusing leaf green for brand consistency
  static const Color error   = Color(0xFFEF4444); // Standard strict red
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color info    = Color(0xFF3B82F6); // Standard blue

  // ==========================================
  // STRUCTURAL ELEMENTS (Borders & Dividers)
  // ==========================================
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark  = Color(0xFF334155);
}