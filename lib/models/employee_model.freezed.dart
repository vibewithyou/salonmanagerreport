// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Employee _$EmployeeFromJson(Map<String, dynamic> json) {
  return _Employee.fromJson(json);
}

/// @nodoc
mixin _$Employee {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get role =>
      throw _privateConstructorUsedError; // manager, stylist, receptionist, other
  List<String> get specialties =>
      throw _privateConstructorUsedError; // list of service IDs
  double? get commission =>
      throw _privateConstructorUsedError; // commission percentage
  String? get ssn => throw _privateConstructorUsedError;
  DateTime? get hireDate => throw _privateConstructorUsedError;
  DateTime? get birthDate => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  int? get yearsOfExperience => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Employee to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeCopyWith<Employee> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeCopyWith<$Res> {
  factory $EmployeeCopyWith(Employee value, $Res Function(Employee) then) =
      _$EmployeeCopyWithImpl<$Res, Employee>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String firstName,
    String lastName,
    String email,
    String phone,
    String role,
    List<String> specialties,
    double? commission,
    String? ssn,
    DateTime? hireDate,
    DateTime? birthDate,
    String? address,
    bool? isActive,
    int? yearsOfExperience,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$EmployeeCopyWithImpl<$Res, $Val extends Employee>
    implements $EmployeeCopyWith<$Res> {
  _$EmployeeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phone = null,
    Object? role = null,
    Object? specialties = null,
    Object? commission = freezed,
    Object? ssn = freezed,
    Object? hireDate = freezed,
    Object? birthDate = freezed,
    Object? address = freezed,
    Object? isActive = freezed,
    Object? yearsOfExperience = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            specialties: null == specialties
                ? _value.specialties
                : specialties // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            commission: freezed == commission
                ? _value.commission
                : commission // ignore: cast_nullable_to_non_nullable
                      as double?,
            ssn: freezed == ssn
                ? _value.ssn
                : ssn // ignore: cast_nullable_to_non_nullable
                      as String?,
            hireDate: freezed == hireDate
                ? _value.hireDate
                : hireDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            birthDate: freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: freezed == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool?,
            yearsOfExperience: freezed == yearsOfExperience
                ? _value.yearsOfExperience
                : yearsOfExperience // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeImplCopyWith<$Res>
    implements $EmployeeCopyWith<$Res> {
  factory _$$EmployeeImplCopyWith(
    _$EmployeeImpl value,
    $Res Function(_$EmployeeImpl) then,
  ) = __$$EmployeeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String firstName,
    String lastName,
    String email,
    String phone,
    String role,
    List<String> specialties,
    double? commission,
    String? ssn,
    DateTime? hireDate,
    DateTime? birthDate,
    String? address,
    bool? isActive,
    int? yearsOfExperience,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$EmployeeImplCopyWithImpl<$Res>
    extends _$EmployeeCopyWithImpl<$Res, _$EmployeeImpl>
    implements _$$EmployeeImplCopyWith<$Res> {
  __$$EmployeeImplCopyWithImpl(
    _$EmployeeImpl _value,
    $Res Function(_$EmployeeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phone = null,
    Object? role = null,
    Object? specialties = null,
    Object? commission = freezed,
    Object? ssn = freezed,
    Object? hireDate = freezed,
    Object? birthDate = freezed,
    Object? address = freezed,
    Object? isActive = freezed,
    Object? yearsOfExperience = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$EmployeeImpl(
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
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        specialties: null == specialties
            ? _value._specialties
            : specialties // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        commission: freezed == commission
            ? _value.commission
            : commission // ignore: cast_nullable_to_non_nullable
                  as double?,
        ssn: freezed == ssn
            ? _value.ssn
            : ssn // ignore: cast_nullable_to_non_nullable
                  as String?,
        hireDate: freezed == hireDate
            ? _value.hireDate
            : hireDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        birthDate: freezed == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: freezed == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool?,
        yearsOfExperience: freezed == yearsOfExperience
            ? _value.yearsOfExperience
            : yearsOfExperience // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeImpl implements _Employee {
  const _$EmployeeImpl({
    required this.id,
    required this.salonId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    required final List<String> specialties,
    this.commission,
    this.ssn,
    this.hireDate,
    this.birthDate,
    this.address,
    this.isActive,
    this.yearsOfExperience,
    this.createdAt,
    this.updatedAt,
  }) : _specialties = specialties;

  factory _$EmployeeImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String role;
  // manager, stylist, receptionist, other
  final List<String> _specialties;
  // manager, stylist, receptionist, other
  @override
  List<String> get specialties {
    if (_specialties is EqualUnmodifiableListView) return _specialties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialties);
  }

  // list of service IDs
  @override
  final double? commission;
  // commission percentage
  @override
  final String? ssn;
  @override
  final DateTime? hireDate;
  @override
  final DateTime? birthDate;
  @override
  final String? address;
  @override
  final bool? isActive;
  @override
  final int? yearsOfExperience;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Employee(id: $id, salonId: $salonId, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, role: $role, specialties: $specialties, commission: $commission, ssn: $ssn, hireDate: $hireDate, birthDate: $birthDate, address: $address, isActive: $isActive, yearsOfExperience: $yearsOfExperience, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality().equals(
              other._specialties,
              _specialties,
            ) &&
            (identical(other.commission, commission) ||
                other.commission == commission) &&
            (identical(other.ssn, ssn) || other.ssn == ssn) &&
            (identical(other.hireDate, hireDate) ||
                other.hireDate == hireDate) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.yearsOfExperience, yearsOfExperience) ||
                other.yearsOfExperience == yearsOfExperience) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    firstName,
    lastName,
    email,
    phone,
    role,
    const DeepCollectionEquality().hash(_specialties),
    commission,
    ssn,
    hireDate,
    birthDate,
    address,
    isActive,
    yearsOfExperience,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeImplCopyWith<_$EmployeeImpl> get copyWith =>
      __$$EmployeeImplCopyWithImpl<_$EmployeeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeImplToJson(this);
  }
}

abstract class _Employee implements Employee {
  const factory _Employee({
    required final String id,
    required final String salonId,
    required final String firstName,
    required final String lastName,
    required final String email,
    required final String phone,
    required final String role,
    required final List<String> specialties,
    final double? commission,
    final String? ssn,
    final DateTime? hireDate,
    final DateTime? birthDate,
    final String? address,
    final bool? isActive,
    final int? yearsOfExperience,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$EmployeeImpl;

  factory _Employee.fromJson(Map<String, dynamic> json) =
      _$EmployeeImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get email;
  @override
  String get phone;
  @override
  String get role; // manager, stylist, receptionist, other
  @override
  List<String> get specialties; // list of service IDs
  @override
  double? get commission; // commission percentage
  @override
  String? get ssn;
  @override
  DateTime? get hireDate;
  @override
  DateTime? get birthDate;
  @override
  String? get address;
  @override
  bool? get isActive;
  @override
  int? get yearsOfExperience;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeImplCopyWith<_$EmployeeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeeSchedule _$EmployeeScheduleFromJson(Map<String, dynamic> json) {
  return _EmployeeSchedule.fromJson(json);
}

/// @nodoc
mixin _$EmployeeSchedule {
  String get id => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get dayOfWeek =>
      throw _privateConstructorUsedError; // monday, tuesday, etc.
  String get startTime => throw _privateConstructorUsedError; // HH:mm format
  String get endTime => throw _privateConstructorUsedError; // HH:mm format
  String? get notes => throw _privateConstructorUsedError;
  bool? get isOffDay => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EmployeeSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeScheduleCopyWith<EmployeeSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeScheduleCopyWith<$Res> {
  factory $EmployeeScheduleCopyWith(
    EmployeeSchedule value,
    $Res Function(EmployeeSchedule) then,
  ) = _$EmployeeScheduleCopyWithImpl<$Res, EmployeeSchedule>;
  @useResult
  $Res call({
    String id,
    String employeeId,
    String salonId,
    String dayOfWeek,
    String startTime,
    String endTime,
    String? notes,
    bool? isOffDay,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$EmployeeScheduleCopyWithImpl<$Res, $Val extends EmployeeSchedule>
    implements $EmployeeScheduleCopyWith<$Res> {
  _$EmployeeScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? salonId = null,
    Object? dayOfWeek = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? notes = freezed,
    Object? isOffDay = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            salonId: null == salonId
                ? _value.salonId
                : salonId // ignore: cast_nullable_to_non_nullable
                      as String,
            dayOfWeek: null == dayOfWeek
                ? _value.dayOfWeek
                : dayOfWeek // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOffDay: freezed == isOffDay
                ? _value.isOffDay
                : isOffDay // ignore: cast_nullable_to_non_nullable
                      as bool?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeScheduleImplCopyWith<$Res>
    implements $EmployeeScheduleCopyWith<$Res> {
  factory _$$EmployeeScheduleImplCopyWith(
    _$EmployeeScheduleImpl value,
    $Res Function(_$EmployeeScheduleImpl) then,
  ) = __$$EmployeeScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String employeeId,
    String salonId,
    String dayOfWeek,
    String startTime,
    String endTime,
    String? notes,
    bool? isOffDay,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$EmployeeScheduleImplCopyWithImpl<$Res>
    extends _$EmployeeScheduleCopyWithImpl<$Res, _$EmployeeScheduleImpl>
    implements _$$EmployeeScheduleImplCopyWith<$Res> {
  __$$EmployeeScheduleImplCopyWithImpl(
    _$EmployeeScheduleImpl _value,
    $Res Function(_$EmployeeScheduleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? salonId = null,
    Object? dayOfWeek = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? notes = freezed,
    Object? isOffDay = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$EmployeeScheduleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        dayOfWeek: null == dayOfWeek
            ? _value.dayOfWeek
            : dayOfWeek // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOffDay: freezed == isOffDay
            ? _value.isOffDay
            : isOffDay // ignore: cast_nullable_to_non_nullable
                  as bool?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeScheduleImpl implements _EmployeeSchedule {
  const _$EmployeeScheduleImpl({
    required this.id,
    required this.employeeId,
    required this.salonId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.notes,
    this.isOffDay,
    this.createdAt,
    this.updatedAt,
  });

  factory _$EmployeeScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeScheduleImplFromJson(json);

  @override
  final String id;
  @override
  final String employeeId;
  @override
  final String salonId;
  @override
  final String dayOfWeek;
  // monday, tuesday, etc.
  @override
  final String startTime;
  // HH:mm format
  @override
  final String endTime;
  // HH:mm format
  @override
  final String? notes;
  @override
  final bool? isOffDay;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'EmployeeSchedule(id: $id, employeeId: $employeeId, salonId: $salonId, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, notes: $notes, isOffDay: $isOffDay, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeScheduleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isOffDay, isOffDay) ||
                other.isOffDay == isOffDay) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    employeeId,
    salonId,
    dayOfWeek,
    startTime,
    endTime,
    notes,
    isOffDay,
    createdAt,
    updatedAt,
  );

  /// Create a copy of EmployeeSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeScheduleImplCopyWith<_$EmployeeScheduleImpl> get copyWith =>
      __$$EmployeeScheduleImplCopyWithImpl<_$EmployeeScheduleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeScheduleImplToJson(this);
  }
}

abstract class _EmployeeSchedule implements EmployeeSchedule {
  const factory _EmployeeSchedule({
    required final String id,
    required final String employeeId,
    required final String salonId,
    required final String dayOfWeek,
    required final String startTime,
    required final String endTime,
    final String? notes,
    final bool? isOffDay,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$EmployeeScheduleImpl;

  factory _EmployeeSchedule.fromJson(Map<String, dynamic> json) =
      _$EmployeeScheduleImpl.fromJson;

  @override
  String get id;
  @override
  String get employeeId;
  @override
  String get salonId;
  @override
  String get dayOfWeek; // monday, tuesday, etc.
  @override
  String get startTime; // HH:mm format
  @override
  String get endTime; // HH:mm format
  @override
  String? get notes;
  @override
  bool? get isOffDay;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of EmployeeSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeScheduleImplCopyWith<_$EmployeeScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeeSummary _$EmployeeSummaryFromJson(Map<String, dynamic> json) {
  return _EmployeeSummary.fromJson(json);
}

/// @nodoc
mixin _$EmployeeSummary {
  int get totalEmployees => throw _privateConstructorUsedError;
  int get stylists => throw _privateConstructorUsedError;
  int get managers => throw _privateConstructorUsedError;
  int get receptionists => throw _privateConstructorUsedError;
  int get activeEmployees => throw _privateConstructorUsedError;

  /// Serializes this EmployeeSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeSummaryCopyWith<EmployeeSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeSummaryCopyWith<$Res> {
  factory $EmployeeSummaryCopyWith(
    EmployeeSummary value,
    $Res Function(EmployeeSummary) then,
  ) = _$EmployeeSummaryCopyWithImpl<$Res, EmployeeSummary>;
  @useResult
  $Res call({
    int totalEmployees,
    int stylists,
    int managers,
    int receptionists,
    int activeEmployees,
  });
}

/// @nodoc
class _$EmployeeSummaryCopyWithImpl<$Res, $Val extends EmployeeSummary>
    implements $EmployeeSummaryCopyWith<$Res> {
  _$EmployeeSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEmployees = null,
    Object? stylists = null,
    Object? managers = null,
    Object? receptionists = null,
    Object? activeEmployees = null,
  }) {
    return _then(
      _value.copyWith(
            totalEmployees: null == totalEmployees
                ? _value.totalEmployees
                : totalEmployees // ignore: cast_nullable_to_non_nullable
                      as int,
            stylists: null == stylists
                ? _value.stylists
                : stylists // ignore: cast_nullable_to_non_nullable
                      as int,
            managers: null == managers
                ? _value.managers
                : managers // ignore: cast_nullable_to_non_nullable
                      as int,
            receptionists: null == receptionists
                ? _value.receptionists
                : receptionists // ignore: cast_nullable_to_non_nullable
                      as int,
            activeEmployees: null == activeEmployees
                ? _value.activeEmployees
                : activeEmployees // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeSummaryImplCopyWith<$Res>
    implements $EmployeeSummaryCopyWith<$Res> {
  factory _$$EmployeeSummaryImplCopyWith(
    _$EmployeeSummaryImpl value,
    $Res Function(_$EmployeeSummaryImpl) then,
  ) = __$$EmployeeSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalEmployees,
    int stylists,
    int managers,
    int receptionists,
    int activeEmployees,
  });
}

/// @nodoc
class __$$EmployeeSummaryImplCopyWithImpl<$Res>
    extends _$EmployeeSummaryCopyWithImpl<$Res, _$EmployeeSummaryImpl>
    implements _$$EmployeeSummaryImplCopyWith<$Res> {
  __$$EmployeeSummaryImplCopyWithImpl(
    _$EmployeeSummaryImpl _value,
    $Res Function(_$EmployeeSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEmployees = null,
    Object? stylists = null,
    Object? managers = null,
    Object? receptionists = null,
    Object? activeEmployees = null,
  }) {
    return _then(
      _$EmployeeSummaryImpl(
        totalEmployees: null == totalEmployees
            ? _value.totalEmployees
            : totalEmployees // ignore: cast_nullable_to_non_nullable
                  as int,
        stylists: null == stylists
            ? _value.stylists
            : stylists // ignore: cast_nullable_to_non_nullable
                  as int,
        managers: null == managers
            ? _value.managers
            : managers // ignore: cast_nullable_to_non_nullable
                  as int,
        receptionists: null == receptionists
            ? _value.receptionists
            : receptionists // ignore: cast_nullable_to_non_nullable
                  as int,
        activeEmployees: null == activeEmployees
            ? _value.activeEmployees
            : activeEmployees // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeSummaryImpl implements _EmployeeSummary {
  const _$EmployeeSummaryImpl({
    required this.totalEmployees,
    required this.stylists,
    required this.managers,
    required this.receptionists,
    required this.activeEmployees,
  });

  factory _$EmployeeSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeSummaryImplFromJson(json);

  @override
  final int totalEmployees;
  @override
  final int stylists;
  @override
  final int managers;
  @override
  final int receptionists;
  @override
  final int activeEmployees;

  @override
  String toString() {
    return 'EmployeeSummary(totalEmployees: $totalEmployees, stylists: $stylists, managers: $managers, receptionists: $receptionists, activeEmployees: $activeEmployees)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeSummaryImpl &&
            (identical(other.totalEmployees, totalEmployees) ||
                other.totalEmployees == totalEmployees) &&
            (identical(other.stylists, stylists) ||
                other.stylists == stylists) &&
            (identical(other.managers, managers) ||
                other.managers == managers) &&
            (identical(other.receptionists, receptionists) ||
                other.receptionists == receptionists) &&
            (identical(other.activeEmployees, activeEmployees) ||
                other.activeEmployees == activeEmployees));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalEmployees,
    stylists,
    managers,
    receptionists,
    activeEmployees,
  );

  /// Create a copy of EmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeSummaryImplCopyWith<_$EmployeeSummaryImpl> get copyWith =>
      __$$EmployeeSummaryImplCopyWithImpl<_$EmployeeSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeSummaryImplToJson(this);
  }
}

abstract class _EmployeeSummary implements EmployeeSummary {
  const factory _EmployeeSummary({
    required final int totalEmployees,
    required final int stylists,
    required final int managers,
    required final int receptionists,
    required final int activeEmployees,
  }) = _$EmployeeSummaryImpl;

  factory _EmployeeSummary.fromJson(Map<String, dynamic> json) =
      _$EmployeeSummaryImpl.fromJson;

  @override
  int get totalEmployees;
  @override
  int get stylists;
  @override
  int get managers;
  @override
  int get receptionists;
  @override
  int get activeEmployees;

  /// Create a copy of EmployeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeSummaryImplCopyWith<_$EmployeeSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
