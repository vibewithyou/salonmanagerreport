import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/coupon_remote_datasource.dart';
import '../data/repositories/coupon_repository.dart';
import '../data/models/coupon_redemption.dart';
import 'coupon_list_notifier.dart';

// Datasource provider
final couponDatasourceProvider = Provider<CouponRemoteDatasource>((ref) {
  return CouponRemoteDatasource();
});

// Repository provider
final couponRepositoryProvider = Provider<CouponRepository>((ref) {
  final datasource = ref.watch(couponDatasourceProvider);
  return CouponRepository(datasource);
});

// Coupon list notifier provider
final couponListNotifierProvider =
    StateNotifierProvider.family<CouponListNotifier, CouponListState, String>(
  (ref, salonId) {
    final repository = ref.watch(couponRepositoryProvider);
    return CouponListNotifier(repository, salonId);
  },
);

// Redemption count provider for a specific coupon
final couponRedemptionCountProvider =
    FutureProvider.family<int, String>((ref, couponId) async {
  final repository = ref.watch(couponRepositoryProvider);
  return repository.getRedemptionCount(couponId);
});

final couponRedemptionsProvider =
    FutureProvider.family<List<CouponRedemption>, String>((ref, couponId) async {
  final repository = ref.watch(couponRepositoryProvider);
  return repository.getCouponRedemptions(couponId);
});
