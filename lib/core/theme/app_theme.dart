import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.foreground,
      tertiary: AppColors.gold,
      onTertiary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.surface,
      onSurface: AppColors.foreground,
      outline: AppColors.border,
    ),
    // Scaffold background
    scaffoldBackgroundColor: AppColors.background,

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: const BorderSide(
          color: AppColors.border,
          width: AppSizes.borderSm,
        ),
      ),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        minimumSize: const Size(double.infinity, AppSizes.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, AppSizes.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        side: const BorderSide(
          color: AppColors.primary,
          width: AppSizes.borderSm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
      ),
    ),

    // Input Field Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: AppSizes.borderMd,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: AppSizes.borderMd,
        ),
      ),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintStyle: const TextStyle(color: AppColors.textTertiary),
      errorStyle: const TextStyle(color: AppColors.error),
    ),

    // Text Theme with Playfair Display for headlines
    textTheme: TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: AppSizes.font3xl,
        fontWeight: FontWeight.bold,
        color: AppColors.foreground,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: AppSizes.font2xl,
        fontWeight: FontWeight.bold,
        color: AppColors.foreground,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: AppSizes.fontXxxl,
        fontWeight: FontWeight.bold,
        color: AppColors.foreground,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: AppSizes.fontXxl,
        fontWeight: FontWeight.bold,
        color: AppColors.foreground,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: AppSizes.fontXl,
        fontWeight: FontWeight.w600,
        color: AppColors.foreground,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: AppSizes.fontLg,
        fontWeight: FontWeight.w600,
        color: AppColors.foreground,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: AppSizes.fontMd,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: AppSizes.fontSm,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: AppSizes.fontLg,
        fontWeight: FontWeight.w400,
        color: AppColors.foreground,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: AppSizes.fontMd,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: AppSizes.fontSm,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: AppSizes.fontMd,
        fontWeight: FontWeight.w500,
        color: AppColors.foreground,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: AppSizes.fontSm,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: AppSizes.fontXs,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: AppSizes.dividerHeight,
      space: AppSizes.lg,
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.primary),
      trackColor: WidgetStateProperty.all(AppColors.border),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXs),
      ),
      side: const BorderSide(color: AppColors.border),
      fillColor: WidgetStateProperty.all(AppColors.primary),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(AppColors.primary),
    ),

    // FAB Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 2,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.dark(
      primary: AppColors.gold,
      onPrimary: AppColors.backgroundDark,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.foregroundDark,
      tertiary: AppColors.accentDark,
      onTertiary: AppColors.backgroundDark,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.foregroundDark,
      outline: AppColors.borderDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.foregroundDark,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: const BorderSide(
          color: AppColors.borderDark,
          width: AppSizes.borderSm,
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: AppSizes.font3xl,
        fontWeight: FontWeight.bold,
        color: AppColors.foregroundDark,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: AppSizes.font2xl,
        fontWeight: FontWeight.bold,
        color: AppColors.foregroundDark,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: AppSizes.fontXxxl,
        fontWeight: FontWeight.bold,
        color: AppColors.foregroundDark,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: AppSizes.fontXxl,
        fontWeight: FontWeight.bold,
        color: AppColors.foregroundDark,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: AppSizes.fontXl,
        fontWeight: FontWeight.w600,
        color: AppColors.foregroundDark,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: AppSizes.fontMd,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryDark,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: AppSizes.fontLg,
        fontWeight: FontWeight.w400,
        color: AppColors.foregroundDark,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: AppSizes.fontSm,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryDark,
      ),
    ),
  );

  // Static color getters for easy access
  static const Color goldColor = AppColors.gold;
  static const Color roseColor = AppColors.rose;
  static const Color sageColor = AppColors.sage;
  static const Color textSecondary = AppColors.textSecondary;

  // Gradient definitions
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
