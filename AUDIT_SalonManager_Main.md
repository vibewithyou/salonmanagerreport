# SalonManager – Main Audit

> Audit-Datum: $(date -u +"%Y-%m-%d %H:%M UTC")  
> Geprüfter Ist-Stand: lokaler Git-Branch `work` (Branch `main` existiert in diesem Klon nicht; Checkout/Pull auf `main` war daher nicht möglich).

## A) Repo Summary (Main)

- **Flutter Architektur**: Riverpod + go_router + Supabase vorhanden, Feature-Slices unter `lib/features/*`, zentrale Core-Layer (`lib/core/*`) und Service-Layer (`lib/services/*`).
- **Supabase Integration**: Init in `lib/main.dart` via `SupabaseService.initialize()`, Konfiguration in `lib/core/config/supabase_config.dart`.
- **Rollen/Guards**: Redirects/Role-Gates in `lib/core/routing/app_router.dart` + Role-Helper in `lib/core/auth/user_role_helpers.dart`.
- **Active Salon Context**: via `IdentityState.currentSalonId` in `lib/core/auth/identity_provider.dart`; Router blockt bestimmte Routen ohne gewählten Salon.
- **Abweichung zu Soll-Rollenmodell**: Soll nennt `owner, platform_admin, salon_owner, salon_manager, stylist, customer`; Code nutzt primär `admin, owner, manager, stylist, employee, customer` und mappt `platform_admin -> admin`, `salon_owner -> owner`.

---

## B) Database / Supabase Audit

### B1 Tabellen-Übersicht (aus `backup.sql` + `supabase/schema`)

| Tabelle (Auszug kritisch) | salon_id vorhanden? | Bemerkung |
|---|---:|---|
| appointments | ja | Booking-Kern vorhanden |
| employees | ja | Mitarbeiter-Mandant vorhanden |
| leave_requests | nein (laut Backup) | Konflikt: Services erwarten teils `salon_id` |
| time_entries | unklar/inkonsistent | unterschiedliche Spaltennutzung (`timestamp` vs `check_in/check_out`) |
| work_schedules | nein (laut Backup) | Service versucht Fallback ohne salon_id |
| customer_profiles | ja | CRM-Basis vorhanden |
| customer_notes (schema) | ja | staff-only RLS in `022_customer_notes.sql` |
| booking_media (schema) | ja | RLS aktuell `using(true)`/`with check(true)` -> zu offen |
| invoices / invoice_items / payments (schema) | invoices: ja | POS-MVP Tabellen + Policies vorhanden |
| salon_tax_config / product_tax_overrides (schema) | salon_tax_config: ja | Steuerkonfig vorhanden |
| consents (schema) | nein | user-zentriert statt salon-zentriert |
| gdpr_requests (schema) | nein | user-zentriert |
| gallery_images / gallery_likes / gallery_saved | gallery_images: ja; likes/saved: nein | Multi-tenant-Risiko für Likes/Saves |
| notification_logs / scheduled_notifications | nein | Notification-Datenmodell vorhanden, aber ohne salon_id |

Zusätzlich in `backup.sql` gefunden: Storage Buckets `avatars`, `img`, `gallery` (public), `chat` (private), `booking-images` (private), `ai-suggestions` (private).

### B2 RLS/Policies Audit

- **Kritisch**: In `backup.sql` wurden **keine** `CREATE POLICY` / `ENABLE ROW LEVEL SECURITY` Statements gefunden (nur in separaten `supabase/schema/*.sql` und zwei Migrationen).
- Positiv vorhanden in `supabase/schema`:
  - `customer_notes` staff-only policies (`022_customer_notes.sql`)
  - POS policies (`025_pos_mvp.sql`)
  - Tax policies (`026_tax_config.sql`)
  - Consent/GDPR own-user policies (`027/028`)
- **Falsch/zu offen**:
  - `booking_media` policy erlaubt jedem authenticated User SELECT/INSERT ohne Salonbindung (`023_before_after_media.sql`).
- **Mandanten-Risiko**:
  - Mehrere Kern-Tabellen aus Backup ohne klar nachweisbare RLS im Dump (z. B. `appointments`, `customer_profiles`, `time_entries`, `work_schedules`, `messages`).

### B3 RPC / Edge Functions

- **RPC Nutzung im App-Code**:
  - `has_free_slot` in `lib/features/bookings/data/booking_repository.dart` (Availability Check).
- **Edge Functions vorhanden (Auszug)**:
  - Workforce/QR/Code: `verify-employee-time-code`, `time-entry-event`, `verify-employee`, `set/get-*code`
  - Billing: `create-invoice`, `process-payment`, `process-refund`
  - Notifications: `send-push-notification`, `send-notifications`, `process-scheduled-notifications`
  - GDPR: `gdpr_export`, `gdpr_delete`
  - Loyalty/AI/Media: `update-loyalty`, `generate-image-embedding`, `get-hairstyle-recommendations`
- **Risiken**:
  - `verify-employee-time-code` verwendet `SUPABASE_ANON_KEY` und lädt alle Codes (`employee_time_codes`) im Server-Kontext -> abhängig von RLS/Policy-Setup.
  - `time-entry-event` arbeitet mit Service Role, aber Spaltennamen wirken inkonsistent zu App-Service (`check_in/check_out` vs `check_in_time/check_out_time`).

### B4 Storage

- Buckets im Backup: `avatars`, `img`, `gallery`, `chat`, `booking-images`, `ai-suggestions`.
- `booking_media` SQL legt Bucket `booking_media` als **public** an.
- Booking-Upload im Flutter-Code nutzt Bucket `booking-images`.
- Keine eindeutige, konsistente Storage-Policy-Dokumentation im Repo für tenant-bound Zugriff.

---

## C) Feature Matrix (Soll vs Ist)

| Feature-ID | Feature | Status | Evidence (Dateipfade/SQL) | Risiken |
|---|---|---|---|---|
| P1.1 | Zeiterfassung Start/Stop DB+Provider+UI | PARTIAL | `lib/services/time_tracking_service.dart`, `lib/features/dashboard/widgets/time_tracking_widget.dart` | UI mit statischen Stats (`0:00`), Service nutzt anderes Schema als andere Teile |
| P1.2 | Pausen/Breaks + Guard gegen doppelt offen | PARTIAL | `supabase/functions/time-entry-event/index.ts`, `lib/services/time_tracking_service.dart` | Guard nur in Edge Function; App-Service ohne robusten open-entry Guard |
| P1.3 | Urlaubsanträge Staff create/list own | PARTIAL | `lib/services/leave_request_service.dart`, `lib/features/dashboard/widgets/leave_request_widget.dart` | UI teilweise TODO, Felder inkonsistent (`type` vs `leave_type`) |
| P1.4 | Manager approve/reject leave + RLS | PARTIAL | `lib/services/workforce_service.dart` (`decideLeaveRequest`) | Kein klarer dedizierter Manager-Approval-Flow mit gesicherter Rollenprüfung im UI |
| P1.5 | Dienstplan Staff read own shifts | PARTIAL | `lib/features/employee/data/employee_repository.dart` (`getWorkSchedule`) | Keine salon_id-Filterung im Query |
| P1.6 | Dienstplan Manager CRUD shifts | PARTIAL | `lib/services/workforce_service.dart` (Schedule-Methoden) | Fallback entfernt salon_id bei Fehler -> Tenant-Leak Risiko |
| P1.7 | Mitarbeiter-Termine DB-only + Filter + Detail | PARTIAL | `lib/features/bookings/data/booking_repository.dart`, `lib/providers/dashboard_providers.dart` | Query häufig nur per `employee_id`, salon-Kontext nicht überall erzwungen |
| P1.8 | QR Check-in serverseitig validiert + startet Zeit | PARTIAL | `supabase/functions/verify-employee-time-code/index.ts`, `supabase/functions/time-entry-event/index.ts`, `lib/features/dashboard/widgets/qr_checkin_widget.dart` | UI ist Mock/TODO, kein echter Scanner/PIN-Flow |
| P2.1 | Availability serverseitig (RPC) korrekt | PARTIAL | `lib/features/bookings/data/booking_repository.dart` (`has_free_slot`) | Nur ein RPC-Check + clientseitige Slot-Generierung |
| P2.2 | Booking Wizard Multi-Service + Buffer + Stylist optional + 5 Bilder + Notiz | PARTIAL | `lib/features/booking/presentation/booking_wizard_screen_complete.dart` | max 5 Bilder + Notiz vorhanden, aber nur Single-Service |
| P2.3 | Booking Statusflow pending→accepted/declined + decided_by/at | WRONG | `lib/features/bookings/data/booking_repository.dart` (`updateAppointmentStatus`) | Nur `status`/`updated_at`, keine `decided_by/decided_at` |
| P2.4 | Staff UI booking requests DB-backed | PARTIAL | `lib/features/admin/dashboard/admin_dashboard_screen.dart`, `lib/features/bookings/data/booking_repository.dart` | DB-Zugriff ja, aber Flow nicht vollständig auditiert (teilweise Legacy/Adapter) |
| P2.5 | Decline + Reschedule offers (DB+RPC+UI) | MISSING | keine RPC/UI-Implementierung gefunden | Produktivfluss unvollständig |
| P2.6 | Notification Center DB-backed + read/unread + badge + payload nav | MISSING | kein dediziertes Notification-Center in `lib/features` gefunden | Kein nachweisbarer UX-Flow |
| P2.7 | Reminders Scheduled Job 24h/2h + Dedup | PARTIAL | `supabase/functions/process-scheduled-notifications/index.ts` | Job vorhanden, Dedup/Idempotenz nur implizit |
| P2.8 | Payments MVP Modell + UI strukturiert | PARTIAL | `supabase/schema/025_pos_mvp.sql`, `lib/features/pos/*` | UI nutzt harte 19% Steuer; Deposit/Partial/Refund UI fehlt |
| P3.1 | CRM customer profiles DB-backed + Search | PARTIAL | `lib/features/customers/data/customer_repository.dart`, `lib/features/customer/presentation/crm_dashboard_screen.dart` | CRM Screen nutzt `_mockCustomers` |
| P3.2 | CRM history aus bookings/invoices | PARTIAL | `customer_repository.dart` (`getCustomerAppointments`), POS Tabellen | keine vollständige kombinierte History-UI |
| P3.3 | Staff-only Notes RLS + UI CRUD | PARTIAL | `supabase/schema/022_customer_notes.sql`, `lib/features/customer/data/customer_notes_repository.dart` | Repo filtert nicht explizit `salon_id`; verlässt sich auf RLS |
| P3.4 | Media booking reference + before/after (Storage+DB+UI) | PARTIAL | `supabase/schema/023_before_after_media.sql`, `customer_appointments_list.dart` Upload-Hook | RLS für booking_media zu offen |
| P3.5 | Loyalty salon cards/events/levels + Hook bei paid/completed | PARTIAL | `lib/features/loyalty/data/loyalty_repository.dart`, `supabase/functions/update-loyalty/index.ts` | Vollständige End-to-End Verknüpfung nicht nachweisbar |
| P4.1 | POS Warenkorb + Services/Products aus DB | PARTIAL | `lib/features/pos/data/billing_repository.dart`, `lib/features/pos/presentation/pos_screen.dart` | Produktquelle `inventory_products` fraglich ggü. restlichem Schema |
| P4.2 | invoices/invoice_items/payments DB+Repo+RLS | OK | `supabase/schema/025_pos_mvp.sql`, `billing_repository.dart` | Kern vorhanden |
| P4.3 | Tax 19/7 pro salon konfigurierbar + im POS genutzt | PARTIAL | `supabase/schema/026_tax_config.sql`, `tax_config_repository.dart`, `pos_screen.dart` | POS nutzt hart `0.19` statt Konfig |
| P4.4 | Partial/Deposit/Refund Skeleton | PARTIAL | DB status enthält `partial/refunded` (`025_pos_mvp.sql`), Edge `process-refund` vorhanden | UI/Skeleton für Deposit/Refund nicht sichtbar |
| P5.1 | Gallery items DB + Filter | PARTIAL | `lib/providers/gallery_provider.dart`, `lib/features/gallery/presentation/gallery_screen.dart` | Es existieren parallele Gallery-Implementierungen; eine ist Mock/leer |
| P5.2 | Likes/Favs DB + UI | PARTIAL | Tabellen in `backup.sql` (`gallery_likes`, `gallery_saved`), UI-Likes im Screen | UI-Likes lokal (`Set<int>`), DB-Write nicht klar |
| P5.3 | AI-lite recs aus likes/tags | PARTIAL | `supabase/functions/get-hairstyle-recommendations/index.ts` | UI-Anbindung nicht eindeutig |
| P5.4 | “Book this look” Prefill Booking Wizard | MISSING | keine klare Navigation/Prefill-Implementierung gefunden | Feature-Lücke |
| P6.1 | Consent logging DB + Settings UI | PARTIAL | `supabase/schema/027_consents.sql`, `lib/features/settings/data/privacy_repository.dart` | UI-Flow begrenzt, salon-Bezug fehlt |
| P6.2 | GDPR export/delete DB + Edge + UI Trigger | OK | `028_gdpr_requests.sql`, `supabase/functions/gdpr_export`, `gdpr_delete`, `privacy_repository.dart` | Basis vorhanden |
| P6.3 | 2FA/MFA mind. owner/salon_owner | MISSING | kein MFA-Flow in `lib/` gefunden | Security-Lücke |
| P6.4 | mind. 2 integration_tests (real flow) | WRONG | `integration_test/booking_flow_test.dart`, `integration_test/time_and_leave_flow_test.dart` | Tests sind In-Memory-Mocks, kein echter App/Supabase-Flow |
| P6.5 | Rate limits/bruteforce Nachweis | MISSING | keine Config/Doku gefunden | Abuse-Risiko |
| P6.6 | Audit logs sens. Aktionen | PARTIAL | Tabellen `audit_logs`, `activity_logs` in `backup.sql`; einige Services | Vollständige Abdeckung (login/pos/refund/pricing) nicht nachweisbar |

---

## D) Critical Findings (Top 20)

1. **Supabase Secret Key im Flutter-Repo committed** (`supabaseSecretKey`) in `lib/core/config/supabase_config.dart`.  
   **Impact:** Voller Backend-Compromise möglich.  
   **Fix:** sofort rotieren, aus Client entfernen, nur serverseitig nutzen.
2. **Branch `main` nicht vorhanden lokal** (nur `work`) – Audit auf anderem Branch.  
   **Impact:** Produktionsaussage eingeschränkt.  
   **Fix:** CI/Repo-Policy auf konsistente Branch-Namen.
3. **Kein RLS/Policy-Nachweis im `backup.sql`**.  
   **Impact:** Tenant-Isolation nicht beweisbar im tatsächlichen Dump.  
   **Fix:** vollständigen Schema+Policy Dump versionieren.
4. **`booking_media` RLS = `using(true)` / `with check(true)`**.  
   **Impact:** authenticated user kann fremde Salon-Medien sehen/schreiben.  
   **Fix:** salon- und role-basiert einschränken.
5. **QR Check-in UI ist Mock/TODO**.  
   **Impact:** P1.8 nicht produktionsreif.  
   **Fix:** mobile_scanner + echte Function-Invokes implementieren.
6. **Zeit-/Leave-Schema inkonsistent (`type` vs `leave_type`, `check_in_time` vs `check_in`)**.  
   **Impact:** Laufzeitfehler, falsche Daten.  
   **Fix:** einheitliches DB Contract + Migration + Refactor.
7. **Workforce fallback entfernt `salon_id` bei Fehler** in Schedule/Leave-Routinen.  
   **Impact:** Mandantenleck möglich.  
   **Fix:** kein tenant-dropping fallback zulassen.
8. **Booking Statusflow ohne `decided_by/decided_at`**.  
   **Impact:** kein Audit-Trail für Entscheidungen.  
   **Fix:** Felder + Update-Logik + UI ergänzen.
9. **Keine Reschedule-Offer Architektur** (P2.5 fehlt).  
   **Impact:** Decline-Prozess unvollständig.
10. **Notification Center UI fehlt** trotz Backend-Bausteinen.  
   **Impact:** Nutzer sehen Reminder/Events nicht konsistent.
11. **POS nutzt harte 19% statt salon_tax_config**.  
   **Impact:** falsche Steuerberechnung je Salon.
12. **Integration Tests sind Mock-only**.  
   **Impact:** keine reale End-to-End-Sicherheit.
13. **CRM Dashboard mit `_mockCustomers`**.  
   **Impact:** operative Entscheidungen auf Fake-Daten.
14. **Gallery hat parallelen/uneinheitlichen Implementierungsstand**.  
   **Impact:** inkonsistenter Produktfluss.
15. **Rollenmodell weicht von Sollrollen ab** (`platform_admin/salon_owner/salon_manager`).  
   **Impact:** Berechtigungs-Missverständnisse.
16. **Many queries ohne expliziten salon_id-Filter** (z. B. employee/customer detail queries).  
   **Impact:** bei schwacher RLS Datenüberschneidung.
17. **`getOrCreateGuestCustomer` nutzt `.eq('user_id','null')`**.  
   **Impact:** falsche Trefferlogik / Duplikate.
18. **Storage-Konzept fragmentiert (`booking-images` vs `booking_media`)**.  
   **Impact:** Governance/Policies schwer kontrollierbar.
19. **Rate-Limit/Bruteforce-Schutz nicht nachweisbar**.  
   **Impact:** Missbrauchs-/Angriffsfläche.
20. **Audit-Logs vorhanden, aber keine klare Abdeckung sensibler Events**.  
   **Impact:** Compliance-/Forensik-Lücken.

---

## E) Mock/Hardcode/TODO Liste (Top 50)

### Auth / Core
1. `lib/services/api_service.dart` – `TODO: Replace with your actual API URL`
2. `lib/core/widgets/testing_and_api_integration.dart` – `TODO: Implement Supabase auth.signInWithPassword`
3. `lib/core/widgets/testing_and_api_integration.dart` – `TODO: Implement Supabase realtime subscription to time_entries table`
4. `lib/core/widgets/testing_and_api_integration.dart` – `TODO: Implement Supabase realtime subscription to appointments table`
5. `lib/core/widgets/testing_and_api_integration.dart` – `TODO: Implement Supabase query to gallery_images table`
6. `lib/core/widgets/testing_and_api_integration.dart` – `TODO: Implement Supabase realtime subscription to chat_messages table`
7. `lib/core/widgets/testing_and_api_integration.dart` – `TODO: Build AppButton widget and verify`
8. `lib/core/widgets/testing_and_api_integration.dart` – `TODO: Build AppInput widget and verify`
9. `lib/core/widgets/testing_and_api_integration.dart` – `TODO: Build BookingWizardScreen and verify`
10. `lib/features/admin/dashboard/admin_dashboard_screen.dart` – TODO Backend-Tab-Erweiterungen

### Booking / Customer
11. `lib/features/booking/presentation/guest_booking_screen.dart` – `TODO: Navigate to booking wizard`
12. `lib/features/dashboard/widgets/appointments_list_widget.dart` – `TODO: Show details`
13. `lib/features/dashboard/presentation/customer_dashboard_screen.dart` – `TODO: Show details modal`
14. `lib/features/customer/dashboard/customer_dashboard_screen_new.dart` – `TODO: Refactor to use BookingRepository`
15. `lib/features/customer/dashboard/customer_dashboard_screen_new.dart` – `TODO: Show details modal`
16. `lib/features/booking/presentation/salon_map_screen.dart` – `_mockSalons`
17. `lib/features/booking/presentation/salon_map_screen.dart` – mock availability logic
18. `lib/features/customer/presentation/crm_dashboard_screen.dart` – `_mockCustomers` (gesamter KPI-Flow)
19. `lib/features/customer/presentation/crm_dashboard_screen.dart` – Segment-/KPI-Berechnungen auf Mock
20. `lib/providers/report_provider.dart` – `TODO: Fetch revenue by month and bookings by service from Supabase`

### Workforce / Time / Leave
21. `lib/features/dashboard/widgets/time_tracking_widget.dart` – TODO Refactor auf EmployeeRepository
22. `lib/features/dashboard/widgets/time_tracking_widget.dart` – statische Today/Week Werte (`0:00`)
23. `lib/features/dashboard/widgets/leave_request_widget.dart` – TODO Refactor auf EmployeeRepository
24. `lib/features/dashboard/widgets/leave_request_widget.dart` – `TODO: Cancel request`
25. `lib/features/dashboard/widgets/qr_checkin_widget.dart` – `TODO: Implement QR scanner`
26. `lib/features/dashboard/widgets/qr_checkin_widget.dart` – `TODO: Verify PIN and check in`
27. `integration_test/time_and_leave_flow_test.dart` – In-Memory Repo statt echter Integration
28. `integration_test/booking_flow_test.dart` – In-Memory Repo statt echter Integration

### POS / Navigation / Ops
29. `lib/features/admin_navigation/widgets/mobile_hamburger_menu.dart` – `TODO: Logout Funktion`
30. `lib/features/admin_navigation/widgets/navigation_layout.dart` – `TODO: Zeige Benachrichtigungen`
31. `lib/features/admin_navigation/widgets/navigation_layout.dart` – `TODO: Logout`
32. `lib/features/home/presentation/home_overview_screen.dart` – `TODO: Navigation`
33. `lib/features/pos/presentation/pos_screen.dart` – harte Steuer 19%
34. `lib/features/pos/data/billing_repository.dart` – temporäre Rechnungsnummer `TMP-...`

### Chat / Misc
35. `lib/features/chat/presentation/screens/chat_inbox_screen.dart` – `TODO: Implement delete`
36. `lib/features/chat/presentation/screens/chat_inbox_screen.dart` – `CURRENT_USER_ID` TODO
37. `lib/features/chat/presentation/screens/chat_detail_screen.dart` – `TODO: Show attachment menu`
38. `lib/features/chat/presentation/screens/chat_detail_screen.dart` – `TODO: Copy to clipboard`
39. `lib/features/chat/presentation/screens/chat_detail_screen.dart` – `TODO: Edit message`
40. `lib/features/chat/presentation/screens/chat_info_screen.dart` – TODO current user mute check
41. `lib/features/chat/presentation/screens/chat_info_screen.dart` – `TODO: Delete conversation`
42. `lib/features/chat/presentation/widgets/attachment_widget.dart` – TODO File Picker

### Legacy / Backups / Doku
43. `lib/features/auth/presentation/login_screen_old.dart` – TODO forgot password
44. `lib/features/auth/presentation/login_screen_backup.dart` – TODO forgot password flow
45. `lib/features/employee/presentation/employee_tabs_integration.dart` – Mock data docs
46. `lib/features/employee/presentation/EMPLOYEE_TABS_README.md` – mock datasets references
47. `lib/core/constants/NAVIGATION_TOKENS_QUICK_REFERENCE.md` – mockup checklist offen
48. `backup.sql` – SQL TODO-Kommentare vorhanden
49. `backup.sql` – keine RLS/Policy DDL im Dump
50. `lib/features/gallery/presentation/gallery_screen.dart` – lokale Like/Fav-States ohne DB-Persistenz

---

## F) Fix Plan (kleine Commits, exakt)

1. **feat(security): remove client-side supabase secret and migrate to env-only config**  
   Dateien: `lib/core/config/supabase_config.dart`, `README`/env docs  
   DB/SQL: none  
   Akzeptanz: App startet mit env vars; kein `sb_secret_` im Repo.
2. **feat(auth): align role taxonomy with required roles (platform_admin/salon_owner/salon_manager)**  
   Dateien: `lib/core/auth/user_role_helpers.dart`, `lib/models/user_model.dart`, router mapping  
   DB/SQL: optional role migration mapping  
   Akzeptanz: Redirects korrekt für alle Sollrollen.
3. **feat(multi-tenant): enforce salon_id in all repository queries (phase 1 batch)**  
   Dateien: `lib/features/employee/data/employee_repository.dart`, `lib/features/bookings/data/booking_repository.dart`, `lib/features/customers/data/customer_repository.dart`  
   DB/SQL: none  
   Akzeptanz: jeder read/write Pfad hat salon_id oder sicheren RPC.
4. **fix(workforce): remove tenant-dropping fallback paths in WorkforceService**  
   Dateien: `lib/services/workforce_service.dart`  
   DB/SQL: ggf. schema alignment für fehlende Spalten  
   Akzeptanz: keine Fallbacks ohne salon_id.
5. **feat(schema): normalize time_entries + leave_requests schema contract**  
   Dateien: neue Migration in `supabase/migrations/` + betroffene Services  
   DB/SQL: vereinheitliche Feldnamen (`check_in_time/check_out_time`, `leave_type`)  
   Akzeptanz: alle Time/Leave-Flows laufen ohne try-fallback.
6. **feat(workforce-ui): wire QR scanner and PIN checkin to edge functions**  
   Dateien: `lib/features/dashboard/widgets/qr_checkin_widget.dart`  
   DB/SQL: none  
   Akzeptanz: echter Scanner + servervalidierter Checkin.
7. **feat(workforce): implement break handling with open-entry guards in app + db constraints**  
   Dateien: `time_tracking_service.dart`, `workforce_service.dart`, SQL constraints/RPC  
   DB/SQL: unique partial index/open-entry guard  
   Akzeptanz: keine doppelt offenen Entries.
8. **feat(leave): manager approval screen with role guard + audit metadata**  
   Dateien: neues UI unter `lib/features/employee/presentation/*`, `workforce_service.dart`  
   DB/SQL: add `decided_by`, `decided_at` falls fehlend  
   Akzeptanz: approve/reject komplett inkl. Historie.
9. **feat(booking): add booking decision metadata + strict status state machine**  
   Dateien: `booking_repository.dart`, admin/staff booking UI  
   DB/SQL: migration für `decided_by`, `decided_at`, constraint status transitions  
   Akzeptanz: pending→accepted/declined mit Audit.
10. **feat(booking): implement reschedule offers data model + rpc + staff/customer ui**  
    Dateien: new `lib/features/bookings/...`, SQL + RPC  
    DB/SQL: `reschedule_offers` + generate/select RPC  
    Akzeptanz: decline erzeugt auswählbare Alternativen.
11. **feat(notifications): build notification center with read/unread + payload navigation**  
    Dateien: neues Feature `lib/features/notifications/*`, router deep-link hooks  
    DB/SQL: notifications table + policies (falls fehlend)  
    Akzeptanz: Badge, mark-as-read, nav by payload.
12. **fix(reminders): harden scheduled reminders with dedup keys and idempotency**  
    Dateien: `supabase/functions/process-scheduled-notifications/index.ts`  
    DB/SQL: unique index on reminder key  
    Akzeptanz: kein Doppelversand.
13. **feat(pos): consume salon tax config in checkout calculation**  
    Dateien: `lib/features/pos/presentation/pos_screen.dart`, `tax_config_repository.dart`  
    DB/SQL: none  
    Akzeptanz: Steuer pro Salon/Override sichtbar korrekt.
14. **feat(pos): add partial/deposit/refund architecture stubs in UI**  
    Dateien: POS UI + billing models  
    DB/SQL: ggf. payment type/status erweitern  
    Akzeptanz: deaktivierte, aber saubere MVP-Skeleton Pfade.
15. **fix(crm): replace `_mockCustomers` dashboard with repository-backed provider**  
    Dateien: `crm_dashboard_screen.dart`, customer providers  
    DB/SQL: optional views for KPI  
    Akzeptanz: KPIs aus DB.
16. **feat(crm): unify customer history from appointments + invoices**  
    Dateien: `customer_repository.dart`, customer detail UI  
    DB/SQL: optional SQL view  
    Akzeptanz: chronologische echte Historie.
17. **fix(media): tighten booking_media RLS to salon membership and role checks**  
    Dateien: neue SQL migration/policy update  
    DB/SQL: replace `using(true)` policies  
    Akzeptanz: kein cross-salon Zugriff.
18. **feat(gallery): consolidate to one gallery implementation (DB-first) + likes/favs persistence**  
    Dateien: `lib/features/gallery/*`, `providers/gallery_provider.dart`  
    DB/SQL: upsert likes/saved tables with policies  
    Akzeptanz: likes/favs persistent, filterbar.
19. **feat(gallery): implement “Book this look” prefill contract to booking wizard**  
    Dateien: gallery detail + booking wizard routes/state  
    DB/SQL: optional ref-image relation  
    Akzeptanz: prefilled booking from look.
20. **feat(security): add MFA onboarding/check for owner + salon_owner roles**  
    Dateien: auth/settings screens + auth service  
    DB/SQL: provider config docs  
    Akzeptanz: MFA required on privileged roles.
21. **test(integration): replace mock integration tests with real app+supabase test harness**  
    Dateien: `integration_test/booking_flow_test.dart`, `integration_test/time_and_leave_flow_test.dart`  
    DB/SQL: seed scripts for test schema  
    Akzeptanz: tests hit real repositories and assert DB state transitions.
22. **docs(security): document rate limiting + bruteforce mitigations**  
    Dateien: `docs/security.md`, edge function middleware  
    DB/SQL: optional throttle table  
    Akzeptanz: measurable limits for auth/code verification endpoints.
23. **feat(audit): central audit log service for login/pos/refund/pricing changes**  
    Dateien: service layer + affected features  
    DB/SQL: audit table/index/policies verify  
    Akzeptanz: every sensitive action emits structured log.
24. **chore(cleanup): remove backup/legacy UI duplicates and archive obsolete screens**  
    Dateien: old login/galleries/legacy routes  
    DB/SQL: none  
    Akzeptanz: eindeutiger produktiver Pfad, weniger Mock-Risiko.

