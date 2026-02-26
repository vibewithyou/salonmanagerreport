import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRepository {
  final SupabaseClient _client;
  NotificationRepository(this._client);

  Future<void> createNotification({
    required String bookingId,
    required String userId,
    required String type,
    required String message,
  }) async {
    await _client.from('notifications').insert({
      'booking_id': bookingId,
      'user_id': userId,
      'type': type,
      'message': message,
    });
  }
}
