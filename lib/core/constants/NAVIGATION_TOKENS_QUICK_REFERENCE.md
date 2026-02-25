# Navigation Tokens Quick Reference Card

## Import Statement
```dart
import 'package:salonmanager/core/constants/navigation_tokens.dart';
```

## Container Dimensions
| Property | Value |
|----------|-------|
| Expanded Width | 280px |
| Collapsed Width | 80px |
| Container Border | 1px |
| Expand/Collapse Animation | 300ms (easeInOut) |

## Item Styling
| Property | Light Theme | Dark Theme |
|----------|-------------|-----------|
| Item Height | 56px | 56px |
| Default BG | #FFFFFF | #121212 |
| Hover BG | #F7F3F0 | #262626 |
| **Active BG** | **#F5EDD8** | **#2D2416** |
| **Active Text** | **#B88D3A** | **#D4A853** |
| Active Border | Gold (2px) | Gold (2px) |
| Disabled Opacity | 50% | 50% |

## Icon Sizing
| Icon Type | Expanded | Collapsed |
|-----------|----------|-----------|
| Menu Item | 24px | 24px |
| Badge | 16px | 16px |
| Collapse Button | 20px | 20px |

## Color Palette (Quick Look)

### Light Theme
```
Default Text: #2B2520
Secondary Text: #736B66
Active Text: #B88D3A (Gold Dark)
Background: #FFFFFF
Hover BG: #F7F3F0
```

### Dark Theme
```
Default Text: #F5EDD8
Secondary Text: #999999
Active Text: #D4A853 (Gold)
Background: #121212
Hover BG: #262626
```

## Header (Logo Area)
| Property | Value |
|----------|-------|
| Height | 80px |
| Logo Size | 32px |
| Border Below | 1px |
| Logo-to-Text Gap | 12px |

## Section Headers
| Property | Value |
|----------|-------|
| Height | 44px |
| Font Size | 12px (UPPERCASE) |
| Font Weight | 600 |
| Letter Spacing | 0.5px |

## Collapse Button
| Property | Value |
|----------|-------|
| Size | 48×48px |
| Border Radius | 8px |
| Icon Size | 20px |
| Animation | 300ms (easeInOut) |

## Badges (Notifications)
| Property | Value |
|----------|-------|
| Size | 20×20px |
| Notification Color | #EF4444 (Red) |
| Unread Color | #D4A853 (Gold) |
| Text Color | #FFFFFF (White) |

## Sub-Menu Items
| Property | Value |
|----------|-------|
| Left Indentation | 24px |
| Item Height | 44px |
| Font Size | 13px |
| Font Weight | 400 (Regular) |

## Animation Timings
| Animation | Duration | Curve |
|-----------|----------|-------|
| Expand/Collapse | 300ms | easeInOut |
| Item Interaction | 150ms | easeInOut |
| Hover Effect | 200ms | easeInOut |
| Active State | 250ms | easeInOut |
| Page Transition | 300ms | easeInOut |
| Sub-Menu | 200ms | easeInOut |

## Responsive Breakpoints
| Breakpoint | Width |
|-----------|-------|
| Mobile | ≤ 480px |
| Tablet | ≤ 768px |
| Desktop | ≥ 1024px |
| Auto-Collapse | ≤ 768px |

## Accessibility
| Property | Value |
|----------|-------|
| Min Touch Target | 44px (WCAG AA) |
| Focus Outline Width | 2px |
| Focus Outline Offset | 2px |
| High Contrast Border | 2px |

## Role-Based Menu Items

### Customer (6 items)
dashboard, bookings, appointments, messages, profile, settings

### Employee (7 items)
dashboard, schedule, clients, gallery, messages, profile, settings

### Stylist (8 items)
dashboard, schedule, clients, gallery, services, messages, profile, settings

### Manager (9 items)
dashboard, team, schedule, clients, reports, inventory, gallery, chat, settings

### Admin (11 items)
dashboard, users, team, schedule, clients, reports, inventory, gallery, chat, salon_settings, system_settings

### Owner (13 items)
dashboard, overview, users, team, schedule, clients, reports, inventory, gallery, chat, salon_settings, system_settings, billing

## Common Code Patterns

### Active Item Container
```dart
isActive
  ? NavigationTokens.itemActiveBgLight
  : NavigationTokens.itemDefaultBgLight
```

### Icon Color by State
```dart
// Light theme
isActive 
  ? NavigationTokens.iconColorActiveLight     // #B88D3A
  : NavigationTokens.iconColorDefaultLight    // #736B66

// Dark theme
isActive 
  ? NavigationTokens.iconColorActiveDark      // #D4A853
  : NavigationTokens.iconColorDefaultDark     // #999999
```

### Smooth Width Animation
```dart
AnimatedContainer(
  width: isExpanded 
    ? NavigationTokens.expandedWidth          // 280px
    : NavigationTokens.collapsedWidth,         // 80px
  duration: NavigationTokens.expandCollapseDuration,  // 300ms
  curve: NavigationTokens.expandCollapseCurve,        // easeInOut
  child: ...,
)
```

### Hover/Active Border
```dart
isActive
  ? Border(
      left: BorderSide(
        color: NavigationTokens.itemActiveBorderLight,
        width: NavigationTokens.itemActiveBorderWidth,  // 2px
      ),
    )
  : null
```

### Theme-Aware Text
```dart
Text(
  label,
  style: TextStyle(
    fontSize: NavigationTokens.itemTextFontSize,
    fontWeight: NavigationTokens.itemTextFontWeight,
    color: isDark 
      ? NavigationTokens.itemTextDark          // #F5EDD8
      : NavigationTokens.itemTextLight,        // #2B2520
  ),
)
```

### Focus State for Accessibility
```dart
FocusableActionDetector(
  onFocusChange: (hasFocus) => ...,
  child: Container(
    decoration: BoxDecoration(
      border: isFocused
        ? Border.all(
            color: NavigationTokens.itemFocusBorderLight,
            width: NavigationTokens.itemFocusBorderWidth,
          )
        : null,
    ),
    child: ...,
  ),
)
```

## Golden Color (#D4A853) Usage
- Active menu item background (light mode)
- Active menu item text (dark mode)
- Border for active items
- Collapse button icon on hover (dark mode)
- Badge for unread items
- Hover text color (dark theme)
- Glow effects for active states

## Shadow System
- **Container**: `containerShadowLight` / `containerShadowDark`
- **Item Hover**: `itemHoverShadow`
- **Item Active**: `itemActiveShadow`
- **Item Focus**: `itemFocusShadow`

## Scrollbar Configuration
| Property | Light | Dark |
|----------|-------|------|
| Thickness | 6px | 6px |
| Color | #D1D5DB | #404040 |
| Hover Color | #9CA3AF | #626262 |
| Border Radius | 3px | 3px |

## Testing Checklist
- [ ] Light theme colors match mockups
- [ ] Dark theme colors match mockups
- [ ] Animations are smooth (300ms expand/collapse)
- [ ] Touch targets are 44px+ (WCAG AA)
- [ ] Gold accent (#D4A853) appears on all active states
- [ ] Hover states provide visual feedback
- [ ] Focus states visible for keyboard navigation
- [ ] Role-based menus show correct items
- [ ] Responsive breakpoints trigger collapse
- [ ] Scrollbar appears on long menus
- [ ] Badges render correctly with counts
- [ ] Dark mode shadows have sufficient contrast

## Performance Tips
1. Use `AnimatedContainer` for width changes
2. Use `AnimatedRotation` for button rotation
3. Memoize theme values to avoid rebuilds
4. Use `const` for shadow definitions
5. Lazy-load sub-menu items when needed

## Accessibility Notes
- Minimum touch target: 44px (WCAG AA Level AA)
- Focus outline: 2px gold border
- Focus outline offset: 2px for visibility
- Color contrast ratios verified for all text states
- Keyboard navigation fully supported
- Screen reader labels required for icons
- ARIA labels for collapse button
- Role-based menu items filtered server-side

## Related Tokens Files
- `app_colors.dart` - Base palette
- `app_sizes.dart` - Spacing system
- `app_shadows.dart` - Shadow definitions
- `app_theme.dart` - Theme configuration

## Full Documentation
See `NAVIGATION_TOKENS_GUIDE.md` for complete implementation guide with code examples.
