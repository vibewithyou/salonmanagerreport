import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/coupon_model.dart';
import '../services/supabase_service.dart';

final couponSupabaseServiceProvider = Provider<SupabaseService>((ref) => SupabaseService());

final couponsProvider = FutureProvider<List<Coupon>>((ref) async {
  final supabaseService = ref.watch(couponSupabaseServiceProvider);
  try {
    final user = supabaseService.currentUser;
    if (user == null) return [];
    final salonResponse = await supabaseService.client.from('salons').select('id').eq('owner_id', user.id).single();
    final salonId = salonResponse['id'];
    final response = await supabaseService.client.from('coupons').select().eq('salon_id', salonId).order('created_at', ascending: false);
    return (response as List).map((e) => Coupon.fromJson(e)).toList();
  } catch (e) {
    return [];
  }
});

final couponNotifierProvider = StateNotifierProvider<CouponNotifier, AsyncValue<void>>((ref) {
  return CouponNotifier(ref.watch(couponSupabaseServiceProvider), ref);
});

class CouponNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseService _supabaseService;
  final Ref _ref;
  CouponNotifier(this._supabaseService, this._ref) : super(const AsyncValue.data(null));

  Future<void> createCoupon(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final user = _supabaseService.currentUser;
      if (user == null) throw Exception('User not authenticated');
      final salonResponse = await _supabaseService.client.from('salons').select('id').eq('owner_id', user.id).single();
      data['salon_id'] = salonResponse['id'];
      data['used_count'] = 0;
      data['is_active'] = true;
      data['created_at'] = DateTime.now().toIso8601String();
      await _supabaseService.client.from('coupons').insert([data]);
      state = const AsyncValue.data(null);
      _ref.invalidate(couponsProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteCoupon(String couponId) async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.client.from('coupons').delete().eq('id', couponId);
      state = const AsyncValue.data(null);
      _ref.invalidate(couponsProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
