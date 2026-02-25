# 🧭 Admin Navigation System - Usage Guide

## ✅ Implementierungsstatus

**Vollständig implementiert:**
- ✅ Navigation Models & Enum (40+ Seiten definiert)
- ✅ Navigation Configuration (JSON-basiert, 6 Hauptmenüs, 30+ Untermenüs)
- ✅ Navigation State Management (Riverpod mit 7 State-Methoden)
- ✅ Responsive Layout Wrapper (Desktop/Tablet/Mobile)
- ✅ Desktop Sidebar (erweiterbar/einklappbar)
- ✅ Mobile Bottom Navigation (sticky footer)
- ✅ Hamburger Menu (Slide-In Overlay mit Animation)
- ✅ Home Overview Screen (Beispiel-Integration)
- ✅ Freezed Code Generation (0 Errors)

**Status:** 182 issues (0 errors, nur info-level warnings)

---

## 📁 Projektstruktur

```
lib/features/admin_navigation/
├── config/
│   └── navigation_config.json          # JSON-Menüstruktur
├── models/
│   ├── navigation_item.dart            # Freezed Models & Enum
│   ├── navigation_item.freezed.dart    # Generated
│   └── navigation_item.g.dart          # Generated
├── providers/
│   └── navigation_providers.dart       # Riverpod State Management
└── widgets/
    ├── navigation_layout.dart          # Responsive Layout Wrapper
    ├── desktop_sidebar.dart            # Desktop/Tablet Sidebar
    ├── mobile_bottom_nav.dart          # Mobile Sticky Footer
    └── mobile_hamburger_menu.dart      # Mobile Overlay Menu

lib/features/home/presentation/
└── home_overview_screen.dart           # Beispiel-Integration
```

---

## 🚀 Verwendung

### 1. Screen mit Navigation Wrapper erstellen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../admin_navigation/widgets/navigation_layout.dart';
import '../../admin_navigation/models/navigation_item.dart';

class MeinScreen extends ConsumerWidget {
  const MeinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationLayout(
      page: NavigationPage.home, // <-- Aktuelle Seite definieren
      child: _buildContent(context, ref),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Mein Screen Content'),
          // Dein Content hier...
        ],
      ),
    );
  }
}
```

### 2. Programmgesteuerte Navigation

```dart
// In jedem ConsumerWidget:
final navNotifier = ref.read(navigationStateProvider.notifier);

// Zu einer Seite navigieren:
navNotifier.navigateToPage(NavigationPage.salonEmployees);

// Menü erweitern/einklappen:
navNotifier.toggleMenu('salon');

// Mobile Sidebar öffnen/schließen:
navNotifier.toggleMobileSidebar();
navNotifier.closeMobileSidebar();

// Desktop Sidebar erweitern/einklappen:
navNotifier.toggleDesktopSidebar();

// Zurück zur vorherigen Seite:
navNotifier.goBack();

// Komplett zurücksetzen:
navNotifier.reset();
```

### 3. Navigation State auslesen

```dart
// Aktuellen Navigation State lesen:
final navState = ref.watch(navigationStateProvider);

print(navState.currentPage);              // NavigationPage.home
print(navState.expandedMenuIds);          // ['salon', 'gallery']
print(navState.navigationHistory);        // [home, salon, employees]
print(navState.isMobileSidebarOpen);      // true/false
print(navState.isDesktopSidebarExpanded); // true/false

// Alle Menü-Items abrufen:
final allItems = ref.watch(navigationItemsProvider);

// Nur 5 Hauptmenüs für Bottom Nav:
final bottomItems = ref.watch(bottomNavigationItemsProvider);

// Aktuell aktives NavigationItem:
final currentItem = ref.watch(currentNavigationItemProvider);
```

---

## 📱 Responsive Verhalten

### Desktop (> 1024px)
- **Persistent Sidebar** (links, immer sichtbar)
- Erweiterbar/einklappbar per Toggle Button
- Erweitert: Icons + Labels
- Eingeklappt: Nur Icons
- Header mit Breadcrumb

### Tablet (768px - 1024px)
- **Icon-only Sidebar** (links, immer sichtbar)
- Gleiche Funktionalität wie Desktop
- Kompaktere Darstellung
- Header mit Breadcrumb

### Mobile (< 768px)
- **Hamburger Menu** (Slide-In von links)
  - Öffnen: Hamburger Icon oben links
  - Schließen: X-Button oder Backdrop Tap
  - Vollständige Menü-Hierarchie
  - Slide-In Animation (300ms)
  
- **Sticky Bottom Navigation** (immer sichtbar)
  - 5 Hauptmenüs: Home, Salon, Galerie, Termine, Profil
  - Icons + Labels
  - Badge-Support
  - Bleibt fixiert beim Scrollen ✅

---

## 🎨 Verfügbare Seiten (NavigationPage Enum)

### Hauptmenüs (6)
```dart
NavigationPage.home             // Dashboard Übersicht
NavigationPage.salon            // Salon-Verwaltung Hub
NavigationPage.gallery          // Galerie Hub
NavigationPage.appointments     // Termin-Verwaltung Hub
NavigationPage.chats            // Chat-System Hub
NavigationPage.profile          // Profil-Einstellungen Hub
```

### Salon-Untermenüs (13)
```dart
NavigationPage.salonOverview    // Meine Salons
NavigationPage.salonEmployees   // Mitarbeiter
NavigationPage.salonCustomers   // Kunden
NavigationPage.salonPos         // Kasse (POS)
NavigationPage.salonInventory   // Lager
NavigationPage.salonSuppliers   // Lieferanten
NavigationPage.salonConsumption // Verbrauch
NavigationPage.salonLoyalty     // Loyalty-Programm
NavigationPage.salonCoupons     // Coupons
NavigationPage.salonReports     // Berichte
NavigationPage.salonSeo         // SEO Dashboard
NavigationPage.salonLocalSeo    // Lokales SEO
NavigationPage.salonPageEditor  // Seiten Editor
```

### Galerie-Untermenüs (3)
```dart
NavigationPage.galleryInspiration  // Inspiration
NavigationPage.galleryGallery      // Galerie
NavigationPage.galleryUpload       // Upload
```

### Termin-Untermenüs (5)
```dart
NavigationPage.appointmentsCalendar   // Kalender
NavigationPage.appointmentsSchedule   // Zeitplan
NavigationPage.appointmentsBookings   // Buchungen
NavigationPage.appointmentsMap        // Karte
NavigationPage.appointmentsClosures   // Schließungen
```

### Chat-Untermenüs (3)
```dart
NavigationPage.chatsTeam           // Team Chat
NavigationPage.chatsSupport        // Support
NavigationPage.chatsAnnouncements  // Ankündigungen
```

### Profil-Untermenüs (7)
```dart
NavigationPage.profileMyProfile      // Mein Profil
NavigationPage.profileSecurity       // Sicherheit
NavigationPage.profileNotifications  // Benachrichtigungen
NavigationPage.profilePreferences    // Voreinstellungen
NavigationPage.profilePayment        // Zahlungsmethoden
NavigationPage.profileSubscription   // Abo & Lizenz
NavigationPage.profileAdvanced       // Erweiterte Einstellungen
```

---

## 🔧 Anpassungen

### Neue Seite hinzufügen

#### 1. NavigationPage Enum erweitern
```dart
// lib/features/admin_navigation/models/navigation_item.dart
enum NavigationPage {
  // ... existing pages
  meinNeuesFeature,  // <-- Hinzufügen
}
```

#### 2. Extension aktualisieren
```dart
extension NavigationPageExtension on NavigationPage {
  String get route {
    switch (this) {
      // ... existing cases
      case NavigationPage.meinNeuesFeature:
        return '/admin/mein-feature';
      // ...
    }
  }

  String get label {
    switch (this) {
      // ... existing cases
      case NavigationPage.meinNeuesFeature:
        return 'Mein Feature';
      // ...
    }
  }
}
```

#### 3. navigation_config.json erweitern
```json
{
  "id": "mein-feature",
  "label": "Mein Feature",
  "icon": "new_releases",
  "page": "meinNeuesFeature",
  "route": "/admin/mein-feature",
  "isVisible": true,
  "requiredPermission": "feature.view"
}
```

#### 4. navigationItemsProvider aktualisieren
```dart
// lib/features/admin_navigation/providers/navigation_providers.dart
final navigationItemsProvider = Provider<List<NavigationItem>>((ref) {
  return [
    // ... existing items
    NavigationItem(
      id: 'mein-feature',
      label: 'Mein Feature',
      icon: Icons.new_releases_rounded,
      page: NavigationPage.meinNeuesFeature,
      route: '/admin/mein-feature',
    ),
  ];
});
```

#### 5. Build Runner ausführen
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🎯 Nächste Schritte

### Empfohlene Umsetzung:

1. **Routing System integrieren** (go_router oder Navigator 2.0)
   - Route Guards für Authentifizierung
   - Deep Linking Support
   - Browser Back-Button Support (Web)

2. **Permission System implementieren**
   - `requiredPermission` Field prüfen
   - Menü-Items basierend auf User-Rolle filtern
   - Access Control für Screens

3. **Alle Subpage Screens erstellen**
   - 13 Salon Screens
   - 3 Galerie Screens
   - 5 Termin Screens
   - 3 Chat Screens
   - 7 Profil Screens

4. **Badge-System aktivieren**
   - Notification Count für Chats
   - Pending Tasks für Dashboard
   - Unread Messages

5. **Animationen verfeinern**
   - Page Transitions
   - Menu Expand/Collapse
   - Hover Effects (Desktop)

6. **Testing**
   - Widget Tests für alle Navigation Components
   - Integration Tests für Navigation Flow
   - Responsive Tests (verschiedene Bildschirmgrößen)

---

## 📚 Technische Details

### State Management
- **Provider:** `StateNotifierProvider<NavigationStateNotifier, NavigationState>`
- **Immutability:** Freezed Models mit `copyWith()`
- **Side Effects:** Keine - Pure State Management

### Responsive Breakpoints
```dart
final isDesktop = screenWidth > 1024;
final isTablet = screenWidth >= 768 && screenWidth <= 1024;
final isMobile = screenWidth < 768;
```

### Animation Durations
- Sidebar Toggle: **250ms** (easeInOut)
- Hamburger Slide-In: **300ms** (easeInOut)
- Menu Expand: **200ms** (easeIn)

### Performance
- **Lazy Loading:** Nur sichtbare Menü-Items rendern
- **Const Widgets:** Wo möglich für bessere Performance
- **Selective Rebuilds:** Nur betroffene Widgets neu rendern

---

## 🐛 Bekannte Limitationen

1. **Routing nicht implementiert** - Derzeit nur State Management, keine echten Route Changes
2. **Permission System Placeholder** - `requiredPermission` wird nicht geprüft
3. **User Profile Hardcoded** - Footer zeigt "Admin User" (TODO: User Provider integrieren)
4. **Badge Values Hardcoded** - Keine echten Notification Counts

---

## 💡 Best Practices

### DO ✅
- `NavigationLayout` als Wrapper für alle Admin Screens verwenden
- `NavigationPage` Enum für Type-Safety nutzen
- Navigation State über Provider verwalten
- Responsive Breakpoints konsistent verwenden

### DON'T ❌
- Nicht direkt `setState()` für Navigation verwenden
- Keine eigenen Sidebar/BottomNav Widgets bauen
- Nicht mehrere `NavigationLayout` Wrapper verschachteln
- Keine hardcoded Routes - immer `NavigationPage` Enum nutzen

---

## 📞 Support & Dokumentation

**Vollständige Architektur-Dokumentation:**
`kontext/NAVIGATION_ARCHITECTURE_PLAN.md`

**Fragen?** 
Siehe Inline-Dokumentation in:
- `navigation_item.dart` - Models & Enum
- `navigation_providers.dart` - State Management
- `navigation_layout.dart` - Layout Logic

---

**Version:** 1.0.0  
**Letztes Update:** 2025-01-XX  
**Status:** ✅ Production Ready (UI Components)  
**Next Milestone:** Routing Integration
