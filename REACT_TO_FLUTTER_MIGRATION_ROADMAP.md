# 🚀 React → Flutter Migration Roadmap
**Datum:** 16. Februar 2026  
**Ziel:** Alle React-Dashboard-Features in Flutter mit modernem Design, Light/Dark Mode und i18n implementieren

---

## 📋 ÜBERSICHT: Was wird migriert?

### React Dashboard Features:
1. **AdminPage** - Admin-Dashboard mit vollständigen Verwaltungsfunktionen
2. **DashboardPage** - Employee-Dashboard mit Zeiterfassung
3. **Authentifizierung** - Salon Code + Employee Code Login
4. **Module Management** - Modul-aktivierung/deaktivierung pro Salon
5. **Activity Log** - Audit Trail für Admin-Aktionen
6. **Employee Management** - Mitarbeiter hinzufügen/entfernen/Codes generieren
7. **Salon Code Reset** - Mit Bestätigung
8. **UI Components** - Button, Card, Toast, Modal, Dialog
9. **Styling** - TailwindCSS → Flutter Material + Custom Theme
10. **Internationalisierung** - Deutsch/Englisch Support
11. **State Management** - Zustand Store → Riverpod
12. **Dark Mode** - Light/Dark Theme wie in React

---

## 🎯 DETAILLIERTE TODO-LISTE

### PHASE 1: GRUNDLAGEN & INFRASTRUKTUR (5 Tasks)

#### Task 1.1: i18n Setup (Easy)
- **Status:** NOT-STARTED
- **Beschreibung:** Deutsche und englische Sprachunterstützung implementieren
- **Subtasks:**
  - [ ] `easy_localization` Paket zu pubspec.yaml hinzufügen
  - [ ] `assets/translations/de.json` erstellen mit allen Labels
  - [ ] `assets/translations/en.json` erstellen mit allen Labels
  - [ ] `LocalizationNotifier` in providers erstellen für Language-Switching
  - [ ] `LocalizationProvider` implementieren mit get_it oder Riverpod
  - [ ] `context.tr()` Extension für einfache Übersetzungen
- **Files to Create:**
  - `lib/providers/localization_provider.dart`
  - `assets/translations/de.json`
  - `assets/translations/en.json`
  - `lib/core/extensions/localization_extension.dart`
- **Estimated Time:** 1.5 hours

#### Task 1.2: Enhanced Theme System (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Modernes Light/Dark Theme System wie React Dashboard
- **Subtasks:**
  - [ ] `AppTheme` Klasse mit Light/Dark ColorScheme erstellen
  - [ ] `ThemeNotifier` für Theme-Switching implementieren
  - [ ] Light Colors definieren (Primary, Secondary, Background, Surface, etc.)
  - [ ] Dark Colors definieren (mit besseren Kontrasten)
  - [ ] `TextTheme` mit konsistenten Styles
  - [ ] `ThemeProvider` in providers
  - [ ] Settings Screen für Theme-Selection
  - [ ] Theme-Persistierung (Shared Preferences)
- **Files to Create:**
  - `lib/core/theme/app_theme.dart`
  - `lib/core/theme/light_theme.dart`
  - `lib/core/theme/dark_theme.dart`
  - `lib/providers/theme_provider.dart`
- **Estimated Time:** 2 hours

#### Task 1.3: Enhanced UI Components Library (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Wiederverwendbare UI-Komponenten wie React
- **Subtasks:**
  - [ ] `AppButton` - Custom Button mit verschiedenen Variants (primary, outline, destructive)
  - [ ] `AppCard` - Mit Header und Content Padding
  - [ ] `AppDialog` - Alert Dialog mit Custom Action Buttons
  - [ ] `AppToast` - Toast Notifications (using FlutterToast oder Custom)
  - [ ] `AppTextField` - Input Field mit Labels und Validation
  - [ ] `AppTab` - Tab Navigation Component
  - [ ] `AppHeader` - Page Header mit Title und Actions
  - [ ] `LoadingOverlay` - Loading Spinner Overlay
- **Files to Create:**
  - `lib/widgets/ui/app_button.dart`
  - `lib/widgets/ui/app_card.dart`
  - `lib/widgets/ui/app_dialog.dart`
  - `lib/widgets/ui/app_toast.dart`
  - `lib/widgets/ui/app_text_field.dart`
  - `lib/widgets/ui/app_tab.dart`
  - `lib/widgets/ui/loading_overlay.dart`
- **Estimated Time:** 2.5 hours

#### Task 1.4: Enhanced State Management (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Riverpod Provider für alle Features
- **Subtasks:**
  - [ ] `AuthProvider` - Session, Rollen, User Info
  - [ ] `SalonProvider` - Aktuelle Salon-Info
  - [ ] `ModulePermissionProvider` - Module Aktivierungsstatus
  - [ ] `ActivityLogProvider` - Audit Log State
  - [ ] `EmployeeProvider` - Employee Liste State
  - [ ] `ThemeProvider` - aktiviertes Theme
  - [ ] `LocalizationProvider` - aktuelle Sprache
  - [ ] `FormStateProvider` - für Forms (Reset Code, etc.)
- **Files to Create:**
  - `lib/providers/auth_provider.dart` (erweitern)
  - `lib/providers/salon_provider.dart`
  - `lib/providers/module_permission_provider.dart`
  - `lib/providers/activity_log_provider.dart`
  - `lib/providers/employee_provider.dart`
- **Estimated Time:** 2 hours

#### Task 1.5: API Service Updates (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Neue Endpoints für Admin-Features
- **Subtasks:**
  - [ ] `getModulePermissions(salonId)` - Module Config laden
  - [ ] `updateModulePermissions(salonId, config)` - Module Update
  - [ ] `getActivityLog(salonId)` - Audit Trail laden
  - [ ] `generateEmployeeCode(employeeId)` - Code generieren
  - [ ] `resetSalonCode(salonId, newCode)` - Salon Code Reset
  - [ ] `getAllEmployees(salonId)` - Employee Liste
  - [ ] `removeEmployee(employeeId)` - Employee entfernen
  - [ ] `addEmployee(salonId, email, name)` - Employee hinzufügen
- **Files to Modify:**
  - `lib/services/api_service.dart`
- **Estimated Time:** 1.5 hours

---

### PHASE 2: ADMIN DASHBOARD (6 Tasks)

#### Task 2.1: Admin Login Flow (Easy)
- **Status:** NOT-STARTED
- **Beschreibung:** Admin-Authentifizierung mit Passwort/Email
- **Subtasks:**
  - [ ] Admin Login Screen erstellen
  - [ ] Email + Password Eingabe
  - [ ] Login Button mit Loading-State
  - [ ] Fehlerbehandlung (Invalid Email, Wrong Password)
  - [ ] Navigation zu AdminDashboard nach erfolreichem Login
  - [ ] Session-Persistierung
- **Files to Create:**
  - `lib/features/admin/presentation/screens/admin_login_screen.dart`
- **Estimated Time:** 1.5 hours

#### Task 2.2: Admin Dashboard Shell (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Layout und Navigation für Admin Dashboard
- **Subtasks:**
  - [ ] Admin Dashboard Screen erstellen
  - [ ] Header mit Logo, Salon-Name, User Info, Logout Button
  - [ ] Tab Navigation (Modules, Users, Employees, Permissions, Logs)
  - [ ] Responsive Layout (Desktop + Tablet + Mobile)
  - [ ] Mobile Menu Toggle
  - [ ] Bottom Navigation für Mobile
  - [ ] Settings Button
- **Files to Create:**
  - `lib/features/admin/presentation/screens/admin_dashboard_screen.dart`
  - `lib/features/admin/presentation/widgets/admin_header.dart`
  - `lib/features/admin/presentation/widgets/admin_navigation.dart`
- **Estimated Time:** 2.5 hours

#### Task 2.3: Modules Management Tab (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Module aktivieren/deaktivieren pro Salon
- **Subtasks:**
  - [ ] Module Liste laden vom Backend
  - [ ] Jedes Modul als Toggle-Card anzeigen
  - [ ] Toggle ON/OFF mit Loading-State
  - [ ] Module-Beschreibungen anzeigen
  - [ ] Module Icons (aus lucide_icons)
  - [ ] Toast-Notification bei Änderung
  - [ ] Error Handling mit Retry
- **Files to Create:**
  - `lib/features/admin/presentation/screens/modules_tab_screen.dart`
  - `lib/features/admin/presentation/widgets/module_toggle_card.dart`
  - `lib/features/admin/models/module_permission_model.dart`
- **Estimated Time:** 2 hours

#### Task 2.4: Employees Management Tab (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Mitarbeiter hinzufügen, entfernen, Codes generieren
- **Subtasks:**
  - [ ] Employee Liste laden
  - [ ] Jeder Employee als Card anzeigen (Name, Email, Code)
  - [ ] "Add Employee" Button (opens Dialog)
  - [ ] Add Employee Dialog (Name, Email Input)
  - [ ] Copy Code Button (mit Feedback)
  - [ ] Regenerate Code Button mit Bestätigung
  - [ ] Delete Employee Button mit Bestätigung
  - [ ] Employee Code anzeigen/kopieren
  - [ ] Loading States
  - [ ] Fehlermeldungen
- **Files to Create:**
  - `lib/features/admin/presentation/screens/employees_tab_screen.dart`
  - `lib/features/admin/presentation/widgets/employee_card.dart`
  - `lib/features/admin/presentation/dialogs/add_employee_dialog.dart`
  - `lib/features/admin/models/employee_model.dart`
- **Estimated Time:** 2.5 hours

#### Task 2.5: Activity Log Tab (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Audit Trail aller Admin-Aktionen
- **Subtasks:**
  - [ ] Activity Log vom Backend laden
  - [ ] Infinite Scroll/Pagination implementieren
  - [ ] Jede Activity als Timeline-Item anzeigen (Icon, Action, User, Timestamp)
  - [ ] Filter nach Action Type
  - [ ] Filter nach Date Range
  - [ ] Search nach User Name
  - [ ] Timestamps formatieren (relative + absolute)
  - [ ] Icons für verschiedene Action Types
- **Files to Create:**
  - `lib/features/admin/presentation/screens/activity_log_tab_screen.dart`
  - `lib/features/admin/presentation/widgets/activity_log_item.dart`
  - `lib/features/admin/models/activity_log_model.dart`
- **Estimated Time:** 2.5 hours

#### Task 2.6: Salon Code Management (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Salon Code anzeigen, generieren, reset mit Bestätigungsdialog
- **Subtasks:**
  - [ ] Desktop-only Tab oder Settings Dialog
  - [ ] Aktiven Salon Code anzeigen
  - [ ] Copy Button für Count Code
  - [ ] "Reset Code" Button
  - [ ] Reset Confirmation Dialog
  - [ ] Neuen Code eingeben + bestätigen
  - [ ] Code Validierung (min 4 Zeichen)
  - [ ] Loading State während Reset
  - [ ] Success/Error Toast
  - [ ] Code History anzeigen (letzte 3 Codes)
- **Files to Create:**
  - `lib/features/admin/presentation/screens/salon_code_tab_screen.dart`
  - `lib/features/admin/presentation/dialogs/reset_salon_code_dialog.dart`
  - `lib/features/admin/models/salon_code_model.dart`
- **Estimated Time:** 1.5 hours

---

### PHASE 3: EMPLOYEE DASHBOARD (4 Tasks)

#### Task 3.1: Employee Login Flow (Easy)
- **Status:** NOT-STARTED
- **Beschreibung:** Employee Code Login
- **Subtasks:**
  - [ ] Employee Login Screen erstellen
  - [ ] Salon Code Input
  - [ ] Employee Code Input
  - [ ] Login Button mit Loading-State
  - [ ] Fehlerbehandlung (Invalid Code)
  - [ ] Navigation zu EmployeeDashboard nach erfolreichem Login
  - [ ] Session-Persistierung
  - [ ] Remember Salon Code Option
- **Files to Create:**
  - `lib/features/employee/presentation/screens/employee_login_screen.dart`
  - `lib/features/employee/models/login_model.dart`
- **Estimated Time:** 1.5 hours

#### Task 3.2: Employee Dashboard Shell (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Layout für Employee Dashboard
- **Subtasks:**
  - [ ] Dashboard Screen erstellen
  - [ ] Header mit Salon-Name, Employee-Name, Logout
  - [ ] Tab Navigation (Time Tracking, Calendar, etc.)
  - [ ] Responsive Layout
  - [ ] Mobile Menu Toggle
  - [ ] Settings Button
  - [ ] Module Visibility basierend auf Salon Permissions
- **Files to Create:**
  - `lib/features/employee/presentation/screens/employee_dashboard_screen.dart`
  - `lib/features/employee/presentation/widgets/employee_header.dart`
  - `lib/features/employee/presentation/widgets/employee_navigation.dart`
- **Estimated Time:** 2 hours

#### Task 3.3: Time Tracking Module (Hard)
- **Status:** NOT-STARTED
- **Beschreibung:** Zeiterfassung wie im React Dashboard
- **Subtasks:**
  - [ ] Start/Stop Button implementieren
  - [ ] Laufende Zeit anzeigen (Stoppuhr)
  - [ ] Aktuelle Session anzeigen (Start Time, Current Duration)
  - [ ] Pause/Resume Funktionalität
  - [ ] Sessions Historie laden
  - [ ] Jede Session als Card anzeigen (Date, Start, End, Duration, Status)
  - [ ] Sessions löschen (mit Bestätigung)
  - [ ] Tages-Summe anzeigen
  - [ ] Wochen-Summe anzeigen
  - [ ] Export als CSV/PDF
  - [ ] Infinite Scroll für Sessions
  - [ ] Real-time Updates vom Backend
- **Files to Create:**
  - `lib/features/employee/presentation/screens/time_tracking_screen.dart`
  - `lib/features/employee/presentation/widgets/time_tracking_widget.dart`
  - `lib/features/employee/presentation/widgets/session_card.dart`
  - `lib/features/employee/models/time_session_model.dart`
  - `lib/features/employee/providers/time_tracking_provider.dart`
- **Estimated Time:** 3.5 hours

#### Task 3.4: Employee Dashboard - Additional Modules (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Placeholders für andere Module auf Employee Dashboard
- **Subtasks:**
  - [ ] Calendar Module (placeholder + enable/disable basierend auf Permissions)
  - [ ] POS Terminal Module (placeholder)
  - [ ] Customers Module (placeholder)
  - [ ] Messages Module (placeholder)
  - [ ] Jedes Modul als Tab oder Navigable Page
  - [ ] "Coming Soon" anzeigen wenn Module disabled
  - [ ] Module Icons
- **Files to Create:**
  - `lib/features/employee/presentation/screens/calendar_module_screen.dart`
  - `lib/features/employee/presentation/screens/pos_module_screen.dart`
  - `lib/features/employee/presentation/screens/customers_module_screen.dart`
  - etc.
- **Estimated Time:** 1.5 hours

---

### PHASE 4: RESPONSIVE DESIGN & MOBILE-FIRST (3 Tasks)

#### Task 4.1: Responsive Layouts (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Mobile-first Responsive Design
- **Subtasks:**
  - [ ] Mobile Layout (< 600px)
  - [ ] Tablet Layout (600px - 900px)
  - [ ] Desktop Layout (> 900px)
  - [ ] LayoutBuilder für responsive Widgets
  - [ ] MediaQuery für Breakpoints
  - [ ] Adaptive Navigation (Bottom Nav für Mobile, Sidebar für Desktop)
  - [ ] Fluid Typography
  - [ ] Touch-friendly Buttons (min 48x48dp)
  - [ ] Proper Spacing bei verschiedenen Screen-Sizes
- **Files to Modify:**
  - Alle Screen-Dateien
- **Estimated Time:** 2 hours

#### Task 4.2: Mobile-specific UX (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Mobile User Experience Optimierungen
- **Subtasks:**
  - [ ] Pull-to-Refresh für Listen implementieren
  - [ ] Swipe-to-Dismiss für Items
  - [ ] Bottom Sheet für Actions statt Dialog auf Mobile
  - [ ] Mobile-optimierte Input-Felder (mit Keyboard-Handling)
  - [ ] Haptic Feedback bei Aktionen
  - [ ] Safe Area Handling
  - [ ] Gesture-Handling (Swipe-Navigation)
  - [ ] Performance Optimization für Low-End Devices
- **Files to Modify:**
  - Alle Widget-Dateien
- **Estimated Time:** 2.5 hours

#### Task 4.3: Platform-specific Styling (Easy)
- **Status:** NOT-STARTED
- **Beschreibung:** iOS/Android native Look & Feel
- **Subtasks:**
  - [ ] iOS: CupertinoButtons wo passend
  - [ ] iOS: NavigationBar Styling
  - [ ] Android: Material Design 3 Components
  - [ ] Android: Back Button Behavior
  - [ ] Font Loading (Custom Fonts wenn nötig)
  - [ ] Icons Material/Cupertino adaptiv
  - [ ] Platform-specific Animations
- **Files to Modify:**
  - Alle Widget-Dateien
- **Estimated Time:** 1.5 hours

---

### PHASE 5: TESTING & QUALITY (2 Tasks)

#### Task 5.1: Unit & Widget Tests (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Tests für kritische Features
- **Subtasks:**
  - [ ] Provider Tests (Auth, Theme, Localization)
  - [ ] Widget Tests für Key Components
  - [ ] API Service Tests (Mocking)
  - [ ] Form Validation Tests
  - [ ] Time Tracking Calculation Tests
  - [ ] Minimum 70% Code Coverage
- **Files to Create:**
  - `test/providers/*_test.dart`
  - `test/widgets/*_test.dart`
  - `test/services/*_test.dart`
- **Estimated Time:** 3 hours

#### Task 5.2: E2E Testing & Bug Fixes (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Integration Tests und Bug Fixes
- **Subtasks:**
  - [ ] E2E Tests für Login Flows
  - [ ] E2E Tests für Admin Actions
  - [ ] E2E Tests für Time Tracking
  - [ ] Performance Profiling
  - [ ] Memory Leak Checks
  - [ ] Theme Switching Works Everywhere
  - [ ] i18n Works in All Screens
  - [ ] No Console Errors/Warnings
  - [ ] Accessibility (a11y) Testing
- **Files to Create:**
  - `test/integration/*_test.dart`
- **Estimated Time:** 2.5 hours

---

### PHASE 6: FINALIZATION & DEPLOYMENT (2 Tasks)

#### Task 6.1: Polish & Optimization (Medium)
- **Status:** NOT-STARTED
- **Beschreibung:** Final Polish und Performance
- **Subtasks:**
  - [ ] Build größe reduziern (Shrinking, Obfuscation)
  - [ ] Performance tunig (Rebuildoptimierungen)
  - [ ] Animation Smoothness Check
  - [ ] Load Time Optimization
  - [ ] Cache Handling (lokale Daten)
  - [ ] Error Messages i18n
  - [ ] Success Messages konsistent
  - [ ] Analytics Integration (optional)
  - [ ] Crash Reporting (Sentry, etc.)
- **Estimated Time:** 2 hours

#### Task 6.2: Deployment Preparation (Easy)
- **Status:** NOT-STARTED
- **Beschreibung:** App Store & Play Store Ready
- **Subtasks:**
  - [ ] App Icons erstellen/updaten
  - [ ] App Splash Screen
  - [ ] App Description (en/de)
  - [ ] Screenshots für Stores
  - [ ] Privacy Policy updated
  - [ ] Version Numbering
  - [ ] Build & Sign für iOS
  - [ ] Build & Sign für Android
  - [ ] Test auf Real Devices
  - [ ] Version Tagging in Git
- **Estimated Time:** 2 hours

---

## 📊 SUMMARY

**Total Tasks:** 26  
**Total Estimated Time:** ~50 hours  
**Team Factor:** 1-2 Developers  
**Target Completion:** 5-10 Working Days (non-parallel)

### Priority Order:
1. Phase 1 (Foundations) - CRITICAL
2. Phase 2 (Admin) + Phase 3 (Employee) - PARALLEL
3. Phase 4 (Responsive) - WHILE Phase 2/3
4. Phase 5 (Testing) - AFTER Phase 3
5. Phase 6 (Finalization) - LAST

---

## 🔄 DEPENDENCY CHAIN

```
1.1 (i18n) ─────┬──> 2.x (Admin Screens)
                │
1.2 (Theme) ────┤──> 3.x (Employee Screens)
                │
1.3 (UI) ───────┼──> 4.x (Responsive)
                │
1.4 (State) ────┤──> 5.x (Testing)
                │
1.5 (API) ──────┴──> 6.x (Deployment)
```

---

## 📝 IMPLEMENTATION NOTES

### Architecture:
- **State Management:** Riverpod (FutureProvider, StateNotifier)
- **Routing:** GoRouter (existing)
- **API:** Supabase (existing)
- **Localization:** easy_localization
- **UI Framework:** Flutter Material Design 3
- **Theme:** Custom Light/Dark ColorScheme
- **Database:** Supabase (PostgreSQL)

### Code Style:
- Follow existing Flutter conventions
- Dart Formatting: `dart format` oder `flutter format`
- Linting: `flutter analyze`
- Meaningful commit messages
- Feature Branches: `feature/task-name`

### Testing Strategy:
- Unit Tests für Business Logic
- Widget Tests für UI Components
- Integration Tests für Features
- Manual Testing auf Real Devices

---

## 🚨 KNOWN CHALLENGES

1. **Theme Switching:** Müssen alle Widgets "buildContext.watch(themeProvider)" nutzen
2. **i18n Strings:** Viele neue Strings in JSON zu übersetzen
3. **API Endpoints:** Einige neue Endpoints müssen Backend-seitig implementiert sein
4. **Time Tracking:** Real-time Timer benötigt StateNotifier mit Timer
5. **Performance:** Große Listen (Activity Log) brauchen Virtualization
6. **Offline Mode:** Caching für Session-Daten implementieren?
7. **Localization Switching:** App-Restart oder Widget Rebuild erforderlich

---

## ✅ SUCCESS CRITERIA

- [ ] Admin Dashboard voll funktional
- [ ] Employee Dashboard voll funktional
- [ ] Time Tracking läuft stabil
- [ ] Light & Dark Mode auf allen Screens
- [ ] Deutsch & Englisch funktioniert überall
- [ ] Responsive auf allen Screen-Größen
- [ ] Keine Crashes/Errors in Production
- [ ] App Store Ready (iOS)
- [ ] Play Store Ready (Android)
- [ ] Minimum 70% Code Coverage
- [ ] Loading Times < 2 seconds
- [ ] Offline Capability (Caching)

---

**Next Step:** Task 1.1 beginnen (i18n Setup)
