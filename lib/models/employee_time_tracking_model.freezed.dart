// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_time_tracking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TimeEntry _$TimeEntryFromJson(Map<String, dynamic> json) {
  return _TimeEntry.fromJson(json);
}

/// @nodoc
mixin _$TimeEntry {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  TimeEntryType get entryType => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get adminConfirmed => throw _privateConstructorUsedError;
  String? get adminId => throw _privateConstructorUsedError;
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  int? get durationMinutes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TimeEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeEntryCopyWith<TimeEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeEntryCopyWith<$Res> {
  factory $TimeEntryCopyWith(TimeEntry value, $Res Function(TimeEntry) then) =
      _$TimeEntryCopyWithImpl<$Res, TimeEntry>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String employeeId,
    TimeEntryType entryType,
    DateTime timestamp,
    String? notes,
    bool adminConfirmed,
    String? adminId,
    DateTime? confirmedAt,
    int? durationMinutes,
    DateTime createdAt,
  });
}

/// @nodoc
class _$TimeEntryCopyWithImpl<$Res, $Val extends TimeEntry>
    implements $TimeEntryCopyWith<$Res> {
  _$TimeEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? employeeId = null,
    Object? entryType = null,
    Object? timestamp = null,
    Object? notes = freezed,
    Object? adminConfirmed = null,
    Object? adminId = freezed,
    Object? confirmedAt = freezed,
    Object? durationMinutes = freezed,
    Object? createdAt = null,
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
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as String,
            entryType: null == entryType
                ? _value.entryType
                : entryType // ignore: cast_nullable_to_non_nullable
                      as TimeEntryType,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            adminConfirmed: null == adminConfirmed
                ? _value.adminConfirmed
                : adminConfirmed // ignore: cast_nullable_to_non_nullable
                      as bool,
            adminId: freezed == adminId
                ? _value.adminId
                : adminId // ignore: cast_nullable_to_non_nullable
                      as String?,
            confirmedAt: freezed == confirmedAt
                ? _value.confirmedAt
                : confirmedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            durationMinutes: freezed == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimeEntryImplCopyWith<$Res>
    implements $TimeEntryCopyWith<$Res> {
  factory _$$TimeEntryImplCopyWith(
    _$TimeEntryImpl value,
    $Res Function(_$TimeEntryImpl) then,
  ) = __$$TimeEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String employeeId,
    TimeEntryType entryType,
    DateTime timestamp,
    String? notes,
    bool adminConfirmed,
    String? adminId,
    DateTime? confirmedAt,
    int? durationMinutes,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$TimeEntryImplCopyWithImpl<$Res>
    extends _$TimeEntryCopyWithImpl<$Res, _$TimeEntryImpl>
    implements _$$TimeEntryImplCopyWith<$Res> {
  __$$TimeEntryImplCopyWithImpl(
    _$TimeEntryImpl _value,
    $Res Function(_$TimeEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? employeeId = null,
    Object? entryType = null,
    Object? timestamp = null,
    Object? notes = freezed,
    Object? adminConfirmed = null,
    Object? adminId = freezed,
    Object? confirmedAt = freezed,
    Object? durationMinutes = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$TimeEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        entryType: null == entryType
            ? _value.entryType
            : entryType // ignore: cast_nullable_to_non_nullable
                  as TimeEntryType,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        adminConfirmed: null == adminConfirmed
            ? _value.adminConfirmed
            : adminConfirmed // ignore: cast_nullable_to_non_nullable
                  as bool,
        adminId: freezed == adminId
            ? _value.adminId
            : adminId // ignore: cast_nullable_to_non_nullable
                  as String?,
        confirmedAt: freezed == confirmedAt
            ? _value.confirmedAt
            : confirmedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        durationMinutes: freezed == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeEntryImpl implements _TimeEntry {
  const _$TimeEntryImpl({
    required this.id,
    required this.salonId,
    required this.employeeId,
    required this.entryType,
    required this.timestamp,
    this.notes,
    required this.adminConfirmed,
    this.adminId,
    this.confirmedAt,
    this.durationMinutes,
    required this.createdAt,
  });

  factory _$TimeEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String employeeId;
  @override
  final TimeEntryType entryType;
  @override
  final DateTime timestamp;
  @override
  final String? notes;
  @override
  final bool adminConfirmed;
  @override
  final String? adminId;
  @override
  final DateTime? confirmedAt;
  @override
  final int? durationMinutes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TimeEntry(id: $id, salonId: $salonId, employeeId: $employeeId, entryType: $entryType, timestamp: $timestamp, notes: $notes, adminConfirmed: $adminConfirmed, adminId: $adminId, confirmedAt: $confirmedAt, durationMinutes: $durationMinutes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.entryType, entryType) ||
                other.entryType == entryType) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.adminConfirmed, adminConfirmed) ||
                other.adminConfirmed == adminConfirmed) &&
            (identical(other.adminId, adminId) || other.adminId == adminId) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    employeeId,
    entryType,
    timestamp,
    notes,
    adminConfirmed,
    adminId,
    confirmedAt,
    durationMinutes,
    createdAt,
  );

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeEntryImplCopyWith<_$TimeEntryImpl> get copyWith =>
      __$$TimeEntryImplCopyWithImpl<_$TimeEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeEntryImplToJson(this);
  }
}

abstract class _TimeEntry implements TimeEntry {
  const factory _TimeEntry({
    required final String id,
    required final String salonId,
    required final String employeeId,
    required final TimeEntryType entryType,
    required final DateTime timestamp,
    final String? notes,
    required final bool adminConfirmed,
    final String? adminId,
    final DateTime? confirmedAt,
    final int? durationMinutes,
    required final DateTime createdAt,
  }) = _$TimeEntryImpl;

  factory _TimeEntry.fromJson(Map<String, dynamic> json) =
      _$TimeEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get employeeId;
  @override
  TimeEntryType get entryType;
  @override
  DateTime get timestamp;
  @override
  String? get notes;
  @override
  bool get adminConfirmed;
  @override
  String? get adminId;
  @override
  DateTime? get confirmedAt;
  @override
  int? get durationMinutes;
  @override
  DateTime get createdAt;

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeEntryImplCopyWith<_$TimeEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyWorkload _$DailyWorkloadFromJson(Map<String, dynamic> json) {
  return _DailyWorkload.fromJson(json);
}

/// @nodoc
mixin _$DailyWorkload {
  String get employeeId => throw _privateConstructorUsedError;
  String get employeeName => throw _privateConstructorUsedError;
  int get totalMinutes => throw _privateConstructorUsedError;
  String? get clockInTime => throw _privateConstructorUsedError;
  String? get clockOutTime => throw _privateConstructorUsedError;
  int get breakMinutes => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'working', 'sick', 'absent', 'no_entry'
  bool get isSick => throw _privateConstructorUsedError;
  bool get isAbsent => throw _privateConstructorUsedError;

  /// Serializes this DailyWorkload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyWorkload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyWorkloadCopyWith<DailyWorkload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyWorkloadCopyWith<$Res> {
  factory $DailyWorkloadCopyWith(
    DailyWorkload value,
    $Res Function(DailyWorkload) then,
  ) = _$DailyWorkloadCopyWithImpl<$Res, DailyWorkload>;
  @useResult
  $Res call({
    String employeeId,
    String employeeName,
    int totalMinutes,
    String? clockInTime,
    String? clockOutTime,
    int breakMinutes,
    String status,
    bool isSick,
    bool isAbsent,
  });
}

/// @nodoc
class _$DailyWorkloadCopyWithImpl<$Res, $Val extends DailyWorkload>
    implements $DailyWorkloadCopyWith<$Res> {
  _$DailyWorkloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyWorkload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? totalMinutes = null,
    Object? clockInTime = freezed,
    Object? clockOutTime = freezed,
    Object? breakMinutes = null,
    Object? status = null,
    Object? isSick = null,
    Object? isAbsent = null,
  }) {
    return _then(
      _value.copyWith(
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as String,
            employeeName: null == employeeName
                ? _value.employeeName
                : employeeName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalMinutes: null == totalMinutes
                ? _value.totalMinutes
                : totalMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            clockInTime: freezed == clockInTime
                ? _value.clockInTime
                : clockInTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            clockOutTime: freezed == clockOutTime
                ? _value.clockOutTime
                : clockOutTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            breakMinutes: null == breakMinutes
                ? _value.breakMinutes
                : breakMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            isSick: null == isSick
                ? _value.isSick
                : isSick // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAbsent: null == isAbsent
                ? _value.isAbsent
                : isAbsent // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyWorkloadImplCopyWith<$Res>
    implements $DailyWorkloadCopyWith<$Res> {
  factory _$$DailyWorkloadImplCopyWith(
    _$DailyWorkloadImpl value,
    $Res Function(_$DailyWorkloadImpl) then,
  ) = __$$DailyWorkloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String employeeId,
    String employeeName,
    int totalMinutes,
    String? clockInTime,
    String? clockOutTime,
    int breakMinutes,
    String status,
    bool isSick,
    bool isAbsent,
  });
}

/// @nodoc
class __$$DailyWorkloadImplCopyWithImpl<$Res>
    extends _$DailyWorkloadCopyWithImpl<$Res, _$DailyWorkloadImpl>
    implements _$$DailyWorkloadImplCopyWith<$Res> {
  __$$DailyWorkloadImplCopyWithImpl(
    _$DailyWorkloadImpl _value,
    $Res Function(_$DailyWorkloadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyWorkload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? totalMinutes = null,
    Object? clockInTime = freezed,
    Object? clockOutTime = freezed,
    Object? breakMinutes = null,
    Object? status = null,
    Object? isSick = null,
    Object? isAbsent = null,
  }) {
    return _then(
      _$DailyWorkloadImpl(
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeName: null == employeeName
            ? _value.employeeName
            : employeeName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalMinutes: null == totalMinutes
            ? _value.totalMinutes
            : totalMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        clockInTime: freezed == clockInTime
            ? _value.clockInTime
            : clockInTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        clockOutTime: freezed == clockOutTime
            ? _value.clockOutTime
            : clockOutTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        breakMinutes: null == breakMinutes
            ? _value.breakMinutes
            : breakMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        isSick: null == isSick
            ? _value.isSick
            : isSick // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAbsent: null == isAbsent
            ? _value.isAbsent
            : isAbsent // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyWorkloadImpl implements _DailyWorkload {
  const _$DailyWorkloadImpl({
    required this.employeeId,
    required this.employeeName,
    required this.totalMinutes,
    this.clockInTime,
    this.clockOutTime,
    required this.breakMinutes,
    required this.status,
    required this.isSick,
    required this.isAbsent,
  });

  factory _$DailyWorkloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyWorkloadImplFromJson(json);

  @override
  final String employeeId;
  @override
  final String employeeName;
  @override
  final int totalMinutes;
  @override
  final String? clockInTime;
  @override
  final String? clockOutTime;
  @override
  final int breakMinutes;
  @override
  final String status;
  // 'working', 'sick', 'absent', 'no_entry'
  @override
  final bool isSick;
  @override
  final bool isAbsent;

  @override
  String toString() {
    return 'DailyWorkload(employeeId: $employeeId, employeeName: $employeeName, totalMinutes: $totalMinutes, clockInTime: $clockInTime, clockOutTime: $clockOutTime, breakMinutes: $breakMinutes, status: $status, isSick: $isSick, isAbsent: $isAbsent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyWorkloadImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.totalMinutes, totalMinutes) ||
                other.totalMinutes == totalMinutes) &&
            (identical(other.clockInTime, clockInTime) ||
                other.clockInTime == clockInTime) &&
            (identical(other.clockOutTime, clockOutTime) ||
                other.clockOutTime == clockOutTime) &&
            (identical(other.breakMinutes, breakMinutes) ||
                other.breakMinutes == breakMinutes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isSick, isSick) || other.isSick == isSick) &&
            (identical(other.isAbsent, isAbsent) ||
                other.isAbsent == isAbsent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    employeeId,
    employeeName,
    totalMinutes,
    clockInTime,
    clockOutTime,
    breakMinutes,
    status,
    isSick,
    isAbsent,
  );

  /// Create a copy of DailyWorkload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyWorkloadImplCopyWith<_$DailyWorkloadImpl> get copyWith =>
      __$$DailyWorkloadImplCopyWithImpl<_$DailyWorkloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyWorkloadImplToJson(this);
  }
}

abstract class _DailyWorkload implements DailyWorkload {
  const factory _DailyWorkload({
    required final String employeeId,
    required final String employeeName,
    required final int totalMinutes,
    final String? clockInTime,
    final String? clockOutTime,
    required final int breakMinutes,
    required final String status,
    required final bool isSick,
    required final bool isAbsent,
  }) = _$DailyWorkloadImpl;

  factory _DailyWorkload.fromJson(Map<String, dynamic> json) =
      _$DailyWorkloadImpl.fromJson;

  @override
  String get employeeId;
  @override
  String get employeeName;
  @override
  int get totalMinutes;
  @override
  String? get clockInTime;
  @override
  String? get clockOutTime;
  @override
  int get breakMinutes;
  @override
  String get status; // 'working', 'sick', 'absent', 'no_entry'
  @override
  bool get isSick;
  @override
  bool get isAbsent;

  /// Create a copy of DailyWorkload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyWorkloadImplCopyWith<_$DailyWorkloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeeklyWorkload _$WeeklyWorkloadFromJson(Map<String, dynamic> json) {
  return _WeeklyWorkload.fromJson(json);
}

/// @nodoc
mixin _$WeeklyWorkload {
  String get workDate => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String get employeeName => throw _privateConstructorUsedError;
  double get totalHours => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'working', 'sick', 'absent', 'no_entry'
  bool get isSick => throw _privateConstructorUsedError;
  bool get isAbsent => throw _privateConstructorUsedError;

  /// Serializes this WeeklyWorkload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeeklyWorkload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyWorkloadCopyWith<WeeklyWorkload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyWorkloadCopyWith<$Res> {
  factory $WeeklyWorkloadCopyWith(
    WeeklyWorkload value,
    $Res Function(WeeklyWorkload) then,
  ) = _$WeeklyWorkloadCopyWithImpl<$Res, WeeklyWorkload>;
  @useResult
  $Res call({
    String workDate,
    String employeeId,
    String employeeName,
    double totalHours,
    String status,
    bool isSick,
    bool isAbsent,
  });
}

/// @nodoc
class _$WeeklyWorkloadCopyWithImpl<$Res, $Val extends WeeklyWorkload>
    implements $WeeklyWorkloadCopyWith<$Res> {
  _$WeeklyWorkloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyWorkload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workDate = null,
    Object? employeeId = null,
    Object? employeeName = null,
    Object? totalHours = null,
    Object? status = null,
    Object? isSick = null,
    Object? isAbsent = null,
  }) {
    return _then(
      _value.copyWith(
            workDate: null == workDate
                ? _value.workDate
                : workDate // ignore: cast_nullable_to_non_nullable
                      as String,
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as String,
            employeeName: null == employeeName
                ? _value.employeeName
                : employeeName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalHours: null == totalHours
                ? _value.totalHours
                : totalHours // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            isSick: null == isSick
                ? _value.isSick
                : isSick // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAbsent: null == isAbsent
                ? _value.isAbsent
                : isAbsent // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeeklyWorkloadImplCopyWith<$Res>
    implements $WeeklyWorkloadCopyWith<$Res> {
  factory _$$WeeklyWorkloadImplCopyWith(
    _$WeeklyWorkloadImpl value,
    $Res Function(_$WeeklyWorkloadImpl) then,
  ) = __$$WeeklyWorkloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String workDate,
    String employeeId,
    String employeeName,
    double totalHours,
    String status,
    bool isSick,
    bool isAbsent,
  });
}

/// @nodoc
class __$$WeeklyWorkloadImplCopyWithImpl<$Res>
    extends _$WeeklyWorkloadCopyWithImpl<$Res, _$WeeklyWorkloadImpl>
    implements _$$WeeklyWorkloadImplCopyWith<$Res> {
  __$$WeeklyWorkloadImplCopyWithImpl(
    _$WeeklyWorkloadImpl _value,
    $Res Function(_$WeeklyWorkloadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeeklyWorkload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workDate = null,
    Object? employeeId = null,
    Object? employeeName = null,
    Object? totalHours = null,
    Object? status = null,
    Object? isSick = null,
    Object? isAbsent = null,
  }) {
    return _then(
      _$WeeklyWorkloadImpl(
        workDate: null == workDate
            ? _value.workDate
            : workDate // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeName: null == employeeName
            ? _value.employeeName
            : employeeName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalHours: null == totalHours
            ? _value.totalHours
            : totalHours // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        isSick: null == isSick
            ? _value.isSick
            : isSick // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAbsent: null == isAbsent
            ? _value.isAbsent
            : isAbsent // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyWorkloadImpl implements _WeeklyWorkload {
  const _$WeeklyWorkloadImpl({
    required this.workDate,
    required this.employeeId,
    required this.employeeName,
    required this.totalHours,
    required this.status,
    required this.isSick,
    required this.isAbsent,
  });

  factory _$WeeklyWorkloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyWorkloadImplFromJson(json);

  @override
  final String workDate;
  @override
  final String employeeId;
  @override
  final String employeeName;
  @override
  final double totalHours;
  @override
  final String status;
  // 'working', 'sick', 'absent', 'no_entry'
  @override
  final bool isSick;
  @override
  final bool isAbsent;

  @override
  String toString() {
    return 'WeeklyWorkload(workDate: $workDate, employeeId: $employeeId, employeeName: $employeeName, totalHours: $totalHours, status: $status, isSick: $isSick, isAbsent: $isAbsent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyWorkloadImpl &&
            (identical(other.workDate, workDate) ||
                other.workDate == workDate) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.totalHours, totalHours) ||
                other.totalHours == totalHours) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isSick, isSick) || other.isSick == isSick) &&
            (identical(other.isAbsent, isAbsent) ||
                other.isAbsent == isAbsent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    workDate,
    employeeId,
    employeeName,
    totalHours,
    status,
    isSick,
    isAbsent,
  );

  /// Create a copy of WeeklyWorkload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyWorkloadImplCopyWith<_$WeeklyWorkloadImpl> get copyWith =>
      __$$WeeklyWorkloadImplCopyWithImpl<_$WeeklyWorkloadImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyWorkloadImplToJson(this);
  }
}

abstract class _WeeklyWorkload implements WeeklyWorkload {
  const factory _WeeklyWorkload({
    required final String workDate,
    required final String employeeId,
    required final String employeeName,
    required final double totalHours,
    required final String status,
    required final bool isSick,
    required final bool isAbsent,
  }) = _$WeeklyWorkloadImpl;

  factory _WeeklyWorkload.fromJson(Map<String, dynamic> json) =
      _$WeeklyWorkloadImpl.fromJson;

  @override
  String get workDate;
  @override
  String get employeeId;
  @override
  String get employeeName;
  @override
  double get totalHours;
  @override
  String get status; // 'working', 'sick', 'absent', 'no_entry'
  @override
  bool get isSick;
  @override
  bool get isAbsent;

  /// Create a copy of WeeklyWorkload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyWorkloadImplCopyWith<_$WeeklyWorkloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeeTimeCode _$EmployeeTimeCodeFromJson(Map<String, dynamic> json) {
  return _EmployeeTimeCode.fromJson(json);
}

/// @nodoc
mixin _$EmployeeTimeCode {
  String get id => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String get timeCode => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EmployeeTimeCode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeTimeCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeTimeCodeCopyWith<EmployeeTimeCode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeTimeCodeCopyWith<$Res> {
  factory $EmployeeTimeCodeCopyWith(
    EmployeeTimeCode value,
    $Res Function(EmployeeTimeCode) then,
  ) = _$EmployeeTimeCodeCopyWithImpl<$Res, EmployeeTimeCode>;
  @useResult
  $Res call({
    String id,
    String employeeId,
    String timeCode,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$EmployeeTimeCodeCopyWithImpl<$Res, $Val extends EmployeeTimeCode>
    implements $EmployeeTimeCodeCopyWith<$Res> {
  _$EmployeeTimeCodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeTimeCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? timeCode = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
            timeCode: null == timeCode
                ? _value.timeCode
                : timeCode // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeTimeCodeImplCopyWith<$Res>
    implements $EmployeeTimeCodeCopyWith<$Res> {
  factory _$$EmployeeTimeCodeImplCopyWith(
    _$EmployeeTimeCodeImpl value,
    $Res Function(_$EmployeeTimeCodeImpl) then,
  ) = __$$EmployeeTimeCodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String employeeId,
    String timeCode,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$EmployeeTimeCodeImplCopyWithImpl<$Res>
    extends _$EmployeeTimeCodeCopyWithImpl<$Res, _$EmployeeTimeCodeImpl>
    implements _$$EmployeeTimeCodeImplCopyWith<$Res> {
  __$$EmployeeTimeCodeImplCopyWithImpl(
    _$EmployeeTimeCodeImpl _value,
    $Res Function(_$EmployeeTimeCodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeTimeCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? timeCode = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$EmployeeTimeCodeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        timeCode: null == timeCode
            ? _value.timeCode
            : timeCode // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeTimeCodeImpl implements _EmployeeTimeCode {
  const _$EmployeeTimeCodeImpl({
    required this.id,
    required this.employeeId,
    required this.timeCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$EmployeeTimeCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeTimeCodeImplFromJson(json);

  @override
  final String id;
  @override
  final String employeeId;
  @override
  final String timeCode;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'EmployeeTimeCode(id: $id, employeeId: $employeeId, timeCode: $timeCode, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeTimeCodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.timeCode, timeCode) ||
                other.timeCode == timeCode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, employeeId, timeCode, createdAt, updatedAt);

  /// Create a copy of EmployeeTimeCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeTimeCodeImplCopyWith<_$EmployeeTimeCodeImpl> get copyWith =>
      __$$EmployeeTimeCodeImplCopyWithImpl<_$EmployeeTimeCodeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeTimeCodeImplToJson(this);
  }
}

abstract class _EmployeeTimeCode implements EmployeeTimeCode {
  const factory _EmployeeTimeCode({
    required final String id,
    required final String employeeId,
    required final String timeCode,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$EmployeeTimeCodeImpl;

  factory _EmployeeTimeCode.fromJson(Map<String, dynamic> json) =
      _$EmployeeTimeCodeImpl.fromJson;

  @override
  String get id;
  @override
  String get employeeId;
  @override
  String get timeCode;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of EmployeeTimeCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeTimeCodeImplCopyWith<_$EmployeeTimeCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityLogEntry _$ActivityLogEntryFromJson(Map<String, dynamic> json) {
  return _ActivityLogEntry.fromJson(json);
}

/// @nodoc
mixin _$ActivityLogEntry {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this ActivityLogEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityLogEntryCopyWith<ActivityLogEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityLogEntryCopyWith<$Res> {
  factory $ActivityLogEntryCopyWith(
    ActivityLogEntry value,
    $Res Function(ActivityLogEntry) then,
  ) = _$ActivityLogEntryCopyWithImpl<$Res, ActivityLogEntry>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String userId,
    String action,
    String? description,
    Map<String, dynamic>? metadata,
    DateTime timestamp,
  });
}

/// @nodoc
class _$ActivityLogEntryCopyWithImpl<$Res, $Val extends ActivityLogEntry>
    implements $ActivityLogEntryCopyWith<$Res> {
  _$ActivityLogEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? userId = null,
    Object? action = null,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? timestamp = null,
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
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            action: null == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityLogEntryImplCopyWith<$Res>
    implements $ActivityLogEntryCopyWith<$Res> {
  factory _$$ActivityLogEntryImplCopyWith(
    _$ActivityLogEntryImpl value,
    $Res Function(_$ActivityLogEntryImpl) then,
  ) = __$$ActivityLogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String userId,
    String action,
    String? description,
    Map<String, dynamic>? metadata,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$ActivityLogEntryImplCopyWithImpl<$Res>
    extends _$ActivityLogEntryCopyWithImpl<$Res, _$ActivityLogEntryImpl>
    implements _$$ActivityLogEntryImplCopyWith<$Res> {
  __$$ActivityLogEntryImplCopyWithImpl(
    _$ActivityLogEntryImpl _value,
    $Res Function(_$ActivityLogEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? userId = null,
    Object? action = null,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? timestamp = null,
  }) {
    return _then(
      _$ActivityLogEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        action: null == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityLogEntryImpl implements _ActivityLogEntry {
  const _$ActivityLogEntryImpl({
    required this.id,
    required this.salonId,
    required this.userId,
    required this.action,
    this.description,
    final Map<String, dynamic>? metadata,
    required this.timestamp,
  }) : _metadata = metadata;

  factory _$ActivityLogEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityLogEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String userId;
  @override
  final String action;
  @override
  final String? description;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'ActivityLogEntry(id: $id, salonId: $salonId, userId: $userId, action: $action, description: $description, metadata: $metadata, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityLogEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    userId,
    action,
    description,
    const DeepCollectionEquality().hash(_metadata),
    timestamp,
  );

  /// Create a copy of ActivityLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityLogEntryImplCopyWith<_$ActivityLogEntryImpl> get copyWith =>
      __$$ActivityLogEntryImplCopyWithImpl<_$ActivityLogEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityLogEntryImplToJson(this);
  }
}

abstract class _ActivityLogEntry implements ActivityLogEntry {
  const factory _ActivityLogEntry({
    required final String id,
    required final String salonId,
    required final String userId,
    required final String action,
    final String? description,
    final Map<String, dynamic>? metadata,
    required final DateTime timestamp,
  }) = _$ActivityLogEntryImpl;

  factory _ActivityLogEntry.fromJson(Map<String, dynamic> json) =
      _$ActivityLogEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get userId;
  @override
  String get action;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime get timestamp;

  /// Create a copy of ActivityLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityLogEntryImplCopyWith<_$ActivityLogEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
