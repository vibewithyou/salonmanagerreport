// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_dashboard_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalonServiceDto _$SalonServiceDtoFromJson(Map<String, dynamic> json) {
  return _SalonServiceDto.fromJson(json);
}

/// @nodoc
mixin _$SalonServiceDto {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get bufferBefore => throw _privateConstructorUsedError;
  int get bufferAfter => throw _privateConstructorUsedError;
  double get depositAmount => throw _privateConstructorUsedError;

  /// Serializes this SalonServiceDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalonServiceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalonServiceDtoCopyWith<SalonServiceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalonServiceDtoCopyWith<$Res> {
  factory $SalonServiceDtoCopyWith(
    SalonServiceDto value,
    $Res Function(SalonServiceDto) then,
  ) = _$SalonServiceDtoCopyWithImpl<$Res, SalonServiceDto>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String name,
    String? description,
    int durationMinutes,
    double price,
    String? category,
    bool isActive,
    int bufferBefore,
    int bufferAfter,
    double depositAmount,
  });
}

/// @nodoc
class _$SalonServiceDtoCopyWithImpl<$Res, $Val extends SalonServiceDto>
    implements $SalonServiceDtoCopyWith<$Res> {
  _$SalonServiceDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalonServiceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? name = null,
    Object? description = freezed,
    Object? durationMinutes = null,
    Object? price = null,
    Object? category = freezed,
    Object? isActive = null,
    Object? bufferBefore = null,
    Object? bufferAfter = null,
    Object? depositAmount = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            bufferBefore: null == bufferBefore
                ? _value.bufferBefore
                : bufferBefore // ignore: cast_nullable_to_non_nullable
                      as int,
            bufferAfter: null == bufferAfter
                ? _value.bufferAfter
                : bufferAfter // ignore: cast_nullable_to_non_nullable
                      as int,
            depositAmount: null == depositAmount
                ? _value.depositAmount
                : depositAmount // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalonServiceDtoImplCopyWith<$Res>
    implements $SalonServiceDtoCopyWith<$Res> {
  factory _$$SalonServiceDtoImplCopyWith(
    _$SalonServiceDtoImpl value,
    $Res Function(_$SalonServiceDtoImpl) then,
  ) = __$$SalonServiceDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String name,
    String? description,
    int durationMinutes,
    double price,
    String? category,
    bool isActive,
    int bufferBefore,
    int bufferAfter,
    double depositAmount,
  });
}

/// @nodoc
class __$$SalonServiceDtoImplCopyWithImpl<$Res>
    extends _$SalonServiceDtoCopyWithImpl<$Res, _$SalonServiceDtoImpl>
    implements _$$SalonServiceDtoImplCopyWith<$Res> {
  __$$SalonServiceDtoImplCopyWithImpl(
    _$SalonServiceDtoImpl _value,
    $Res Function(_$SalonServiceDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalonServiceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? name = null,
    Object? description = freezed,
    Object? durationMinutes = null,
    Object? price = null,
    Object? category = freezed,
    Object? isActive = null,
    Object? bufferBefore = null,
    Object? bufferAfter = null,
    Object? depositAmount = null,
  }) {
    return _then(
      _$SalonServiceDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        bufferBefore: null == bufferBefore
            ? _value.bufferBefore
            : bufferBefore // ignore: cast_nullable_to_non_nullable
                  as int,
        bufferAfter: null == bufferAfter
            ? _value.bufferAfter
            : bufferAfter // ignore: cast_nullable_to_non_nullable
                  as int,
        depositAmount: null == depositAmount
            ? _value.depositAmount
            : depositAmount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalonServiceDtoImpl implements _SalonServiceDto {
  const _$SalonServiceDtoImpl({
    required this.id,
    required this.salonId,
    required this.name,
    this.description,
    this.durationMinutes = 30,
    required this.price,
    this.category,
    this.isActive = true,
    this.bufferBefore = 0,
    this.bufferAfter = 0,
    this.depositAmount = 0,
  });

  factory _$SalonServiceDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalonServiceDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final int durationMinutes;
  @override
  final double price;
  @override
  final String? category;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int bufferBefore;
  @override
  @JsonKey()
  final int bufferAfter;
  @override
  @JsonKey()
  final double depositAmount;

  @override
  String toString() {
    return 'SalonServiceDto(id: $id, salonId: $salonId, name: $name, description: $description, durationMinutes: $durationMinutes, price: $price, category: $category, isActive: $isActive, bufferBefore: $bufferBefore, bufferAfter: $bufferAfter, depositAmount: $depositAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalonServiceDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.bufferBefore, bufferBefore) ||
                other.bufferBefore == bufferBefore) &&
            (identical(other.bufferAfter, bufferAfter) ||
                other.bufferAfter == bufferAfter) &&
            (identical(other.depositAmount, depositAmount) ||
                other.depositAmount == depositAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    name,
    description,
    durationMinutes,
    price,
    category,
    isActive,
    bufferBefore,
    bufferAfter,
    depositAmount,
  );

  /// Create a copy of SalonServiceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalonServiceDtoImplCopyWith<_$SalonServiceDtoImpl> get copyWith =>
      __$$SalonServiceDtoImplCopyWithImpl<_$SalonServiceDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SalonServiceDtoImplToJson(this);
  }
}

abstract class _SalonServiceDto implements SalonServiceDto {
  const factory _SalonServiceDto({
    required final String id,
    required final String salonId,
    required final String name,
    final String? description,
    final int durationMinutes,
    required final double price,
    final String? category,
    final bool isActive,
    final int bufferBefore,
    final int bufferAfter,
    final double depositAmount,
  }) = _$SalonServiceDtoImpl;

  factory _SalonServiceDto.fromJson(Map<String, dynamic> json) =
      _$SalonServiceDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get name;
  @override
  String? get description;
  @override
  int get durationMinutes;
  @override
  double get price;
  @override
  String? get category;
  @override
  bool get isActive;
  @override
  int get bufferBefore;
  @override
  int get bufferAfter;
  @override
  double get depositAmount;

  /// Create a copy of SalonServiceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalonServiceDtoImplCopyWith<_$SalonServiceDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalonCustomerDto _$SalonCustomerDtoFromJson(Map<String, dynamic> json) {
  return _SalonCustomerDto.fromJson(json);
}

/// @nodoc
mixin _$SalonCustomerDto {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<AppointmentSummaryDto> get appointments =>
      throw _privateConstructorUsedError;
  double get totalSpending => throw _privateConstructorUsedError;
  DateTime? get lastVisitDate => throw _privateConstructorUsedError;

  /// Serializes this SalonCustomerDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalonCustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalonCustomerDtoCopyWith<SalonCustomerDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalonCustomerDtoCopyWith<$Res> {
  factory $SalonCustomerDtoCopyWith(
    SalonCustomerDto value,
    $Res Function(SalonCustomerDto) then,
  ) = _$SalonCustomerDtoCopyWithImpl<$Res, SalonCustomerDto>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String firstName,
    String lastName,
    String? phone,
    String? email,
    DateTime createdAt,
    DateTime updatedAt,
    List<AppointmentSummaryDto> appointments,
    double totalSpending,
    DateTime? lastVisitDate,
  });
}

/// @nodoc
class _$SalonCustomerDtoCopyWithImpl<$Res, $Val extends SalonCustomerDto>
    implements $SalonCustomerDtoCopyWith<$Res> {
  _$SalonCustomerDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalonCustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? appointments = null,
    Object? totalSpending = null,
    Object? lastVisitDate = freezed,
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
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            appointments: null == appointments
                ? _value.appointments
                : appointments // ignore: cast_nullable_to_non_nullable
                      as List<AppointmentSummaryDto>,
            totalSpending: null == totalSpending
                ? _value.totalSpending
                : totalSpending // ignore: cast_nullable_to_non_nullable
                      as double,
            lastVisitDate: freezed == lastVisitDate
                ? _value.lastVisitDate
                : lastVisitDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalonCustomerDtoImplCopyWith<$Res>
    implements $SalonCustomerDtoCopyWith<$Res> {
  factory _$$SalonCustomerDtoImplCopyWith(
    _$SalonCustomerDtoImpl value,
    $Res Function(_$SalonCustomerDtoImpl) then,
  ) = __$$SalonCustomerDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String firstName,
    String lastName,
    String? phone,
    String? email,
    DateTime createdAt,
    DateTime updatedAt,
    List<AppointmentSummaryDto> appointments,
    double totalSpending,
    DateTime? lastVisitDate,
  });
}

/// @nodoc
class __$$SalonCustomerDtoImplCopyWithImpl<$Res>
    extends _$SalonCustomerDtoCopyWithImpl<$Res, _$SalonCustomerDtoImpl>
    implements _$$SalonCustomerDtoImplCopyWith<$Res> {
  __$$SalonCustomerDtoImplCopyWithImpl(
    _$SalonCustomerDtoImpl _value,
    $Res Function(_$SalonCustomerDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalonCustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? appointments = null,
    Object? totalSpending = null,
    Object? lastVisitDate = freezed,
  }) {
    return _then(
      _$SalonCustomerDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        appointments: null == appointments
            ? _value._appointments
            : appointments // ignore: cast_nullable_to_non_nullable
                  as List<AppointmentSummaryDto>,
        totalSpending: null == totalSpending
            ? _value.totalSpending
            : totalSpending // ignore: cast_nullable_to_non_nullable
                  as double,
        lastVisitDate: freezed == lastVisitDate
            ? _value.lastVisitDate
            : lastVisitDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalonCustomerDtoImpl implements _SalonCustomerDto {
  const _$SalonCustomerDtoImpl({
    required this.id,
    required this.salonId,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.email,
    required this.createdAt,
    required this.updatedAt,
    final List<AppointmentSummaryDto> appointments = const [],
    this.totalSpending = 0,
    this.lastVisitDate,
  }) : _appointments = appointments;

  factory _$SalonCustomerDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalonCustomerDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<AppointmentSummaryDto> _appointments;
  @override
  @JsonKey()
  List<AppointmentSummaryDto> get appointments {
    if (_appointments is EqualUnmodifiableListView) return _appointments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appointments);
  }

  @override
  @JsonKey()
  final double totalSpending;
  @override
  final DateTime? lastVisitDate;

  @override
  String toString() {
    return 'SalonCustomerDto(id: $id, salonId: $salonId, firstName: $firstName, lastName: $lastName, phone: $phone, email: $email, createdAt: $createdAt, updatedAt: $updatedAt, appointments: $appointments, totalSpending: $totalSpending, lastVisitDate: $lastVisitDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalonCustomerDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(
              other._appointments,
              _appointments,
            ) &&
            (identical(other.totalSpending, totalSpending) ||
                other.totalSpending == totalSpending) &&
            (identical(other.lastVisitDate, lastVisitDate) ||
                other.lastVisitDate == lastVisitDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    firstName,
    lastName,
    phone,
    email,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_appointments),
    totalSpending,
    lastVisitDate,
  );

  /// Create a copy of SalonCustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalonCustomerDtoImplCopyWith<_$SalonCustomerDtoImpl> get copyWith =>
      __$$SalonCustomerDtoImplCopyWithImpl<_$SalonCustomerDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SalonCustomerDtoImplToJson(this);
  }
}

abstract class _SalonCustomerDto implements SalonCustomerDto {
  const factory _SalonCustomerDto({
    required final String id,
    required final String salonId,
    required final String firstName,
    required final String lastName,
    final String? phone,
    final String? email,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final List<AppointmentSummaryDto> appointments,
    final double totalSpending,
    final DateTime? lastVisitDate,
  }) = _$SalonCustomerDtoImpl;

  factory _SalonCustomerDto.fromJson(Map<String, dynamic> json) =
      _$SalonCustomerDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<AppointmentSummaryDto> get appointments;
  @override
  double get totalSpending;
  @override
  DateTime? get lastVisitDate;

  /// Create a copy of SalonCustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalonCustomerDtoImplCopyWith<_$SalonCustomerDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppointmentSummaryDto _$AppointmentSummaryDtoFromJson(
  Map<String, dynamic> json,
) {
  return _AppointmentSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$AppointmentSummaryDto {
  String get id => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;

  /// Serializes this AppointmentSummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentSummaryDtoCopyWith<AppointmentSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentSummaryDtoCopyWith<$Res> {
  factory $AppointmentSummaryDtoCopyWith(
    AppointmentSummaryDto value,
    $Res Function(AppointmentSummaryDto) then,
  ) = _$AppointmentSummaryDtoCopyWithImpl<$Res, AppointmentSummaryDto>;
  @useResult
  $Res call({String id, DateTime startTime, String status, double? price});
}

/// @nodoc
class _$AppointmentSummaryDtoCopyWithImpl<
  $Res,
  $Val extends AppointmentSummaryDto
>
    implements $AppointmentSummaryDtoCopyWith<$Res> {
  _$AppointmentSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? status = null,
    Object? price = freezed,
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$AppointmentSummaryDtoImplCopyWith<$Res>
    implements $AppointmentSummaryDtoCopyWith<$Res> {
  factory _$$AppointmentSummaryDtoImplCopyWith(
    _$AppointmentSummaryDtoImpl value,
    $Res Function(_$AppointmentSummaryDtoImpl) then,
  ) = __$$AppointmentSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime startTime, String status, double? price});
}

/// @nodoc
class __$$AppointmentSummaryDtoImplCopyWithImpl<$Res>
    extends
        _$AppointmentSummaryDtoCopyWithImpl<$Res, _$AppointmentSummaryDtoImpl>
    implements _$$AppointmentSummaryDtoImplCopyWith<$Res> {
  __$$AppointmentSummaryDtoImplCopyWithImpl(
    _$AppointmentSummaryDtoImpl _value,
    $Res Function(_$AppointmentSummaryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppointmentSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? status = null,
    Object? price = freezed,
  }) {
    return _then(
      _$AppointmentSummaryDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$AppointmentSummaryDtoImpl implements _AppointmentSummaryDto {
  const _$AppointmentSummaryDtoImpl({
    required this.id,
    required this.startTime,
    required this.status,
    this.price,
  });

  factory _$AppointmentSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentSummaryDtoImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime startTime;
  @override
  final String status;
  @override
  final double? price;

  @override
  String toString() {
    return 'AppointmentSummaryDto(id: $id, startTime: $startTime, status: $status, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentSummaryDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, startTime, status, price);

  /// Create a copy of AppointmentSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentSummaryDtoImplCopyWith<_$AppointmentSummaryDtoImpl>
  get copyWith =>
      __$$AppointmentSummaryDtoImplCopyWithImpl<_$AppointmentSummaryDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentSummaryDtoImplToJson(this);
  }
}

abstract class _AppointmentSummaryDto implements AppointmentSummaryDto {
  const factory _AppointmentSummaryDto({
    required final String id,
    required final DateTime startTime,
    required final String status,
    final double? price,
  }) = _$AppointmentSummaryDtoImpl;

  factory _AppointmentSummaryDto.fromJson(Map<String, dynamic> json) =
      _$AppointmentSummaryDtoImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get startTime;
  @override
  String get status;
  @override
  double? get price;

  /// Create a copy of AppointmentSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentSummaryDtoImplCopyWith<_$AppointmentSummaryDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

EmployeePortfolioImageDto _$EmployeePortfolioImageDtoFromJson(
  Map<String, dynamic> json,
) {
  return _EmployeePortfolioImageDto.fromJson(json);
}

/// @nodoc
mixin _$EmployeePortfolioImageDto {
  String get id => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get hairstyle => throw _privateConstructorUsedError;
  String? get mimeType => throw _privateConstructorUsedError;
  int? get fileSize => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;

  /// Serializes this EmployeePortfolioImageDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeePortfolioImageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeePortfolioImageDtoCopyWith<EmployeePortfolioImageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeePortfolioImageDtoCopyWith<$Res> {
  factory $EmployeePortfolioImageDtoCopyWith(
    EmployeePortfolioImageDto value,
    $Res Function(EmployeePortfolioImageDto) then,
  ) = _$EmployeePortfolioImageDtoCopyWithImpl<$Res, EmployeePortfolioImageDto>;
  @useResult
  $Res call({
    String id,
    String employeeId,
    String imageUrl,
    String? caption,
    DateTime createdAt,
    String? color,
    String? hairstyle,
    String? mimeType,
    int? fileSize,
    int? height,
    int? width,
  });
}

/// @nodoc
class _$EmployeePortfolioImageDtoCopyWithImpl<
  $Res,
  $Val extends EmployeePortfolioImageDto
>
    implements $EmployeePortfolioImageDtoCopyWith<$Res> {
  _$EmployeePortfolioImageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeePortfolioImageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? imageUrl = null,
    Object? caption = freezed,
    Object? createdAt = null,
    Object? color = freezed,
    Object? hairstyle = freezed,
    Object? mimeType = freezed,
    Object? fileSize = freezed,
    Object? height = freezed,
    Object? width = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            hairstyle: freezed == hairstyle
                ? _value.hairstyle
                : hairstyle // ignore: cast_nullable_to_non_nullable
                      as String?,
            mimeType: freezed == mimeType
                ? _value.mimeType
                : mimeType // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileSize: freezed == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as int?,
            height: freezed == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as int?,
            width: freezed == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeePortfolioImageDtoImplCopyWith<$Res>
    implements $EmployeePortfolioImageDtoCopyWith<$Res> {
  factory _$$EmployeePortfolioImageDtoImplCopyWith(
    _$EmployeePortfolioImageDtoImpl value,
    $Res Function(_$EmployeePortfolioImageDtoImpl) then,
  ) = __$$EmployeePortfolioImageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String employeeId,
    String imageUrl,
    String? caption,
    DateTime createdAt,
    String? color,
    String? hairstyle,
    String? mimeType,
    int? fileSize,
    int? height,
    int? width,
  });
}

/// @nodoc
class __$$EmployeePortfolioImageDtoImplCopyWithImpl<$Res>
    extends
        _$EmployeePortfolioImageDtoCopyWithImpl<
          $Res,
          _$EmployeePortfolioImageDtoImpl
        >
    implements _$$EmployeePortfolioImageDtoImplCopyWith<$Res> {
  __$$EmployeePortfolioImageDtoImplCopyWithImpl(
    _$EmployeePortfolioImageDtoImpl _value,
    $Res Function(_$EmployeePortfolioImageDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeePortfolioImageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? imageUrl = null,
    Object? caption = freezed,
    Object? createdAt = null,
    Object? color = freezed,
    Object? hairstyle = freezed,
    Object? mimeType = freezed,
    Object? fileSize = freezed,
    Object? height = freezed,
    Object? width = freezed,
  }) {
    return _then(
      _$EmployeePortfolioImageDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        hairstyle: freezed == hairstyle
            ? _value.hairstyle
            : hairstyle // ignore: cast_nullable_to_non_nullable
                  as String?,
        mimeType: freezed == mimeType
            ? _value.mimeType
            : mimeType // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileSize: freezed == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        height: freezed == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int?,
        width: freezed == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeePortfolioImageDtoImpl implements _EmployeePortfolioImageDto {
  const _$EmployeePortfolioImageDtoImpl({
    required this.id,
    required this.employeeId,
    required this.imageUrl,
    this.caption,
    required this.createdAt,
    this.color,
    this.hairstyle,
    this.mimeType,
    this.fileSize,
    this.height,
    this.width,
  });

  factory _$EmployeePortfolioImageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeePortfolioImageDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String employeeId;
  @override
  final String imageUrl;
  @override
  final String? caption;
  @override
  final DateTime createdAt;
  @override
  final String? color;
  @override
  final String? hairstyle;
  @override
  final String? mimeType;
  @override
  final int? fileSize;
  @override
  final int? height;
  @override
  final int? width;

  @override
  String toString() {
    return 'EmployeePortfolioImageDto(id: $id, employeeId: $employeeId, imageUrl: $imageUrl, caption: $caption, createdAt: $createdAt, color: $color, hairstyle: $hairstyle, mimeType: $mimeType, fileSize: $fileSize, height: $height, width: $width)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeePortfolioImageDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.hairstyle, hairstyle) ||
                other.hairstyle == hairstyle) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    employeeId,
    imageUrl,
    caption,
    createdAt,
    color,
    hairstyle,
    mimeType,
    fileSize,
    height,
    width,
  );

  /// Create a copy of EmployeePortfolioImageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeePortfolioImageDtoImplCopyWith<_$EmployeePortfolioImageDtoImpl>
  get copyWith =>
      __$$EmployeePortfolioImageDtoImplCopyWithImpl<
        _$EmployeePortfolioImageDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeePortfolioImageDtoImplToJson(this);
  }
}

abstract class _EmployeePortfolioImageDto implements EmployeePortfolioImageDto {
  const factory _EmployeePortfolioImageDto({
    required final String id,
    required final String employeeId,
    required final String imageUrl,
    final String? caption,
    required final DateTime createdAt,
    final String? color,
    final String? hairstyle,
    final String? mimeType,
    final int? fileSize,
    final int? height,
    final int? width,
  }) = _$EmployeePortfolioImageDtoImpl;

  factory _EmployeePortfolioImageDto.fromJson(Map<String, dynamic> json) =
      _$EmployeePortfolioImageDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get employeeId;
  @override
  String get imageUrl;
  @override
  String? get caption;
  @override
  DateTime get createdAt;
  @override
  String? get color;
  @override
  String? get hairstyle;
  @override
  String? get mimeType;
  @override
  int? get fileSize;
  @override
  int? get height;
  @override
  int? get width;

  /// Create a copy of EmployeePortfolioImageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeePortfolioImageDtoImplCopyWith<_$EmployeePortfolioImageDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EmployeePortfolioImageWithTagsDto {
  String get id => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get hairstyle => throw _privateConstructorUsedError;
  String? get mimeType => throw _privateConstructorUsedError;
  int? get fileSize => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  List<String> get tagIds => throw _privateConstructorUsedError;

  /// Create a copy of EmployeePortfolioImageWithTagsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeePortfolioImageWithTagsDtoCopyWith<EmployeePortfolioImageWithTagsDto>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeePortfolioImageWithTagsDtoCopyWith<$Res> {
  factory $EmployeePortfolioImageWithTagsDtoCopyWith(
    EmployeePortfolioImageWithTagsDto value,
    $Res Function(EmployeePortfolioImageWithTagsDto) then,
  ) =
      _$EmployeePortfolioImageWithTagsDtoCopyWithImpl<
        $Res,
        EmployeePortfolioImageWithTagsDto
      >;
  @useResult
  $Res call({
    String id,
    String imageUrl,
    String? caption,
    DateTime createdAt,
    String? color,
    String? hairstyle,
    String? mimeType,
    int? fileSize,
    int? height,
    int? width,
    List<String> tagIds,
  });
}

/// @nodoc
class _$EmployeePortfolioImageWithTagsDtoCopyWithImpl<
  $Res,
  $Val extends EmployeePortfolioImageWithTagsDto
>
    implements $EmployeePortfolioImageWithTagsDtoCopyWith<$Res> {
  _$EmployeePortfolioImageWithTagsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeePortfolioImageWithTagsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? caption = freezed,
    Object? createdAt = null,
    Object? color = freezed,
    Object? hairstyle = freezed,
    Object? mimeType = freezed,
    Object? fileSize = freezed,
    Object? height = freezed,
    Object? width = freezed,
    Object? tagIds = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            hairstyle: freezed == hairstyle
                ? _value.hairstyle
                : hairstyle // ignore: cast_nullable_to_non_nullable
                      as String?,
            mimeType: freezed == mimeType
                ? _value.mimeType
                : mimeType // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileSize: freezed == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as int?,
            height: freezed == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as int?,
            width: freezed == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as int?,
            tagIds: null == tagIds
                ? _value.tagIds
                : tagIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeePortfolioImageWithTagsDtoImplCopyWith<$Res>
    implements $EmployeePortfolioImageWithTagsDtoCopyWith<$Res> {
  factory _$$EmployeePortfolioImageWithTagsDtoImplCopyWith(
    _$EmployeePortfolioImageWithTagsDtoImpl value,
    $Res Function(_$EmployeePortfolioImageWithTagsDtoImpl) then,
  ) = __$$EmployeePortfolioImageWithTagsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String imageUrl,
    String? caption,
    DateTime createdAt,
    String? color,
    String? hairstyle,
    String? mimeType,
    int? fileSize,
    int? height,
    int? width,
    List<String> tagIds,
  });
}

/// @nodoc
class __$$EmployeePortfolioImageWithTagsDtoImplCopyWithImpl<$Res>
    extends
        _$EmployeePortfolioImageWithTagsDtoCopyWithImpl<
          $Res,
          _$EmployeePortfolioImageWithTagsDtoImpl
        >
    implements _$$EmployeePortfolioImageWithTagsDtoImplCopyWith<$Res> {
  __$$EmployeePortfolioImageWithTagsDtoImplCopyWithImpl(
    _$EmployeePortfolioImageWithTagsDtoImpl _value,
    $Res Function(_$EmployeePortfolioImageWithTagsDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeePortfolioImageWithTagsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? caption = freezed,
    Object? createdAt = null,
    Object? color = freezed,
    Object? hairstyle = freezed,
    Object? mimeType = freezed,
    Object? fileSize = freezed,
    Object? height = freezed,
    Object? width = freezed,
    Object? tagIds = null,
  }) {
    return _then(
      _$EmployeePortfolioImageWithTagsDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        hairstyle: freezed == hairstyle
            ? _value.hairstyle
            : hairstyle // ignore: cast_nullable_to_non_nullable
                  as String?,
        mimeType: freezed == mimeType
            ? _value.mimeType
            : mimeType // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileSize: freezed == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        height: freezed == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int?,
        width: freezed == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int?,
        tagIds: null == tagIds
            ? _value._tagIds
            : tagIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$EmployeePortfolioImageWithTagsDtoImpl
    implements _EmployeePortfolioImageWithTagsDto {
  const _$EmployeePortfolioImageWithTagsDtoImpl({
    required this.id,
    required this.imageUrl,
    this.caption,
    required this.createdAt,
    this.color,
    this.hairstyle,
    this.mimeType,
    this.fileSize,
    this.height,
    this.width,
    final List<String> tagIds = const [],
  }) : _tagIds = tagIds;

  @override
  final String id;
  @override
  final String imageUrl;
  @override
  final String? caption;
  @override
  final DateTime createdAt;
  @override
  final String? color;
  @override
  final String? hairstyle;
  @override
  final String? mimeType;
  @override
  final int? fileSize;
  @override
  final int? height;
  @override
  final int? width;
  final List<String> _tagIds;
  @override
  @JsonKey()
  List<String> get tagIds {
    if (_tagIds is EqualUnmodifiableListView) return _tagIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagIds);
  }

  @override
  String toString() {
    return 'EmployeePortfolioImageWithTagsDto(id: $id, imageUrl: $imageUrl, caption: $caption, createdAt: $createdAt, color: $color, hairstyle: $hairstyle, mimeType: $mimeType, fileSize: $fileSize, height: $height, width: $width, tagIds: $tagIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeePortfolioImageWithTagsDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.hairstyle, hairstyle) ||
                other.hairstyle == hairstyle) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width) &&
            const DeepCollectionEquality().equals(other._tagIds, _tagIds));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    imageUrl,
    caption,
    createdAt,
    color,
    hairstyle,
    mimeType,
    fileSize,
    height,
    width,
    const DeepCollectionEquality().hash(_tagIds),
  );

  /// Create a copy of EmployeePortfolioImageWithTagsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeePortfolioImageWithTagsDtoImplCopyWith<
    _$EmployeePortfolioImageWithTagsDtoImpl
  >
  get copyWith =>
      __$$EmployeePortfolioImageWithTagsDtoImplCopyWithImpl<
        _$EmployeePortfolioImageWithTagsDtoImpl
      >(this, _$identity);
}

abstract class _EmployeePortfolioImageWithTagsDto
    implements EmployeePortfolioImageWithTagsDto {
  const factory _EmployeePortfolioImageWithTagsDto({
    required final String id,
    required final String imageUrl,
    final String? caption,
    required final DateTime createdAt,
    final String? color,
    final String? hairstyle,
    final String? mimeType,
    final int? fileSize,
    final int? height,
    final int? width,
    final List<String> tagIds,
  }) = _$EmployeePortfolioImageWithTagsDtoImpl;

  @override
  String get id;
  @override
  String get imageUrl;
  @override
  String? get caption;
  @override
  DateTime get createdAt;
  @override
  String? get color;
  @override
  String? get hairstyle;
  @override
  String? get mimeType;
  @override
  int? get fileSize;
  @override
  int? get height;
  @override
  int? get width;
  @override
  List<String> get tagIds;

  /// Create a copy of EmployeePortfolioImageWithTagsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeePortfolioImageWithTagsDtoImplCopyWith<
    _$EmployeePortfolioImageWithTagsDtoImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

PastAppointmentDto _$PastAppointmentDtoFromJson(Map<String, dynamic> json) {
  return _PastAppointmentDto.fromJson(json);
}

/// @nodoc
mixin _$PastAppointmentDto {
  String get id => throw _privateConstructorUsedError;
  String? get customerProfileId => throw _privateConstructorUsedError;
  String? get guestName => throw _privateConstructorUsedError;
  String? get guestEmail => throw _privateConstructorUsedError;
  String? get serviceId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String? get appointmentNumber => throw _privateConstructorUsedError;

  /// Serializes this PastAppointmentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PastAppointmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PastAppointmentDtoCopyWith<PastAppointmentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PastAppointmentDtoCopyWith<$Res> {
  factory $PastAppointmentDtoCopyWith(
    PastAppointmentDto value,
    $Res Function(PastAppointmentDto) then,
  ) = _$PastAppointmentDtoCopyWithImpl<$Res, PastAppointmentDto>;
  @useResult
  $Res call({
    String id,
    String? customerProfileId,
    String? guestName,
    String? guestEmail,
    String? serviceId,
    DateTime startTime,
    String status,
    double? price,
    String? appointmentNumber,
  });
}

/// @nodoc
class _$PastAppointmentDtoCopyWithImpl<$Res, $Val extends PastAppointmentDto>
    implements $PastAppointmentDtoCopyWith<$Res> {
  _$PastAppointmentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PastAppointmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerProfileId = freezed,
    Object? guestName = freezed,
    Object? guestEmail = freezed,
    Object? serviceId = freezed,
    Object? startTime = null,
    Object? status = null,
    Object? price = freezed,
    Object? appointmentNumber = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            customerProfileId: freezed == customerProfileId
                ? _value.customerProfileId
                : customerProfileId // ignore: cast_nullable_to_non_nullable
                      as String?,
            guestName: freezed == guestName
                ? _value.guestName
                : guestName // ignore: cast_nullable_to_non_nullable
                      as String?,
            guestEmail: freezed == guestEmail
                ? _value.guestEmail
                : guestEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            serviceId: freezed == serviceId
                ? _value.serviceId
                : serviceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            appointmentNumber: freezed == appointmentNumber
                ? _value.appointmentNumber
                : appointmentNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PastAppointmentDtoImplCopyWith<$Res>
    implements $PastAppointmentDtoCopyWith<$Res> {
  factory _$$PastAppointmentDtoImplCopyWith(
    _$PastAppointmentDtoImpl value,
    $Res Function(_$PastAppointmentDtoImpl) then,
  ) = __$$PastAppointmentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? customerProfileId,
    String? guestName,
    String? guestEmail,
    String? serviceId,
    DateTime startTime,
    String status,
    double? price,
    String? appointmentNumber,
  });
}

/// @nodoc
class __$$PastAppointmentDtoImplCopyWithImpl<$Res>
    extends _$PastAppointmentDtoCopyWithImpl<$Res, _$PastAppointmentDtoImpl>
    implements _$$PastAppointmentDtoImplCopyWith<$Res> {
  __$$PastAppointmentDtoImplCopyWithImpl(
    _$PastAppointmentDtoImpl _value,
    $Res Function(_$PastAppointmentDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PastAppointmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerProfileId = freezed,
    Object? guestName = freezed,
    Object? guestEmail = freezed,
    Object? serviceId = freezed,
    Object? startTime = null,
    Object? status = null,
    Object? price = freezed,
    Object? appointmentNumber = freezed,
  }) {
    return _then(
      _$PastAppointmentDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        customerProfileId: freezed == customerProfileId
            ? _value.customerProfileId
            : customerProfileId // ignore: cast_nullable_to_non_nullable
                  as String?,
        guestName: freezed == guestName
            ? _value.guestName
            : guestName // ignore: cast_nullable_to_non_nullable
                  as String?,
        guestEmail: freezed == guestEmail
            ? _value.guestEmail
            : guestEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        serviceId: freezed == serviceId
            ? _value.serviceId
            : serviceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        appointmentNumber: freezed == appointmentNumber
            ? _value.appointmentNumber
            : appointmentNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PastAppointmentDtoImpl implements _PastAppointmentDto {
  const _$PastAppointmentDtoImpl({
    required this.id,
    this.customerProfileId,
    this.guestName,
    this.guestEmail,
    this.serviceId,
    required this.startTime,
    required this.status,
    this.price,
    this.appointmentNumber,
  });

  factory _$PastAppointmentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PastAppointmentDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String? customerProfileId;
  @override
  final String? guestName;
  @override
  final String? guestEmail;
  @override
  final String? serviceId;
  @override
  final DateTime startTime;
  @override
  final String status;
  @override
  final double? price;
  @override
  final String? appointmentNumber;

  @override
  String toString() {
    return 'PastAppointmentDto(id: $id, customerProfileId: $customerProfileId, guestName: $guestName, guestEmail: $guestEmail, serviceId: $serviceId, startTime: $startTime, status: $status, price: $price, appointmentNumber: $appointmentNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PastAppointmentDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerProfileId, customerProfileId) ||
                other.customerProfileId == customerProfileId) &&
            (identical(other.guestName, guestName) ||
                other.guestName == guestName) &&
            (identical(other.guestEmail, guestEmail) ||
                other.guestEmail == guestEmail) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.appointmentNumber, appointmentNumber) ||
                other.appointmentNumber == appointmentNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    customerProfileId,
    guestName,
    guestEmail,
    serviceId,
    startTime,
    status,
    price,
    appointmentNumber,
  );

  /// Create a copy of PastAppointmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PastAppointmentDtoImplCopyWith<_$PastAppointmentDtoImpl> get copyWith =>
      __$$PastAppointmentDtoImplCopyWithImpl<_$PastAppointmentDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PastAppointmentDtoImplToJson(this);
  }
}

abstract class _PastAppointmentDto implements PastAppointmentDto {
  const factory _PastAppointmentDto({
    required final String id,
    final String? customerProfileId,
    final String? guestName,
    final String? guestEmail,
    final String? serviceId,
    required final DateTime startTime,
    required final String status,
    final double? price,
    final String? appointmentNumber,
  }) = _$PastAppointmentDtoImpl;

  factory _PastAppointmentDto.fromJson(Map<String, dynamic> json) =
      _$PastAppointmentDtoImpl.fromJson;

  @override
  String get id;
  @override
  String? get customerProfileId;
  @override
  String? get guestName;
  @override
  String? get guestEmail;
  @override
  String? get serviceId;
  @override
  DateTime get startTime;
  @override
  String get status;
  @override
  double? get price;
  @override
  String? get appointmentNumber;

  /// Create a copy of PastAppointmentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PastAppointmentDtoImplCopyWith<_$PastAppointmentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppointmentStatisticsDto _$AppointmentStatisticsDtoFromJson(
  Map<String, dynamic> json,
) {
  return _AppointmentStatisticsDto.fromJson(json);
}

/// @nodoc
mixin _$AppointmentStatisticsDto {
  int get totalAppointments => throw _privateConstructorUsedError;
  int get totalCompleted => throw _privateConstructorUsedError;
  int get totalCancelled => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError;

  /// Serializes this AppointmentStatisticsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentStatisticsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentStatisticsDtoCopyWith<AppointmentStatisticsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentStatisticsDtoCopyWith<$Res> {
  factory $AppointmentStatisticsDtoCopyWith(
    AppointmentStatisticsDto value,
    $Res Function(AppointmentStatisticsDto) then,
  ) = _$AppointmentStatisticsDtoCopyWithImpl<$Res, AppointmentStatisticsDto>;
  @useResult
  $Res call({
    int totalAppointments,
    int totalCompleted,
    int totalCancelled,
    double totalRevenue,
    double completionRate,
  });
}

/// @nodoc
class _$AppointmentStatisticsDtoCopyWithImpl<
  $Res,
  $Val extends AppointmentStatisticsDto
>
    implements $AppointmentStatisticsDtoCopyWith<$Res> {
  _$AppointmentStatisticsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentStatisticsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAppointments = null,
    Object? totalCompleted = null,
    Object? totalCancelled = null,
    Object? totalRevenue = null,
    Object? completionRate = null,
  }) {
    return _then(
      _value.copyWith(
            totalAppointments: null == totalAppointments
                ? _value.totalAppointments
                : totalAppointments // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCompleted: null == totalCompleted
                ? _value.totalCompleted
                : totalCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCancelled: null == totalCancelled
                ? _value.totalCancelled
                : totalCancelled // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            completionRate: null == completionRate
                ? _value.completionRate
                : completionRate // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppointmentStatisticsDtoImplCopyWith<$Res>
    implements $AppointmentStatisticsDtoCopyWith<$Res> {
  factory _$$AppointmentStatisticsDtoImplCopyWith(
    _$AppointmentStatisticsDtoImpl value,
    $Res Function(_$AppointmentStatisticsDtoImpl) then,
  ) = __$$AppointmentStatisticsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalAppointments,
    int totalCompleted,
    int totalCancelled,
    double totalRevenue,
    double completionRate,
  });
}

/// @nodoc
class __$$AppointmentStatisticsDtoImplCopyWithImpl<$Res>
    extends
        _$AppointmentStatisticsDtoCopyWithImpl<
          $Res,
          _$AppointmentStatisticsDtoImpl
        >
    implements _$$AppointmentStatisticsDtoImplCopyWith<$Res> {
  __$$AppointmentStatisticsDtoImplCopyWithImpl(
    _$AppointmentStatisticsDtoImpl _value,
    $Res Function(_$AppointmentStatisticsDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppointmentStatisticsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAppointments = null,
    Object? totalCompleted = null,
    Object? totalCancelled = null,
    Object? totalRevenue = null,
    Object? completionRate = null,
  }) {
    return _then(
      _$AppointmentStatisticsDtoImpl(
        totalAppointments: null == totalAppointments
            ? _value.totalAppointments
            : totalAppointments // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCompleted: null == totalCompleted
            ? _value.totalCompleted
            : totalCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCancelled: null == totalCancelled
            ? _value.totalCancelled
            : totalCancelled // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        completionRate: null == completionRate
            ? _value.completionRate
            : completionRate // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentStatisticsDtoImpl implements _AppointmentStatisticsDto {
  const _$AppointmentStatisticsDtoImpl({
    required this.totalAppointments,
    required this.totalCompleted,
    required this.totalCancelled,
    required this.totalRevenue,
    required this.completionRate,
  });

  factory _$AppointmentStatisticsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentStatisticsDtoImplFromJson(json);

  @override
  final int totalAppointments;
  @override
  final int totalCompleted;
  @override
  final int totalCancelled;
  @override
  final double totalRevenue;
  @override
  final double completionRate;

  @override
  String toString() {
    return 'AppointmentStatisticsDto(totalAppointments: $totalAppointments, totalCompleted: $totalCompleted, totalCancelled: $totalCancelled, totalRevenue: $totalRevenue, completionRate: $completionRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentStatisticsDtoImpl &&
            (identical(other.totalAppointments, totalAppointments) ||
                other.totalAppointments == totalAppointments) &&
            (identical(other.totalCompleted, totalCompleted) ||
                other.totalCompleted == totalCompleted) &&
            (identical(other.totalCancelled, totalCancelled) ||
                other.totalCancelled == totalCancelled) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalAppointments,
    totalCompleted,
    totalCancelled,
    totalRevenue,
    completionRate,
  );

  /// Create a copy of AppointmentStatisticsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentStatisticsDtoImplCopyWith<_$AppointmentStatisticsDtoImpl>
  get copyWith =>
      __$$AppointmentStatisticsDtoImplCopyWithImpl<
        _$AppointmentStatisticsDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentStatisticsDtoImplToJson(this);
  }
}

abstract class _AppointmentStatisticsDto implements AppointmentStatisticsDto {
  const factory _AppointmentStatisticsDto({
    required final int totalAppointments,
    required final int totalCompleted,
    required final int totalCancelled,
    required final double totalRevenue,
    required final double completionRate,
  }) = _$AppointmentStatisticsDtoImpl;

  factory _AppointmentStatisticsDto.fromJson(Map<String, dynamic> json) =
      _$AppointmentStatisticsDtoImpl.fromJson;

  @override
  int get totalAppointments;
  @override
  int get totalCompleted;
  @override
  int get totalCancelled;
  @override
  double get totalRevenue;
  @override
  double get completionRate;

  /// Create a copy of AppointmentStatisticsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentStatisticsDtoImplCopyWith<_$AppointmentStatisticsDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CustomerWithHistoryDto _$CustomerWithHistoryDtoFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerWithHistoryDto.fromJson(json);
}

/// @nodoc
mixin _$CustomerWithHistoryDto {
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<AppointmentSummaryDto> get appointments =>
      throw _privateConstructorUsedError;

  /// Serializes this CustomerWithHistoryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerWithHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerWithHistoryDtoCopyWith<CustomerWithHistoryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerWithHistoryDtoCopyWith<$Res> {
  factory $CustomerWithHistoryDtoCopyWith(
    CustomerWithHistoryDto value,
    $Res Function(CustomerWithHistoryDto) then,
  ) = _$CustomerWithHistoryDtoCopyWithImpl<$Res, CustomerWithHistoryDto>;
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    String? phone,
    String? email,
    String? address,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
    List<AppointmentSummaryDto> appointments,
  });
}

/// @nodoc
class _$CustomerWithHistoryDtoCopyWithImpl<
  $Res,
  $Val extends CustomerWithHistoryDto
>
    implements $CustomerWithHistoryDtoCopyWith<$Res> {
  _$CustomerWithHistoryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerWithHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? appointments = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            appointments: null == appointments
                ? _value.appointments
                : appointments // ignore: cast_nullable_to_non_nullable
                      as List<AppointmentSummaryDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerWithHistoryDtoImplCopyWith<$Res>
    implements $CustomerWithHistoryDtoCopyWith<$Res> {
  factory _$$CustomerWithHistoryDtoImplCopyWith(
    _$CustomerWithHistoryDtoImpl value,
    $Res Function(_$CustomerWithHistoryDtoImpl) then,
  ) = __$$CustomerWithHistoryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    String? phone,
    String? email,
    String? address,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
    List<AppointmentSummaryDto> appointments,
  });
}

/// @nodoc
class __$$CustomerWithHistoryDtoImplCopyWithImpl<$Res>
    extends
        _$CustomerWithHistoryDtoCopyWithImpl<$Res, _$CustomerWithHistoryDtoImpl>
    implements _$$CustomerWithHistoryDtoImplCopyWith<$Res> {
  __$$CustomerWithHistoryDtoImplCopyWithImpl(
    _$CustomerWithHistoryDtoImpl _value,
    $Res Function(_$CustomerWithHistoryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerWithHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? appointments = null,
  }) {
    return _then(
      _$CustomerWithHistoryDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        appointments: null == appointments
            ? _value._appointments
            : appointments // ignore: cast_nullable_to_non_nullable
                  as List<AppointmentSummaryDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerWithHistoryDtoImpl implements _CustomerWithHistoryDto {
  const _$CustomerWithHistoryDtoImpl({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.email,
    this.address,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    final List<AppointmentSummaryDto> appointments = const [],
  }) : _appointments = appointments;

  factory _$CustomerWithHistoryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerWithHistoryDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? address;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<AppointmentSummaryDto> _appointments;
  @override
  @JsonKey()
  List<AppointmentSummaryDto> get appointments {
    if (_appointments is EqualUnmodifiableListView) return _appointments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appointments);
  }

  @override
  String toString() {
    return 'CustomerWithHistoryDto(id: $id, firstName: $firstName, lastName: $lastName, phone: $phone, email: $email, address: $address, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, appointments: $appointments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerWithHistoryDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(
              other._appointments,
              _appointments,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    firstName,
    lastName,
    phone,
    email,
    address,
    notes,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_appointments),
  );

  /// Create a copy of CustomerWithHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerWithHistoryDtoImplCopyWith<_$CustomerWithHistoryDtoImpl>
  get copyWith =>
      __$$CustomerWithHistoryDtoImplCopyWithImpl<_$CustomerWithHistoryDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerWithHistoryDtoImplToJson(this);
  }
}

abstract class _CustomerWithHistoryDto implements CustomerWithHistoryDto {
  const factory _CustomerWithHistoryDto({
    required final String id,
    required final String firstName,
    required final String lastName,
    final String? phone,
    final String? email,
    final String? address,
    final String? notes,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final List<AppointmentSummaryDto> appointments,
  }) = _$CustomerWithHistoryDtoImpl;

  factory _CustomerWithHistoryDto.fromJson(Map<String, dynamic> json) =
      _$CustomerWithHistoryDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get address;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<AppointmentSummaryDto> get appointments;

  /// Create a copy of CustomerWithHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerWithHistoryDtoImplCopyWith<_$CustomerWithHistoryDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
