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
}
