# Umbauplan: Flutter‑App an React‑Seite angleichen

Dieser Plan beschreibt die Umstellung der bestehenden Flutter‑App auf eine Struktur, die an die React‑Seite (`vibewithyou/salonmanager1‑2`) angelehnt ist.  Ziel ist es, die bisherige Landing‑Page der App zu entfernen und stattdessen einen Anmelde‑/Registrierungs‑Bildschirm als Startpunkt zu verwenden.  Zudem wird eine seitliche Navigation (ein‑/ausklappbar) eingeführt, um die hierarchische Struktur der React‑Seite abzubilden.  Die folgenden Abschnitte beziehen sich auf die Analyse der React‑Dateien (u.a. `App.tsx`, `AdminDashboard.tsx` und `sidebar.tsx`) und sollen einer anderen KI als Leitfaden zur Umsetzung in Flutter dienen.

## 1. Start‑ und Authentifizierungs‑Flow

### 1.1 Landing‑Page entfernen
- **React‑Status:** Die React‑Seite besitzt eine Landing‑Page (`Index.tsx`) mit Held‑Bereich, Features, Rollen‑Sektion und Footer.  Diese Seite ist über den Root‑Pfad (`/`) erreichbar und dient Marketing‑Zwecken.  Für die App wird diese Seite **ersetzt** durch einen Auth‑Einstieg. 
- **Flutter‑Plan:** Beim Start der App wird sofort ein **Auth‑Screen** geladen.  Hier wählt der Benutzer zwischen:
  - **Login** (bestehendes Konto, egal ob Kunde, Mitarbeiter, Manager oder Admin).
  - **Registrieren** (Neues Konto erstellen; Registrierung sollte Rolle und Berechtigungen berücksichtigen, z. B. „Kunde“ vs. „Mitarbeiter“).
  - **Gast‑Termin buchen** (ohne Konto).  Dieser Button leitet direkt in den mehrstufigen Buchungswizard (Salon → Leistung → Zeit → Kontaktdaten und optionaler Text/Bilder), wie in der React‑App beschrieben【424651131194406†L180-L187】.

### 1.2 Login‑/Registrierungs‑Design
- **Orientierung an `Login.tsx`:** Die React‑Login‑Seite verwendet eine zweispaltige Aufteilung: links das Formular mit Feldern (E‑Mail, Passwort), rechts eine dekorative Gradient‑Fläche【506817521326823†L55-L67】.  Beim Login wird `useAuth` aufgerufen und ein Protected Route auf das Dashboard führt nach erfolgreicher Anmeldung.
- **Flutter‑Umsetzung:** In Flutter sollte der `AuthScreen` einen ähnlichen zweispaltigen Aufbau haben:
  - Links: `TextFormField` für E‑Mail/Benutzername und Passwort, „Anmelden“‑Button, Link „Passwort vergessen?“ und Link „Jetzt registrieren“.
  - Rechts (auf großen Bildschirmen): dekoratives Bild oder Verlauf; auf kleinen Bildschirmen kann dieser Bereich ausgeblendet werden.
  - Formularvalidierung, Feedback bei Fehlern sowie Buttons für Google/Apple‑Login können integriert werden.

### 1.3 Gast‑Termin‑Buchung
- Der React‑Router definiert `/booking` als öffentlichen Wizard, damit Gäste Termine ohne Konto buchen können【424651131194406†L180-L187】.  Der Flow: Salon auswählen → Leistung auswählen → optional Stylist → Datum/Uhrzeit wählen → Kontaktdaten + optional Notiz/Bilder【424651131194406†L180-L187】.  
- Für Flutter wird dieser Flow als separate Route (`/booking`) implementiert.  Wichtige Felder (E‑Mail, Telefon, Name) sind Pflicht, Notiz und bis zu fünf Bilder optional.  Nach dem letzten Schritt erhält der Gast eine Bestätigung mit Referenzcode und einen Link per E‑Mail/SMS, um Termine zu verwalten.

## 2. Navigation – Sidebar statt Top‑Navbar

### 2.1 Hierarchische Gruppen
Die React‑Applikation organisiert Navigationseinträge in Gruppen, die im Admin‑Dashboard definiert sind【263864729613098†L456-L534】.  Beispiele:

| Gruppe (id) | Label | Routen |
|-------------|-------|--------|
| `salons` | „Meine Salons“ | `/salons` (Übersicht aller Salons) |
| `overview` | „Übersicht“ | `/admin` (Admin‑Dashboard) |
| `appointments` | „Termine“ | `/calendar`, `/schedule`, `/booking`, `/booking-map`, `/closures` |
| `salon` | „Salon“ | `/employees`, `/inventory`, `/suppliers`, `/service-consumption`, `/loyalty-settings`, `/coupons`, `/reports` |
| `marketing` | „Marketing & Online“ | `/seo-dashboard`, `/local-seo`, `/salon-page-editor`, `/inspiration` |
| `gallery` | „Galerie“ | `/gallery`, `/gallery/upload` |
| `communication` | „Kommunikation“ | `/create-staff-chat`, `/support-chat`, `/conversations` |
| `settings` | „Einstellungen“ | `/salon-setup`, `/profile`, `/security` |

Diese Gruppen werden an `SidebarNavigation` übergeben und erscheinen in der klappbaren Seitenleiste【263864729613098†L456-L534】.

### 2.2 Collapse/Expand‑Logik (React `sidebar.tsx`)
Das `Sidebar`‑Component verwendet einen `SidebarProvider` und speichert den Zustand (eingeklappt/ausgeklappt) in einem Cookie, schaltet bei kleinen Bildschirmen zu einer Drawer‑Ansicht und unterstützt das Tastenkürzel „Ctrl/Cmd + B“ zum Umschalten【622168660256128†L92-L104】【622168660256128†L153-L175】.  In Flutter soll sich diese Logik wie folgt wiederfinden:

1. **Breite Navigation:** Für größere Bildschirme nutzt man eine permanente `NavigationRail` oder ein eigenes `SideBar`‑Widget, das sich von 240 px auf 72 px Breite zusammenschieben lässt.  Beim Zusammenklappen werden nur Icons angezeigt; beim Ausklappen erscheinen die Labels und Unterpunkte.
2. **Mobile Drawer:** Auf Smartphones öffnet sich die Navigation als Drawer (Slide‑In) über einen Hamburger‑Button.  Flutter bietet `Drawer`/`NavigationDrawer` hierfür.
3. **Zustand speichern:** Der aktuelle Sidebar‑Status kann in `SharedPreferences` persistiert werden.
4. **Hierarchische Navigation:** Innerhalb der Sidebar werden Accordion‑ähnliche Gruppen („Termine“, „Salon“ usw.) implementiert.  In Flutter kann man dazu `ExpansionTile` nutzen.  Jede Gruppe enthält mehrere Einträge (`ListTile`) mit Icons und Routen.  Das Verhalten (Animation, Hover‑Effekt) orientiert sich am React‑Design.

### 2.3 Routenmanagement
- In React werden Routen mittels `react-router-dom` definiert (`App.tsx`) und durch `ProtectedRoute` nach Rollen / Salon‑Auswahl geschützt【424651131194406†L90-L199】.  Flutter sollte `go_router` oder `auto_route` verwenden, um deklarative Routen (Pfad → Widget) mit Parameter‑Support (z. B. `salon/:slug`) anzulegen.  
- **Rollenbasierte Absicherung:** Der `UserRoleProvider` schützt bestimmte Routen vor unbefugtem Zugriff【424651131194406†L90-L199】.  In Flutter wird dies durch Wrapper‑Widgets oder Guards umgesetzt.  Beispiel: `AdminGuard` prüft, ob `currentUser.role == 'admin'` und zeigt andernfalls einen Fehler bzw. leitet zum Employee‑Dashboard weiter.
- **Onboarding‑Check:** React verwendet `RequireUserOnboarding`, um Benutzer, die noch keinen Salon gewählt haben, auf eine Onboarding‑Seite zu lenken.  Dies sollte in Flutter analog umgesetzt werden.

## 3. Administrations‑ und Mitarbeiter‑Dashboards

### 3.1 Admin‑Dashboard
- **Tabs:** Der Admin‑Bereich enthält mehrere Tabs („Übersicht“, „Mitarbeiter“, „Services“, „Urlaub“, „POS“, „Kunden“, „Galerie“, „Zeiterfassung“, „Vergangene Termine“ und „Salon‑Einstellungen“)【263864729613098†L602-L654】【263864729613098†L849-L859】.  In Flutter kann man das Tab‑Layout mit `TabBar` und `TabBarView` realisieren.  
- **Navigation:** Der Admin erreicht den Dashboard‑Tab über `/admin` und die übrigen Funktionen über die Sidebar.  Eine klare Trennung zwischen Navigations‑Routen (links) und Tab‑Wechseln (innerhalb einer Route) ist sinnvoll.  
- **Header‑Actions:** Im Header wird das Admin‑Badge angezeigt【263864729613098†L538-L547】.  Flutter kann eine `AppBar` mit `Row` nutzen, in der rechts Widgets wie Theme‑Switcher, Sprach‑Switcher und ein Dropdown mit Profil/Buffern implementiert werden.

### 3.2 Employee‑Dashboard
- Mitarbeiter nutzen keinen Sidebar‑Navigation; stattdessen gibt es im Header Buttons für Dashboard, POS, Kunden, vergangene Termine und Portfolio【259889735310897†L259-L283】.  Bei Bedarf kann eine kleine `NavigationRail` eingeblendet werden, falls man eine einheitliche Seitenleiste verwenden möchte.
- Der Haupt‑Tab „Dashboard“ zeigt Kennzahlen (Termine heute/diese Woche, erledigte Termine, Position des Mitarbeiters) und Cards für Nachrichten & Support【259889735310897†L286-L358】.
- Tabs für POS, Kunden, vergangene Termine und Portfolio laden entsprechende Widgets (`POSDashboard`, `CustomersTab`, `PastAppointmentsTab`, `EmployeePortfolioTab`).

### 3.3 Kunden‑Perspektive
- Kunden, die sich einloggen, können ihr Profil, ihre Termine, die Treuekarte und Lieblingsservices verwalten.  Dafür ist ein eigenes Dashboard nötig (nicht detailliert im React‑Code).  Der Plan sollte einen **CustomerHomeScreen** mit Terminhistorie, Treuepunkten und Profilzugriff vorsehen.

## 4. Backend‑Anbindung und State Management

### 4.1 Authentifizierung
- Die React‑App nutzt Supabase für Auth (OAuth, E‑Mail/Passwort) und `AuthContext` zur Speicherung des Tokens.  In Flutter kann `supabase_flutter` genutzt werden oder, falls ein eigenes Backend verwendet wird, `dio` bzw. `http` + `provider`/`riverpod` zur Authentifizierung.  Wichtig ist ein **tokenbasierter Flow** mit Persistierung im Secure Storage.  
- Für den Gast‑Buchungs‑Flow wird keine Authentifizierung benötigt; der Server muss jedoch temporäre „manage tokens“ oder OTP bereitstellen, um Terminänderungen zu ermöglichen.

### 4.2 Rollen & RBAC
- Die React‑App unterscheidet Rollen (`customer`, `stylist`, `manager`, `admin`) und ergänzt sie um Salon‑ID.  `ProtectedRoute` überprüft Rolle und Salon【424651131194406†L90-L199】.  
- In Flutter sollte das `User`‑Modell neben `id` und `email` auch `role` und `currentSalonId` enthalten.  Guards verhindern unberechtigten Zugriff.  Beispiel: `if (!user.isAdmin) return const NotAuthorizedPage();`.

### 4.3 Datenverwaltung
- Daten werden im React‑Projekt hauptsächlich via Supabase (SQL) und `@tanstack/react-query` geladen.  In Flutter kommen `riverpod` und `flutter_riverpod` (oder `flutter_bloc`) zum Einsatz, um API‑Calls zu kapseln und zu cachen.

## 5. UI‑Design und Theme

### 5.1 Farbpalette
- Das React‑Design verwendet eine dunkle Oberfläche mit goldenen Akzenten und unterstützender „sage“ und „rose“‐Palette【263864729613098†L570-L599】.  Bei hellen Themes wird automatisch angepasst.  Flutter kann mit `ThemeData` zwei Farbschemata bereitstellen (Light & Dark) und goldene Akzentfarbe (`Color(0xFFcc9933)` oder ähnlich) definieren.

### 5.2 Typografie
- `font-display` und `font-bold` werden in React verwendet.  In Flutter sollten Fonts wie „Inter“ oder „SF Pro“ eingebunden und unterschiedliche TextStyles (Headline1–Headline6) definiert werden.

### 5.3 Icons
- React nutzt `lucide-react`.  Flutter kann `lucide_icons` oder `flutter_icons` nutzen.  Für Navigationseinträge sollten passende Icons (Schere für Salon, Kalender, Chart, Benutzer, etc.) gewählt werden.

### 5.4 Responsive Design
- Der Sidebar verkleinert sich auf schmalen Viewports zu einem Drawer; Tabs werden in Dropdowns umgewandelt.  In Flutter sollte mittels `LayoutBuilder` das Layout an Bildschirmbreiten angepasst werden.  Auf Tablets bleiben Sidebar und Content nebeneinander, auf Phones wechselt man zu einer Drawer‑Navigation.

## 6. Zusätzliche Features

1. **Mehrsprachigkeit:** Die React‑App verwendet `react-i18next`.  In Flutter lässt sich `flutter_localizations` zusammen mit `intl` und einem `AppLocalizations`‑Generator nutzen.  Alle Labels der Navigation sollten übersetzbar sein.
2. **Cookie‑ und Consent‑Banner:** React zeigt ein Consent‑Overlay (`ConsentManager`).  Dies kann in Flutter über einen `Banner` oder modales Dialog implementiert werden, der bei erster Nutzung angezeigt wird.
3. **AppBar‑Shortcuts:** Die Tastenkombination `Ctrl/Cmd + B` zum Einklappen der Sidebar wird in Flutter über `Shortcuts` und `Actions` realisiert.
4. **File‑Upload & Galerie:** Für den Upload von Bildern (Galerie und Gast‑Booking) nutzt React `Dropzone` und `Supabase Storage`.  In Flutter benötigt man `file_picker` bzw. `image_picker` und Anbindung an das Backend.

## 7. Umsetzungsschritte (Roadmap)

1. **Projektstruktur anpassen:** Erstelle ein neues Flutter‑Package namens `features/` mit Sub‑Modulen `auth`, `booking`, `dashboard/admin`, `dashboard/employee`, `dashboard/customer`, `gallery`, `marketing`, `pos`, `settings`.  Implementiere `main.dart` mit `go_router` und `RiverpodProviderScope`.
2. **Auth‑Flow implementieren:** Entwickle `AuthScreen` mit Login‑, Registrierungs‑ und Gast‑Buchungs‑Buttons.  Integriere Auth‑API und persistiere Tokens.  Implementiere `ForgotPassword`/`ResetPassword`‑Seiten.
3. **Navigation implementieren:** Erstelle `SideNavigationWidget` mit expandierbarer `NavigationRail` und `Drawer`‑Fallback.  Binde hier die Nav‑Gruppen für Admin (s. Tabelle oben) an.  Richte Hotkey `Ctrl+B` ein.
4. **Routing konfigurieren:** Definiere alle Routen laut `App.tsx` und verbinde sie mit Widgets.  Implementiere Guards für Rollen und Onboarding.  
5. **Dashboards portieren:** Baue Admin‑ und Employee‑Dashboards mit Tabs und Widgets.  Begib dich schrittweise – erst Grundlayout, dann Inhalte (z. B. Karten, Listen).  
6. **Guest‑Booking Wizard:** Realisiere den mehrstufigen Buchungsprozess mit Zustandsspeicherung über mehrere Seiten/Steps und Upload‑Funktion für Bilder.
7. **Weiterführende Seiten:** Implementiere sukzessive die übrigen Seiten (Galerie, SEO‑Dashboard, Local SEO, Service Consumption, Loyalty, etc.).  Priorisiere dabei Seiten, die für den MVP relevant sind.
8. **Testen und Verfeinern:** Führe Usability‑Tests durch, insbesondere zur Responsiveness und Bedienbarkeit der Sidebar.  Passe Animationen und Farben an das bestehende Markenbild an.

## 8. Fazit

Die React‑Seite von **SalonManager** dient als Referenz für Struktur und Funktionsumfang.  Dieser Plan fasst die wichtigsten Navigations‑ und Seitenstrukturen zusammen und beschreibt, wie sie in Flutter umgesetzt werden können, wobei ein **Login‑Zentrum** den Einstieg bildet und eine **ein‑/ausklappbare Seitenleiste** das Herzstück der Navigation wird.  Rollen‑basierte Zugriffskontrollen, moderne UI‑Elemente und ein flüssiger Buchungs‑Wizard sorgen dafür, dass die Flutter‑App den Komfort und Funktionsumfang der Web‑App erreicht und gleichzeitig auf mobilen Geräten optimal bedienbar bleibt.
