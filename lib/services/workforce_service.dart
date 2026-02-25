import 'package:supabase_flutter/supabase_flutter.dart';

const Set<String> _supportedLeaveTypes = {
  'vacation',
  'sick',
  'personal',
  'training',
};

const Set<String> _supportedLeaveStatuses = {
  'pending',
  'approved',
  'rejected',
};

const int _defaultVacationAllowanceDays = 30;

String _normalizeWorkforceLeaveType(String? value) {
  final normalized = (value ?? '').trim().toLowerCase();

  if (_supportedLeaveTypes.contains(normalized)) {
    return normalized;
  }

  switch (normalized) {
    case 'other':
      return 'personal';
    default:
      return 'vacation';
  }
}

String _normalizeWorkforceLeaveStatus(String? value) {
  final normalized = (value ?? '').trim().toLowerCase();

  switch (normalized) {
    case 'pending':
    case 'approved':
    case 'rejected':
      return normalized;
    case 'declined':
      return 'rejected';
    default:
      return 'pending';
  }
}

class WorkforceEmployee {
  final String id;
  final String salonId;
  final String? userId;
  final String name;

  WorkforceEmployee({
    required this.id,
    required this.salonId,
    required this.userId,
    required this.name,
  });

  factory WorkforceEmployee.fromJson(Map<String, dynamic> json) {
    final firstName = (json['first_name'] as String?)?.trim() ?? '';
    final lastName = (json['last_name'] as String?)?.trim() ?? '';
    final displayName = (json['display_name'] as String?)?.trim() ?? '';
    final fullName = ('$firstName $lastName').trim();

    return WorkforceEmployee(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      userId: json['user_id'] as String?,
      name: fullName.isNotEmpty
          ? fullName
          : (displayName.isNotEmpty ? displayName : 'Mitarbeiter'),
    );
  }
}

class WorkforceSchedule {
  final String id;
  final String employeeId;
  final String? salonId;
  final String? salonName;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isRecurring;
  final DateTime? specificDate;

  WorkforceSchedule({
    required this.id,
    required this.employeeId,
    required this.salonId,
    required this.salonName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isRecurring,
    required this.specificDate,
  });

  factory WorkforceSchedule.fromJson(Map<String, dynamic> json) {
    final salonData = json['salons'];
    String? salonName;
    if (salonData is Map<String, dynamic>) {
      salonName = salonData['name']?.toString();
    }

    return WorkforceSchedule(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      salonId: json['salon_id']?.toString(),
      salonName: salonName,
      dayOfWeek: (json['day_of_week'] as num?)?.toInt() ?? 0,
      startTime: (json['start_time'] as String?) ?? '09:00:00',
      endTime: (json['end_time'] as String?) ?? '17:00:00',
      isRecurring: json['is_recurring'] as bool? ?? true,
      specificDate: json['specific_date'] != null
          ? DateTime.tryParse(json['specific_date'].toString())
          : null,
    );
  }
}

class WorkforceLeaveRequest {
  final String id;
  final String salonId;
  final String employeeId;
  final String employeeName;
  final String leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String? reason;
  final String? approvedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WorkforceLeaveRequest({
    required this.id,
    required this.salonId,
    required this.employeeId,
    required this.employeeName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.reason,
    required this.approvedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  int get dayCount {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    if (end.isBefore(start)) {
      return 0;
    }

    return end.difference(start).inDays + 1;
  }

  factory WorkforceLeaveRequest.fromJson(Map<String, dynamic> json) {
    final employee = json['employees'];
    String employeeName = 'Mitarbeiter';
    if (employee is Map<String, dynamic>) {
      final firstName = (employee['first_name'] as String?)?.trim() ?? '';
      final lastName = (employee['last_name'] as String?)?.trim() ?? '';
      final name = ('$firstName $lastName').trim();
      final displayName = (employee['display_name'] as String?)?.trim() ?? '';
      if (name.isNotEmpty) {
        employeeName = name;
      } else if (displayName.isNotEmpty) {
        employeeName = displayName;
      }
    }

    return WorkforceLeaveRequest(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      employeeId: json['employee_id'] as String,
      employeeName: employeeName,
      leaveType: _normalizeWorkforceLeaveType(json['leave_type']?.toString()),
      startDate: DateTime.parse(json['start_date'].toString()),
      endDate: DateTime.parse(json['end_date'].toString()),
      status: _normalizeWorkforceLeaveStatus(json['status']?.toString()),
      reason: json['reason'] as String?,
      approvedBy: json['approved_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }
}

class SalonOpeningHour {
  final String dayKey;
  final bool closed;
  final String open;
  final String close;

  const SalonOpeningHour({
    required this.dayKey,
    required this.closed,
    required this.open,
    required this.close,
  });
}

class SalonClosure {
  final String id;
  final String salonId;
  final DateTime startDate;
  final DateTime endDate;
  final String? reason;

  const SalonClosure({
    required this.id,
    required this.salonId,
    required this.startDate,
    required this.endDate,
    required this.reason,
  });

  factory SalonClosure.fromJson(Map<String, dynamic> json) {
    return SalonClosure(
      id: json['id'] as String,
      salonId: json['salon_id'] as String,
      startDate: DateTime.parse(json['start_date'].toString()),
      endDate: DateTime.parse(json['end_date'].toString()),
      reason: json['reason'] as String?,
    );
  }
}

class ScheduleValidationResult {
  final bool canSave;
  final List<String> blockingIssues;
  final List<String> warnings;

  const ScheduleValidationResult({
    required this.canSave,
    required this.blockingIssues,
    required this.warnings,
  });
}

class WorkforceService {
  WorkforceService(this._client);

  final SupabaseClient _client;

  Future<List<WorkforceEmployee>> getSalonEmployees(String salonId) async {
    final data = await _client
        .from('employees')
        .select('id, salon_id, user_id, display_name')
        .eq('salon_id', salonId)
        .order('display_name', ascending: true);

    return (data as List)
        .whereType<Map<String, dynamic>>()
        .map(WorkforceEmployee.fromJson)
        .toList();
  }

  Future<WorkforceEmployee?> getCurrentEmployeeForUser({
    required String userId,
    String? salonId,
  }) async {
    var query = _client
        .from('employees')
        .select('id, salon_id, user_id, display_name')
        .eq('user_id', userId);

    if (salonId != null && salonId.isNotEmpty) {
      query = query.eq('salon_id', salonId);
    }

    final data = await query.limit(1).maybeSingle();

    if (data == null) {
      return null;
    }

    return WorkforceEmployee.fromJson(data);
  }

  Future<List<WorkforceSchedule>> getEmployeeSchedules(String employeeId) async {
    dynamic data;
    try {
      data = await _client
          .from('work_schedules')
          .select('*, salons:salon_id(id, name)')
          .eq('employee_id', employeeId)
          .order('specific_date', ascending: true)
          .order('day_of_week', ascending: true)
          .order('start_time', ascending: true);
    } catch (_) {
      data = await _client
          .from('work_schedules')
          .select()
          .eq('employee_id', employeeId)
          .order('specific_date', ascending: true)
          .order('day_of_week', ascending: true)
          .order('start_time', ascending: true);
    }

    return (data as List)
        .whereType<Map<String, dynamic>>()
        .map(WorkforceSchedule.fromJson)
        .toList();
  }

  Future<Map<String, SalonOpeningHour>> getSalonOpeningHours(String salonId) async {
    final defaults = <String, SalonOpeningHour>{
      'monday': const SalonOpeningHour(
        dayKey: 'monday',
        closed: false,
        open: '09:00',
        close: '18:00',
      ),
      'tuesday': const SalonOpeningHour(
        dayKey: 'tuesday',
        closed: false,
        open: '09:00',
        close: '18:00',
      ),
      'wednesday': const SalonOpeningHour(
        dayKey: 'wednesday',
        closed: false,
        open: '09:00',
        close: '18:00',
      ),
      'thursday': const SalonOpeningHour(
        dayKey: 'thursday',
        closed: false,
        open: '09:00',
        close: '18:00',
      ),
      'friday': const SalonOpeningHour(
        dayKey: 'friday',
        closed: false,
        open: '09:00',
        close: '18:00',
      ),
      'saturday': const SalonOpeningHour(
        dayKey: 'saturday',
        closed: true,
        open: '09:00',
        close: '14:00',
      ),
      'sunday': const SalonOpeningHour(
        dayKey: 'sunday',
        closed: true,
        open: '00:00',
        close: '00:00',
      ),
    };

    try {
      final response = await _client
          .from('salons')
          .select('opening_hours')
          .eq('id', salonId)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        return defaults;
      }

      final raw = response['opening_hours'];
      if (raw is! Map) {
        return defaults;
      }

      final result = <String, SalonOpeningHour>{...defaults};
      for (final entry in raw.entries) {
        final key = entry.key.toString();
        final value = entry.value;
        if (value is! Map) {
          continue;
        }

        result[key] = SalonOpeningHour(
          dayKey: key,
          closed: value['closed'] == true,
          open: _normalizeHourField(value['open']?.toString() ?? '09:00'),
          close: _normalizeHourField(value['close']?.toString() ?? '18:00'),
        );
      }

      return result;
    } catch (_) {
      return defaults;
    }
  }

  Future<void> updateSalonOpeningHour({
    required String salonId,
    required String dayKey,
    required bool closed,
    required String open,
    required String close,
  }) async {
    final current = await _client
        .from('salons')
        .select('opening_hours')
        .eq('id', salonId)
        .limit(1)
        .maybeSingle();

    final raw = <String, dynamic>{};
    if (current != null && current['opening_hours'] is Map) {
      raw.addAll((current['opening_hours'] as Map).cast<String, dynamic>());
    }

    raw[dayKey] = {
      'open': _normalizeHourField(open),
      'close': _normalizeHourField(close),
      'closed': closed,
    };

    await _client
        .from('salons')
        .update({'opening_hours': raw, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', salonId);
  }

  Future<List<SalonClosure>> getSalonClosures(String salonId) async {
    final data = await _client
        .from('salon_closures')
        .select('id, salon_id, start_date, end_date, reason')
        .eq('salon_id', salonId)
        .order('start_date', ascending: false);

    return (data as List)
        .whereType<Map<String, dynamic>>()
        .map(SalonClosure.fromJson)
        .toList();
  }

  Future<void> addSalonClosure({
    required String salonId,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  }) async {
    await _client.from('salon_closures').insert({
      'salon_id': salonId,
      'start_date': _toDateOnly(startDate),
      'end_date': _toDateOnly(endDate),
      'reason': reason,
    });
  }

  Future<void> deleteSalonClosure(String closureId) async {
    await _client.from('salon_closures').delete().eq('id', closureId);
  }

  Future<void> setRecurringSchedule({
    required String employeeId,
    required int dayOfWeek,
    required String startTime,
    required String endTime,
    String? salonId,
  }) async {
    await _client
        .from('work_schedules')
        .delete()
        .eq('employee_id', employeeId)
        .eq('day_of_week', dayOfWeek)
        .eq('is_recurring', true);

    final payload = {
      'employee_id': employeeId,
      'day_of_week': dayOfWeek,
      'start_time': _normalizeTime(startTime),
      'end_time': _normalizeTime(endTime),
      'is_recurring': true,
      if (salonId != null && salonId.isNotEmpty) 'salon_id': salonId,
    };

    try {
      await _client.from('work_schedules').insert(payload);
    } catch (_) {
      final fallback = Map<String, dynamic>.from(payload)..remove('salon_id');
      await _client.from('work_schedules').insert(fallback);
    }
  }

  Future<void> setSpecificScheduleAssignment({
    required String employeeId,
    required String salonId,
    required DateTime date,
    required String startTime,
    required String endTime,
  }) async {
    final dateKey = _toDateOnly(date);
    final dayOfWeek = date.weekday - 1;

    await _client
        .from('work_schedules')
        .delete()
        .eq('employee_id', employeeId)
        .eq('is_recurring', false)
        .eq('specific_date', dateKey);

    final payload = {
      'employee_id': employeeId,
      'salon_id': salonId,
      'day_of_week': dayOfWeek,
      'specific_date': dateKey,
      'start_time': _normalizeTime(startTime),
      'end_time': _normalizeTime(endTime),
      'is_recurring': false,
    };

    try {
      await _client.from('work_schedules').insert(payload);
    } catch (_) {
      final fallback = Map<String, dynamic>.from(payload)..remove('salon_id');
      await _client.from('work_schedules').insert(fallback);
    }
  }

  Future<ScheduleValidationResult> validateRecurringScheduleAssignment({
    required String salonId,
    required String employeeId,
    required int dayOfWeek,
    required String startTime,
    required String endTime,
  }) async {
    final blockingIssues = <String>[];
    final warnings = <String>[];

    if (dayOfWeek < 0 || dayOfWeek > 6) {
      blockingIssues.add('Ungültiger Wochentag.');
      return ScheduleValidationResult(
        canSave: false,
        blockingIssues: blockingIssues,
        warnings: warnings,
      );
    }

    final startMinutes = _parseMinutes(startTime);
    final endMinutes = _parseMinutes(endTime);

    if (startMinutes == null || endMinutes == null) {
      blockingIssues.add('Zeitformat ungültig. Bitte HH:mm verwenden.');
      return ScheduleValidationResult(
        canSave: false,
        blockingIssues: blockingIssues,
        warnings: warnings,
      );
    }

    if (endMinutes <= startMinutes) {
      blockingIssues.add('Endzeit muss nach Startzeit liegen.');
    }

    final openingHours = await getSalonOpeningHours(salonId);
    final dayKey = _dayKeyFromIndex(dayOfWeek);
    final dayHours = openingHours[dayKey];

    if (dayHours == null) {
      warnings.add('Keine Öffnungszeiten für den Tag gefunden.');
    } else {
      if (dayHours.closed) {
        blockingIssues.add('Der Salon ist an diesem Tag geschlossen.');
      } else {
        final openMinutes = _parseMinutes(dayHours.open);
        final closeMinutes = _parseMinutes(dayHours.close);

        if (openMinutes != null && closeMinutes != null) {
          if (startMinutes < openMinutes || endMinutes > closeMinutes) {
            blockingIssues.add(
              'Schicht liegt außerhalb der Öffnungszeiten (${dayHours.open} - ${dayHours.close}).',
            );
          }
        }
      }
    }

    final lookAheadStart = DateTime.now();
    final lookAheadEnd = lookAheadStart.add(const Duration(days: 120));

    final approvedAbsences = await getLeaveRequests(
      salonId: salonId,
      employeeId: employeeId,
      status: 'approved',
    );

    final absenceConflicts = approvedAbsences.where((request) {
      return _rangeContainsWeekday(
        start: request.startDate,
        end: request.endDate,
        targetDayOfWeek: dayOfWeek,
        minDate: lookAheadStart,
        maxDate: lookAheadEnd,
      );
    }).length;

    if (absenceConflicts > 0) {
      warnings.add(
        'Konflikt mit $absenceConflicts genehmigten Abwesenheit(en) in den nächsten 120 Tagen.',
      );
    }

    final closures = await getSalonClosures(salonId);
    final closureConflicts = closures.where((closure) {
      return _rangeContainsWeekday(
        start: closure.startDate,
        end: closure.endDate,
        targetDayOfWeek: dayOfWeek,
        minDate: lookAheadStart,
        maxDate: lookAheadEnd,
      );
    }).length;

    if (closureConflicts > 0) {
      warnings.add(
        'Konflikt mit $closureConflicts Schließzeit(en) in den nächsten 120 Tagen.',
      );
    }

    return ScheduleValidationResult(
      canSave: blockingIssues.isEmpty,
      blockingIssues: blockingIssues,
      warnings: warnings,
    );
  }

  Future<List<WorkforceLeaveRequest>> getLeaveRequests({
    required String salonId,
    String? employeeId,
    String? status,
  }) async {
    try {
      var query = _client
          .from('leave_requests')
          .select(
            'id, salon_id, employee_id, leave_type, start_date, end_date, status, reason, approved_by, created_at, updated_at, employees(display_name, salon_id)',
          )
          .eq('salon_id', salonId);

      if (employeeId != null && employeeId.isNotEmpty) {
        query = query.eq('employee_id', employeeId);
      }

      final normalizedStatus = _normalizeWorkforceLeaveStatus(status);
      if (status != null && status.isNotEmpty && normalizedStatus.isNotEmpty) {
        query = query.eq('status', normalizedStatus);
      }

      final data = await query.order('start_date', ascending: false);
      return (data as List)
          .whereType<Map<String, dynamic>>()
          .map(WorkforceLeaveRequest.fromJson)
          .toList();
    } catch (_) {
      try {
        var query = _client
            .from('leave_requests')
            .select(
              'id, employee_id, leave_type, start_date, end_date, status, reason, approved_by, created_at, updated_at, employees(display_name, salon_id)',
            );

        if (employeeId != null && employeeId.isNotEmpty) {
          query = query.eq('employee_id', employeeId);
        }

        final normalizedStatus = _normalizeWorkforceLeaveStatus(status);
        if (status != null && status.isNotEmpty && normalizedStatus.isNotEmpty) {
          query = query.eq('status', normalizedStatus);
        }

        final data = await query.order('start_date', ascending: false);
        final filtered = (data as List)
            .whereType<Map<String, dynamic>>()
            .where((row) {
              final employee = row['employees'];
              if (employee is Map<String, dynamic>) {
                final employeeSalonId = employee['salon_id']?.toString();
                if (employeeSalonId != null && employeeSalonId.isNotEmpty) {
                  return employeeSalonId == salonId;
                }
              }
              return true;
            })
            .toList();

        return filtered.map(WorkforceLeaveRequest.fromJson).toList();
      } catch (_) {
      var query = _client
          .from('leave_requests')
          .select(
            'id, employee_id, leave_type, start_date, end_date, status, reason, approved_by, created_at, updated_at',
          );

      if (employeeId != null && employeeId.isNotEmpty) {
        query = query.eq('employee_id', employeeId);
      }

      final normalizedStatus = _normalizeWorkforceLeaveStatus(status);
      if (status != null && status.isNotEmpty && normalizedStatus.isNotEmpty) {
        query = query.eq('status', normalizedStatus);
      }

      final data = await query.order('start_date', ascending: false);
      final rows = (data as List).whereType<Map<String, dynamic>>().toList();

      if (rows.isEmpty) {
        return const [];
      }

      final employeeIds = rows
          .map((row) => row['employee_id']?.toString())
          .whereType<String>()
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      Map<String, dynamic> employeesById = const {};
      if (employeeIds.isNotEmpty) {
        final employeeData = await _client
            .from('employees')
            .select('id, display_name, salon_id')
            .inFilter('id', employeeIds);

        employeesById = {
          for (final row in (employeeData as List).whereType<Map<String, dynamic>>())
            (row['id']?.toString() ?? ''): row,
        };
      }

      final filtered = rows.where((row) {
        final employeeIdValue = row['employee_id']?.toString();
        if (employeeIdValue == null || employeeIdValue.isEmpty) {
          return true;
        }
        final employee = employeesById[employeeIdValue];
        if (employee is Map<String, dynamic>) {
          final employeeSalonId = employee['salon_id']?.toString();
          if (employeeSalonId != null && employeeSalonId.isNotEmpty) {
            return employeeSalonId == salonId;
          }
        }
        return true;
      }).map((row) {
        final employeeIdValue = row['employee_id']?.toString();
        final employee = employeeIdValue == null ? null : employeesById[employeeIdValue];
        return {
          ...row,
          if (employee != null) 'employees': employee,
        };
      }).toList();

      return filtered.map(WorkforceLeaveRequest.fromJson).toList();
      }
    }
  }

  Future<void> submitLeaveRequest({
    required String salonId,
    required String employeeId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  }) async {
    if (endDate.isBefore(startDate)) {
      throw ArgumentError('End date must not be before start date');
    }

    final normalizedLeaveType = _normalizeWorkforceLeaveType(leaveType);

    try {
      await _client.from('leave_requests').insert({
        'salon_id': salonId,
        'employee_id': employeeId,
        'leave_type': normalizedLeaveType,
        'start_date': _toDateOnly(startDate),
        'end_date': _toDateOnly(endDate),
        'status': 'pending',
        'reason': reason,
      });
    } catch (_) {
      await _client.from('leave_requests').insert({
        'employee_id': employeeId,
        'leave_type': normalizedLeaveType,
        'start_date': _toDateOnly(startDate),
        'end_date': _toDateOnly(endDate),
        'status': 'pending',
        'reason': reason,
      });
    }
  }

  Future<void> decideLeaveRequest({
    required String requestId,
    required String status,
    String? approvedBy,
  }) async {
    final rawStatus = status.trim().toLowerCase();
    if (!_supportedLeaveStatuses.contains(rawStatus) && rawStatus != 'declined') {
      throw ArgumentError('Unsupported leave request status: $status');
    }
    final normalizedStatus = rawStatus == 'declined' ? 'rejected' : rawStatus;

    await _client.from('leave_requests').update({
      'status': normalizedStatus,
      if (approvedBy != null) 'approved_by': approvedBy,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', requestId);
  }

  Future<Map<String, int>> getEmployeeLeaveSummary({
    required String employeeId,
    required int year,
  }) async {
    final from = DateTime(year, 1, 1);
    final to = DateTime(year, 12, 31);

    final data = await _client
        .from('leave_requests')
        .select('leave_type, status, start_date, end_date')
        .eq('employee_id', employeeId)
      .lte('start_date', _toDateOnly(to))
      .gte('end_date', _toDateOnly(from));

    int approvedVacationDays = 0;
    int pendingVacationDays = 0;
    int sickDays = 0;

    for (final row in (data as List).whereType<Map<String, dynamic>>()) {
      final leaveType = _normalizeWorkforceLeaveType(row['leave_type']?.toString());
      final status = _normalizeWorkforceLeaveStatus(row['status']?.toString());
      final start = DateTime.tryParse(row['start_date'].toString());
      final end = DateTime.tryParse(row['end_date'].toString());
      if (start == null || end == null) continue;
      final days = _countOverlappingDays(
        start: start,
        end: end,
        rangeStart: from,
        rangeEnd: to,
      );
      if (days <= 0) {
        continue;
      }

      if (leaveType == 'sick' && status == 'approved') {
        sickDays += days;
      }

      if (leaveType == 'vacation') {
        if (status == 'approved') {
          approvedVacationDays += days;
        } else if (status == 'pending') {
          pendingVacationDays += days;
        }
      }
    }

    final trackedSickDays = await _getTrackedSickDays(
      employeeId: employeeId,
      from: from,
      to: to,
    );
    if (trackedSickDays > sickDays) {
      sickDays = trackedSickDays;
    }

    return {
      'approvedVacationDays': approvedVacationDays,
      'pendingVacationDays': pendingVacationDays,
      'requestedVacationDays': approvedVacationDays + pendingVacationDays,
      'openVacationDays': pendingVacationDays,
      'sickDays': sickDays,
    };
  }

  Future<int?> getEmployeeVacationAllowance(String employeeId) async {
    try {
      final row = await _client
          .from('employees')
          .select('vacation_days_per_year')
          .eq('id', employeeId)
          .limit(1)
          .maybeSingle();

      if (row == null) {
        return _defaultVacationAllowanceDays;
      }

      final value = row['vacation_days_per_year'];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      return _defaultVacationAllowanceDays;
    } catch (_) {
      return _defaultVacationAllowanceDays;
    }
  }

  Future<int> _getTrackedSickDays({
    required String employeeId,
    required DateTime from,
    required DateTime to,
  }) async {
    final fromIso = DateTime(from.year, from.month, from.day).toIso8601String();
    final toExclusiveIso = DateTime(to.year, to.month, to.day)
        .add(const Duration(days: 1))
        .toIso8601String();

    final sickDates = <String>{};

    try {
      final dashboardEntries = await _client
          .from('dashboard_time_entries')
          .select('timestamp')
          .eq('employee_id', employeeId)
          .eq('entry_type', 'sick')
          .gte('timestamp', fromIso)
          .lt('timestamp', toExclusiveIso);

      for (final row in (dashboardEntries as List).whereType<Map<String, dynamic>>()) {
        final timestamp = DateTime.tryParse(row['timestamp']?.toString() ?? '');
        if (timestamp == null) {
          continue;
        }
        sickDates.add(_toDateOnly(timestamp));
      }
    } catch (_) {}

    return sickDates.length;
  }

  Future<bool> isEmployeeBlocked({
    required String employeeId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final rangeStartDate = DateTime(startTime.year, startTime.month, startTime.day);
    final rangeEndDate = DateTime(endTime.year, endTime.month, endTime.day);

    final approvedLeave = await _client
        .from('leave_requests')
        .select('id')
        .eq('employee_id', employeeId)
        .eq('status', 'approved')
      .lte('start_date', _toDateOnly(rangeEndDate))
      .gte('end_date', _toDateOnly(rangeStartDate))
        .limit(1)
        .maybeSingle();

    if (approvedLeave != null) {
      return true;
    }

    final startOfRange = DateTime(
      rangeStartDate.year,
      rangeStartDate.month,
      rangeStartDate.day,
    );
    final endOfRangeExclusive = DateTime(
      rangeEndDate.year,
      rangeEndDate.month,
      rangeEndDate.day,
    ).add(const Duration(days: 1));

    try {
      final sickEntryDashboard = await _client
          .from('dashboard_time_entries')
          .select('id')
          .eq('employee_id', employeeId)
          .eq('entry_type', 'sick')
          .gte('timestamp', startOfRange.toIso8601String())
          .lt('timestamp', endOfRangeExclusive.toIso8601String())
          .limit(1)
          .maybeSingle();

      return sickEntryDashboard != null;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isSalonBlocked({
    required String salonId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final rangeStartDate = DateTime(startTime.year, startTime.month, startTime.day);
    final rangeEndDate = DateTime(endTime.year, endTime.month, endTime.day);

    final closure = await _client
        .from('salon_closures')
        .select('id')
        .eq('salon_id', salonId)
        .lte('start_date', _toDateOnly(rangeEndDate))
        .gte('end_date', _toDateOnly(rangeStartDate))
        .limit(1)
        .maybeSingle();

    if (closure != null) {
      return true;
    }

    if (rangeStartDate != rangeEndDate) {
      return true;
    }

    final dayKey = _dayKeyFromIndex(startTime.weekday - 1);
    final openingHours = await getSalonOpeningHours(salonId);
    final dayHours = openingHours[dayKey];

    if (dayHours == null || dayHours.closed) {
      return true;
    }

    final openMinutes = _parseMinutes(dayHours.open);
    final closeMinutes = _parseMinutes(dayHours.close);
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    if (openMinutes == null || closeMinutes == null) {
      return true;
    }

    return startMinutes < openMinutes || endMinutes > closeMinutes;
  }

  Future<List<String>> getBookingBlockReasons({
    required String salonId,
    required DateTime startTime,
    required DateTime endTime,
    String? employeeId,
  }) async {
    final reasons = <String>[];

    if (!endTime.isAfter(startTime)) {
      reasons.add('Ungültige Zeitspanne: Endzeit muss nach der Startzeit liegen.');
      return reasons;
    }

    final rangeStartDate = DateTime(startTime.year, startTime.month, startTime.day);
    final rangeEndDate = DateTime(endTime.year, endTime.month, endTime.day);

    if (rangeStartDate != rangeEndDate) {
      reasons.add('Termine über Mitternacht sind nicht buchbar.');
      return reasons;
    }

    final closure = await _client
        .from('salon_closures')
        .select('start_date, end_date, reason')
        .eq('salon_id', salonId)
        .lte('start_date', _toDateOnly(rangeEndDate))
        .gte('end_date', _toDateOnly(rangeStartDate))
        .order('start_date', ascending: true)
        .limit(1)
        .maybeSingle();

    if (closure != null) {
      final closureReason = closure['reason']?.toString().trim();
      reasons.add(
        closureReason == null || closureReason.isEmpty
            ? 'Salon ist am gewählten Datum geschlossen.'
            : 'Salon ist geschlossen: $closureReason',
      );
      return reasons;
    }

    final dayKey = _dayKeyFromIndex(startTime.weekday - 1);
    final openingHours = await getSalonOpeningHours(salonId);
    final dayHours = openingHours[dayKey];
    if (dayHours == null || dayHours.closed) {
      reasons.add('Salon ist an diesem Tag geschlossen.');
      return reasons;
    }

    final openMinutes = _parseMinutes(dayHours.open);
    final closeMinutes = _parseMinutes(dayHours.close);
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    if (openMinutes == null || closeMinutes == null) {
      reasons.add('Öffnungszeiten sind nicht korrekt hinterlegt.');
      return reasons;
    }

    if (startMinutes < openMinutes || endMinutes > closeMinutes) {
      reasons.add(
        'Termin liegt außerhalb der Öffnungszeiten (${dayHours.open} - ${dayHours.close}).',
      );
      return reasons;
    }

    if (employeeId == null || employeeId.trim().isEmpty) {
      return reasons;
    }

    final normalizedEmployeeId = employeeId.trim();
    final approvedLeave = await _client
        .from('leave_requests')
        .select('leave_type, start_date, end_date')
        .eq('employee_id', normalizedEmployeeId)
        .eq('status', 'approved')
        .lte('start_date', _toDateOnly(rangeEndDate))
        .gte('end_date', _toDateOnly(rangeStartDate))
        .limit(1)
        .maybeSingle();

    if (approvedLeave != null) {
      final leaveType = _normalizeWorkforceLeaveType(
        approvedLeave['leave_type']?.toString(),
      );
      final label = switch (leaveType) {
        'sick' => 'Krankmeldung',
        'vacation' => 'genehmigter Urlaub',
        _ => 'genehmigte Abwesenheit',
      };
      reasons.add('Mitarbeiter blockiert durch $label.');
      return reasons;
    }

    final startOfRange = DateTime(
      rangeStartDate.year,
      rangeStartDate.month,
      rangeStartDate.day,
    );
    final endOfRangeExclusive = DateTime(
      rangeEndDate.year,
      rangeEndDate.month,
      rangeEndDate.day,
    ).add(const Duration(days: 1));

    try {
      final sickEntryDashboard = await _client
          .from('dashboard_time_entries')
          .select('id')
          .eq('employee_id', normalizedEmployeeId)
          .eq('entry_type', 'sick')
          .gte('timestamp', startOfRange.toIso8601String())
          .lt('timestamp', endOfRangeExclusive.toIso8601String())
          .limit(1)
          .maybeSingle();

      if (sickEntryDashboard != null) {
        reasons.add('Mitarbeiter ist für den Tag krankgemeldet.');
        return reasons;
      }
    } catch (_) {}

    final dayOfWeek = startTime.weekday - 1;
    final dateKey = _toDateOnly(rangeStartDate);

    final recurringSchedulesData = await _client
        .from('work_schedules')
        .select('day_of_week, start_time, end_time, is_recurring, specific_date')
        .eq('employee_id', normalizedEmployeeId)
        .eq('is_recurring', true)
        .eq('day_of_week', dayOfWeek);

    final specificSchedulesData = await _client
        .from('work_schedules')
        .select('day_of_week, start_time, end_time, is_recurring, specific_date')
        .eq('employee_id', normalizedEmployeeId)
        .eq('is_recurring', false)
        .eq('specific_date', dateKey);

    final schedules = <Map<String, dynamic>>[
      ...(recurringSchedulesData as List).whereType<Map<String, dynamic>>(),
      ...(specificSchedulesData as List).whereType<Map<String, dynamic>>(),
    ];
    if (schedules.isEmpty) {
      reasons.add('Keine geplante Schicht für diesen Mitarbeiter am gewählten Tag.');
      return reasons;
    }

    final isWithinShift = schedules.any((schedule) {
      final shiftStart = _parseMinutes(schedule['start_time']?.toString() ?? '');
      final shiftEnd = _parseMinutes(schedule['end_time']?.toString() ?? '');
      if (shiftStart == null || shiftEnd == null) {
        return false;
      }
      return startMinutes >= shiftStart && endMinutes <= shiftEnd;
    });

    if (!isWithinShift) {
      reasons.add('Termin liegt außerhalb der geplanten Mitarbeiterschicht.');
    }

    return reasons;
  }

  String _toDateOnly(DateTime value) {
    final v = value.toLocal();
    return '${v.year.toString().padLeft(4, '0')}-${v.month.toString().padLeft(2, '0')}-${v.day.toString().padLeft(2, '0')}';
  }

  String _normalizeTime(String value) {
    final raw = value.trim();
    if (raw.isEmpty) return '09:00:00';
    if (raw.length == 5) return '$raw:00';
    return raw;
  }

  String _normalizeHourField(String value) {
    final raw = value.trim();
    if (raw.isEmpty) return '09:00';
    if (raw.length >= 5) {
      return raw.substring(0, 5);
    }
    return raw;
  }

  static int _countOverlappingDays({
    required DateTime start,
    required DateTime end,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) {
    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(end.year, end.month, end.day);
    final normalizedRangeStart = DateTime(
      rangeStart.year,
      rangeStart.month,
      rangeStart.day,
    );
    final normalizedRangeEnd = DateTime(rangeEnd.year, rangeEnd.month, rangeEnd.day);

    if (normalizedEnd.isBefore(normalizedStart)) {
      return 0;
    }

    final overlapStart = normalizedStart.isAfter(normalizedRangeStart)
        ? normalizedStart
        : normalizedRangeStart;
    final overlapEnd = normalizedEnd.isBefore(normalizedRangeEnd)
        ? normalizedEnd
        : normalizedRangeEnd;

    if (overlapEnd.isBefore(overlapStart)) {
      return 0;
    }

    return overlapEnd.difference(overlapStart).inDays + 1;
  }

  static int? _parseMinutes(String value) {
    final normalized = value.trim();
    final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(normalized);
    if (match == null) {
      return null;
    }

    final hour = int.tryParse(match.group(1)!);
    final minute = int.tryParse(match.group(2)!);
    if (hour == null || minute == null) {
      return null;
    }

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return hour * 60 + minute;
  }

  static String _dayKeyFromIndex(int dayOfWeek) {
    switch (dayOfWeek) {
      case 0:
        return 'monday';
      case 1:
        return 'tuesday';
      case 2:
        return 'wednesday';
      case 3:
        return 'thursday';
      case 4:
        return 'friday';
      case 5:
        return 'saturday';
      case 6:
        return 'sunday';
      default:
        return 'monday';
    }
  }

  static bool _rangeContainsWeekday({
    required DateTime start,
    required DateTime end,
    required int targetDayOfWeek,
    required DateTime minDate,
    required DateTime maxDate,
  }) {
    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(end.year, end.month, end.day);
    final normalizedMin = DateTime(minDate.year, minDate.month, minDate.day);
    final normalizedMax = DateTime(maxDate.year, maxDate.month, maxDate.day);

    final overlapStart = normalizedStart.isAfter(normalizedMin)
        ? normalizedStart
        : normalizedMin;
    final overlapEnd = normalizedEnd.isBefore(normalizedMax)
        ? normalizedEnd
        : normalizedMax;

    if (overlapEnd.isBefore(overlapStart)) {
      return false;
    }

    var cursor = overlapStart;
    while (!cursor.isAfter(overlapEnd)) {
      if (cursor.weekday - 1 == targetDayOfWeek) {
        return true;
      }
      cursor = cursor.add(const Duration(days: 1));
    }

    return false;
  }
}
