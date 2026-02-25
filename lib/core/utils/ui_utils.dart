import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// UI Utility class for custom decorations and effects
class UiUtils {
  /// Liquid glass effect decoration (frosted glass with blur)
  static BoxDecoration liquidGlass({
    bool isDark = false,
    Color? customColor,
    double borderRadius = 16,
    Color? borderColor,
    double borderWidth = 1,
  }) {
    return BoxDecoration(
      color:
          customColor ??
          (isDark
              ? AppColors.gradientGlassDark[0]
              : AppColors.gradientGlass[0]),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color:
            borderColor ?? (isDark ? AppColors.borderDark : AppColors.border),
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Gradient primary decoration
  static BoxDecoration gradientPrimary({
    double borderRadius = 16,
    List<Color>? customGradient,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: customGradient ?? AppColors.gradientPrimary,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// Gradient primary decoration with theme awareness (Light/Dark mode)
  static BoxDecoration gradientPrimaryThemed({
    double borderRadius = 16,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;
    return BoxDecoration(
      gradient: LinearGradient(
        colors: isDark ? AppColors.gradientPrimaryDark : AppColors.gradientPrimary,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: isDark ? AppColors.gold.withValues(alpha: 0.2) : AppColors.primary.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// Gradient gold decoration
  static BoxDecoration gradientGold({double borderRadius = 16}) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: AppColors.gradientGold,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: AppColors.gold.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// Gradient warm decoration (subtle background)
  static BoxDecoration gradientWarm({double borderRadius = 0}) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: AppColors.gradientWarm,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  /// Hover lift effect (shadow transition)
  static BoxDecoration hoverLift({
    bool isHovered = false,
    bool isDark = false,
    double borderRadius = 16,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: isDark ? AppColors.surfaceDark : AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color:
            borderColor ??
            (isHovered
                ? (isDark
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.5))
                : (isDark ? AppColors.borderDark : AppColors.border)),
        width: 1,
      ),
      boxShadow: isHovered
          ? [
              BoxShadow(
                color: (isDark ? Colors.black : Colors.black.withValues(alpha: 0.1)),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ]
          : [
              BoxShadow(
                color: (isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05)),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
    );
  }

  /// Shadow glow effect (primary color glow)
  static List<BoxShadow> shadowGlow({Color? color}) {
    return [
      BoxShadow(
        color: (color ?? AppColors.primary).withValues(alpha: 0.4),
        blurRadius: 40,
        offset: const Offset(0, 0),
      ),
    ];
  }

  /// Shadow gold effect
  static List<BoxShadow> shadowGold() {
    return [
      BoxShadow(
        color: AppColors.gold.withValues(alpha: 0.5),
        blurRadius: 60,
        offset: const Offset(0, 0),
      ),
    ];
  }

  /// Text gradient (for headings)
  /// Returns a ShaderCallback that can be used with ShaderMask
  static ShaderCallback textGradient(List<Color> colors) {
    return (Rect bounds) {
      return LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds);
    };
  }
}
