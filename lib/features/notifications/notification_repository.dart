import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRepository {
  final SupabaseClient client;
  NotificationRepository(this.client);

  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    final response = await client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .execute();
    if (response.error != null) throw response.error!;
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<void> markAsRead(int id) async {
    final response = await client
        .from('notifications')
        .update({'read_at': DateTime.now().toIso8601String()})
        .eq('id', id)
        .execute();
    if (response.error != null) throw response.error!;
  }
}
