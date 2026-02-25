# Flutter SalonManager Skill

Ein umfassender Skill für die Migration und Entwicklung der **SalonManager** Flutter-App basierend auf dem vollständigen React Vite Projekt.

## 📋 Was ist dieser Skill?

Dieser Skill enthält:
- **Architektur-Patterns**: React → Flutter Migration
- **State Management**: TanStack Query → Riverpod
- **UI-Komponenten**: shadcn/ui → Flutter Material 3
- **Supabase Integration**: Best Practices
- **Feature-spezifische Guidance**: Gallery, Booking, Chat, POS, etc.
- **Migration Checkliste**: 10 Phasen für vollständige Umsetzung

## 🎯 Verwendung

Claude liest automatisch diesen Skill, wenn du an der Flutter-App arbeitest.

**Beispiel-Prompts:**
- "Implementiere die Gallery-Seite mit Filtern"
- "Erstelle den Booking Wizard"  
- "Migriere den Chat von React zu Flutter"
- "Setup Riverpod für Authentication"

## 📚 Inhalt

### Architektur
- Feature-basierte Struktur
- Clean Architecture Patterns
- Riverpod State Management
- GoRouter Navigation

### React → Flutter Mappings
- Komponenten (Button, Input, Dialog, etc.)
- State Management (useState → StateProvider)
- Hooks (useEffect → ref.listen)
- Routing (React Router → GoRouter)

### Supabase
- Client Setup
- Authentication
- Realtime Subscriptions
- Storage (File Upload)
- RLS Policies

### Features
- **Gallery**: Masonry Grid, AI Suggestions, Filters
- **Booking**: Multi-Step Wizard, Availability
- **Chat**: Real-time Messaging
- **Maps**: Google Maps Integration
- **Dashboard**: Role-based Views
- **POS**: Point of Sale Terminal

## 🚀 Quick Start

1. **Lies das SKILL.md** für vollständige Dokumentation
2. **Folge der Migration Checkliste** (10 Phasen)
3. **Verwende Code-Patterns** aus den Beispielen

## 📦 Dependencies

Alle benötigten Packages sind im Skill dokumentiert:
- flutter_riverpod
- supabase_flutter
- go_router
- freezed
- google_maps_flutter
- easy_localization
- und mehr...

## 🎓 Learning Resources

- Flutter Docs
- Riverpod Docs
- Supabase Flutter Guide
- React to Flutter Guide (im Skill enthalten)

---

**Version:** 1.0  
**Erstellt:** 15.02.2026  
**Basis:** salonmanager1-2 (React Vite)