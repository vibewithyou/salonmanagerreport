# Employee Dashboard - Implementation Guide

## Quick Start

### 1. Deploy SQL Functions
1. Go to Supabase Dashboard: https://app.supabase.com/
2. Select project: db.tshbudjnxgufagnvgqtl.supabase.co
3. Navigate to: SQL Editor
4. Create new query
5. Copy content from `EMPLOYEE_DASHBOARD_SQL_FUNCTIONS.sql`
6. Click "Run"

### 2. Verify Functions
Run verification queries at bottom of SQL file to confirm all functions are created.

### 3. Generate Freezed Models
```bash
cd C:\Users\Tobi\Documents\GitHub\salonmanager
flutter pub run build_runner build
```

### 4. Implement in Flutter

#### Step 1: Create Models Directory
```bash
mkdir -p lib/models/employee
```

#### Step 2: Create Freezed Models

**File: `lib/models/employee/employee_appointment.dart`**
```dart
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
    @JsonKey(name: 'customer_image') List<String>? customerImage,
    @JsonKey(name: 'customer_notes') String? customerNotes,
    @JsonKey(name: 'customer_preferences') String? customerPreferences,
    @JsonKey(name: 'customer_allergies') String? customerAllergies,
  }) = _EmployeeAppointment;

  factory EmployeeAppointment.fromJson(Map<String, dynamic> json) =>
      _$EmployeeAppointmentFromJson(json);
}
```

**File: `lib/models/employee/employee_shift.dart`**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'employee_shift.freezed.dart';
part 'employee_shift.g.dart';

@freezed
class EmployeeShift with _$EmployeeShift {
  const factory EmployeeShift({
    required String id,
    @JsonKey(name: 'start_time') required String startTimeStr,
    @JsonKey(name: 'end_time') required String endTimeStr,
    @JsonKey(name: 'is_recurring') required bool isRecurring,
    @JsonKey(name: 'day_of_week') int? dayOfWeek,
    @JsonKey(name: 'specific_date') DateTime? specificDate,
    @JsonKey(name: 'duration_hours') required int durationHours,
  }) = _EmployeeShift;

  factory EmployeeShift.fromJson(Map<String, dynamic> json) =>
      _$EmployeeShiftFromJson(json);

  const EmployeeShift._();

  TimeOfDay get startTime {
    final parts = startTimeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  TimeOfDay get endTime {
    final parts = endTimeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
```

**File: `lib/models/employee/employee_stats.dart`**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_stats.freezed.dart';
part 'employee_stats.g.dart';

@freezed
class EmployeeStats with _$EmployeeStats {
  const factory EmployeeStats({
    @JsonKey(name: 'total_today') required int totalToday,
    @JsonKey(name: 'completed_today') required int completedToday,
    @JsonKey(name: 'upcoming_today') required int upcomingToday,
    @JsonKey(name: 'revenue_today') required num revenueToday,
    @JsonKey(name: 'total_week') required int totalWeek,
    @JsonKey(name: 'completed_week') required int completedWeek,
    @JsonKey(name: 'revenue_week') required num revenueWeek,
    @JsonKey(name: 'total_month') required int totalMonth,
    @JsonKey(name: 'revenue_month') required num revenueMonth,
    @JsonKey(name: 'unique_customers') required int uniqueCustomers,
    @JsonKey(name: 'completion_rate_today') required double completionRateToday,
  }) = _EmployeeStats;

  factory EmployeeStats.fromJson(Map<String, dynamic> json) =>
      _$EmployeeStatsFromJson(json);
}
```

#### Step 3: Create Service Layer

**File: `lib/services/supabase/employee_dashboard_service.dart`**
```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:salonmanager/models/employee/employee_appointment.dart';
import 'package:salonmanager/models/employee/employee_shift.dart';
import 'package:salonmanager/models/employee/employee_stats.dart';
import 'package:salonmanager/models/employee/recent_customer.dart';
import 'package:salonmanager/models/employee/current_shift.dart';

class EmployeeDashboardService {
  final SupabaseClient _supabase;

  EmployeeDashboardService(this._supabase);

  Future<List<EmployeeAppointment>> getTodayAppointments(String employeeId) async {
    try {
      final response = await _supabase.rpc(
        'get_today_appointments',
        params: {'employee_id': employeeId},
      );

      if (response == null) return [];

      final list = response is List ? response : [response];
      return list
          .map((json) => EmployeeAppointment.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching today appointments: $e');
      rethrow;
    }
  }

  Future<List<EmployeeShift>> getUpcomingShifts(String employeeId) async {
    try {
      final response = await _supabase.rpc(
        'get_upcoming_shifts',
        params: {'employee_id': employeeId},
      );

      if (response == null) return [];

      final list = response is List ? response : [response];
      return list
          .map((json) => EmployeeShift.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching upcoming shifts: $e');
      rethrow;
    }
  }

  Future<EmployeeStats?> getEmployeeStats(String employeeId) async {
    try {
      final response = await _supabase.rpc(
        'get_employee_stats',
        params: {'employee_id': employeeId},
      );

      if (response == null) return null;
      return EmployeeStats.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching employee stats: $e');
      rethrow;
    }
  }

  Future<List<RecentCustomer>> getRecentCustomers(
    String employeeId, {
    int limit = 10,
  }) async {
    try {
      final response = await _supabase.rpc(
        'get_recent_customers',
        params: {
          'employee_id': employeeId,
          'limit_count': limit,
        },
      );

      if (response == null) return [];

      final list = response is List ? response : [response];
      return list
          .map((json) => RecentCustomer.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching recent customers: $e');
      rethrow;
    }
  }

  Future<CurrentShift?> getCurrentShift(String employeeId) async {
    try {
      final response = await _supabase.rpc(
        'get_current_shift',
        params: {'employee_id': employeeId},
      );

      if (response == null) return null;
      return CurrentShift.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching current shift: $e');
      rethrow;
    }
  }

  Future<void> recordTimeEntry({
    required String employeeId,
    required String salonId,
    required String entryType,
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

  Future<List<Map<String, dynamic>>> getTodayTimeEntries(
    String employeeId,
    String salonId,
  ) async {
    try {
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      final response = await _supabase
          .from('dashboard_time_entries')
          .select()
          .eq('employee_id', employeeId)
          .eq('salon_id', salonId)
          .gte('timestamp', yesterday.toIso8601String())
          .order('timestamp', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching today time entries: $e');
      rethrow;
    }
  }

  Stream<List<EmployeeAppointment>> streamTodayAppointments(String employeeId) {
    return _supabase
        .from('appointments')
        .stream(primaryKey: ['id'])
        .eq('employee_id', employeeId)
        .map((appointments) {
          final now = DateTime.now();
          return appointments
              .where((a) {
                final date = DateTime.parse(a['start_time'] as String);
                return date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day;
              })
              .map((json) => EmployeeAppointment.fromJson(json as Map<String, dynamic>))
              .toList();
        });
  }
}
```

#### Step 4: Create Riverpod Providers

**File: `lib/providers/employee/employee_dashboard_provider.dart`**
```dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:salonmanager/services/supabase/employee_dashboard_service.dart';
import 'package:salonmanager/models/employee/employee_appointment.dart';
import 'package:salonmanager/models/employee/employee_shift.dart';
import 'package:salonmanager/models/employee/employee_stats.dart';
import 'package:salonmanager/models/employee/recent_customer.dart';
import 'package:salonmanager/models/employee/current_shift.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

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

#### Step 5: Create Dashboard Screen

**File: `lib/features/employee/presentation/screens/employee_dashboard_screen.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salonmanager/providers/employee/employee_dashboard_provider.dart';
import 'package:intl/intl.dart';

class EmployeeDashboardScreen extends HookConsumerWidget {
  final String employeeId;
  final String salonId;

  const EmployeeDashboardScreen({
    required this.employeeId,
    required this.salonId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(currentEmployeeIdProvider.notifier).state = employeeId;
    ref.read(currentSalonIdProvider.notifier).state = salonId;

    final todayAppointments = ref.watch(streamTodayAppointmentsProvider);
    final stats = ref.watch(employeeStatsProvider);
    final currentShift = ref.watch(currentShiftProvider);
    final recentCustomers = ref.watch(recentCustomersProvider(10));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(todayAppointmentsProvider);
          ref.refresh(employeeStatsProvider);
          ref.refresh(currentShiftProvider);
          ref.refresh(recentCustomersProvider(10));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistics Card
                stats.when(
                  data: (stat) => stat != null
                      ? _buildStatisticsCard(context, stat)
                      : const SizedBox(),
                  loading: () => const _SkeletonCard(height: 120),
                  error: (err, st) => _buildErrorCard('Statistics Error'),
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
                const Text(
                  'Today\'s Appointments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                todayAppointments.when(
                  data: (appointments) => appointments.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: Text('No appointments today')),
                        )
                      : Column(
                          children: appointments
                              .map((apt) => _buildAppointmentCard(context, apt))
                              .toList(),
                        ),
                  loading: () => const _SkeletonCard(height: 80),
                  error: (err, st) => _buildErrorCard('Appointments Error'),
                ),
                const SizedBox(height: 16),

                // Recent Customers
                const Text(
                  'Recent Customers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                recentCustomers.when(
                  data: (customers) => customers == null || customers.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: Text('No recent customers')),
                        )
                      : Column(
                          children: customers
                              .map((customer) => _buildCustomerCard(context, customer))
                              .toList(),
                        ),
                  loading: () => const _SkeletonCard(height: 80),
                  error: (err, st) => _buildErrorCard('Customers Error'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context, stats) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Today\'s Overview',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatItem('Total', stats.totalToday.toString(), Colors.blue),
                _buildStatItem('Completed', stats.completedToday.toString(), Colors.green),
                _buildStatItem(
                  'Revenue',
                  '€${stats.revenueToday.toStringAsFixed(2)}',
                  Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: stats.totalToday > 0
                  ? stats.completedToday / stats.totalToday
                  : 0,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Text(
              'Completion Rate: ${stats.completionRateToday.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentShiftCard(BuildContext context, shift) {
    final statusColor = _getStatusColor(shift.currentStatus);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Current Shift',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    shift.currentStatus.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Shift: ${shift.startTime.format(context)} - ${shift.endTime.format(context)}',
              style: const TextStyle(fontSize: 14),
            ),
            if (shift.lastEntryTime != null) ...[
              const SizedBox(height: 8),
              Text(
                'Last Entry: ${DateFormat('HH:mm:ss').format(shift.lastEntryTime!)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, appointment) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.customerName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        appointment.serviceName,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(appointment.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    appointment.status,
                    style: TextStyle(
                      fontSize: 11,
                      color: _getStatusColor(appointment.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('HH:mm').format(appointment.startTime),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  '€${appointment.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(BuildContext context, customer) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${customer.firstName} ${customer.lastName}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${customer.totalAppointments} appointments',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Error: $message',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'working':
        return Colors.green;
      case 'pending':
      case 'not_started':
        return Colors.orange;
      case 'cancelled':
      case 'checked_out':
        return Colors.red;
      case 'confirmed':
        return Colors.blue;
      case 'on_break':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class _SkeletonCard extends StatelessWidget {
  final double height;

  const _SkeletonCard({required this.height});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
```

## Testing

### Test 1: Check Functions Exist
```sql
-- In Supabase SQL Editor
SELECT * FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name LIKE 'get_%';
```

### Test 2: Test Single Function
```sql
-- Replace with actual employee ID
SELECT * FROM get_today_appointments('8df27a0f-8b76-446f-8b83-e5feb2aeb877');
```

### Test 3: Flutter Widget Test
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:salonmanager/features/employee/presentation/screens/employee_dashboard_screen.dart';

void main() {
  testWidgets('Employee Dashboard loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: EmployeeDashboardScreen(
          employeeId: '8df27a0f-8b76-446f-8b83-e5feb2aeb877',
          salonId: 'b9fbbe58-3b16-43d3-88af-0570ecd3d653',
        ),
      ),
    );

    expect(find.text('Employee Dashboard'), findsOneWidget);
  });
}
```

## Integration Points

### Time Tracking Integration
```dart
// Record check-in
await service.recordTimeEntry(
  employeeId: employeeId,
  salonId: salonId,
  entryType: 'check_in',
);

// Get current status
final shift = await service.getCurrentShift(employeeId);
print(shift?.currentStatus); // 'working', 'on_break', etc.
```

### Real-time Updates
The dashboard uses StreamProvider for real-time appointment updates:
```dart
final streamTodayAppointmentsProvider = StreamProvider.autoDispose<List<EmployeeAppointment>>((ref) async* {
  final employeeId = ref.watch(currentEmployeeIdProvider);
  if (employeeId == null) {
    yield [];
    return;
  }
  final service = ref.watch(employeeDashboardServiceProvider);
  yield* service.streamTodayAppointments(employeeId);
});
```

## Performance Optimization

1. **Caching**: FutureProvider.autoDispose automatically clears cache when unused
2. **Pagination**: Recent customers supports limit parameter (default: 10)
3. **Indexes**: Ensure database has indexes on:
   - appointments.employee_id
   - appointments.start_time
   - work_schedules.employee_id
   - customer_profiles.id
   - dashboard_time_entries.employee_id

## Error Handling

All service methods include try-catch blocks with logging:
```dart
try {
  // operation
} catch (e) {
  print('Error: $e');
  rethrow; // Allows UI to show error
}
```

## Next Steps

1. Deploy SQL functions to Supabase
2. Generate Freezed models
3. Implement service layer
4. Create Riverpod providers
5. Build UI screens
6. Test with real employee data
7. Implement time tracking integration
