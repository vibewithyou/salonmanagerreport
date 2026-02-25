# Route Matrix (Final) – 2026-02-21

Quelle: zentrale Router-Konfiguration in `lib/core/routing/app_router.dart`.

Statuswerte:
- **echter Screen**: produktiver Screen mit validem Ziel
- **feature-in-arbeit**: klare In-Work-Seite mit UX statt leerem Placeholder
- **redirect/alias**: gewollte Kompatibilitäts- oder Legacy-Weiterleitung
- **defekt (behoben)**: vorher ohne valides Ziel, jetzt aufgelöst

## 1) Public/Auth

| Route | Ziel | Status | Guard/Kommentar |
|---|---|---|---|
| `/splash` | `SplashScreen` | echter Screen | Public |
| `/role-loading` | `RoleLoadingScreen` | echter Screen | Public, aber unauth → `/entry` |
| `/entry` | `EntryScreenNew` | echter Screen | Public |
| `/login` | `LoginScreen` | echter Screen | Public |
| `/register` | `RegisterChoiceScreen` | echter Screen | Public |
| `/register/customer` | `RegisterCustomerScreen` | echter Screen | Public |
| `/register/owner` | `RegisterOwnerScreen` | echter Screen | Public |
| `/invite` | `InviteScreen` | echter Screen | Public |
| `/auth/forgot-password` | `ForgotPasswordScreen` | echter Screen | Public |
| `/booking/guest` | `GuestBookingScreen` | echter Screen | Public |
| `/auth` | `EntryScreenNew` | redirect/alias | Legacy-Kompatibilität |
| `/auth/login` | `/login` | redirect/alias | Legacy-Kompatibilität |
| `/auth/register` | `RegisterScreen` | echter Screen | Legacy-Pfad weiterhin gültig |

## 2) Core Booking & Dashboard Aliases

| Route | Ziel | Status | Guard/Kommentar |
|---|---|---|---|
| `/booking` | `BookingWizardScreenNew` | echter Screen | Auth für Shell-Flow nicht erforderlich |
| `/booking/availability` | `AvailabilityPickerScreen` | echter Screen | Auth-abhängig durch Global Redirect |
| `/booking/employee-selection` | `EmployeeSelectionScreen` | echter Screen | Auth-abhängig durch Global Redirect |
| `/dashboard` | `homeRouteForRole(role)` | redirect/alias | Rollenbasierter Adapter |
| `/admin-dashboard` | `/admin` | redirect/alias | Legacy-Kompatibilität |
| `/employee-dashboard` | `/employee` | redirect/alias | Legacy-Kompatibilität |

## 3) Protected Shell-Routen

| Route | Ziel | Status | Guard/Kommentar |
|---|---|---|---|
| `/select-salon` | `SalonSelectionScreen` | echter Screen | Auth; für Staff ohne Salon relevant |
| `/salon-setup` | `SalonSetupScreen` | echter Screen | Auth |
| `/admin` | `AdminDashboardScreen` | echter Screen | **admin-only** |
| `/employee` | `EmployeeDashboardScreen` | echter Screen | **staff-only** |
| `/customer` | `CustomerDashboardScreen` | echter Screen | **customer-only** |
| `/my-appointments` | `CalendarScreen` | echter Screen | Placeholder-Ziel entfernt |
| `/salon-map` | `SalonMapScreen` | echter Screen | Auth |
| `/salon-map-search` | `SalonMapSearchScreen` | echter Screen | Auth |
| `/salon-list-search` | `SalonListSearchScreen` | echter Screen | Auth |
| `/gallery` | `GalleryScreen` | echter Screen | Auth |
| `/inspiration` | `FeatureInProgressScreen` | feature-in-arbeit | Klare UX statt Stub |
| `/messages` | `ChatInboxScreen` | echter Screen | Auth |
| `/messages/:conversationId` | `ChatDetailScreen` | echter Screen | Auth |
| `/messages/:conversationId/info` | `ChatInfoScreen` | echter Screen | Auth |
| `/support` | `ChatInboxScreen(conversationType: support)` | echter Screen | Auth |
| `/conversations` | `/messages` | redirect/alias | **defekt (behoben)** |
| `/crm` | `CRMDashboardScreen` | echter Screen | **admin-only** |
| `/security-privacy` | `SecurityPrivacyScreen` | echter Screen | Auth |
| `/inventory` | `InventoryScreen` | echter Screen | **staff-only** + Salon-Kontext |
| `/pos` | `POSScreen` | echter Screen | **staff-only** + Salon-Kontext |
| `/reports` | `ReportsScreen` | echter Screen | **staff-only** + Salon-Kontext |
| `/settings` | `SettingsDashboard` | echter Screen | Auth |
| `/calendar` | `CalendarScreen` | echter Screen | Auth; Staff mit Salon-Check |
| `/schedule` | `FeatureInProgressScreen` | feature-in-arbeit | **staff-only** + Salon-Kontext |
| `/booking-map` | `/salon-map` | redirect/alias | Placeholder-Ziel entfernt |
| `/closures` | `FeatureInProgressScreen` | feature-in-arbeit | **admin-only** + Salon-Kontext |
| `/employees` | `EmployeeManagementScreen` | echter Screen | **admin-only** + Salon-Kontext |
| `/suppliers` | `FeatureInProgressScreen` | feature-in-arbeit | **admin-only** + Salon-Kontext |
| `/service-consumption` | `FeatureInProgressScreen` | feature-in-arbeit | **admin-only** + Salon-Kontext |
| `/loyalty-settings` | `FeatureInProgressScreen` | feature-in-arbeit | **admin-only** + Salon-Kontext |
| `/coupons` | `CouponsScreen` | echter Screen | **admin-only** |
| `/loyalty` | `FeatureInProgressScreen` | feature-in-arbeit | **customer-only**, **defekt (behoben)** |
| `/profile` | `ProfileDashboard` | echter Screen | Placeholder-Ziel entfernt |

## 4) Redirect-/Guard-Regeln (vereinheitlicht)

- Auth-Flow: Public-Routen bleiben offen; geschützte Routen ohne Auth → `/entry`.
- Identity-Loading: Geschützte Ziele blockieren sauber auf `/role-loading`.
- Rollen-Flow:
  - admin-only Prefixe (z. B. `/admin`, `/crm`, `/employees`, `/suppliers`, ...)
  - staff-only Prefixe (z. B. `/employee`, `/inventory`, `/pos`, `/reports`, `/schedule`)
  - customer-only Prefixe (`/customer`, `/loyalty`)
- Salon-Kontext: Für Non-Customer auf salon-relevanten Prefixen ohne `currentSalonId` → `/select-salon`.
- Loop-Schutz: Redirects laufen über eine Guard-Funktion, die kein Redirect ausführt, wenn Ziel = aktuelle Route.

## 5) Ergebnis gegen Abnahmekriterien

- Produktiv erreichbare Routen haben valide Ziele.
- Keine `Placeholder()`-Ziele mehr im produktiven Router.
- Defekte Navigationsziele korrigiert:
  - Nav: `Gespräche` zeigt auf `/messages`.
  - Alias: `/conversations` → `/messages`.
  - Customer Loyalty hat nun gültige Route (`/loyalty`).
