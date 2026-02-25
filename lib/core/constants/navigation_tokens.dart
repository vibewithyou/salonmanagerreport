import 'package:flutter/material.dart';

/// Navigation Component Design Tokens
/// Defines styling for left-side collapsible navigation component
/// Consistent with golden accent (#CC9933 / #D4A853), dark theme support,
/// and role-specific menu hierarchy.
///
/// Used in: All dashboard screens (Customer, Employee, Admin)
class NavigationTokens {
  // ============================================================================
  // NAVIGATION CONTAINER TOKENS
  // ============================================================================

  /// Width of expanded navigation sidebar (in pixels)
  static const double expandedWidth = 280.0;

  /// Width of collapsed navigation sidebar (in pixels)
  static const double collapsedWidth = 80.0;

  /// Smooth animation duration for expand/collapse transition
  static const Duration expandCollapseDuration = Duration(milliseconds: 300);

  /// Curve for expand/collapse animation
  static const Curve expandCollapseCurve = Curves.easeInOut;

  // Navigation Container - Light Theme
  static const Color containerBgLight = Color(0xFFFFFFFF);
  static const Color containerBorderLight = Color(0xFFE8DFD8);
  static const List<BoxShadow> containerShadowLight = [
    BoxShadow(
      color: Color(0x141A1816), // 8% opacity dark
      offset: Offset(2, 0),
      blurRadius: 12,
      spreadRadius: -2,
    ),
  ];

  // Navigation Container - Dark Theme
  static const Color containerBgDark = Color(0xFF121212);
  static const Color containerBorderDark = Color(0xFF262626);
  static const List<BoxShadow> containerShadowDark = [
    BoxShadow(
      color: Color(0xFF000000), // Pure black 30% opacity
      offset: Offset(2, 0),
      blurRadius: 16,
      spreadRadius: -4,
    ),
  ];

  /// Border width for navigation container
  static const double containerBorderWidth = 1.0;

  /// Border radius for navigation corners
  static const double containerBorderRadius = 0.0; // Full height, no corners

  // ============================================================================
  // NAVIGATION ITEM TOKENS
  // ============================================================================

  /// Height of each navigation menu item
  static const double itemHeight = 56.0;

  /// Padding for navigation items (when expanded)
  static const EdgeInsets itemPaddingExpanded = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  /// Padding for navigation items (when collapsed)
  static const EdgeInsets itemPaddingCollapsed = EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 12.0,
  );

  // Item Text - Light Theme
  static const Color itemTextLight = Color(0xFF2B2520); // Foreground
  static const Color itemTextSecondaryLight = Color(0xFF736B66); // Text secondary
  static const double itemTextFontSize = 14.0;
  static const FontWeight itemTextFontWeight = FontWeight.w500;

  // Item Text - Dark Theme
  static const Color itemTextDark = Color(0xFFF5EDD8); // Foreground dark
  static const Color itemTextSecondaryDark = Color(0xFF999999); // Text tertiary dark
  static const double itemTextLineHeight = 1.4;
  static const String itemTextFontFamily = 'Inter';

  // Item Text Spacing
  static const double itemTextLetterSpacing = 0.1;

  // ============================================================================
  // ITEM STATE TOKENS (Default, Hover, Active, Disabled)
  // ============================================================================

  // Default State
  static const Color itemDefaultBgLight = Color(0xFFFFFFFF);
  static const Color itemDefaultBgDark = Color(0xFF121212);
  static const Color itemDefaultBorderLight = Colors.transparent;
  static const Color itemDefaultBorderDark = Colors.transparent;
  static const List<BoxShadow> itemDefaultShadow = [];

  // Hover State
  static const Color itemHoverBgLight = Color(0xFFF7F3F0); // Muted background
  static const Color itemHoverBgDark = Color(0xFF262626); // Slightly lighter
  static const Color itemHoverTextLight = Color(0xFF2B2520); // Foreground
  static const Color itemHoverTextDark = Color(0xFFD4A853); // Gold accent
  static const List<BoxShadow> itemHoverShadow = [
    BoxShadow(
      color: Color(0x0A000000), // Subtle shadow on hover
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
  static const double itemHoverBorderRadius = 12.0;

  // Active State
  static const Color itemActiveBgLight = Color(0xFFF5EDD8); // Gold light
  static const Color itemActiveBgDark = Color(0xFF2D2416); // Dark gold tint
  static const Color itemActiveTextLight = Color(0xFFB88D3A); // Gold dark
  static const Color itemActiveTextDark = Color(0xFFD4A853); // Gold accent
  static const Color itemActiveBorderLight = Color(0xFFD4A853); // Gold
  static const Color itemActiveBorderDark = Color(0xFFD4A853); // Gold
  static const double itemActiveBorderWidth = 2.0;
  static const double itemActiveBorderRadius = 12.0;
  static const List<BoxShadow> itemActiveShadow = [
    BoxShadow(
      color: Color(0x1FD4A853), // Gold 12% opacity
      offset: Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  // Disabled State
  static const Color itemDisabledBgLight = Color(0xFFFFFFFF);
  static const Color itemDisabledBgDark = Color(0xFF121212);
  static const Color itemDisabledTextLight = Color(0xFFD1D5DB); // Text disabled
  static const Color itemDisabledTextDark = Color(0xFF666666); // Text disabled dark
  static const double itemDisabledOpacity = 0.5;

  // Focus State (for keyboard navigation)
  static const Color itemFocusBorderLight = Color(0xFFD4A853); // Gold
  static const Color itemFocusBorderDark = Color(0xFFD4A853); // Gold
  static const double itemFocusBorderWidth = 2.0;
  static const List<BoxShadow> itemFocusShadow = [
    BoxShadow(
      color: Color(0x33D4A853), // Gold 20% opacity
      offset: Offset(0, 0),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  // ============================================================================
  // NAVIGATION ICON TOKENS
  // ============================================================================

  /// Icon size for navigation items (when expanded)
  static const double iconSizeExpanded = 24.0;

  /// Icon size for navigation items (when collapsed)
  static const double iconSizeCollapsed = 24.0;

  /// Icon size for section headers/badges
  static const double iconSizeBadge = 16.0;

  /// Spacing between icon and text label (when expanded)
  static const double iconTextSpacing = 12.0;

  // Icon Colors - Light Theme
  static const Color iconColorDefaultLight = Color(0xFF736B66); // Text secondary
  static const Color iconColorActiveLight = Color(0xFFB88D3A); // Gold dark
  static const Color iconColorHoverLight = Color(0xFF2B2520); // Foreground

  // Icon Colors - Dark Theme
  static const Color iconColorDefaultDark = Color(0xFF999999); // Text tertiary
  static const Color iconColorActiveDark = Color(0xFFD4A853); // Gold
  static const Color iconColorHoverDark = Color(0xFFF5EDD8); // Foreground dark

  /// Icon weight/stroke width (if using custom icons)
  static const double iconStrokeWidth = 2.0;

  // ============================================================================
  // COLLAPSE BUTTON TOKENS
  // ============================================================================

  /// Height of collapse/expand button
  static const double collapseButtonHeight = 48.0;

  /// Width of collapse/expand button
  static const double collapseButtonWidth = 48.0;

  /// Button icon size (chevron/arrow)
  static const double collapseButtonIconSize = 20.0;

  /// Padding inside collapse button
  static const EdgeInsets collapseButtonPadding = EdgeInsets.all(12.0);

  /// Border radius for collapse button
  static const double collapseButtonBorderRadius = 8.0;

  // Button Background Colors - Light Theme
  static const Color collapseButtonBgLight = Color(0xFFF7F3F0); // Muted
  static const Color collapseButtonBgHoverLight = Color(0xFFE8DFD8); // Slightly darker

  // Button Background Colors - Dark Theme
  static const Color collapseButtonBgDark = Color(0xFF262626); // Border color
  static const Color collapseButtonBgHoverDark = Color(0xFF3A3A3A); // Slightly lighter

  // Button Icon Colors - Light Theme
  static const Color collapseButtonIconLight = Color(0xFF736B66); // Text secondary
  static const Color collapseButtonIconHoverLight = Color(0xFF2B2520); // Foreground

  // Button Icon Colors - Dark Theme
  static const Color collapseButtonIconDark = Color(0xFF999999); // Text tertiary
  static const Color collapseButtonIconHoverDark = Color(0xFFD4A853); // Gold

  /// Animation duration for collapse button rotation
  static const Duration collapseButtonAnimationDuration =
      Duration(milliseconds: 300);

  /// Animation curve for collapse button rotation
  static const Curve collapseButtonAnimationCurve = Curves.easeInOut;

  // ============================================================================
  // NAVIGATION HEADER/LOGO AREA TOKENS
  // ============================================================================

  /// Height of header area (logo + brand area)
  static const double headerHeight = 80.0;

  /// Padding for header content
  static const EdgeInsets headerPaddingExpanded = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 20.0,
  );

  /// Padding for header content (when collapsed)
  static const EdgeInsets headerPaddingCollapsed = EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 20.0,
  );

  /// Logo size (when expanded)
  static const double logoSizeExpanded = 32.0;

  /// Logo size (when collapsed)
  static const double logoSizeCollapsed = 32.0;

  /// Border between header and menu items
  static const Color headerBorderLight = Color(0xFFE8DFD8);
  static const Color headerBorderDark = Color(0xFF262626);
  static const double headerBorderWidth = 1.0;

  // Header Text - Light Theme
  static const Color headerTextLight = Color(0xFF2B2520); // Foreground
  static const Color headerTextSecondaryLight = Color(0xFF736B66); // Text secondary
  static const double headerTextFontSize = 16.0;
  static const FontWeight headerTextFontWeight = FontWeight.w600;

  // Header Text - Dark Theme
  static const Color headerTextDark = Color(0xFFF5EDD8); // Foreground dark
  static const Color headerTextSecondaryDark = Color(0xFF999999); // Text tertiary

  // Header Background
  static const Color headerBgLight = Color(0xFFFFFFFF);
  static const Color headerBgDark = Color(0xFF121212);

  /// Spacing between logo and brand name (when expanded)
  static const double headerLogoTextSpacing = 12.0;

  // ============================================================================
  // SECTION HEADER TOKENS (Group headers like "Menu", "Settings")
  // ============================================================================

  /// Height of section header
  static const double sectionHeaderHeight = 44.0;

  /// Padding for section headers
  static const EdgeInsets sectionHeaderPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  // Section Header Text Colors - Light Theme
  static const Color sectionHeaderTextLight = Color(0xFF736B66); // Text secondary
  static const double sectionHeaderFontSize = 12.0;
  static const FontWeight sectionHeaderFontWeight = FontWeight.w600;
  static const double sectionHeaderLetterSpacing = 0.5;
  static const TextTransform sectionHeaderTransform = TextTransform.uppercase;

  // Section Header Text Colors - Dark Theme
  static const Color sectionHeaderTextDark = Color(0xFF999999); // Text tertiary

  // Section Header Background
  static const Color sectionHeaderBgLight = Color(0xFFFAF7F5); // Background
  static const Color sectionHeaderBgDark = Color(0xFF0A0A0A); // Background dark

  /// Section divider spacing
  static const double sectionSpacing = 8.0;

  // ============================================================================
  // BADGE/NOTIFICATION TOKENS
  // ============================================================================

  /// Badge container size (for notification/unread counts)
  static const double badgeSize = 20.0;

  /// Badge text font size
  static const double badgeFontSize = 10.0;
  static const FontWeight badgeFontWeight = FontWeight.w600;

  /// Badge background color (notification)
  static const Color badgeBgNotification = Color(0xFFEF4444); // Error/Red

  /// Badge background color (unread)
  static const Color badgeBgUnread = Color(0xFFD4A853); // Gold

  /// Badge text color
  static const Color badgeTextColor = Color(0xFFFFFFFF); // White

  /// Badge border radius (circular)
  static const double badgeBorderRadius = 10.0;

  /// Padding inside badge
  static const EdgeInsets badgePadding = EdgeInsets.symmetric(
    horizontal: 6.0,
    vertical: 2.0,
  );

  // ============================================================================
  // SUB-MENU/NESTED MENU TOKENS
  // ============================================================================

  /// Left padding for nested menu items (indentation)
  static const double submenuIndentation = 24.0;

  /// Height of submenu item
  static const double submenuItemHeight = 44.0;

  /// Font size for submenu items
  static const double submenuFontSize = 13.0;
  static const FontWeight submenuFontWeight = FontWeight.w400;

  // Submenu Colors - Light Theme
  static const Color submenuTextLight = Color(0xFF736B66); // Text secondary
  static const Color submenuTextActiveLight = Color(0xFFB88D3A); // Gold dark
  static const Color submenuBgLight = Color(0xFFFFFFFF);
  static const Color submenuBgHoverLight = Color(0xFFFAF7F5); // Background light

  // Submenu Colors - Dark Theme
  static const Color submenuTextDark = Color(0xFF999999); // Text tertiary
  static const Color submenuTextActiveDark = Color(0xFFD4A853); // Gold
  static const Color submenuBgDark = Color(0xFF121212);
  static const Color submenuBgHoverDark = Color(0xFF1A1A1A); // Slightly lighter

  /// Expand/collapse animation for submenu
  static const Duration submenuAnimationDuration = Duration(milliseconds: 200);

  // ============================================================================
  // SCROLLBAR TOKENS
  // ============================================================================

  /// Scrollbar thickness (when visible)
  static const double scrollbarThickness = 6.0;

  /// Scrollbar color - Light Theme
  static const Color scrollbarColorLight = Color(0xFFD1D5DB); // Gray 300
  static const Color scrollbarColorHoverLight = Color(0xFF9CA3AF); // Gray 400

  /// Scrollbar color - Dark Theme
  static const Color scrollbarColorDark = Color(0xFF404040); // Gray 700
  static const Color scrollbarColorHoverDark = Color(0xFF626262); // Gray 600

  /// Scrollbar border radius
  static const double scrollbarBorderRadius = 3.0;

  // ============================================================================
  // ROLE-SPECIFIC TOKENS
  // ============================================================================

  /// Menu items visibility for each role
  static const Map<String, List<String>> roleMenuItems = {
    'customer': [
      'dashboard',
      'bookings',
      'appointments',
      'messages',
      'profile',
      'settings',
    ],
    'employee': [
      'dashboard',
      'schedule',
      'clients',
      'gallery',
      'messages',
      'profile',
      'settings',
    ],
    'stylist': [
      'dashboard',
      'schedule',
      'clients',
      'gallery',
      'services',
      'messages',
      'profile',
      'settings',
    ],
    'manager': [
      'dashboard',
      'team',
      'schedule',
      'clients',
      'reports',
      'inventory',
      'gallery',
      'chat',
      'settings',
    ],
    'admin': [
      'dashboard',
      'users',
      'team',
      'schedule',
      'clients',
      'reports',
      'inventory',
      'gallery',
      'chat',
      'salon_settings',
      'system_settings',
    ],
    'owner': [
      'dashboard',
      'overview',
      'users',
      'team',
      'schedule',
      'clients',
      'reports',
      'inventory',
      'gallery',
      'chat',
      'salon_settings',
      'system_settings',
      'billing',
    ],
  };

  // ============================================================================
  // ANIMATION TOKENS
  // ============================================================================

  /// General menu item animation duration
  static const Duration itemAnimationDuration = Duration(milliseconds: 150);

  /// Menu item animation curve
  static const Curve itemAnimationCurve = Curves.easeInOut;

  /// Hover effect animation duration
  static const Duration hoverAnimationDuration = Duration(milliseconds: 200);

  /// Active state animation duration
  static const Duration activeAnimationDuration = Duration(milliseconds: 250);

  /// Page transition animation when navigating
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);

  /// Page transition curve
  static const Curve pageTransitionCurve = Curves.easeInOut;

  // ============================================================================
  // RESPONSIVE BREAKPOINTS
  // ============================================================================

  /// Minimum width before navigation collapses on mobile
  static const double breakpointMobile = 480.0;

  /// Minimum width before navigation collapses on tablet
  static const double breakpointTablet = 768.0;

  /// Minimum width for desktop layout
  static const double breakpointDesktop = 1024.0;

  /// Auto-collapse navigation on screens smaller than this
  static const double autoCollapseWidth = 768.0;

  // ============================================================================
  // ACCESSIBILITY & INTERACTION TOKENS
  // ============================================================================

  /// Minimum touch target size for menu items (WCAG AA compliance)
  static const double minTouchTargetSize = 44.0;

  /// Focus outline width (for keyboard navigation)
  static const double focusOutlineWidth = 2.0;

  /// Focus outline offset
  static const double focusOutlineOffset = 2.0;

  /// Ripple effect color (for Material-style feedback)
  static const Color rippleColorLight = Color(0x1FD4A853); // Gold 12% opacity
  static const Color rippleColorDark = Color(0x33D4A853); // Gold 20% opacity

  /// High contrast mode border width
  static const double highContrastBorderWidth = 2.0;
}

/// Text Transform enum for section headers
enum TextTransform {
  none,
  uppercase,
  lowercase,
  capitalize,
}
