// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LeaveRequest _$LeaveRequestFromJson(Map<String, dynamic> json) {
  return _LeaveRequest.fromJson(json);
}

/// @nodoc
mixin _$LeaveRequest {
  String get id => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get requestedAt => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  String? get respondedBy => throw _privateConstructorUsedError;
  String? get employeeName => throw _privateConstructorUsedError;
  String? get employeeAvatar => throw _privateConstructorUsedError;

  /// Serializes this LeaveRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaveRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaveRequestCopyWith<LeaveRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaveRequestCopyWith<$Res> {
  factory $LeaveRequestCopyWith(
    LeaveRequest value,
    $Res Function(LeaveRequest) then,
  ) = _$LeaveRequestCopyWithImpl<$Res, LeaveRequest>;
  @useResult
  $Res call({
    String id,
    String employeeId,
    String salonId,
    DateTime startDate,
    DateTime endDate,
    String reason,
    String status,
    DateTime requestedAt,
    DateTime? respondedAt,
    String? respondedBy,
    String? employeeName,
    String? employeeAvatar,
  });
}

/// @nodoc
class _$LeaveRequestCopyWithImpl<$Res, $Val extends LeaveRequest>
    implements $LeaveRequestCopyWith<$Res> {
  _$LeaveRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaveRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? salonId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? reason = null,
    Object? status = null,
    Object? requestedAt = null,
    Object? respondedAt = freezed,
    Object? respondedBy = freezed,
    Object? employeeName = freezed,
    Object? employeeAvatar = freezed,
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
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            requestedAt: null == requestedAt
                ? _value.requestedAt
                : requestedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            respondedAt: freezed == respondedAt
                ? _value.respondedAt
                : respondedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            respondedBy: freezed == respondedBy
                ? _value.respondedBy
                : respondedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            employeeName: freezed == employeeName
                ? _value.employeeName
                : employeeName // ignore: cast_nullable_to_non_nullable
                      as String?,
            employeeAvatar: freezed == employeeAvatar
                ? _value.employeeAvatar
                : employeeAvatar // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeaveRequestImplCopyWith<$Res>
    implements $LeaveRequestCopyWith<$Res> {
  factory _$$LeaveRequestImplCopyWith(
    _$LeaveRequestImpl value,
    $Res Function(_$LeaveRequestImpl) then,
  ) = __$$LeaveRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String employeeId,
    String salonId,
    DateTime startDate,
    DateTime endDate,
    String reason,
    String status,
    DateTime requestedAt,
    DateTime? respondedAt,
    String? respondedBy,
    String? employeeName,
    String? employeeAvatar,
  });
}

/// @nodoc
class __$$LeaveRequestImplCopyWithImpl<$Res>
    extends _$LeaveRequestCopyWithImpl<$Res, _$LeaveRequestImpl>
    implements _$$LeaveRequestImplCopyWith<$Res> {
  __$$LeaveRequestImplCopyWithImpl(
    _$LeaveRequestImpl _value,
    $Res Function(_$LeaveRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeaveRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? salonId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? reason = null,
    Object? status = null,
    Object? requestedAt = null,
    Object? respondedAt = freezed,
    Object? respondedBy = freezed,
    Object? employeeName = freezed,
    Object? employeeAvatar = freezed,
  }) {
    return _then(
      _$LeaveRequestImpl(
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
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        requestedAt: null == requestedAt
            ? _value.requestedAt
            : requestedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        respondedAt: freezed == respondedAt
            ? _value.respondedAt
            : respondedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        respondedBy: freezed == respondedBy
            ? _value.respondedBy
            : respondedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        employeeName: freezed == employeeName
            ? _value.employeeName
            : employeeName // ignore: cast_nullable_to_non_nullable
                  as String?,
        employeeAvatar: freezed == employeeAvatar
            ? _value.employeeAvatar
            : employeeAvatar // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaveRequestImpl extends _LeaveRequest {
  const _$LeaveRequestImpl({
    required this.id,
    required this.employeeId,
    required this.salonId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.status = 'pending',
    required this.requestedAt,
    this.respondedAt,
    this.respondedBy,
    this.employeeName,
    this.employeeAvatar,
  }) : super._();

  factory _$LeaveRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaveRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String employeeId;
  @override
  final String salonId;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String reason;
  @override
  @JsonKey()
  final String status;
  @override
  final DateTime requestedAt;
  @override
  final DateTime? respondedAt;
  @override
  final String? respondedBy;
  @override
  final String? employeeName;
  @override
  final String? employeeAvatar;

  @override
  String toString() {
    return 'LeaveRequest(id: $id, employeeId: $employeeId, salonId: $salonId, startDate: $startDate, endDate: $endDate, reason: $reason, status: $status, requestedAt: $requestedAt, respondedAt: $respondedAt, respondedBy: $respondedBy, employeeName: $employeeName, employeeAvatar: $employeeAvatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaveRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.respondedBy, respondedBy) ||
                other.respondedBy == respondedBy) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.employeeAvatar, employeeAvatar) ||
                other.employeeAvatar == employeeAvatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    employeeId,
    salonId,
    startDate,
    endDate,
    reason,
    status,
    requestedAt,
    respondedAt,
    respondedBy,
    employeeName,
    employeeAvatar,
  );

  /// Create a copy of LeaveRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaveRequestImplCopyWith<_$LeaveRequestImpl> get copyWith =>
      __$$LeaveRequestImplCopyWithImpl<_$LeaveRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaveRequestImplToJson(this);
  }
}

abstract class _LeaveRequest extends LeaveRequest {
  const factory _LeaveRequest({
    required final String id,
    required final String employeeId,
    required final String salonId,
    required final DateTime startDate,
    required final DateTime endDate,
    required final String reason,
    final String status,
    required final DateTime requestedAt,
    final DateTime? respondedAt,
    final String? respondedBy,
    final String? employeeName,
    final String? employeeAvatar,
  }) = _$LeaveRequestImpl;
  const _LeaveRequest._() : super._();

  factory _LeaveRequest.fromJson(Map<String, dynamic> json) =
      _$LeaveRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get employeeId;
  @override
  String get salonId;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String get reason;
  @override
  String get status;
  @override
  DateTime get requestedAt;
  @override
  DateTime? get respondedAt;
  @override
  String? get respondedBy;
  @override
  String? get employeeName;
  @override
  String? get employeeAvatar;

  /// Create a copy of LeaveRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaveRequestImplCopyWith<_$LeaveRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
