import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_model.freezed.dart';
part 'coupon_model.g.dart';

@freezed
class Coupon with _$Coupon {
  const factory Coupon({
    required String id,
    required String salonId,
    required String code,
    required String discountType, // percentage, fixed
    required double discountValue,
    DateTime? expiryDate,
    int? maxUses,
    int? usedCount,
    bool? isActive,
    DateTime? createdAt,
  }) = _Coupon;

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
}
