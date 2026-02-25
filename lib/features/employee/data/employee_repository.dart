import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';

/// Employee repository provider
final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return EmployeeRepository(supabaseService.client);
});

/// Repository for employee operations
class EmployeeRepository {
  final SupabaseClient _client;

  EmployeeRepository(this._client);

  /// Get employee by ID
  Future<EmployeeData?> getEmployeeById(String employeeId) async {
    try {
      final data = await _client
          .from('employees')
          .select()
          .eq('id', employeeId)
          .maybeSingle();

      if (data == null) return null;

      return EmployeeData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch employee: $e');
    }
  }

  /// Get employee by user ID and salon
  Future<EmployeeData?> getEmployeeByUser({
    required String userId,
    required String salonId,
  }) async {
    try {
      final data = await _client
          .from('employees')
          .select()
          .eq('user_id', userId)
          .eq('salon_id', salonId)
          .maybeSingle();

      if (data == null) return null;

      return EmployeeData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch employee: $e');
    }
  }

  /// Get employee's upcoming appointments
  Future<List<EmployeeAppointment>> getEmployeeAppointments({
    required String employeeId,
    bool upcomingOnly = false,
  }) async {
    try {
      var query = _client
          .from('appointments')
          .select()
          .eq('employee_id', employeeId);

      if (upcomingOnly) {
        query = query.gte('start_time', DateTime.now().toIso8601String());
      }

      final data = await query.order('start_time', ascending: true);

      return (data as List)
          .map((json) => EmployeeAppointment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch appointments: $e');
    }
  }

  /// Get employee's time entries
  Future<List<TimeEntry>> getTimeEntries({
    required String employeeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      var query = _client
          .from('time_entries')
          .select()
          .eq('employee_id', employeeId)
          .order('timestamp', ascending: false);

      dynamic data = await query;
      List filteredData = data as List;

      if (fromDate != null) {
        filteredData = filteredData.where((item) {
          final timestamp = DateTime.parse(item['timestamp']);
          return timestamp.isAfter(fromDate);
        }).toList();
      }

      if (toDate != null) {
        filteredData = filteredData.where((item) {
          final timestamp = DateTime.parse(item['timestamp']);
          return timestamp.isBefore(toDate);
        }).toList();
      }

      return filteredData
          .map((json) => TimeEntry.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch time entries: $e');
    }
  }

  /// Clock in
  Future<TimeEntry> clockIn({
    required String salonId,
    required String employeeId,
    String? notes,
  }) async {
    try {
      final data = await _client.from('time_entries').insert({
        'salon_id': salonId,
        'employee_id': employeeId,
        'entry_type': 'clock_in',
        'timestamp': DateTime.now().toIso8601String(),
        'notes': notes,
      }).select().single();

      return TimeEntry.fromJson(data);
    } catch (e) {
      throw Exception('Failed to clock in: $e');
    }
  }

  /// Clock out
  Future<TimeEntry> clockOut({
    required String salonId,
    required String employeeId,
    String? notes,
  }) async {
    try {
      // Get last clock-in time
      final lastEntry = await _client
          .from('time_entries')
          .select()
          .eq('employee_id', employeeId)
          .eq('entry_type', 'clock_in')
          .order('timestamp', ascending: false)
          .limit(1)
          .maybeSingle();

      late int durationMinutes;
      if (lastEntry != null) {
        final clockInTime = DateTime.parse(lastEntry['timestamp'] as String);
        durationMinutes = DateTime.now().difference(clockInTime).inMinutes;
      }

      final data = await _client.from('time_entries').insert({
        'salon_id': salonId,
        'employee_id': employeeId,
        'entry_type': 'clock_out',
        'timestamp': DateTime.now().toIso8601String(),
        'duration_minutes': durationMinutes,
        'notes': notes,
      }).select().single();

      return TimeEntry.fromJson(data);
    } catch (e) {
      throw Exception('Failed to clock out: $e');
    }
  }

  /// Get current time entry (active clock in)
  Future<Map<String, dynamic>?> getCurrentTimeEntry(String employeeId) async {
    try {
      final data = await _client
          .from('time_entries')
          .select()
          .eq('employee_id', employeeId)
          .eq('entry_type', 'clock_in')
          .order('timestamp', ascending: false)
          .limit(1)
          .maybeSingle();

      return data;
    } catch (e) {
      return null;
    }
  }

  /// Get all employees in a salon
  Future<List<dynamic>> getSalonEmployees(String salonId) async {
    try {
      final data = await _client
          .from('employees')
          .select()
          .eq('salon_id', salonId)
          .order('created_at', ascending: true);

      return data as List;
    } catch (e) {
      throw Exception('Failed to fetch salon employees: $e');
    }
  }

  /// Create leave request
  Future<LeaveRequest> createLeaveRequest({
    required String salonId,
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    try {
      final data = await _client.from('leave_requests').insert({
        'salon_id': salonId,
        'employee_id': employeeId,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'reason': reason,
        'status': 'pending',
      }).select().single();

      return LeaveRequest.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create leave request: $e');
    }
  }

  /// Get leave requests for employee
  Future<List<LeaveRequest>> getLeaveRequests({
    required String employeeId,
    String? status,
  }) async {
    try {
      var query = _client
          .from('leave_requests')
          .select()
          .eq('employee_id', employeeId);

      if (status != null) {
        query = query.eq('status', status);
      }

      final data = await query.order('start_date', ascending: true);

      return (data as List)
          .map((json) => LeaveRequest.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch leave requests: $e');
    }
  }

  /// Update appointment status by employee
  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    try {
      await _client
          .from('appointments')
          .update({'status': status})
          .eq('id', appointmentId);
    } catch (e) {
      throw Exception('Failed to update appointment: $e');
    }
  }

  /// Get employee services
  Future<List<String>> getEmployeeServices(String employeeId) async {
    try {
      final data = await _client
          .from('employee_services')
          .select('service_id')
          .eq('employee_id', employeeId);

      return (data as List)
          .map((json) => json['service_id'] as String)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch employee services: $e');
    }
  }

  /// Get work schedule for employee
  Future<List<WorkSchedule>> getWorkSchedule(String employeeId) async {
    try {
      final data = await _client
          .from('work_schedules')
          .select()
          .eq('employee_id', employeeId);

      return (data as List)
          .map((json) => WorkSchedule.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch work schedule: $e');
    }
  }
}

/// Employee data model
class EmployeeData {
  final String id;
  final String salonId;
  final String? userId;
  final String? role;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final bool? isActive;
  final DateTime createdAt;

  EmployeeData({
    required this.id,
    required this.salonId,
    this.userId,
    this.role,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.isActive,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      userId: json['user_id'] as String?,
      role: json['role'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}

/// Employee appointment summary
class EmployeeAppointment {
  final String id;
  final String? customerProfileId;
  final String? guestName;
  final String? guestEmail;
  final String? serviceId;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final double? price;

  EmployeeAppointment({
    required this.id,
    this.customerProfileId,
    this.guestName,
    this.guestEmail,
    this.serviceId,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.price,
  });

  String get customerName => guestName ?? 'Guest';
  Duration get duration => endTime.difference(startTime);

  factory EmployeeAppointment.fromJson(Map<String, dynamic> json) {
    return EmployeeAppointment(
      id: json['id'] as String,
      customerProfileId: json['customer_profile_id'] as String?,
      guestName: json['guest_name'] as String?,
      guestEmail: json['guest_email'] as String?,
      serviceId: json['service_id'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      status: json['status'] as String? ?? 'pending',
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}

/// Time entry model (clock in/out)
class TimeEntry {
  final String id;
  final String salonId;
  final String employeeId;
  final String entryType; // 'clock_in' or 'clock_out'
  final DateTime timestamp;
  final int? durationMinutes;
  final String? notes;
  final bool? adminConfirmed;
  final String? adminId;
  final DateTime? confirmedAt;

  TimeEntry({
    required this.id,
    required this.salonId,
    required this.employeeId,
    required this.entryType,
    required this.timestamp,
    this.durationMinutes,
    this.notes,
    this.adminConfirmed,
    this.adminId,
    this.confirmedAt,
  });

  bool get isClockIn => entryType == 'clock_in';
  bool get isClockOut => entryType == 'clock_out';

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      employeeId: json['employee_id'] as String? ?? '',
      entryType: json['entry_type'] as String? ?? '',
      timestamp: DateTime.parse(json['timestamp'] as String),
      durationMinutes: json['duration_minutes'] as int?,
      notes: json['notes'] as String?,
      adminConfirmed: json['admin_confirmed'] as bool?,
      adminId: json['admin_id'] as String?,
      confirmedAt: json['confirmed_at'] != null ? DateTime.parse(json['confirmed_at'] as String) : null,
    );
  }
}

/// Leave request model
class LeaveRequest {
  final String id;
  final String salonId;
  final String employeeId;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status; // 'pending', 'approved', 'rejected'
  final String? rejectionReason;
  final DateTime createdAt;

  LeaveRequest({
    required this.id,
    required this.salonId,
    required this.employeeId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.rejectionReason,
    required this.createdAt,
  });

  Duration get duration => endDate.difference(startDate);
  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      employeeId: json['employee_id'] as String? ?? '',
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      reason: json['reason'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      rejectionReason: json['rejection_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}

/// Work schedule model
class WorkSchedule {
  final String id;
  final String salonId;
  final String employeeId;
  final int dayOfWeek; // 0-6 (Monday-Sunday)
  final String? startTime;
  final String? endTime;
  final bool? isWorking;

  WorkSchedule({
    required this.id,
    required this.salonId,
    required this.employeeId,
    required this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.isWorking,
  });

  String get dayName {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[dayOfWeek];
  }

  factory WorkSchedule.fromJson(Map<String, dynamic> json) {
    return WorkSchedule(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      employeeId: json['employee_id'] as String? ?? '',
      dayOfWeek: json['day_of_week'] as int? ?? 0,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      isWorking: json['is_working'] as bool? ?? true,
    );
  }
}
