import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerProfilesRepository {
  final SupabaseClient _client;

  CustomerProfilesRepository(this._client);

  Future<List<Map<String, dynamic>>> listCustomers(String salonId, {String? search}) async {
    final query = _client
        .from('customer_profiles')
        .select()
        .eq('salon_id', salonId);
    if (search != null && search.isNotEmpty) {
      query.ilike('phone', '%$search%');
    }
    final response = await query.execute();
    return response.data as List<Map<String, dynamic>>;
  }

  Future<Map<String, dynamic>?> getCustomerDetail(String salonId, String customerId) async {
    final response = await _client
        .from('customer_profiles')
        .select()
        .eq('salon_id', salonId)
        .eq('customer_id', customerId)
        .single()
        .execute();
    return response.data as Map<String, dynamic>?;
  }

  Future<List<Map<String, dynamic>>> listCustomerBookings(String salonId, String customerId) async {
    final response = await _client
        .from('bookings')
        .select()
        .eq('salon_id', salonId)
        .eq('customer_id', customerId)
        .order('created_at', ascending: false)
        .execute();
    return response.data as List<Map<String, dynamic>>;
  }
}
