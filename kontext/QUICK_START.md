# Quick Start - Nach dem Umbau

## ✅ Was wurde umgesetzt

Die Flutter-App wurde erfolgreich umstrukturiert gemäß dem Umbauplan. Die wichtigsten Änderungen:

### 1. Neue Navigation
- ✅ go_router für deklaratives Routing
- ✅ NavigationRail (Desktop) / Drawer (Mobile)
- ✅ Automatisches Routing basierend auf User-Rolle
- ✅ Persistente Sidebar-State (SharedPreferences)

### 2. Authentifizierung
- ✅ Zentraler Auth-Service mit Riverpod
- ✅ Role-Based Access Control vorbereitet
- ✅ Auth-Guards im Router
- ✅ Automatische Redirects nach Login

### 3. Struktur
- ✅ Entry Screen als Startpunkt (Login/Register/Gast)
- ✅ Rollenbasierte Dashboards (Admin/Employee/Customer)
- ✅ Hierarchische Navigation-Items
- ✅ Gold/Black Theme bereits vorhanden

## 🚀 App starten

```bash
# Dependencies installieren (falls noch nicht geschehen)
flutter pub get

# App auf Device/Emulator starten
flutter run
```

## 📱 Navigation Flow

```
App Start
  ↓
Splash Screen
  ↓
Auth-Check → Nein → /auth (Entry Screen)
  ↓             ↓
  |          Login/Register/Gast-Buchung
  |             ↓
  ↓         Login erfolgreich
  |             ↓
  └──→ Rolle prüfen
          ↓
    ┌─────┼─────┐
    ↓     ↓     ↓
  Admin Empl. Customer
  /admin /empl /cust
    ↓     ↓     ↓
  [Dashboard mit Navigation Shell]
```

## 🎯 Nächste Schritte (empfohlen)

### Sofort
1. **App testen**
   ```bash
   flutter run
   ```
2. **Register-Screen anpassen** (analog zu Login)
3. **Auth-Flow testen** (Login → Dashboard)

### Kurzfristig (diese Woche)
4. **Admin-Dashboard erweitern**
   - Tabs hinzufügen
   - Statistik-Widgets
   - Schnellzugriff-Cards

5. **Kalender-Seite implementieren**
   - Erste funktionale Seite nach Dashboard
   - Termine-Übersicht

6. **Gast-Booking Wizard**
   - Mehrstufiger Prozess
   - Salon → Service → Zeit → Daten

### Mittelfristig (dieser Monat)
7. **Weitere Seiten implementieren**
   - Mitarbeiter-Verwaltung
   - Inventar
   - Berichte

8. **Backend API-Integration**
   - Laravel Endpoints verbinden
   - Real-time Updates

9. **Testing & Polish**
   - Widget-Tests
   - Bug-Fixes
   - UI-Verbesserungen

## 🛠️ Häufige Aufgaben

### Neue Seite hinzufügen

1. **Route in app_router.dart**:
```dart
GoRoute(
  path: '/neue-seite',
  builder: (context, state) => const NeueSeite(),
),
```

2. **Navigation-Item in navigation_items.dart**:
```dart
NavigationItem(
  label: 'Neue Seite',
  path: '/neue-seite',
  icon: LucideIcons.star,
),
```

3. **Screen erstellen**:
```dart
class NeueSeite extends StatelessWidget {
  const NeueSeite({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Neue Seite')),
      body: Center(child: Text('Inhalt')),
    );
  }
}
```

### Navigation verwenden

```dart
// Zu Route navigieren
context.go('/admin');

// Mit Parameter
context.go('/salon/$salonId');

// Zurück
context.pop();

// Ersetzen (z.B. nach Login)
context.go('/admin'); // Automatisch, da Router redirects
```

### Auth-Service nutzen

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authServiceProvider);
    final user = auth.currentUser;
    
    if (user == null) {
      return Text('Nicht eingeloggt');
    }
    
    return Text('Hallo ${user.firstName}');
  }
}
```

### Sidebar toggle

```dart
// Im Widget
IconButton(
  icon: Icon(Icons.menu),
  onPressed: () {
    ref.read(sidebarCollapsedProvider.notifier).toggle();
  },
)
```

## 📝 Dateien-Übersicht

### Neue wichtige Dateien
```
lib/
├── core/
│   ├── routing/
│   │   └── app_router.dart         ← Router-Config
│   └── navigation/
│       ├── app_shell.dart          ← Navigation-Layout
│       ├── navigation_items.dart   ← Menü-Struktur
│       └── sidebar_state_provider.dart
├── services/
│   └── auth_service.dart           ← Auth-Logik
└── main.dart                       ← MaterialApp.router
```

### Wichtige angepasste Dateien
```
lib/
├── main.dart                      ← go_router Integration
├── services/
│   └── supabase_service.dart     ← Provider hinzugefügt
├── providers/
│   └── salon_provider.dart       ← Duplikat entfernt
└── features/auth/presentation/
    └── login_screen.dart         ← go_router Navigation
```

## 🐛 Bekannte Issues

- `home_overview_screen.dart` verwendet alte Navigation → muss angepasst werden
- Einige Placeholder-Screens haben noch keine Implementierung
- Warnings in `employees_tab.dart` über `ref.refresh` Return-Value

## 📚 Dokumentation

- **Vollständige Doku**: `kontext/UMBAU_DOKUMENTATION.md`
- **Original Plan**: `kontext/umbauplan.md`

## 🆘 Hilfe

### App startet nicht?
```bash
# Dependencies aktualisieren
flutter pub get

# Flutter clean
flutter clean
flutter pub get
```

### Navigation funktioniert nicht?
- Prüfe ob go_router installiert ist
- Checke ob Router in main.dart verwendet wird
- Schaue in die Logs für Routing-Fehler

### Auth-Fehler?
- Supabase-Config prüfen (`lib/core/config/supabase_config.dart`)
- User-Model und Auth-Service synchron?
- Token in SharedPreferences gespeichert?

---

**Viel Erfolg! 🚀**

Bei Fragen zur Implementierung siehe `UMBAU_DOKUMENTATION.md`
