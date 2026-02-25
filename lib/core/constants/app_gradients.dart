import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Gradient System for Salon Manager App
/// Matching React app design: Primary, Warm, Glass, Gold
class AppGradients {
  // Primary Gradient - Primary to Rose
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.gradientPrimary,
  );

  // Warm Gradient - Light to Secondary
  static const LinearGradient warm = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: AppColors.gradientWarm,
  );

  // Glass Gradient - Glassmorphism effect (Light)
  static const LinearGradient glass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.gradientGlass,
  );

  // Glass Gradient - Glassmorphism effect (Dark)
  static const LinearGradient glassDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.gradientGlassDark,
  );

  // Gold Gradient - Accent highlight
  static const LinearGradient gold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.gradientGold,
  );

  // Button Hover Gradient
  static const LinearGradient buttonHover = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFC96550), // Darker primary
      Color(0xFFC46A7E), // Darker rose
    ],
  );

  // Rose Accent Gradient
  static LinearGradient rose = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.rose,
      AppColors.roseDark,
    ],
  );

  // Sage Accent Gradient
  static LinearGradient sage = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.sage,
      AppColors.sageDark,
    ],
  );

  // Success Gradient
  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF22C55E),
      Color(0xFF16A34A),
    ],
  );

  // Warning Gradient
  static const LinearGradient warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFECA57),
      Color(0xFFFDBB2D),
    ],
  );

  // Error Gradient
  static const LinearGradient error = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEF4444),
      Color(0xFFDC2626),
    ],
  );
}
