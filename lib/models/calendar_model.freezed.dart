// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) {
  return _CalendarEvent.fromJson(json);
}

/// @nodoc
mixin _$CalendarEvent {
  String? get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String get eventType =>
      throw _privateConstructorUsedError; // appointment, break, holiday, event
  String get status =>
      throw _privateConstructorUsedError; // scheduled, completed, cancelled
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CalendarEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarEventCopyWith<CalendarEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarEventCopyWith<$Res> {
  factory $CalendarEventCopyWith(
    CalendarEvent value,
    $Res Function(CalendarEvent) then,
  ) = _$CalendarEventCopyWithImpl<$Res, CalendarEvent>;
  @useResult
  $Res call({
    String? id,
    String salonId,
    String title,
    String? description,
    DateTime startTime,
    DateTime endTime,
    String eventType,
    String status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$CalendarEventCopyWithImpl<$Res, $Val extends CalendarEvent>
    implements $CalendarEventCopyWith<$Res> {
  _$CalendarEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? salonId = null,
    Object? title = null,
    Object? description = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? eventType = null,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            salonId: null == salonId
                ? _value.salonId
                : salonId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            eventType: null == eventType
                ? _value.eventType
                : eventType // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$CalendarEventImplCopyWith<$Res>
    implements $CalendarEventCopyWith<$Res> {
  factory _$$CalendarEventImplCopyWith(
    _$CalendarEventImpl value,
    $Res Function(_$CalendarEventImpl) then,
  ) = __$$CalendarEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String salonId,
    String title,
    String? description,
    DateTime startTime,
    DateTime endTime,
    String eventType,
    String status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$CalendarEventImplCopyWithImpl<$Res>
    extends _$CalendarEventCopyWithImpl<$Res, _$CalendarEventImpl>
    implements _$$CalendarEventImplCopyWith<$Res> {
  __$$CalendarEventImplCopyWithImpl(
    _$CalendarEventImpl _value,
    $Res Function(_$CalendarEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? salonId = null,
    Object? title = null,
    Object? description = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? eventType = null,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CalendarEventImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        eventType: null == eventType
            ? _value.eventType
            : eventType // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$CalendarEventImpl implements _CalendarEvent {
  const _$CalendarEventImpl({
    this.id,
    required this.salonId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.eventType,
    required this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory _$CalendarEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarEventImplFromJson(json);

  @override
  final String? id;
  @override
  final String salonId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String eventType;
  // appointment, break, holiday, event
  @override
  final String status;
  // scheduled, completed, cancelled
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CalendarEvent(id: $id, salonId: $salonId, title: $title, description: $description, startTime: $startTime, endTime: $endTime, eventType: $eventType, status: $status, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
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
    title,
    description,
    startTime,
    endTime,
    eventType,
    status,
    notes,
    createdAt,
    updatedAt,
  );

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarEventImplCopyWith<_$CalendarEventImpl> get copyWith =>
      __$$CalendarEventImplCopyWithImpl<_$CalendarEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalendarEventImplToJson(this);
  }
}

abstract class _CalendarEvent implements CalendarEvent {
  const factory _CalendarEvent({
    final String? id,
    required final String salonId,
    required final String title,
    final String? description,
    required final DateTime startTime,
    required final DateTime endTime,
    required final String eventType,
    required final String status,
    final String? notes,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$CalendarEventImpl;

  factory _CalendarEvent.fromJson(Map<String, dynamic> json) =
      _$CalendarEventImpl.fromJson;

  @override
  String? get id;
  @override
  String get salonId;
  @override
  String get title;
  @override
  String? get description;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  String get eventType; // appointment, break, holiday, event
  @override
  String get status; // scheduled, completed, cancelled
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarEventImplCopyWith<_$CalendarEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppointmentSummary _$AppointmentSummaryFromJson(Map<String, dynamic> json) {
  return _AppointmentSummary.fromJson(json);
}

/// @nodoc
mixin _$AppointmentSummary {
  int get totalAppointments => throw _privateConstructorUsedError;
  int get completedAppointments => throw _privateConstructorUsedError;
  int get cancelledAppointments => throw _privateConstructorUsedError;
  int get pendingAppointments => throw _privateConstructorUsedError;

  /// Serializes this AppointmentSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentSummaryCopyWith<AppointmentSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentSummaryCopyWith<$Res> {
  factory $AppointmentSummaryCopyWith(
    AppointmentSummary value,
    $Res Function(AppointmentSummary) then,
  ) = _$AppointmentSummaryCopyWithImpl<$Res, AppointmentSummary>;
  @useResult
  $Res call({
    int totalAppointments,
    int completedAppointments,
    int cancelledAppointments,
    int pendingAppointments,
  });
}

/// @nodoc
class _$AppointmentSummaryCopyWithImpl<$Res, $Val extends AppointmentSummary>
    implements $AppointmentSummaryCopyWith<$Res> {
  _$AppointmentSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAppointments = null,
    Object? completedAppointments = null,
    Object? cancelledAppointments = null,
    Object? pendingAppointments = null,
  }) {
    return _then(
      _value.copyWith(
            totalAppointments: null == totalAppointments
                ? _value.totalAppointments
                : totalAppointments // ignore: cast_nullable_to_non_nullable
                      as int,
            completedAppointments: null == completedAppointments
                ? _value.completedAppointments
                : completedAppointments // ignore: cast_nullable_to_non_nullable
                      as int,
            cancelledAppointments: null == cancelledAppointments
                ? _value.cancelledAppointments
                : cancelledAppointments // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingAppointments: null == pendingAppointments
                ? _value.pendingAppointments
                : pendingAppointments // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppointmentSummaryImplCopyWith<$Res>
    implements $AppointmentSummaryCopyWith<$Res> {
  factory _$$AppointmentSummaryImplCopyWith(
    _$AppointmentSummaryImpl value,
    $Res Function(_$AppointmentSummaryImpl) then,
  ) = __$$AppointmentSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalAppointments,
    int completedAppointments,
    int cancelledAppointments,
    int pendingAppointments,
  });
}

/// @nodoc
class __$$AppointmentSummaryImplCopyWithImpl<$Res>
    extends _$AppointmentSummaryCopyWithImpl<$Res, _$AppointmentSummaryImpl>
    implements _$$AppointmentSummaryImplCopyWith<$Res> {
  __$$AppointmentSummaryImplCopyWithImpl(
    _$AppointmentSummaryImpl _value,
    $Res Function(_$AppointmentSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppointmentSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAppointments = null,
    Object? completedAppointments = null,
    Object? cancelledAppointments = null,
    Object? pendingAppointments = null,
  }) {
    return _then(
      _$AppointmentSummaryImpl(
        totalAppointments: null == totalAppointments
            ? _value.totalAppointments
            : totalAppointments // ignore: cast_nullable_to_non_nullable
                  as int,
        completedAppointments: null == completedAppointments
            ? _value.completedAppointments
            : completedAppointments // ignore: cast_nullable_to_non_nullable
                  as int,
        cancelledAppointments: null == cancelledAppointments
            ? _value.cancelledAppointments
            : cancelledAppointments // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingAppointments: null == pendingAppointments
            ? _value.pendingAppointments
            : pendingAppointments // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentSummaryImpl implements _AppointmentSummary {
  const _$AppointmentSummaryImpl({
    required this.totalAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
    required this.pendingAppointments,
  });

  factory _$AppointmentSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentSummaryImplFromJson(json);

  @override
  final int totalAppointments;
  @override
  final int completedAppointments;
  @override
  final int cancelledAppointments;
  @override
  final int pendingAppointments;

  @override
  String toString() {
    return 'AppointmentSummary(totalAppointments: $totalAppointments, completedAppointments: $completedAppointments, cancelledAppointments: $cancelledAppointments, pendingAppointments: $pendingAppointments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentSummaryImpl &&
            (identical(other.totalAppointments, totalAppointments) ||
                other.totalAppointments == totalAppointments) &&
            (identical(other.completedAppointments, completedAppointments) ||
                other.completedAppointments == completedAppointments) &&
            (identical(other.cancelledAppointments, cancelledAppointments) ||
                other.cancelledAppointments == cancelledAppointments) &&
            (identical(other.pendingAppointments, pendingAppointments) ||
                other.pendingAppointments == pendingAppointments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalAppointments,
    completedAppointments,
    cancelledAppointments,
    pendingAppointments,
  );

  /// Create a copy of AppointmentSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentSummaryImplCopyWith<_$AppointmentSummaryImpl> get copyWith =>
      __$$AppointmentSummaryImplCopyWithImpl<_$AppointmentSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentSummaryImplToJson(this);
  }
}

abstract class _AppointmentSummary implements AppointmentSummary {
  const factory _AppointmentSummary({
    required final int totalAppointments,
    required final int completedAppointments,
    required final int cancelledAppointments,
    required final int pendingAppointments,
  }) = _$AppointmentSummaryImpl;

  factory _AppointmentSummary.fromJson(Map<String, dynamic> json) =
      _$AppointmentSummaryImpl.fromJson;

  @override
  int get totalAppointments;
  @override
  int get completedAppointments;
  @override
  int get cancelledAppointments;
  @override
  int get pendingAppointments;

  /// Create a copy of AppointmentSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentSummaryImplCopyWith<_$AppointmentSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
