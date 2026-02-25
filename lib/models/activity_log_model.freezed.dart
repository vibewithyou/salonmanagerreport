// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivityLog _$ActivityLogFromJson(Map<String, dynamic> json) {
  return _ActivityLog.fromJson(json);
}

/// @nodoc
mixin _$ActivityLog {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  ActivityType get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  String? get ipAddress => throw _privateConstructorUsedError;
  String? get userAgent => throw _privateConstructorUsedError;

  /// Serializes this ActivityLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityLogCopyWith<ActivityLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityLogCopyWith<$Res> {
  factory $ActivityLogCopyWith(
    ActivityLog value,
    $Res Function(ActivityLog) then,
  ) = _$ActivityLogCopyWithImpl<$Res, ActivityLog>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String userId,
    String userName,
    ActivityType type,
    String description,
    DateTime timestamp,
    Map<String, dynamic>? metadata,
    String? ipAddress,
    String? userAgent,
  });
}

/// @nodoc
class _$ActivityLogCopyWithImpl<$Res, $Val extends ActivityLog>
    implements $ActivityLogCopyWith<$Res> {
  _$ActivityLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? userId = null,
    Object? userName = null,
    Object? type = null,
    Object? description = null,
    Object? timestamp = null,
    Object? metadata = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
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
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ActivityType,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            ipAddress: freezed == ipAddress
                ? _value.ipAddress
                : ipAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            userAgent: freezed == userAgent
                ? _value.userAgent
                : userAgent // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityLogImplCopyWith<$Res>
    implements $ActivityLogCopyWith<$Res> {
  factory _$$ActivityLogImplCopyWith(
    _$ActivityLogImpl value,
    $Res Function(_$ActivityLogImpl) then,
  ) = __$$ActivityLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String userId,
    String userName,
    ActivityType type,
    String description,
    DateTime timestamp,
    Map<String, dynamic>? metadata,
    String? ipAddress,
    String? userAgent,
  });
}

/// @nodoc
class __$$ActivityLogImplCopyWithImpl<$Res>
    extends _$ActivityLogCopyWithImpl<$Res, _$ActivityLogImpl>
    implements _$$ActivityLogImplCopyWith<$Res> {
  __$$ActivityLogImplCopyWithImpl(
    _$ActivityLogImpl _value,
    $Res Function(_$ActivityLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? userId = null,
    Object? userName = null,
    Object? type = null,
    Object? description = null,
    Object? timestamp = null,
    Object? metadata = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
  }) {
    return _then(
      _$ActivityLogImpl(
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
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ActivityType,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        ipAddress: freezed == ipAddress
            ? _value.ipAddress
            : ipAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        userAgent: freezed == userAgent
            ? _value.userAgent
            : userAgent // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityLogImpl implements _ActivityLog {
  const _$ActivityLogImpl({
    required this.id,
    required this.salonId,
    required this.userId,
    required this.userName,
    required this.type,
    required this.description,
    required this.timestamp,
    final Map<String, dynamic>? metadata,
    this.ipAddress,
    this.userAgent,
  }) : _metadata = metadata;

  factory _$ActivityLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityLogImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final ActivityType type;
  @override
  final String description;
  @override
  final DateTime timestamp;
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
  final String? ipAddress;
  @override
  final String? userAgent;

  @override
  String toString() {
    return 'ActivityLog(id: $id, salonId: $salonId, userId: $userId, userName: $userName, type: $type, description: $description, timestamp: $timestamp, metadata: $metadata, ipAddress: $ipAddress, userAgent: $userAgent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    userId,
    userName,
    type,
    description,
    timestamp,
    const DeepCollectionEquality().hash(_metadata),
    ipAddress,
    userAgent,
  );

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityLogImplCopyWith<_$ActivityLogImpl> get copyWith =>
      __$$ActivityLogImplCopyWithImpl<_$ActivityLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityLogImplToJson(this);
  }
}

abstract class _ActivityLog implements ActivityLog {
  const factory _ActivityLog({
    required final String id,
    required final String salonId,
    required final String userId,
    required final String userName,
    required final ActivityType type,
    required final String description,
    required final DateTime timestamp,
    final Map<String, dynamic>? metadata,
    final String? ipAddress,
    final String? userAgent,
  }) = _$ActivityLogImpl;

  factory _ActivityLog.fromJson(Map<String, dynamic> json) =
      _$ActivityLogImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get userId;
  @override
  String get userName;
  @override
  ActivityType get type;
  @override
  String get description;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get metadata;
  @override
  String? get ipAddress;
  @override
  String? get userAgent;

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityLogImplCopyWith<_$ActivityLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityLogCreateRequest _$ActivityLogCreateRequestFromJson(
  Map<String, dynamic> json,
) {
  return _ActivityLogCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$ActivityLogCreateRequest {
  String get salonId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  ActivityType get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  String? get ipAddress => throw _privateConstructorUsedError;
  String? get userAgent => throw _privateConstructorUsedError;

  /// Serializes this ActivityLogCreateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityLogCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityLogCreateRequestCopyWith<ActivityLogCreateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityLogCreateRequestCopyWith<$Res> {
  factory $ActivityLogCreateRequestCopyWith(
    ActivityLogCreateRequest value,
    $Res Function(ActivityLogCreateRequest) then,
  ) = _$ActivityLogCreateRequestCopyWithImpl<$Res, ActivityLogCreateRequest>;
  @useResult
  $Res call({
    String salonId,
    String userId,
    String userName,
    ActivityType type,
    String description,
    Map<String, dynamic>? metadata,
    String? ipAddress,
    String? userAgent,
  });
}

/// @nodoc
class _$ActivityLogCreateRequestCopyWithImpl<
  $Res,
  $Val extends ActivityLogCreateRequest
>
    implements $ActivityLogCreateRequestCopyWith<$Res> {
  _$ActivityLogCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityLogCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? salonId = null,
    Object? userId = null,
    Object? userName = null,
    Object? type = null,
    Object? description = null,
    Object? metadata = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
  }) {
    return _then(
      _value.copyWith(
            salonId: null == salonId
                ? _value.salonId
                : salonId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ActivityType,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            ipAddress: freezed == ipAddress
                ? _value.ipAddress
                : ipAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            userAgent: freezed == userAgent
                ? _value.userAgent
                : userAgent // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityLogCreateRequestImplCopyWith<$Res>
    implements $ActivityLogCreateRequestCopyWith<$Res> {
  factory _$$ActivityLogCreateRequestImplCopyWith(
    _$ActivityLogCreateRequestImpl value,
    $Res Function(_$ActivityLogCreateRequestImpl) then,
  ) = __$$ActivityLogCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String salonId,
    String userId,
    String userName,
    ActivityType type,
    String description,
    Map<String, dynamic>? metadata,
    String? ipAddress,
    String? userAgent,
  });
}

/// @nodoc
class __$$ActivityLogCreateRequestImplCopyWithImpl<$Res>
    extends
        _$ActivityLogCreateRequestCopyWithImpl<
          $Res,
          _$ActivityLogCreateRequestImpl
        >
    implements _$$ActivityLogCreateRequestImplCopyWith<$Res> {
  __$$ActivityLogCreateRequestImplCopyWithImpl(
    _$ActivityLogCreateRequestImpl _value,
    $Res Function(_$ActivityLogCreateRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityLogCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? salonId = null,
    Object? userId = null,
    Object? userName = null,
    Object? type = null,
    Object? description = null,
    Object? metadata = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
  }) {
    return _then(
      _$ActivityLogCreateRequestImpl(
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ActivityType,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        ipAddress: freezed == ipAddress
            ? _value.ipAddress
            : ipAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        userAgent: freezed == userAgent
            ? _value.userAgent
            : userAgent // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityLogCreateRequestImpl implements _ActivityLogCreateRequest {
  const _$ActivityLogCreateRequestImpl({
    required this.salonId,
    required this.userId,
    required this.userName,
    required this.type,
    required this.description,
    final Map<String, dynamic>? metadata,
    this.ipAddress,
    this.userAgent,
  }) : _metadata = metadata;

  factory _$ActivityLogCreateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityLogCreateRequestImplFromJson(json);

  @override
  final String salonId;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final ActivityType type;
  @override
  final String description;
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
  final String? ipAddress;
  @override
  final String? userAgent;

  @override
  String toString() {
    return 'ActivityLogCreateRequest(salonId: $salonId, userId: $userId, userName: $userName, type: $type, description: $description, metadata: $metadata, ipAddress: $ipAddress, userAgent: $userAgent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityLogCreateRequestImpl &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    salonId,
    userId,
    userName,
    type,
    description,
    const DeepCollectionEquality().hash(_metadata),
    ipAddress,
    userAgent,
  );

  /// Create a copy of ActivityLogCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityLogCreateRequestImplCopyWith<_$ActivityLogCreateRequestImpl>
  get copyWith =>
      __$$ActivityLogCreateRequestImplCopyWithImpl<
        _$ActivityLogCreateRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityLogCreateRequestImplToJson(this);
  }
}

abstract class _ActivityLogCreateRequest implements ActivityLogCreateRequest {
  const factory _ActivityLogCreateRequest({
    required final String salonId,
    required final String userId,
    required final String userName,
    required final ActivityType type,
    required final String description,
    final Map<String, dynamic>? metadata,
    final String? ipAddress,
    final String? userAgent,
  }) = _$ActivityLogCreateRequestImpl;

  factory _ActivityLogCreateRequest.fromJson(Map<String, dynamic> json) =
      _$ActivityLogCreateRequestImpl.fromJson;

  @override
  String get salonId;
  @override
  String get userId;
  @override
  String get userName;
  @override
  ActivityType get type;
  @override
  String get description;
  @override
  Map<String, dynamic>? get metadata;
  @override
  String? get ipAddress;
  @override
  String? get userAgent;

  /// Create a copy of ActivityLogCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityLogCreateRequestImplCopyWith<_$ActivityLogCreateRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
