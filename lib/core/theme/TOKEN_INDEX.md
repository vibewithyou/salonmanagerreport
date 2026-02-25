# Design Tokens Index

Schnelle Referenz für alle verfügbaren Design Tokens.

## Überblick

| Token-Datei | Widget | Purpose | Größe |
|------------|--------|---------|-------|
| **shift_card_tokens.dart** | ShiftCard | Schicht-Details Anzeige | 166 lines |
| **time_tracker_tokens.dart** | TimeTrackerWidget | Clock-In/Out System | 175 lines |
| **customer_list_tokens.dart** | CustomerListItem | Customer List Items | 184 lines |
| **schedule_calendar_tokens.dart** | ScheduleCalendar | Weekly Schedule View | 207 lines |

---

## Token Categories

### Container & Layout Tokens
```dart
// Alle Widgets
containerBorderRadius     // Ecken-Radius
containerElevation        // Schatten-Höhe
containerBg(Light/Dark)   // Hintergrund-Farbe
containerBorder(Light/Dark) // Border Farbe
containerBorderWidth      // Border Dicke
```

### Spacing Tokens
```dart
paddingXl    = 20.0
paddingLg    = 16.0
paddingMd    = 12.0
paddingSmall = 8.0

rowSpacing       // Horizontaler Abstand
columnSpacing    // Vertikaler Abstand
sectionSpacing   // Zwischen Sektionen
```

### Color Tokens
```dart
// Light Theme
Color[Type]Color       // z.B. textColor, buttonBackground

// Dark Theme
Color[Type]ColorDark   // z.B. textColorDark, buttonBackgroundDark

// Semantische Farben
statusActive/Paused/Completed/Cancelled
Background/Foreground
Primary/Secondary
```

### Typography Tokens
```dart
[Type]FontSize       // Größe (z.B. headerFontSize)
[Type]FontWeight     // Gewicht (z.B. headerFontWeight)
[Type]FontStyle      // Stil (z.B. italic für Off Days)
```

---

## Quick Access

### ShiftCardTokens
**Import**: `import '../theme/shift_card_tokens.dart';`

**Häufig genutzt**:
```dart
ShiftCardTokens.timeDisplayColor      // Gold (#D4A853)
ShiftCardTokens.statusActiveBackground // Sage (#7BA38C)
ShiftCardTokens.containerBorderRadius   // 16.0
ShiftCardTokens.paddingLg              // 16.0
```

### TimeTrackerTokens
**Import**: `import '../theme/time_tracker_tokens.dart';`

**Häufig genutzt**:
```dart
TimeTrackerTokens.buttonClockInBackground    // Sage (#7BA38C)
TimeTrackerTokens.buttonClockOutBackground   // Primary (#D4775E)
TimeTrackerTokens.timeDisplayColor           // Gold (#D4A853)
TimeTrackerTokens.animationDuration          // 300ms
```

### CustomerListTokens
**Import**: `import '../theme/customer_list_tokens.dart';`

**Häufig genutzt**:
```dart
CustomerListTokens.avatarSize              // 48.0
CustomerListTokens.frequencyBadgeBackground // Gold Light
CustomerListTokens.nameColor               // Foreground
CustomerListTokens.contactColor            // Secondary
```

### ScheduleCalendarTokens
**Import**: `import '../theme/schedule_calendar_tokens.dart';`

**Häufig genutzt**:
```dart
ScheduleCalendarTokens.shiftConfirmedBackground  // Sage
ScheduleCalendarTokens.todayBorderLight          // Gold
ScheduleCalendarTokens.dayColumnBorderRadius     // 12.0
ScheduleCalendarTokens.minDayColumnWidth         // 80.0
```

---

## Common Patterns

### Light/Dark Theme Check
```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
final color = isDark ? Tokens.colorDark : Tokens.color;
```

### Container Styling
```dart
Card(
  color: isDark ? Tokens.containerBackgroundDark : Tokens.containerBackgroundLight,
  elevation: Tokens.containerElevation,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Tokens.containerBorderRadius),
  ),
)
```

### Text Styling
```dart
Text(
  'Label',
  style: TextStyle(
    color: Tokens.textColor,
    fontSize: Tokens.textFontSize,
    fontWeight: Tokens.textFontWeight,
  ),
)
```

### Status Badge
```dart
Container(
  padding: EdgeInsets.symmetric(
    horizontal: Tokens.statusBadgePaddingX,
    vertical: Tokens.statusBadgePaddingY,
  ),
  decoration: BoxDecoration(
    color: statusColor,
    borderRadius: BorderRadius.circular(Tokens.statusBadgeBorderRadius),
  ),
)
```

---

## Color Reference

### Status Colors
```
Active     → Sage (#7BA38C) [success indicator]
Paused     → Warning (#FECA57) [caution indicator]
Completed  → Success (#22C55E) [positive indicator]
Cancelled  → Error (#EF4444) [error indicator]
```

### Primary Colors
```
Gold       → #D4A853 (Accent, Primary in Dark)
Primary    → #D4775E (Warm Terracotta)
Rose       → #D47B8E (Secondary Accent)
Sage       → #7BA38C (Positive/Confirm)
```

### Neutral Colors (Light)
```
Background → #FAF7F5 (Warm Beige)
Foreground → #2B2520 (Dark Brown)
Surface    → #FFFFFF (White)
Border     → #E8DFD8 (Light Border)
```

### Neutral Colors (Dark)
```
Background → #0A0A0A (Near Black)
Foreground → #F5EDD8 (Light Beige)
Surface    → #121212 (Dark Gray)
Border     → #262626 (Dark Border)
```

---

## Font Sizes Reference

```
xs   = 10px  (Extra Small)
sm   = 12px  (Small)
md   = 14px  (Medium - default)
lg   = 16px  (Large)
xl   = 18px  (Extra Large)
xxl  = 20px  (2X Large)
xxxl = 24px  (3X Large)
2xl  = 28px  (2XL)
3xl  = 32px  (3XL)
```

---

## Spacing Reference

```
xs   = 4.0   (Extra Small)
sm   = 8.0   (Small)
md   = 12.0  (Medium - default)
lg   = 16.0  (Large - container padding)
xl   = 20.0  (Extra Large)
xxl  = 24.0  (2X Large)
xxxl = 32.0  (3X Large)
```

---

## Border Radius Reference

```
radiusXs   = 4.0    (Extra Small)
radiusSm   = 8.0    (Small)
radiusMd   = 12.0   (Medium)
radiusLg   = 16.0   (Large - containers)
radiusXl   = 20.0   (Extra Large)
radiusFull = 999.0  (Fully rounded)
```

---

## Shadow/Elevation Reference

```
shadowElevationSm  = 2.0   (Small shadow)
shadowElevationMd  = 4.0   (Medium shadow)
shadowElevationLg  = 8.0   (Large shadow)
shadowElevationXl  = 12.0  (Extra large shadow)
```

---

## Example Widget Implementations

### ShiftCard - Basic
**File**: `lib/core/widgets/shift_card_example.dart`
```dart
ShiftCardExample(
  startTime: '09:00',
  endTime: '17:00',
  breakTime: '30 min',
  status: 'active',
)
```

---

## File Locations

```
lib/core/
├── theme/
│   ├── shift_card_tokens.dart
│   ├── time_tracker_tokens.dart
│   ├── customer_list_tokens.dart
│   ├── schedule_calendar_tokens.dart
│   ├── EMPLOYEE_WIDGETS_TOKENS.md        (Main Documentation)
│   └── TOKEN_INDEX.md                   (This File)
├── constants/
│   ├── app_colors.dart                  (Base Colors)
│   └── app_sizes.dart                   (Base Sizes)
└── widgets/
    └── shift_card_example.dart          (Example Implementation)
```

---

## Import Template

```dart
import 'package:flutter/material.dart';
import '../theme/shift_card_tokens.dart';
// OR
import '../theme/time_tracker_tokens.dart';
// OR
import '../theme/customer_list_tokens.dart';
// OR
import '../theme/schedule_calendar_tokens.dart';
```

---

## Best Practices Summary

✅ **DO**:
- Verwende Token-Konstanten für alle Design-Werte
- Unterstütze Light/Dark Themes mit `*Dark` Varianten
- Gruppiere semantisch verwandte Tokens
- Dokumentiere Custom-Tokens ausführlich

❌ **DON'T**:
- Hard-codiere Magic Numbers
- Verwende Color() direkt statt AppColors
- Ignoriere Theme-Unterstützung
- Dupliziere Design-Entscheidungen

---

## Maintenance

### Token Updates
Wenn ein Token geändert werden muss:
1. Ändere es an einer Stelle in der Token-Datei
2. Alle Widgets werden automatisch aktualisiert
3. Dokumentiere die Änderung mit Kommentar

### Neue Tokens Hinzufügen
1. Nutze bestehende Token als Template
2. Folge der Naming Convention: `purposePropertyTheme`
3. Dokumentiere Light/Dark Varianten
4. Aktualisiere diesen INDEX

---

## Support & Questions

Für Fragen zu den Tokens:
1. Siehe EMPLOYEE_WIDGETS_TOKENS.md für ausführliche Dokumentation
2. Überprüfe shift_card_example.dart für Verwendungsbeispiele
3. Nutze diese INDEX-Datei für schnelle Referenz

---

**Zuletzt aktualisiert**: 2026-02-15
**Design System**: Material 3 + SalonManager Branding
**Status**: Production Ready ✓
