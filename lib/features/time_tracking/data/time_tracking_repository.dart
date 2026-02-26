import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/time_entry.dart';

class TimeTrackingRepository {
  TimeTrackingRepository(this._client);

  final SupabaseClient _client;

  Future<TimeEntry> startShift({
    required String salonId,
    required String staffId,
  }) async {
    final existingOpen = await _client
        .from('time_entries')
        .select('id')
        .eq('salon_id', salonId)
        .eq('staff_id', staffId)
        .isFilter('clock_out', null)
        .order('clock_in', ascending: false)
        .limit(1)
        .maybeSingle();

    if (existingOpen != null) {
      throw StateError('Es existiert bereits eine offene Schicht.');
    }

    final created = await _client
        .from('time_entries')
        .insert({
          'salon_id': salonId,
          'staff_id': staffId,
        })
        .select()
        .single();

    return TimeEntry.fromJson(created);
  }

  Future<TimeEntry> stopShift({required String entryId}) async {
    final updated = await _client
        .from('time_entries')
        .update({'clock_out': DateTime.now().toIso8601String()})
        .eq('id', entryId)
        .select()
        .single();

    return TimeEntry.fromJson(updated);
  }

  Future<List<TimeEntry>> listForStaff({
    required String salonId,
    required String staffId,
    DateTime? from,
    DateTime? to,
  }) async {
    var query = _client
        .from('time_entries')
        .select()
        .eq('salon_id', salonId)
        .eq('staff_id', staffId);

    if (from != null) {
      query = query.gte('clock_in', from.toIso8601String());
    }

    if (to != null) {
      query = query.lte('clock_in', to.toIso8601String());
    }

    final rows = await query.order('clock_in', ascending: false);

    return (rows as List<dynamic>)
        .map((row) => TimeEntry.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Stream<List<TimeEntry>> watchOpenEntry({
    required String salonId,
    required String staffId,
  }) {
    return _client
        .from('time_entries')
        .stream(primaryKey: ['id'])
        .eq('salon_id', salonId)
        .eq('staff_id', staffId)
        .map(
          (rows) => rows
              .where((row) => row['clock_out'] == null)
              .map((row) => TimeEntry.fromJson(row))
              .toList()
            ..sort((a, b) => b.clockIn.compareTo(a.clockIn)),
        );
  }
}
