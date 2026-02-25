import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/data/user_repository.dart';
import '../features/bookings/data/booking_repository.dart';
import '../features/employee/data/employee_repository.dart';
import '../features/transactions/data/transaction_repository.dart';
import '../features/inventory/data/inventory_repository.dart';
import '../models/appointment_model_simple.dart';
import '../models/leave_request_model.dart' as leave_model;
import '../models/salon_settings_model.dart';
import '../models/time_entry_model.dart';
import '../services/dashboard_service.dart';
import '../services/leave_request_service.dart';
import '../services/supabase_service.dart';
import '../services/time_tracking_service.dart';
import 'auth_provider.dart' show currentUserProvider;

// ============================================================================
// CUSTOMER DASHBOARD PROVIDERS
// ============================================================================

/// Dashboard service provider
final dashboardServiceProvider = Provider<DashboardService>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return DashboardService(supabaseService.client);
});

/// Salon settings for admin dashboard
final salonSettingsProvider = FutureProvider.family<SalonSettings?, String>((ref, salonId) async {
  final service = ref.watch(dashboardServiceProvider);
  return service.getSalonSettings(salonId);
});

/// Salon code for staff access
final salonCodeProvider = FutureProvider.family<String?, String>((ref, salonId) async {
  final service = ref.watch(dashboardServiceProvider);
  return service.getSalonCode(salonId);
});

/// Activity log
final activityLogProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  return service.getActivityLog();
});

/// Customer's upcoming appointments
final customerAppointmentsProvider = FutureProvider<List<AppointmentSimple>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return [];

  final bookingRepo = ref.watch(bookingRepositoryProvider);
  try {
    final appointments = await bookingRepo.getCustomerAppointments(user.id);
    return appointments.map(_mapAppointmentSimple).toList();
  } catch (e) {
    return [];
  }
});

// ============================================================================
// EMPLOYEE DASHBOARD PROVIDERS
// ============================================================================

/// Employee's own appointments/schedule
final employeeAppointmentsProvider = FutureProvider<List<AppointmentSimple>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return [];

  final bookingRepo = ref.watch(bookingRepositoryProvider);
  try {
    final appointments = await bookingRepo.getEmployeeAppointments(user.id);
    return appointments.map(_mapAppointmentSimple).toList();
  } catch (e) {
    return [];
  }
});

/// Employee's time tracking status (clock in/out)
final employeeTimeTrackingProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return null;

  final employeeRepo = ref.watch(employeeRepositoryProvider);
  try {
    return await employeeRepo.getCurrentTimeEntry(user.id);
  } catch (e) {
    return null;
  }
});

/// Time tracking service
final timeTrackingServiceProvider = Provider<TimeTrackingService>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return TimeTrackingService(supabaseService.client);
});

/// Employee time tracking status
final timeTrackingStatusProvider = FutureProvider<TimeEntryStatus>((ref) async {
  final service = ref.watch(timeTrackingServiceProvider);
  return service.getStatus();
});

/// Employee's leave requests
final employeeLeaveRequestsProvider = FutureProvider<List<dynamic>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return [];

  final employeeRepo = ref.watch(employeeRepositoryProvider);
  try {
    return await employeeRepo.getLeaveRequests(employeeId: user.id);
  } catch (e) {
    return [];
  }
});

/// Leave request service
final leaveRequestServiceProvider = Provider<LeaveRequestService>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return LeaveRequestService(supabaseService.client);
});

/// Current user's leave requests
final myLeaveRequestsProvider = FutureProvider<List<leave_model.LeaveRequest>>((ref) async {
  final service = ref.watch(leaveRequestServiceProvider);
  return service.getMyRequests();
});

AppointmentSimple _mapAppointmentSimple(AppointmentData data) {
  return AppointmentSimple(
    id: data.id,
    startTime: data.startTime,
    endTime: data.endTime,
    customerName: data.guestName ?? 'Kunde',
    customerPhone: data.guestPhone,
    serviceName: data.serviceId ?? 'Service',
    price: data.price ?? 0,
    status: _mapAppointmentStatus(data.status),
    stylistName: null,
    stylistId: data.employeeId,
    notes: data.notes,
  );
}

AppointmentStatus _mapAppointmentStatus(String status) {
  switch (status) {
    case 'confirmed':
      return AppointmentStatus.confirmed;
    case 'completed':
      return AppointmentStatus.completed;
    case 'cancelled':
      return AppointmentStatus.cancelled;
    case 'no_show':
      return AppointmentStatus.noShow;
    case 'pending':
    default:
      return AppointmentStatus.pending;
  }
}

/// Employee's schedule for the month
final employeeScheduleProvider = FutureProvider.family<List<dynamic>, DateTime>(
  (ref, month) async {
    final user = await ref.watch(currentUserProvider.future);
    if (user == null) return [];

    final employeeRepo = ref.watch(employeeRepositoryProvider);
    try {
      return await employeeRepo.getWorkSchedule(user.id);
    } catch (e) {
      return [];
    }
  },
);

// ============================================================================
// ADMIN DASHBOARD PROVIDERS
// ============================================================================

/// Admin employee count
final employeeCountProvider = FutureProvider.family<int, String>((ref, salonId) async {
  final service = ref.watch(dashboardServiceProvider);
  final employees = await service.getEmployees(salonId);
  return employees.length;
});

/// Admin daily workload
final dailyWorkloadProvider = FutureProvider.family<List<dynamic>, String>((ref, salonId) async {
  final service = ref.watch(dashboardServiceProvider);
  final now = DateTime.now();
  final date = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  return service.getDailyWorkload(salonId, date);
});

/// Admin's salon appointments (all appointments in their salon)
final adminSalonAppointmentsProvider = FutureProvider<List<dynamic>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return [];

  final bookingRepo = ref.watch(bookingRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  
  try {
    // Get admin's primary salon
    final salonContext = await userRepo.fetchSalonContext(user.id);
    if (salonContext?.primarySalonId == null) return [];

    return await bookingRepo.getSalonAppointments(salonId: salonContext!.primarySalonId!);
  } catch (e) {
    return [];
  }
});

/// Admin's inventory overview
final adminInventoryProvider = FutureProvider<List<dynamic>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return [];

  final inventoryRepo = ref.watch(inventoryRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  
  try {
    final salonContext = await userRepo.fetchSalonContext(user.id);
    if (salonContext?.primarySalonId == null) return [];

    return await inventoryRepo.getInventory(salonContext!.primarySalonId!);
  } catch (e) {
    return [];
  }
});

/// Admin's employees list
final adminEmployeesProvider = FutureProvider<List<dynamic>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return [];

  final employeeRepo = ref.watch(employeeRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  
  try {
    final salonContext = await userRepo.fetchSalonContext(user.id);
    if (salonContext?.primarySalonId == null) return [];

    return await employeeRepo.getSalonEmployees(salonContext!.primarySalonId!);
  } catch (e) {
    return [];
  }
});

/// Admin's low inventory items
final adminLowInventoryProvider = FutureProvider<List<dynamic>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return [];

  final inventoryRepo = ref.watch(inventoryRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  
  try {
    final salonContext = await userRepo.fetchSalonContext(user.id);
    if (salonContext?.primarySalonId == null) return [];

    return await inventoryRepo.getLowInventoryItems(
      salonContext!.primarySalonId!,
      threshold: 5,
    );
  } catch (e) {
    print('Error fetching low inventory: $e');
    return [];
  }
});

/// Admin's transaction summary (revenue, etc)
final adminTransactionSummaryProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return null;

  final transactionRepo = ref.watch(transactionRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  
  try {
    final salonContext = await userRepo.fetchSalonContext(user.id);
    if (salonContext?.primarySalonId == null) return null;

    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    
    final summary = await transactionRepo.getRevenueSummary(
      salonId: salonContext!.primarySalonId!,
      fromDate: firstDayOfMonth,
      toDate: now,
    );
    
    return {
      'totalRevenue': summary.totalRevenue,
      'totalTransactions': summary.transactionCount,
      'period': 'month',
    };
  } catch (e) {
    print('Error fetching transaction summary: $e');
    return null;
  }
});

// ============================================================================
// SHARED DASHBOARD PROVIDERS
// ============================================================================

/// User's current salon context
final userSalonContextProvider = FutureProvider<SalonContext?>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return null;

  final userRepo = ref.watch(userRepositoryProvider);
  try {
    return await userRepo.fetchSalonContext(user.id);
  } catch (e) {
    print('Error fetching salon context: $e');
    return null;
  }
});

// ==================== State Providers for UI ====================
final activeTabProvider = StateProvider<int>((ref) => 0);

final showModuleSettings = StateProvider<bool>((ref) => false);

final isLoading = StateProvider<bool>((ref) => false);
