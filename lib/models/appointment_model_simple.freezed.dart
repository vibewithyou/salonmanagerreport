// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_model_simple.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppointmentSimple _$AppointmentSimpleFromJson(Map<String, dynamic> json) {
  return _AppointmentSimple.fromJson(json);
}

/// @nodoc
mixin _$AppointmentSimple {
  String get id => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String get serviceName => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  AppointmentStatus get status => throw _privateConstructorUsedError;
  String? get stylistName => throw _privateConstructorUsedError;
  String? get stylistId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this AppointmentSimple to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentSimple
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentSimpleCopyWith<AppointmentSimple> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentSimpleCopyWith<$Res> {
  factory $AppointmentSimpleCopyWith(
    AppointmentSimple value,
    $Res Function(AppointmentSimple) then,
  ) = _$AppointmentSimpleCopyWithImpl<$Res, AppointmentSimple>;
  @useResult
  $Res call({
    String id,
    DateTime startTime,
    DateTime endTime,
    String customerName,
    String? customerPhone,
    String serviceName,
    double price,
    AppointmentStatus status,
    String? stylistName,
    String? stylistId,
    String? notes,
  });
}

/// @nodoc
class _$AppointmentSimpleCopyWithImpl<$Res, $Val extends AppointmentSimple>
    implements $AppointmentSimpleCopyWith<$Res> {
  _$AppointmentSimpleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentSimple
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? serviceName = null,
    Object? price = null,
    Object? status = null,
    Object? stylistName = freezed,
    Object? stylistId = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            customerName: null == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String,
            customerPhone: freezed == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            serviceName: null == serviceName
                ? _value.serviceName
                : serviceName // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AppointmentStatus,
            stylistName: freezed == stylistName
                ? _value.stylistName
                : stylistName // ignore: cast_nullable_to_non_nullable
                      as String?,
            stylistId: freezed == stylistId
                ? _value.stylistId
                : stylistId // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppointmentSimpleImplCopyWith<$Res>
    implements $AppointmentSimpleCopyWith<$Res> {
  factory _$$AppointmentSimpleImplCopyWith(
    _$AppointmentSimpleImpl value,
    $Res Function(_$AppointmentSimpleImpl) then,
  ) = __$$AppointmentSimpleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime startTime,
    DateTime endTime,
    String customerName,
    String? customerPhone,
    String serviceName,
    double price,
    AppointmentStatus status,
    String? stylistName,
    String? stylistId,
    String? notes,
  });
}

/// @nodoc
class __$$AppointmentSimpleImplCopyWithImpl<$Res>
    extends _$AppointmentSimpleCopyWithImpl<$Res, _$AppointmentSimpleImpl>
    implements _$$AppointmentSimpleImplCopyWith<$Res> {
  __$$AppointmentSimpleImplCopyWithImpl(
    _$AppointmentSimpleImpl _value,
    $Res Function(_$AppointmentSimpleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppointmentSimple
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? serviceName = null,
    Object? price = null,
    Object? status = null,
    Object? stylistName = freezed,
    Object? stylistId = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$AppointmentSimpleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        customerName: null == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String,
        customerPhone: freezed == customerPhone
            ? _value.customerPhone
            : customerPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        serviceName: null == serviceName
            ? _value.serviceName
            : serviceName // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AppointmentStatus,
        stylistName: freezed == stylistName
            ? _value.stylistName
            : stylistName // ignore: cast_nullable_to_non_nullable
                  as String?,
        stylistId: freezed == stylistId
            ? _value.stylistId
            : stylistId // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentSimpleImpl implements _AppointmentSimple {
  const _$AppointmentSimpleImpl({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.customerName,
    required this.customerPhone,
    required this.serviceName,
    required this.price,
    required this.status,
    this.stylistName,
    this.stylistId,
    this.notes,
  });

  factory _$AppointmentSimpleImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentSimpleImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String customerName;
  @override
  final String? customerPhone;
  @override
  final String serviceName;
  @override
  final double price;
  @override
  final AppointmentStatus status;
  @override
  final String? stylistName;
  @override
  final String? stylistId;
  @override
  final String? notes;

  @override
  String toString() {
    return 'AppointmentSimple(id: $id, startTime: $startTime, endTime: $endTime, customerName: $customerName, customerPhone: $customerPhone, serviceName: $serviceName, price: $price, status: $status, stylistName: $stylistName, stylistId: $stylistId, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentSimpleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.stylistName, stylistName) ||
                other.stylistName == stylistName) &&
            (identical(other.stylistId, stylistId) ||
                other.stylistId == stylistId) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    startTime,
    endTime,
    customerName,
    customerPhone,
    serviceName,
    price,
    status,
    stylistName,
    stylistId,
    notes,
  );

  /// Create a copy of AppointmentSimple
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentSimpleImplCopyWith<_$AppointmentSimpleImpl> get copyWith =>
      __$$AppointmentSimpleImplCopyWithImpl<_$AppointmentSimpleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentSimpleImplToJson(this);
  }
}

abstract class _AppointmentSimple implements AppointmentSimple {
  const factory _AppointmentSimple({
    required final String id,
    required final DateTime startTime,
    required final DateTime endTime,
    required final String customerName,
    required final String? customerPhone,
    required final String serviceName,
    required final double price,
    required final AppointmentStatus status,
    final String? stylistName,
    final String? stylistId,
    final String? notes,
  }) = _$AppointmentSimpleImpl;

  factory _AppointmentSimple.fromJson(Map<String, dynamic> json) =
      _$AppointmentSimpleImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  String get customerName;
  @override
  String? get customerPhone;
  @override
  String get serviceName;
  @override
  double get price;
  @override
  AppointmentStatus get status;
  @override
  String? get stylistName;
  @override
  String? get stylistId;
  @override
  String? get notes;

  /// Create a copy of AppointmentSimple
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentSimpleImplCopyWith<_$AppointmentSimpleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
