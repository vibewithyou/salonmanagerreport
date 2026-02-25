# 🗂️ Navigation Architektur Plan - Admin Dashboard

**Erstellt:** 8. Februar 2026  
**Status:** In Planung  
**Sprache:** Deutsch

---

## 📋 Projektübersicht

Umgestaltung des Admin Dashboards mit:
- **Desktop:** Persistente Sidebar Navigation (immer sichtbar) + expandierbare/kollabierbare Menüs
- **Tablet (768px - 1024px):** Collapsible Sidebar mit Icon-nur Ansicht
- **Mobile (<768px):** Hamburger Menu (Icon oben) + Sticky Footer Navigation (unten ständig sichtbar)

---

## 🎯 Navigation Struktur

### Hauptmenü-Punkte (alle Bildschirmgrößen)
```
1. 🏠 Home          → Dashboard Übersicht
2. 🏢 Salon         → Salon Management Hub  
3. 🖼️ Galerie       → Galerie & Inspiration
4. 📅 Termine       → Kalender & Buchungen
5. 💬 Chats         → Kommunikation
6. 👤 Profil        → Profileinstellungen
```

---

## 📁 Detaillierte Menü-Struktur

### 1️⃣ HOME (Übersicht)
```
🏠 Home
└─ Übersicht (Hauptseite)
   - Statistiken
   - Schnellaktionen
   - Geplante Termine
   - Unvollendete Aufgaben
```

### 2️⃣ SALON (Salon Management)
```
🏢 Salon
├─ Meine Salons
├─ Mitarbeiter
│  ├─ Mitarbeiterliste
│  ├─ Zeiterfassung
│  ├─ Rollen & Berechtigungen
│  └─ Abwesenheit
├─ Kunden
│  ├─ Kundenliste
│  ├─ Kundensegmente
│  └─ Kundenhistorie
├─ 💳 Kasse (POS)
├─ 📦 Lager
│  ├─ Bestandsverwaltung
│  ├─ Nachbestellungen
│  └─ Lieferanten
├─ 🚚 Lieferanten
├─ 💧 Verbrauch
├─ 🎁 Loyalty Program
├─ 🎟️ Coupons
├─ 📊 Berichte
│  ├─ Umsatzberichte
│  ├─ Mitarbeiterleistung
│  └─ Kundenbericht
├─ 🔍 SEO Dashboard
├─ 📍 Lokales SEO
└─ ✏️ Seiten Editor
```

### 3️⃣ GALERIE (Fotos & Inspiration)
```
🖼️ Galerie
├─ 💡 Inspiration
│  ├─ Trending Styles
│  ├─ Nach Frisur
│  ├─ Nach Farbe
│  └─ Kolektionen
├─ 📷 Galerie (Arbeiten)
│  ├─ Alle Fotos
│  ├─ Nach Mitarbeiter
│  ├─ Nach Service
│  └─ Alben
└─ 📤 Foto Upload
   ├─ Neue Fotos hochladen
   ├─ Bulk Upload
   └─ Verwaltete Upload-Queue
```

### 4️⃣ TERMINE (Kalender & Buchungen)
```
📅 Termine
├─ 📆 Kalender
│  ├─ Tagesansicht
│  ├─ Wochenansicht
│  ├─ Monatsansicht
│  └─ Mitarbeiter-Schichten
├─ ⏰ Zeitplan
│  ├─ Verfügbarkeiten
│  ├─ Arbeitszeiten
│  └─ Pausen
├─ 📝 Buchungen
│  ├─ Alle Buchungen
│  ├─ Ausstehend
│  ├─ Bestätigt
│  ├─ Abgeschlossen
│  └─ Storniert
├─ 🗺️ Karte
│  └─ Salon mit Umgebung anzeigen
└─ ❌ Schließungen
   ├─ Sonderöffnungen
   ├─ Ferienzeiten
   └─ Wartungstage
```

### 5️⃣ CHATS (Kommunikation)
```
💬 Chats
├─ 👥 Team Chat
│  └─ Interne Mitarbeiterkommunikation
├─ 🆘 Support Chat
│  └─ Kundensupport & Anfragen
├─ 📢 Ankündigungen
│  └─ Betriebliche Mitteilungen
└─ 📧 Nachrichten Center
   ├─ Ungelesen
   ├─ Gespeichert
   └─ Archiv
```

### 6️⃣ PROFIL (Einstellungen)
```
👤 Profil
├─ 👤 Mein Profil
│  ├─ Profilinformationen
│  ├─ Profilbild
│  ├─ Persönliche Daten
│  └─ Kontaktinformationen
├─ 🔐 Sicherheit
│  ├─ Passwort ändern
│  ├─ Zwei-Faktor-Authentifizierung
│  ├─ Angemeldete Geräte
│  └─ Sitzungsverwaltung
├─ 🔔 Benachrichtigungen
│  ├─ E-Mail Einstellungen
│  ├─ SMS Einstellungen
│  ├─ Push Notifications
│  └─ Benachrichtigungswahl
├─ 🎨 Voreinstellungen
│  ├─ Design (Hell/Dunkel)
│  ├─ Sprache
│  ├─ Zeitzone
│  ├─ Datumsformat
│  └─ Währung
├─ 💳 Zahlungsmethoden
│  ├─ Kreditkarten
│  ├─ Bankkonten
│  └─ Zahlungshistorie
├─ 📄 Abo & Lizenz
│  ├─ Abo-Status
│  ├─ Rechnungen
│  └─ Upgrade-Optionen
└─ ⚙️ Erweiterte Einstellungen
   ├─ API Keys
   ├─ Webhooks
   ├─ Berechtigungen
   └─ Datenexport
```

---

## 🛠️ Implementierungs-Strategie

### Phase 1: Architektur & Datenmodelle
1. **Navigation Model** erstellen
   - `NavItem` mit `id`, `label`, `icon`, `route`, `children`, `permissions`
   
2. **Navigation Provider** (Riverpod)
   - `navigationProvider` für aktiven Menü-Punkt
   - `expandedMenusProvider` für Submenu-Status
   - `navigationHistoryProvider` für Back-Navigation

3. **JSON Konfiguration**
   - `navigation_config.json` mit vollständiger Menü-Struktur
   - Ermöglicht zukünftige Konfigurationen ohne Code-Änderungen

### Phase 2: UI Komponenten
1. **DesktopNavigation** (SizedBox width > 1024)
   - Persistente linke Sidebar (250px)
   - Expandierbare Menü-Einträge
   - Icons + Labels

2. **TabletNavigation** (768px - 1024px)
   - Collapsible Sidebar (nur Icons)
   - Breadcrumb für aktuellen Pfad
   - Hover-Tooltip für Icons

3. **MobileNavigation** (< 768px)
   - Hamburger-Menü (Icon oben-links)
   - Vollbild-Overlay-Menü
   - **Sticky Footer-Navigation** (Bottom Navigation Bar)
     - 5 Hauptpunkte sichtbar
     - Icons + Label (bei aktiv)
     - Aktiver Punkt highlighted

### Phase 3: Screen-Struktur

Neuen Ordner erstellen: `lib/features/admin_navigation/`

```
lib/features/admin_navigation/
├── models/
│   └── navigation_model.dart           # Nav Item, Page, Config
├── providers/
│   └── navigation_provider.dart        # Riverpod State
├── widgets/
│   ├── desktop_sidebar.dart            # Desktop Navigation
│   ├── tablet_sidebar.dart             # Tablet Navigation
│   ├── mobile_hamburger_menu.dart      # Hamburger
│   ├── mobile_bottom_nav.dart          # Footer Navigation
│   ├── breadcrumb_navigation.dart      # Pfad-Anzeige
│   └── navigation_layout.dart          # Main Layout-Wrapper
├── screens/
│   ├── home_overview_screen.dart
│   ├── salon_management_screen.dart
│   ├── salon_subpages.dart            # Salon Unterpunkte
│   ├── gallery_screen.dart
│   ├── gallery_subpages.dart
│   ├── appointments_screen.dart
│   ├── appointments_subpages.dart
│   ├── chats_screen.dart
│   ├── chats_subpages.dart
│   └── profile_settings_screen.dart
└── config/
    └── navigation_config.json
```

### Phase 4: Responsive Breakpoints

| Device | Width | Layout |
|--------|-------|--------|
| Mobile | < 768px | Hamburger + Bottom Nav |
| Tablet | 768px - 1024px | Icon Sidebar + Breadcrumb |
| Desktop | > 1024px | Full Sidebar + Content |

---

## 📊 Datenmodelle

### NavigationItem
```dart
class NavigationItem {
  final String id;
  final String label;
  final String icon;
  final String? route;
  final List<NavigationItem>? children;
  final String? requiredPermission;
  final bool isVisible;
}
```

### NavigationPage
```dart
enum NavigationPage {
  home,
  salon,
  gallery,
  appointments,
  chats,
  profile,
  // Sub-pages...
}
```

---

## 🎨 UI/UX Richtlinien

### Farbgebung
- **Active:** AppColors.primary
- **Inactive:** AppColors.textSecondary
- **Hover:** AppColors.primary.withValues(alpha: 0.1)
- **Background:** Theme-aware

### Icons
- **Desktop:** FontAwesome 6 (größere Icons)
- **Mobile:** Lucide Icons (optimiert für kleinere Größen)
- **Größen:** Desktop 24px, Tablet 20px, Mobile 20px

### Animationen
- Menu Toggle: 300ms smooth transition
- Submenu Expand: 200ms ease-in-out
- Navigation Slide: 250ms fade + slide

---

## 🔗 Routing-Struktur

```
/admin
├── /admin/home
├── /admin/salon
│   ├── /admin/salon/overview
│   ├── /admin/salon/employees
│   ├── /admin/salon/customers
│   ├── /admin/salon/pos
│   ├── /admin/salon/inventory
│   ├── /admin/salon/suppliers
│   ├── /admin/salon/consumption
│   ├── /admin/salon/loyalty
│   ├── /admin/salon/coupons
│   ├── /admin/salon/reports
│   ├── /admin/salon/seo
│   ├── /admin/salon/local-seo
│   └── /admin/salon/page-editor
├── /admin/gallery
│   ├── /admin/gallery/inspiration
│   ├── /admin/gallery/portfolio
│   └── /admin/gallery/upload
├── /admin/appointments
│   ├── /admin/appointments/calendar
│   ├── /admin/appointments/schedule
│   ├── /admin/appointments/bookings
│   ├── /admin/appointments/map
│   └── /admin/appointments/closures
├── /admin/chats
│   ├── /admin/chats/team
│   ├── /admin/chats/support
│   └── /admin/chats/announcements
└── /admin/profile
    ├── /admin/profile/account
    ├── /admin/profile/security
    ├── /admin/profile/notifications
    ├── /admin/profile/preferences
    ├── /admin/profile/payments
    ├── /admin/profile/subscription
    └── /admin/profile/settings
```

---

## 🗄️ Supabase Integration

### Tabellen die verwendet werden:
- `salons` - Salon-Informationen
- `employees` - Mitarbeiterdaten
- `customers` - Kundendaten
- `appointments` - Termine & Buchungen
- `conversations` - Chat/Nachrichten
- `gallery_photos` - Galerie-Fotos
- `coupons` - Gutscheine
- `inventory_items` - Lager-Verwaltung
- `activity_logs` - Audit Trail
- `user_permissions` - Berechtigungssystem
- `salon_settings` - Salon-Konfiguration

---

## 🎯 Implementierungs-Reihenfolge

### Sprint 1: Foundation
- [ ] Navigation Models erstellen
- [ ] Navigation Provider setup
- [ ] Navigation Layout Wrapper
- [ ] DesktopSidebar grundlegend

### Sprint 2: Mobile & Tablet
- [ ] Tablet Navigation
- [ ] Hamburger Menu
- [ ] Bottom Navigation Footer
- [ ] Responsive Testing

### Sprint 3: Hauptseiten
- [ ] Home Overview
- [ ] Salon Management Hub
- [ ] Gallery Overview
- [ ] Appointments Overview
- [ ] Chats overview
- [ ] Profile Settings

### Sprint 4: Unterseiten
- [ ] Salon Subpages (12 Screen)
- [ ] Gallery Subpages (3 Screens)
- [ ] Appointments Subpages (5 Screens)
- [ ] Chats Subpages (3 Screens)

### Sprint 5: Polish & Testing
- [ ] Navigation Links verknüpfen
- [ ] Responsive Design optimieren
- [ ] Berechtigungssystem integrieren
- [ ] Animationen feinabstimmen
- [ ] User Testing

---

## 📝 Notizen zu bestehenden Funktionen

### Bereits implementiert in React Site:
- AdminPage mit Module-Toggle
- Dashboard mit Stats
- Employee Time Tracking
- Activity Logs
- Salon Settings

### Zu portieren/erweitern:
- Employee Management (erweitern mit Rollen & Berechtigungen)
- Gallery (neuer Upload-UI)
- Booking Calendar (erweitern mit Map & Closures)
- Chat System (komplexer, nur Basic implementiert)
- Salon Management (neuer Hub mit mehreren Unterpunkten)

---

## 🔐 Berechtigungssystem

Navigation wird dynamisch basierend auf `user.permissions` gefiltert:
```dart
final canAccessSalon = user.permissions.contains('salon:manage');
final canAccessChats = user.permissions.contains('chat:access');
final canAccessReports = user.permissions.contains('reports:view');
```

---

## 📱 Mobile-First Considerations

- Bottom Navigation immer sticky (nicht scrollbar)
- Mindeststörke Buttons: 48x48px (Touch-friendly)
- Maximal 5 Icons in Bottom Nav
- Submenu in Full-Screen Overlay
- Swipe-Navigation optional für zukünftige Versionen

---

## ✅ Definition of Done

- [ ] Alle 6 Hauptmenüpunkte navigieren mit Submenu
- [ ] Desktop: Sidebar immer sichtbar
- [ ] Tablet: Collapsible Icon-Sidebar
- [ ] Mobile: Hamburger + Bottom Navigation
- [ ] Alle Links funktionieren
- [ ] Responsive auf allen Breakpoints
- [ ] Dark Mode unterstützt
- [ ] Navigation Berechtigungen integriert
- [ ] Dokumentation aktualisiert
- [ ] Tests geschrieben

---

**Nächster Schritt:** Datenmodelle implementieren
