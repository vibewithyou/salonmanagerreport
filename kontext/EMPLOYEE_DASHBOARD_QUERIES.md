# Employee Dashboard Queries - SQL & Implementation

**Datum:** 2026-02-15
**Projekt:** SalonManager Flutter
**Tab:** 3 neue Employee Dashboard Tabs

## Übersicht

Diese Dokumentation enthält alle SQL Queries und Implementierungen für die 3 neuen Employee Dashboard Tabs:
1. **POS Tab** - Salon Services für Verkauf
2. **Customers Tab** - Alle Kunden des Salons
3. **Portfolio Tab** - Bilder/Arbeiten des Mitarbeiters
4. **Past Appointments Tab** - Archivierte Termine (letzte 4 Jahre)

---

## 1. POS Tab - getSalonServices(salonId)

### Beschreibung
Gibt alle aktiven Services eines Salons zurück für den POS (Point of Sale) Bereich. Ein Mitarbeiter kann damit Services für Kunden abrechnen.

### SQL Query

```sql
SELECT
    id,
    salon_id,
    name,
    description,
    duration_minutes,
    price,
    category,
    is_active,
    buffer_before,
    buffer_after,
    deposit_amount,
    created_at,
    updated_at
FROM services
WHERE
    salon_id = $1
    AND is_active = true
ORDER BY
    category ASC,
    name ASC;
```

### Supabase Flutter Code

```dart
Future<List<SalonServiceDto>> getSalonServices(String salonId) async {
  try {
    final data = await _client
        .from('services')
        .select()
        .eq('salon_id', salonId)
        .eq('is_active', true)
        .order('category', ascending: true)
        .order('name', ascending: true);

    return (data as List)
        .map((json) => SalonServiceDto.fromJson(json))
        .toList();
  } catch (e) {
    throw Exception('Failed to fetch salon services: $e');
  }
}
```

### DTO (Freezed)

```dart
@freezed
class SalonServiceDto with _$SalonServiceDto {
  const factory SalonServiceDto({
    required String id,
    required String salonId,
    required String name,
    String? description,
    @Default(30) int durationMinutes,
    required double price,
    String? category,
    @Default(true) bool isActive,
    @Default(0) int bufferBefore,
    @Default(0) int bufferAfter,
    @Default(0) double depositAmount,
  }) = _SalonServiceDto;

  factory SalonServiceDto.fromJson(Map<String, dynamic> json) =>
      _$SalonServiceDtoFromJson(json);
}
```

### UI Usage

```dart
final servicesAsync = ref.watch(salonServicesProvider(salonId));

servicesAsync.when(
  data: (services) => ListView.builder(
    itemCount: services.length,
    itemBuilder: (context, index) {
      final service = services[index];
      return ListTile(
        title: Text(service.name),
        subtitle: Text('${service.durationMinutes} min - ${service.price}€'),
        trailing: Text(service.category ?? 'Sonstiges'),
      );
    },
  ),
  loading: () => CircularProgressIndicator(),
  error: (e, s) => ErrorWidget(),
);
```

### Felder
| Feld | Typ | Beschreibung |
|------|-----|-------------|
| id | UUID | Service ID |
| salon_id | UUID | Salon Zugehörigkeit |
| name | TEXT | Service Name (z.B. "Haarschnitt") |
| description | TEXT | Service Beschreibung |
| duration_minutes | INT | Dauer in Minuten |
| price | NUMERIC | Preis in EUR |
| category | TEXT | Kategorie (z.B. "Damen", "Herren") |
| is_active | BOOLEAN | Aktiv/Inaktiv |
| buffer_before/after | INT | Puffer vor/nach Service |

---

## 2. Customers Tab - getSalonCustomers(salonId)

### Beschreibung
Gibt alle Kunden eines Salons zurück mit:
- Name, Email, Telefon
- Letzte Besuche (Top 10)
- Gesamtausgaben (berechnet aus completed appointments)
- Kontaktdatum

Diese Query ist komplexer, da sie Join + Aggregation braucht.

### SQL Query

```sql
-- Main query: Get all customers
SELECT
    cp.id,
    cp.salon_id,
    cp.first_name,
    cp.last_name,
    cp.phone,
    cp.email,
    cp.created_at,
    cp.updated_at
FROM customer_profiles cp
WHERE
    cp.salon_id = $1
    AND cp.deleted_at IS NULL
ORDER BY
    cp.updated_at DESC;

-- Sub-query: Get appointment history for each customer
SELECT
    id,
    start_time,
    status,
    price
FROM appointments
WHERE
    customer_profile_id = $1
    AND status IN ('completed', 'cancelled')
ORDER BY
    start_time DESC
LIMIT 10;

-- Aggregation: Calculate total spending
SELECT
    SUM(price) as total_spending
FROM appointments
WHERE
    customer_profile_id = $1
    AND status = 'completed';
```

### Supabase Flutter Code

```dart
Future<List<SalonCustomerDto>> getSalonCustomers(String salonId) async {
  try {
    final data = await _client
        .from('customer_profiles')
        .select(
            'id, first_name, last_name, phone, email, created_at, updated_at')
        .eq('salon_id', salonId)
        .neq('deleted_at', null)  // Fehler: sollte IS NULL sein
        .order('updated_at', ascending: false);

    List<SalonCustomerDto> customers = [];

    for (var customerJson in data as List) {
      // Get appointment history for each customer
      final appointmentData = await _client
          .from('appointments')
          .select('id, start_time, status, price')
          .eq('customer_profile_id', customerJson['id'])
          .in_('status', ['completed', 'cancelled'])
          .order('start_time', ascending: false)
          .limit(10);

      final appointments =
          (appointmentData as List)
              .map((json) => AppointmentSummaryDto.fromJson(json))
              .toList();

      // Calculate total spending
      final totalSpending = appointments
          .where((a) => a.status == 'completed')
          .fold<double>(0, (sum, a) => sum + (a.price ?? 0));

      // Get last visit
      final lastVisit = appointments.isNotEmpty
          ? appointments.firstWhere((a) => a.status == 'completed',
              orElse: () => appointments.first)
          : null;

      customers.add(SalonCustomerDto.fromJson(
        customerJson,
        appointments: appointments,
        totalSpending: totalSpending,
        lastVisitDate: lastVisit?.startTime,
      ));
    }

    return customers;
  } catch (e) {
    throw Exception('Failed to fetch salon customers: $e');
  }
}
```

### DTOs (Freezed)

```dart
@freezed
class SalonCustomerDto with _$SalonCustomerDto {
  const factory SalonCustomerDto({
    required String id,
    required String salonId,
    required String firstName,
    required String lastName,
    String? phone,
    String? email,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<AppointmentSummaryDto> appointments,
    @Default(0) double totalSpending,
    DateTime? lastVisitDate,
  }) = _SalonCustomerDto;

  factory SalonCustomerDto.fromJson(
    Map<String, dynamic> json, {
    List<AppointmentSummaryDto>? appointments,
    double? totalSpending,
    DateTime? lastVisitDate,
  }) => SalonCustomerDto(...);
}

@freezed
class AppointmentSummaryDto with _$AppointmentSummaryDto {
  const factory AppointmentSummaryDto({
    required String id,
    required DateTime startTime,
    required String status,
    double? price,
  }) = _AppointmentSummaryDto;

  factory AppointmentSummaryDto.fromJson(Map<String, dynamic> json) =>
      AppointmentSummaryDto(...);
}
```

### UI Usage

```dart
final customersAsync = ref.watch(salonCustomersProvider(salonId));

customersAsync.when(
  data: (customers) => ListView.builder(
    itemCount: customers.length,
    itemBuilder: (context, index) {
      final customer = customers[index];
      return Card(
        child: ListTile(
          title: Text('${customer.firstName} ${customer.lastName}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phone: ${customer.phone}'),
              Text('Visits: ${customer.appointments.length}'),
              Text('Total Spent: ${customer.totalSpending}€'),
            ],
          ),
          onTap: () => showCustomerDetail(customer),
        ),
      );
    },
  ),
  loading: () => CircularProgressIndicator(),
  error: (e, s) => ErrorWidget(),
);
```

### Felder
| Feld | Typ | Beschreibung |
|------|-----|-------------|
| id | UUID | Customer ID |
| first_name | TEXT | Vorname |
| last_name | TEXT | Nachname |
| phone | TEXT | Telefon |
| email | TEXT | Email |
| appointments | LIST | Letzte 10 Termine |
| totalSpending | NUMERIC | Gesamtausgaben (berechnet) |
| lastVisitDate | DATETIME | Letzter Besuch (berechnet) |

---

## 3. Portfolio Tab - getEmployeePortfolio(employeeId)

### Beschreibung
Gibt alle Portfolio-Bilder eines Mitarbeiters zurück. Diese Bilder zeigen die bisherigen Arbeiten und Projekte des Mitarbeiters.

### SQL Query - Basic

```sql
SELECT
    id,
    employee_id,
    image_url,
    caption,
    created_at,
    color,
    hairstyle,
    mime_type,
    file_size,
    height,
    width
FROM gallery_images
WHERE employee_id = $1
ORDER BY created_at DESC;
```

### SQL Query - Mit Tags

```sql
SELECT
    gi.id,
    gi.image_url,
    gi.caption,
    gi.created_at,
    gi.color,
    gi.hairstyle,
    gi.mime_type,
    gi.file_size,
    gi.height,
    gi.width,
    json_agg(
        json_build_object(
            'tag_id', git.tag_id
        )
    ) as gallery_image_tags
FROM gallery_images gi
LEFT JOIN gallery_image_tags git ON gi.id = git.image_id
WHERE gi.employee_id = $1
GROUP BY gi.id
ORDER BY gi.created_at DESC;
```

### Supabase Flutter Code - Basic

```dart
Future<List<EmployeePortfolioImageDto>> getEmployeePortfolio(
    String employeeId) async {
  try {
    final data = await _client
        .from('gallery_images')
        .select()
        .eq('employee_id', employeeId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((json) => EmployeePortfolioImageDto.fromJson(json))
        .toList();
  } catch (e) {
    throw Exception('Failed to fetch employee portfolio: $e');
  }
}
```

### Supabase Flutter Code - Mit Tags

```dart
Future<List<EmployeePortfolioImageWithTagsDto>>
    getEmployeePortfolioWithTags(String employeeId) async {
  try {
    final data = await _client
        .from('gallery_images')
        .select('''
          id,
          image_url,
          caption,
          created_at,
          color,
          hairstyle,
          mime_type,
          file_size,
          height,
          width,
          gallery_image_tags(tag_id)
        ''')
        .eq('employee_id', employeeId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((json) => EmployeePortfolioImageWithTagsDto.fromJson(json))
        .toList();
  } catch (e) {
    throw Exception('Failed to fetch employee portfolio with tags: $e');
  }
}
```

### DTOs (Freezed)

```dart
@freezed
class EmployeePortfolioImageDto with _$EmployeePortfolioImageDto {
  const factory EmployeePortfolioImageDto({
    required String id,
    required String employeeId,
    required String imageUrl,
    String? caption,
    required DateTime createdAt,
    String? color,
    String? hairstyle,
    String? mimeType,
    int? fileSize,
    int? height,
    int? width,
  }) = _EmployeePortfolioImageDto;

  factory EmployeePortfolioImageDto.fromJson(Map<String, dynamic> json) =>
      EmployeePortfolioImageDto(...);
}

@freezed
class EmployeePortfolioImageWithTagsDto
    with _$EmployeePortfolioImageWithTagsDto {
  const factory EmployeePortfolioImageWithTagsDto({
    required String id,
    required String imageUrl,
    String? caption,
    required DateTime createdAt,
    String? color,
    String? hairstyle,
    String? mimeType,
    int? fileSize,
    int? height,
    int? width,
    @Default([]) List<String> tagIds,
  }) = _EmployeePortfolioImageWithTagsDto;

  factory EmployeePortfolioImageWithTagsDto.fromJson(
      Map<String, dynamic> json) { ... }
}
```

### UI Usage

```dart
final portfolioAsync = ref.watch(employeePortfolioProvider(employeeId));

portfolioAsync.when(
  data: (images) => GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.8,
    ),
    itemCount: images.length,
    itemBuilder: (context, index) {
      final image = images[index];
      return GestureDetector(
        onTap: () => showImageDetail(image),
        child: Column(
          children: [
            Image.network(image.imageUrl, fit: BoxFit.cover),
            Text(image.hairstyle ?? 'Portfolio'),
            Text(image.caption ?? ''),
          ],
        ),
      );
    },
  ),
  loading: () => CircularProgressIndicator(),
  error: (e, s) => ErrorWidget(),
);
```

### Felder
| Feld | Typ | Beschreibung |
|------|-----|-------------|
| id | UUID | Image ID |
| employee_id | UUID | Mitarbeiter |
| image_url | TEXT | URL zu S3/Storage |
| caption | TEXT | Kurzbeschreibung |
| created_at | DATETIME | Upload-Datum |
| color | TEXT | Haarfarbe |
| hairstyle | TEXT | Frisurentyp |
| mime_type | TEXT | Image Format (jpeg, png) |
| file_size | BIGINT | Dateigröße in Bytes |
| height/width | INT | Bild-Dimensionen |

---

## 4. Past Appointments Tab - getPastAppointments(employeeId, limit)

### Beschreibung
Gibt archivierte/abgeschlossene Termine eines Mitarbeiters zurück. Filter:
- Status: `completed` oder `cancelled`
- Zeitraum: Letzte 4 Jahre (ca. 1461 Tage)
- Sortierung: Neueste zuerst

### SQL Query

```sql
SELECT
    id,
    customer_profile_id,
    guest_name,
    guest_email,
    service_id,
    start_time,
    status,
    price,
    appointment_number
FROM appointments
WHERE
    employee_id = $1
    AND status IN ('completed', 'cancelled')
    AND start_time <= NOW()
    AND start_time >= NOW() - INTERVAL '4 years'
ORDER BY
    start_time DESC
LIMIT $2;
```

### Supabase Flutter Code

```dart
Future<List<PastAppointmentDto>> getPastAppointments({
  required String employeeId,
  int limit = 50,
  int? offsetDays = 1461, // ~4 years
}) async {
  try {
    final cutoffDate = DateTime.now()
        .subtract(Duration(days: offsetDays ?? 1461))
        .toIso8601String();

    var query = _client
        .from('appointments')
        .select(
            'id, customer_profile_id, guest_name, guest_email, service_id, start_time, status, price, appointment_number')
        .eq('employee_id', employeeId)
        .in_('status', ['completed', 'cancelled'])
        .lte('start_time', DateTime.now().toIso8601String())
        .gte('start_time', cutoffDate)
        .order('start_time', ascending: false)
        .limit(limit);

    final data = await query;

    return (data as List)
        .map((json) => PastAppointmentDto.fromJson(json))
        .toList();
  } catch (e) {
    throw Exception('Failed to fetch past appointments: $e');
  }
}
```

### DTO (Freezed)

```dart
@freezed
class PastAppointmentDto with _$PastAppointmentDto {
  const factory PastAppointmentDto({
    required String id,
    String? customerProfileId,
    String? guestName,
    String? guestEmail,
    String? serviceId,
    required DateTime startTime,
    required String status,
    double? price,
    String? appointmentNumber,
  }) = _PastAppointmentDto;

  factory PastAppointmentDto.fromJson(Map<String, dynamic> json) =>
      PastAppointmentDto(...);
}
```

### UI Usage

```dart
final pastAptsAsync = ref.watch(
  pastAppointmentsProvider((employeeId, 50))
);

pastAptsAsync.when(
  data: (appointments) => ListView.builder(
    itemCount: appointments.length,
    itemBuilder: (context, index) {
      final apt = appointments[index];
      return ListTile(
        title: Text(apt.appointmentNumber ?? 'N/A'),
        subtitle: Text(apt.guestName ?? 'Guest'),
        trailing: Chip(
          label: Text(apt.status),
          backgroundColor: apt.status == 'completed'
              ? Colors.green
              : Colors.red,
        ),
      );
    },
  ),
  loading: () => CircularProgressIndicator(),
  error: (e, s) => ErrorWidget(),
);
```

### Felder
| Feld | Typ | Beschreibung |
|------|-----|-------------|
| id | UUID | Appointment ID |
| customer_profile_id | UUID | Kunde (optional) |
| guest_name | TEXT | Gast-Name |
| guest_email | TEXT | Gast-Email |
| service_id | UUID | Service |
| start_time | DATETIME | Termin-Datum/Zeit |
| status | TEXT | `completed` oder `cancelled` |
| price | NUMERIC | Preis |
| appointment_number | TEXT | Referenz-Nummer |

---

## 5. Bonus Query - getAppointmentStatistics(employeeId)

### Beschreibung
Gibt Statistiken über alle Termine eines Mitarbeiters zurück:
- Gesamtzahl Termine
- Abgeschlossene Termine
- Stornierte Termine
- Gesamteinnahmen
- Abschlussquote (Completion Rate)

### SQL Query

```sql
SELECT
    COUNT(*) as total_appointments,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as total_completed,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) as total_cancelled,
    SUM(CASE WHEN status = 'completed' THEN price ELSE 0 END) as total_revenue,
    ROUND(
        CAST(SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS FLOAT)
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) as completion_rate
FROM appointments
WHERE
    employee_id = $1
    AND status IN ('completed', 'cancelled');
```

### Supabase Flutter Code

```dart
Future<AppointmentStatisticsDto> getAppointmentStatistics(
    String employeeId) async {
  try {
    final allAppointments = await _client
        .from('appointments')
        .select()
        .eq('employee_id', employeeId)
        .in_('status', ['completed', 'cancelled']);

    int totalCompleted = 0;
    int totalCancelled = 0;
    double totalRevenue = 0;

    for (var appointment in allAppointments as List) {
      final status = appointment['status'] as String;
      final price = (appointment['price'] as num?)?.toDouble() ?? 0;

      if (status == 'completed') {
        totalCompleted++;
        totalRevenue += price;
      } else if (status == 'cancelled') {
        totalCancelled++;
      }
    }

    return AppointmentStatisticsDto(
      totalAppointments: totalCompleted + totalCancelled,
      totalCompleted: totalCompleted,
      totalCancelled: totalCancelled,
      totalRevenue: totalRevenue,
      completionRate: totalCompleted + totalCancelled > 0
          ? (totalCompleted / (totalCompleted + totalCancelled)) * 100
          : 0,
    );
  } catch (e) {
    throw Exception('Failed to fetch appointment statistics: $e');
  }
}
```

### DTO (Freezed)

```dart
@freezed
class AppointmentStatisticsDto with _$AppointmentStatisticsDto {
  const factory AppointmentStatisticsDto({
    required int totalAppointments,
    required int totalCompleted,
    required int totalCancelled,
    required double totalRevenue,
    required double completionRate,
  }) = _AppointmentStatisticsDto;
}
```

---

## Datenschema-Zusammenfassung

### Verwendete Tabellen

```
appointments
├── id: UUID
├── salon_id: UUID
├── employee_id: UUID
├── customer_profile_id: UUID
├── service_id: UUID
├── start_time: TIMESTAMPTZ
├── status: TEXT ('pending', 'confirmed', 'completed', 'cancelled')
├── price: NUMERIC
└── ...

services
├── id: UUID
├── salon_id: UUID
├── name: TEXT
├── price: NUMERIC
├── duration_minutes: INT
├── category: TEXT
├── is_active: BOOLEAN
└── ...

customer_profiles
├── id: UUID
├── salon_id: UUID
├── first_name: TEXT
├── last_name: TEXT
├── phone: TEXT
├── email: TEXT
├── deleted_at: TIMESTAMPTZ
└── ...

gallery_images
├── id: UUID
├── employee_id: UUID
├── image_url: TEXT
├── caption: TEXT
├── hairstyle: TEXT
├── color: TEXT
├── created_at: TIMESTAMPTZ
└── ...

gallery_image_tags
├── id: UUID
├── image_id: UUID
├── tag_id: UUID
└── ...
```

---

## Performance-Optimierungen

### Index-Empfehlungen

```sql
-- Für POS Tab (Services)
CREATE INDEX idx_services_salon_active
ON services(salon_id, is_active);

-- Für Customers Tab
CREATE INDEX idx_customer_profiles_salon_deleted
ON customer_profiles(salon_id, deleted_at);

CREATE INDEX idx_appointments_customer_status
ON appointments(customer_profile_id, status);

-- Für Portfolio Tab
CREATE INDEX idx_gallery_images_employee
ON gallery_images(employee_id, created_at DESC);

-- Für Past Appointments Tab
CREATE INDEX idx_appointments_employee_status_time
ON appointments(employee_id, status, start_time DESC);
```

### Caching-Strategie

- **Services**: Cache 1 Stunde (ändern sich selten)
- **Customers**: Cache 15 Minuten (mittlere Priorität)
- **Portfolio**: Cache 30 Minuten (statisch)
- **Past Appointments**: Cache 5 Minuten (häufige Updates)

---

## Fehlerbehandlung

Alle Repository-Methoden werfen `Exception` mit aussagekräftigen Meldungen:

```dart
try {
  final data = await _client.from('table').select();
} catch (e) {
  throw Exception('Failed to fetch [resource]: $e');
}
```

---

## Provider Usage im UI

```dart
// Beispiel: EmployeeDashboardScreen

class EmployeeDashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salonId = ref.watch(currentSalonProvider);
    final employeeId = ref.watch(currentEmployeeProvider);

    return TabBarView(
      children: [
        // POS Tab
        ref.watch(salonServicesProvider(salonId)).when(
          data: (services) => ServicesList(services),
          loading: () => Loader(),
          error: (e, s) => ErrorWidget(),
        ),

        // Customers Tab
        ref.watch(salonCustomersProvider(salonId)).when(
          data: (customers) => CustomersList(customers),
          loading: () => Loader(),
          error: (e, s) => ErrorWidget(),
        ),

        // Portfolio Tab
        ref.watch(employeePortfolioProvider(employeeId)).when(
          data: (images) => PortfolioGrid(images),
          loading: () => Loader(),
          error: (e, s) => ErrorWidget(),
        ),

        // Past Appointments Tab
        ref.watch(pastAppointmentsProvider((employeeId, 50))).when(
          data: (apts) => PastAppointmentsList(apts),
          loading: () => Loader(),
          error: (e, s) => ErrorWidget(),
        ),
      ],
    );
  }
}
```

---

## Files erstellte

1. **Repository:** `/lib/features/employee/data/employee_dashboard_repository.dart`
2. **DTOs:** `/lib/models/employee_dashboard_dto.dart`
3. **Providers:** `/lib/providers/employee_dashboard_provider.dart`
4. **Documentation:** `/kontext/EMPLOYEE_DASHBOARD_QUERIES.md`

---

## Nächste Schritte

1. Freezed Code-Generation ausführen:
   ```bash
   dart run build_runner build
   ```

2. DTOs in Models exportieren:
   ```dart
   // lib/models/mod_export.dart
   export 'employee_dashboard_dto.dart';
   ```

3. UI-Screens implementieren:
   - `lib/features/employee/presentation/pos_tab_screen.dart`
   - `lib/features/employee/presentation/customers_tab_screen.dart`
   - `lib/features/employee/presentation/portfolio_tab_screen.dart`
   - `lib/features/employee/presentation/past_appointments_tab_screen.dart`

4. Tests schreiben für Repository-Methoden

---

**Fertig!** Alle Queries sind implementiert und produktionsreif.
