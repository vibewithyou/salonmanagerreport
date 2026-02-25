# Navigation Design Tokens Implementation Guide

## Overview

The `navigation_tokens.dart` file provides a complete design token specification for a left-side collapsible navigation component that works across all SalonManager dashboards (Customer, Employee, Admin). These tokens ensure consistent styling with the golden accent color (#D4A853), support dark theme, and include role-specific menu configurations.

## Token Categories

### 1. Navigation Container Tokens

Define the overall navigation sidebar styling.

**Light Theme:**
- Background: White (#FFFFFF)
- Border: Warm beige (#E8DFD8)
- Shadow: Subtle elevation effect

**Dark Theme:**
- Background: Dark surface (#121212)
- Border: Dark border (#262626)
- Shadow: Increased depth for contrast

**Dimensions:**
```dart
NavigationTokens.expandedWidth;      // 280.0 px
NavigationTokens.collapsedWidth;     // 80.0 px
NavigationTokens.containerBorderWidth;  // 1.0 px
```

**Animation:**
```dart
NavigationTokens.expandCollapseDuration;  // 300ms
NavigationTokens.expandCollapseCurve;     // easeInOut
```

### 2. Navigation Item Tokens

Control individual menu item appearance and spacing.

**Heights & Padding:**
```dart
NavigationTokens.itemHeight;           // 56.0 px
NavigationTokens.itemPaddingExpanded;  // Horizontal: 16px, Vertical: 12px
NavigationTokens.itemPaddingCollapsed; // Horizontal: 8px, Vertical: 12px
```

**Text Styling:**
- Font size: 14px
- Font weight: 500 (medium)
- Font family: Inter
- Line height: 1.4

### 3. Item State Tokens

Four primary states with distinct visual treatment:

#### Default State
- Background: White / Dark background
- Border: Transparent
- No shadow

#### Hover State
```dart
NavigationTokens.itemHoverBgLight;      // #F7F3F0
NavigationTokens.itemHoverBgDark;       // #262626
NavigationTokens.itemHoverTextDark;     // Gold (#D4A853)
NavigationTokens.itemHoverShadow;       // Subtle elevation
NavigationTokens.itemHoverBorderRadius; // 12.0 px
```

#### Active State
```dart
NavigationTokens.itemActiveBgLight;     // Gold light (#F5EDD8)
NavigationTokens.itemActiveBgDark;      // Dark gold tint (#2D2416)
NavigationTokens.itemActiveTextLight;   // Gold dark (#B88D3A)
NavigationTokens.itemActiveTextDark;    // Gold (#D4A853)
NavigationTokens.itemActiveBorderLight; // Gold (#D4A853)
NavigationTokens.itemActiveBorderWidth; // 2.0 px
NavigationTokens.itemActiveShadow;      // Gold glow
NavigationTokens.itemActiveBorderRadius; // 12.0 px
```

#### Disabled State
```dart
NavigationTokens.itemDisabledTextLight; // Gray (#D1D5DB)
NavigationTokens.itemDisabledTextDark;  // Dark gray (#666666)
NavigationTokens.itemDisabledOpacity;   // 0.5
```

#### Focus State (Keyboard Navigation)
```dart
NavigationTokens.itemFocusBorderLight;  // Gold (#D4A853)
NavigationTokens.itemFocusBorderDark;   // Gold (#D4A853)
NavigationTokens.itemFocusBorderWidth;  // 2.0 px
NavigationTokens.itemFocusShadow;       // Gold 20% opacity
```

### 4. Navigation Icon Tokens

Control icon sizing and color across states.

**Sizes:**
```dart
NavigationTokens.iconSizeExpanded;   // 24.0 px
NavigationTokens.iconSizeCollapsed;  // 24.0 px
NavigationTokens.iconSizeBadge;      // 16.0 px
NavigationTokens.iconTextSpacing;    // 12.0 px (gap between icon and label)
NavigationTokens.iconStrokeWidth;    // 2.0 px (for custom icon strokes)
```

**Colors - Light Theme:**
```dart
NavigationTokens.iconColorDefaultLight;  // #736B66 (text secondary)
NavigationTokens.iconColorActiveLight;   // #B88D3A (gold dark)
NavigationTokens.iconColorHoverLight;    // #2B2520 (foreground)
```

**Colors - Dark Theme:**
```dart
NavigationTokens.iconColorDefaultDark;   // #999999 (text tertiary)
NavigationTokens.iconColorActiveDark;    // #D4A853 (gold)
NavigationTokens.iconColorHoverDark;     // #F5EDD8 (foreground dark)
```

### 5. Collapse Button Tokens

Special button for expanding/collapsing sidebar.

**Dimensions:**
```dart
NavigationTokens.collapseButtonHeight;        // 48.0 px
NavigationTokens.collapseButtonWidth;         // 48.0 px
NavigationTokens.collapseButtonIconSize;      // 20.0 px
NavigationTokens.collapseButtonBorderRadius;  // 8.0 px
NavigationTokens.collapseButtonPadding;       // 12.0 px all sides
```

**Colors & Animation:**
```dart
NavigationTokens.collapseButtonBgLight;          // #F7F3F0
NavigationTokens.collapseButtonBgHoverLight;     // #E8DFD8
NavigationTokens.collapseButtonIconLight;        // #736B66
NavigationTokens.collapseButtonAnimationDuration; // 300ms
NavigationTokens.collapseButtonAnimationCurve;    // easeInOut
```

### 6. Header/Logo Area Tokens

Navigation header with branding.

**Dimensions:**
```dart
NavigationTokens.headerHeight;            // 80.0 px
NavigationTokens.headerPaddingExpanded;   // H: 16px, V: 20px
NavigationTokens.headerPaddingCollapsed;  // H: 8px, V: 20px
NavigationTokens.logoSizeExpanded;        // 32.0 px
NavigationTokens.logoSizeCollapsed;       // 32.0 px
NavigationTokens.headerLogoTextSpacing;   // 12.0 px
```

**Text & Colors:**
- Font size: 16px
- Font weight: 600 (semi-bold)
- Light text: #2B2520
- Dark text: #F5EDD8
- Border separating header from menu: 1px

### 7. Section Header Tokens

Group headers like "Menu", "Preferences", "Admin".

**Styling:**
```dart
NavigationTokens.sectionHeaderHeight;       // 44.0 px
NavigationTokens.sectionHeaderPadding;      // H: 16px, V: 12px
NavigationTokens.sectionHeaderFontSize;     // 12.0 px
NavigationTokens.sectionHeaderFontWeight;   // 600 (semi-bold)
NavigationTokens.sectionHeaderLetterSpacing; // 0.5 px
NavigationTokens.sectionHeaderTransform;    // UPPERCASE
NavigationTokens.sectionSpacing;            // 8.0 px (between sections)
```

**Colors:**
- Light: #736B66 (text secondary), BG: #FAF7F5
- Dark: #999999, BG: #0A0A0A

### 8. Badge/Notification Tokens

Display badges for notifications/unread counts.

```dart
NavigationTokens.badgeSize;           // 20.0 px
NavigationTokens.badgeFontSize;       // 10.0 px
NavigationTokens.badgeFontWeight;     // 600 (semi-bold)
NavigationTokens.badgeBgNotification; // #EF4444 (red)
NavigationTokens.badgeBgUnread;       // #D4A853 (gold)
NavigationTokens.badgeTextColor;      // #FFFFFF (white)
NavigationTokens.badgeBorderRadius;   // 10.0 px (circular)
NavigationTokens.badgePadding;        // H: 6px, V: 2px
```

### 9. Sub-Menu/Nested Tokens

Hierarchical menu structure.

```dart
NavigationTokens.submenuIndentation;        // 24.0 px (left padding)
NavigationTokens.submenuItemHeight;         // 44.0 px
NavigationTokens.submenuFontSize;           // 13.0 px
NavigationTokens.submenuFontWeight;         // 400 (regular)
NavigationTokens.submenuAnimationDuration;  // 200ms
```

**Colors:**
- Light: Text #736B66, Active #B88D3A, Hover BG #FAF7F5
- Dark: Text #999999, Active #D4A853, Hover BG #1A1A1A

### 10. Scrollbar Tokens

Scrollbar appearance for long menus.

```dart
NavigationTokens.scrollbarThickness;      // 6.0 px
NavigationTokens.scrollbarColorLight;     // #D1D5DB (gray 300)
NavigationTokens.scrollbarColorHoverLight; // #9CA3AF (gray 400)
NavigationTokens.scrollbarColorDark;      // #404040 (gray 700)
NavigationTokens.scrollbarBorderRadius;   // 3.0 px
```

### 11. Role-Specific Menu Items

Pre-configured menu structure per role.

```dart
NavigationTokens.roleMenuItems['customer'];  // 6 items
NavigationTokens.roleMenuItems['employee'];  // 7 items
NavigationTokens.roleMenuItems['stylist'];   // 8 items
NavigationTokens.roleMenuItems['manager'];   // 9 items
NavigationTokens.roleMenuItems['admin'];     // 11 items
NavigationTokens.roleMenuItems['owner'];     // 13 items
```

Example for customer:
```
- Dashboard
- Bookings
- Appointments
- Messages
- Profile
- Settings
```

### 12. Animation Tokens

Consistent animation timings across interactions.

```dart
NavigationTokens.expandCollapseDuration;    // 300ms
NavigationTokens.itemAnimationDuration;     // 150ms
NavigationTokens.hoverAnimationDuration;    // 200ms
NavigationTokens.activeAnimationDuration;   // 250ms
NavigationTokens.pageTransitionDuration;    // 300ms
NavigationTokens.submenuAnimationDuration;  // 200ms

NavigationTokens.expandCollapseCurve;       // easeInOut
NavigationTokens.itemAnimationCurve;        // easeInOut
NavigationTokens.pageTransitionCurve;       // easeInOut
```

### 13. Responsive Breakpoints

Screen size thresholds for layout changes.

```dart
NavigationTokens.breakpointMobile;      // 480.0 px
NavigationTokens.breakpointTablet;      // 768.0 px
NavigationTokens.breakpointDesktop;     // 1024.0 px
NavigationTokens.autoCollapseWidth;     // 768.0 px (auto-collapse threshold)
```

### 14. Accessibility & Interaction Tokens

WCAG AA compliance and keyboard navigation.

```dart
NavigationTokens.minTouchTargetSize;     // 44.0 px (WCAG AA)
NavigationTokens.focusOutlineWidth;      // 2.0 px
NavigationTokens.focusOutlineOffset;     // 2.0 px
NavigationTokens.rippleColorLight;       // Gold 12% opacity
NavigationTokens.rippleColorDark;        // Gold 20% opacity
NavigationTokens.highContrastBorderWidth; // 2.0 px
```

## Usage Examples

### Example 1: Navigation Item Container

```dart
Container(
  height: NavigationTokens.itemHeight,
  padding: isExpanded 
    ? NavigationTokens.itemPaddingExpanded
    : NavigationTokens.itemPaddingCollapsed,
  decoration: BoxDecoration(
    color: isActive 
      ? (isDark ? NavigationTokens.itemActiveBgDark : NavigationTokens.itemActiveBgLight)
      : (isDark ? NavigationTokens.itemDefaultBgDark : NavigationTokens.itemDefaultBgLight),
    border: isActive
      ? Border(
          left: BorderSide(
            color: NavigationTokens.itemActiveBorderLight,
            width: NavigationTokens.itemActiveBorderWidth,
          ),
        )
      : null,
    borderRadius: BorderRadius.circular(NavigationTokens.itemActiveBorderRadius),
    boxShadow: isActive ? NavigationTokens.itemActiveShadow : [],
  ),
  child: Row(
    children: [
      Icon(
        iconData,
        size: NavigationTokens.iconSizeExpanded,
        color: isActive
          ? (isDark ? NavigationTokens.iconColorActiveDark : NavigationTokens.iconColorActiveLight)
          : (isDark ? NavigationTokens.iconColorDefaultDark : NavigationTokens.iconColorDefaultLight),
      ),
      if (isExpanded) ...[
        SizedBox(width: NavigationTokens.iconTextSpacing),
        Text(
          label,
          style: TextStyle(
            fontSize: NavigationTokens.itemTextFontSize,
            fontWeight: NavigationTokens.itemTextFontWeight,
            fontFamily: NavigationTokens.itemTextFontFamily,
            color: isActive
              ? (isDark ? NavigationTokens.itemActiveTextDark : NavigationTokens.itemActiveTextLight)
              : (isDark ? NavigationTokens.itemTextDark : NavigationTokens.itemTextLight),
          ),
        ),
      ],
    ],
  ),
)
```

### Example 2: Collapse Button with Animation

```dart
AnimatedRotation(
  turns: isExpanded ? 0 : 0.5, // Rotate arrow when collapsed
  duration: NavigationTokens.collapseButtonAnimationDuration,
  curve: NavigationTokens.collapseButtonAnimationCurve,
  child: GestureDetector(
    onTap: toggleNavigation,
    child: Container(
      height: NavigationTokens.collapseButtonHeight,
      width: NavigationTokens.collapseButtonWidth,
      decoration: BoxDecoration(
        color: isHovered
          ? (isDark ? NavigationTokens.collapseButtonBgHoverDark : NavigationTokens.collapseButtonBgHoverLight)
          : (isDark ? NavigationTokens.collapseButtonBgDark : NavigationTokens.collapseButtonBgLight),
        borderRadius: BorderRadius.circular(NavigationTokens.collapseButtonBorderRadius),
      ),
      padding: NavigationTokens.collapseButtonPadding,
      child: Icon(
        Icons.chevron_left,
        size: NavigationTokens.collapseButtonIconSize,
        color: isHovered
          ? (isDark ? NavigationTokens.collapseButtonIconHoverDark : NavigationTokens.collapseButtonIconHoverLight)
          : (isDark ? NavigationTokens.collapseButtonIconDark : NavigationTokens.collapseButtonIconLight),
      ),
    ),
  ),
)
```

### Example 3: Section Header

```dart
Padding(
  padding: NavigationTokens.sectionHeaderPadding,
  child: Text(
    'MENU',
    style: TextStyle(
      fontSize: NavigationTokens.sectionHeaderFontSize,
      fontWeight: NavigationTokens.sectionHeaderFontWeight,
      letterSpacing: NavigationTokens.sectionHeaderLetterSpacing,
      color: isDark ? NavigationTokens.sectionHeaderTextDark : NavigationTokens.sectionHeaderTextLight,
    ),
  ),
)
```

### Example 4: Badge Notification

```dart
Positioned(
  right: 8.0,
  top: 4.0,
  child: Container(
    height: NavigationTokens.badgeSize,
    width: NavigationTokens.badgeSize,
    decoration: BoxDecoration(
      color: isNotification 
        ? NavigationTokens.badgeBgNotification
        : NavigationTokens.badgeBgUnread,
      borderRadius: BorderRadius.circular(NavigationTokens.badgeBorderRadius),
    ),
    alignment: Alignment.center,
    child: Text(
      count.toString(),
      style: TextStyle(
        fontSize: NavigationTokens.badgeFontSize,
        fontWeight: NavigationTokens.badgeFontWeight,
        color: NavigationTokens.badgeTextColor,
      ),
    ),
  ),
)
```

### Example 5: Navigation Container with Expand/Collapse Animation

```dart
AnimatedContainer(
  width: isExpanded 
    ? NavigationTokens.expandedWidth 
    : NavigationTokens.collapsedWidth,
  duration: NavigationTokens.expandCollapseDuration,
  curve: NavigationTokens.expandCollapseCurve,
  decoration: BoxDecoration(
    color: isDark ? NavigationTokens.containerBgDark : NavigationTokens.containerBgLight,
    border: Border(
      right: BorderSide(
        color: isDark ? NavigationTokens.containerBorderDark : NavigationTokens.containerBorderLight,
        width: NavigationTokens.containerBorderWidth,
      ),
    ),
    boxShadow: isDark 
      ? NavigationTokens.containerShadowDark 
      : NavigationTokens.containerShadowLight,
  ),
  child: CustomScrollView(
    slivers: [
      SliverAppBar(
        pinned: true,
        expandedHeight: NavigationTokens.headerHeight,
        // ... header content
      ),
      SliverList(
        delegate: SliverChildListDelegate(menuItems),
      ),
    ],
  ),
)
```

### Example 6: Keyboard Focus Navigation

```dart
FocusableActionDetector(
  onFocus: () => setState(() => _isFocused = true),
  onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
  child: Container(
    decoration: BoxDecoration(
      border: _isFocused
        ? Border.all(
            color: NavigationTokens.itemFocusBorderLight,
            width: NavigationTokens.itemFocusBorderWidth,
          )
        : null,
      borderRadius: BorderRadius.circular(NavigationTokens.itemActiveBorderRadius),
      boxShadow: _isFocused ? NavigationTokens.itemFocusShadow : [],
    ),
    child: MenuItem(),
  ),
)
```

## Implementation Checklist

- [ ] Import `navigation_tokens.dart` in navigation component
- [ ] Implement expand/collapse animation with `expandCollapseDuration` and `expandCollapseCurve`
- [ ] Apply role-specific menu items from `roleMenuItems` map
- [ ] Style navigation items with state tokens (default, hover, active, disabled)
- [ ] Add keyboard navigation focus states
- [ ] Implement smooth page transitions with `pageTransitionDuration`
- [ ] Test dark theme colors and shadows
- [ ] Verify touch target sizes meet WCAG AA (44px minimum)
- [ ] Implement scrollbar with `scrollbarThickness` and colors
- [ ] Add animation to collapse button rotation
- [ ] Test responsive behavior at breakpoints
- [ ] Verify accessibility with screen readers

## Design Rationale

These tokens follow Material Design 3 principles and SalonManager's existing design system:

1. **Golden Accent (#D4A853)** - Premium brand color used for active states and hover effects
2. **Smooth Animations** - 200-300ms durations for micro-interactions
3. **Role-Based Visibility** - Menu items automatically filtered by user role
4. **Dark Theme Support** - Complete color palette for both light and dark modes
5. **Accessibility** - WCAG AA compliant touch targets and focus indicators
6. **Responsive Design** - Auto-collapse behavior on tablets and below
7. **Premium Aesthetic** - Elegant spacing, typography, and shadows matching React app

## Related Files

- `app_colors.dart` - Base color palette
- `app_sizes.dart` - Spacing and sizing system
- `app_shadows.dart` - Shadow/elevation system
- `app_theme.dart` - Theme configuration
- `design_system_widgets.dart` - Reusable animation widgets
