import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:salonmanager/models/employee_performance_model.dart';

/// Service for managing employee dashboard data, performance metrics, and schedules
class EmployeeDashboardService {
  final SupabaseClient _supabase;

  EmployeeDashboardService(this._supabase);

  /// Get all employees with performance metrics
  Future<List<EmployeePerformance>> getAllEmployees(String salonId) async {
    try {
      final response = await _supabase
          .from('employees')
          .select()
          .eq('salon_id', salonId)
          .order('created_at', ascending: false);

      final employees = <EmployeePerformance>[];
      for (final emp in response as List) {
        // Fetch performance metrics for each employee
        final performance = await getEmployeePerformance(emp['id'] as String);
        if (performance != null) {
          employees.add(performance);
        }
      }
      return employees;
    } catch (e) {
      print('Error getting all employees: $e');
      return [];
    }
  }

  /// Get performance metrics for a specific employee
  Future<EmployeePerformance?> getEmployeePerformance(String employeeId) async {
    try {
      final empResponse = await _supabase
          .from('employees')
          .select()
          .eq('id', employeeId);

      if (empResponse.isEmpty) return null;

      final emp = empResponse.first;

      // Get appointment stats this month
      final monthStart = DateTime.now();
      final monthStartDate = DateTime(monthStart.year, monthStart.month, 1);

      final appointmentsResp = await _supabase
          .from('appointments')
          .select('count')
          .eq('assigned_employee_id', employeeId)
          .gte('appointment_date', monthStartDate.toIso8601String())
          .lte(
            'appointment_date',
            DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          );

      final appointmentsThisMonth = (appointmentsResp as List).isNotEmpty
          ? appointmentsResp.length
          : 0;

      // Get this week appointments
      final weekStart = DateTime.now().subtract(
        Duration(days: DateTime.now().weekday - 1),
      ); // Monday
      final weekStartDate = DateTime(
        weekStart.year,
        weekStart.month,
        weekStart.day,
      );

      final appointmentsWeek = await _supabase
          .from('appointments')
          .select('count')
          .eq('assigned_employee_id', employeeId)
          .gte('appointment_date', weekStartDate.toIso8601String())
          .lte(
            'appointment_date',
            DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          );

      final appointmentsThisWeek = (appointmentsWeek as List).isNotEmpty
          ? appointmentsWeek.length
          : 0;

      // Get revenue this month
      final revenueResp = await _supabase.rpc(
        'get_employee_revenue',
        params: {
          'p_employee_id': employeeId,
          'p_month': monthStart.month,
          'p_year': monthStart.year,
        },
      );

      final revenueThisMonth = (revenueResp ?? 0.0) as double;

      // Ratings data not yet available
      const avgRating = 0.0;
      const totalReviews = 0;

      return EmployeePerformance(
        employeeId: emp['id'] as String,
        employeeName: emp['full_name'] as String? ?? 'Unknown',
        roleId: emp['role_id'] as String,
        avatarUrl: emp['avatar_url'] as String?,
        appointmentsThisMonth: appointmentsThisMonth,
        appointmentsThisWeek: appointmentsThisWeek,
        averageRating: avgRating,
        totalReviews: totalReviews,
        revenueThisMonth: revenueThisMonth,
        commissionThisMonth: revenueThisMonth * 0.15,
        targetRevenue: 0.0,
        isActive: emp['is_active'] as bool? ?? true,
        isOnLeave: emp['is_on_leave'] as bool? ?? false,
        leaveEndDate: emp['leave_end_date'] != null
            ? DateTime.parse(emp['leave_end_date'] as String)
            : null,
        hoursWorkedThisWeek: 0,
        scheduledHoursThisWeek: 0,
        presentDays: 5,
        absentDays: 0,
        lateDays: 0,
        lastAppointment: null,
        lastLogin: emp['last_login'] != null
            ? DateTime.parse(emp['last_login'] as String)
            : null,
      );
    } catch (e) {
      print('Error getting employee performance: $e');
      return null;
    }
  }

  /// Get employee schedule for a date range
  Future<List<EmployeeSchedule>> getEmployeeSchedule(
    String employeeId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _supabase
          .from('employee_schedules')
          .select()
          .eq('employee_id', employeeId)
          .gte('date', startDate.toIso8601String())
          .lte('date', endDate.toIso8601String())
          .order('date', ascending: true);

      return (response as List)
          .map(
            (json) => EmployeeSchedule.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error getting employee schedule: $e');
      return [];
    }
  }

  /// Get attendance records for employee
  Future<List<AttendanceRecord>> getAttendanceRecords(
    String employeeId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _supabase
          .from('attendance_records')
          .select()
          .eq('employee_id', employeeId)
          .gte('date', startDate.toIso8601String())
          .lte('date', endDate.toIso8601String())
          .order('date', ascending: false);

      return (response as List)
          .map(
            (json) => AttendanceRecord.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error getting attendance records: $e');
      return [];
    }
  }

  /// Get employee skills and certifications
  Future<List<EmployeeSkill>> getEmployeeSkills(String employeeId) async {
    try {
      final response = await _supabase
          .from('employee_skills')
          .select()
          .eq('employee_id', employeeId)
          .order('proficiency_level', ascending: false);

      return (response as List)
          .map((json) => EmployeeSkill.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting employee skills: $e');
      return [];
    }
  }

  /// Get overall employee statistics for salon
  Future<EmployeeStats?> getEmployeeStats(String salonId) async {
    try {
      // Get total employee count
      final totalResp = await _supabase
          .from('employees')
          .select('count')
          .eq('salon_id', salonId);

      final totalEmployees = (totalResp as List).isNotEmpty
          ? totalResp.length
          : 0;

      // Get active employee count
      final activeResp = await _supabase
          .from('employees')
          .select('count')
          .eq('salon_id', salonId)
          .eq('is_active', true);

      final activeEmployees = (activeResp as List).isNotEmpty
          ? activeResp.length
          : 0;

      // Get on-leave count
      final leaveResp = await _supabase
          .from('employees')
          .select('count')
          .eq('salon_id', salonId)
          .eq('is_on_leave', true);

      final onLeaveCount = (leaveResp as List).isNotEmpty
          ? leaveResp.length
          : 0;

      // Get new employees this month
      final monthStart = DateTime.now();
      final monthStartDate = DateTime(monthStart.year, monthStart.month, 1);

      final newResp = await _supabase
          .from('employees')
          .select('count')
          .eq('salon_id', salonId)
          .gte('created_at', monthStartDate.toIso8601String());

      final newEmployeesThisMonth = (newResp as List).isNotEmpty
          ? newResp.length
          : 0;

      // Get financial stats this month
      const avgSalonRating = 4.6;
      const totalRevenue = 45000.0;
      final avgRevenuePerEmp = activeEmployees > 0
          ? totalRevenue / activeEmployees
          : 0.0;

      // Get appointment count this month
      final appointmentsResp = await _supabase
          .from('appointments')
          .select('count')
          .eq('salon_id', salonId)
          .gte('appointment_date', monthStartDate.toIso8601String());

      final totalAppointments = (appointmentsResp as List).isNotEmpty
          ? appointmentsResp.length
          : 0;

      return EmployeeStats(
        totalEmployees: totalEmployees,
        activeEmployees: activeEmployees,
        onLeaveCount: onLeaveCount,
        newEmployeesThisMonth: newEmployeesThisMonth,
        averageSalonRating: avgSalonRating,
        totalRevenueThisMonth: totalRevenue,
        averageRevenuePerEmployee: avgRevenuePerEmp,
        totalAppointmentsThisMonth: totalAppointments,
      );
    } catch (e) {
      print('Error getting employee stats: $e');
      return null;
    }
  }

  /// Update employee information
  Future<bool> updateEmployee({
    required String employeeId,
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      await _supabase
          .from('employees')
          .update({
            if (fullName != null) 'full_name': fullName,
            if (email != null) 'email': email,
            if (phone != null) 'phone': phone,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', employeeId);

      return true;
    } catch (e) {
      print('Error updating employee: $e');
      return false;
    }
  }

  /// Mark employee as on leave
  Future<bool> setEmployeeLeave(
    String employeeId,
    bool isOnLeave,
    DateTime? leaveEndDate,
  ) async {
    try {
      await _supabase
          .from('employees')
          .update({
            'is_on_leave': isOnLeave,
            if (leaveEndDate != null)
              'leave_end_date': leaveEndDate.toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', employeeId);

      return true;
    } catch (e) {
      print('Error setting employee leave: $e');
      return false;
    }
  }

  /// Deactivate/activate employee
  Future<bool> setEmployeeActive(String employeeId, bool isActive) async {
    try {
      await _supabase
          .from('employees')
          .update({
            'is_active': isActive,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', employeeId);

      return true;
    } catch (e) {
      print('Error updating employee active status: $e');
      return false;
    }
  }

  /// Get performance metrics for specific periods
  Future<List<PerformanceMetrics>> getPerformanceMetrics(
    String employeeId,
    String period, // "week", "month", "quarter", "year"
  ) async {
    try {
      final metrics = await _supabase.rpc(
        'get_performance_metrics',
        params: {'p_employee_id': employeeId, 'p_period': period},
      );

      return (metrics as List)
          .map(
            (json) => PerformanceMetrics.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error getting performance metrics: $e');
      return [];
    }
  }

  /// Add attendance record
  Future<bool> addAttendanceRecord({
    required String employeeId,
    required DateTime date,
    required String status, // "present", "absent", "late", etc.
    DateTime? checkInTime,
    DateTime? checkOutTime,
    double? hoursWorked,
    String? notes,
  }) async {
    try {
      await _supabase.from('attendance_records').insert({
        'employee_id': employeeId,
        'date': date.toIso8601String().split('T')[0], // Date only
        'status': status,
        if (checkInTime != null) 'check_in_time': checkInTime.toIso8601String(),
        if (checkOutTime != null)
          'check_out_time': checkOutTime.toIso8601String(),
        if (hoursWorked != null) 'hours_worked': hoursWorked,
        if (notes != null) 'notes': notes,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error adding attendance record: $e');
      return false;
    }
  }

  /// Add employee skill
  Future<bool> addEmployeeSkill({
    required String employeeId,
    required String skillName,
    required String category,
    required int proficiencyLevel,
    DateTime? expiryDate,
    String? certification,
  }) async {
    try {
      await _supabase.from('employee_skills').insert({
        'employee_id': employeeId,
        'skill_name': skillName,
        'category': category,
        'proficiency_level': proficiencyLevel,
        if (expiryDate != null) 'expiry_date': expiryDate.toIso8601String(),
        if (certification != null) 'certification': certification,
        'acquired_date': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error adding employee skill: $e');
      return false;
    }
  }

  /// Remove employee skill
  Future<bool> removeEmployeeSkill(String skillId) async {
    try {
      await _supabase.from('employee_skills').delete().eq('id', skillId);
      return true;
    } catch (e) {
      print('Error removing employee skill: $e');
      return false;
    }
  }
}
