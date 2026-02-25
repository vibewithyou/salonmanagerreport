import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/inventory_model.dart';
import '../services/supabase_service.dart';

final inventorySupabaseServiceProvider = Provider<SupabaseService>((ref) => SupabaseService());

final inventoryItemsProvider = FutureProvider<List<InventoryItem>>((ref) async {
  final supabaseService = ref.watch(inventorySupabaseServiceProvider);
  try {
    final user = supabaseService.currentUser;
    if (user == null) return [];
    final salonResponse = await supabaseService.client.from('salons').select('id').eq('owner_id', user.id).single();
    final salonId = salonResponse['id'];
    final response = await supabaseService.client.from('inventory').select().eq('salon_id', salonId).order('name', ascending: true);
    return (response as List).map((item) {
      final map = item as Map<String, dynamic>;
      return InventoryItem.fromJson({
        'id': map['id'],
        'salonId': map['salon_id'],
        'name': map['name'] ?? '',
        'quantity': (map['quantity'] as num?)?.toInt() ?? 0,
        'price': (map['price'] as num?)?.toDouble() ?? 0.0,
        'category': map['description'],
        'lowStockThreshold': (map['min_quantity'] as num?)?.toInt(),
        'createdAt': map['created_at'],
      });
    }).toList();
  } catch (e) {
    return [];
  }
});

final lowStockItemsProvider = FutureProvider<List<InventoryItem>>((ref) async {
  final items = await ref.watch(inventoryItemsProvider.future);
  return items.where((item) => item.quantity <= (item.lowStockThreshold ?? 10)).toList();
});

final inventoryNotifierProvider = StateNotifierProvider<InventoryNotifier, AsyncValue<void>>((ref) {
  return InventoryNotifier(ref.watch(inventorySupabaseServiceProvider), ref);
});

class InventoryNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseService _supabaseService;
  final Ref _ref;
  InventoryNotifier(this._supabaseService, this._ref) : super(const AsyncValue.data(null));

  Future<void> createItem(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final user = _supabaseService.currentUser;
      if (user == null) throw Exception('User not authenticated');
      final salonResponse = await _supabaseService.client.from('salons').select('id').eq('owner_id', user.id).single();
      data['salon_id'] = salonResponse['id'];
      data['created_at'] = DateTime.now().toIso8601String();
      await _supabaseService.client.from('inventory').insert([
        {
          'salon_id': data['salon_id'],
          'name': data['name'] ?? data['product_name'] ?? '',
          'description': data['description'],
          'quantity': data['quantity'] ?? 0,
          'min_quantity': data['min_quantity'] ?? data['low_stock_threshold'] ?? 5,
          'price': data['price'] ?? data['unit_price'],
          'unit': data['unit'] ?? 'Stück',
          'expiry_date': data['expiry_date'],
          'supplier_id': data['supplier_id'],
          'created_at': data['created_at'],
        },
      ]);
      state = const AsyncValue.data(null);
      _ref.invalidate(inventoryItemsProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateStock(String itemId, int newQuantity) async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.client.from('inventory').update({
        'quantity': newQuantity,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', itemId);
      state = const AsyncValue.data(null);
      _ref.invalidate(inventoryItemsProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
