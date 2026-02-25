# Quick Reference Card - Design Tokens

## 🎨 Employee Dashboard Tokens - Schnelle Übersicht

### Token Dateien
```dart
import '../theme/shift_card_tokens.dart';           // ShiftCard
import '../theme/time_tracker_tokens.dart';         // TimeTracker
import '../theme/customer_list_tokens.dart';        // CustomerList
import '../theme/schedule_calendar_tokens.dart';    // ScheduleCalendar
```

---

## 📏 Spacing (AppSizes)

```
xs   = 4.0      (Minimal gaps)
sm   = 8.0      (Small)
md   = 12.0     (Default)
lg   = 16.0     (Containers)
xl   = 20.0     (Large)
xxl  = 24.0     (2X)
xxxl = 32.0     (3X)
```

---

## 🎯 Colors (Quick Reference)

| Use | Color | Hex | Token |
|-----|-------|-----|-------|
| Accent | Gold | #D4A853 | `AppColors.gold` |
| Primary Action | Terracotta | #D4775E | `AppColors.primary` |
| Success/Clock-In | Sage | #7BA38C | `AppColors.sage` |
| Warning/Pending | Warning | #FECA57 | `AppColors.warning` |
| Error/Cancelled | Error | #EF4444 | `AppColors.error` |
| Completed | Success | #22C55E | `AppColors.success` |

---

## 🌓 Light/Dark Theme

```dart
final isDark = Theme.of(context).brightness == Brightness.dark;

// Light
color: isDark ? ColorDark : Color

// Example
bgColor: isDark
  ? ShiftCardTokens.containerBackgroundDark
  : ShiftCardTokens.containerBackgroundLight
```

---

## 📱 Status Badges (Shift Status)

```dart
// Active / Confirmed
background: Sage (#7BA38C)
foreground: White
text: "Aktiv" / "Bestätigt"

// Paused / Pending
background: Warning (#FECA57)
foreground: Black
text: "Pause" / "Ausstehend"

// Completed
background: Success (#22C55E)
foreground: White
text: "Fertig"

// Cancelled
background: Error (#EF4444)
foreground: White
text: "Abgesagt"
```

---

## 🔘 Button Colors

| Type | Background | Foreground | Size |
|------|-----------|-----------|------|
| Clock-In | Sage | White | 52px (buttonHeightLg) |
| Clock-Out | Primary | White | 52px |
| Pause | Warning | Black | 44px (buttonHeightMd) |
| Resume | Sage | White | 44px |
| Disabled | Gray200 | Gray | 44px |

---

## 📐 Common Components

### Container/Card
```dart
Card(
  color: isDark ? Tokens.containerBgDark : Tokens.containerBg,
  elevation: Tokens.containerElevation,        // 4.0
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(
      Tokens.containerBorderRadius              // 16.0
    ),
  ),
)
```

### Text
```dart
Text(
  'Label',
  style: TextStyle(
    color: Tokens.textColor,
    fontSize: Tokens.textFontSize,              // e.g., 14.0
    fontWeight: Tokens.textFontWeight,          // e.g., FontWeight.w600
  ),
)
```

### Badge/Chip
```dart
Container(
  padding: EdgeInsets.symmetric(
    horizontal: Tokens.badgePaddingX,
    vertical: Tokens.badgePaddingY,
  ),
  decoration: BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(
      Tokens.badgeBorderRadius
    ),
  ),
)
```

---

## ⏰ TimeDisplay Styling

```dart
// Large Time (09:00 - 17:00)
fontSize:   48px
fontWeight: Bold
color:      Gold (#D4A853)
fontFamily: Inter

// Duration (8 Stunden)
fontSize:   12px
fontWeight: Regular
color:      Secondary Text
```

---

## 🗓️ Calendar Elements

| Element | Size | Color | Radius |
|---------|------|-------|--------|
| Day Column | 80-120px | Light: Background | 12px |
| Shift Block | Variable | Status Color | 12px |
| Today Border | 2px | Gold | - |
| Today Bg | - | Gold Light | 12px |

---

## 🎭 Avatar (CustomerList)

```dart
size:            48x48
borderRadius:    16px
backgroundColor: Gold Light (#F5EDD8)
textColor:       Gold (#D4A853)
fontSize:        14px
fontWeight:      Bold
```

---

## 📊 Font Sizes

```
xs   = 10px     (Extra Small - Labels)
sm   = 12px     (Small)
md   = 14px     (Default)
lg   = 16px     (Large)
xl   = 18px     (Headlines)
xxl  = 20px     (Large Headlines)
xxxl = 24px     (Display)
2xl  = 28px     (Large Display)
3xl  = 32px     (Extra Large Display)
```

---

## 🎨 Typography

```
Headers:  Playfair Display (Bold, SemiBold)
Body:     Inter (Regular, Medium, SemiBold)

Display Large:    32px Playfair Bold
Headline Medium:  20px Playfair Bold
Title Large:      16px Inter SemiBold (600)
Body Medium:      14px Inter Regular (400)
Label Small:      10px Inter Medium (500)
```

---

## ✨ Animation Constants

```dart
// TimeTracker & ScheduleCalendar
duration: Duration(milliseconds: 300)
curve:    Curves.easeInOut

// CustomerList Hover
duration: Duration(milliseconds: 200)
curve:    Curves.easeInOut
```

---

## 🔍 Elevation/Shadow

```
Small:   2.0
Medium:  4.0   (Default Cards)
Large:   8.0
XLarge:  12.0
```

---

## 📦 Import Cheat Sheet

```dart
// All in one (if needed)
import '../theme/shift_card_tokens.dart';
import '../theme/time_tracker_tokens.dart';
import '../theme/customer_list_tokens.dart';
import '../theme/schedule_calendar_tokens.dart';

// Base colors & sizes
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
```

---

## 🚀 Quick Usage Pattern

```dart
@override
Widget build(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    padding: EdgeInsets.all(Tokens.paddingLg),
    decoration: BoxDecoration(
      color: isDark ? Tokens.bgDark : Tokens.bg,
      borderRadius: BorderRadius.circular(Tokens.borderRadius),
      boxShadow: isDark ? Tokens.shadowDark : Tokens.shadow,
    ),
    child: Text(
      'Content',
      style: TextStyle(
        color: isDark ? Tokens.textDark : Tokens.text,
        fontSize: Tokens.fontSize,
        fontWeight: Tokens.fontWeight,
      ),
    ),
  );
}
```

---

## 📝 Border Radius Reference

```
radiusXs   = 4px    (Minimal)
radiusSm   = 8px    (Small)
radiusMd   = 12px   (Medium - Day Columns)
radiusLg   = 16px   (Large - Containers)
radiusXl   = 20px   (Extra Large)
radiusFull = 999px  (Fully Rounded)
```

---

## 🎯 Status Colors - All Widgets

### ShiftCard Status
- Active → Sage
- Paused → Warning
- Completed → Success
- Cancelled → Error

### ScheduleCalendar Status
- Confirmed → Sage
- Pending → Warning
- Completed → Success
- Cancelled → Error

### TimeTracker Status
- ClockIn → Sage
- ClockOut → Primary
- Paused → Warning

---

## ❌ Häufige Fehler

```dart
// FALSCH ❌
Card(color: Colors.white)                 // Hard-coded
Text(style: TextStyle(fontSize: 16.0))   // Magic number
EdgeInsets.all(16.0)                      // Direct value

// RICHTIG ✓
Card(color: Tokens.containerBg)           // Token
Text(style: TextStyle(fontSize: Tokens.fontSize))  // Token
EdgeInsets.all(Tokens.paddingLg)         // Token
```

---

## 📚 Full Docs

- **Main**: `lib/core/theme/EMPLOYEE_WIDGETS_TOKENS.md`
- **Index**: `lib/core/theme/TOKEN_INDEX.md`
- **Guide**: `DESIGN_TOKENS_IMPLEMENTATION_GUIDE.md`
- **Example**: `lib/core/widgets/shift_card_example.dart`

---

**Print this card and keep it nearby! 🎨**

Last Updated: 2026-02-15
