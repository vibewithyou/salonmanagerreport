import '../datasources/coupon_remote_datasource.dart';
import '../models/coupon.dart';
import '../models/coupon_redemption.dart';

class CouponRepository {
  final CouponRemoteDatasource _datasource;

  CouponRepository(this._datasource);

  Future<List<Coupon>> getCoupons(String salonId) =>
      _datasource.getCoupons(salonId);

  Future<Coupon> getCouponById(String couponId) =>
      _datasource.getCouponById(couponId);

  Future<Coupon> createCoupon(Map<String, dynamic> couponData) =>
      _datasource.createCoupon(couponData);

  Future<Coupon> updateCoupon(String couponId, Map<String, dynamic> updates) =>
      _datasource.updateCoupon(couponId, updates);

  Future<void> deleteCoupon(String couponId) =>
      _datasource.deleteCoupon(couponId);

  Future<List<CouponRedemption>> getCouponRedemptions(String couponId) =>
      _datasource.getCouponRedemptions(couponId);

    Future<void> createRedemption({
        required String couponId,
        required String customerProfileId,
        required String salonId,
        String? transactionId,
    }) =>
            _datasource.createRedemption(
                couponId: couponId,
                customerProfileId: customerProfileId,
                salonId: salonId,
                transactionId: transactionId,
            );

  Future<int> getRedemptionCount(String couponId) =>
      _datasource.getRedemptionCount(couponId);
}
