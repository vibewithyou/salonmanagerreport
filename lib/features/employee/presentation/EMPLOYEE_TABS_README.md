# Employee Tabs Documentation

Flutter Widgets für die 4 neuen Employee Tabs mit Riverpod Integration, Material 3 Design und Gold (#CC9933) Theme.

## Übersicht

### 1. POSTab Enhanced (`pos_tab_enhanced.dart`)
**Kassierungssystem für Salon-Dienstleistungen**

#### Features
- Service-Katalog mit Kategorie-Filter
- Warenkorb mit Mengensteuerung
- Rabatt-Berechnung (prozentual)
- 3 Zahlungsarten: Bar, Karte, EC
- Abrechnung mit Bestätigung
- Echtzeitkalkulationen

#### Komponenten
- `POSTabEnhanced` - Hauptwidget (Konsument)
- `CartItem` - Datenmodell für Warenkorbposten
- `_ServiceTile` - Service-Listenelement
- `_CartItemTile` - Warenkorbelement mit Steuerung

#### Riverpod Providers
```dart
salonServicesProvider(salonId) // FutureProvider<List<SalonServiceDto>>
```

#### UI Layout
```
┌─────────────────────────────────────────┐
│ Services List (2/3)  │  Cart Panel (1/3) │
├─────────────────────┼───────────────────┤
│ [Kategorien Filter] │ Warenkorb          │
│ ┌─────────────────┐ │ ┌─────────────────┐│
│ │ Service 1: €35  │ │ │ Artikel 1: €35  ││
│ │ 30 min          │ │ │ Menge: 2        ││
│ │ [+ Add]         │ │ │ Total: €70      ││
│ ├─────────────────┤ │ ├─────────────────┤│
│ │ Service 2: €50  │ │ │ Artikel 2: €50  ││
│ │ 45 min          │ │ │ Menge: 1        ││
│ │ [+ Add]         │ │ │ Total: €50      ││
│ └─────────────────┘ │ │─────────────────│
│                     │ │ Rabatt: 10% -€12│
│                     │ │ Gesamt: €108    │
│                     │ │ [Bar][Karte][EC]│
│                     │ │ [Abrechnen]     │
│                     │ └─────────────────┘│
└─────────────────────┴───────────────────┘
```

#### Beispiel Integration
```dart
POSTabEnhanced(
  salonId: 'salon-123',
  employeeId: 'emp-456',
)
```

---

### 2. CustomersTab (`customers_tab.dart`)
**Kundenmanagement mit Such- und Filterfunktion**

#### Features
- Kundenliste mit Search/Filter
- Sortierung nach: Name, Besuche, Ausgaben
- Kundendetails in BottomSheet
- Statistiken: Besuche, Ausgaben, letzter Besuch
- Buchungshistorie
- Kontakt-Aktionen (Anruf, Nachricht)

#### Komponenten
- `CustomersTab` - Hauptwidget (ConsumerStateful)
- `_CustomerCard` - Kundenlisten-Element
- `_CustomerDetailsSheet` - Detail-Modalfenster

#### Riverpod Providers
```dart
salonCustomersProvider(salonId) // FutureProvider<List<SalonCustomerDto>>
customerWithHistoryProvider(customerId) // FutureProvider<CustomerWithHistoryDto>
```

#### UI Layout
```
┌──────────────────────────────────┐
│ [Suchfeld........................]│
│ [Name][Besuche][Ausgaben][▲▼]   │
├──────────────────────────────────┤
│ ┌─────────────────────────────────┐│
│ │ [AS] Anna Schmitt              ││
│ │      anna@example.com           ││
│ │      5 Besuche  €250           ││
│ └─────────────────────────────────┘│
│ ┌─────────────────────────────────┐│
│ │ [MM] Maria Müller              ││
│ │      maria@example.com          ││
│ │      12 Besuche  €580          ││
│ └─────────────────────────────────┘│
└──────────────────────────────────┘

BottomSheet (on tap):
┌────────────────────────────────┐
│ [AS] Anna Schmitt              │
│ Kunde seit 15. Jan 2024        │
├────────────────────────────────┤
│ Kontakt:                       │
│ 📞 +49 123 456789              │
│ 📧 anna@example.com            │
├────────────────────────────────┤
│ Statistiken:                   │
│ 5 Besuche | €250 | 7. Dez     │
├────────────────────────────────┤
│ Buchungshistorie:              │
│ ✓ 7. Dez 2024 • 14:00  €45     │
│ ✓ 30. Nov 2024 • 10:30  €50    │
├────────────────────────────────┤
│ [💬 Nachricht senden][☎ Anrufen]│
└────────────────────────────────┘
```

#### Datenmodelle
```dart
SalonCustomerDto {
  id, salonId, firstName, lastName,
  email, phone, createdAt, updatedAt,
  appointments[], totalSpending, lastVisitDate
}

AppointmentSummaryDto {
  id, startTime, status, price
}
```

#### Beispiel Integration
```dart
CustomersTab(
  salonId: 'salon-123',
)
```

---

### 3. PortfolioTab (`portfolio_tab.dart`)
**Portfolio-Galerie mit Upload und Lightbox**

#### Features
- Responsive Grid-Layout (2-3 Spalten umschaltbar)
- Bilder mit Captions, Haarfarbe, Frisurtyp
- Cached Network Image mit Fallback
- Lightbox mit PageView (Wischen)
- Bild-Metadaten anzeigen
- Teilen/Löschen Funktionen
- Upload-Dialog (Camera/Galerie)

#### Komponenten
- `PortfolioTab` - Hauptwidget (ConsumerStateful)
- `_PortfolioImageCard` - Bild-Gitterelement mit Hover
- `_ImageLightbox` - Vollbild Carousel Modal

#### Riverpod Providers
```dart
employeePortfolioProvider(employeeId) 
  // FutureProvider<List<EmployeePortfolioImageDto>>

employeePortfolioWithTagsProvider(employeeId)
  // FutureProvider<List<EmployeePortfolioImageWithTagsDto>>
```

#### UI Layout
```
┌─────────────────────────────────┐
│ Portfolio  [🟦 🔲] [+]           │
│ 24 Bilder                       │
├─────────────────────────────────┤
│ ┌──────┐ ┌──────┐ ┌──────┐     │
│ │ 📷   │ │ 📷   │ │ 📷   │     │
│ │  Hl. │ │  Bo. │ │  Fa. │     │
│ │ Blond│ │Brown │ │ Rot  │     │
│ └──────┘ └──────┘ └──────┘     │
│ ┌──────┐ ┌──────┐ ┌──────┐     │
│ │ 📷   │ │ 📷   │ │ 📷   │     │
│ │ Fle. │ │ Loc. │ │ Str. │     │
│ └──────┘ └──────┘ └──────┘     │
└─────────────────────────────────┘

Lightbox (on tap):
┌────────────────────────────────┐
│ Bild 5 von 24  Blonde Highlights│
│ [X]                            │
├────────────────────────────────┤
│         🖼 [Carousel]          │
│  ◄        (PageView)         ► │
│          (Wischen)            │
├────────────────────────────────┤
│ Frisur: Highlights             │
│ Farbe:  🟨 #FFD700             │
│ Datum:  7. Dez 2024            │
├────────────────────────────────┤
│ [Share] [Delete]               │
└────────────────────────────────┘
```

#### Datenmodelle
```dart
EmployeePortfolioImageDto {
  id, employeeId, imageUrl, caption,
  createdAt, color, hairstyle,
  mimeType, fileSize, height, width
}
```

#### Beispiel Integration
```dart
PortfolioTab(
  employeeId: 'emp-456',
  employeeName: 'Max Mustermann',
)
```

---

### 4. PastAppointmentsTab (`past_appointments_tab.dart`)
**Vergangene Termine mit Filterung und Statistiken**

#### Features
- Datum-Range-Picker mit Quick-Buttons (30T, 90T, 1J)
- Status-Filter (Alle, Abgeschlossen, Abgebrochen, Ausstehend)
- Statistiken: Gesamt, Abgeschlossen, Ertrag, Quote
- Sortierung nach Datum (neueste zuerst)
- Detail-BottomSheet mit Rechnung/Share
- Responsive Design

#### Komponenten
- `PastAppointmentsTab` - Hauptwidget (ConsumerStateful)
- `_PastAppointmentCard` - Termin-Listenelement
- `_AppointmentDetailsSheet` - Detail-Modal
- `_DateRangePickerDialog` - Datum-Wähler Dialog

#### Riverpod Providers
```dart
pastAppointmentsProvider((employeeId, limit))
  // FutureProvider<List<PastAppointmentDto>>

appointmentStatisticsProvider(employeeId)
  // FutureProvider<AppointmentStatisticsDto>
```

#### UI Layout
```
┌──────────────────────────────────┐
│ [📅 7. Dez 2024 - 90 Tage ▼]    │
│ [30T] [90T] [1J] [▲▼]           │
│ [Alle] [✓ Abg.] [✗ Abgbr.] [⏱ Ausst.]
├──────────────────────────────────┤
│ ┌──────────────────────────────┐ │
│ │ 📊 Gesamt  Abg.    Ertrag  Quote
│ │    125     110     €4,850   88%  │
│ └──────────────────────────────┘ │
├──────────────────────────────────┤
│ ┌──────────────────────────────┐ │
│ │ 7.Dez  Anna Müller         │✓│ │
│ │ 14:00  Haarschnitt + Färben │ │ │
│ │        €75                  │ │ │
│ └──────────────────────────────┘ │
│ ┌──────────────────────────────┐ │
│ │ 6.Dez  Maria Schmidt        │✓│ │
│ │ 10:30  Lockenerstellung     │ │ │
│ │        €95                  │ │ │
│ └──────────────────────────────┘ │
└──────────────────────────────────┘

BottomSheet (on tap):
┌────────────────────────────────┐
│ Termin-Details                 │
│ Dienstag, 7. Dezember 2024  [X]│
├────────────────────────────────┤
│ Kundin/Kunde:                  │
│ 👤 Anna Müller                 │
│ 📧 anna@example.com            │
├────────────────────────────────┤
│ Termin-Information:            │
│ ⏰ 14:00                        │
│ 📅 7. Dezember 2024            │
│ # APT-00147                    │
├────────────────────────────────┤
│ Status & Zahlung:              │
│ ℹ Status: [✓ Abgeschlossen]    │
│ € Betrag: €75,00               │
├────────────────────────────────┤
│ [📥 Rechnung] [Share]          │
└────────────────────────────────┘
```

#### Datenmodelle
```dart
PastAppointmentDto {
  id, customerProfileId, guestName, guestEmail,
  serviceId, startTime, status, price,
  appointmentNumber
}

AppointmentStatisticsDto {
  totalAppointments, totalCompleted,
  totalCancelled, totalRevenue, completionRate
}
```

#### Beispiel Integration
```dart
PastAppointmentsTab(
  employeeId: 'emp-456',
)
```

---

## Integration in existendes Dashboard

### Option 1: Separate Tabs im Employee Dashboard
```dart
// In employee_dashboard_screen.dart
Tab(icon: Icon(LucideIcons.store), text: 'Tools'),
// In TabBarView:
EmployeeTabsIntegration(
  salonId: widget.salonId,
  employeeId: widget.employeeId,
),
```

### Option 2: Neue Seite
```dart
GoRoute(
  path: '/employee/tools',
  builder: (context, state) => EmployeeTabsIntegration(
    salonId: state.pathParameters['salonId'] ?? '',
    employeeId: state.pathParameters['employeeId'] ?? '',
  ),
),
```

### Option 3: Individual Tabs
```dart
// Nur POS
POSTabEnhanced(salonId: 'salon-123', employeeId: 'emp-456')

// Nur Kunden
CustomersTab(salonId: 'salon-123')

// Nur Portfolio
PortfolioTab(employeeId: 'emp-456')

// Nur Historie
PastAppointmentsTab(employeeId: 'emp-456')
```

---

## Styling & Theme

### Gold Theme (#CC9933)
Alle Widgets verwenden:
- **Primary**: `AppColors.gold` (#CC9933)
- **Background**: `Colors.black`
- **Cards**: `Colors.grey[900]`
- **Text Primary**: `Colors.white`
- **Text Secondary**: `Colors.white70`

### Icons
- **Lucide Icons** für konsistente Design
- Größen: 14px (small), 18px (medium), 24px (large), 48px (xlarge)

### Spacing
- Standard: 16px Padding/Margin
- Cards: 12px zwischen Elementen
- Dividers: `Colors.white10` oder `Colors.white24`

---

## Error Handling & States

Alle Widgets bieten:

### Loading State
```dart
Center(child: CircularProgressIndicator())
```

### Error State
```
┌────────────────────────────────┐
│  ⚠️                            │
│  Fehler beim Laden...          │
│  [Erneut versuchen]            │
└────────────────────────────────┘
```

### Empty State
```
┌────────────────────────────────┐
│  📦                            │
│  Keine Daten gefunden          │
│  (sprechender Hinweis)         │
└────────────────────────────────┘
```

---

## Riverpod Integration Checklist

- [x] Alle Provider sind in `lib/providers/employee_dashboard_provider.dart` definiert
- [x] DTOs sind in `lib/models/employee_dashboard_dto.dart` definiert
- [x] Repository implementiert alle Methoden
- [x] Cache Invalidation via `employeeDashboardCacheProvider`

---

## Material 3 Compliance

- [x] Abgerundete Ecken (12px Standard)
- [x] Elevation und Schatten
- [x] Gradient-Hintergründe selektiv
- [x] Responsive Layout
- [x] Dark Mode Support (durchgehend schwarz)
- [x] Accessibility (Color Contrast, Icon Labels)

---

## Performance Optimizations

1. **CachedNetworkImage** für Portfolio-Bilder
2. **SingleChildScrollView** mit NeverScrollableScrollPhysics für nested scrolls
3. **ListView.builder** statt Column für große Listen
4. **FilterChip** mit Riverpod für Filterstate
5. **DraggableScrollableSheet** für modales Scrolling

---

## Testing

Mock data für alle Tabs:

```dart
// lib/utils/mock_data.dart verfügbar mit:
// - mockServices (10 Services)
// - mockCustomers (15 Customers)
// - mockPortfolioImages (24 Images)
// - mockPastAppointments (50 Appointments)
// - mockStatistics (Statistics)
```

---

## File Structure
```
lib/features/employee/presentation/
├── customers_tab.dart              (745 lines)
├── portfolio_tab.dart              (703 lines)
├── past_appointments_tab.dart      (965 lines)
├── pos_tab_enhanced.dart           (853 lines)
├── employee_tabs_integration.dart  (377 lines)
└── EMPLOYEE_TABS_README.md         (This file)
```

Total: ~3,600 Lines of Production Code

---

## Weitere Features (Roadmap)

- [ ] Offline Mode mit Hive Caching
- [ ] PDF Invoice Generation
- [ ] WhatsApp Integration für Kundenkontakt
- [ ] Advanced Analytics Dashboard
- [ ] Batch Operations (Mehrfach-Abrechnung)
- [ ] Custom Date Range Presets
- [ ] Image Filter & Edit (für Portfolio)
- [ ] Service Templates & Bundles

---

## Support & Debugging

### Console Output
- Alle async Fehler werden geloggt
- SnackBar für User-Feedback
- Error Boundary mit Retry-Buttons

### State Management
- Riverpod DevTools zur Verfügung
- Cache manuell refreshbar via Buttons
- Komplette Provider-Integration

---

Viel Spaß mit den neuen Tabs! 🎉
