import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_redemption.freezed.dart';
part 'coupon_redemption.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@freezed
class CouponRedemption with _$CouponRedemption {
  const factory CouponRedemption({
    required String id,
    required String couponId,
    required String customerProfileId,
    required String salonId,
    required DateTime redeemedAt,
    String? transactionId,
    // Joined data (optional, from customer_profiles)
    String? customerName,
  }) = _CouponRedemption;

  factory CouponRedemption.fromJson(Map<String, dynamic> json) =>
      _$CouponRedemptionFromJson(json);
}
