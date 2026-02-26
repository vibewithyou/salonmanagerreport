import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/customer_notes_repository.dart';

final customerNotesProvider = FutureProvider.family<List<CustomerNote>, Map<String, String>>((ref, params) async {
  final repo = ref.watch(customerNotesRepositoryProvider);
  return repo.getCustomerNotes(params['customerId']!, params['salonId']!);
});

final addCustomerNoteProvider = FutureProvider.family<void, Map<String, String>>((ref, params) async {
  final repo = ref.watch(customerNotesRepositoryProvider);
  await repo.addNote(
    salonId: params['salonId']!,
    customerId: params['customerId']!,
    createdBy: params['createdBy']!,
    note: params['note']!,
  );
});
