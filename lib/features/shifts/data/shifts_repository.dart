import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/shift.dart';

class ShiftsRepository {
  ShiftsRepository(this._client);

  final SupabaseClient _client;

  Future<List<Shift>> listShiftsForStaff({
    required String salonId,
    required String staffId,
    required DateTime from,
    required DateTime to,
  }) async {
    final rows = await _client
        .from('shifts')
        .select()
        .eq('salon_id', salonId)
        .eq('staff_id', staffId)
        .gte('start_at', from.toIso8601String())
        .lte('start_at', to.toIso8601String())
        .order('start_at', ascending: true);

    return (rows as List<dynamic>)
        .map((row) => Shift.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<Shift> upsertShift({
    String? id,
    required String salonId,
    required String staffId,
    required DateTime startAt,
    required DateTime endAt,
    String type = 'work',
    String? note,
  }) async {
    final payload = {
      if (id != null) 'id': id,
      'salon_id': salonId,
      'staff_id': staffId,
      'start_at': startAt.toIso8601String(),
      'end_at': endAt.toIso8601String(),
      'type': type,
      'note': note,
    };

    final row = await _client
        .from('shifts')
        .upsert(payload)
        .select()
        .single();

    return Shift.fromJson(row);
  }
}
