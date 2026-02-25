import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/employee_model.dart';
import '../services/supabase_service.dart';
import '../core/auth/identity_provider.dart';
import '../models/activity_log_model.dart';
import '../services/activity_log_service.dart';

final employeeSupabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

class AdminSalonEmployeesGroup {
  final String salonId;
  final String salonName;
  final List<Employee> employees;

  const AdminSalonEmployeesGroup({
    required this.salonId,
    required this.salonName,
    required this.employees,
  });
}

// All employees for current salon
final employeesProvider = FutureProvider<List<Employee>>((ref) async {
  final supabaseService = ref.watch(employeeSupabaseServiceProvider);
  final identity = ref.watch(identityProvider);

  try {
    final user = supabaseService.currentUser;
    if (user == null) return [];

    String? salonId = identity.currentSalonId;
    if (salonId == null || salonId.isEmpty) {
      final salonResponse = await supabaseService.client
        .from('salons')
        .select('id')
        .eq('owner_id', user.id)
        .single();
      salonId = salonResponse['id'] as String?;
    }

    if (salonId == null || salonId.isEmpty) return [];

    final response = await supabaseService.client
        .from('employees')
        .select()
        .eq('salon_id', salonId)
      .eq('is_active', true)
        .order('created_at', ascending: false);

    return (response as List).map((e) => Employee.fromJson(e)).toList();
  } catch (e) {
    return [];
  }
});

final adminEmployeesBySalonProvider =
    FutureProvider<List<AdminSalonEmployeesGroup>>((ref) async {
  final supabaseService = ref.watch(employeeSupabaseServiceProvider);
  final identity = ref.watch(identityProvider);

  try {
    final user = supabaseService.currentUser;
    if (user == null) return [];

    final availableSalons = identity.availableSalons;
    final salonNameById = {
      for (final salon in availableSalons) salon.id: salon.name,
    };

    final requestedSalonIds = <String>[];
    if ((identity.roleKey == 'admin' || identity.roleKey == 'owner') &&
        availableSalons.isNotEmpty) {
      requestedSalonIds.addAll(availableSalons.map((s) => s.id));
    } else if (identity.currentSalonId != null &&
        identity.currentSalonId!.isNotEmpty) {
      requestedSalonIds.add(identity.currentSalonId!);
    }

    final uniqueSalonIds = requestedSalonIds.toSet().toList();
    if (uniqueSalonIds.isEmpty) return [];

    final groups = await Future.wait(
      uniqueSalonIds.map((salonId) async {
        final response = await supabaseService.client
            .from('employees')
            .select()
            .eq('salon_id', salonId)
            .eq('is_active', true)
            .order('created_at', ascending: false);

        final employees =
            (response as List).map((e) => Employee.fromJson(e)).toList();

        return AdminSalonEmployeesGroup(
          salonId: salonId,
          salonName: salonNameById[salonId] ?? 'Salon',
          employees: employees,
        );
      }),
    );

    return groups;
  } catch (e) {
    return [];
  }
});

// Employees by role
final employeesByRoleProvider = FutureProvider.family<List<Employee>, String>((ref, role) async {
  final employees = await ref.watch(employeesProvider.future);
  return employees.where((e) => e.role == role).toList();
});

// Single employee detail
final employeeDetailProvider = FutureProvider.family<Employee?, String>((ref, employeeId) async {
  final supabaseService = ref.watch(employeeSupabaseServiceProvider);

  try {
    final response = await supabaseService.client
        .from('employees')
        .select()
        .eq('id', employeeId)
        .single();

    return Employee.fromJson(response);
  } catch (e) {
    return null;
  }
});

// Employee summary stats
final employeeSummaryProvider = FutureProvider<EmployeeSummary>((ref) async {
  final employees = await ref.watch(employeesProvider.future);

  int stylists = 0;
  int managers = 0;
  int receptionists = 0;
  int active = 0;

  for (var emp in employees) {
    if (emp.isActive == true) active++;
    switch (emp.role) {
      case 'stylist':
        stylists++;
        break;
      case 'manager':
        managers++;
        break;
      case 'receptionist':
        receptionists++;
        break;
    }
  }

  return EmployeeSummary(
    totalEmployees: employees.length,
    stylists: stylists,
    managers: managers,
    receptionists: receptionists,
    activeEmployees: active,
  );
});

// Employee schedule
final employeeScheduleProvider = FutureProvider.family<List<EmployeeSchedule>, String>((ref, employeeId) async {
  final supabaseService = ref.watch(employeeSupabaseServiceProvider);

  try {
    final response = await supabaseService.client
        .from('employee_schedules')
        .select()
        .eq('employee_id', employeeId)
        .order('day_of_week', ascending: true);

    return (response as List).map((e) => EmployeeSchedule.fromJson(e)).toList();
  } catch (e) {
    return [];
  }
});

// Employee notifier for CRUD operations
final employeeNotifierProvider = StateNotifierProvider<EmployeeNotifier, AsyncValue<void>>((ref) {
  final supabaseService = ref.watch(employeeSupabaseServiceProvider);
  return EmployeeNotifier(supabaseService, ref);
});

class EmployeeNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseService _supabaseService;
  final Ref _ref;
  final ActivityLogService _activityLogService;

  EmployeeNotifier(this._supabaseService, this._ref)
      : _activityLogService = ActivityLogService(_supabaseService.client),
        super(const AsyncValue.data(null));

  Future<void> createEmployee(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final user = _supabaseService.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final identity = _ref.read(identityProvider);

      String? salonId = identity.currentSalonId;
      if (salonId == null || salonId.isEmpty) {
        final salonResponse = await _supabaseService.client
            .from('salons')
            .select('id')
            .eq('owner_id', user.id)
            .single();
        salonId = salonResponse['id'] as String?;
      }

      if (salonId == null || salonId.isEmpty) {
        throw Exception('Salon not selected');
      }

      data['salon_id'] = salonId;
      data['is_active'] = true;
      data['created_at'] = DateTime.now().toIso8601String();
      data['updated_at'] = DateTime.now().toIso8601String();

      await _supabaseService.client.from('employees').insert([data]);

      await _logActivity(
        salonId: salonId,
        type: ActivityType.employeeAdded,
        description: 'Mitarbeiter hinzugefuegt',
        metadata: {
          'employee_name': '${data['first_name']} ${data['last_name']}',
          'employee_email': data['email'],
        },
      );

      state = const AsyncValue.data(null);
      _ref.invalidate(employeesProvider);
      _ref.invalidate(employeeSummaryProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateEmployee(String employeeId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      data['updated_at'] = DateTime.now().toIso8601String();

      await _supabaseService.client
          .from('employees')
          .update(data)
          .eq('id', employeeId);

      final identity = _ref.read(identityProvider);
      final salonId = identity.currentSalonId;
      if (salonId != null && salonId.isNotEmpty) {
        await _logActivity(
          salonId: salonId,
          type: ActivityType.permissionChanged,
          description: 'Mitarbeiter aktualisiert',
          metadata: {
            'employee_id': employeeId,
            'changes': data,
          },
        );
      }

      state = const AsyncValue.data(null);
      _ref.invalidate(employeesProvider);
      _ref.invalidate(employeeDetailProvider(employeeId));
      _ref.invalidate(employeeSummaryProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.client
          .from('employees')
          .update({'is_active': false})
          .eq('id', employeeId);

      final identity = _ref.read(identityProvider);
      final salonId = identity.currentSalonId;
      if (salonId != null && salonId.isNotEmpty) {
        await _logActivity(
          salonId: salonId,
          type: ActivityType.employeeRemoved,
          description: 'Mitarbeiter deaktiviert',
          metadata: {
            'employee_id': employeeId,
          },
        );
      }

      state = const AsyncValue.data(null);
      _ref.invalidate(employeesProvider);
      _ref.invalidate(employeeSummaryProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> toggleActiveStatus(String employeeId, bool isActive) async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.client
          .from('employees')
          .update({'is_active': isActive}).eq('id', employeeId);

      final identity = _ref.read(identityProvider);
      final salonId = identity.currentSalonId;
      if (salonId != null && salonId.isNotEmpty) {
        await _logActivity(
          salonId: salonId,
          type: ActivityType.permissionChanged,
          description: isActive ? 'Mitarbeiter aktiviert' : 'Mitarbeiter deaktiviert',
          metadata: {
            'employee_id': employeeId,
            'is_active': isActive,
          },
        );
      }

      state = const AsyncValue.data(null);
      _ref.invalidate(employeesProvider);
      _ref.invalidate(employeeDetailProvider(employeeId));
      _ref.invalidate(employeeSummaryProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateSchedule(String employeeId, List<Map<String, dynamic>> scheduleData) async {
    state = const AsyncValue.loading();
    try {
      // Delete existing schedules
      await _supabaseService.client
          .from('employee_schedules')
          .delete()
          .eq('employee_id', employeeId);

      // Insert new schedules
      for (var schedule in scheduleData) {
        schedule['employee_id'] = employeeId;
        schedule['created_at'] = DateTime.now().toIso8601String();
        schedule['updated_at'] = DateTime.now().toIso8601String();
      }

      await _supabaseService.client.from('employee_schedules').insert(scheduleData);

      state = const AsyncValue.data(null);
      _ref.invalidate(employeeScheduleProvider(employeeId));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> _logActivity({
    required String salonId,
    required ActivityType type,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    final user = _supabaseService.currentUser;
    if (user == null) return;

    await _activityLogService.logActivity(
      salonId: salonId,
      userId: user.id,
      userName: user.email ?? 'Admin',
      type: type,
      description: description,
      metadata: metadata,
    );
  }
}
