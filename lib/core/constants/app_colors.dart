import 'package:flutter/material.dart';

/// Salon Manager App Color Palette
/// Matching React app design: Gold + Rose + Sage aesthetic
class AppColors {
  // Primary Colors (Warm Terracotta/Coral)
  static const Color primary = Color(0xFFD4775E); // hsl(15 60% 55%)
  static const Color primaryLight = Color(0xFFF5DED8);
  static const Color primaryDark = Color(0xFFB85F48);

  // Secondary Colors (Warm Beige/Cream)
  static const Color secondary = Color(0xFFF2EBE6); // hsl(30 30% 94%)
  static const Color secondaryLight = Color(0xFFFAF7F5);
  static const Color secondaryDark = Color(0xFFE5D9CF);

  // Gold Colors
  static const Color gold = Color(0xFFD4A853); // hsl(38 70% 55%)
  static const Color goldLight = Color(0xFFF5EDD8); // hsl(38 60% 85%)
  static const Color goldDark = Color(0xFFB88D3A);

  // Rose Colors
  static const Color rose = Color(0xFFD47B8E); // hsl(350 50% 65%)
  static const Color roseLight = Color(0xFFF5E0E6); // hsl(350 40% 92%)
  static const Color roseDark = Color(0xFFB85F72);

  // Sage Colors
  static const Color sage = Color(0xFF7BA38C); // hsl(140 20% 55%)
  static const Color sageLight = Color(0xFFE6F0EB); // hsl(140 15% 92%)
  static const Color sageDark = Color(0xFF5F8570);

  // Semantic Colors
  static const Color success = Color(0xFF22C55E); // Green
  static const Color warning = Color(0xFFFECA57); // Yellow
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF06B6D4); // Cyan

  // Neutral Colors - Light Mode
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFFFAF7F5); // hsl(30 20% 98%)
  static const Color foreground = Color(0xFF2B2520); // hsl(30 10% 10%)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF); // Same as surface
  static const Color border = Color(0xFFE8DFD8); // hsl(30 20% 90%)
  static const Color borderLight = Color(0xFFE8DFD8); // Same as border

  // Neutral Colors - Dark Mode
  static const Color backgroundDark = Color(0xFF0A0A0A); // hsl(0 0% 4%)
  static const Color foregroundDark = Color(0xFFF5EDD8); // hsl(38 30% 95%)
  static const Color surfaceDark = Color(0xFF121212); // hsl(0 0% 7%)
  static const Color borderDark = Color(0xFF262626); // hsl(0 0% 15%)

  // Gray Scale
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Text Colors - Light Mode
  static const Color textPrimary = Color(0xFF2B2520); // hsl(30 10% 10%)
  static const Color textSecondary = Color(0xFF736B66); // hsl(30 10% 45%)
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);

  // Text Colors - Dark Mode
  static const Color textPrimaryDark = Color(0xFFF5EDD8); // hsl(38 30% 95%)
  static const Color textSecondaryDark = Color(0xFFE5D9CF); // hsl(38 30% 90%)
  static const Color textTertiaryDark = Color(0xFF999999); // hsl(0 0% 60%)
  static const Color textDisabledDark = Color(0xFF666666);

  // Muted Colors
  static const Color muted = Color(0xFFF7F3F0); // hsl(30 20% 96%)
  static const Color mutedForeground = Color(0xFF736B66); // hsl(30 10% 45%)
  static const Color mutedDark = Color(0xFF262626); // hsl(0 0% 15%)
  static const Color mutedForegroundDark = Color(0xFF999999); // hsl(0 0% 60%)

  // Accent Color (for highlights)
  static const Color accent = Color(0xFFD47B8E); // Rose
  static const Color accentForeground = Color(0xFFFFFFFF);
  static const Color accentDark = Color(0xFFD4A853); // Gold
  static const Color accentForegroundDark = Color(0xFF0A0A0A);

  // Overlay Colors
  static const Color overlay = Color(0x00000000); // Transparent
  static const Color overlayLight = Color(0x1F000000); // 12% black
  static const Color overlayMedium = Color(0x33000000); // 20% black
  static const Color overlayDark = Color(0x80000000); // 50% black

  // Gradient Colors (for LinearGradient)
  static const List<Color> gradientPrimary = [
    Color(0xFFD4775E), // primary
    Color(0xFFD47B8E), // rose
  ];

  static const List<Color> gradientPrimaryDark = [
    Color(0xFFD4A853), // gold (primary in dark mode)
    Color(0xFFD47B8E), // rose
  ];

  static const List<Color> gradientWarm = [
    Color(0xFFFAF7F5), // background light
    Color(0xFFF2EBE6), // secondary
  ];

  static const List<Color> gradientGold = [
    Color(0xFFD4A853), // gold
    Color(0xFFB88D3A), // gold dark
  ];

  static const List<Color> gradientGlass = [
    Color(0xE6FFFFFF), // white 90%
    Color(0x99FFFFFF), // white 60%
  ];

  static const List<Color> gradientGlassDark = [
    Color(0xE6141414), // dark 90%
    Color(0x991E1E1E), // dark 60%
  ];
}
