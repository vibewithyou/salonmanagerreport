import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Design Tokens für CustomerListItem Widget
/// Kunde in Recent Customers Liste
class CustomerListTokens {
  // List Item Container
  static const double containerBorderRadius = AppSizes.radiusMd;
  static const double containerElevation = 0.0;
  static const Color containerBackgroundLight = AppColors.white;
  static const Color containerBackgroundDark = AppColors.surfaceDark;
  static const Color containerBorderLight = AppColors.border;
  static const Color containerBorderDark = AppColors.borderDark;
  static const double containerBorderWidth = AppSizes.borderSm;

  // Padding & Spacing
  static const double paddingHorizontal = AppSizes.lg;
  static const double paddingVertical = AppSizes.md;
  static const double paddingSmall = AppSizes.sm;
  static const double itemSpacing = AppSizes.md;
  static const double infoSpacing = AppSizes.sm;

  // Avatar
  static const double avatarSize = 48.0;
  static const double avatarBorderRadius = AppSizes.radiusLg;
  static const Color avatarBackgroundLight = AppColors.goldLight;
  static const Color avatarBackgroundDark = AppColors.accentDark;
  static const Color avatarTextColor = AppColors.gold;

  static const double avatarFontSize = AppSizes.fontMd;
  static const FontWeight avatarFontWeight = FontWeight.bold;

  // Customer Name
  static const Color nameColor = AppColors.foreground;
  static const Color nameColorDark = AppColors.foregroundDark;
  static const double nameFontSize = AppSizes.fontMd;
  static const FontWeight nameFontWeight = FontWeight.w600;

  // Customer Phone/Email
  static const Color contactColor = AppColors.textSecondary;
  static const Color contactColorDark = AppColors.textSecondaryDark;
  static const double contactFontSize = AppSizes.fontSm;
  static const FontWeight contactFontWeight = FontWeight.w400;

  // Last Service Info
  static const Color lastServiceLabelColor = AppColors.textTertiary;
  static const Color lastServiceLabelColorDark = AppColors.textTertiaryDark;
  static const double lastServiceLabelFontSize = AppSizes.fontXs;
  static const FontWeight lastServiceLabelFontWeight = FontWeight.w400;

  static const Color lastServiceValueColor = AppColors.textSecondary;
  static const Color lastServiceValueColorDark = AppColors.textSecondaryDark;
  static const double lastServiceValueFontSize = AppSizes.fontSm;
  static const FontWeight lastServiceValueFontWeight = FontWeight.w500;

  // Service Frequency Badge
  static const double frequencyBadgePaddingX = AppSizes.md;
  static const double frequencyBadgePaddingY = AppSizes.sm;
  static const double frequencyBadgeBorderRadius = AppSizes.radiusMd;

  static const Color frequencyBadgeBackgroundLight = AppColors.goldLight;
  static const Color frequencyBadgeForegroundLight = AppColors.gold;

  static const Color frequencyBadgeBackgroundDark = AppColors.accentDark;
  static const Color frequencyBadgeForegroundDark = AppColors.white;

  static const double frequencyBadgeFontSize = AppSizes.fontXs;
  static const FontWeight frequencyBadgeFontWeight = FontWeight.w600;

  // Rating Display
  static const double ratingIconSize = AppSizes.iconSm;
  static const Color ratingColor = AppColors.gold;
  static const Color ratingColorDark = AppColors.gold;

  static const Color ratingTextColor = AppColors.textSecondary;
  static const Color ratingTextColorDark = AppColors.textSecondaryDark;
  static const double ratingTextFontSize = AppSizes.fontSm;

  // Status Indicator
  static const double statusIndicatorSize = 8.0;
  static const double statusIndicatorBorderRadius = AppSizes.radiusFull;

  static const Color statusOnlineColor = AppColors.success;
  static const Color statusOfflineColor = AppColors.textTertiary;
  static const Color statusOfflineColorDark = AppColors.textTertiaryDark;

  // Actions Button
  static const double actionButtonSize = AppSizes.iconMd;
  static const Color actionButtonColor = AppColors.textSecondary;
  static const Color actionButtonColorDark = AppColors.textSecondaryDark;
  static const Color actionButtonHoverColor = AppColors.gold;
  static const Color actionButtonHoverColorDark = AppColors.gold;

  // Divider between items
  static const Color dividerColor = AppColors.border;
  static const Color dividerColorDark = AppColors.borderDark;
  static const double dividerHeight = AppSizes.dividerHeight;

  // Notes/Tags Area
  static const Color noteTextColor = AppColors.textTertiary;
  static const Color noteTextColorDark = AppColors.textTertiaryDark;
  static const double noteTextFontSize = AppSizes.fontXs;
  static const FontWeight noteTextFontWeight = FontWeight.w400;

  static const Color noteBackgroundLight = AppColors.muted;
  static const Color noteBackgroundDark = AppColors.mutedDark;

  static const double noteBorderRadius = AppSizes.radiusSm;
  static const double notePadding = AppSizes.sm;

  // Shadow
  static const List<BoxShadow> elevation = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> elevationDark = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> elevationHover = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> elevationHoverDark = [
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // Interactions
  static const Duration hoverDuration = Duration(milliseconds: 200);
  static const Curve hoverCurve = Curves.easeInOut;
}
