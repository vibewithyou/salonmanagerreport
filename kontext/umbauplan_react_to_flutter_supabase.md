# Umbauplan (React ➜ Flutter) – SalonManager: echte Supabase-Daten + vollständige Feature-Portierung

**Repos / Quellen**
- **Flutter App (Ziel):** `tenesky/salonmanager` (Branch `tobi`)
- **React App (Referenz):** `vibewithyou/salonmanager1-2`
- **Im Flutter-Repo vorhanden:** Ordner `react_site/` (Kopie der React App) und `supabase_dump.py` (Supabase Dump/Export)

> Ziel: **Keine Dummy-/Mock-Daten mehr**, sondern **echte Supabase-Daten (Auth + Tabellen + RPC + Storage)**, und alle funktionsfähigen React-Features **1:1** in Flutter nachbauen (inkl. Rollenkonzepte, Dashboards, Buchungsflow, Karte/Suche, Chat, Inventar, POS, Loyalty).

---

## 0) Leitprinzipien (damit die KI nicht halluziniert)

1. **Nichts “erfinden”**: Alles muss sich aus `react_site/` (React-Code) oder aus `supabase_dump.py` / Supabase-Schema ableiten lassen.  
2. **Portiere Logik – nicht UI**: UI ist “okay” → Fokus auf Datenfluss, echte Queries, RPC, RLS, Fehlerbehandlung.  
3. **Einheitliche Daten-API**: In Flutter **keine** verstreuten Supabase-Calls in Widgets. Immer über `repositories/services`.  
4. **Single Source of Truth für Rollen + Redirects**: Role-Key als String (`"salon_owner"`, `"stylist"`, `"customer"`, …), keine `.name`/`.displayName` auf beliebigen Objekten.  
5. **Feature-Slices**: pro Feature eigener Ordner in `lib/features/...` mit `data/`, `domain/`, `presentation/`.

---

## 1) Bestandsaufnahme: Wo ist was?

### 1.1 React: Supabase Client & Integrations
Im React-Projekt findest du:
- `react_site/src/integrations/supabase/client.ts`  
  → erstellt den Supabase Client, liest URL/Key aus ENV und setzt `persistSession`, `autoRefreshToken`.
- `react_site/src/integrations/supabase/rpc.ts`  
  → RPC-Wrapper wie `salons_within_radius`, `salons_within_radius_filtered`, `has_free_slot`.

**Aufgabe:** Diese Struktur in Flutter spiegeln:
- `lib/core/supabase/supabase_client.dart` (Initialisierung)
- `lib/core/supabase/supabase_rpc.dart` (RPC-Funktionen als Dart-Wrapper)

### 1.2 Supabase Schema / Dump
- `supabase_dump.py` enthält den Export (Tabellen, ggf. Daten, Policies, RPC-Namen).
- Zusätzlich liegt im React-Repo oft ein `supabase/schema.sql` oder Migrations-Textdateien (z. B. `kontext/SUPABASE_SQL_MIGRATIONS.txt`).

**Aufgabe:** Erzeuge daraus in Flutter:
- Typisierte Models (Freezed/JsonSerializable) **nur** für Tabellen, die die App nutzt
- klare Repository-Methoden: `getSalons()`, `getAppointmentsForUser()`, `createBookingGuest()`, etc.

---

## 2) Problem 1 lösen: Dummy-Daten entfernen & echte Supabase-Daten nutzen

### 2.1 Abstellen von Mock-Services
In Flutter wurden zuletzt Services mit Mock-Daten angelegt (z. B. `appointment_service.dart`, `time_tracking_service.dart`, `leave_request_service.dart`).  
**Ziel:** Diese dürfen nicht mehr “fake” zurückgeben.

**Umbau-Regel**
- Alle Services bekommen eine echte Implementierung mit `supabase_flutter`.
- Mock-Listen nur noch als Fallback in *Dev-only* (optional, per Flag).

### 2.2 Supabase Flutter einbauen
**Pakete**
- `supabase_flutter`
- optional: `flutter_secure_storage` (Mobile), für Web reicht `supabase_flutter` Session-Storage

**Init**
- Werte (URL/AnonKey) aus `.env` oder Flutter `--dart-define`
- gleiche Werte wie in React `client.ts`

**Dateien (Vorschlag)**
- `lib/core/config/env.dart` (lädt `SUPABASE_URL`, `SUPABASE_ANON_KEY`)
- `lib/core/supabase/supabase_init.dart` (Supabase.initialize)
- `lib/core/supabase/supabase_client.dart` (Getter `Supabase.instance.client`)

### 2.3 Auth 1:1 wie React
React nutzt Supabase Auth (persist + refresh).  
Flutter muss:
- Session persistieren
- beim Start Session laden
- `onAuthStateChange` abonnieren
- `GET /me`-Äquivalent: Userprofil + Rollen aus DB laden

**Wichtig: Rollen sind NICHT aus Supabase Auth selbst** → meistens aus einer Tabelle wie `user_roles` oder `profiles`.

**Implementiere**
- `AuthRepository`
  - `signIn(email, password)`
  - `signUpCustomer(...)`
  - `signUpOwner(...)`
  - `signOut()`
  - `currentSession`
- `UserRepository`
  - `fetchProfile(userId)`
  - `fetchRole(userId)` → roleKey (string)
  - `fetchSalonContext(userId)` → salonIds / currentSalonId

**Riverpod**
- `authControllerProvider` (State: loading/authenticated/user/roleKey/currentSalonId)

### 2.4 Rollen- und Redirect-Bugs endgültig fixen
Aktuelle Fehlerbilder zeigen `.name`/`.displayName` auf `UserRole` → Crash.  
**Fix: roleKey als String überall.**

**Neue Datei**
- `lib/core/auth/role_helpers.dart`
  - `String roleKeyFromDb(String raw)`
  - `bool isAdminRole(String roleKey)`
  - `String homeRouteForRole(String roleKey)`
  - `String roleDisplayName(String roleKey)`

**Router-Guards**
- nie `role.name`, nie `role.displayName`
- Redirect nach Login: `homeRouteForRole(roleKey)`

---

## 3) Problem 2 lösen: fehlende Features + Platzhalter → echte React-Funktionen portieren

### 3.1 Vorgehen: Feature-Mapping von React nach Flutter

#### Schritt A: Feature-Liste aus React ableiten
Die KI soll im `react_site/` folgende Dinge automatisch finden:
- `src/pages/**` (alle Hauptseiten)
- `src/components/**` (Widgets/Komponenten)
- `src/integrations/supabase/**` (Queries/RPC)
- `src/hooks/**` oder `use*.ts` (Datenlogik)
- `src/routes` / `App.tsx` (Routing)

**Output, den die KI erzeugen muss:**
- `docs/react_feature_inventory.md`  
  Enthält Tabelle: `Route | Page | Data Sources (tables/rpc) | Actions (insert/update/delete) | Flutter Ziel-Screen`
- `docs/supabase_usage_map.md`  
  Enthält Tabelle: `Table/RPC | React Files | Purpose | Flutter Repository Method`

#### Schritt B: Flutter Screens/Features auf Vollständigkeit prüfen
Die KI erzeugt:
- `docs/flutter_feature_inventory.md` (Routes + Screens + Status)
- `docs/gap_list.md` (was fehlt, priorisiert)

---

## 4) Konkrete Portierungsaufgaben (in Reihenfolge)

### Phase 1 — Daten- und Auth-Integration (MUSS zuerst)
1. Supabase Flutter init + env
2. AuthRepository + UserRepository (roleKey + profile + salon context)
3. Router Redirect/Guards stabilisieren
4. Dummy Services entfernen (Termine/Zeiterfassung/Urlaub) → echte Supabase Implementierung
5. „Entry / Login / Register / Guest Booking Start“ sicher navigierbar machen

**Akzeptanz**
- Login funktioniert
- nach Login Redirect je Rolle (admin/employee/customer)
- `/customer`, `/employee`, `/admin` laden ohne Crash
- keine Mock-Daten in Dashboards

---

### Phase 2 — Salons & Suche/Karte (weil das überall gebraucht wird)
React hat RPC:
- `salons_within_radius`
- `salons_within_radius_filtered`
- `has_free_slot`

**Flutter**
- `SalonRepository`
  - `getSalonsWithinRadius(lat, lon, radius)`
  - `getSalonsWithinRadiusFiltered(lat, lon, radius, filters)`
  - `hasFreeSlot(salonId, start, end)`

**UI**
- Liste + Karte (flutter_map)
- Filter (minRating, minPrice/maxPrice, categories, availability start/end)

**Akzeptanz**
- echte Salons aus DB sichtbar
- Marker + Liste synchron
- Filter funktioniert (RPC)

---

### Phase 3 — Booking Wizard (Guest + Customer)
**React-Flow nachbauen** (Wizard Steps)
1. Salon wählen
2. Service wählen
3. Stylist optional
4. Datum/Uhrzeit (Availability)
5. Notizen + bis zu 5 Bilder (Storage bucket `booking-images`)
6. AGB/Datenschutz akzeptieren
7. Speichern (appointments/bookings Tabellen laut Dump)

**Flutter**
- `BookingRepository`
  - `createGuestBooking(...)`
  - `createCustomerBooking(...)`
  - `uploadBookingImage(file)` → returns URL
  - `getAvailableSlots(...)` (RPC oder query)

**Akzeptanz**
- Gast kann buchen (ohne Konto)
- Kunde kann buchen (mit Konto)
- Daten erscheinen in DB
- Upload funktioniert (RLS beachten)

---

### Phase 4 — Dashboards vollständig (Customer/Employee/Admin)
**Ziel:** Alles, was in React wirklich funktioniert, muss in Flutter funktionieren.

#### Customer
- Upcoming appointments (real query)
- My appointments list (cancel/reschedule if supported)
- Favorites/Gallery likes (wenn React das hat)
- Messages/Support (falls vorhanden)

#### Employee (Stylist)
- Terminliste (nur eigene)
- Status ändern (accept/decline/complete)
- Time Tracking: checkin/checkout (real insert/update)
- Leave requests: create + list
- Schedule view (wenn im Schema vorhanden)

#### Admin/Owner/Manager
- Termine salonweit
- Mitarbeiterverwaltung (invite/create)
- Services CRUD
- Inventory CRUD + transactions
- POS (transactions + invoices)
- Loyalty (accounts/settings)
- Reports (minimal: counts/sums)

**Akzeptanz**
- keine „Coming soon“ Screens in den Kern-Menüpunkten
- alle Aktionen schreiben in Supabase

---

### Phase 5 — Chat / Messages (Realtime)
Wenn React Chat implementiert:
- Tabellen: `conversations`, `messages`, `participants`
- Realtime subscription in Flutter (Supabase Realtime)

**Akzeptanz**
- neue Nachricht erscheint live
- Rollenberechtigungen stimmen

---

## 5) Datei- & Code-Blueprint (Flutter)

### 5.1 Core
- `lib/core/config/env.dart`
- `lib/core/supabase/supabase_init.dart`
- `lib/core/supabase/supabase_client.dart`
- `lib/core/supabase/supabase_rpc.dart`
- `lib/core/auth/role_helpers.dart`
- `lib/core/router/app_router.dart` (go_router, Guards)

### 5.2 Features (Beispiel Salon)
- `lib/features/salons/data/salon_repository.dart`
- `lib/features/salons/data/salon_models.dart`
- `lib/features/salons/presentation/salon_list_screen.dart`
- `lib/features/salons/presentation/salon_map_screen.dart`

### 5.3 Repositories: Regeln
- Kein Supabase Call direkt im Widget
- Repositories liefern typed models
- Fehler: immer `Either/Result` oder Exception-Handling + UI Fehlerzustand

---

## 6) “Nicht halluzinieren”: Checkliste für Claude

Claude muss bei jeder Implementierung:
1. **React-Datei nennen**, aus der die Logik kommt (Pfad in `react_site/`)
2. **Supabase Tabelle/RPC nennen**, die verwendet wird
3. In Flutter: **Repository-Methode** nennen, die es abbildet
4. Wenn etwas im Dump nicht existiert: **nicht implementieren**, sondern als “blocked: missing table/column” markieren

---

## 7) Arbeitsaufteilung in Tasks (für VS Code Agent)

### Task 1 — Mapping erzeugen (Docs)
- `docs/react_feature_inventory.md`
- `docs/supabase_usage_map.md`
- `docs/flutter_feature_inventory.md`
- `docs/gap_list.md`

### Task 2 — Supabase Integration + Auth
- Supabase init + env
- AuthRepository + UserRepository
- roleKey helpers
- Router redirect/guards fix
- remove mock usage

### Task 3 — Salons / Karte / Filter
- RPC wrapper
- UI integration

### Task 4 — Booking Wizard (Guest + Customer) + Image upload
- storage upload
- create booking

### Task 5 — Dashboards (Employee + Admin) feature-complete
- port React functionality

### Task 6 — Realtime chat (wenn in React)
- subscriptions

---

## 8) “Done”-Kriterien (Messbar)

- **Keine** Dummy-Daten mehr in Produktion (Mock nur per Dev-Flag)
- Login + Session persistieren
- Role Redirect korrekt (owner/admin → /admin, stylist → /employee, customer → /customer)
- Salons aus Supabase sichtbar (Liste/Karte)
- Booking erstellt echte Datensätze + Bildupload funktioniert
- Employee/Admin Funktionen schreiben echte Daten (CRUD)

---

## 9) Nächster Schritt (so startest du sofort)

1. Lass die KI **Task 1** generieren (Docs + Mapping)  
2. Danach **Task 2** (Supabase + Auth)  
3. Danach **Task 3** (Salons/Karte), weil es im Booking gebraucht wird.

