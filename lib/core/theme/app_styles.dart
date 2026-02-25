import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Reusable text styles for the app
class AppStyles {
  // Display styles (using Playfair Display)
  static TextStyle displayLarge = GoogleFonts.playfairDisplay(
    fontSize: AppSizes.font3xl,
    fontWeight: FontWeight.bold,
    color: AppColors.foreground,
  );

  static TextStyle displayMedium = GoogleFonts.playfairDisplay(
    fontSize: AppSizes.font2xl,
    fontWeight: FontWeight.bold,
    color: AppColors.foreground,
  );

  static TextStyle displaySmall = GoogleFonts.playfairDisplay(
    fontSize: AppSizes.fontXxxl,
    fontWeight: FontWeight.bold,
    color: AppColors.foreground,
  );

  // Headline styles (using Playfair Display)
  static TextStyle headlineLarge = GoogleFonts.playfairDisplay(
    fontSize: AppSizes.fontXxl,
    fontWeight: FontWeight.bold,
    color: AppColors.foreground,
  );

  static TextStyle headlineMedium = GoogleFonts.playfairDisplay(
    fontSize: AppSizes.fontXl,
    fontWeight: FontWeight.bold,
    color: AppColors.foreground,
  );

  static TextStyle headlineSmall = GoogleFonts.playfairDisplay(
    fontSize: AppSizes.fontLg,
    fontWeight: FontWeight.w600,
    color: AppColors.foreground,
  );

  // Title styles (using Inter)
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: AppSizes.fontLg,
    fontWeight: FontWeight.w600,
    color: AppColors.foreground,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Body styles (using Inter)
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: AppSizes.fontLg,
    fontWeight: FontWeight.w400,
    color: AppColors.foreground,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Label styles (using Inter)
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w500,
    color: AppColors.foreground,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Gradient definitions for easy access
  static const LinearGradient liquidGlass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.gradientGlass,
  );

  static const LinearGradient gradientWarm = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.gradientWarm,
  );

  static const LinearGradient gradientGold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.gradientGold,
  );

  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.gradientPrimary,
  );
}
