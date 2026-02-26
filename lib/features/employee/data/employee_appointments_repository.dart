import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/employee_appointment.dart';

class EmployeeAppointmentsRepository {
  EmployeeAppointmentsRepository(this._client);

  final SupabaseClient _client;

  Future<List<EmployeeAppointment>> listForStaff({
    required String salonId,
    required String staffUserId,
  }) async {
    final rows = await _client
        .from('bookings')
        .select('*')
        .eq('salon_id', salonId)
        .or('stylist_id.eq.$staffUserId,staff_id.eq.$staffUserId')
        .order('start_at', ascending: true);

    return (rows as List<dynamic>)
        .map((row) => EmployeeAppointment.fromJson(row as Map<String, dynamic>))
        .toList();
  }
}
