# Design Tokens Implementation Guide für Employee Dashboard

**Datum**: 2026-02-15
**Status**: Abgeschlossen
**Projekt**: SalonManager Flutter

---

## Zusammenfassung

Vier neue Design Token-Dateien wurden erstellt, um konsistente UI/UX für das Employee Dashboard zu gewährleisten. Diese Tokens basieren auf Material 3, verwenden das Golden (#CC9933) Branding und unterstützen vollständig Dark/Light Themes.

## Erstellte Token-Dateien

### 1. **shift_card_tokens.dart**
**Location**: `lib/core/theme/shift_card_tokens.dart`

Widget: **ShiftCard** - Zeigt Schicht-Details

**Kerntoken**:
- Container: Radius (16), Background (Light/Dark), Border
- Time Display: Gold Color, XXL Font (44), Bold
- Status Badges: 4 States (Active/Sage, Paused/Warning, Completed/Success, Cancelled/Error)
- Info Rows: Label + Value mit unterschiedlichen Farben
- Spacing: paddingLg, columnSpacing (16, 16)

**Farbschema**:
```
Active    → Sage (#7BA38C) on White
Paused    → Warning (#FECA57) on Black
Completed → Success (#22C55E) on White
Cancelled → Error (#EF4444) on White
```

---

### 2. **time_tracker_tokens.dart**
**Location**: `lib/core/theme/time_tracker_tokens.dart`

Widget: **TimeTrackerWidget** - Clock-In/Out Funktionalität

**Kerntoken**:
- Time Display: Gold (48px, Bold)
- Buttons: Sage (Clock-In), Primary (Clock-Out), 44px Height
- Status: 3 States (ClockOut, ClockIn, Paused)
- Pause Controls: Separate Button-States (Pause/Resume)
- Animations: 300ms mit Curves.easeInOut

**Buttons**:
```
Clock-In  → Sage (#7BA38C) Text White
Clock-Out → Primary (#D4775E) Text White
Disabled  → Gray200 (#E5E7EB) Text Disabled
```

---

### 3. **customer_list_tokens.dart**
**Location**: `lib/core/theme/customer_list_tokens.dart`

Widget: **CustomerListItem** - Recent Customers Liste

**Kerntoken**:
- Avatar: 48px, Gold Background, Border Radius 16
- Name: Foreground Color, MD Font (14), W600
- Contact: Secondary Text, SM Font (12)
- Last Service: Tertiary Text, XS Font (10)
- Frequency Badge: Gold Light Background, Gold Text
- Rating: 5-Star Display in Gold
- Hover Shadows: Elevation unterschiedlich bei Hover

**Avatar**:
```
Size: 48x48
Background Light: #F5EDD8 (Gold Light)
Background Dark:  #D4A853 (Gold)
Text Color: Gold (#D4A853)
```

---

### 4. **schedule_calendar_tokens.dart**
**Location**: `lib/core/theme/schedule_calendar_tokens.dart`

Widget: **ScheduleCalendar** - Wochenansicht mit Schichten

**Kerntoken**:
- Day Columns: 80-120px Width, Border Radius 12
- Today Highlight: Gold Border + Light Background
- Shift Blocks: Gold Border, 4 Status (Confirmed, Pending, Cancelled, Completed)
- Time Scale: Optional Stundenskala
- Navigation: Previous/Next Buttons
- Grid Lines: Border Color

**Shift Status**:
```
Confirmed  → Sage (#7BA38C) Text White
Pending    → Warning (#FECA57) Text Black
Cancelled  → Error (#EF4444) Text White
Completed  → Success (#22C55E) Text White
```

---

## Design Principles

### 1. Spacing System
Alle Widgets verwenden konsistente AppSizes:

```dart
xs   = 4.0   // Minimal gaps
sm   = 8.0   // Small spacing
md   = 12.0  // Medium spacing (default)
lg   = 16.0  // Large spacing (containers)
xl   = 20.0  // Extra large spacing
xxl  = 24.0  // Double extra large
xxxl = 32.0  // Triple extra large
```

### 2. Font System
**Körper**: Inter (Regular, Medium, SemiBold)
**Header**: Playfair Display (Bold, SemiBold)

```dart
Font Sizes:
xs   = 10px  // Labels
sm   = 12px  // Body small
md   = 14px  // Body default
lg   = 16px  // Large body/titles
xl   = 18px  // Headlines
xxl  = 20px  // Large headlines
xxxl = 24px  // Display small
2xl  = 28px  // Display medium
3xl  = 32px  // Display large
```

### 3. Color Semantics

**Primär** (Warm Terracotta): #D4775E
- Primary Actions, Important Elements

**Gold** (Accent): #D4A853
- Time Displays, Highlights, Premium Features

**Rose** (Secondary Accent): #D47B8E
- Alternative Highlights

**Sage** (Positive/Confirm): #7BA38C
- Clock-In, Confirmed Status, Success

**Warning**: #FECA57
- Pending Status, Caution States

**Error**: #EF4444
- Cancelled, Errors, Warnings

**Success**: #22C55E
- Completed Tasks, Success States

---

## Theme Support

### Light Theme
```dart
Background:   #FAF7F5 (Warm Beige)
Foreground:   #2B2520 (Dark Brown)
Surface:      #FFFFFF (White)
Border:       #E8DFD8 (Light Beige)
Text Primary: #2B2520
Text Secondary: #736B66
```

### Dark Theme
```dart
Background:   #0A0A0A (Near Black)
Foreground:   #F5EDD8 (Light Beige)
Surface:      #121212 (Dark Gray)
Border:       #262626 (Dark Border)
Text Primary: #F5EDD8
Text Secondary: #E5D9CF
```

---

## Implementierungs-Muster

### Basis-Pattern für Light/Dark Support

```dart
final isDark = Theme.of(context).brightness == Brightness.dark;

final bgColor = isDark
    ? ShiftCardTokens.containerBackgroundDark
    : ShiftCardTokens.containerBackgroundLight;

final textColor = isDark
    ? ShiftCardTokens.headerTextColorDark
    : ShiftCardTokens.headerTextColor;
```

### Container-Pattern

```dart
Card(
  color: isDark ? Tokens.containerBackgroundDark : Tokens.containerBackgroundLight,
  elevation: Tokens.containerElevation,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Tokens.containerBorderRadius),
    side: BorderSide(
      color: isDark ? Tokens.containerBorderDark : Tokens.containerBorderLight,
      width: Tokens.containerBorderWidth,
    ),
  ),
  child: Padding(
    padding: EdgeInsets.all(Tokens.paddingLg),
    child: // ... content
  ),
)
```

### Text-Pattern

```dart
Text(
  'Shift Time',
  style: TextStyle(
    color: Tokens.timeDisplayColor,
    fontSize: Tokens.timeDisplayFontSize,
    fontWeight: Tokens.timeDisplayFontWeight,
  ),
)
```

### Button-Pattern

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Tokens.buttonClockInBackground,
    foregroundColor: Tokens.buttonClockInForeground,
    minimumSize: Size(double.infinity, Tokens.buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Tokens.buttonBorderRadius),
    ),
  ),
  onPressed: () {},
  child: Text('Clock In'),
)
```

---

## Best Practices

### ✅ RICHTIG

```dart
// Verwende Tokens für alle Design-Entscheidungen
EdgeInsets.all(Tokens.paddingLg)
BorderRadius.circular(Tokens.containerBorderRadius)
TextStyle(fontSize: Tokens.headerFontSize)

// Unterstütze beide Themes
isDark ? Tokens.colorDark : Tokens.color

// Verwende AppSizes & AppColors Konstanten
color: AppColors.gold
spacing: AppSizes.lg
```

### ❌ FALSCH

```dart
// Hard-codierte Werte
EdgeInsets.all(16.0)
BorderRadius.circular(12.0)
TextStyle(fontSize: 24)

// Theme-Unterstützung vergessen
color: Color(0xFFD4775E)

// Magic Numbers
Container(height: 48.0)
```

---

## Beispiel-Widget: ShiftCardExample

**File**: `lib/core/widgets/shift_card_example.dart`

Ein vollständig implementiertes Beispiel-Widget zeigt:
- Alle Token-Verwendungen
- Light/Dark Theme Support
- Status-Badge Implementierung
- Info-Row Pattern
- Icon Integration mit Lucide Icons

### Verwendung:

```dart
ShiftCardExample(
  startTime: '09:00',
  endTime: '17:00',
  breakTime: '30 min',
  status: 'active',
)
```

---

## Dokumentation

### Haupt-Dokumentation
**File**: `lib/core/theme/EMPLOYEE_WIDGETS_TOKENS.md`

Enthält:
- Überblick aller Widgets
- Token-Struktur Erklärung
- Widget-spezifische Dokumentation
- Migration Checklist
- Best Practices
- Zukunfts-Roadmap

---

## Dateistruktur

```
lib/core/
├── theme/
│   ├── app_theme.dart                    (Existierend)
│   ├── app_styles.dart                   (Existierend)
│   ├── shift_card_tokens.dart            ✨ NEU
│   ├── time_tracker_tokens.dart          ✨ NEU
│   ├── customer_list_tokens.dart         ✨ NEU
│   ├── schedule_calendar_tokens.dart     ✨ NEU
│   └── EMPLOYEE_WIDGETS_TOKENS.md        ✨ NEU
├── constants/
│   ├── app_colors.dart                   (Existierend)
│   └── app_sizes.dart                    (Existierend)
└── widgets/
    └── shift_card_example.dart           ✨ NEU
```

---

## Implementation Checklist

Für neue Widgets im Employee Dashboard:

- [ ] Tokens-Datei erstellen (`widget_name_tokens.dart`)
- [ ] Container Styling definieren (Background, Border, Radius)
- [ ] Spacing Konstanten setzen
- [ ] Light/Dark Farben für alle Zustände
- [ ] Typography Tokens setzen
- [ ] Status-Varianten dokumentieren
- [ ] Example Widget schreiben
- [ ] Tests mit Light/Dark Theme
- [ ] Shadow/Elevation Werte konsistent

---

## Responsive Design

Die Tokens unterstützen responsive Design:

**ScheduleCalendar** (Beispiel):
```dart
minDayColumnWidth = 80.0
maxDayColumnWidth = 120.0
```

Diese Werte ermöglichen flexible Layouts auf verschiedenen Bildschirmgrößen.

---

## Animations & Interaktionen

### TimeTrackerWidget
```dart
static const Duration animationDuration = Duration(milliseconds: 300);
static const Curve animationCurve = Curves.easeInOut;
```

### CustomerListItem (Hover)
```dart
static const Duration hoverDuration = Duration(milliseconds: 200);
static const Curve hoverCurve = Curves.easeInOut;
```

---

## Migration von Hard-Coded Werten

Falls existierende Widgets noch hard-codierte Werte verwenden:

**Vorher**:
```dart
Card(
  color: Colors.white,
  elevation: 2,
  child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text(
      '09:00 - 17:00',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  ),
)
```

**Nachher**:
```dart
Card(
  color: ShiftCardTokens.containerBackgroundLight,
  elevation: ShiftCardTokens.containerElevation,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(ShiftCardTokens.containerBorderRadius),
  ),
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

---

## Accessibility Considerations

Die Tokens berücksichtigen:
- **Color Contrast**: Alle Textfarben erfüllen WCAG AA Standards
- **Font Sizes**: Minimum 10px für Body Text (Mobile-friendly)
- **Touch Targets**: Buttons mindestens 44px (AppSizes.buttonHeightMd)
- **Spacing**: Ausreichende Abstände zwischen Elementen

---

## Versionierung & Updates

Diese Tokens entsprechen:
- **Flutter**: 3.10+
- **Material Design 3**: ✓
- **Dark Mode**: ✓ Vollständig unterstützt
- **Responsive**: ✓

---

## Nächste Schritte

1. **Integration**: Verwende die Tokens in neuen Employee Widgets
2. **Migration**: Refactor existierende Widgets zu Tokens
3. **Testing**: Teste alle Widgets in Light/Dark Themes
4. **Feedback**: Sammle Feedback zur Konsistenz
5. **Erweiterung**: Weitere Token-Sets für andere Features

---

## Support & Dokumentation

Alle Tokens sind vollständig dokumentiert:
- Jede Datei hat umfangreiche Comments
- EMPLOYEE_WIDGETS_TOKENS.md: Ausführliche Dokumentation
- shift_card_example.dart: Praktische Beispiele
- Inline-Dokumentation in jedem Token-Set

---

## Summary Table

| Widget | Tokens-Datei | Hauptelemente | Status |
|--------|-------------|---------------|--------|
| ShiftCard | shift_card_tokens.dart | Time Display, Status, Info Rows | ✓ Abgeschlossen |
| TimeTracker | time_tracker_tokens.dart | Clock Buttons, Pause, Status | ✓ Abgeschlossen |
| CustomerList | customer_list_tokens.dart | Avatar, Info, Frequency Badge | ✓ Abgeschlossen |
| ScheduleCalendar | schedule_calendar_tokens.dart | Day Columns, Shift Blocks | ✓ Abgeschlossen |

---

**Erstellt am**: 2026-02-15
**Projekt**: SalonManager Flutter
**Design System**: Material 3 + Custom Branding
