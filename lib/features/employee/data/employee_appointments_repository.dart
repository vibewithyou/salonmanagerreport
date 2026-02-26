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
        .select('*, customer_profiles:customer_id(id, first_name, last_name, phone, email), booking_media(id, url, type), booking_items(service_name)')
        .eq('salon_id', salonId)
        .or('stylist_id.eq.$staffUserId,staff_id.eq.$staffUserId')
        .order('start_at', ascending: true);

    return (rows as List<dynamic>).map((row) {
      final customer = row['customer_profiles'] as Map<String, dynamic>?;
      final customerName = customer != null
          ? '${customer['first_name'] ?? ''} ${customer['last_name'] ?? ''}'.trim()
          : 'Kunde';
      final customerPhone = customer?['phone'] as String?;
      final customerEmail = customer?['email'] as String?;

      final media = row['booking_media'] as List<dynamic>?;
      final referenceImages = media != null
          ? media.where((m) => m['type'] == 'reference').map((m) => m['url'] as String).toList()
          : [];

      final services = row['booking_items'] as List<dynamic>?;
      final serviceNames = services != null
          ? services.map((s) => s['service_name'] as String).toList()
          : [];

      return EmployeeAppointment(
        id: row['id'] as String,
        salonId: row['salon_id'] as String,
        startAt: DateTime.parse((row['start_at'] ?? row['start_time']).toString()),
        endAt: DateTime.parse((row['end_at'] ?? row['end_time']).toString()),
        status: (row['status'] as String?) ?? 'pending',
        customerName: customerName,
        customerPhone: customerPhone,
        customerEmail: customerEmail,
        serviceName: serviceNames.isNotEmpty ? serviceNames.join(', ') : (row['service_name'] as String? ?? 'Service'),
        price: row['price'] as num?,
        notes: row['notes'] as String?,
        referenceImages: referenceImages,
        services: serviceNames,
      );
    }).toList();
  }
}
