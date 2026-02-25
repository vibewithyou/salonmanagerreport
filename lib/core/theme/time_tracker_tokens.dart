import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Design Tokens für TimeTrackerWidget
/// Clock-In/Out Button, aktuelle Zeit, Pause-Status
class TimeTrackerTokens {
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
  static const double sectionSpacing = AppSizes.xl;
  static const double rowSpacing = AppSizes.md;
  static const double buttonSpacing = AppSizes.lg;

  // Time Display Section
  static const Color timeHeaderColor = AppColors.textSecondary;
  static const Color timeHeaderColorDark = AppColors.textSecondaryDark;
  static const double timeHeaderFontSize = AppSizes.fontSm;
  static const FontWeight timeHeaderFontWeight = FontWeight.w500;

  static const Color timeDisplayColor = AppColors.gold;
  static const Color timeDisplayColorDark = AppColors.gold;
  static const double timeDisplayFontSize = 48.0;
  static const FontWeight timeDisplayFontWeight = FontWeight.bold;

  static const Color dateDisplayColor = AppColors.textSecondary;
  static const Color dateDisplayColorDark = AppColors.textSecondaryDark;
  static const double dateDisplayFontSize = AppSizes.fontSm;

  // Clock Icon
  static const double clockIconSize = 32.0;
  static const Color clockIconColor = AppColors.gold;
  static const Color clockIconColorDark = AppColors.gold;

  // Status Section
  static const Color statusLabelColor = AppColors.textSecondary;
  static const Color statusLabelColorDark = AppColors.textSecondaryDark;
  static const double statusLabelFontSize = AppSizes.fontSm;

  // Status Badge
  static const double statusBadgePaddingX = AppSizes.lg;
  static const double statusBadgePaddingY = AppSizes.md;
  static const double statusBadgeBorderRadius = AppSizes.radiusMd;

  // Status Colors
  static const Color statusClockOutBackground = AppColors.gray100;
  static const Color statusClockOutForeground = AppColors.textSecondary;

  static const Color statusClockInBackground = AppColors.sage;
  static const Color statusClockInForeground = AppColors.white;

  static const Color statusPausedBackground = AppColors.warning;
  static const Color statusPausedForeground = AppColors.black;

  static const Color statusClockOutBackgroundDark = AppColors.muted;
  static const Color statusClockOutForegroundDark = AppColors.textSecondaryDark;

  static const Color statusClockInBackgroundDark = AppColors.sage;
  static const Color statusClockInForegroundDark = AppColors.white;

  static const double statusFontSize = AppSizes.fontMd;
  static const FontWeight statusFontWeight = FontWeight.w600;

  // Clock In/Out Button
  static const double buttonHeight = AppSizes.buttonHeightLg;
  static const double buttonBorderRadius = AppSizes.radiusLg;
  static const double buttonElevation = 0.0;

  static const Color buttonClockInBackground = AppColors.sage;
  static const Color buttonClockInForeground = AppColors.white;

  static const Color buttonClockOutBackground = AppColors.primary;
  static const Color buttonClockOutForeground = AppColors.white;

  static const Color buttonDisabledBackground = AppColors.gray200;
  static const Color buttonDisabledForeground = AppColors.textDisabled;

  static const Color buttonDisabledBackgroundDark = AppColors.muted;
  static const Color buttonDisabledForegroundDark = AppColors.textDisabledDark;

  static const double buttonFontSize = AppSizes.fontLg;
  static const FontWeight buttonFontWeight = FontWeight.w600;
  static const double buttonIconSize = AppSizes.iconMd;

  // Pause Controls Section
  static const Color pauseLabelColor = AppColors.textSecondary;
  static const Color pauseLabelColorDark = AppColors.textSecondaryDark;
  static const double pauseLabelFontSize = AppSizes.fontSm;

  // Pause Button
  static const double pauseButtonHeight = AppSizes.buttonHeightMd;
  static const double pauseButtonBorderRadius = AppSizes.radiusMd;

  static const Color pauseButtonBackground = AppColors.warning;
  static const Color pauseButtonForeground = AppColors.black;

  static const Color resumeButtonBackground = AppColors.sage;
  static const Color resumeButtonForeground = AppColors.white;

  static const Color pauseButtonDisabledBackground = AppColors.gray200;
  static const Color pauseButtonDisabledForeground = AppColors.textDisabled;

  static const double pauseButtonFontSize = AppSizes.fontMd;
  static const FontWeight pauseButtonFontWeight = FontWeight.w600;
  static const double pauseButtonIconSize = AppSizes.iconSm;

  // Pause Duration Display
  static const Color pauseDurationColor = AppColors.warning;
  static const Color pauseDurationColorDark = AppColors.warning;
  static const double pauseDurationFontSize = AppSizes.fontMd;
  static const FontWeight pauseDurationFontWeight = FontWeight.w600;

  // Info Text
  static const Color infoTextColor = AppColors.textTertiary;
  static const Color infoTextColorDark = AppColors.textTertiaryDark;
  static const double infoTextFontSize = AppSizes.fontXs;

  // Divider
  static const Color dividerColor = AppColors.border;
  static const Color dividerColorDark = AppColors.borderDark;
  static const double dividerHeight = AppSizes.dividerHeight;

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

  // Animations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeInOut;
}
