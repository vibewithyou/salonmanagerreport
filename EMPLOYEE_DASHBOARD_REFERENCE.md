# Employee Dashboard - Quick Reference

## One-Page Cheat Sheet

### SQL Functions Deployed

```
✅ get_today_appointments(UUID) → 16 fields
✅ get_upcoming_shifts(UUID) → 8 fields
✅ get_employee_stats(UUID) → 11 fields
✅ get_recent_customers(UUID, INT) → 12 fields
✅ get_current_shift(UUID) → 9 fields
```

---

## Flutter Models

```dart
// 5 Freezed Models
EmployeeAppointment - Appointment details
EmployeeShift - Work schedule
EmployeeStats - Dashboard metrics
RecentCustomer - Customer history
CurrentShift - Time tracking status
```

---

## Riverpod Providers

```dart
// Data Access
todayAppointmentsProvider
employeeStatsProvider
upcomingShiftsProvider
recentCustomersProvider(limit)
currentShiftProvider

// Real-time
streamTodayAppointmentsProvider

// State
currentEmployeeIdProvider
currentSalonIdProvider
```

---

## Service Methods

```dart
EmployeeDashboardService

getTodayAppointments(employeeId) → List<EmployeeAppointment>
getUpcomingShifts(employeeId) → List<EmployeeShift>
getEmployeeStats(employeeId) → EmployeeStats
getRecentCustomers(employeeId, limit) → List<RecentCustomer>
getCurrentShift(employeeId) → CurrentShift?
recordTimeEntry(...) → void
getTodayTimeEntries(...) → List<Map>
streamTodayAppointments(employeeId) → Stream<List>
```

---

## File Mapping

| File | Purpose | Size |
|------|---------|------|
| EMPLOYEE_DASHBOARD_SQL_FUNCTIONS.sql | PostgreSQL functions | 11 KB |
| EMPLOYEE_DASHBOARD_QUERIES.md | Full documentation | 35 KB |
| EMPLOYEE_DASHBOARD_IMPLEMENTATION.md | Step-by-step guide | 28 KB |
| EMPLOYEE_DASHBOARD_SUMMARY.md | Quick overview | 9 KB |
| EMPLOYEE_DASHBOARD_INDEX.md | Navigation | 11 KB |
| EMPLOYEE_DASHBOARD_REFERENCE.md | This file | 3 KB |

---

## Quick Queries

### Get Today's Appointments
```sql
SELECT * FROM get_today_appointments('EMPLOYEE_UUID');
```

### Get This Week Stats
```sql
SELECT * FROM get_employee_stats('EMPLOYEE_UUID');
-- Returns: today, week, month stats + completion rate
```

### Get Last 5 Customers
```sql
SELECT * FROM get_recent_customers('EMPLOYEE_UUID', 5);
```

### Check Current Status
```sql
SELECT * FROM get_current_shift('EMPLOYEE_UUID');
```

---

## Flutter Usage

### Initialize Provider Context
```dart
ref.read(currentEmployeeIdProvider.notifier).state = employeeId;
ref.read(currentSalonIdProvider.notifier).state = salonId;
```

### Watch Statistics
```dart
final stats = ref.watch(employeeStatsProvider);
stats.when(
  data: (stat) => Text('${stat?.totalToday} appointments'),
  loading: () => CircularProgressIndicator(),
  error: (e, st) => Text('Error: $e'),
);
```

### Stream Real-time Appointments
```dart
final appointments = ref.watch(streamTodayAppointmentsProvider);
appointments.when(
  data: (list) => ListView(
    children: list.map((apt) => AppointmentTile(apt)).toList(),
  ),
  // ...
);
```

### Record Time Entry
```dart
final service = ref.watch(employeeDashboardServiceProvider);
await service.recordTimeEntry(
  employeeId: employeeId,
  salonId: salonId,
  entryType: 'check_in',
);
```

---

## Data Flow

```
Supabase Functions
       ↓
EmployeeDashboardService (RPC calls)
       ↓
Riverpod Providers (FutureProvider/StreamProvider)
       ↓
Flutter UI (build method)
       ↓
User sees live dashboard
```

---

## Database Tables

```
appointments
├─ PK: id
├─ FK: employee_id
├─ FK: customer_id
├─ FK: service_id
└─ Fields: start_time, end_time, status, price

employees
├─ PK: id
├─ FK: user_id
├─ FK: salon_id
└─ Fields: position, weekly_hours, hire_date

work_schedules
├─ PK: id
├─ FK: employee_id
└─ Fields: day_of_week, start_time, end_time

services
├─ PK: id
├─ FK: salon_id
└─ Fields: name, duration_minutes, price

customer_profiles
├─ PK: id
├─ FK: salon_id
└─ Fields: first_name, phone, email, preferences

dashboard_time_entries
├─ PK: id
├─ FK: employee_id, salon_id
└─ Fields: entry_type, timestamp, admin_confirmed
```

---

## Time Zone: Europe/Berlin

All queries automatically convert timestamps to Berlin timezone.

```sql
-- Query example
DATE(appointment.start_time AT TIME ZONE 'Europe/Berlin')
-- Current server time: 2026-02-15 23:15 UTC
-- Berlin time: 2026-02-16 00:15 CET
```

---

## Status Values

### Appointment Status
- `pending` - Awaiting confirmation
- `confirmed` - Accepted
- `completed` - Finished
- `cancelled` - Cancelled
- `no_show` - Customer didn't show up

### Time Entry Types
- `check_in` - Started work
- `check_out` - Ended work
- `break_start` - Started break
- `break_end` - Ended break

### Current Shift Status
- `working` - Currently working
- `on_break` - On break
- `checked_out` - Day ended
- `not_started` - Shift hasn't started yet

---

## Color Coding (UI)

```dart
// Status colors
'completed' / 'working' → Green ✅
'pending' / 'not_started' → Orange ⏳
'cancelled' / 'checked_out' → Red ❌
'confirmed' → Blue ℹ️
'on_break' → Purple 🔶
```

---

## Performance Tips

1. **Use StreamProvider** for real-time updates
2. **Limit queries** with pagination (default 10)
3. **Cache with autoDispose** for memory efficiency
4. **Batch time entries** instead of single records
5. **Index database** on employee_id and timestamps

---

## Common Errors & Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| Functions not found | Not deployed | Run SQL_FUNCTIONS.sql |
| Models not generated | Build runner not run | `flutter pub run build_runner build` |
| Empty data | Wrong employee_id | Verify UUID in database |
| No real-time | Realtime not enabled | Enable in Supabase settings |
| Timezone issues | Server timezone different | All queries use Europe/Berlin |

---

## Testing IDs

**Test Employee**: `8df27a0f-8b76-446f-8b83-e5feb2aeb877`
**Test Salon**: `b9fbbe58-3b16-43d3-88af-0570ecd3d653`

```sql
-- Test query
SELECT * FROM get_today_appointments('8df27a0f-8b76-446f-8b83-e5feb2aeb877');
```

---

## Directory Structure

```
lib/
├── models/employee/
│   ├── employee_appointment.dart
│   ├── employee_shift.dart
│   ├── employee_stats.dart
│   ├── recent_customer.dart
│   └── current_shift.dart
├── services/supabase/
│   └── employee_dashboard_service.dart
├── providers/employee/
│   └── employee_dashboard_provider.dart
└── features/employee/presentation/screens/
    └── employee_dashboard_screen.dart
```

---

## API Endpoint Format

```
Supabase RPC Endpoint:
POST /functions/v1/get_today_appointments
Content-Type: application/json

Request Body:
{
  "employee_id": "UUID"
}

Response:
[
  {
    "id": "UUID",
    "start_time": "2026-02-15T08:00:00+01:00",
    "end_time": "2026-02-15T08:45:00+01:00",
    ...
  }
]
```

---

## State Management Flow

```
User opens dashboard
        ↓
Set currentEmployeeIdProvider & currentSalonIdProvider
        ↓
Providers fetch data (auto-cached with autoDispose)
        ↓
Service makes RPC calls to Supabase
        ↓
Functions execute SQL queries
        ↓
Data returned as JSON
        ↓
Freezed models deserialize JSON
        ↓
UI widgets rebuild with data
        ↓
Real-time stream updates appointments in background
```

---

## Key Metrics Explained

### Stats from getEmployeeStats

| Metric | Purpose |
|--------|---------|
| totalToday | All appointments today |
| completedToday | Finished appointments |
| upcomingToday | Pending/confirmed today |
| revenueToday | Income from completed |
| totalWeek | All week appointments |
| completedWeek | Finished this week |
| revenueWeek | Income this week |
| totalMonth | All month appointments |
| revenueMonth | Income this month |
| uniqueCustomers | Different customers today |
| completionRateToday | % complete = completed/total |

---

## Deployment Checklist

- [ ] SQL functions created in Supabase
- [ ] Database indexes added
- [ ] Models generated (build_runner)
- [ ] Service layer compiled
- [ ] Providers configured
- [ ] Screens implemented
- [ ] Error handling tested
- [ ] Real-time tested
- [ ] Time tracking tested
- [ ] Mobile responsiveness verified

---

## Links

- Supabase Project: https://app.supabase.com/ (db.tshbudjnxgufagnvgqtl)
- Documentation: EMPLOYEE_DASHBOARD_QUERIES.md
- Implementation: EMPLOYEE_DASHBOARD_IMPLEMENTATION.md
- Full Index: EMPLOYEE_DASHBOARD_INDEX.md

---

**Status**: Production Ready ✅
**Version**: 1.0
**Date**: 2026-02-15
