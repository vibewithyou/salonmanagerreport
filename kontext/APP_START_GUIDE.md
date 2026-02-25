# App-Start Anleitung

## Problem: Web-Browser Zeitüberschreitung

Die App versuchte im Chrome-Browser zu starten, was zu Verbindungsproblemen führte.

## Lösung: Windows Desktop oder Emulator verwenden

### Windows Desktop (empfohlen)

**Voraussetzung**: Developer Mode muss aktiviert sein

```powershell
# 1. Developer Mode aktivieren
start ms-settings:developers

# Im sich öffnenden Fenster: "Entwicklermodus" einschalten

# 2. App starten
flutter run -d windows
```

### Alternative: Android Emulator

Falls Sie Android Studio installiert haben:

```bash
# 1. Emulator starten
# - Android Studio öffnen
# - Device Manager → Create Device
# - Oder einen bestehenden Emulator starten

# 2. App auf Emulator starten
flutter run
```

### Alternative: Chrome (mit Fehlerbehebung)

Falls Sie Web bevorzugen:

```bash
# Chrome mit spezifischen Flags
flutter run -d chrome --web-renderer html

# Oder Edge
flutter run -d edge
```

## Nach Developer Mode Aktivierung

Wenn der Developer Mode aktiviert ist:

```bash
# Build bereinigen
flutter clean
flutter pub get

# App auf Windows starten
flutter run -d windows
```

## Verfügbare Devices prüfen

```bash
flutter devices
```

Gibt eine Liste verfügbarer Geräte aus:
- Windows (PC)
- Chrome (Browser)
- Edge (Browser)
- Android Emulator (falls konfiguriert)
- iOS Simulator (nur auf macOS)

## Troubleshooting

**Symlink-Fehler**:
- Developer Mode aktivieren (siehe oben)

**Chrome-Timeout**:
- Auf Windows Desktop wechseln
- Oder `flutter run -d chrome --web-renderer html` versuchen

**Keine Geräte verfügbar**:
- Android Studio installieren für Emulatoren
- Visual Studio für Windows-Desktop-Support

---

**Empfohlener Start-Befehl**: `flutter run -d windows`
