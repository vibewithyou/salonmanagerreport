// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_entry_model.dart';

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
  String get employeeId => throw _privateConstructorUsedError;
  String get employeeName => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  DateTime get checkInTime => throw _privateConstructorUsedError;
  DateTime? get checkOutTime => throw _privateConstructorUsedError;
  int? get totalMinutes => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

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
    String employeeId,
    String employeeName,
    String salonId,
    DateTime checkInTime,
    DateTime? checkOutTime,
    int? totalMinutes,
    String? notes,
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
    Object? employeeId = null,
    Object? employeeName = null,
    Object? salonId = null,
    Object? checkInTime = null,
    Object? checkOutTime = freezed,
    Object? totalMinutes = freezed,
    Object? notes = freezed,
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
            employeeName: null == employeeName
                ? _value.employeeName
                : employeeName // ignore: cast_nullable_to_non_nullable
                      as String,
            salonId: null == salonId
                ? _value.salonId
                : salonId // ignore: cast_nullable_to_non_nullable
                      as String,
            checkInTime: null == checkInTime
                ? _value.checkInTime
                : checkInTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            checkOutTime: freezed == checkOutTime
                ? _value.checkOutTime
                : checkOutTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            totalMinutes: freezed == totalMinutes
                ? _value.totalMinutes
                : totalMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
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
    String employeeId,
    String employeeName,
    String salonId,
    DateTime checkInTime,
    DateTime? checkOutTime,
    int? totalMinutes,
    String? notes,
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
    Object? employeeId = null,
    Object? employeeName = null,
    Object? salonId = null,
    Object? checkInTime = null,
    Object? checkOutTime = freezed,
    Object? totalMinutes = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$TimeEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeName: null == employeeName
            ? _value.employeeName
            : employeeName // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        checkInTime: null == checkInTime
            ? _value.checkInTime
            : checkInTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        checkOutTime: freezed == checkOutTime
            ? _value.checkOutTime
            : checkOutTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        totalMinutes: freezed == totalMinutes
            ? _value.totalMinutes
            : totalMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
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
class _$TimeEntryImpl implements _TimeEntry {
  const _$TimeEntryImpl({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.salonId,
    required this.checkInTime,
    this.checkOutTime,
    this.totalMinutes,
    this.notes,
  });

  factory _$TimeEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String employeeId;
  @override
  final String employeeName;
  @override
  final String salonId;
  @override
  final DateTime checkInTime;
  @override
  final DateTime? checkOutTime;
  @override
  final int? totalMinutes;
  @override
  final String? notes;

  @override
  String toString() {
    return 'TimeEntry(id: $id, employeeId: $employeeId, employeeName: $employeeName, salonId: $salonId, checkInTime: $checkInTime, checkOutTime: $checkOutTime, totalMinutes: $totalMinutes, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.checkInTime, checkInTime) ||
                other.checkInTime == checkInTime) &&
            (identical(other.checkOutTime, checkOutTime) ||
                other.checkOutTime == checkOutTime) &&
            (identical(other.totalMinutes, totalMinutes) ||
                other.totalMinutes == totalMinutes) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    employeeId,
    employeeName,
    salonId,
    checkInTime,
    checkOutTime,
    totalMinutes,
    notes,
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
    required final String employeeId,
    required final String employeeName,
    required final String salonId,
    required final DateTime checkInTime,
    final DateTime? checkOutTime,
    final int? totalMinutes,
    final String? notes,
  }) = _$TimeEntryImpl;

  factory _TimeEntry.fromJson(Map<String, dynamic> json) =
      _$TimeEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get employeeId;
  @override
  String get employeeName;
  @override
  String get salonId;
  @override
  DateTime get checkInTime;
  @override
  DateTime? get checkOutTime;
  @override
  int? get totalMinutes;
  @override
  String? get notes;

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeEntryImplCopyWith<_$TimeEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimeEntryStatus _$TimeEntryStatusFromJson(Map<String, dynamic> json) {
  return _TimeEntryStatus.fromJson(json);
}

/// @nodoc
mixin _$TimeEntryStatus {
  bool get isCheckedIn => throw _privateConstructorUsedError;
  TimeEntry? get currentEntry => throw _privateConstructorUsedError;
  int? get todayMinutes => throw _privateConstructorUsedError;
  int? get weekMinutes => throw _privateConstructorUsedError;

  /// Serializes this TimeEntryStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeEntryStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeEntryStatusCopyWith<TimeEntryStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeEntryStatusCopyWith<$Res> {
  factory $TimeEntryStatusCopyWith(
    TimeEntryStatus value,
    $Res Function(TimeEntryStatus) then,
  ) = _$TimeEntryStatusCopyWithImpl<$Res, TimeEntryStatus>;
  @useResult
  $Res call({
    bool isCheckedIn,
    TimeEntry? currentEntry,
    int? todayMinutes,
    int? weekMinutes,
  });

  $TimeEntryCopyWith<$Res>? get currentEntry;
}

/// @nodoc
class _$TimeEntryStatusCopyWithImpl<$Res, $Val extends TimeEntryStatus>
    implements $TimeEntryStatusCopyWith<$Res> {
  _$TimeEntryStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeEntryStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCheckedIn = null,
    Object? currentEntry = freezed,
    Object? todayMinutes = freezed,
    Object? weekMinutes = freezed,
  }) {
    return _then(
      _value.copyWith(
            isCheckedIn: null == isCheckedIn
                ? _value.isCheckedIn
                : isCheckedIn // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentEntry: freezed == currentEntry
                ? _value.currentEntry
                : currentEntry // ignore: cast_nullable_to_non_nullable
                      as TimeEntry?,
            todayMinutes: freezed == todayMinutes
                ? _value.todayMinutes
                : todayMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            weekMinutes: freezed == weekMinutes
                ? _value.weekMinutes
                : weekMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }

  /// Create a copy of TimeEntryStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimeEntryCopyWith<$Res>? get currentEntry {
    if (_value.currentEntry == null) {
      return null;
    }

    return $TimeEntryCopyWith<$Res>(_value.currentEntry!, (value) {
      return _then(_value.copyWith(currentEntry: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TimeEntryStatusImplCopyWith<$Res>
    implements $TimeEntryStatusCopyWith<$Res> {
  factory _$$TimeEntryStatusImplCopyWith(
    _$TimeEntryStatusImpl value,
    $Res Function(_$TimeEntryStatusImpl) then,
  ) = __$$TimeEntryStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isCheckedIn,
    TimeEntry? currentEntry,
    int? todayMinutes,
    int? weekMinutes,
  });

  @override
  $TimeEntryCopyWith<$Res>? get currentEntry;
}

/// @nodoc
class __$$TimeEntryStatusImplCopyWithImpl<$Res>
    extends _$TimeEntryStatusCopyWithImpl<$Res, _$TimeEntryStatusImpl>
    implements _$$TimeEntryStatusImplCopyWith<$Res> {
  __$$TimeEntryStatusImplCopyWithImpl(
    _$TimeEntryStatusImpl _value,
    $Res Function(_$TimeEntryStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeEntryStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCheckedIn = null,
    Object? currentEntry = freezed,
    Object? todayMinutes = freezed,
    Object? weekMinutes = freezed,
  }) {
    return _then(
      _$TimeEntryStatusImpl(
        isCheckedIn: null == isCheckedIn
            ? _value.isCheckedIn
            : isCheckedIn // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentEntry: freezed == currentEntry
            ? _value.currentEntry
            : currentEntry // ignore: cast_nullable_to_non_nullable
                  as TimeEntry?,
        todayMinutes: freezed == todayMinutes
            ? _value.todayMinutes
            : todayMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        weekMinutes: freezed == weekMinutes
            ? _value.weekMinutes
            : weekMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeEntryStatusImpl implements _TimeEntryStatus {
  const _$TimeEntryStatusImpl({
    required this.isCheckedIn,
    this.currentEntry,
    this.todayMinutes,
    this.weekMinutes,
  });

  factory _$TimeEntryStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeEntryStatusImplFromJson(json);

  @override
  final bool isCheckedIn;
  @override
  final TimeEntry? currentEntry;
  @override
  final int? todayMinutes;
  @override
  final int? weekMinutes;

  @override
  String toString() {
    return 'TimeEntryStatus(isCheckedIn: $isCheckedIn, currentEntry: $currentEntry, todayMinutes: $todayMinutes, weekMinutes: $weekMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeEntryStatusImpl &&
            (identical(other.isCheckedIn, isCheckedIn) ||
                other.isCheckedIn == isCheckedIn) &&
            (identical(other.currentEntry, currentEntry) ||
                other.currentEntry == currentEntry) &&
            (identical(other.todayMinutes, todayMinutes) ||
                other.todayMinutes == todayMinutes) &&
            (identical(other.weekMinutes, weekMinutes) ||
                other.weekMinutes == weekMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isCheckedIn,
    currentEntry,
    todayMinutes,
    weekMinutes,
  );

  /// Create a copy of TimeEntryStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeEntryStatusImplCopyWith<_$TimeEntryStatusImpl> get copyWith =>
      __$$TimeEntryStatusImplCopyWithImpl<_$TimeEntryStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeEntryStatusImplToJson(this);
  }
}

abstract class _TimeEntryStatus implements TimeEntryStatus {
  const factory _TimeEntryStatus({
    required final bool isCheckedIn,
    final TimeEntry? currentEntry,
    final int? todayMinutes,
    final int? weekMinutes,
  }) = _$TimeEntryStatusImpl;

  factory _TimeEntryStatus.fromJson(Map<String, dynamic> json) =
      _$TimeEntryStatusImpl.fromJson;

  @override
  bool get isCheckedIn;
  @override
  TimeEntry? get currentEntry;
  @override
  int? get todayMinutes;
  @override
  int? get weekMinutes;

  /// Create a copy of TimeEntryStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeEntryStatusImplCopyWith<_$TimeEntryStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
