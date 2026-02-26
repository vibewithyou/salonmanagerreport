import 'package:supabase_flutter/supabase_flutter.dart';
import 'customer_notes_repository.dart';

class CrmRepository {
  final SupabaseClient client;
  final CustomerNotesRepository notesRepository;

  CrmRepository(this.client)
      : notesRepository = CustomerNotesRepository(client);

  Future<List<CustomerNote>> getCustomerNotes(String customerId, String salonId) {
    return notesRepository.getCustomerNotes(customerId, salonId);
  }

  Future<void> addNote({
    required String salonId,
    required String customerId,
    required String createdBy,
    required String note,
  }) {
    return notesRepository.addNote(
      salonId: salonId,
      customerId: customerId,
      createdBy: createdBy,
      note: note,
    );
  }

  // TODO: Implement getCustomerBookings
}
