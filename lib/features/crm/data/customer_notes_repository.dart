import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerNote {
  final String id;
  final String salonId;
  final String customerId;
  final String createdBy;
  final String note;
  final DateTime createdAt;

  CustomerNote({
    required this.id,
    required this.salonId,
    required this.customerId,
    required this.createdBy,
    required this.note,
    required this.createdAt,
  });

  factory CustomerNote.fromJson(Map<String, dynamic> json) {
    return CustomerNote(
      id: json['id'] as String,
      salonId: json['salon_id'] as String,
      customerId: json['customer_id'] as String,
      createdBy: json['created_by'] as String,
      note: json['note'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class CustomerNotesRepository {
  final SupabaseClient _client;
  CustomerNotesRepository(this._client);

  Future<List<CustomerNote>> getCustomerNotes(String customerId, String salonId) async {
    final data = await _client
        .from('customer_notes')
        .select()
        .eq('customer_id', customerId)
        .eq('salon_id', salonId)
        .order('created_at', ascending: false);
    return (data as List).map((e) => CustomerNote.fromJson(e)).toList();
  }

  Future<void> addNote({
    required String salonId,
    required String customerId,
    required String createdBy,
    required String note,
  }) async {
    await _client.from('customer_notes').insert({
      'salon_id': salonId,
      'customer_id': customerId,
      'created_by': createdBy,
      'note': note,
    });
  }
}
