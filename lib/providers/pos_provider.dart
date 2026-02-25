import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pos_model.dart';
import '../services/supabase_service.dart';

final posSupabaseServiceProvider = Provider<SupabaseService>((ref) => SupabaseService());

final posTransactionsProvider = FutureProvider<List<POSTransaction>>((ref) async {
  final supabaseService = ref.watch(posSupabaseServiceProvider);
  try {
    final user = supabaseService.currentUser;
    if (user == null) return [];
    final salonResponse = await supabaseService.client.from('salons').select('id').eq('owner_id', user.id).single();
    final salonId = salonResponse['id'];
    final response = await supabaseService.client.from('pos_transactions').select().eq('salon_id', salonId).order('created_at', ascending: false).limit(50);
    return (response as List).map((e) => POSTransaction.fromJson(e)).toList();
  } catch (e) {
    return [];
  }
});

final posNotifierProvider = StateNotifierProvider<POSNotifier, AsyncValue<void>>((ref) {
  return POSNotifier(ref.watch(posSupabaseServiceProvider), ref);
});

class POSNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseService _supabaseService;
  final Ref _ref;
  POSNotifier(this._supabaseService, this._ref) : super(const AsyncValue.data(null));

  Future<void> createTransaction(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final user = _supabaseService.currentUser;
      if (user == null) throw Exception('User not authenticated');
      final salonResponse = await _supabaseService.client.from('salons').select('id').eq('owner_id', user.id).single();
      data['salon_id'] = salonResponse['id'];
      data['status'] = 'completed';
      data['created_at'] = DateTime.now().toIso8601String();
      await _supabaseService.client.from('pos_transactions').insert([data]);
      state = const AsyncValue.data(null);
      _ref.invalidate(posTransactionsProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
