import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/customer_provider.dart';
import '../data/customer_notes_repository.dart';
import '../domain/customer_note.dart';

final customerNotesRepositoryProvider = Provider<CustomerNotesRepository>((ref) {
  final supabaseService = ref.watch(customerSupabaseServiceProvider);
  return CustomerNotesRepository(supabaseService);
});

final customerNotesProvider = FutureProvider.family<List<CustomerNote>, String>((ref, customerId) {
  final repository = ref.watch(customerNotesRepositoryProvider);
  return repository.getNotes(customerId);
});

final customerNotesNotifierProvider =
    StateNotifierProvider<CustomerNotesNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(customerNotesRepositoryProvider);
  return CustomerNotesNotifier(repository, ref);
});

class CustomerNotesNotifier extends StateNotifier<AsyncValue<void>> {
  final CustomerNotesRepository _repository;
  final Ref _ref;

  CustomerNotesNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> addNote({
    required String customerId,
    required String salonId,
    required String note,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addNote(
        customerId: customerId,
        salonId: salonId,
        note: note,
      );
      _ref.invalidate(customerNotesProvider(customerId));
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteNote({
    required String customerId,
    required String noteId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteNote(noteId);
      _ref.invalidate(customerNotesProvider(customerId));
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
