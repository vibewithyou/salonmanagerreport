// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_appointment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerAppointment _$CustomerAppointmentFromJson(Map<String, dynamic> json) {
  return _CustomerAppointment.fromJson(json);
}

/// @nodoc
mixin _$CustomerAppointment {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  DateTime get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  DateTime get endTime => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'guest_name')
  String? get guestName => throw _privateConstructorUsedError;
  @JsonKey(name: 'guest_email')
  String? get guestEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'guest_phone')
  String? get guestPhone => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'buffer_before')
  int? get bufferBefore => throw _privateConstructorUsedError;
  @JsonKey(name: 'buffer_after')
  int? get bufferAfter => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_profile_id')
  String? get customerProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'appointment_number')
  String? get appointmentNumber => throw _privateConstructorUsedError;
  ServiceInfo? get service => throw _privateConstructorUsedError;

  /// Serializes this CustomerAppointment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerAppointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerAppointmentCopyWith<CustomerAppointment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerAppointmentCopyWith<$Res> {
  factory $CustomerAppointmentCopyWith(
    CustomerAppointment value,
    $Res Function(CustomerAppointment) then,
  ) = _$CustomerAppointmentCopyWithImpl<$Res, CustomerAppointment>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'start_time') DateTime startTime,
    @JsonKey(name: 'end_time') DateTime endTime,
    String status,
    String? notes,
    @JsonKey(name: 'guest_name') String? guestName,
    @JsonKey(name: 'guest_email') String? guestEmail,
    @JsonKey(name: 'guest_phone') String? guestPhone,
    double? price,
    @JsonKey(name: 'buffer_before') int? bufferBefore,
    @JsonKey(name: 'buffer_after') int? bufferAfter,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'customer_profile_id') String? customerProfileId,
    @JsonKey(name: 'appointment_number') String? appointmentNumber,
    ServiceInfo? service,
  });

  $ServiceInfoCopyWith<$Res>? get service;
}

/// @nodoc
class _$CustomerAppointmentCopyWithImpl<$Res, $Val extends CustomerAppointment>
    implements $CustomerAppointmentCopyWith<$Res> {
  _$CustomerAppointmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerAppointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? notes = freezed,
    Object? guestName = freezed,
    Object? guestEmail = freezed,
    Object? guestPhone = freezed,
    Object? price = freezed,
    Object? bufferBefore = freezed,
    Object? bufferAfter = freezed,
    Object? imageUrl = freezed,
    Object? customerProfileId = freezed,
    Object? appointmentNumber = freezed,
    Object? service = freezed,
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            guestName: freezed == guestName
                ? _value.guestName
                : guestName // ignore: cast_nullable_to_non_nullable
                      as String?,
            guestEmail: freezed == guestEmail
                ? _value.guestEmail
                : guestEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            guestPhone: freezed == guestPhone
                ? _value.guestPhone
                : guestPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            bufferBefore: freezed == bufferBefore
                ? _value.bufferBefore
                : bufferBefore // ignore: cast_nullable_to_non_nullable
                      as int?,
            bufferAfter: freezed == bufferAfter
                ? _value.bufferAfter
                : bufferAfter // ignore: cast_nullable_to_non_nullable
                      as int?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerProfileId: freezed == customerProfileId
                ? _value.customerProfileId
                : customerProfileId // ignore: cast_nullable_to_non_nullable
                      as String?,
            appointmentNumber: freezed == appointmentNumber
                ? _value.appointmentNumber
                : appointmentNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            service: freezed == service
                ? _value.service
                : service // ignore: cast_nullable_to_non_nullable
                      as ServiceInfo?,
          )
          as $Val,
    );
  }

  /// Create a copy of CustomerAppointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ServiceInfoCopyWith<$Res>? get service {
    if (_value.service == null) {
      return null;
    }

    return $ServiceInfoCopyWith<$Res>(_value.service!, (value) {
      return _then(_value.copyWith(service: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CustomerAppointmentImplCopyWith<$Res>
    implements $CustomerAppointmentCopyWith<$Res> {
  factory _$$CustomerAppointmentImplCopyWith(
    _$CustomerAppointmentImpl value,
    $Res Function(_$CustomerAppointmentImpl) then,
  ) = __$$CustomerAppointmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'start_time') DateTime startTime,
    @JsonKey(name: 'end_time') DateTime endTime,
    String status,
    String? notes,
    @JsonKey(name: 'guest_name') String? guestName,
    @JsonKey(name: 'guest_email') String? guestEmail,
    @JsonKey(name: 'guest_phone') String? guestPhone,
    double? price,
    @JsonKey(name: 'buffer_before') int? bufferBefore,
    @JsonKey(name: 'buffer_after') int? bufferAfter,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'customer_profile_id') String? customerProfileId,
    @JsonKey(name: 'appointment_number') String? appointmentNumber,
    ServiceInfo? service,
  });

  @override
  $ServiceInfoCopyWith<$Res>? get service;
}

/// @nodoc
class __$$CustomerAppointmentImplCopyWithImpl<$Res>
    extends _$CustomerAppointmentCopyWithImpl<$Res, _$CustomerAppointmentImpl>
    implements _$$CustomerAppointmentImplCopyWith<$Res> {
  __$$CustomerAppointmentImplCopyWithImpl(
    _$CustomerAppointmentImpl _value,
    $Res Function(_$CustomerAppointmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerAppointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? notes = freezed,
    Object? guestName = freezed,
    Object? guestEmail = freezed,
    Object? guestPhone = freezed,
    Object? price = freezed,
    Object? bufferBefore = freezed,
    Object? bufferAfter = freezed,
    Object? imageUrl = freezed,
    Object? customerProfileId = freezed,
    Object? appointmentNumber = freezed,
    Object? service = freezed,
  }) {
    return _then(
      _$CustomerAppointmentImpl(
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
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        guestName: freezed == guestName
            ? _value.guestName
            : guestName // ignore: cast_nullable_to_non_nullable
                  as String?,
        guestEmail: freezed == guestEmail
            ? _value.guestEmail
            : guestEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        guestPhone: freezed == guestPhone
            ? _value.guestPhone
            : guestPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        bufferBefore: freezed == bufferBefore
            ? _value.bufferBefore
            : bufferBefore // ignore: cast_nullable_to_non_nullable
                  as int?,
        bufferAfter: freezed == bufferAfter
            ? _value.bufferAfter
            : bufferAfter // ignore: cast_nullable_to_non_nullable
                  as int?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerProfileId: freezed == customerProfileId
            ? _value.customerProfileId
            : customerProfileId // ignore: cast_nullable_to_non_nullable
                  as String?,
        appointmentNumber: freezed == appointmentNumber
            ? _value.appointmentNumber
            : appointmentNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        service: freezed == service
            ? _value.service
            : service // ignore: cast_nullable_to_non_nullable
                  as ServiceInfo?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerAppointmentImpl implements _CustomerAppointment {
  const _$CustomerAppointmentImpl({
    required this.id,
    @JsonKey(name: 'start_time') required this.startTime,
    @JsonKey(name: 'end_time') required this.endTime,
    required this.status,
    this.notes,
    @JsonKey(name: 'guest_name') this.guestName,
    @JsonKey(name: 'guest_email') this.guestEmail,
    @JsonKey(name: 'guest_phone') this.guestPhone,
    this.price,
    @JsonKey(name: 'buffer_before') this.bufferBefore,
    @JsonKey(name: 'buffer_after') this.bufferAfter,
    @JsonKey(name: 'image_url') this.imageUrl,
    @JsonKey(name: 'customer_profile_id') this.customerProfileId,
    @JsonKey(name: 'appointment_number') this.appointmentNumber,
    this.service,
  });

  factory _$CustomerAppointmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerAppointmentImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'start_time')
  final DateTime startTime;
  @override
  @JsonKey(name: 'end_time')
  final DateTime endTime;
  @override
  final String status;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'guest_name')
  final String? guestName;
  @override
  @JsonKey(name: 'guest_email')
  final String? guestEmail;
  @override
  @JsonKey(name: 'guest_phone')
  final String? guestPhone;
  @override
  final double? price;
  @override
  @JsonKey(name: 'buffer_before')
  final int? bufferBefore;
  @override
  @JsonKey(name: 'buffer_after')
  final int? bufferAfter;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'customer_profile_id')
  final String? customerProfileId;
  @override
  @JsonKey(name: 'appointment_number')
  final String? appointmentNumber;
  @override
  final ServiceInfo? service;

  @override
  String toString() {
    return 'CustomerAppointment(id: $id, startTime: $startTime, endTime: $endTime, status: $status, notes: $notes, guestName: $guestName, guestEmail: $guestEmail, guestPhone: $guestPhone, price: $price, bufferBefore: $bufferBefore, bufferAfter: $bufferAfter, imageUrl: $imageUrl, customerProfileId: $customerProfileId, appointmentNumber: $appointmentNumber, service: $service)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerAppointmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.guestName, guestName) ||
                other.guestName == guestName) &&
            (identical(other.guestEmail, guestEmail) ||
                other.guestEmail == guestEmail) &&
            (identical(other.guestPhone, guestPhone) ||
                other.guestPhone == guestPhone) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.bufferBefore, bufferBefore) ||
                other.bufferBefore == bufferBefore) &&
            (identical(other.bufferAfter, bufferAfter) ||
                other.bufferAfter == bufferAfter) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.customerProfileId, customerProfileId) ||
                other.customerProfileId == customerProfileId) &&
            (identical(other.appointmentNumber, appointmentNumber) ||
                other.appointmentNumber == appointmentNumber) &&
            (identical(other.service, service) || other.service == service));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    startTime,
    endTime,
    status,
    notes,
    guestName,
    guestEmail,
    guestPhone,
    price,
    bufferBefore,
    bufferAfter,
    imageUrl,
    customerProfileId,
    appointmentNumber,
    service,
  );

  /// Create a copy of CustomerAppointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerAppointmentImplCopyWith<_$CustomerAppointmentImpl> get copyWith =>
      __$$CustomerAppointmentImplCopyWithImpl<_$CustomerAppointmentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerAppointmentImplToJson(this);
  }
}

abstract class _CustomerAppointment implements CustomerAppointment {
  const factory _CustomerAppointment({
    required final String id,
    @JsonKey(name: 'start_time') required final DateTime startTime,
    @JsonKey(name: 'end_time') required final DateTime endTime,
    required final String status,
    final String? notes,
    @JsonKey(name: 'guest_name') final String? guestName,
    @JsonKey(name: 'guest_email') final String? guestEmail,
    @JsonKey(name: 'guest_phone') final String? guestPhone,
    final double? price,
    @JsonKey(name: 'buffer_before') final int? bufferBefore,
    @JsonKey(name: 'buffer_after') final int? bufferAfter,
    @JsonKey(name: 'image_url') final String? imageUrl,
    @JsonKey(name: 'customer_profile_id') final String? customerProfileId,
    @JsonKey(name: 'appointment_number') final String? appointmentNumber,
    final ServiceInfo? service,
  }) = _$CustomerAppointmentImpl;

  factory _CustomerAppointment.fromJson(Map<String, dynamic> json) =
      _$CustomerAppointmentImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'start_time')
  DateTime get startTime;
  @override
  @JsonKey(name: 'end_time')
  DateTime get endTime;
  @override
  String get status;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'guest_name')
  String? get guestName;
  @override
  @JsonKey(name: 'guest_email')
  String? get guestEmail;
  @override
  @JsonKey(name: 'guest_phone')
  String? get guestPhone;
  @override
  double? get price;
  @override
  @JsonKey(name: 'buffer_before')
  int? get bufferBefore;
  @override
  @JsonKey(name: 'buffer_after')
  int? get bufferAfter;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'customer_profile_id')
  String? get customerProfileId;
  @override
  @JsonKey(name: 'appointment_number')
  String? get appointmentNumber;
  @override
  ServiceInfo? get service;

  /// Create a copy of CustomerAppointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerAppointmentImplCopyWith<_$CustomerAppointmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ServiceInfo _$ServiceInfoFromJson(Map<String, dynamic> json) {
  return _ServiceInfo.fromJson(json);
}

/// @nodoc
mixin _$ServiceInfo {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;

  /// Serializes this ServiceInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceInfoCopyWith<ServiceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceInfoCopyWith<$Res> {
  factory $ServiceInfoCopyWith(
    ServiceInfo value,
    $Res Function(ServiceInfo) then,
  ) = _$ServiceInfoCopyWithImpl<$Res, ServiceInfo>;
  @useResult
  $Res call({
    String name,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    double? price,
  });
}

/// @nodoc
class _$ServiceInfoCopyWithImpl<$Res, $Val extends ServiceInfo>
    implements $ServiceInfoCopyWith<$Res> {
  _$ServiceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? durationMinutes = freezed,
    Object? price = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            durationMinutes: freezed == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServiceInfoImplCopyWith<$Res>
    implements $ServiceInfoCopyWith<$Res> {
  factory _$$ServiceInfoImplCopyWith(
    _$ServiceInfoImpl value,
    $Res Function(_$ServiceInfoImpl) then,
  ) = __$$ServiceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    double? price,
  });
}

/// @nodoc
class __$$ServiceInfoImplCopyWithImpl<$Res>
    extends _$ServiceInfoCopyWithImpl<$Res, _$ServiceInfoImpl>
    implements _$$ServiceInfoImplCopyWith<$Res> {
  __$$ServiceInfoImplCopyWithImpl(
    _$ServiceInfoImpl _value,
    $Res Function(_$ServiceInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? durationMinutes = freezed,
    Object? price = freezed,
  }) {
    return _then(
      _$ServiceInfoImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        durationMinutes: freezed == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceInfoImpl implements _ServiceInfo {
  const _$ServiceInfoImpl({
    required this.name,
    @JsonKey(name: 'duration_minutes') this.durationMinutes,
    this.price,
  });

  factory _$ServiceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceInfoImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  @override
  final double? price;

  @override
  String toString() {
    return 'ServiceInfo(name: $name, durationMinutes: $durationMinutes, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceInfoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, durationMinutes, price);

  /// Create a copy of ServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceInfoImplCopyWith<_$ServiceInfoImpl> get copyWith =>
      __$$ServiceInfoImplCopyWithImpl<_$ServiceInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceInfoImplToJson(this);
  }
}

abstract class _ServiceInfo implements ServiceInfo {
  const factory _ServiceInfo({
    required final String name,
    @JsonKey(name: 'duration_minutes') final int? durationMinutes,
    final double? price,
  }) = _$ServiceInfoImpl;

  factory _ServiceInfo.fromJson(Map<String, dynamic> json) =
      _$ServiceInfoImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes;
  @override
  double? get price;

  /// Create a copy of ServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceInfoImplCopyWith<_$ServiceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
