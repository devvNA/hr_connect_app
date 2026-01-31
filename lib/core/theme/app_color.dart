import 'package:flutter/material.dart';

/// Design System Colors
class AppColors {
  AppColors._();

  // Primary Palette (From HTML Reference)
  static const Color primary = Color(0xFF135BEC);
  static const Color primaryDark = Color(0xFF0E46B5);
  static const Color primaryContainer = Color(0xFFE7EEFD); // primary/10 approx

  // Background Colors
  static const Color background = Color(0xFFF8F9FB); // background-light
  static const Color backgroundDark = Color(0xFF101622);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A2230);

  // Text Colors
  static const Color textPrimary = Color(0xFF111318);
  static const Color textSecondary = Color(0xFF6B7280); // gray-500
  static const Color textLight = Color(0xFF9CA3AF); // gray-400
  static const Color textOnPrimary = Colors.white;

  // Status & Accent Colors
  static const Color success = Color(0xFF16A34A); // green-600
  static const Color successContainer = Color(0xFFF0FDF4); // green-50

  static const Color warning = Color(0xFFEA580C); // orange-600
  static const Color warningContainer = Color(0xFFFFF7ED); // orange-50

  static const Color purple = Color(0xFF9333EA); // purple-600
  static const Color purpleContainer = Color(0xFFFAF5FF); // purple-50

  static const Color error = Color(0xFFEF4444); // red-500

  // UI Elements
  static const Color border = Color(0xFFF3F4F6); // gray-100
  static const Color divider = Color(0xFFE5E7EB); // gray-200
  static const Color inputFill = Colors.white;

  // Backward Compatibility / Aliases for AppTheme
  static const Color primarySurface = primaryContainer;
  static const Color secondary = Color(
    0xFFDFE6F6,
  ); // Keeping original secondary
  static const Color cardBackground = surface;
  static const Color textHint = textLight;

  // Shadows (Approximation for Flutter)
  static final List<BoxShadow> shadowSoft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 20,
      offset: const Offset(0, 4),
      spreadRadius: -2,
    ),
  ];

  static final List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];
}
