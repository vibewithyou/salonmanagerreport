// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CouponImpl _$$CouponImplFromJson(Map<String, dynamic> json) => _$CouponImpl(
  id: json['id'] as String,
  salonId: json['salon_id'] as String,
  code: json['code'] as String,
  title: json['title'] as String?,
  description: json['description'] as String?,
  discountType: json['discount_type'] as String,
  discountValue: (json['discount_value'] as num).toDouble(),
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  minPoints: (json['min_points'] as num?)?.toDouble(),
  targetTags: (json['target_tags'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  isActive: json['is_active'] as bool? ?? true,
  createdBy: json['created_by'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$CouponImplToJson(_$CouponImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salon_id': instance.salonId,
      'code': instance.code,
      'title': instance.title,
      'description': instance.description,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'min_points': instance.minPoints,
      'target_tags': instance.targetTags,
      'is_active': instance.isActive,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
    };
