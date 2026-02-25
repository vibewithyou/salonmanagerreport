# React-Site vs Flutter-App – Funktionsanalyse & Gap-Plan

Datum: 2026-02-21

## 1) Analyse-Scope

Verglichen wurden:
- kompletter react_site-Ordner unter react_site/salonmanager1-2-feature-booking-completion
  - dashboard/src (direkt lesbarer Source-Code)
  - Root-Dokumentation + E2E-Specs
  - dist/assets (Build-Bundle als Laufzeit-Evidenz)
- Flutter-App unter lib/ mit Fokus auf Admin-, Employee- und Customer-Dashboards

Wichtige Einschränkung:
- Im React-Root fehlt der ursprüngliche src-Ordner (nur dist-Bundle, docs, e2e, dashboard vorhanden). Deshalb wurde mit Evidenzstufen gearbeitet:
  1) direkt lesbarer Source (höchste Sicherheit)
  2) dist-Bundle mit Source-Mapping-Strings (mittlere Sicherheit)
  3) docs/e2e Aussagen (niedrigere Sicherheit)
- In beiden Codebasen existieren parallel mehrere Dashboard-Implementierungen (historisch/alt/neu). Für die Bewertung wurde vor allem das berücksichtigt, was aktuell über Routing erreichbar bzw. klar als aktive Struktur genutzt wird.

---

## 2) React: Was ist wirklich implementiert?

Hinweis zur Lesart:
- "Stabil implementiert" = direkt in Source geprüft
- "Nachweisbar außerhalb Source" = im dist-Bundle und/oder E2E/docs belegt, aber nicht als Root-src einsehbar

## 2.1 Stabil implementiert

- Auth + Session (Zustand)
  - Salon-Login mit Salon-Code
  - Employee-Login mit Time-Code
  - Session Restore über localStorage (24h)
- Rollenrouting
  - Admin geschützt über /admin
  - Dashboard geschützt über /
- Admin Kernfunktionen
  - Modul-Aktivierung/-Deaktivierung
  - Salon-Code anzeigen/kopieren/resetten (mit Bestätigung)
  - Mitarbeiter-Codes generieren + kopieren
  - Mitarbeiter hinzufügen/entfernen
  - Aktivitätslog anzeigen
- Employee Time Tracking
  - Clock-in/out, Break start/end
  - Aktive Mitarbeiter inkl. Status/Arbeitszeit
  - Serveranbindung über Supabase RPC/Functions

## 2.2 Teilweise / Placeholder

- Dashboard Module Kalender, Kunden, POS sind in der Hauptseite als „Kommt bald“ markiert
- Komponenten für Kalender/Kunden/POS existieren, sind aber Placeholder („wird noch implementiert“)

## 2.3 Auffälligkeiten

- README behauptet teils mehr Fertigstellung als im gerouteten UI sichtbar
- Einige Hooks/Dateien wirken aus größerem React-Kontext übernommen (nicht zwingend aktiv in dieser Dashboard-App)

## 2.4 Nachweisbar außerhalb dashboard/src (dist/docs/e2e)

Im vollständigen react_site sind zusätzlich belegbar:
- Routen/Flows: /booking, /conversations bzw. /conversation/:id, /salon-setup, /booking-map, /calendar, /schedule, /inventory, /suppliers, /gallery
- POS/Transaktionen/Rechnung: POSDashboard, TransactionHistory, Invoice-Nummern-Logik, Refund-/Invoice-Flows
- Compliance (DSGVO/GoBD): GDPR Export/Löschantrag inkl. Audit- und Aufbewahrungslogik
- E2E-Szenarien für Booking, Chat, Maps und Time-Tracking

Bewertung:
- React-Gesamtsystem ist deutlich breiter als nur die kleine dashboard/src-App.
- Praktisch liegt derzeit ein „Source-Split“ vor: ein Teil als lesbarer Source, ein größerer Teil nur als Build-Artefakt + Dokumentation.

---

## 3) Flutter: Was ist schon gut / stark?

## 3.1 Sehr stark bzw. über React hinaus

- Rollen- und Zugriffslogik (GoRouter + Guards)
  - Feingranulare Rollen (admin/owner/manager/stylist/employee/customer)
  - Striktes Redirect-Verhalten
  - Salon-Auswahl-Checks
- Multi-Dashboard Architektur
  - Admin, Employee, Customer getrennt
- Customer-Dashboard
  - Quick Actions, Termine-Liste, Booking-Navigation
- Chat-Modul
  - Sehr umfangreiche Struktur (Inbox, Detail, Info, Provider/Repository, Realtime-Ansatz)
- Admin Business-Module
  - Kundenverwaltung (eigene Notifier/State/Data-Layer)
  - Coupons-Modul (umfangreiche UI + State)
  - Modul-Management, Salon-Code-Manager, Employee-Code-Generator, Activity-Log als Tabs vorhanden

## 3.2 Architekturstärken

- Riverpod + Repository/Service-Aufteilung
- GoRouter Shell + Role-basiertes Routing
- Theme/Localization bereits integriert

---

## 4) Flutter: Wo sind die Lücken / Risiken?

## 4.1 Inkonsistente Dashboard-Landschaft (wichtigstes Problem)

Es gibt mehrere parallele Dashboard-Screens mit ähnlichen Namen, z. B.:
- features/admin/dashboard/admin_dashboard_screen.dart
- features/dashboard/presentation/admin_dashboard_screen.dart
- features/employee/presentation/employee_dashboard_screen.dart
- features/employee/dashboard/employee_dashboard_screen.dart

Risiko:
- Unterschiedliche Implementierungsstände
- Schwer nachvollziehbar, welches Dashboard „source of truth“ ist

## 4.2 Platzhalter in aktivem Routing

- In app_router.dart sind mehrere Routen noch Placeholder (z. B. /calendar, /schedule, /profile etc.)
- Das erzeugt UX-Brüche trotz vorhandener Module an anderer Stelle

## 4.3 Employee Dashboard (geroutete Variante) noch nicht datenreif

- In der gerouteten Employee-Implementierung liegen Daten-Platzhalter am Dateiende:
  - _appointments = []
  - _timeEntries = []
  - _leaveRequests = []
- UI wirkt weit gebaut, aber Datenbindung ist noch nicht final

## 4.4 Admin-Dashboard enthält viele „Coming Soon“-Tabs

Im aktuell gerouteten Admin-Dashboard sind mehrere Tabs als Coming Soon umgesetzt (z. B. Termine, Services, Inventar, Galerie, Marketing, Reports, Zeit, Settings), obwohl in anderen Teilen der App dafür bereits Module existieren.

---

## 5) Gap-Matrix React vs Flutter

## 5.1 Auth & Rollen

- React: einfacher (admin/employee), dafür klar im Dashboard-Kontext
- Flutter: deutlich stärker (mehr Rollen, Guards, Redirects)

Bewertung:
- Flutter besser (Architektur)
- React besser fokussiert auf Dashboard-Codes (Salon-/Time-Code-Usecase in einem Flow)

## 5.2 Admin Control Center (Module/Codes/Employees/Activity)

- React: kompakt und in einem Screen konsistent nutzbar
- Flutter: Features existieren, aber verteilt und teils in konkurrierenden Dashboard-Versionen

Bewertung:
- Funktional ähnlich/teils stärker in Flutter, aber UX/Struktur aktuell weniger konsistent

## 5.3 Employee Dashboard

- React: nur Time Tracking wirklich produktiv
- Flutter: viel mehr Oberfläche + geplante Features, aber gerouteter Screen teilweise mit Platzhalterdaten

Bewertung:
- Flutter strategisch besser, operativ noch nicht durchgängig „live-data ready“

## 5.4 Customer Dashboard

- React Dashboard-App: nicht vorhanden
- Flutter: vorhanden und integriert

Bewertung:
- Flutter klar voraus

## 5.6 POS / Rechnungen / Compliance

- React (gesamt): durch dist/docs klar belegbar (POS, Invoice/Refund, GDPR/GoBD-Flows)
- Flutter: im aktuell geprüften Dashboard-Kontext nicht in vergleichbarer End-to-End-Tiefe belegt

Bewertung:
- Hier hat React (gesamt) aktuell einen Vorsprung in nachweisbarer Breite.
- Flutter sollte diese Lücke nicht nur als UI-Tabs, sondern mit vollständigen Daten-/Prozessketten schließen.

## 5.5 Chat

- React Dashboard-App: nicht zentral implementiert
- Flutter: umfangreiches Modul

Bewertung:
- Flutter klar voraus

---

## 6) Konkreter Verbesserungsplan (priorisiert)

## Phase A (höchste Priorität, 1–2 Wochen)

0. React-Quellstand sauberstellen (für belastbaren Vergleich)
- Fehlenden Root-src im react_site klären (separates Repo/Branch/Export?)
- Ziel: eine überprüfbare Source of Truth statt dist+docs-only für Kernmodule

1. Dashboard-Konsolidierung (Flutter)
- Ein aktives Admin-Dashboard und ein aktives Employee-Dashboard als Source of Truth festlegen
- Doppelte/alte Varianten markieren oder entfernen
- Router auf die finalen Screens ausrichten

2. Placeholder-Routen schließen
- /schedule, /profile, /calendar usw. auf echte Screens routen
- Falls noch nicht fertig: klare „Feature in Arbeit“-Seite statt Flutter Placeholder()

3. Employee Live-Data anschließen
- Geroutetes Employee-Dashboard von lokalen Placeholder-Listen auf Provider/Repository umstellen
- Mindestziel: Termine, Time Entries, Leave Requests live

## Phase B (hoch, 2–4 Wochen)

4. Admin-Tab-Realignment
- Coming-Soon Tabs im gerouteten Admin-Dashboard sukzessive mit bereits vorhandenen Modulen ersetzen
- Bereits fertige Tabs (Customers, Coupons, Module, Codes, Activity) als Standard aktiv

5. React-Parität gezielt absichern
- Prüfen: Salon-Code-Reset, Employee-Code-Generierung, Activity-Filter, Employee CRUD in finalem Flutter-Admin-Flow vollständig und UX-stabil

## Phase C (mittel, 4+ Wochen)

6. Qualitäts- und Konsistenzphase
- Einheitliche Design-Tokens zwischen Dashboards
- E2E Smoke-Flows je Rolle (admin/employee/customer)
- Monitoring/Logging für kritische Admin-Aktionen

7. Parität für React-Gesamtfeatures
- Flutter-Roadmap für POS/Invoice/Refund/Compliance klar priorisieren
- Keine "Coming Soon"-Tabs für Features, die in React produktnah genutzt werden

---

## 7) Kurzfazit

- Bei reinem dashboard/src-Scope ist Flutter funktional insgesamt weiter (Rollenmodell, Customer, Chat, modulare Data-Layer).
- Beim vollständigen react_site zeigt sich jedoch: React hat zusätzlich belegbare produktnahe Bereiche (u. a. POS, Rechnungen, DSGVO/GoBD), die in Flutter aktuell nicht gleichwertig integriert nachweisbar sind.
- Hauptproblem in Flutter ist weniger Feature-Idee, sondern Konsolidierung + saubere End-to-End-Integration im aktiven Routing.

Empfehlung:
- Erst konsolidieren, dann erweitern.
- Sobald Routing + Dashboard-Source-of-Truth sauber ist und die POS/Compliance-Kette live integriert ist, kann Flutter React auch im operativen Dashboard-Alltag klar überholen.
