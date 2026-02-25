# SalonManager Flutter App - Umbau Dokumentation

## Durchgeführte Änderungen

### ✅ 1. Routing-System mit go_router

#### Hinzugefügte Dependencies
- `go_router: ^14.6.2` zur pubspec.yaml hinzugefügt
- `easy_localization` Duplikat entfernt

#### Neue Dateien
- **`lib/core/routing/app_router.dart`**
  - Zentrale Router-Konfiguration mit go_router
  - Automatisches Redirect basierend auf Authentifizierungsstatus
  - Rollenbasierte Navigation (Admin → `/admin`, Employee → `/employee`, Customer → `/customer`)
  - Öffentliche Routen für Auth und Gast-Booking
  - ShellRoute für geschützte Bereiche mit Navigation

#### Angepasste Dateien
- **`lib/main.dart`**
  - Von `MaterialApp` zu `MaterialApp.router` migriert
  - Router-Provider integriert
  - Alte route-Definitionen entfernt

### ✅ 2. Navigation mit Sidebar/Drawer

#### Neue Dateien
- **`lib/core/navigation/app_shell.dart`**
  - Hauptlayout mit NavigationRail für Desktop
  - Drawer für mobile Geräte
  - Ein-/ausklappbare Sidebar
  - User-Profil-Sektion
  - Responsive Design (768px Breakpoint)

- **`lib/core/navigation/navigation_items.dart`**
  - Hierarchische Navigationsstruktur
  - Rollenbasierte Navigation-Items:
    - **Admin/Manager**: Dashboard, Termine, Salon-Management, Galerie, Kommunikation, Einstellungen
    - **Employee**: Dashboard, Termine, POS, Portfolio, Profil
    - **Customer**: Dashboard, Termine buchen, Treuekarte, Profil

- **`lib/core/navigation/sidebar_state_provider.dart`**
  - StateNotifier für Sidebar-Zustand
  - Persistente Speicherung mit SharedPreferences
  - Automatisches Laden beim App-Start

### ✅ 3. Authentifizierung & Services

#### Neue Dateien
- **`lib/services/auth_service.dart`**
  - Zentraler Auth-Service mit Riverpod
  - Login, Register, Logout Funktionen
  - Token-basierte Authentifizierung
  - Integration mit Supabase
  - Rollenmanagement (Admin, Manager, Employee, Customer)

#### Angepasste Dateien
- **`lib/services/supabase_service.dart`**
  - `supabaseServiceProvider` hinzugefügt
  - Riverpod-Integration

- **`lib/providers/salon_provider.dart`**
  - Duplizierter `supabaseServiceProvider` entfernt

- **`lib/features/auth/presentation/login_screen.dart`**
  - go_router Navigation integriert
  - Auth-Service statt direkter Supabase-Calls
  - Automatisches Routing nach erfolgreichem Login

### ✅ 4. Design & Theme

#### Bereits vorhanden
- Gold/Rose/Sage Farbpalette (wie im Umbauplan beschrieben)
- Dark/Light Mode Support
- AppColors mit primären, sekundären und Akzentfarben
- Responsive Design-Grundlagen

#### Navigation Design
- Gold-Akzent (`Color(0xFFcc9933)`) für aktive Navigation-Items
- Smooth Animations für Sidebar-Collapse
- Hover-Effekte und Material Design 3

## Routenstruktur

### Öffentliche Routen
- `/splash` - Splash Screen
- `/auth` - Entry Screen (Login/Register/Gast)
- `/auth/login` - Login Screen
- `/auth/register` - Register Screen
- `/auth/forgot-password` - Password Reset
- `/booking` - Gast-Buchung (ohne Auth)

### Geschützte Routen (mit Navigation Shell)
- `/admin` - Admin Dashboard
- `/employee` - Employee Dashboard
- `/customer` - Customer Dashboard
- `/calendar` - Kalendert
- `/schedule` - Zeitplan
- `/employees` - Mitarbeiterverwaltung
- `/inventory` - Inventar
- `/suppliers` - Lieferanten
- `/gallery` - Galerie
- `/conversations` - Nachrichten
- `/profile` - Profil
- `/settings` - Einstellungen
- *(weitere Platzhalter für zukünftige Features)*

## Noch zu implementieren

### 📋 Phase 2: Dashboard-Erweiterungen

1. **Admin-Dashboard**
   - Tabs-Implementation (Übersicht, Mitarbeiter, Services, etc.)
   - Statistik-Widgets
   - Schnellzugriff-Cards
   - Aktivitäts-Feed

2. **Employee-Dashboard**
   - Header mit Buttons statt Sidebar
   - Termine-Übersicht
   - POS-Integration
   - Portfolio-Verwaltung

3. **Customer-Dashboard**
   - Terminhistorie
   - Treuepunkte
   - Lieblingsservices
   - Profilverwaltung

### 📋 Phase 3: Fehlende Seiten

Die folgenden Routen existieren als Platzhalter und müssen implementiert werden:
- Kalender-Ansicht (`/calendar`)
- Zeitplan (`/schedule`)
- Buchungs-Karte (`/booking-map`)
- Schließzeiten (`/closures`)
- Mitarbeiterverwaltung (`/employees`)
- Inventar (`/inventory`)
- Lieferanten (`/suppliers`)
- Service-Verbrauch (`/service-consumption`)
- Treueprogramm-Einstellungen (`/loyalty-settings`)
- Gutscheine (`/coupons`)
- Berichte (`/reports`)

### 📋 Phase 4: Gast-Buchungs-Wizard

Mehrstufiger Buchungsprozess:
1. Salon auswählen
2. Leistung auswählen
3. Optional: Stylist wählen
4. Datum/Uhrzeit wählen
5. Kontaktdaten eingeben
6. Optional: Notiz und bis zu 5 Bilder hochladen
7. Bestätigung mit Referenzcode

### 📋 Phase 5: Backend-Integration

- Laravel API-Integration
- Supabase Datenbankschema
- RBAC (Role-Based Access Control) vollständig implementieren
- Real-time Updates für Termine
- Push-Benachrichtigungen

### 📋 Phase 6: Testing & Optimierung

- Widget-Tests für Navigation
- Integration-Tests für Auth-Flow
- Performance-Optimierung
- Responsive Design für alle Screens
- Accessibility-Verbesserungen

## Verwendung

### Router-Navigation

```dart
// Navigation mit go_router
context.go('/admin');           // Navigiere zu Route
context.push('/profile');        // Push neue Route
context.pop();                   // Zurück

// Mit Parametern
context.go('/salon/${salonId}');
```

### Auth-Service

```dart
// Login
final authService = ref.read(authServiceProvider);
final success = await authService.login(email, password);

// Logout
await authService.logout();
context.go('/auth');

// Aktueller User
final user = authService.currentUser;
final role = user?.role.name; // 'admin', 'employee', 'customer'
```

### Sidebar State

```dart
// Toggle Sidebar
ref.read(sidebarCollapsedProvider.notifier).toggle();

// Sidebar Zustand lesen
final isCollapsed = ref.watch(sidebarCollapsedProvider);
```

## Nächste Schritte

1. **Testing**: App auf Emulator/Device starten und Routing testen
2. **Register-Screen**: Analog zum Login-Screen anpassen
3. **Admin-Dashboard**: Mit Tabs und Widgets erweitern
4. **Kalender**: Erste Funktionsseite implementieren
5. **Gast-Booking**: Wizard-Flow aufbauen

## Wichtige Änderungen für bestehenden Code

### Alte Navigation entfernen
Falls noch andere Screens die alte Navigation verwenden:
```dart
// ALT (entfernen)
Navigator.of(context).pushNamed('/dashboard');

// NEU (verwenden)
context.go('/admin'); // oder '/employee' / '/customer' je nach Rolle
```

### Supabase-Direktzugriff durch Service ersetzen
```dart
// ALT
final supabase = SupabaseService();
await supabase.signInWithEmail(...);

// NEU
final authService = ref.read(authServiceProvider);
await authService.login(...);
```

## Bekannte Issues

- [ ] home_overview_screen.dart verwendet alte Navigation (muss angepasst werden)
- [ ] Einige warning-level Fehler in employees_tab.dart und settings_tab.dart
- [ ] public_layout.dart hat unbenutzten Parameter

## Architektur-Diagramm

```
lib/
├── main.dart (MaterialApp.router)
├── core/
│   ├── routing/
│   │   └── app_router.dart (go_router config)
│   ├── navigation/
│   │   ├── app_shell.dart (NavigationRail/Drawer)
│   │   ├── navigation_items.dart (Routen-Definitionen)
│   │   └── sidebar_state_provider.dart (Persistenz)
│   ├── theme/ (bereits vorhanden)
│   └── constants/ (bereits vorhanden)
├── services/
│   ├── auth_service.dart (NEU - Auth-Logik)
│   └── supabase_service.dart (erweitert)
├── features/
│   ├── auth/ (Login/Register)
│   ├── dashboard/ (Admin/Employee/Customer)
│   ├── booking/ (Gast-Wizard)
│   └── ... (weitere Features)
└── models/ (User, Salon, etc.)
```

---

**Stand**: 2026-02-13
**Version**: 1.1.0 (Supabase Repositories Phase 1 abgeschlossen)

---

## Phase 2: Supabase-Datenschicht (Gestartet 2026-02-13)

### ✅ Implementierte Repositories (9 Stück mit 50+ Data Models)

#### Authentication
- `lib/features/auth/data/auth_repository.dart` - Login, Register, Auth
- `lib/features/auth/data/user_repository.dart` - Profile, Roles, Salon Context

#### Core Business Data  
- `lib/features/salons/data/salon_repository.dart` - Salon + RPC integration
- `lib/features/services/data/service_repository.dart` - Services & Categories
- `lib/features/customers/data/customer_repository.dart` - Customer Profiles
- `lib/features/bookings/data/booking_repository.dart` - Bookings & Appointments

#### Employee Features
- `lib/features/employee/data/employee_repository.dart` - Time tracking, Leave requests

#### Financial  
- `lib/features/transactions/data/transaction_repository.dart` - POS & Invoices
- `lib/features/inventory/data/inventory_repository.dart` - Stock Management

#### Loyalty
- `lib/features/loyalty/data/loyalty_repository.dart` - Points & Coupons

### RPC Wrappers
- `lib/core/supabase/supabase_rpc.dart` - PostgreSQL function wrappers

### Dokumentation
- `kontext/ANALYSIS_SUPABASE_SCHEMA.md` - Complete schema analysis
- `kontext/UMBAU_DOKUMENTATION.md` - THIS FILE

### Nächste Schritte (Phase 3)
1. Auth Provider aktualisieren (use new repositories)
2. Router Guards fixen (role-based routing)
3. Mock Services entfernen
4. Dashboards mit echten Daten verbinden

