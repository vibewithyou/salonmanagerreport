import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/time_entry_model.dart';

class TimeTrackingService {
  TimeTrackingService(this._supabase);

  final SupabaseClient _supabase;

  Future<TimeEntryStatus> getStatus() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      return const TimeEntryStatus(isCheckedIn: false);
    }

    try {
      final response = await _supabase
          .from('time_entries')
          .select()
          .eq('employee_id', user.id)
          .order('check_in_time', ascending: false)
          .limit(1);

      if (response.isNotEmpty) {
        final data = response.first;
        final isCheckedIn = data['check_out_time'] == null;
        final todayMinutes = data['total_minutes'] as int?;

        return TimeEntryStatus(
          isCheckedIn: isCheckedIn,
          currentEntry: null,
          todayMinutes: todayMinutes,
          weekMinutes: null,
        );
      }
    } catch (_) {
      // Ignore and fall back to default status.
    }

    return const TimeEntryStatus(isCheckedIn: false);
  }

  Future<void> checkIn() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Not signed in');
    }

    await _supabase.from('time_entries').insert({
      'employee_id': user.id,
      'check_in_time': DateTime.now().toIso8601String(),
    });
  }

  Future<void> checkOut() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Not signed in');
    }

    await _supabase
        .from('time_entries')
        .update({'check_out_time': DateTime.now().toIso8601String()})
        .eq('employee_id', user.id)
        .isFilter('check_out_time', null);
  }
}
