# Dashboard-Vergleich React vs. Flutter & Verbesserungsplan

**Datum:** 16. Februar 2026  
**Status:** Analyse für Harmonisierung und Verbesserung

---

## 📊 ZUSAMMENFASSUNG: Was noch fehlt?

### ✅ Was React hat, Flutter braucht:
1. **Modulares Berechtigungssystem** für Module/Features
2. **Salon Code Reset** Funktionalität mit Bestätigung
3. **Activity Log / Audit Trail** für Admin-Aktionen
4. **Time Code Generierung** für Mitarbeiter-Logins
5. **Responsive Mobile-First Design** (Dashboard hat besseres Mobile Layout)
6. **Zustand-basiertes State Management** (Flutter nutzt Riverpod)
7. **Bessere Fehlerbehandlung und Toast-Notifications**

### ✅ Was Flutter hat, React braucht:
1. **Customer Dashboard** (separat für Kundenbuchungen)
2. **QR Code Check-in** Feature
3. **Leave Request Management** (Urlaubsanträge)
4. **Shift Management** für Mitarbeiter
5. **Appointment Management** Integration
6. **Multi-Salon Support** in der Navigation
7. **Dark Mode** Default-Implementierung
8. **Offline Capabilites** (Flutter Ready)

---

## 🔍 DETAILLIERTER VERGLEICH

### 1. AUTHENTIFIZIERUNG & ROLLEN-SYSTEM

#### React Dashboard-Lösung:
```typescript
// App.tsx - Rollenbasierte Routen
<ProtectedRoute requiredRole="admin">
  <AdminPage />
</ProtectedRoute>

// useDashboardAuth.ts - Zustand Store mit:
// - admin / employee Rollen
// - salonId, employeeId, salonCode
// - Session-Persistierung (localStorage, 24h Expiry)
// - salonLogin() & employeeLogin() als separate Flows
```

**Rollen in React:**
- `admin` - Vollugriff auf AdminPage
- `employee` - Nur Dashboard (Zeit-Tracking)
- `null` / unauthenticated - Weiterleitung zu /login

#### Flutter-Lösung:
```dart
// core/guards/role_guard.dart
enum UserRole { admin, owner, manager, stylist, employee, customer }

// Methoden:
- hasRole(requiredRole)
- hasAnyRole([roles])
- isAdminOrManager()
- isEmployee()
- checkRoleAccess(path, allowedRoles) // mit Redirect

// core/navigation/app_shell.dart
// - Dynamische Navigation basierend auf UserRole
// - getNavigationItems(userRole) für unterschiedliche Navs
```

**Rollen in Flutter:**
- `admin` / `owner` / `manager` - Admin-Dashboard
- `stylist` / `employee` - Employee-Dashboard
- `customer` - Customer-Dashboard

#### ❌ PROBLEM:
- **React:** Nur 2 echte Rollen (admin/employee), keine Owner/Manager/Stylist Differenzierung
- **Flutter:** Hat mehr Rollen, aber keine **Modul-basierte Berechtigungen** (z.B. darf Manager Module X, Y deaktivieren?)

---

### 2. DASHBOARD-STRUKTUR & LAYOUT

#### React Dashboard:
- **AdminPage.tsx** (623 Zeilen)
  - Tabs: modules, users, employees, permissions, logs
  - Salon Code Management (generieren, reset, bestätigen)
  - Employee Code Generierung für Time-Tracking
  - Permission Config Pro Modul
  - Activity Log aus DB
  - Responsive: Grid-basiert mit TailwindCSS

- **DashboardPage.tsx** (129 Zeilen)
  - Employee/User Dashboard
  - Hauptmodul: EmployeeTimeTracking
  - Andere Module disabled/TBD
  - Mobile-First (Menu-Toggle, responsive Gap)

- **LoginPage.tsx**
  - Salon Code Input & Verification
  - Employee Time Code Login

#### Flutter Dashboard:
- **admin_dashboard_screen.dart** (669 Zeilen)
  - TabBar mit 4+ Tabs
  - Tabs: Overview, Employees, Gallery, Messages, Reports, Coupons, Inventory, POS
  - Sidebar Navigation (140-260px)
  - Responsive: Row-basiert mit MediaQuery
  - Gradient Hintergrund

- **employee_dashboard_screen.dart** (249 Zeilen)
  - TabBar mit 4 Tabs
  - Tabs: Appointments, Time-Tracking, QR-Check-in, Leave Requests
  - Provider-basiert (employeeAppointmentsProvider, etc.)
  - Better Feature-Integration

- **customer_dashboard_screen.dart** (457 Zeilen)
  - Willkommenssection
  - Schnellaktionen-Grid
  - Meine Termine
  - Integration mit Buchungsystem

#### ❌ UNTERSCHIEDE:
| Aspekt | React | Flutter |
|--------|-------|---------|
| **Admin Struktur** | Modul-Config Seite | Tab-UI (Employees, Gallery, etc.) |
| **Employee View** | Nur Zeit-Tracking | Termine, Zeit, QR, Urlaub |
| **Customer View** | ❌ Nicht vorhanden | ✅ Terminübersicht, Aktionen |
| **Mobile Layout** | Responsive, Menü-Toggle | Drawer bei Mobile, Rail bei Desktop |
| **Tab-Count** | 5-6 Admin, 1 User | 8 Admin, 4 Employee, 5 Customer |

---

### 3. MODUL-SYSTEM & FEATURE-VERWALTUNG

#### React Lösung:
```tsx
// AdminPage.tsx - modules Tab
interface ModuleConfig {
  name: string        // 'time_tracking', 'pos', 'inventory', etc.
  enabled: boolean
  permissions?: {
    canEdit: boolean
    canView: boolean
    canDelete: boolean
  }
}

// Dashboard speichert in salon_dashboard_config Tabelle:
{
  salonId, 
  module_settings: JSON (alle Module und Status)
  config_version
}
```

**Verfügbare Module in React:**
- ✅ time_tracking (implemented)
- ⏳ calendar (planned)
- ⏳ pos (planned)
- ⏳ inventory (planned)
- ⏳ messaging (planned)

#### Flutter Lösung:
**Keine zentrale Modul-Aktivierung!**
- Admin-Dashboard zeigt direkt alle Features (Employees, Gallery, Messages, Reports, etc.)
- Kein Feature-Flag oder Admin-Config-Panel
- Features sind hardcodiert im Code

#### ❌ KRITISCHES PROBLEM:
**React hat Admin-Module-Management, Flutter hat es NICHT!**
- Salons in Flutter können nicht eigenständig im Admin-Panel:
  - Module deaktivieren
  - Berechtigungen setzen
  - Salon-Codes ändern
  - Mitarbeiter-Codes generieren

---

### 4. AUTHENTIFIZIERUNG & ZUGANG

#### React:
```typescript
// 2-Schritt Login
1. SalonLogin(salonId, salonCode) → admin Rolle
2. EmployeeLogin(timeCode) → employee Rolle

// Persistierung
- localStorage + Session (24h)
- Auto-Restore session on mount
```

#### Flutter:
```dart
// Pin-basiert (alt) oder Supabase Auth
- currentUserProvider → Riverpod
- Keine explizite Salon/Employee Code Struktur
- Auth via Supabase (EmailPassword oder SSO)
```

#### ❌ MISMATCH:
- React verwendet **Code-basierte Logins** (salonCode, timeCode)
- Flutter nutzt **Standard Supabase Auth** (Email/Passwort)
- Sind dies unterschiedliche Authentifizierungs-Layer?

---

### 5. DATENMODELLE & QUERIES

#### React (API-Layer):
```typescript
// dashboardAPI (services/api.ts)
- getDashboardConfig(salonId)
- updateSalonCode(salonId, newCode)
- getEmployees(salonId)
- generateTimeCode(employeeId)
- getActivityLog(salonId)
- etc.

// RPC Functions in Supabase:
- verify_salon_code()
- generate_employee_time_code()
- get_dashboard_config()
```

#### Flutter:
```dart
// Direkter Supabase-Zugriff via Provider
- employeeAppointmentsProvider
- employeeShiftsProvider
- employeeTimeTrackingProvider
- dashboardActivitiesProvider
- etc.

// SQL-Functions im Backend:
- get_employee_appointments()
- get_employee_shifts()
- etc.
```

---

### 6. UI/UX UNTERSCHIEDE

| Feature | React | Flutter |
|---------|-------|---------|
| **Color Scheme** | Grayscale (bg-gray, blue accent) | Gold/Brown (App Theme) |
| **Icons** | Lucide React | Lucide Icons (Flutter pkg) |
| **Cards** | shadcn/ui Card Component | Custom Container |
| **Forms** | Custom Input + Label | TextField |
| **Dark Mode** | CSS Classes (.dark) | Material 3 ThemeData |
| **Responsiveness** | TailwindCSS (sm:, md:, lg:) | MediaQuery Breakpoints |
| **State Mangement** | Zustand (localStorage) | Riverpod (Ref) |

---

## 📋 FEHLENDE FEATURES IN FLUTTER

### A) Admin Panel / Super-Admin Tools

**❌ FEHLEND:**
1. **Salon Code Management Panel**
   - [ ] Code generieren
   - [ ] Code zurücksetzen
   - [ ] Code validieren
   - [ ] Bestätigungs-Dialog

2. **Modul-Verwaltung**
   - [ ] Module aktivieren/deaktivieren
   - [ ] Berechtigungen pro Modul setzen
   - [ ] Konfiguration speichern in DB

3. **Employee Code Management**
   - [ ] Codes generieren für Mitarbeiter
   - [ ] Codes anzeigen (mit Copy-Button)
   - [ ] Codes zurücksetzen

4. **Activity Log / Audit Trail**
   - [ ] Admin-Aktionen loggen
   - [ ] Mitarbeiter-Logins tracknen
   - [ ] Änderungen dokumentieren
   - [ ] Zeitstempel + User Info

5. **Salon Settings Panel**
   - [ ] Salon-Info bearbeiten
   - [ ] Geschäftszeiten konfigurieren
   - [ ] Feiertage definieren
   - [ ] Zahlungsarten einstellen

---

### B) Employee Features (auch fehlend in React!)

**In Flutter vorhanden, React fehlen:**
1. **QR Code Check-in** System
2. **Leave Request Management** (Urlaubsantrag)
3. **Shift Management** (Arbeitsschichten)
4. **Appointment Management** (Termin-Details)

**In React nicht implementiert:**
- Nur `EmployeeTimeTracking` aktiv
- Andere Module placeholder/TBD

---

### C) Customer Features (nur in Flutter!)

**In Flutter:**
- ✅ Customer Dashboard
- ✅ Meine Termine Übersicht
- ✅ Schnellaktionen (Buchen, Angebot, etc.)
- ✅ Kundenprofil Management

**In React:**
- ❌ Nicht vorhanden (nur Admin + Employee)

---

## 🎯 ROLLE-SPEZIFISCHE DASHBOARDS: VERGLEICH

### ADMIN/OWNER/MANAGER DASHBOARD

#### React AdminPage:
1. **Tabs Navigation:**
   - modules (Konfiguration)
   - users (Mitarbeiter-Codes)
   - employees (Liste + Code-Gen)
   - permissions (Modul-Rechte)
   - logs (Activity Log)

2. **Features:**
   - Salon Code reset
   - Employee Time Code generieren
   - Module Config laden/speichern
   - Permission Pro Modul setzen
   - Activity Log anzeigen

3. **State:** Zustand Store (useDashboardStore)

#### Flutter AdminDashboard:
1. **Tabs Navigation:**
   - Overview
   - Employees (Employee Management)
   - Gallery
   - Messages
   - Reports
   - Coupons
   - Inventory
   - POS

2. **Features:**
   - Employee Management Screen importiert
   - Direkte Feature-Navigation
   - Keine zentrale Konfiguration
   - Kein Modul-Management
   - Kein Code-Management

3. **State:** Riverpod Providers

#### ❌ PROBLEM:
- React: Feature-rich, aber nur Zeit-Tracking implementiert
- Flutter: Mehr Features sichtbar, aber keine Admin-Controls

---

### EMPLOYEE DASHBOARD

#### React DashboardPage:
1. **Module:**
   - ⏱️ Zeiterfassung (implemented)
   - 📅 Kalender (disabled)
   - 💬 Messaging (disabled)
   - 📊 Reports (disabled)

2. **Features:**
   - EmployeeTimeTracking Component
   - Session Display (Salon-Name)
   - Mobile-responsive Menu
   - Logout Button

3. **Design:** Modern, Responsive, TailwindCSS

#### Flutter EmployeeDashboard:
1. **Tabs:**
   - 📅 Termine (Appointments)
   - ⏱️ Zeiterfassung (Time Tracking)
   - 🔷 QR-Check-in
   - 🏖️ Urlaub (Leave Requests)

2. **Features:**
   - Appointments anzeigen + Details
   - Time Tracking Widget
   - QR Code Scanner Integration
   - Leave Request Form

3. **Design:** Material 3, AppBar + TabBar

#### ✅ VORTEIL Flutter:
- Mehr Features bereits implementiert
- Bessere Feature-Abdeckung
- QR-Check-in native support

---

### CUSTOMER DASHBOARD

#### React:
- ❌ **Nicht vorhanden** (nur Login)

#### Flutter:
- ✅ **Separate CustomerDashboardScreen**
  - Welcome Section
  - Quick Actions Grid
  - Meine Termine (mit Details)
  - Kundenprofilverwaltung

#### ⚠️ PROBLEM:
React braucht Customer Dashboard!

---

## 🛠️ VERBESSERUNGSPLAN: 9-PUNKTE STRATEGIE

### PHASE 1: HARMONISIERUNG (Woche 1-2)

#### 1. **Role-Struktur vereinheitlichen**
```
Ziel: Konsistente Rollenmodelle in beiden Apps

React (JETZT):
- admin
- employee
- null

React (SOLLTE):
- admin / owner / manager
- stylist / employee
- customer

Flutter (JETZT):
- admin / owner / manager
- stylist / employee
- customer

Aktion:
- React: UserRole enum erweitern
- React: ProtectedRoute aktualisieren für neue Rollen
- Backend: ensure all roles populated in user attributes
```

#### 2. **Zentrales Dashboard-Schema definieren**
```
Alle Dashboards müssen folgende Struktur haben:

Common Layout:
├── Header (User, Theme, Language, Logout)
│   ├── Title + Subtitle
│   ├── Settings/Language Button
│   └── Theme Toggle
├── Navigation (Role-specific)
│   ├── Tabs (Mobile/Desktop unterschiedlich)
│   └── Sidebar (Desktop nur)
└── Content Area
    └── Tab-specific Widget

Consistency:
- Gleiche Header in allen Dashboards
- Gleiche Icon-Library (Lucide)
- Gleiche Color Scheme (with theme support)
```

---

### PHASE 2: ADMIN-MODULE MANAGEMENT (Woche 2-3)

#### 3. **Flutter Admin-Panel mit Modul-Management erweitern**

**Was zu tun ist:**
```dart
// Neu: lib/features/admin/dashboard/admin_settings_tab.dart
class AdminSettingsTab extends ConsumerWidget {
  // Salon Code Management
  _buildSalonCodeSection()  // Generate, Reset, Validate
  
  // Module Management
  _buildModuleManagementSection()  // Toggle features
  
  // Employee Code Management
  _buildEmployeeCodeSection()  // Generate codes
  
  // Activity Log
  _buildActivityLogSection()  // Show audit trail
  
  // Salon Settings
  _buildSalonSettingsSection()  // Hours, info, etc.
}

// Neu: lib/providers/admin_providers.dart
final salonConfigProvider = StateNotifierProvider(...)
final moduleSettingsProvider = StateNotifierProvider(...)
final salonCodeProvider = StateNotifierProvider(...)
final activityLogProvider = FutureProvider(...)
```

**Implementierungs-Checklist:**
- [ ] Salon Code Panel (wie React AdminPage)
- [ ] Module Enable/Disable toggles
- [ ] Employee Code Generator
- [ ] Activity Log Viewer
- [ ] Settings Tab erweitern

---

#### 4. **React Admin Module Completion**

**Was zu tun ist:**
```typescript
// Dashboard/src/pages/AdminPage.tsx erweitern:

// Modul-Implementierung:
const AVAILABLE_MODULES = {
  time_tracking: { name: 'Zeit-Tracking', icon: Clock },
  pos: { name: 'POS-System', icon: ShoppingCart },
  inventory: { name: 'Inventar', icon: Package },
  calendar: { name: 'Kalender', icon: Calendar },
  messaging: { name: 'Nachrichten', icon: MessageSquare },
  reports: { name: 'Berichte', icon: BarChart3 },
}

// Implementierung für jedes Modul:
- [ ] time_tracking: Erweitern (mehr als nur Component)
- [ ] pos: Implementieren
- [ ] inventory: Implementieren
- [ ] calendar: Implementieren
- [ ] messaging: Implementieren
- [ ] reports: Implementieren
```

---

### PHASE 3: EMPLOYEE FEATURES (Woche 3-4)

#### 5. **React Employee Dashboard aufstocken**

```typescript
// Neu: React Dashboard/src/components/EmployeeModules/
├── QRCheckIn.tsx        (Von Flutter kopieren)
├── ShiftSchedule.tsx    (Von Flutter kopieren)
├── LeaveRequest.tsx     (Von Flutter kopieren)
├── AppointmentView.tsx  (Von Flutter kopieren)
└── TimeTracking.tsx     (Bestehend, erweitern)

// Neu: Dashboard/src/hooks/useEmployeeShifts.ts
// Neu: Dashboard/src/hooks/useEmployeeLeaveRequests.ts
// Neu: Dashboard/src/hooks/useQRCodeScanner.ts
```

---

#### 6. **Flutter Employee Dashboard erweitern**

```dart
// Erweitern mit:
- [ ] Bessere Time-Tracking UI (wie React?)
- [ ] Performance-Metriken (Umsatz, Termine)
- [ ] Messaging Integration
- [ ] Notes/Tasks Management
```

---

### PHASE 4: CUSTOMER FEATURES (Woche 4-5)

#### 7. **React Customer Dashboard hinzufügen**

```typescript
// Neu: Dashboard/src/pages/CustomerPage.tsx
import CustomerDashboard from '../components/CustomerDashboard'

// Neu: Dashboard/src/components/CustomerDashboard/
├── AppointmentsList.tsx
├── QuickActions.tsx
├── ProfileSection.tsx
├── ReviewsRatings.tsx
└── BookingCreate.tsx

// App.tsx erweitern:
<Route path="/customer" element={
  <ProtectedRoute requiredRole="customer">
    <CustomerPage />
  </ProtectedRoute>
} />
```

---

### PHASE 5: AUTHENTIFIZIERUNG (Woche 5)

#### 8. **Auth-Layer Harmonisierung**

```
Option A: Code-basierte Auth einführen (React Ansatz)
- Salon Code für Admin-Zugang
- Time Code für Employee-Zugang
- Vorteil: Kein Passwort-Verwirtschaftung
- Nachteil: Neue RPC-Functions in Supabase

Option B: Standard Auth bevorzugen (Flutter Ansatz)
- Email/Passwort oder SSO
- Vorteil: Standard, sicherer
- Nachteil: Bestehende Codes-Struktur erhalten

Entscheidung: → Hybrid
- Flutter: Gleiche Code-basierte Auth wie React implementieren
  (salonCode für Admin, timeCode für Employee)
- React: Beibehalten, aber mit Flutter synchronisieren
```

**Aktion:**
```dart
// Flutter: Neuer Auth-Guard für Salon/Employee Codes
class CodeBasedAuthGuard {
  Future<bool> verifySalonCode(String salonId, String code)
  Future<bool> verifyEmployeeCode(String employeeId, String code)
  Future<String> generateSalonCode(String salonId)
  Future<String> generateEmployeeCode(String employeeId)
}
```

---

### PHASE 6: UI/UX ALIGNMENT (Woche 6)

#### 9. **Design System Standardisieren**

```
Einheitliche:
- [ ] Color Palette (Gold #cc9933, grays, theme colors)
- [ ] Icon Library (Lucide -> both apps)
- [ ] Typography (FontFamily, Sizes)
- [ ] Spacing System (4pt Grid)
- [ ] Component Library
  - Button Styles (Primary, Secondary, Danger)
  - Card/Container Styles
  - Form Elements
  - Navigation Patterns
```

**Konkret:**
- Flutter: App-Theme anpassen (falls nötig)
- React: Design Tokens aktualisieren
- Beide: Dokumentation in Design System

---

## 📊 FEATURE-MATRIX: Aktueller Stand

### ADMIN-DASHBOARDS

| Feature | React | Flutter | Priorität |
|---------|-------|---------|-----------|
| **Authentifizierung** | Salon Code | Email Auth | ⚠️ Harmonisieren |
| **Salon Code Mgmt** | ✅ (Reset, Gen) | ❌ | 🔴 Kritisch |
| **Employee Code Gen** | ✅ | ❌ | 🔴 Kritisch |
| **Modul Management** | ✅ (Config) | ❌ | 🔴 Kritisch |
| **Permission Control** | ✅ | ❌ | 🟡 Wichtig |
| **Activity Log** | ✅ | ❌ | 🟡 Wichtig |
| **Responsive Layout** | ✅ (TW) | ✅ (MQ) | ✅ Beide gut |
| **Dark Mode** | ⚠️ (CSS) | ✅ (Material) | ✅ Beide OK |
| **Multi-Salon** | Nur SalonId | Nur SalonId | ✅ Beide OK |

### EMPLOYEE-DASHBOARDS

| Feature | React | Flutter | Priorität |
|---------|-------|---------|-----------|
| **Zeit-Tracking** | ✅ | ✅ | ✅ Done |
| **Appointments** | ❌ | ✅ | 🔴 React need |
| **QR Check-in** | ❌ | ✅ | 🔴 React need |
| **Leave Requests** | ❌ | ✅ | 🔴 React need |
| **Shift Schedule** | ❌ | ✅ | 🔴 React need |
| **Mobile UI** | ✅ Good | ✅ Good | ✅ Both OK |

### CUSTOMER-DASHBOARDS

| Feature | React | Flutter | Priorität |
|---------|-------|---------|-----------|
| **Dashboard** | ❌ | ✅ | 🔴 React MISSING |
| **Appointments** | ❌ | ✅ | 🔴 React MISSING |
| **Booking** | ❌ | ✅ | 🔴 React MISSING |
| **Profile** | ❌ | ✅ | 🔴 React MISSING |

---

## 🚀 IMPLEMENTATION ROADMAP

```
WOCHE 1-2: Setup & Harmonisierung
├── [1] Role-Struktur vereinheitlichen ✓
├── [2] Dashboard-Schema definieren
└── [3] Code-Audit durchführen

WOCHE 2-3: Admin Features
├── [3] Flutter Admin Panel erweitern
├── [4] React Admin komplettieren
└── → Deploy: Admin Module funktionieren in beiden Apps

WOCHE 3-4: Employee Features
├── [5] React Employee Dashboard aufstocken
├── [6] Flutter Employee Dashboard erweitern
└── → Deploy: Employee können alle Features nutzen

WOCHE 4-5: Customer Features
├── [7] React Customer Dashboard hinzufügen
└── → Deploy: Customers sehen ihre Daten

WOCHE 5: Auth Harmonisierung
├── [8] Code-basierte Auth in Flutter ergänzen
└── → Sync: Login-Flow zwischen Apps identisch

WOCHE 6: Final Polish
├── [9] Design System finalisieren
├── Testing & QA
└── → Release: v2.0 harmonisierte Dashboards
```

---

## 💾 IMPLEMENTIERUNGS-CHECKLISTE

### A) FLUTTER ÄNDERUNGEN (Admin Panel)

**lib/features/admin/dashboard/**
- [ ] Neu: `admin_salon_code_tab.dart` (Salon Code Mgmt)
- [ ] Neu: `admin_modules_tab.dart` (Module Enable/Disable)
- [ ] Neu: `admin_settings_tab.dart` (Einstellungen)
- [ ] Neu: `admin_activity_log_tab.dart` (Audit Trail)
- [ ] Update: `admin_dashboard_screen.dart` (5 Tabs statt 8)
- [ ] Update: `employees_tab.dart` (Code Generator hinzufügen)

**lib/features/admin/presentation/**
- [ ] Neu: `admin_module_management.dart`
- [ ] Neu: `salon_code_manager.dart`
- [ ] Neu: `employee_code_generator.dart`

**lib/providers/**
- [ ] Neu: `admin_salon_config_provider.dart`
- [ ] Neu: `module_settings_provider.dart`
- [ ] Neu: `salon_codes_provider.dart`
- [ ] Neu: `activity_log_provider.dart`

---

### B) REACT ÄNDERUNGEN (Employee + Customer)

**dashboard/src/pages/**
- [ ] Neu: `CustomerPage.tsx`

**dashboard/src/components/**
- [ ] Update: `EmployeeTimeTracking.tsx` (erweitern)
- [ ] Neu: `QRCheckIn.tsx`
- [ ] Neu: `ShiftSchedule.tsx`
- [ ] Neu: `LeaveRequest.tsx`
- [ ] Neu: `CustomerDashboard/index.tsx`

**dashboard/src/hooks/**
- [ ] Neu: `useQRScanner.ts`
- [ ] Neu: `useEmployeeShifts.ts`
- [ ] Neu: `useLeaveRequests.ts`
- [ ] Neu: `useCustomerAppointments.ts`

**dashboard/src/services/**
- [ ] Update: `api.ts` (neue Endpoints)

---

### C) DATENBANK-ÄNDERUNGEN

**Supabase Functions (beide Apps):**
- [ ] `verify_salon_code()` - Validation
- [ ] `generate_salon_code()` - Code generieren
- [ ] `reset_salon_code()` - Mit Bestätigung
- [ ] `generate_employee_time_code()` - Mitarbeiter Codes
- [ ] `get_activity_log()` - Admin Actions logging
- [ ] `get_dashboard_config()` - Modul Settings

**Tabellen:**
- [ ] `activity_logs` (audit trail) - Falls nicht vorhanden
- [ ] `salon_codes` - Falls nicht vorhanden
- [ ] `employee_codes` - Falls nicht vorhanden
- [ ] `dashboard_module_config` - Falls nicht vorhanden

---

## 📈 SUCCESS CRITERIA

- [x] Beide Apps haben gleiche Rollen-Struktur
- [x] Admin-Panel können in beiden Apps Salons konfigurieren
- [x] Employee-Features sind in beiden Apps verfügbar
- [x] Customer-Dashboard existiert in beiden Apps
- [x] Code-Authentifizierung harmonisiert
- [x] Design-System konsistent
- [x] Activity Logging implementiert
- [x] All Features dokumentiert

---

## 📚 ZUSÄTZLICHE RESSOURCEN

- Flutter Dashboard Dokumentation: [`lib/features/dashboard/` Verzeichnis](lib/features/dashboard/)
- React Dashboard Dokumentation: [`react_site/salonmanager1-2-feature-booking-completion/dashboard/` Verzeichnis](react_site/salonmanager1-2-feature-booking-completion/dashboard/)
- Bestehende Implementierungen: [`EMPLOYEE_DASHBOARD_IMPLEMENTATION.md`](EMPLOYEE_DASHBOARD_IMPLEMENTATION.md)

---

## 🔗 NÄCHSTE SCHRITTE

1. **Validierung:** Team-Review dieses Plans (Dauer: 30min)
2. **Priorisierung:** Welche Phase zuerst? (Admin vs. Customer vs. Auth)
3. **Task-Breakdown:** Jede Phase in Sprint-Tasks aufteilen
4. **Start:** Phase 1 nächste Woche?

**Geschätzter Aufwand:** 6-8 Wochen für vollständige Harmonisierung

---

*Erstellt: 16. Februar 2026*  
*Status: Bereit zur Review & Implementierung*
