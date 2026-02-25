# Dashboard Architecture Freeze (Prompt 1/6)

Date: 2026-02-21

## Zielbild (Source of Truth)

Es gibt genau einen produktiven Einstieg pro Rolle:

- **Admin Dashboard (aktiv):** `/admin` → `lib/features/admin/dashboard/admin_dashboard_screen.dart`
- **Employee Dashboard (aktiv):** `/employee` → `lib/features/employee/presentation/employee_dashboard_screen.dart`

Die Rollen-/Auth-Guards bleiben unverändert in `lib/core/routing/app_router.dart` + `lib/core/auth/user_role_helpers.dart`.

## Entscheidungsmatrix

### Admin Dashboard Varianten

- `lib/features/admin/dashboard/admin_dashboard_screen.dart`  
  **Status:** Behalten (Source of Truth)  
  **Begründung:** Einziger produktiv verdrahteter Admin-Entry im Router.

- `lib/features/admin/presentation/admin_dashboard_screen.dart`  
  **Status:** Löschen  
  **Begründung:** Nicht im produktiven Router importiert, parallel/legacy Implementierung.

- `lib/features/admin/admin_dashboard_screen.dart`  
  **Status:** Löschen  
  **Begründung:** Nicht im produktiven Router importiert, legacy Struktur.

- `lib/features/dashboard/presentation/admin_dashboard_screen.dart`  
  **Status:** Löschen  
  **Begründung:** Nicht im produktiven Router importiert, doppelter Admin-Screen.

### Employee Dashboard Varianten

- `lib/features/employee/presentation/employee_dashboard_screen.dart`  
  **Status:** Behalten (Source of Truth)  
  **Begründung:** Einziger produktiv verdrahteter Employee-Entry im Router.

- `lib/features/employee/dashboard/employee_dashboard_screen.dart`  
  **Status:** Löschen  
  **Begründung:** Nicht im produktiven Router importiert, duplicate Implementierung.

- `lib/features/dashboard/presentation/employee_dashboard_screen.dart`  
  **Status:** Löschen  
  **Begründung:** Nicht im produktiven Router importiert, legacy Placeholder-Variante.

## Routing-Konsolidierung

In `lib/core/routing/app_router.dart` wurden dashboard-bezogene Kompatibilitäts-Adapter ergänzt:

- `/dashboard` → Redirect auf rollenbasiertes Ziel via `homeRouteForRole(roleKey)`
- `/admin-dashboard` → Redirect auf `/admin`
- `/employee-dashboard` → Redirect auf `/employee`

Damit bleiben ältere Dashboard-Pfade erreichbar, ohne zusätzliche aktive Dashboard-Implementierungen einzuführen.

## Vorher / Nachher

- **Vorher:** Mehrere Admin-/Employee-Dashboard-Dateien parallel vorhanden, nur ein Teil produktiv geroutet.
- **Nachher:** Genau ein produktiver Admin-Entry und ein produktiver Employee-Entry; Legacy-Implementierungen entfernt; Dashboard-Kompatibilität über Redirects gesichert.

## Entfernte Module/Dateien

- `lib/features/admin/presentation/admin_dashboard_screen.dart`
- `lib/features/admin/admin_dashboard_screen.dart`
- `lib/features/dashboard/presentation/admin_dashboard_screen.dart`
- `lib/features/employee/dashboard/employee_dashboard_screen.dart`
- `lib/features/dashboard/presentation/employee_dashboard_screen.dart`
