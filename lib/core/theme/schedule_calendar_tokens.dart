import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Design Tokens für ScheduleCalendar Widget
/// Wochenansicht mit Schichten
class ScheduleCalendarTokens {
  // Container
  static const double containerBorderRadius = AppSizes.radiusLg;
  static const double containerElevation = AppSizes.shadowElevationMd;
  static const Color containerBackgroundLight = AppColors.white;
  static const Color containerBackgroundDark = AppColors.surfaceDark;
  static const Color containerBorderLight = AppColors.border;
  static const Color containerBorderDark = AppColors.borderDark;
  static const double containerBorderWidth = AppSizes.borderSm;

  // Padding & Spacing
  static const double paddingXl = AppSizes.xl;
  static const double paddingLg = AppSizes.lg;
  static const double paddingMd = AppSizes.md;
  static const double paddingSmall = AppSizes.sm;

  // Internal Spacing
  static const double headerSpacing = AppSizes.lg;
  static const double dayColumnSpacing = AppSizes.md;
  static const double shiftBlockSpacing = AppSizes.sm;

  // Header Section
  static const Color headerTitleColor = AppColors.foreground;
  static const Color headerTitleColorDark = AppColors.foregroundDark;
  static const double headerTitleFontSize = AppSizes.fontXl;
  static const FontWeight headerTitleFontWeight = FontWeight.bold;

  static const Color dateRangeColor = AppColors.textSecondary;
  static const Color dateRangeColorDark = AppColors.textSecondaryDark;
  static const double dateRangeFontSize = AppSizes.fontSm;

  // Navigation Buttons
  static const double navButtonSize = 36.0;
  static const double navButtonBorderRadius = AppSizes.radiusMd;
  static const Color navButtonBackground = AppColors.surface;
  static const Color navButtonBackgroundDark = AppColors.borderDark;
  static const Color navButtonForeground = AppColors.foreground;
  static const Color navButtonForegroundDark = AppColors.foregroundDark;

  // Day Column Header
  static const Color dayNameColor = AppColors.foreground;
  static const Color dayNameColorDark = AppColors.foregroundDark;
  static const double dayNameFontSize = AppSizes.fontMd;
  static const FontWeight dayNameFontWeight = FontWeight.w600;

  static const Color dayDateColor = AppColors.textSecondary;
  static const Color dayDateColorDark = AppColors.textSecondaryDark;
  static const double dayDateFontSize = AppSizes.fontSm;

  // Day Column Container
  static const double dayColumnBorderRadius = AppSizes.radiusMd;
  static const Color dayColumnBackgroundLight = AppColors.background;
  static const Color dayColumnBackgroundDark = AppColors.borderDark;
  static const Color dayColumnBorderLight = AppColors.border;
  static const Color dayColumnBorderDark = AppColors.borderDark;

  // Today Highlight
  static const Color todayBackgroundLight = AppColors.goldLight;
  static const Color todayBackgroundDark = Color(0xFF2A2520);
  static const Color todayBorderLight = AppColors.gold;
  static const Color todayBorderDark = AppColors.gold;

  // Shift Block
  static const double shiftBlockBorderRadius = AppSizes.radiusMd;
  static const double shiftBlockPaddingX = AppSizes.md;
  static const double shiftBlockPaddingY = AppSizes.sm;
  static const Color shiftBlockBorder = AppColors.gold;
  static const double shiftBlockBorderWidth = AppSizes.borderSm;

  // Shift Status Colors
  static const Color shiftConfirmedBackground = AppColors.sage;
  static const Color shiftConfirmedForeground = AppColors.white;

  static const Color shiftPendingBackground = AppColors.warning;
  static const Color shiftPendingForeground = AppColors.black;

  static const Color shiftCancelledBackground = AppColors.error;
  static const Color shiftCancelledForeground = AppColors.white;

  static const Color shiftCompletedBackground = AppColors.success;
  static const Color shiftCompletedForeground = AppColors.white;

  // Shift Text
  static const double shiftTimeFontSize = AppSizes.fontSm;
  static const FontWeight shiftTimeFontWeight = FontWeight.w600;

  static const double shiftDurationFontSize = AppSizes.fontXs;
  static const FontWeight shiftDurationFontWeight = FontWeight.w400;

  // Off Day Display
  static const Color offDayTextColor = AppColors.textTertiary;
  static const Color offDayTextColorDark = AppColors.textTertiaryDark;
  static const double offDayFontSize = AppSizes.fontSm;
  static const FontWeight offDayFontWeight = FontWeight.w400;
  static const FontStyle offDayFontStyle = FontStyle.italic;

  // Empty State
  static const Color emptyStateColor = AppColors.textSecondary;
  static const Color emptyStateColorDark = AppColors.textSecondaryDark;
  static const double emptyStateFontSize = AppSizes.fontSm;

  // Time Scale (if with hours)
  static const Color timeScaleColor = AppColors.textTertiary;
  static const Color timeScaleColorDark = AppColors.textTertiaryDark;
  static const double timeScaleFontSize = AppSizes.fontXs;

  static const Color timeScaleDividerColor = AppColors.border;
  static const Color timeScaleDividerColorDark = AppColors.borderDark;

  // Scroll Indicators
  static const Color scrollIndicatorColor = AppColors.gold;
  static const Color scrollIndicatorColorDark = AppColors.gold;

  // Grid Lines
  static const Color gridLineColor = AppColors.border;
  static const Color gridLineColorDark = AppColors.borderDark;
  static const double gridLineHeight = AppSizes.borderSm;

  // Info Badge (shift count, hours)
  static const double badgeBorderRadius = AppSizes.radiusMd;
  static const double badgePaddingX = AppSizes.md;
  static const double badgePaddingY = AppSizes.sm;

  static const Color badgeBackgroundLight = AppColors.goldLight;
  static const Color badgeForegroundLight = AppColors.gold;

  static const Color badgeBackgroundDark = AppColors.accentDark;
  static const Color badgeForegroundDark = AppColors.white;

  static const double badgeFontSize = AppSizes.fontXs;
  static const FontWeight badgeFontWeight = FontWeight.w600;

  // Legend (if needed)
  static const Color legendTextColor = AppColors.textSecondary;
  static const Color legendTextColorDark = AppColors.textSecondaryDark;
  static const double legendFontSize = AppSizes.fontXs;

  // Shadow
  static const List<BoxShadow> elevation = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> elevationDark = [
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shiftShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shiftShadowDark = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  // Animations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeInOut;

  // Responsive
  static const double minDayColumnWidth = 80.0;
  static const double maxDayColumnWidth = 120.0;
}
