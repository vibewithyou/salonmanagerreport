import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon.freezed.dart';
part 'coupon.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@freezed
class Coupon with _$Coupon {
  const factory Coupon({
    required String id,
    required String salonId,
    required String code,
    String? title,
    String? description,
    required String discountType, // "percentage" or "fixed"
    required double discountValue,
    DateTime? startDate,
    DateTime? endDate,
    double? minPoints,
    List<String>? targetTags,
    @Default(true) bool isActive,
    String? createdBy,
    DateTime? createdAt,
  }) = _Coupon;

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
}
