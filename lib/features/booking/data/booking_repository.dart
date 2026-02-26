import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final supabase = Supabase.instance.client;
  return BookingRepository(supabase);
});

class BookingRepository {
  final SupabaseClient _client;
  BookingRepository(this._client);

  Future<void> updateBookingStatus(String id, String status) async {
    try {
      await _client
          .from('bookings')
          .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }
}
