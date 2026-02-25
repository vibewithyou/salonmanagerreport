// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_appointment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AdminAppointment _$AdminAppointmentFromJson(Map<String, dynamic> json) {
  return _AdminAppointment.fromJson(json);
}

/// @nodoc
mixin _$AdminAppointment {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String get serviceId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get employeeName => throw _privateConstructorUsedError;
  String? get serviceName => throw _privateConstructorUsedError;

  /// Serializes this AdminAppointment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdminAppointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminAppointmentCopyWith<AdminAppointment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminAppointmentCopyWith<$Res> {
  factory $AdminAppointmentCopyWith(
    AdminAppointment value,
    $Res Function(AdminAppointment) then,
  ) = _$AdminAppointmentCopyWithImpl<$Res, AdminAppointment>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String customerId,
    String employeeId,
    String serviceId,
    DateTime startTime,
    DateTime endTime,
    String status,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
    String? customerName,
    String? employeeName,
    String? serviceName,
  });
}

/// @nodoc
class _$AdminAppointmentCopyWithImpl<$Res, $Val extends AdminAppointment>
    implements $AdminAppointmentCopyWith<$Res> {
  _$AdminAppointmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminAppointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? customerId = null,
    Object? employeeId = null,
    Object? serviceId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? customerName = freezed,
    Object? employeeName = freezed,
    Object? serviceName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            salonId: null == salonId
                ? _value.salonId
                : salonId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as String,
            serviceId: null == serviceId
                ? _value.serviceId
                : serviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            employeeName: freezed == employeeName
                ? _value.employeeName
                : employeeName // ignore: cast_nullable_to_non_nullable
                      as String?,
            serviceName: freezed == serviceName
                ? _value.serviceName
                : serviceName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AdminAppointmentImplCopyWith<$Res>
    implements $AdminAppointmentCopyWith<$Res> {
  factory _$$AdminAppointmentImplCopyWith(
    _$AdminAppointmentImpl value,
    $Res Function(_$AdminAppointmentImpl) then,
  ) = __$$AdminAppointmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String customerId,
    String employeeId,
    String serviceId,
    DateTime startTime,
    DateTime endTime,
    String status,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
    String? customerName,
    String? employeeName,
    String? serviceName,
  });
}

/// @nodoc
class __$$AdminAppointmentImplCopyWithImpl<$Res>
    extends _$AdminAppointmentCopyWithImpl<$Res, _$AdminAppointmentImpl>
    implements _$$AdminAppointmentImplCopyWith<$Res> {
  __$$AdminAppointmentImplCopyWithImpl(
    _$AdminAppointmentImpl _value,
    $Res Function(_$AdminAppointmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminAppointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? customerId = null,
    Object? employeeId = null,
    Object? serviceId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? customerName = freezed,
    Object? employeeName = freezed,
    Object? serviceName = freezed,
  }) {
    return _then(
      _$AdminAppointmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        serviceId: null == serviceId
            ? _value.serviceId
            : serviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        employeeName: freezed == employeeName
            ? _value.employeeName
            : employeeName // ignore: cast_nullable_to_non_nullable
                  as String?,
        serviceName: freezed == serviceName
            ? _value.serviceName
            : serviceName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminAppointmentImpl extends _AdminAppointment {
  const _$AdminAppointmentImpl({
    required this.id,
    required this.salonId,
    required this.customerId,
    required this.employeeId,
    required this.serviceId,
    required this.startTime,
    required this.endTime,
    this.status = 'pending',
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.customerName,
    this.employeeName,
    this.serviceName,
  }) : super._();

  factory _$AdminAppointmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminAppointmentImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String customerId;
  @override
  final String employeeId;
  @override
  final String serviceId;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  @JsonKey()
  final String status;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? customerName;
  @override
  final String? employeeName;
  @override
  final String? serviceName;

  @override
  String toString() {
    return 'AdminAppointment(id: $id, salonId: $salonId, customerId: $customerId, employeeId: $employeeId, serviceId: $serviceId, startTime: $startTime, endTime: $endTime, status: $status, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, customerName: $customerName, employeeName: $employeeName, serviceName: $serviceName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminAppointmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    customerId,
    employeeId,
    serviceId,
    startTime,
    endTime,
    status,
    notes,
    createdAt,
    updatedAt,
    customerName,
    employeeName,
    serviceName,
  );

  /// Create a copy of AdminAppointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminAppointmentImplCopyWith<_$AdminAppointmentImpl> get copyWith =>
      __$$AdminAppointmentImplCopyWithImpl<_$AdminAppointmentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminAppointmentImplToJson(this);
  }
}

abstract class _AdminAppointment extends AdminAppointment {
  const factory _AdminAppointment({
    required final String id,
    required final String salonId,
    required final String customerId,
    required final String employeeId,
    required final String serviceId,
    required final DateTime startTime,
    required final DateTime endTime,
    final String status,
    final String? notes,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? customerName,
    final String? employeeName,
    final String? serviceName,
  }) = _$AdminAppointmentImpl;
  const _AdminAppointment._() : super._();

  factory _AdminAppointment.fromJson(Map<String, dynamic> json) =
      _$AdminAppointmentImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get customerId;
  @override
  String get employeeId;
  @override
  String get serviceId;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  String get status;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get customerName;
  @override
  String? get employeeName;
  @override
  String? get serviceName;

  /// Create a copy of AdminAppointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminAppointmentImplCopyWith<_$AdminAppointmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
