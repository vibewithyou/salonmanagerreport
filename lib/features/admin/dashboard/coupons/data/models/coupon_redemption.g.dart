// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_redemption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CouponRedemptionImpl _$$CouponRedemptionImplFromJson(
  Map<String, dynamic> json,
) => _$CouponRedemptionImpl(
  id: json['id'] as String,
  couponId: json['coupon_id'] as String,
  customerProfileId: json['customer_profile_id'] as String,
  salonId: json['salon_id'] as String,
  redeemedAt: DateTime.parse(json['redeemed_at'] as String),
  transactionId: json['transaction_id'] as String?,
  customerName: json['customer_name'] as String?,
);

Map<String, dynamic> _$$CouponRedemptionImplToJson(
  _$CouponRedemptionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'coupon_id': instance.couponId,
  'customer_profile_id': instance.customerProfileId,
  'salon_id': instance.salonId,
  'redeemed_at': instance.redeemedAt.toIso8601String(),
  'transaction_id': instance.transactionId,
  'customer_name': instance.customerName,
};
