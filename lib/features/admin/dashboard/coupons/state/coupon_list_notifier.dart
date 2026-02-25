import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/coupon.dart';
import '../data/repositories/coupon_repository.dart';

part 'coupon_list_notifier.freezed.dart';

@freezed
class CouponListState with _$CouponListState {
  const factory CouponListState.loading() = _Loading;
  const factory CouponListState.loaded(List<Coupon> coupons) = _Loaded;
  const factory CouponListState.error(String message) = _Error;
}

class CouponListNotifier extends StateNotifier<CouponListState> {
  final CouponRepository _repository;
  final String _salonId;
  RealtimeChannel? _couponsChannel;

  CouponListNotifier(this._repository, this._salonId)
      : super(const CouponListState.loading()) {
    loadCoupons();
    _bindRealtimeForSalon();
  }

  Future<void> loadCoupons({bool silent = false}) async {
    if (!silent) {
      state = const CouponListState.loading();
    }
    try {
      final coupons = await _repository.getCoupons(_salonId);
      state = CouponListState.loaded(coupons);
    } catch (e) {
      state = CouponListState.error(e.toString());
    }
  }

  Future<void> createCoupon(Map<String, dynamic> couponData) async {
    try {
      couponData['salon_id'] = _salonId;
      couponData['created_at'] = DateTime.now().toIso8601String();
      
      await _repository.createCoupon(couponData);
      await loadCoupons(silent: true);
    } catch (e) {
      state = CouponListState.error('Failed to create coupon: $e');
      rethrow;
    }
  }

  Future<void> updateCoupon(String couponId, Map<String, dynamic> updates) async {
    try {
      await _repository.updateCoupon(couponId, updates);
      await loadCoupons(silent: true);
    } catch (e) {
      state = CouponListState.error('Failed to update coupon: $e');
      rethrow;
    }
  }

  Future<void> deleteCoupon(String couponId) async {
    try {
      await _repository.deleteCoupon(couponId);
      await loadCoupons(silent: true);
    } catch (e) {
      state = CouponListState.error('Failed to delete coupon: $e');
      rethrow;
    }
  }

  Future<void> toggleCouponStatus(String couponId, bool isActive) async {
    try {
      await _repository.updateCoupon(couponId, {'is_active': isActive});
      await loadCoupons(silent: true);
    } catch (e) {
      state = CouponListState.error('Failed to toggle coupon status: $e');
      rethrow;
    }
  }

  Future<void> redeemCoupon({
    required String couponId,
    required String customerProfileId,
    String? transactionId,
  }) async {
    try {
      await _repository.createRedemption(
        couponId: couponId,
        customerProfileId: customerProfileId,
        salonId: _salonId,
        transactionId: transactionId,
      );
    } catch (e) {
      state = CouponListState.error('Failed to redeem coupon: $e');
      rethrow;
    }
  }

  void _bindRealtimeForSalon() {
    _couponsChannel?.unsubscribe();
    _couponsChannel = Supabase.instance.client
        .channel('coupon-list-$_salonId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'coupons',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'salon_id',
            value: _salonId,
          ),
          callback: (_) {
            loadCoupons(silent: true);
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    _couponsChannel?.unsubscribe();
    super.dispose();
  }
}
