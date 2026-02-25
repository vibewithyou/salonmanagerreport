import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/leave_request_model.dart';

class LeaveRequestService {
  LeaveRequestService(this._supabase);

  final SupabaseClient _supabase;

  Future<List<LeaveRequest>> getMyRequests() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      return [];
    }

    try {
      final response = await _supabase
          .from('leave_requests')
          .select()
          .eq('employee_id', user.id)
          .order('created_at', ascending: false);

        return response
          .whereType<Map<String, dynamic>>()
          .map(_mapLeaveRequest)
          .toList();
    } catch (_) {
      // Ignore and fall back to empty list.
    }

    return [];
  }

  Future<void> submitLeaveRequest({
    required LeaveType type,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Not signed in');
    }

    await _supabase.from('leave_requests').insert({
      'employee_id': user.id,
      'type': type.name,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'reason': reason ?? '',
      'status': LeaveStatus.pending.name,
    });
  }

  LeaveRequest _mapLeaveRequest(Map<String, dynamic> data) {
    return LeaveRequest(
      id: data['id']?.toString() ?? '',
      employeeId: data['employee_id']?.toString() ?? '',
      employeeName: data['employee_name']?.toString() ?? '',
      type: _parseLeaveType(data['type']?.toString()),
      startDate: _parseDate(data['start_date']) ?? DateTime.now(),
      endDate: _parseDate(data['end_date']) ?? DateTime.now(),
      reason: data['reason']?.toString() ?? '',
      status: _parseLeaveStatus(data['status']?.toString()),
      adminNotes: data['admin_notes']?.toString(),
      createdAt: _parseDate(data['created_at']),
      updatedAt: _parseDate(data['updated_at']),
    );
  }

  LeaveType _parseLeaveType(String? value) {
    switch (value) {
      case 'vacation':
        return LeaveType.vacation;
      case 'sick':
        return LeaveType.sick;
      case 'personal':
        return LeaveType.personal;
      case 'other':
        return LeaveType.other;
      default:
        return LeaveType.vacation;
    }
  }

  LeaveStatus _parseLeaveStatus(String? value) {
    switch (value) {
      case 'approved':
        return LeaveStatus.approved;
      case 'rejected':
        return LeaveStatus.rejected;
      case 'pending':
      default:
        return LeaveStatus.pending;
    }
  }

  DateTime? _parseDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
