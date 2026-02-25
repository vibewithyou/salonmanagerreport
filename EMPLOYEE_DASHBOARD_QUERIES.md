# Employee Dashboard - Supabase Queries
**Erstellt: 2026-02-15**

## Database Schema

### Relevant Tables

#### appointments
```sql
id UUID PRIMARY KEY
salon_id UUID (FK: salons)
customer_id UUID (FK: customer_profiles)
employee_id UUID (FK: employees)
service_id UUID (FK: services)
start_time TIMESTAMP WITH TIME ZONE
end_time TIMESTAMP WITH TIME ZONE
status ENUM ('pending', 'confirmed', 'completed', 'cancelled', 'no_show')
price NUMERIC
notes TEXT
created_at TIMESTAMP WITH TIME ZONE
updated_at TIMESTAMP WITH TIME ZONE
```

#### employees
```sql
id UUID PRIMARY KEY
user_id UUID (FK: auth.users)
salon_id UUID (FK: salons)
position TEXT
bio TEXT
skills ARRAY
weekly_hours INTEGER
hourly_rate NUMERIC
is_active BOOLEAN
hire_date DATE
display_name TEXT
created_at TIMESTAMP WITH TIME ZONE
updated_at TIMESTAMP WITH TIME ZONE
```

#### work_schedules
```sql
id UUID PRIMARY KEY
employee_id UUID (FK: employees)
day_of_week INTEGER (0-6, Monday=1, Sunday=0)
start_time TIME WITHOUT TIME ZONE
end_time TIME WITHOUT TIME ZONE
is_recurring BOOLEAN
specific_date DATE (for non-recurring schedules)
created_at TIMESTAMP WITH TIME ZONE
```

#### services
```sql
id UUID PRIMARY KEY
salon_id UUID (FK: salons)
name TEXT
description TEXT
duration_minutes INTEGER
price NUMERIC
category TEXT
is_active BOOLEAN
created_at TIMESTAMP WITH TIME ZONE
updated_at TIMESTAMP WITH TIME ZONE
```

#### customer_profiles
```sql
id UUID PRIMARY KEY
salon_id UUID (FK: salons)
user_id UUID (FK: auth.users)
first_name TEXT
last_name TEXT
phone TEXT
email TEXT
birthdate DATE
address TEXT
notes TEXT
image_urls ARRAY
preferences TEXT
allergies TEXT
tags ARRAY
created_at TIMESTAMP WITH TIME ZONE
updated_at TIMESTAMP WITH TIME ZONE
deleted_at TIMESTAMP WITH TIME ZONE
```

#### dashboard_time_entries
```sql
id UUID PRIMARY KEY
salon_id UUID (FK: salons)
employee_id UUID (FK: employees)
entry_type VARCHAR ('check_in', 'check_out', 'break_start', 'break_end')
timestamp TIMESTAMP WITH TIME ZONE
notes TEXT
admin_confirmed BOOLEAN
admin_id UUID (FK: employees)
confirmed_at TIMESTAMP WITH TIME ZONE
duration_minutes INTEGER
created_at TIMESTAMP WITH TIME ZONE
```

---

## SQL Queries

### 1. getTodayAppointments(employeeId)
Returns all appointments for an employee on today's date.

```sql
SELECT
  a.id,
  a.start_time,
  a.end_time,
  a.status,
  a.price,
  a.notes,
  s.name AS service_name,
  s.duration_minutes,
  COALESCE(c.first_name || ' ' || c.last_name, a.guest_name) AS customer_name,
  COALESCE(c.phone, a.guest_phone) AS customer_phone,
  COALESCE(c.email, a.guest_email) AS customer_email,
  c.id AS customer_id,
  c.image_urls AS customer_image,
  c.notes AS customer_notes,
  c.preferences AS customer_preferences,
  c.allergies AS customer_allergies
FROM
  appointments a
  LEFT JOIN services s ON a.service_id = s.id
  LEFT JOIN customer_profiles c ON a.customer_id = c.id
WHERE
  a.employee_id = $1
  AND DATE(a.start_time AT TIME ZONE 'Europe/Berlin') = CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
  AND a.deleted_at IS NULL
ORDER BY
  a.start_time ASC;
```

---

### 2. getUpcomingShifts(employeeId)
Returns work schedule for the next 7 days.

```sql
SELECT
  ws.id,
  ws.day_of_week,
  ws.start_time,
  ws.end_time,
  ws.specific_date,
  ws.is_recurring,
  CASE
    WHEN ws.is_recurring THEN CAST(ws.day_of_week AS TEXT)
    ELSE TO_CHAR(ws.specific_date, 'YYYY-MM-DD')
  END AS schedule_date,
  (EXTRACT(EPOCH FROM (ws.end_time - ws.start_time)) / 3600)::INTEGER AS duration_hours
FROM
  work_schedules ws
WHERE
  ws.employee_id = $1
  AND (
    -- Recurring schedules for next 7 days
    (ws.is_recurring = TRUE
     AND ws.day_of_week IN (
       SELECT EXTRACT(DOW FROM (CURRENT_DATE AT TIME ZONE 'Europe/Berlin')::DATE + INTERVAL '1 day' * i)
       FROM generate_series(0, 6) AS i
     ))
    -- Specific date schedules in next 7 days
    OR (ws.is_recurring = FALSE
        AND ws.specific_date >= CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
        AND ws.specific_date < (CURRENT_DATE AT TIME ZONE 'Europe/Berlin'::DATE + INTERVAL '7 days'))
  )
ORDER BY
  CASE WHEN ws.is_recurring THEN ws.day_of_week ELSE 7 END,
  ws.specific_date,
  ws.start_time;
```

---

### 3. getEmployeeStats(employeeId)
Comprehensive statistics dashboard.

```sql
WITH today_appointments AS (
  SELECT
    COUNT(*) AS total_today,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) AS completed_today,
    COUNT(CASE WHEN status = 'pending' OR status = 'confirmed' THEN 1 END) AS upcoming_today,
    COALESCE(SUM(CASE WHEN status = 'completed' THEN price END), 0) AS revenue_today
  FROM
    appointments
  WHERE
    employee_id = $1
    AND DATE(start_time AT TIME ZONE 'Europe/Berlin') = CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
    AND deleted_at IS NULL
),
this_week_appointments AS (
  SELECT
    COUNT(*) AS total_week,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) AS completed_week,
    COALESCE(SUM(CASE WHEN status = 'completed' THEN price END), 0) AS revenue_week
  FROM
    appointments
  WHERE
    employee_id = $1
    AND DATE(start_time AT TIME ZONE 'Europe/Berlin') >= DATE_TRUNC('week', CURRENT_DATE AT TIME ZONE 'Europe/Berlin')::DATE
    AND DATE(start_time AT TIME ZONE 'Europe/Berlin') <= CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
    AND deleted_at IS NULL
),
this_month_appointments AS (
  SELECT
    COUNT(*) AS total_month,
    COALESCE(SUM(CASE WHEN status = 'completed' THEN price END), 0) AS revenue_month
  FROM
    appointments
  WHERE
    employee_id = $1
    AND DATE_TRUNC('month', start_time AT TIME ZONE 'Europe/Berlin') = DATE_TRUNC('month', CURRENT_DATE AT TIME ZONE 'Europe/Berlin')
    AND deleted_at IS NULL
),
unique_customers_today AS (
  SELECT COUNT(DISTINCT customer_id) AS unique_customers
  FROM appointments
  WHERE
    employee_id = $1
    AND DATE(start_time AT TIME ZONE 'Europe/Berlin') = CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
    AND status = 'completed'
    AND deleted_at IS NULL
)
SELECT
  ta.total_today,
  ta.completed_today,
  ta.upcoming_today,
  ta.revenue_today,
  tw.total_week,
  tw.completed_week,
  tw.revenue_week,
  tm.total_month,
  tm.revenue_month,
  uc.unique_customers,
  ROUND((ta.completed_today::NUMERIC / NULLIF(ta.total_today, 0)) * 100, 1) AS completion_rate_today
FROM
  today_appointments ta,
  this_week_appointments tw,
  this_month_appointments tm,
  unique_customers_today uc;
```

---

### 4. getRecentCustomers(employeeId, limit)
Returns recently served customers with their appointment history.

```sql
SELECT DISTINCT ON (c.id)
  c.id,
  c.first_name,
  c.last_name,
  c.phone,
  c.email,
  c.image_urls,
  c.preferences,
  c.allergies,
  c.notes,
  MAX(a.start_time) AS last_appointment,
  COUNT(a.id) AS total_appointments,
  STRING_AGG(DISTINCT s.name, ', ' ORDER BY s.name) AS services_history
FROM
  customer_profiles c
  INNER JOIN appointments a ON c.id = a.customer_id
  LEFT JOIN services s ON a.service_id = s.id
WHERE
  a.employee_id = $1
  AND a.status = 'completed'
  AND a.deleted_at IS NULL
  AND c.deleted_at IS NULL
GROUP BY
  c.id,
  c.first_name,
  c.last_name,
  c.phone,
  c.email,
  c.image_urls,
  c.preferences,
  c.allergies,
  c.notes
ORDER BY
  c.id,
  MAX(a.start_time) DESC
LIMIT $2;
```

---

### 5. getCurrentShift(employeeId)
Returns employee's current shift for time tracking.

```sql
WITH today_schedule AS (
  SELECT
    ws.id,
    ws.start_time,
    ws.end_time,
    ws.day_of_week,
    CASE
      WHEN ws.is_recurring THEN 'recurring'
      ELSE 'specific'
    END AS schedule_type
  FROM
    work_schedules ws
  WHERE
    ws.employee_id = $1
    AND (
      (ws.is_recurring = TRUE AND ws.day_of_week = EXTRACT(DOW FROM CURRENT_DATE AT TIME ZONE 'Europe/Berlin')::INTEGER)
      OR (ws.is_recurring = FALSE AND ws.specific_date = CURRENT_DATE AT TIME ZONE 'Europe/Berlin')
    )
  LIMIT 1
),
latest_time_entry AS (
  SELECT
    id,
    entry_type,
    timestamp,
    ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY timestamp DESC) AS rn
  FROM
    dashboard_time_entries
  WHERE
    employee_id = $1
    AND DATE(timestamp AT TIME ZONE 'Europe/Berlin') = CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
)
SELECT
  ts.id AS schedule_id,
  ts.start_time,
  ts.end_time,
  ts.schedule_type,
  lte.entry_type AS last_entry_type,
  lte.timestamp AS last_entry_time,
  CASE
    WHEN lte.entry_type = 'check_in' THEN 'working'
    WHEN lte.entry_type = 'check_out' THEN 'checked_out'
    WHEN lte.entry_type = 'break_start' THEN 'on_break'
    WHEN lte.entry_type = 'break_end' THEN 'working'
    ELSE 'not_started'
  END AS current_status,
  EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP AT TIME ZONE 'Europe/Berlin' - lte.timestamp)) / 60 AS minutes_since_last_entry,
  CASE
    WHEN NOW() AT TIME ZONE 'Europe/Berlin'::TIME > ts.start_time
         AND NOW() AT TIME ZONE 'Europe/Berlin'::TIME < ts.end_time
    THEN TRUE
    ELSE FALSE
  END AS is_shift_active
FROM
  today_schedule ts
  LEFT JOIN latest_time_entry lte ON lte.rn = 1;
```

---

## Supabase Flutter Implementation

### 1. Models (Freezed)

```dart
// lib/models/employee/employee_appointment.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_appointment.freezed.dart';
part 'employee_appointment.g.dart';

@freezed
class EmployeeAppointment with _$EmployeeAppointment {
  const factory EmployeeAppointment({
    required String id,
    required DateTime startTime,
    required DateTime endTime,
    required String status,
    required num price,
    String? notes,
    required String serviceName,
    required int durationMinutes,
    required String customerName,
    String? customerPhone,
    String? customerEmail,
    String? customerId,
    List<String>? customerImage,
    String? customerNotes,
    String? customerPreferences,
    String? customerAllergies,
  }) = _EmployeeAppointment;

  factory EmployeeAppointment.fromJson(Map<String, dynamic> json) =>
      _$EmployeeAppointmentFromJson(json);
}
```

```dart
// lib/models/employee/employee_shift.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_shift.freezed.dart';
part 'employee_shift.g.dart';

@freezed
class EmployeeShift with _$EmployeeShift {
  const factory EmployeeShift({
    required String id,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required bool isRecurring,
    int? dayOfWeek,
    DateTime? specificDate,
    required int durationHours,
  }) = _EmployeeShift;

  factory EmployeeShift.fromJson(Map<String, dynamic> json) =>
      _$EmployeeShiftFromJson(json);
}
```

```dart
// lib/models/employee/employee_stats.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_stats.freezed.dart';
part 'employee_stats.g.dart';

@freezed
class EmployeeStats with _$EmployeeStats {
  const factory EmployeeStats({
    // Today
    required int totalToday,
    required int completedToday,
    required int upcomingToday,
    required num revenueToday,

    // This Week
    required int totalWeek,
    required int completedWeek,
    required num revenueWeek,

    // This Month
    required int totalMonth,
    required num revenueMonth,

    // Customers
    required int uniqueCustomers,
    required double completionRateToday,
  }) = _EmployeeStats;

  factory EmployeeStats.fromJson(Map<String, dynamic> json) =>
      _$EmployeeStatsFromJson(json);
}
```

```dart
// lib/models/employee/recent_customer.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_customer.freezed.dart';
part 'recent_customer.g.dart';

@freezed
class RecentCustomer with _$RecentCustomer {
  const factory RecentCustomer({
    required String id,
    required String firstName,
    required String lastName,
    String? phone,
    String? email,
    List<String>? imageUrls,
    String? preferences,
    String? allergies,
    String? notes,
    DateTime? lastAppointment,
    required int totalAppointments,
    String? servicesHistory,
  }) = _RecentCustomer;

  factory RecentCustomer.fromJson(Map<String, dynamic> json) =>
      _$RecentCustomerFromJson(json);
}
```

```dart
// lib/models/employee/current_shift.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_shift.freezed.dart';
part 'current_shift.g.dart';

@freezed
class CurrentShift with _$CurrentShift {
  const factory CurrentShift({
    String? scheduleId,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String scheduleType,
    String? lastEntryType,
    DateTime? lastEntryTime,
    required String currentStatus,
    double? minutesSinceLastEntry,
    required bool isShiftActive,
  }) = _CurrentShift;

  factory CurrentShift.fromJson(Map<String, dynamic> json) =>
      _$CurrentShiftFromJson(json);
}
```

### 2. Service Layer

```dart
// lib/services/supabase/employee_dashboard_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:salonmanager/models/employee/employee_appointment.dart';
import 'package:salonmanager/models/employee/employee_shift.dart';
import 'package:salonmanager/models/employee/employee_stats.dart';
import 'package:salonmanager/models/employee/recent_customer.dart';
import 'package:salonmanager/models/employee/current_shift.dart';

class EmployeeDashboardService {
  final SupabaseClient _supabase;

  EmployeeDashboardService(this._supabase);

  /// Get today's appointments for an employee
  Future<List<EmployeeAppointment>> getTodayAppointments(String employeeId) async {
    try {
      final response = await _supabase.rpc(
        'get_today_appointments',
        params: {'employee_id': employeeId},
      ) as List;

      return response
          .map((json) => EmployeeAppointment.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching today appointments: $e');
      rethrow;
    }
  }

  /// Get upcoming shifts (next 7 days)
  Future<List<EmployeeShift>> getUpcomingShifts(String employeeId) async {
    try {
      final response = await _supabase.rpc(
        'get_upcoming_shifts',
        params: {'employee_id': employeeId},
      ) as List;

      return response
          .map((json) => EmployeeShift.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching upcoming shifts: $e');
      rethrow;
    }
  }

  /// Get employee statistics
  Future<EmployeeStats> getEmployeeStats(String employeeId) async {
    try {
      final response = await _supabase.rpc(
        'get_employee_stats',
        params: {'employee_id': employeeId},
      );

      return EmployeeStats.fromJson(response);
    } catch (e) {
      print('Error fetching employee stats: $e');
      rethrow;
    }
  }

  /// Get recent customers
  Future<List<RecentCustomer>> getRecentCustomers(
    String employeeId, {
    int limit = 10,
  }) async {
    try {
      final response = await _supabase.rpc(
        'get_recent_customers',
        params: {
          'employee_id': employeeId,
          'limit': limit,
        },
      ) as List;

      return response
          .map((json) => RecentCustomer.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching recent customers: $e');
      rethrow;
    }
  }

  /// Get current shift status for time tracking
  Future<CurrentShift?> getCurrentShift(String employeeId) async {
    try {
      final response = await _supabase.rpc(
        'get_current_shift',
        params: {'employee_id': employeeId},
      );

      if (response == null) return null;
      return CurrentShift.fromJson(response);
    } catch (e) {
      print('Error fetching current shift: $e');
      rethrow;
    }
  }

  /// Record time entry (check in/out, breaks)
  Future<void> recordTimeEntry({
    required String employeeId,
    required String salonId,
    required String entryType, // 'check_in', 'check_out', 'break_start', 'break_end'
    String? notes,
  }) async {
    try {
      await _supabase.from('dashboard_time_entries').insert({
        'salon_id': salonId,
        'employee_id': employeeId,
        'entry_type': entryType,
        'notes': notes,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error recording time entry: $e');
      rethrow;
    }
  }

  /// Get today's time entries for dashboard
  Future<List<Map<String, dynamic>>> getTodayTimeEntries(
    String employeeId,
    String salonId,
  ) async {
    try {
      final response = await _supabase
          .from('dashboard_time_entries')
          .select()
          .eq('employee_id', employeeId)
          .eq('salon_id', salonId)
          .gte('timestamp', DateTime.now().subtract(Duration(days: 1)).toIso8601String())
          .order('timestamp', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching today time entries: $e');
      rethrow;
    }
  }

  /// Stream real-time appointments for today
  Stream<List<EmployeeAppointment>> streamTodayAppointments(String employeeId) {
    return _supabase
        .from('appointments')
        .stream(primaryKey: ['id'])
        .eq('employee_id', employeeId)
        .map((appointments) {
          return appointments
              .where((a) {
                final date = DateTime.parse(a['start_time'] as String);
                return date.year == DateTime.now().year &&
                    date.month == DateTime.now().month &&
                    date.day == DateTime.now().day;
              })
              .map((json) => EmployeeAppointment.fromJson(json))
              .toList();
        });
  }
}
```

### 3. Riverpod Providers

```dart
// lib/providers/employee/employee_dashboard_provider.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salonmanager/services/supabase/employee_dashboard_service.dart';
import 'package:salonmanager/models/employee/employee_appointment.dart';
import 'package:salonmanager/models/employee/employee_shift.dart';
import 'package:salonmanager/models/employee/employee_stats.dart';
import 'package:salonmanager/models/employee/recent_customer.dart';
import 'package:salonmanager/models/employee/current_shift.dart';

final employeeDashboardServiceProvider = Provider((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return EmployeeDashboardService(supabase);
});

final currentEmployeeIdProvider = StateProvider<String?>((ref) => null);
final currentSalonIdProvider = StateProvider<String?>((ref) => null);

// Today's Appointments
final todayAppointmentsProvider = FutureProvider.autoDispose<List<EmployeeAppointment>?>((ref) async {
  final employeeId = ref.watch(currentEmployeeIdProvider);
  if (employeeId == null) return null;

  final service = ref.watch(employeeDashboardServiceProvider);
  return service.getTodayAppointments(employeeId);
});

final streamTodayAppointmentsProvider =
    StreamProvider.autoDispose<List<EmployeeAppointment>>((ref) async* {
  final employeeId = ref.watch(currentEmployeeIdProvider);
  if (employeeId == null) {
    yield [];
    return;
  }

  final service = ref.watch(employeeDashboardServiceProvider);
  yield* service.streamTodayAppointments(employeeId);
});

// Upcoming Shifts
final upcomingShiftsProvider = FutureProvider.autoDispose<List<EmployeeShift>?>((ref) async {
  final employeeId = ref.watch(currentEmployeeIdProvider);
  if (employeeId == null) return null;

  final service = ref.watch(employeeDashboardServiceProvider);
  return service.getUpcomingShifts(employeeId);
});

// Employee Statistics
final employeeStatsProvider = FutureProvider.autoDispose<EmployeeStats?>((ref) async {
  final employeeId = ref.watch(currentEmployeeIdProvider);
  if (employeeId == null) return null;

  final service = ref.watch(employeeDashboardServiceProvider);
  return service.getEmployeeStats(employeeId);
});

// Recent Customers
final recentCustomersProvider =
    FutureProvider.autoDispose.family<List<RecentCustomer>?, int>((ref, limit) async {
  final employeeId = ref.watch(currentEmployeeIdProvider);
  if (employeeId == null) return null;

  final service = ref.watch(employeeDashboardServiceProvider);
  return service.getRecentCustomers(employeeId, limit: limit);
});

// Current Shift
final currentShiftProvider = FutureProvider.autoDispose<CurrentShift?>((ref) async {
  final employeeId = ref.watch(currentEmployeeIdProvider);
  if (employeeId == null) return null;

  final service = ref.watch(employeeDashboardServiceProvider);
  return service.getCurrentShift(employeeId);
});

// Today's Time Entries
final todayTimeEntriesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>?>((ref) async {
  final employeeId = ref.watch(currentEmployeeIdProvider);
  final salonId = ref.watch(currentSalonIdProvider);
  if (employeeId == null || salonId == null) return null;

  final service = ref.watch(employeeDashboardServiceProvider);
  return service.getTodayTimeEntries(employeeId, salonId);
});
```

### 4. Usage Example in Widget

```dart
// lib/features/employee/presentation/screens/employee_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salonmanager/providers/employee/employee_dashboard_provider.dart';

class EmployeeDashboardScreen extends HookConsumerWidget {
  final String employeeId;
  final String salonId;

  const EmployeeDashboardScreen({
    required this.employeeId,
    required this.salonId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize current employee context
    ref.read(currentEmployeeIdProvider.notifier).state = employeeId;
    ref.read(currentSalonIdProvider.notifier).state = salonId;

    final todayAppointments = ref.watch(streamTodayAppointmentsProvider);
    final stats = ref.watch(employeeStatsProvider);
    final currentShift = ref.watch(currentShiftProvider);
    final recentCustomers = ref.watch(recentCustomersProvider(10));

    return Scaffold(
      appBar: AppBar(title: const Text('Employee Dashboard')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(todayAppointmentsProvider);
          ref.refresh(employeeStatsProvider);
          ref.refresh(currentShiftProvider);
          ref.refresh(recentCustomersProvider(10));
        },
        child: ListView(
          children: [
            // Statistics Section
            stats.when(
              data: (stat) => stat != null
                  ? _buildStatisticsCard(context, stat)
                  : const SizedBox(),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(child: Text('Error: $err')),
            ),

            const SizedBox(height: 16),

            // Current Shift Status
            currentShift.when(
              data: (shift) => shift != null
                  ? _buildCurrentShiftCard(context, shift)
                  : const SizedBox(),
              loading: () => const SizedBox(),
              error: (err, st) => const SizedBox(),
            ),

            const SizedBox(height: 16),

            // Today's Appointments
            todayAppointments.when(
              data: (appointments) =>
                  _buildAppointmentsSection(context, appointments),
              loading: () => const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
              error: (err, st) => Center(child: Text('Error: $err')),
            ),

            const SizedBox(height: 16),

            // Recent Customers
            recentCustomers.when(
              data: (customers) => customers != null
                  ? _buildRecentCustomersSection(context, customers)
                  : const SizedBox(),
              loading: () => const SizedBox(),
              error: (err, st) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context, stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Today\'s Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Appointments', stats.totalToday.toString()),
                _buildStatItem('Completed', stats.completedToday.toString()),
                _buildStatItem('Revenue', '€${stats.revenueToday}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentShiftCard(BuildContext context, shift) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Current Status: ${shift.currentStatus}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Shift: ${shift.startTime} - ${shift.endTime}'),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsSection(BuildContext context, appointments) {
    return Column(
      children: appointments
          .map((apt) => ListTile(
                title: Text(apt.customerName),
                subtitle: Text(apt.serviceName),
                trailing: Text(apt.startTime.toString()),
              ))
          .toList(),
    );
  }

  Widget _buildRecentCustomersSection(BuildContext context, customers) {
    return Column(
      children: customers
          .map((customer) => ListTile(
                title: Text('${customer.firstName} ${customer.lastName}'),
                subtitle: Text('${customer.totalAppointments} appointments'),
              ))
          .toList(),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
```

---

## SQL Functions für Supabase

Füge diese Funktionen in Supabase SQL Editor ein:

```sql
-- Create functions for employee dashboard

CREATE OR REPLACE FUNCTION get_today_appointments(employee_id UUID)
RETURNS TABLE (
  id UUID,
  start_time TIMESTAMP WITH TIME ZONE,
  end_time TIMESTAMP WITH TIME ZONE,
  status TEXT,
  price NUMERIC,
  notes TEXT,
  service_name TEXT,
  duration_minutes INTEGER,
  customer_name TEXT,
  customer_phone TEXT,
  customer_email TEXT,
  customer_id UUID,
  customer_image TEXT[],
  customer_notes TEXT,
  customer_preferences TEXT,
  customer_allergies TEXT
) AS $$
SELECT
  a.id,
  a.start_time,
  a.end_time,
  a.status::TEXT,
  a.price,
  a.notes,
  s.name,
  s.duration_minutes,
  COALESCE(c.first_name || ' ' || c.last_name, a.guest_name),
  COALESCE(c.phone, a.guest_phone),
  COALESCE(c.email, a.guest_email),
  c.id,
  c.image_urls,
  c.notes,
  c.preferences,
  c.allergies
FROM
  appointments a
  LEFT JOIN services s ON a.service_id = s.id
  LEFT JOIN customer_profiles c ON a.customer_id = c.id
WHERE
  a.employee_id = $1
  AND DATE(a.start_time AT TIME ZONE 'Europe/Berlin') = CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
  AND a.deleted_at IS NULL
ORDER BY
  a.start_time ASC;
$$ LANGUAGE SQL STABLE;

CREATE OR REPLACE FUNCTION get_upcoming_shifts(employee_id UUID)
RETURNS TABLE (
  id UUID,
  day_of_week INTEGER,
  start_time TIME WITHOUT TIME ZONE,
  end_time TIME WITHOUT TIME ZONE,
  specific_date DATE,
  is_recurring BOOLEAN,
  schedule_date TEXT,
  duration_hours INTEGER
) AS $$
SELECT
  ws.id,
  ws.day_of_week,
  ws.start_time,
  ws.end_time,
  ws.specific_date,
  ws.is_recurring,
  CASE
    WHEN ws.is_recurring THEN CAST(ws.day_of_week AS TEXT)
    ELSE TO_CHAR(ws.specific_date, 'YYYY-MM-DD')
  END,
  (EXTRACT(EPOCH FROM (ws.end_time - ws.start_time)) / 3600)::INTEGER
FROM
  work_schedules ws
WHERE
  ws.employee_id = $1
  AND (
    (ws.is_recurring = TRUE
     AND ws.day_of_week IN (
       SELECT EXTRACT(DOW FROM (CURRENT_DATE AT TIME ZONE 'Europe/Berlin')::DATE + INTERVAL '1 day' * i)::INTEGER
       FROM generate_series(0, 6) AS i
     ))
    OR (ws.is_recurring = FALSE
        AND ws.specific_date >= CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
        AND ws.specific_date < (CURRENT_DATE AT TIME ZONE 'Europe/Berlin'::DATE + INTERVAL '7 days'))
  )
ORDER BY
  CASE WHEN ws.is_recurring THEN ws.day_of_week ELSE 7 END,
  ws.specific_date,
  ws.start_time;
$$ LANGUAGE SQL STABLE;

CREATE OR REPLACE FUNCTION get_employee_stats(employee_id UUID)
RETURNS TABLE (
  total_today INTEGER,
  completed_today INTEGER,
  upcoming_today INTEGER,
  revenue_today NUMERIC,
  total_week INTEGER,
  completed_week INTEGER,
  revenue_week NUMERIC,
  total_month INTEGER,
  revenue_month NUMERIC,
  unique_customers INTEGER,
  completion_rate_today NUMERIC
) AS $$
WITH today_appointments AS (
  SELECT
    COUNT(*)::INTEGER AS total_today,
    COUNT(CASE WHEN status = 'completed' THEN 1 END)::INTEGER AS completed_today,
    COUNT(CASE WHEN status = 'pending' OR status = 'confirmed' THEN 1 END)::INTEGER AS upcoming_today,
    COALESCE(SUM(CASE WHEN status = 'completed' THEN price END), 0) AS revenue_today
  FROM
    appointments
  WHERE
    employee_id = $1
    AND DATE(start_time AT TIME ZONE 'Europe/Berlin') = CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
    AND deleted_at IS NULL
),
this_week_appointments AS (
  SELECT
    COUNT(*)::INTEGER AS total_week,
    COUNT(CASE WHEN status = 'completed' THEN 1 END)::INTEGER AS completed_week,
    COALESCE(SUM(CASE WHEN status = 'completed' THEN price END), 0) AS revenue_week
  FROM
    appointments
  WHERE
    employee_id = $1
    AND DATE(start_time AT TIME ZONE 'Europe/Berlin') >= DATE_TRUNC('week', CURRENT_DATE AT TIME ZONE 'Europe/Berlin')::DATE
    AND DATE(start_time AT TIME ZONE 'Europe/Berlin') <= CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
    AND deleted_at IS NULL
),
this_month_appointments AS (
  SELECT
    COUNT(*)::INTEGER AS total_month,
    COALESCE(SUM(CASE WHEN status = 'completed' THEN price END), 0) AS revenue_month
  FROM
    appointments
  WHERE
    employee_id = $1
    AND DATE_TRUNC('month', start_time AT TIME ZONE 'Europe/Berlin') = DATE_TRUNC('month', CURRENT_DATE AT TIME ZONE 'Europe/Berlin')
    AND deleted_at IS NULL
),
unique_customers_today AS (
  SELECT COUNT(DISTINCT customer_id)::INTEGER AS unique_customers
  FROM appointments
  WHERE
    employee_id = $1
    AND DATE(start_time AT TIME ZONE 'Europe/Berlin') = CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
    AND status = 'completed'
    AND deleted_at IS NULL
)
SELECT
  ta.total_today,
  ta.completed_today,
  ta.upcoming_today,
  ta.revenue_today,
  tw.total_week,
  tw.completed_week,
  tw.revenue_week,
  tm.total_month,
  tm.revenue_month,
  uc.unique_customers,
  ROUND((ta.completed_today::NUMERIC / NULLIF(ta.total_today, 0)) * 100, 1)
FROM
  today_appointments ta,
  this_week_appointments tw,
  this_month_appointments tm,
  unique_customers_today uc;
$$ LANGUAGE SQL STABLE;

CREATE OR REPLACE FUNCTION get_recent_customers(employee_id UUID, limit_count INTEGER DEFAULT 10)
RETURNS TABLE (
  id UUID,
  first_name TEXT,
  last_name TEXT,
  phone TEXT,
  email TEXT,
  image_urls TEXT[],
  preferences TEXT,
  allergies TEXT,
  notes TEXT,
  last_appointment TIMESTAMP WITH TIME ZONE,
  total_appointments INTEGER,
  services_history TEXT
) AS $$
SELECT DISTINCT ON (c.id)
  c.id,
  c.first_name,
  c.last_name,
  c.phone,
  c.email,
  c.image_urls,
  c.preferences,
  c.allergies,
  c.notes,
  MAX(a.start_time),
  COUNT(a.id)::INTEGER,
  STRING_AGG(DISTINCT s.name, ', ' ORDER BY s.name)
FROM
  customer_profiles c
  INNER JOIN appointments a ON c.id = a.customer_id
  LEFT JOIN services s ON a.service_id = s.id
WHERE
  a.employee_id = $1
  AND a.status = 'completed'
  AND a.deleted_at IS NULL
  AND c.deleted_at IS NULL
GROUP BY
  c.id,
  c.first_name,
  c.last_name,
  c.phone,
  c.email,
  c.image_urls,
  c.preferences,
  c.allergies,
  c.notes
ORDER BY
  c.id,
  MAX(a.start_time) DESC
LIMIT limit_count;
$$ LANGUAGE SQL STABLE;

CREATE OR REPLACE FUNCTION get_current_shift(employee_id UUID)
RETURNS TABLE (
  schedule_id UUID,
  start_time TIME WITHOUT TIME ZONE,
  end_time TIME WITHOUT TIME ZONE,
  schedule_type TEXT,
  last_entry_type TEXT,
  last_entry_time TIMESTAMP WITH TIME ZONE,
  current_status TEXT,
  minutes_since_last_entry NUMERIC,
  is_shift_active BOOLEAN
) AS $$
WITH today_schedule AS (
  SELECT
    ws.id,
    ws.start_time,
    ws.end_time,
    ws.day_of_week,
    CASE
      WHEN ws.is_recurring THEN 'recurring'
      ELSE 'specific'
    END AS schedule_type
  FROM
    work_schedules ws
  WHERE
    ws.employee_id = $1
    AND (
      (ws.is_recurring = TRUE AND ws.day_of_week = EXTRACT(DOW FROM CURRENT_DATE AT TIME ZONE 'Europe/Berlin')::INTEGER)
      OR (ws.is_recurring = FALSE AND ws.specific_date = CURRENT_DATE AT TIME ZONE 'Europe/Berlin')
    )
  LIMIT 1
),
latest_time_entry AS (
  SELECT
    id,
    entry_type,
    timestamp,
    ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY timestamp DESC) AS rn
  FROM
    dashboard_time_entries
  WHERE
    employee_id = $1
    AND DATE(timestamp AT TIME ZONE 'Europe/Berlin') = CURRENT_DATE AT TIME ZONE 'Europe/Berlin'
)
SELECT
  ts.id,
  ts.start_time,
  ts.end_time,
  ts.schedule_type,
  lte.entry_type,
  lte.timestamp,
  CASE
    WHEN lte.entry_type = 'check_in' THEN 'working'
    WHEN lte.entry_type = 'check_out' THEN 'checked_out'
    WHEN lte.entry_type = 'break_start' THEN 'on_break'
    WHEN lte.entry_type = 'break_end' THEN 'working'
    ELSE 'not_started'
  END,
  EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP AT TIME ZONE 'Europe/Berlin' - lte.timestamp)) / 60,
  CASE
    WHEN (CURRENT_TIME AT TIME ZONE 'Europe/Berlin')::TIME > ts.start_time
         AND (CURRENT_TIME AT TIME ZONE 'Europe/Berlin')::TIME < ts.end_time
    THEN TRUE
    ELSE FALSE
  END
FROM
  today_schedule ts
  LEFT JOIN latest_time_entry lte ON lte.rn = 1;
$$ LANGUAGE SQL STABLE;
```

---

## Integration Checklist

- [ ] SQL functions deployed to Supabase
- [ ] Freezed models generated (`flutter pub run build_runner build`)
- [ ] Service layer implemented
- [ ] Riverpod providers created
- [ ] Screens/widgets implemented
- [ ] Error handling tested
- [ ] Real-time streaming tested
- [ ] Time zone handling verified (using 'Europe/Berlin')
- [ ] RLS policies configured for employee data access
- [ ] Performance tested with large datasets

---

## Best Practices

1. **Time Zone Handling**: All queries use 'Europe/Berlin' timezone for consistency
2. **Real-time Updates**: Use StreamProvider for appointments to update in real-time
3. **Error Handling**: All service methods handle and log errors
4. **Caching**: Use FutureProvider.autoDispose for automatic cache invalidation
5. **Pagination**: Recent customers supports limit parameter for performance
6. **Data Privacy**: Ensure RLS policies restrict employees to their own data
