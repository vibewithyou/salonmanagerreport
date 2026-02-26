import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsRepository {
  final SupabaseClient _client;

  NotificationsRepository(this._client);

  Future<List<Map<String, dynamic>>> listNotifications(String userId) async {
    final response = await _client
        .from('notifications')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .execute();
    return List<Map<String, dynamic>>.from(response.data ?? []);
  }

  Future<int> unreadCount(String userId) async {
    final response = await _client
        .from('notifications')
        .select('id')
        .eq('user_id', userId)
        .is('read_at', null)
        .execute();
    return (response.data as List).length;
  }

  Future<void> markRead(String id) async {
    await _client
        .from('notifications')
        .update({'read_at': DateTime.now().toIso8601String()})
        .eq('id', id)
        .execute();
  }
}
