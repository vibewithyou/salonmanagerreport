import '../../../services/supabase_service.dart';
import '../domain/customer_note.dart';

class CustomerNotesRepository {
  final SupabaseService _supabaseService;

  CustomerNotesRepository(this._supabaseService);

  Future<List<CustomerNote>> getNotes(String customerId) async {
    final response = await _supabaseService.client
        .from('customer_notes')
        .select()
        .eq('customer_id', customerId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => CustomerNote.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> addNote({
    required String customerId,
    required String salonId,
    required String note,
  }) async {
    final userId = _supabaseService.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _supabaseService.client.from('customer_notes').insert({
      'salon_id': salonId,
      'customer_id': customerId,
      'created_by': userId,
      'note': note.trim(),
    });
  }

  Future<void> deleteNote(String noteId) async {
    await _supabaseService.client
        .from('customer_notes')
        .delete()
        .eq('id', noteId);
  }
}
