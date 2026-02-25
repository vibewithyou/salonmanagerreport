# Architectural Decisions

Use this file to record any decisions or assumptions made during development that impact the project's architecture, data model or functionality.  Provide the date and a brief rationale for each decision.  Recording decisions here helps future developers understand the rationale behind design choices.

## Decision Log

- **2026‑02‑22**: Placeholder entry – no decisions have been made yet.  Replace this line with your first real decision when necessary.
- **2026-02-22**: Admin-Time-Tracking validiert vor jeder Buchung verpflichtend über `verify_employee_time_code` und erstellt Einträge über `create_dashboard_time_entry` (statt Placeholder/UI-only Erfolg). Grund: Konsistenz mit React-Flow (`dashboard/src/components/EmployeeTimeTracking.tsx`, `dashboard/src/services/api.ts`) und DB-Funktionen aus `backup.sql`.
- **2026-02-22**: Live-Liste „aktive Mitarbeiter“ per Polling (10s) in `time_tracking_tab.dart` umgesetzt, Datenquelle ist `get_daily_employee_workload` (RPC) aus `backup.sql`. Grund: Echtzeitnahe Übersicht wie in React `EmployeeTimeTracking.tsx`, ohne neue Parallelarchitektur.
- **2026-02-22**: Admin-Override „anderen Mitarbeiter ausstempeln“ verlangt doppelte Autorisierung: (1) aktueller User muss Admin-Rolle haben (`identity.roleKey` via `isAdminRole`) und (2) eingegebener Code muss zu Admin/Manager-Employee gehören (`employees.position`). Jede Override-Aktion schreibt Audit in `dashboard_activity_log` mit Verifizierer/Ziel.
- **2026-02-22**: Routing konsolidiert auf einen Admin-Primärpfad `kAdminPrimaryPath = '/admin'` in `app_router.dart`; Legacy-Pfade (`/admin-dashboard`, `/dashboard/admin`, `/dashboard/admin/:tab`, `/admin/home`) leiten explizit auf den Primärpfad weiter, inklusive Tab-Deep-Link-Mapping.
