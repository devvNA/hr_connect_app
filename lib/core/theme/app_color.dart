import 'package:flutter/material.dart';

/// Design System Colors
class AppColors {
  AppColors._();

  // Primary Blue Palette
  static const Color primary = Color(0xFF135BEC);
  static const Color primarySurface = Color(0xFFE7EEFD);

  // Secondary Colors
  static const Color secondary = Color(0xFFDFE6F6);

  // Background Colors
  static const Color background = Color(0xFFFAF7FB);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B6B7B);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Colors.white;

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  static const Color completed = Color(
    0xFF607D8B,
  ); // Blue Grey for completed status

  // Neutral Colors
  static const Color border = Color(0xFFE8E8E8);
  static const Color divider = Color(0xFFF0F0F0);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color shimmer = Color(0xFFEEEEEE);
  static const Color inputFill = Color(0xFFFAFAFA);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4DB6AC), Color(0xFF009688)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4DB6AC), Color(0xFF009688)],
  );
}
