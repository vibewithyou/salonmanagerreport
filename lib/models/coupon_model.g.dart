// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CouponImpl _$$CouponImplFromJson(Map<String, dynamic> json) => _$CouponImpl(
  id: json['id'] as String,
  salonId: json['salonId'] as String,
  code: json['code'] as String,
  discountType: json['discountType'] as String,
  discountValue: (json['discountValue'] as num).toDouble(),
  expiryDate: json['expiryDate'] == null
      ? null
      : DateTime.parse(json['expiryDate'] as String),
  maxUses: (json['maxUses'] as num?)?.toInt(),
  usedCount: (json['usedCount'] as num?)?.toInt(),
  isActive: json['isActive'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$CouponImplToJson(_$CouponImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'code': instance.code,
      'discountType': instance.discountType,
      'discountValue': instance.discountValue,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'maxUses': instance.maxUses,
      'usedCount': instance.usedCount,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
