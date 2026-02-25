# 🚀 SalonManager Flutter - Projekt Status

**Letztes Update:** 08.02.2026  
**Sprache:** Deutsch/English  
**Plattform:** Flutter (Web/Mobile/Desktop Target)

---

## 📋 Inhaltsverzeichnis
1. [Abgeschlossene Features](#abgeschlossene-features)
2. [In Bearbeitung](#in-bearbeitung)
3. [Noch zu implementieren](#noch-zu-implementieren)
4. [Supabase Datenbank Status](#supabase-datenbank-status)
5. [Bekannte Probleme](#bekannte-probleme)

---

## ✅ Abgeschlossene Features

### Phase 1: Authentication & Authorization ✅
- [x] Email/Password Authentifizierung via Supabase
- [x] Role-Based Access Control (customer, employee, admin, owner)
- [x] Automatisches Routing basierend auf Benutzerrolle
- [x] Logout Funktionalität
- [x] Auth Stream triggert Routing Updates

### Phase 2: Salon Search & Map ✅ (NEUE PHASE)
- [x] Location Services (GPS mit geolocator package)
- [x] Fallback Standort (Berlin default bei Permission-Denial)
- [x] Salon Search Provider (Riverpod State Management)
- [x] Salon Filter System (Rating, Preis, Kategorien, Radius)
- [x] Google Maps Integration
  - [x] Dynamische Marker für Salons
  - [x] Radius Slider (1-100 km)
  - [x] Filter Panel mit Expandable Kategorien
  - [x] Bottom Sheet mit Salon Cards
- [x] Salon Liste Screen
  - [x] Sortiere-Dropdown (Entfernung, Bewertung, Preis)
  - [x] Expandable Filter Panel
  - [x] Responsive Salon Cards
- [x] Router Integration
  - [x] `/salon-map-search` Route
  - [x] `/salon-list-search` Route
  - [x] Navigation von Customer Dashboard

### Phase 4: Dashboard Providers ✅
- [x] Dashboard Data Layer mit Riverpod
- [x] Customer Appointments Provider
- [x] Dashboard Analytics Providers
- [x] Error Handling & Loading States

### Entry Flow & Navigation
- [x] SplashScreen (2 Sekunden mit Animation)
- [x] EntryScreen mit 3 Haupt-Buttons
  - [x] Gast Termin buchen (ohne Login)
  - [x] Kunde Login
  - [x] Mitarbeiter/Admin Login
- [x] Separate Customer Login Screen
- [x] Separate Employee Login Screen
- [x] Booking Wizard für Gäste

### Theme System
- [x] Light/Dark/System Theme Modes
- [x] SharedPreferences Persistierung
- [x] Theme-aware Gradients
- [x] Automatische Theme-Anwendung auf Material App

### Internationalization
- [x] Easy Localization Integration
- [x] Deutsch (DE) als Default
- [x] English (EN) Support
- [x] Translations für alle Screens:
  - [x] Entry Screen
  - [x] Login Screens
  - [x] Splash Screen
  - [x] Dashboard Screens

### Dashboard Struktur
- [x] Customer Dashboard (Shell)
- [x] Employee Dashboard (Shell)
- [x] Admin Dashboard (Shell)
- [x] Logout Button in allen Dashboards

### Booking System
- [x] Booking Wizard Screen vorhanden
- [x] Bookable über Entry Screen

---

## 🟡 In Bearbeitung

### Phase 3: Advanced Booking Features (Upcoming)
- [ ] Availability Time Picker (using hasFreeSlot RPC)
- [ ] Employee/Stylist Selection per Service
- [ ] Image Upload für Bookings (booking_images bucket)
- [ ] Booking Confirmation & Payment UI

### Admin Dashboard Navigation
- [ ] **Neu:** Top Navigation mit:
  - [ ] Language Switcher (DE/EN) direkt in Nav
  - [ ] Dark/Light Mode Toggle direkt in Nav
  - [ ] Entfernung des Settings-Icons
- [ ] Dashboard Content mit Tabs/Navigation

### Auth Improvements
- [ ] "Remember me for 30 days" Checkbox beim Login
- [ ] Persistent Session Handling
- [ ] Auto-Login nach 30 Tagen

---

## ❌ Noch zu implementieren

### High Priority (Woche 1-2)

#### Admin Dashboard Content
- [ ] Module Controls (On/Off für Features)
  - [ ] POS Toggle
  - [ ] Booking Toggle
  - [ ] Calendar Toggle
  - [ ] Chat Toggle
  - [ ] Reports Toggle
  - [ ] Employee Management Toggle
  - [ ] Inventory Toggle
  - [ ] Settings Toggle
  
- [ ] Permission Settings
  - [ ] Employee Permissions pro Salon
  - [ ] Feature Access Control
  - [ ] Customizable Permission Matrix

- [ ] Employee Management
  - [ ] Employee hinzufügen
  - [ ] Employee löschen
  - [ ] Employee bearbeiten
  - [ ] Employee Codes generieren/revoken
  - [ ] Activity Log für Employee Changes

- [ ] Salon Management
  - [ ] Salon Code Reset
  - [ ] Salon Code Anzeige & Copy
  - [ ] Salon Code History

### Medium Priority (Woche 2-3)

#### Dashboard Content Integration
- [ ] Customer Dashboard
  - [ ] Meine Termine anzeigen
  - [ ] Termin buchen
  - [ ] Profil bearbeiten
  - [ ] Zahlungsmethoden
  - [ ] Benachrichtigungspräferenzen

- [ ] Employee Dashboard
  - [ ] Mein Kalender
  - [ ] Heute Kunden
  - [ ] Zeiten tracken (Clock In/Out)
  - [ ] Meine Dienste
  - [ ] Pause verwalten

#### Feature Integration
- [ ] Calendar/Scheduling (Calendar Feature vorhanden, muss in Dashboards integriert)
- [ ] Chat System (Feature vorhanden, muss in Dashboards integriert)
- [ ] Time Tracking (Feature vorhanden, muss integriert)
- [ ] Reports/Analytics (Feature vorhanden, muss integriert)
- [ ] Inventory Management (Feature vorhanden, muss integriert)

#### Notifications
- [ ] Push Notifications Setup
- [ ] In-App Notifications
- [ ] Email Notifications
- [ ] SMS Notifications (optional)

### Low Priority (Woche 3+)

#### Advanced Features
- [ ] POS System Integration
- [ ] Advanced Reporting & Analytics
- [ ] Multi-Salon Support
- [ ] Backup & Recovery
- [ ] Audit Logs
- [ ] API Documentaion

#### Mobile-spezifische Features
- [ ] Offline Mode
- [ ] Native Camera Integration (für Photos)
- [ ] Foto Upload zu Appointments
- [ ] Biometric Auth (Fingerprint/FaceID)

---

## 🗄️ Supabase Datenbank Status

### Verwaltete Tabellen

#### Core Auth
- ✅ `auth.users` - Supabase Auth (Automatic)
- ✅ `user_roles` - Role per User
  - Columns: `id`, `user_id`, `role` (customer|employee|admin|owner), `created_at`
  - Status: **Aktiv & verwendet**

#### Profiles & Users
- ⚠️ `profiles` - Kunde/User Profile
  - Columns: `id`, `user_id`, `firstName`, `lastName`, `email`, etc.
  - Status: **Vorhanden aber noch nicht in neuem Router verwendet**

- ⚠️ `customer_profiles` - Spezifische Customer Daten
  - Status: **Vorhanden, nutzen für erweiterte Customer Infos**

#### Salon Management
- ✅ `salons` - Salon/Geschäft
  - Columns: `id`, `owner_id`, `name`, `description`, etc.
  - Status: **In Verwendung**

- ⚠️ `employees` - Mitarbeiter
  - Status: **Vorhanden, braucht Integration in Admin Dashboard**

#### Business Data
- ✅ `services` - Salon Services/Dienstleistungen
- ✅ `appointments` - Buchungen
- ✅ `availability` - Verfügbarkeitsslots
- ✅ `time_entries` - Time Tracking
- ✅ `conversations` - Chat Messages

#### Activity & Logs
- ⚠️ `audit_logs` - Activity Tracking
  - Status: **Vorhanden, nicht in App integriert**

- ⚠️ `admin_module_activity_logs` - Admin Action Logs
  - Status: **Vorhanden, nicht in App integriert**

### Offene Datenbankfragen
- [ ] Sind alle Tabellen korrekt in Flutter gemappt?
- [ ] Gibt es Row-Level Security (RLS) Policies?
- [ ] Sind Foreign Keys korrekt gesetzt?
- [ ] Sind Indexes für Performance optimiert?

---

## 🐛 Bekannte Probleme

### Behoben (Diese Session)
- [x] Admin Login Routing Bug (war: geht zurück zur Entry Screen)
  - **Fix:** Auth Stream filtern + user_roles Tabelle statt profiles
- [x] Dark Mode Entry Screen (war: keine Farbe-Änderung bei Dark Mode)
  - **Fix:** gradientPrimaryThemed() hinzugefügt

### Aktuell offen
- [ ] Settings Icon wird noch im Entry Screen angezeigt (soll in Nav sein)
- [ ] Language Switcher nur im Settings Bottom Sheet (soll direkt in Nav sein)
- [ ] Admin Dashboard hat nur Placeholder Content
- [ ] Keine "Remember me" Option beim Login

### Zu überprüfen
- [ ] Funktioniert Hot Reload zuverlässig bei komplexen Änderungen?
- [ ] Sind alle Translations vollständig?
- [ ] Responsive Design auf Mobile Geräten?

---

## 📊 Feature Completion Matrix

| Feature | React Vite | Flutter | Status | Priorität |
|---------|-----------|---------|--------|-----------|
| Auth | ✅ | ✅ | ✅ 100% | - |
| Entry Flow | ✅ | ✅ | ✅ 100% | - |
| Guest Booking | ✅ | ✅ | ✅ 100% | - |
| Theme System | ⚠️ (Hardcoded) | ✅ | ✅ 100% | - |
| i18n Support | ❌ | ✅ | ✅ 100% | - |
| **Salon Search (NEW)** | ✅ | ✅ | ✅ 100% | ✅ Phase 2 |
| **Salon Map (NEW)** | ✅ | ✅ | ✅ 100% | ✅ Phase 2 |
| **Location Services (NEW)** | ✅ | ✅ | ✅ 100% | ✅ Phase 2 |
| Admin Dashboard | ✅ | 🟡 (Shell) | 🟡 10% | 🔴 High |
| Employee Dashboard | ✅ | 🟡 (Shell) | 🟡 10% | 🟡 Medium |
| Customer Dashboard | ✅ | ✅ (mit Phase 2) | ✅ 50% | 🟡 Medium |
| Settings UI | ✅ | 🟡 (Bottom Sheet) | 🟡 50% | 🟡 Medium |
| Remember Me | ❌ | ❌ | ❌ 0% | 🔴 High |
| Availability Picker | ✅ | ❌ | ❌ 0% | 🔴 High (Phase 3) |
| Notifications | ✅ | ❌ | ❌ 0% | 🟡 Medium |

---

## 🛠️ Nächste Schritte (Priorisiert)

### Nächste Session:
1. Admin Dashboard Navigation neu gestalten
   - Language Switcher in Header
   - Dark/Light Toggle in Header
   - Settings Icon entfernen
   
2. "Remember me for 30 days" implementieren
   - Checkbox in Login Screens
   - SharedPreferences für Tokens
   - Auto-Login bei App-Start

3. Admin Dashboard Content beginnen
   - Module Controls Tab
   - Permission Settings Tab
   - Employee Management Tab

### Danach:
4. Employee/Customer Dashboard mit echten Daten
5. Feature Integration (Calendar, Chat, etc.)
6. Notifications System
7. Mobile Optimierungen

---

## 📝 Notizen

- Supabase Backup vorhanden: `backup.sql` (Stand 05.02.2026)
- Alle Translations zentral in `assets/translations/{de,en}.json`
- Theme-Farben in `lib/core/constants/app_colors.dart`
- Auf Chrome (Web) getestet und funktionsfähig
- Hot Reload funktioniert gut für UI-Änderungen

---

**Status gesamt:** 53% Feature-Parität mit React Vite (↑ von 45% nach Phase 2)
**Sauberer Zustand:** Ja - kein Tech Debt  
**Bereit für Produktion:** Nein - Admin Dashboard & Phase 3 fehlen  
**Letzte Review:** 08.02.2026
