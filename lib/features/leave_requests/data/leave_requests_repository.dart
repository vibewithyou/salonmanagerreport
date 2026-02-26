import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/leave_request.dart';

class LeaveRequestsRepository {
  LeaveRequestsRepository(this._client);

  final SupabaseClient _client;

  Future<List<LeaveRequest>> listMine({
    required String salonId,
    required String staffId,
  }) async {
    final rows = await _client
        .from('leave_requests')
        .select()
        .eq('salon_id', salonId)
        .eq('staff_id', staffId)
        .order('start_at', ascending: false);

    return (rows as List<dynamic>)
        .map((row) => LeaveRequest.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<LeaveRequest> createRequest({
    required String salonId,
    required String staffId,
    required String type,
    required DateTime startAt,
    required DateTime endAt,
    String? reason,
  }) async {
    final created = await _client
        .from('leave_requests')
        .insert({
          'salon_id': salonId,
          'staff_id': staffId,
          'type': type,
          'start_at': '${startAt.year.toString().padLeft(4, '0')}-${startAt.month.toString().padLeft(2, '0')}-${startAt.day.toString().padLeft(2, '0')}',
          'end_at': '${endAt.year.toString().padLeft(4, '0')}-${endAt.month.toString().padLeft(2, '0')}-${endAt.day.toString().padLeft(2, '0')}',
          'reason': reason,
        })
        .select()
        .single();

    return LeaveRequest.fromJson(created);
  }
  /// Update status of a leave request (manager/owner)
  Future<void> updateStatus(String id, String status, {String? comment}) async {
    await _client.from('leave_requests').update({
      'status': status,
      'decided_by': _client.auth.currentUser?.id,
      'decided_at': DateTime.now().toUtc().toIso8601String(),
      if (comment != null) 'manager_comment': comment,
    }).eq('id', id);
  }

  /// List all pending leave requests for a salon (manager/owner)
  Future<List<LeaveRequest>> listPendingForSalon(String salonId) async {
    final rows = await _client
        .from('leave_requests')
        .select()
        .eq('salon_id', salonId)
        .eq('status', 'pending')
        .order('start_at', ascending: false);
    return (rows as List<dynamic>)
        .map((row) => LeaveRequest.fromJson(row as Map<String, dynamic>))
        .toList();
  }
}
