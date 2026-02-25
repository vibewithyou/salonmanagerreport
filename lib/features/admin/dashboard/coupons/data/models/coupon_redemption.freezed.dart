// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_redemption.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CouponRedemption _$CouponRedemptionFromJson(Map<String, dynamic> json) {
  return _CouponRedemption.fromJson(json);
}

/// @nodoc
mixin _$CouponRedemption {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'coupon_id')
  String get couponId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_profile_id')
  String get customerProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'salon_id')
  String get salonId => throw _privateConstructorUsedError;
  @JsonKey(name: 'redeemed_at')
  DateTime get redeemedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_id')
  String? get transactionId => throw _privateConstructorUsedError; // Joined data (optional, from customer_profiles)
  @JsonKey(name: 'customer_name')
  String? get customerName => throw _privateConstructorUsedError;

  /// Serializes this CouponRedemption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CouponRedemption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CouponRedemptionCopyWith<CouponRedemption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouponRedemptionCopyWith<$Res> {
  factory $CouponRedemptionCopyWith(
    CouponRedemption value,
    $Res Function(CouponRedemption) then,
  ) = _$CouponRedemptionCopyWithImpl<$Res, CouponRedemption>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'coupon_id') String couponId,
    @JsonKey(name: 'customer_profile_id') String customerProfileId,
    @JsonKey(name: 'salon_id') String salonId,
    @JsonKey(name: 'redeemed_at') DateTime redeemedAt,
    @JsonKey(name: 'transaction_id') String? transactionId,
    @JsonKey(name: 'customer_name') String? customerName,
  });
}

/// @nodoc
class _$CouponRedemptionCopyWithImpl<$Res, $Val extends CouponRedemption>
    implements $CouponRedemptionCopyWith<$Res> {
  _$CouponRedemptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CouponRedemption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? couponId = null,
    Object? customerProfileId = null,
    Object? salonId = null,
    Object? redeemedAt = null,
    Object? transactionId = freezed,
    Object? customerName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            couponId: null == couponId
                ? _value.couponId
                : couponId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerProfileId: null == customerProfileId
                ? _value.customerProfileId
                : customerProfileId // ignore: cast_nullable_to_non_nullable
                      as String,
            salonId: null == salonId
                ? _value.salonId
                : salonId // ignore: cast_nullable_to_non_nullable
                      as String,
            redeemedAt: null == redeemedAt
                ? _value.redeemedAt
                : redeemedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            transactionId: freezed == transactionId
                ? _value.transactionId
                : transactionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CouponRedemptionImplCopyWith<$Res>
    implements $CouponRedemptionCopyWith<$Res> {
  factory _$$CouponRedemptionImplCopyWith(
    _$CouponRedemptionImpl value,
    $Res Function(_$CouponRedemptionImpl) then,
  ) = __$$CouponRedemptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'coupon_id') String couponId,
    @JsonKey(name: 'customer_profile_id') String customerProfileId,
    @JsonKey(name: 'salon_id') String salonId,
    @JsonKey(name: 'redeemed_at') DateTime redeemedAt,
    @JsonKey(name: 'transaction_id') String? transactionId,
    @JsonKey(name: 'customer_name') String? customerName,
  });
}

/// @nodoc
class __$$CouponRedemptionImplCopyWithImpl<$Res>
    extends _$CouponRedemptionCopyWithImpl<$Res, _$CouponRedemptionImpl>
    implements _$$CouponRedemptionImplCopyWith<$Res> {
  __$$CouponRedemptionImplCopyWithImpl(
    _$CouponRedemptionImpl _value,
    $Res Function(_$CouponRedemptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CouponRedemption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? couponId = null,
    Object? customerProfileId = null,
    Object? salonId = null,
    Object? redeemedAt = null,
    Object? transactionId = freezed,
    Object? customerName = freezed,
  }) {
    return _then(
      _$CouponRedemptionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        couponId: null == couponId
            ? _value.couponId
            : couponId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerProfileId: null == customerProfileId
            ? _value.customerProfileId
            : customerProfileId // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        redeemedAt: null == redeemedAt
            ? _value.redeemedAt
            : redeemedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        transactionId: freezed == transactionId
            ? _value.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CouponRedemptionImpl implements _CouponRedemption {
  const _$CouponRedemptionImpl({
    required this.id,
    @JsonKey(name: 'coupon_id') required this.couponId,
    @JsonKey(name: 'customer_profile_id') required this.customerProfileId,
    @JsonKey(name: 'salon_id') required this.salonId,
    @JsonKey(name: 'redeemed_at') required this.redeemedAt,
    @JsonKey(name: 'transaction_id') this.transactionId,
    @JsonKey(name: 'customer_name') this.customerName,
  });

  factory _$CouponRedemptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouponRedemptionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'coupon_id')
  final String couponId;
  @override
  @JsonKey(name: 'customer_profile_id')
  final String customerProfileId;
  @override
  @JsonKey(name: 'salon_id')
  final String salonId;
  @override
  @JsonKey(name: 'redeemed_at')
  final DateTime redeemedAt;
  @override
  @JsonKey(name: 'transaction_id')
  final String? transactionId;
  // Joined data (optional, from customer_profiles)
  @override
  @JsonKey(name: 'customer_name')
  final String? customerName;

  @override
  String toString() {
    return 'CouponRedemption(id: $id, couponId: $couponId, customerProfileId: $customerProfileId, salonId: $salonId, redeemedAt: $redeemedAt, transactionId: $transactionId, customerName: $customerName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponRedemptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.couponId, couponId) ||
                other.couponId == couponId) &&
            (identical(other.customerProfileId, customerProfileId) ||
                other.customerProfileId == customerProfileId) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.redeemedAt, redeemedAt) ||
                other.redeemedAt == redeemedAt) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    couponId,
    customerProfileId,
    salonId,
    redeemedAt,
    transactionId,
    customerName,
  );

  /// Create a copy of CouponRedemption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CouponRedemptionImplCopyWith<_$CouponRedemptionImpl> get copyWith =>
      __$$CouponRedemptionImplCopyWithImpl<_$CouponRedemptionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CouponRedemptionImplToJson(this);
  }
}

abstract class _CouponRedemption implements CouponRedemption {
  const factory _CouponRedemption({
    required final String id,
    @JsonKey(name: 'coupon_id') required final String couponId,
    @JsonKey(name: 'customer_profile_id')
    required final String customerProfileId,
    @JsonKey(name: 'salon_id') required final String salonId,
    @JsonKey(name: 'redeemed_at') required final DateTime redeemedAt,
    @JsonKey(name: 'transaction_id') final String? transactionId,
    @JsonKey(name: 'customer_name') final String? customerName,
  }) = _$CouponRedemptionImpl;

  factory _CouponRedemption.fromJson(Map<String, dynamic> json) =
      _$CouponRedemptionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'coupon_id')
  String get couponId;
  @override
  @JsonKey(name: 'customer_profile_id')
  String get customerProfileId;
  @override
  @JsonKey(name: 'salon_id')
  String get salonId;
  @override
  @JsonKey(name: 'redeemed_at')
  DateTime get redeemedAt;
  @override
  @JsonKey(name: 'transaction_id')
  String? get transactionId; // Joined data (optional, from customer_profiles)
  @override
  @JsonKey(name: 'customer_name')
  String? get customerName;

  /// Create a copy of CouponRedemption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CouponRedemptionImplCopyWith<_$CouponRedemptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
