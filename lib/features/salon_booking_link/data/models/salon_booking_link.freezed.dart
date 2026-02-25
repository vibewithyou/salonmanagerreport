// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salon_booking_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalonBookingLink _$SalonBookingLinkFromJson(Map<String, dynamic> json) {
  return _SalonBookingLink.fromJson(json);
}

/// @nodoc
mixin _$SalonBookingLink {
  /// Die eindeutige Salon-ID
  String get salonId => throw _privateConstructorUsedError;

  /// Der vollständige Buchungslink (z.B. https://example.com/#/salon/{id})
  String get bookingLink => throw _privateConstructorUsedError;

  /// Ob die öffentliche Buchung über diesen Link aktiviert ist
  bool get bookingEnabled => throw _privateConstructorUsedError;

  /// Der Salonname (für QR-Code-Download-Dateiname)
  String? get salonName => throw _privateConstructorUsedError;

  /// Serializes this SalonBookingLink to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalonBookingLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalonBookingLinkCopyWith<SalonBookingLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalonBookingLinkCopyWith<$Res> {
  factory $SalonBookingLinkCopyWith(
    SalonBookingLink value,
    $Res Function(SalonBookingLink) then,
  ) = _$SalonBookingLinkCopyWithImpl<$Res, SalonBookingLink>;
  @useResult
  $Res call({
    String salonId,
    String bookingLink,
    bool bookingEnabled,
    String? salonName,
  });
}

/// @nodoc
class _$SalonBookingLinkCopyWithImpl<$Res, $Val extends SalonBookingLink>
    implements $SalonBookingLinkCopyWith<$Res> {
  _$SalonBookingLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalonBookingLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? salonId = null,
    Object? bookingLink = null,
    Object? bookingEnabled = null,
    Object? salonName = freezed,
  }) {
    return _then(
      _value.copyWith(
            salonId: null == salonId
                ? _value.salonId
                : salonId // ignore: cast_nullable_to_non_nullable
                      as String,
            bookingLink: null == bookingLink
                ? _value.bookingLink
                : bookingLink // ignore: cast_nullable_to_non_nullable
                      as String,
            bookingEnabled: null == bookingEnabled
                ? _value.bookingEnabled
                : bookingEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            salonName: freezed == salonName
                ? _value.salonName
                : salonName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalonBookingLinkImplCopyWith<$Res>
    implements $SalonBookingLinkCopyWith<$Res> {
  factory _$$SalonBookingLinkImplCopyWith(
    _$SalonBookingLinkImpl value,
    $Res Function(_$SalonBookingLinkImpl) then,
  ) = __$$SalonBookingLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String salonId,
    String bookingLink,
    bool bookingEnabled,
    String? salonName,
  });
}

/// @nodoc
class __$$SalonBookingLinkImplCopyWithImpl<$Res>
    extends _$SalonBookingLinkCopyWithImpl<$Res, _$SalonBookingLinkImpl>
    implements _$$SalonBookingLinkImplCopyWith<$Res> {
  __$$SalonBookingLinkImplCopyWithImpl(
    _$SalonBookingLinkImpl _value,
    $Res Function(_$SalonBookingLinkImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalonBookingLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? salonId = null,
    Object? bookingLink = null,
    Object? bookingEnabled = null,
    Object? salonName = freezed,
  }) {
    return _then(
      _$SalonBookingLinkImpl(
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        bookingLink: null == bookingLink
            ? _value.bookingLink
            : bookingLink // ignore: cast_nullable_to_non_nullable
                  as String,
        bookingEnabled: null == bookingEnabled
            ? _value.bookingEnabled
            : bookingEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        salonName: freezed == salonName
            ? _value.salonName
            : salonName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalonBookingLinkImpl implements _SalonBookingLink {
  const _$SalonBookingLinkImpl({
    required this.salonId,
    required this.bookingLink,
    this.bookingEnabled = true,
    this.salonName,
  });

  factory _$SalonBookingLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalonBookingLinkImplFromJson(json);

  /// Die eindeutige Salon-ID
  @override
  final String salonId;

  /// Der vollständige Buchungslink (z.B. https://example.com/#/salon/{id})
  @override
  final String bookingLink;

  /// Ob die öffentliche Buchung über diesen Link aktiviert ist
  @override
  @JsonKey()
  final bool bookingEnabled;

  /// Der Salonname (für QR-Code-Download-Dateiname)
  @override
  final String? salonName;

  @override
  String toString() {
    return 'SalonBookingLink(salonId: $salonId, bookingLink: $bookingLink, bookingEnabled: $bookingEnabled, salonName: $salonName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalonBookingLinkImpl &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.bookingLink, bookingLink) ||
                other.bookingLink == bookingLink) &&
            (identical(other.bookingEnabled, bookingEnabled) ||
                other.bookingEnabled == bookingEnabled) &&
            (identical(other.salonName, salonName) ||
                other.salonName == salonName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, salonId, bookingLink, bookingEnabled, salonName);

  /// Create a copy of SalonBookingLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalonBookingLinkImplCopyWith<_$SalonBookingLinkImpl> get copyWith =>
      __$$SalonBookingLinkImplCopyWithImpl<_$SalonBookingLinkImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SalonBookingLinkImplToJson(this);
  }
}

abstract class _SalonBookingLink implements SalonBookingLink {
  const factory _SalonBookingLink({
    required final String salonId,
    required final String bookingLink,
    final bool bookingEnabled,
    final String? salonName,
  }) = _$SalonBookingLinkImpl;

  factory _SalonBookingLink.fromJson(Map<String, dynamic> json) =
      _$SalonBookingLinkImpl.fromJson;

  /// Die eindeutige Salon-ID
  @override
  String get salonId;

  /// Der vollständige Buchungslink (z.B. https://example.com/#/salon/{id})
  @override
  String get bookingLink;

  /// Ob die öffentliche Buchung über diesen Link aktiviert ist
  @override
  bool get bookingEnabled;

  /// Der Salonname (für QR-Code-Download-Dateiname)
  @override
  String? get salonName;

  /// Create a copy of SalonBookingLink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalonBookingLinkImplCopyWith<_$SalonBookingLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
