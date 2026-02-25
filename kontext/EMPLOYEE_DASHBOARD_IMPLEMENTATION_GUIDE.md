# Employee Dashboard Tabs - Implementation Guide

**Version:** 1.0
**Datum:** 2026-02-15
**Status:** Ready for Implementation

---

## Überblick

3 neue Tabs für das Employee Dashboard wurden mit vollständiger Supabase Integration, Freezed DTOs und Repository Pattern implementiert:

1. **POS Tab** - Services zum Verkauf
2. **Customers Tab** - Salon-Kunden
3. **Portfolio Tab** - Mitarbeiter-Portfolio
4. **Past Appointments Tab** - Archivierte Termine

---

## Erstellte Dateien

### 1. Backend/Repository
```
lib/features/employee/data/employee_dashboard_repository.dart
```
- 7 Query-Methoden
- Repository Pattern mit Supabase Client
- Error Handling
- Filtering & Sorting

**Methoden:**
- `getSalonServices(salonId)` - POS Services
- `getSalonCustomers(salonId)` - Salon Customers
- `getEmployeePortfolio(employeeId)` - Portfolio Bilder
- `getEmployeePortfolioWithTags(employeeId)` - Portfolio mit Tags
- `getPastAppointments(employeeId, limit)` - Archivierte Termine
- `getAppointmentStatistics(employeeId)` - Statistiken
- `getCustomerWithHistory(customerId)` - Customer + History

### 2. Data Transfer Objects (DTOs)
```
lib/models/employee_dashboard_dto.dart
```
- 7 Freezed DTOs mit JSON Serialization
- Type-safe Daten zwischen Repository und UI
- Computed Fields (z.B. totalSpending, lastVisitDate)

**DTOs:**
- `SalonServiceDto`
- `SalonCustomerDto`
- `AppointmentSummaryDto`
- `EmployeePortfolioImageDto`
- `EmployeePortfolioImageWithTagsDto`
- `PastAppointmentDto`
- `AppointmentStatisticsDto`
- `CustomerWithHistoryDto`

### 3. State Management (Riverpod)
```
lib/providers/employee_dashboard_provider.dart
```
- 7 FutureProviders für AsyncValue Handling
- Cache Invalidation Notifier
- Auto-refresh Funktionen

**Provider:**
- `salonServicesProvider(salonId)`
- `salonCustomersProvider(salonId)`
- `employeePortfolioProvider(employeeId)`
- `employeePortfolioWithTagsProvider(employeeId)`
- `pastAppointmentsProvider((employeeId, limit))`
- `appointmentStatisticsProvider(employeeId)`
- `customerWithHistoryProvider(customerId)`
- `employeeDashboardCacheProvider` - Cache Management

### 4. UI Example
```
lib/features/employee/presentation/pos_services_tab.dart
```
- Vollständige POS Services Tab Implementation
- Category Filter
- Service Cards mit Details
- Error & Loading States
- Add to Cart Funktionalität

### 5. Documentation
```
kontext/EMPLOYEE_DASHBOARD_QUERIES.md
kontext/EMPLOYEE_DASHBOARD_IMPLEMENTATION_GUIDE.md
```

---

## Schnellstart

### Schritt 1: Freezed Code Generation

```bash
cd salonmanager
dart run build_runner build
```

Das generiert die `.freezed.dart` und `.g.dart` Dateien automatisch.

### Schritt 2: DTOs Exportieren

Füge in `lib/models/mod_export.dart` hinzu:

```dart
export 'employee_dashboard_dto.dart';
```

### Schritt 3: Integration in Employee Dashboard

Aktualisiere `lib/features/employee/dashboard/employee_dashboard_screen.dart`:

```dart
import '../../../providers/employee_dashboard_provider.dart';
import '../presentation/pos_services_tab.dart';
import '../presentation/customers_tab.dart';
import '../presentation/portfolio_tab.dart';
import '../presentation/past_appointments_tab.dart';

class EmployeeDashboardScreen extends ConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this); // 7 statt 4 tabs
  }

  @override
  Widget build(BuildContext context) {
    final currentSalonId = ref.watch(currentSalonProvider);
    final currentEmployeeId = ref.watch(currentEmployeeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mitarbeiter-Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            // Existing tabs
            Tab(icon: Icon(LucideIcons.calendar), text: 'Termine'),
            Tab(icon: Icon(LucideIcons.clock), text: 'Zeiterfassung'),
            Tab(icon: Icon(LucideIcons.qrCode), text: 'QR-Check-in'),
            Tab(icon: Icon(LucideIcons.umbrellaOff), text: 'Urlaub'),

            // New tabs
            Tab(icon: Icon(LucideIcons.shoppingCart), text: 'POS'),
            Tab(icon: Icon(LucideIcons.users), text: 'Kunden'),
            Tab(icon: Icon(LucideIcons.image), text: 'Portfolio'),
            Tab(icon: Icon(LucideIcons.history), text: 'Archiv'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Existing tabs
          _buildAppointmentsTab(context),
          _buildTimeTrackingTab(context),
          _buildQRCheckInTab(context),
          _buildLeaveRequestsTab(context),

          // New tabs
          PosServicesTab(salonId: currentSalonId),
          CustomersTab(salonId: currentSalonId),
          PortfolioTab(employeeId: currentEmployeeId),
          PastAppointmentsTab(employeeId: currentEmployeeId),
        ],
      ),
    );
  }
}
```

---

## UI Tab Implementierungen

### POS Services Tab

```dart
import '../../../providers/employee_dashboard_provider.dart';

class PosServicesTab extends ConsumerStatefulWidget {
  final String salonId;
  const PosServicesTab({required this.salonId, super.key});

  @override
  ConsumerState<PosServicesTab> createState() => _PosServicesTabState();
}

class _PosServicesTabState extends ConsumerState<PosServicesTab> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(salonServicesProvider(widget.salonId));

    return servicesAsync.when(
      data: (services) => ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return ServiceCard(service: service);
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (e, s) => ErrorWidget(),
    );
  }
}
```

Vollständiges Beispiel siehe: `lib/features/employee/presentation/pos_services_tab.dart`

### Customers Tab

```dart
class CustomersTab extends ConsumerWidget {
  final String salonId;
  const CustomersTab({required this.salonId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(salonCustomersProvider(widget.salonId));

    return customersAsync.when(
      data: (customers) => ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return CustomerCard(
            customer: customer,
            onTap: () => showCustomerDetail(context, customer),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (e, s) => ErrorWidget(),
    );
  }

  void showCustomerDetail(BuildContext context, SalonCustomerDto customer) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CustomerDetailSheet(customer: customer),
    );
  }
}
```

### Portfolio Tab

```dart
class PortfolioTab extends ConsumerWidget {
  final String employeeId;
  const PortfolioTab({required this.employeeId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioAsync = ref.watch(employeePortfolioProvider(widget.employeeId));

    return portfolioAsync.when(
      data: (images) => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return PortfolioImageCard(image: image);
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (e, s) => ErrorWidget(),
    );
  }
}
```

### Past Appointments Tab

```dart
class PastAppointmentsTab extends ConsumerWidget {
  final String employeeId;
  const PastAppointmentsTab({required this.employeeId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(
      pastAppointmentsProvider((widget.employeeId, 50))
    );

    return appointmentsAsync.when(
      data: (appointments) => ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final apt = appointments[index];
          return AppointmentCard(appointment: apt);
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (e, s) => ErrorWidget(),
    );
  }
}
```

---

## Provider Usage Patterns

### Einfacher Load

```dart
final servicesAsync = ref.watch(salonServicesProvider(salonId));

servicesAsync.when(
  data: (data) => ServicesList(data),
  loading: () => Loader(),
  error: (e, s) => ErrorWidget(),
);
```

### Mit Cache Invalidation

```dart
// Manueller Refresh
ref.refresh(salonServicesProvider(salonId));

// Über den Cache Notifier
ref.read(employeeDashboardCacheProvider.notifier)
    .refreshSalonServices(salonId);

// Alle gleichzeitig aktualisieren
ref.read(employeeDashboardCacheProvider.notifier)
    .refreshAll(salonId, employeeId);
```

### Fehlerbehandlung

```dart
servicesAsync.whenData((services) {
  if (services.isEmpty) {
    return EmptyStateWidget();
  }
  return ServicesList(services);
}).when(
  data: (widget) => widget,
  loading: () => Loader(),
  error: (e, s) {
    print('Error: $e');
    return ErrorWidget(error: e);
  },
);
```

---

## Performance Optimierungen

### 1. Index auf Supabase erstellen

```sql
-- Für schnellere Queries
CREATE INDEX idx_services_salon_active
ON services(salon_id, is_active);

CREATE INDEX idx_customer_profiles_salon_deleted
ON customer_profiles(salon_id, deleted_at);

CREATE INDEX idx_appointments_customer_status
ON appointments(customer_profile_id, status);

CREATE INDEX idx_gallery_images_employee
ON gallery_images(employee_id, created_at DESC);

CREATE INDEX idx_appointments_employee_status_time
ON appointments(employee_id, status, start_time DESC);
```

### 2. RLS Policies überprüfen

```sql
-- Services - Employees können Services ihres Salons sehen
CREATE POLICY "employees_can_view_salon_services"
ON services
FOR SELECT
USING (
  salon_id = (
    SELECT salon_id FROM employees
    WHERE user_id = auth.uid()
  )
);

-- Customers - Employees können Kunden ihres Salons sehen
CREATE POLICY "employees_can_view_salon_customers"
ON customer_profiles
FOR SELECT
USING (
  salon_id = (
    SELECT salon_id FROM employees
    WHERE user_id = auth.uid()
  )
);

-- Gallery Images - Employees können ihre eigenen Portfolio-Bilder sehen
CREATE POLICY "employees_can_view_own_portfolio"
ON gallery_images
FOR SELECT
USING (employee_id = auth.uid());

-- Appointments - Employees können nur ihre eigenen Termine sehen
CREATE POLICY "employees_can_view_own_appointments"
ON appointments
FOR SELECT
USING (employee_id = auth.uid());
```

### 3. Caching-Strategie

```dart
// Cache Durations
const Duration SERVICES_CACHE = Duration(hours: 1);
const Duration CUSTOMERS_CACHE = Duration(minutes: 15);
const Duration PORTFOLIO_CACHE = Duration(minutes: 30);
const Duration PAST_APPOINTMENTS_CACHE = Duration(minutes: 5);
const Duration STATISTICS_CACHE = Duration(minutes: 10);
```

---

## Testing

### Unit Tests für Repository

```dart
test('getSalonServices returns list of services', () async {
  final repository = EmployeeDashboardRepository(mockClient);

  when(mockClient.from('services').select()...).thenReturn(mockQuery);

  final result = await repository.getSalonServices('salon-123');

  expect(result, isA<List<SalonServiceDto>>());
  expect(result.length, greaterThan(0));
  verify(mockClient.from('services').select()).called(1);
});

test('getSalonCustomers calculates total spending correctly', () async {
  final repository = EmployeeDashboardRepository(mockClient);

  final result = await repository.getSalonCustomers('salon-123');

  expect(result.first.totalSpending, equals(500.00));
  expect(result.first.appointments.length, equals(10));
});

test('getPastAppointments filters by status and date', () async {
  final repository = EmployeeDashboardRepository(mockClient);

  final result = await repository.getPastAppointments(
    employeeId: 'emp-123',
    limit: 50,
  );

  expect(result, everyElement((apt) =>
    apt.status == 'completed' || apt.status == 'cancelled'
  ));
});
```

### Widget Tests

```dart
testWidgets('PosServicesTab displays service list', (WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderContainer(
      child: MaterialApp(
        home: Scaffold(
          body: PosServicesTab(salonId: 'salon-123'),
        ),
      ),
    ),
  );

  expect(find.byType(ServiceCard), findsWidgets);
  expect(find.text('Haarschnitt'), findsOneWidget);
});
```

---

## Deployment Checklist

- [ ] Freezed Code Generation durchführen (`dart run build_runner build`)
- [ ] DTOs in Model Exports hinzufügen
- [ ] RLS Policies auf Supabase erstellen
- [ ] Indexes erstellen
- [ ] UI Tabs implementieren
- [ ] Error Handling testen
- [ ] Offline Handling testen
- [ ] Performance testen (besonders für große Customer/Service Listen)
- [ ] Tests schreiben und durchführen
- [ ] Flutter Analyze durchführen
- [ ] Build testen für alle Plattformen

---

## Fehlerbehandlung

### Häufige Fehler

1. **"Freezed DTOs sind nicht generiert"**
   ```bash
   dart run build_runner clean
   dart run build_runner build
   ```

2. **"RLS Policy blockiert Query"**
   - Überprüfe ob User das Recht hat, die Ressourcen zu sehen
   - Prüfe Supabase RLS Policies

3. **"Timeout beim Laden großer Datenmengen"**
   - Pagination implementieren
   - Limit reduzieren
   - Indexes überprüfen

4. **"Null Safety Fehler in DTOs"**
   - Stelle sicher, dass alle optionalen Felder `?` haben
   - Verwende `@Default()` für Defaults

---

## Zukünftige Verbesserungen

1. **Pagination** - Für sehr große Listen (Customers, Past Appointments)
2. **Filtering & Search** - Kunden/Services durchsuchen
3. **Offline Support** - Lokales Caching mit Hive
4. **Real-time Updates** - Supabase Real-time Subscriptions
5. **Analytics** - Mehr Statistiken für Employees
6. **Export** - Daten als PDF/CSV exportieren

---

## Support & Debugging

### Debug-Tipps

1. **Riverpod DevTools**
   ```dart
   import 'package:riverpod_graph/riverpod_graph.dart';

   // In Main App
   builder: (context, home) => RiverpodScope(child: home),
   ```

2. **Supabase Logging**
   ```dart
   SupabaseClient(...).rest.headers['Authorization'];
   ```

3. **Query-Monitoring**
   ```dart
   // In Repository
   print('Query: ${query.toString()}');
   ```

---

## Kontakt

Bei Fragen oder Problemen:
- Repository: C:\Users\Tobi\Documents\GitHub\salonmanager
- Branch: claude/blissful-jang
- Dokumentation: kontext/EMPLOYEE_DASHBOARD_QUERIES.md

---

**Fertig zum Implementieren!**
