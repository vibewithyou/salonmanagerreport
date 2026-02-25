# Employee Dashboard Design Tokens

Diese Dokumentation beschreibt die neu erstellten Design Token-Dateien für Employee Dashboard Widgets im SalonManager Projekt.

## Überblick

Vier neue Token-Dateien wurden erstellt, um konsistente Design-Systeme für Employee Dashboard Widgets zu etablieren:

1. **shift_card_tokens.dart** - ShiftCard Widget
2. **time_tracker_tokens.dart** - TimeTrackerWidget
3. **customer_list_tokens.dart** - CustomerListItem Widget
4. **schedule_calendar_tokens.dart** - ScheduleCalendar Widget

## Token-Struktur

Alle Token-Dateien folgen dem gleichen Aufbau:

```dart
class WidgetNameTokens {
  // Container Styling
  static const double containerBorderRadius = ...;
  static const Color containerBackgroundLight = ...;
  static const Color containerBackgroundDark = ...;

  // Padding & Spacing
  static const double paddingLg = AppSizes.lg;

  // Colors (Light/Dark Theme)
  static const Color textColor = AppColors.foreground;
  static const Color textColorDark = AppColors.foregroundDark;

  // Typography
  static const double fontSize = AppSizes.fontMd;
  static const FontWeight fontWeight = FontWeight.w600;
}
```

## Design Principles

### Brand Identity
- **Farbe Golden (#CC9933)**: Primäre Akzentfarbe für Highlights und wichtige Elemente
- **Fonts**: Inter (Body), Playfair Display (Headers)
- **Theme**: Material 3 mit Dark Theme Support

### Spacing System (App Sizes)
- `xs = 4.0`   - Minimal spacing
- `sm = 8.0`   - Small spacing
- `md = 12.0`  - Medium spacing
- `lg = 16.0`  - Large spacing
- `xl = 20.0`  - Extra large spacing
- `xxl = 24.0` - Double extra large

### Color Palette
- **Primary**: Warm Terracotta/Coral (#D4775E)
- **Gold**: #D4A853 (Accent)
- **Rose**: #D47B8E (Secondary accent)
- **Sage**: #7BA38C (Success/Positive)
- **Backgrounds**: Light: #FAF7F5, Dark: #0A0A0A
- **Text**: Foreground: #2B2520, Secondary: #736B66

## Widget-spezifische Tokens

### 1. ShiftCardTokens (shift_card_tokens.dart)

**Zweck**: Zeigt Schicht-Details (Start, Ende, Pause, Status)

**Hauptelemente**:
- `timeDisplayColor`: Gold-Farbe für Start/End Zeiten
- `statusBadge*`: Verschiedene Status (Active, Paused, Completed, Cancelled)
- `infoRow*`: Label und Werte für Zeit-Informationen
- `breakDisplay*`: Break/Pause Anzeige mit spezifischen Farben

**Verwendungsbeispiel**:
```dart
Card(
  color: ShiftCardTokens.containerBackgroundLight,
  borderRadius: BorderRadius.circular(ShiftCardTokens.containerBorderRadius),
  child: Padding(
    padding: EdgeInsets.all(ShiftCardTokens.paddingLg),
    child: Text(
      '09:00 - 17:00',
      style: TextStyle(
        color: ShiftCardTokens.timeDisplayColor,
        fontSize: ShiftCardTokens.timeDisplayFontSize,
        fontWeight: ShiftCardTokens.timeDisplayFontWeight,
      ),
    ),
  ),
)
```

### 2. TimeTrackerTokens (time_tracker_tokens.dart)

**Zweck**: Clock-In/Out Button, aktuelle Zeit, Pause-Status

**Hauptelemente**:
- `timeDisplay*`: Große, fette Zeitanzeige in Gold
- `buttonClockIn/Out*`: Unterschiedliche Button-Farben für States
- `pauseButton*`: Pause/Resume Controls
- `animationDuration`: Übergang-Animationen

**Spezialfeatures**:
- Unterschiedliche Button-States (ClockIn, ClockOut, Paused)
- Status-Badges (ClockOut, ClockIn, Paused)
- Pause-Dauer Tracking

### 3. CustomerListTokens (customer_list_tokens.dart)

**Zweck**: Kunde in Recent Customers Liste

**Hauptelemente**:
- `avatar*`: Avatar-Styling mit Gold-Hintergrund
- `nameColor`: Primärer Text für Kundenname
- `frequencyBadge*`: Service-Häufigkeit Badge
- `ratingDisplay`: Star-Rating Anzeige
- `lastServiceInfo`: Letzte Service-Information

**Interaktionen**:
- `hoverDuration`: Smooth Hover-Effekte
- `elevationHover`: Erhöhter Shadow beim Hover

### 4. ScheduleCalendarTokens (schedule_calendar_tokens.dart)

**Zweck**: Wochenansicht mit Schichten

**Hauptelemente**:
- `dayColumn*`: Styling für Tages-Spalten
- `todayHighlight*`: Hervorhebung des heutigen Tages
- `shiftBlock*`: Individual Shift Blocks
- `shiftStatus*`: Verschiedene Schicht-Status (Confirmed, Pending, Cancelled, Completed)
- `dayNameColor`: Tagesname (Mo, Di, Mi, etc.)

**Responsive Features**:
- `minDayColumnWidth = 80.0`
- `maxDayColumnWidth = 120.0`
- Scrollable Wochenansicht

## Light/Dark Theme Support

Alle Widgets unterstützen vollständig sowohl Light als auch Dark Theme:

```dart
// Light Theme
static const Color textColor = AppColors.foreground;      // #2B2520
static const Color textColorDark = AppColors.foregroundDark; // #F5EDD8
```

Verwende die entsprechenden `*Dark` Konstanten beim Build mit Dark Theme:

```dart
final textColor = isDarkMode
  ? WidgetTokens.textColorDark
  : WidgetTokens.textColor;
```

## Konsistente Spacing

Alle Widgets verwenden das einheitliche Spacing-System:

```dart
// Container Padding
EdgeInsets.all(WidgetTokens.paddingLg)           // 16.0

// Internal Spacing
SizedBox(height: WidgetTokens.rowSpacing)        // 12.0

// Section Spacing
SizedBox(height: WidgetTokens.sectionSpacing)    // 20.0
```

## Verwendung in Widgets

### Beispiel: ShiftCard Implementation

```dart
import 'package:flutter/material.dart';
import '../core/theme/shift_card_tokens.dart';
import '../core/theme/app_colors.dart';

class ShiftCard extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String status; // 'active', 'paused', 'completed', 'cancelled'

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark
        ? ShiftCardTokens.containerBackgroundDark
        : ShiftCardTokens.containerBackgroundLight,
      borderRadius: BorderRadius.circular(ShiftCardTokens.containerBorderRadius),
      elevation: ShiftCardTokens.containerElevation,
      child: Padding(
        padding: EdgeInsets.all(ShiftCardTokens.paddingLg),
        child: Column(
          children: [
            // Time Display
            Text(
              '$startTime - $endTime',
              style: TextStyle(
                color: ShiftCardTokens.timeDisplayColor,
                fontSize: ShiftCardTokens.timeDisplayFontSize,
                fontWeight: ShiftCardTokens.timeDisplayFontWeight,
              ),
            ),
            SizedBox(height: ShiftCardTokens.rowSpacing),

            // Status Badge
            _buildStatusBadge(status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    late Color backgroundColor;
    late Color foregroundColor;

    switch (status) {
      case 'active':
        backgroundColor = ShiftCardTokens.statusActiveBackground;
        foregroundColor = ShiftCardTokens.statusActiveForeground;
        break;
      case 'paused':
        backgroundColor = ShiftCardTokens.statusPausedBackground;
        foregroundColor = ShiftCardTokens.statusPausedForeground;
        break;
      case 'completed':
        backgroundColor = ShiftCardTokens.statusCompletedBackground;
        foregroundColor = ShiftCardTokens.statusCompletedForeground;
        break;
      case 'cancelled':
        backgroundColor = ShiftCardTokens.statusCancelledBackground;
        foregroundColor = ShiftCardTokens.statusCancelledForeground;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ShiftCardTokens.statusBadgePaddingX,
        vertical: ShiftCardTokens.statusBadgePaddingY,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ShiftCardTokens.statusBadgeBorderRadius),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: foregroundColor,
          fontSize: ShiftCardTokens.statusFontSize,
          fontWeight: ShiftCardTokens.statusFontWeight,
        ),
      ),
    );
  }
}
```

## Best Practices

### 1. Theme Awareness
```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
final bgColor = isDark ? Tokens.colorDark : Tokens.color;
```

### 2. Consistent Spacing
```dart
// RICHTIG
EdgeInsets.only(left: Tokens.paddingLg, right: Tokens.paddingMd)

// FALSCH
EdgeInsets.only(left: 16.5, right: 12.7)
```

### 3. Typography Standards
```dart
// RICHTIG
TextStyle(
  fontSize: ShiftCardTokens.timeDisplayFontSize,
  fontWeight: ShiftCardTokens.timeDisplayFontWeight,
)

// FALSCH
TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
)
```

### 4. Color Semantics
```dart
// RICHTIG - Gold für Accent
color: ShiftCardTokens.timeDisplayColor  // AppColors.gold

// FALSCH
color: Color(0xFFD4A853)  // Direct hex
```

## Migration Checklist für neue Widgets

Bei der Implementierung neuer Widgets:

- [ ] Token-Datei erstellen (`widget_name_tokens.dart`)
- [ ] Light/Dark Theme Farben definieren
- [ ] Spacing konstant mit AppSizes verwenden
- [ ] Status-Varianten dokumentieren
- [ ] Beispiel-Implementierung schreiben
- [ ] Tests mit Light/Dark Theme durchführen
- [ ] Shadow/Elevation Werte konsistent halten

## Dateistruktur

```
lib/core/theme/
├── app_theme.dart                    # Main theme definitions
├── app_styles.dart                   # Reusable text styles
├── shift_card_tokens.dart            # ShiftCard tokens
├── time_tracker_tokens.dart          # TimeTracker tokens
├── customer_list_tokens.dart         # CustomerList tokens
├── schedule_calendar_tokens.dart     # ScheduleCalendar tokens
└── EMPLOYEE_WIDGETS_TOKENS.md        # This documentation

lib/core/constants/
├── app_colors.dart                   # Color palette
└── app_sizes.dart                    # Spacing/sizing system
```

## Zukunfts-Roadmap

Potenzielle Erweiterungen:

- [ ] Animationen (transitions zwischen States)
- [ ] Responsive Breakpoints
- [ ] Accessibility Token (WCAG contrast ratios)
- [ ] Accessibility Considerations (Font sizes für a11y)
- [ ] Shared component library
- [ ] Token export zu Design-Tools (Figma, etc.)

## Kontakt & Feedback

Diese Tokens wurden designed, um konsistenz und wartbarkeit im Employee Dashboard zu gewährleisten.

Feedback und Verbesserungen willkommen!
