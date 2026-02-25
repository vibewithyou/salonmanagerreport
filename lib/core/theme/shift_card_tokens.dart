import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Design Tokens für ShiftCard Widget
/// Zeigt Schicht-Details: Start, Ende, Pause, Status
class ShiftCardTokens {
  // Container Styling
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
  static const double rowSpacing = AppSizes.md;
  static const double columnSpacing = AppSizes.lg;
  static const double timeBlockSpacing = AppSizes.md;

  // Header Section
  static const Color headerTextColor = AppColors.foreground;
  static const Color headerTextColorDark = AppColors.foregroundDark;
  static const double headerFontSize = AppSizes.fontLg;
  static const FontWeight headerFontWeight = FontWeight.w600;

  // Time Display
  static const Color timeDisplayColor = AppColors.gold;
  static const Color timeDisplayColorDark = AppColors.gold;
  static const double timeDisplayFontSize = AppSizes.fontXxl;
  static const FontWeight timeDisplayFontWeight = FontWeight.bold;

  // Status Badge
  static const double statusBadgePaddingX = AppSizes.lg;
  static const double statusBadgePaddingY = AppSizes.sm;
  static const double statusBadgeBorderRadius = AppSizes.radiusLg;

  // Status Colors
  static const Color statusActiveBackground = AppColors.sage;
  static const Color statusActiveForeground = AppColors.white;
  static const Color statusPausedBackground = AppColors.warning;
  static const Color statusPausedForeground = AppColors.black;
  static const Color statusCompletedBackground = AppColors.success;
  static const Color statusCompletedForeground = AppColors.white;
  static const Color statusCancelledBackground = AppColors.error;
  static const Color statusCancelledForeground = AppColors.white;

  static const double statusFontSize = AppSizes.fontSm;
  static const FontWeight statusFontWeight = FontWeight.w600;

  // Info Row (Start, End, Break)
  static const Color infoLabelColor = AppColors.textSecondary;
  static const Color infoLabelColorDark = AppColors.textSecondaryDark;
  static const double infoLabelFontSize = AppSizes.fontSm;
  static const FontWeight infoLabelFontWeight = FontWeight.w500;

  static const Color infoValueColor = AppColors.foreground;
  static const Color infoValueColorDark = AppColors.foregroundDark;
  static const double infoValueFontSize = AppSizes.fontMd;
  static const FontWeight infoValueFontWeight = FontWeight.w600;

  // Divider
  static const Color dividerColor = AppColors.border;
  static const Color dividerColorDark = AppColors.borderDark;
  static const double dividerHeight = AppSizes.dividerHeight;

  // Icon Styling
  static const double iconSize = AppSizes.iconMd;
  static const Color iconColor = AppColors.gold;
  static const Color iconColorDark = AppColors.gold;

  // Break Display
  static const Color breakLabelColor = AppColors.textSecondary;
  static const Color breakLabelColorDark = AppColors.textSecondaryDark;
  static const double breakLabelFontSize = AppSizes.fontSm;

  static const Color breakValueColor = AppColors.primary;
  static const Color breakValueColorDark = AppColors.gold;
  static const double breakValueFontSize = AppSizes.fontMd;
  static const FontWeight breakValueFontWeight = FontWeight.w600;

  // Duration Info
  static const Color durationTextColor = AppColors.textSecondary;
  static const Color durationTextColorDark = AppColors.textSecondaryDark;
  static const double durationFontSize = AppSizes.fontSm;

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
}
