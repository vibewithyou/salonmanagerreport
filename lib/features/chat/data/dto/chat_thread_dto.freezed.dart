// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_thread_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatThreadDto _$ChatThreadDtoFromJson(Map<String, dynamic> json) {
  return _ChatThreadDto.fromJson(json);
}

/// @nodoc
mixin _$ChatThreadDto {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get appointmentId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String get lastMessageAt => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this ChatThreadDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatThreadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatThreadDtoCopyWith<ChatThreadDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatThreadDtoCopyWith<$Res> {
  factory $ChatThreadDtoCopyWith(
    ChatThreadDto value,
    $Res Function(ChatThreadDto) then,
  ) = _$ChatThreadDtoCopyWithImpl<$Res, ChatThreadDto>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String type,
    String? appointmentId,
    String? title,
    String lastMessageAt,
    String createdAt,
    String updatedAt,
    String? status,
  });
}

/// @nodoc
class _$ChatThreadDtoCopyWithImpl<$Res, $Val extends ChatThreadDto>
    implements $ChatThreadDtoCopyWith<$Res> {
  _$ChatThreadDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatThreadDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? type = null,
    Object? appointmentId = freezed,
    Object? title = freezed,
    Object? lastMessageAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = freezed,
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            appointmentId: freezed == appointmentId
                ? _value.appointmentId
                : appointmentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastMessageAt: null == lastMessageAt
                ? _value.lastMessageAt
                : lastMessageAt // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatThreadDtoImplCopyWith<$Res>
    implements $ChatThreadDtoCopyWith<$Res> {
  factory _$$ChatThreadDtoImplCopyWith(
    _$ChatThreadDtoImpl value,
    $Res Function(_$ChatThreadDtoImpl) then,
  ) = __$$ChatThreadDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String type,
    String? appointmentId,
    String? title,
    String lastMessageAt,
    String createdAt,
    String updatedAt,
    String? status,
  });
}

/// @nodoc
class __$$ChatThreadDtoImplCopyWithImpl<$Res>
    extends _$ChatThreadDtoCopyWithImpl<$Res, _$ChatThreadDtoImpl>
    implements _$$ChatThreadDtoImplCopyWith<$Res> {
  __$$ChatThreadDtoImplCopyWithImpl(
    _$ChatThreadDtoImpl _value,
    $Res Function(_$ChatThreadDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatThreadDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? type = null,
    Object? appointmentId = freezed,
    Object? title = freezed,
    Object? lastMessageAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = freezed,
  }) {
    return _then(
      _$ChatThreadDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        appointmentId: freezed == appointmentId
            ? _value.appointmentId
            : appointmentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastMessageAt: null == lastMessageAt
            ? _value.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatThreadDtoImpl extends _ChatThreadDto {
  const _$ChatThreadDtoImpl({
    required this.id,
    required this.salonId,
    required this.type,
    this.appointmentId,
    this.title,
    required this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
    this.status,
  }) : super._();

  factory _$ChatThreadDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatThreadDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String type;
  @override
  final String? appointmentId;
  @override
  final String? title;
  @override
  final String lastMessageAt;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final String? status;

  @override
  String toString() {
    return 'ChatThreadDto(id: $id, salonId: $salonId, type: $type, appointmentId: $appointmentId, title: $title, lastMessageAt: $lastMessageAt, createdAt: $createdAt, updatedAt: $updatedAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatThreadDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.appointmentId, appointmentId) ||
                other.appointmentId == appointmentId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    type,
    appointmentId,
    title,
    lastMessageAt,
    createdAt,
    updatedAt,
    status,
  );

  /// Create a copy of ChatThreadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatThreadDtoImplCopyWith<_$ChatThreadDtoImpl> get copyWith =>
      __$$ChatThreadDtoImplCopyWithImpl<_$ChatThreadDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatThreadDtoImplToJson(this);
  }
}

abstract class _ChatThreadDto extends ChatThreadDto {
  const factory _ChatThreadDto({
    required final String id,
    required final String salonId,
    required final String type,
    final String? appointmentId,
    final String? title,
    required final String lastMessageAt,
    required final String createdAt,
    required final String updatedAt,
    final String? status,
  }) = _$ChatThreadDtoImpl;
  const _ChatThreadDto._() : super._();

  factory _ChatThreadDto.fromJson(Map<String, dynamic> json) =
      _$ChatThreadDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get type;
  @override
  String? get appointmentId;
  @override
  String? get title;
  @override
  String get lastMessageAt;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  String? get status;

  /// Create a copy of ChatThreadDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatThreadDtoImplCopyWith<_$ChatThreadDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatParticipantDto _$ChatParticipantDtoFromJson(Map<String, dynamic> json) {
  return _ChatParticipantDto.fromJson(json);
}

/// @nodoc
mixin _$ChatParticipantDto {
  String get id => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get lastReadMessageId => throw _privateConstructorUsedError;
  String? get archivedAt => throw _privateConstructorUsedError;
  bool? get isMuted => throw _privateConstructorUsedError;
  bool? get isBlocked => throw _privateConstructorUsedError;
  bool? get canWrite => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChatParticipantDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatParticipantDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatParticipantDtoCopyWith<ChatParticipantDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatParticipantDtoCopyWith<$Res> {
  factory $ChatParticipantDtoCopyWith(
    ChatParticipantDto value,
    $Res Function(ChatParticipantDto) then,
  ) = _$ChatParticipantDtoCopyWithImpl<$Res, ChatParticipantDto>;
  @useResult
  $Res call({
    String id,
    String conversationId,
    String userId,
    String role,
    bool isActive,
    String? lastReadMessageId,
    String? archivedAt,
    bool? isMuted,
    bool? isBlocked,
    bool? canWrite,
    String createdAt,
    String updatedAt,
  });
}

/// @nodoc
class _$ChatParticipantDtoCopyWithImpl<$Res, $Val extends ChatParticipantDto>
    implements $ChatParticipantDtoCopyWith<$Res> {
  _$ChatParticipantDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatParticipantDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? userId = null,
    Object? role = null,
    Object? isActive = null,
    Object? lastReadMessageId = freezed,
    Object? archivedAt = freezed,
    Object? isMuted = freezed,
    Object? isBlocked = freezed,
    Object? canWrite = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            conversationId: null == conversationId
                ? _value.conversationId
                : conversationId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastReadMessageId: freezed == lastReadMessageId
                ? _value.lastReadMessageId
                : lastReadMessageId // ignore: cast_nullable_to_non_nullable
                      as String?,
            archivedAt: freezed == archivedAt
                ? _value.archivedAt
                : archivedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            isMuted: freezed == isMuted
                ? _value.isMuted
                : isMuted // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isBlocked: freezed == isBlocked
                ? _value.isBlocked
                : isBlocked // ignore: cast_nullable_to_non_nullable
                      as bool?,
            canWrite: freezed == canWrite
                ? _value.canWrite
                : canWrite // ignore: cast_nullable_to_non_nullable
                      as bool?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatParticipantDtoImplCopyWith<$Res>
    implements $ChatParticipantDtoCopyWith<$Res> {
  factory _$$ChatParticipantDtoImplCopyWith(
    _$ChatParticipantDtoImpl value,
    $Res Function(_$ChatParticipantDtoImpl) then,
  ) = __$$ChatParticipantDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String conversationId,
    String userId,
    String role,
    bool isActive,
    String? lastReadMessageId,
    String? archivedAt,
    bool? isMuted,
    bool? isBlocked,
    bool? canWrite,
    String createdAt,
    String updatedAt,
  });
}

/// @nodoc
class __$$ChatParticipantDtoImplCopyWithImpl<$Res>
    extends _$ChatParticipantDtoCopyWithImpl<$Res, _$ChatParticipantDtoImpl>
    implements _$$ChatParticipantDtoImplCopyWith<$Res> {
  __$$ChatParticipantDtoImplCopyWithImpl(
    _$ChatParticipantDtoImpl _value,
    $Res Function(_$ChatParticipantDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatParticipantDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? userId = null,
    Object? role = null,
    Object? isActive = null,
    Object? lastReadMessageId = freezed,
    Object? archivedAt = freezed,
    Object? isMuted = freezed,
    Object? isBlocked = freezed,
    Object? canWrite = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ChatParticipantDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        conversationId: null == conversationId
            ? _value.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastReadMessageId: freezed == lastReadMessageId
            ? _value.lastReadMessageId
            : lastReadMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        archivedAt: freezed == archivedAt
            ? _value.archivedAt
            : archivedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        isMuted: freezed == isMuted
            ? _value.isMuted
            : isMuted // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isBlocked: freezed == isBlocked
            ? _value.isBlocked
            : isBlocked // ignore: cast_nullable_to_non_nullable
                  as bool?,
        canWrite: freezed == canWrite
            ? _value.canWrite
            : canWrite // ignore: cast_nullable_to_non_nullable
                  as bool?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatParticipantDtoImpl extends _ChatParticipantDto {
  const _$ChatParticipantDtoImpl({
    required this.id,
    required this.conversationId,
    required this.userId,
    required this.role,
    required this.isActive,
    this.lastReadMessageId,
    this.archivedAt,
    this.isMuted,
    this.isBlocked,
    this.canWrite,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  factory _$ChatParticipantDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatParticipantDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String conversationId;
  @override
  final String userId;
  @override
  final String role;
  @override
  final bool isActive;
  @override
  final String? lastReadMessageId;
  @override
  final String? archivedAt;
  @override
  final bool? isMuted;
  @override
  final bool? isBlocked;
  @override
  final bool? canWrite;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'ChatParticipantDto(id: $id, conversationId: $conversationId, userId: $userId, role: $role, isActive: $isActive, lastReadMessageId: $lastReadMessageId, archivedAt: $archivedAt, isMuted: $isMuted, isBlocked: $isBlocked, canWrite: $canWrite, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatParticipantDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.lastReadMessageId, lastReadMessageId) ||
                other.lastReadMessageId == lastReadMessageId) &&
            (identical(other.archivedAt, archivedAt) ||
                other.archivedAt == archivedAt) &&
            (identical(other.isMuted, isMuted) || other.isMuted == isMuted) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.canWrite, canWrite) ||
                other.canWrite == canWrite) &&
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
    conversationId,
    userId,
    role,
    isActive,
    lastReadMessageId,
    archivedAt,
    isMuted,
    isBlocked,
    canWrite,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ChatParticipantDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatParticipantDtoImplCopyWith<_$ChatParticipantDtoImpl> get copyWith =>
      __$$ChatParticipantDtoImplCopyWithImpl<_$ChatParticipantDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatParticipantDtoImplToJson(this);
  }
}

abstract class _ChatParticipantDto extends ChatParticipantDto {
  const factory _ChatParticipantDto({
    required final String id,
    required final String conversationId,
    required final String userId,
    required final String role,
    required final bool isActive,
    final String? lastReadMessageId,
    final String? archivedAt,
    final bool? isMuted,
    final bool? isBlocked,
    final bool? canWrite,
    required final String createdAt,
    required final String updatedAt,
  }) = _$ChatParticipantDtoImpl;
  const _ChatParticipantDto._() : super._();

  factory _ChatParticipantDto.fromJson(Map<String, dynamic> json) =
      _$ChatParticipantDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get conversationId;
  @override
  String get userId;
  @override
  String get role;
  @override
  bool get isActive;
  @override
  String? get lastReadMessageId;
  @override
  String? get archivedAt;
  @override
  bool? get isMuted;
  @override
  bool? get isBlocked;
  @override
  bool? get canWrite;
  @override
  String get createdAt;
  @override
  String get updatedAt;

  /// Create a copy of ChatParticipantDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatParticipantDtoImplCopyWith<_$ChatParticipantDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatMessageDto _$ChatMessageDtoFromJson(Map<String, dynamic> json) {
  return _ChatMessageDto.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageDto {
  String get id => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get messageType => throw _privateConstructorUsedError;
  String? get mediaId => throw _privateConstructorUsedError;
  String? get replyToMessageId => throw _privateConstructorUsedError;
  String? get editedAt => throw _privateConstructorUsedError;
  String? get deletedAt => throw _privateConstructorUsedError;
  List<String>? get deletedForUserIds => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChatMessageDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageDtoCopyWith<ChatMessageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageDtoCopyWith<$Res> {
  factory $ChatMessageDtoCopyWith(
    ChatMessageDto value,
    $Res Function(ChatMessageDto) then,
  ) = _$ChatMessageDtoCopyWithImpl<$Res, ChatMessageDto>;
  @useResult
  $Res call({
    String id,
    String conversationId,
    String senderId,
    String? content,
    String? messageType,
    String? mediaId,
    String? replyToMessageId,
    String? editedAt,
    String? deletedAt,
    List<String>? deletedForUserIds,
    String createdAt,
    String updatedAt,
  });
}

/// @nodoc
class _$ChatMessageDtoCopyWithImpl<$Res, $Val extends ChatMessageDto>
    implements $ChatMessageDtoCopyWith<$Res> {
  _$ChatMessageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? content = freezed,
    Object? messageType = freezed,
    Object? mediaId = freezed,
    Object? replyToMessageId = freezed,
    Object? editedAt = freezed,
    Object? deletedAt = freezed,
    Object? deletedForUserIds = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            conversationId: null == conversationId
                ? _value.conversationId
                : conversationId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String,
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String?,
            messageType: freezed == messageType
                ? _value.messageType
                : messageType // ignore: cast_nullable_to_non_nullable
                      as String?,
            mediaId: freezed == mediaId
                ? _value.mediaId
                : mediaId // ignore: cast_nullable_to_non_nullable
                      as String?,
            replyToMessageId: freezed == replyToMessageId
                ? _value.replyToMessageId
                : replyToMessageId // ignore: cast_nullable_to_non_nullable
                      as String?,
            editedAt: freezed == editedAt
                ? _value.editedAt
                : editedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            deletedForUserIds: freezed == deletedForUserIds
                ? _value.deletedForUserIds
                : deletedForUserIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatMessageDtoImplCopyWith<$Res>
    implements $ChatMessageDtoCopyWith<$Res> {
  factory _$$ChatMessageDtoImplCopyWith(
    _$ChatMessageDtoImpl value,
    $Res Function(_$ChatMessageDtoImpl) then,
  ) = __$$ChatMessageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String conversationId,
    String senderId,
    String? content,
    String? messageType,
    String? mediaId,
    String? replyToMessageId,
    String? editedAt,
    String? deletedAt,
    List<String>? deletedForUserIds,
    String createdAt,
    String updatedAt,
  });
}

/// @nodoc
class __$$ChatMessageDtoImplCopyWithImpl<$Res>
    extends _$ChatMessageDtoCopyWithImpl<$Res, _$ChatMessageDtoImpl>
    implements _$$ChatMessageDtoImplCopyWith<$Res> {
  __$$ChatMessageDtoImplCopyWithImpl(
    _$ChatMessageDtoImpl _value,
    $Res Function(_$ChatMessageDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? content = freezed,
    Object? messageType = freezed,
    Object? mediaId = freezed,
    Object? replyToMessageId = freezed,
    Object? editedAt = freezed,
    Object? deletedAt = freezed,
    Object? deletedForUserIds = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ChatMessageDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        conversationId: null == conversationId
            ? _value.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String,
        content: freezed == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String?,
        messageType: freezed == messageType
            ? _value.messageType
            : messageType // ignore: cast_nullable_to_non_nullable
                  as String?,
        mediaId: freezed == mediaId
            ? _value.mediaId
            : mediaId // ignore: cast_nullable_to_non_nullable
                  as String?,
        replyToMessageId: freezed == replyToMessageId
            ? _value.replyToMessageId
            : replyToMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        editedAt: freezed == editedAt
            ? _value.editedAt
            : editedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        deletedForUserIds: freezed == deletedForUserIds
            ? _value._deletedForUserIds
            : deletedForUserIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageDtoImpl extends _ChatMessageDto {
  const _$ChatMessageDtoImpl({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.content,
    this.messageType,
    this.mediaId,
    this.replyToMessageId,
    this.editedAt,
    this.deletedAt,
    final List<String>? deletedForUserIds,
    required this.createdAt,
    required this.updatedAt,
  }) : _deletedForUserIds = deletedForUserIds,
       super._();

  factory _$ChatMessageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String conversationId;
  @override
  final String senderId;
  @override
  final String? content;
  @override
  final String? messageType;
  @override
  final String? mediaId;
  @override
  final String? replyToMessageId;
  @override
  final String? editedAt;
  @override
  final String? deletedAt;
  final List<String>? _deletedForUserIds;
  @override
  List<String>? get deletedForUserIds {
    final value = _deletedForUserIds;
    if (value == null) return null;
    if (_deletedForUserIds is EqualUnmodifiableListView)
      return _deletedForUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'ChatMessageDto(id: $id, conversationId: $conversationId, senderId: $senderId, content: $content, messageType: $messageType, mediaId: $mediaId, replyToMessageId: $replyToMessageId, editedAt: $editedAt, deletedAt: $deletedAt, deletedForUserIds: $deletedForUserIds, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.mediaId, mediaId) || other.mediaId == mediaId) &&
            (identical(other.replyToMessageId, replyToMessageId) ||
                other.replyToMessageId == replyToMessageId) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            const DeepCollectionEquality().equals(
              other._deletedForUserIds,
              _deletedForUserIds,
            ) &&
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
    conversationId,
    senderId,
    content,
    messageType,
    mediaId,
    replyToMessageId,
    editedAt,
    deletedAt,
    const DeepCollectionEquality().hash(_deletedForUserIds),
    createdAt,
    updatedAt,
  );

  /// Create a copy of ChatMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageDtoImplCopyWith<_$ChatMessageDtoImpl> get copyWith =>
      __$$ChatMessageDtoImplCopyWithImpl<_$ChatMessageDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageDtoImplToJson(this);
  }
}

abstract class _ChatMessageDto extends ChatMessageDto {
  const factory _ChatMessageDto({
    required final String id,
    required final String conversationId,
    required final String senderId,
    final String? content,
    final String? messageType,
    final String? mediaId,
    final String? replyToMessageId,
    final String? editedAt,
    final String? deletedAt,
    final List<String>? deletedForUserIds,
    required final String createdAt,
    required final String updatedAt,
  }) = _$ChatMessageDtoImpl;
  const _ChatMessageDto._() : super._();

  factory _ChatMessageDto.fromJson(Map<String, dynamic> json) =
      _$ChatMessageDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get conversationId;
  @override
  String get senderId;
  @override
  String? get content;
  @override
  String? get messageType;
  @override
  String? get mediaId;
  @override
  String? get replyToMessageId;
  @override
  String? get editedAt;
  @override
  String? get deletedAt;
  @override
  List<String>? get deletedForUserIds;
  @override
  String get createdAt;
  @override
  String get updatedAt;

  /// Create a copy of ChatMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageDtoImplCopyWith<_$ChatMessageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageReadDto _$MessageReadDtoFromJson(Map<String, dynamic> json) {
  return _MessageReadDto.fromJson(json);
}

/// @nodoc
mixin _$MessageReadDto {
  String get id => throw _privateConstructorUsedError;
  String get messageId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get readAt => throw _privateConstructorUsedError;

  /// Serializes this MessageReadDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageReadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageReadDtoCopyWith<MessageReadDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageReadDtoCopyWith<$Res> {
  factory $MessageReadDtoCopyWith(
    MessageReadDto value,
    $Res Function(MessageReadDto) then,
  ) = _$MessageReadDtoCopyWithImpl<$Res, MessageReadDto>;
  @useResult
  $Res call({String id, String messageId, String userId, String readAt});
}

/// @nodoc
class _$MessageReadDtoCopyWithImpl<$Res, $Val extends MessageReadDto>
    implements $MessageReadDtoCopyWith<$Res> {
  _$MessageReadDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageReadDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? messageId = null,
    Object? userId = null,
    Object? readAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            messageId: null == messageId
                ? _value.messageId
                : messageId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            readAt: null == readAt
                ? _value.readAt
                : readAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageReadDtoImplCopyWith<$Res>
    implements $MessageReadDtoCopyWith<$Res> {
  factory _$$MessageReadDtoImplCopyWith(
    _$MessageReadDtoImpl value,
    $Res Function(_$MessageReadDtoImpl) then,
  ) = __$$MessageReadDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String messageId, String userId, String readAt});
}

/// @nodoc
class __$$MessageReadDtoImplCopyWithImpl<$Res>
    extends _$MessageReadDtoCopyWithImpl<$Res, _$MessageReadDtoImpl>
    implements _$$MessageReadDtoImplCopyWith<$Res> {
  __$$MessageReadDtoImplCopyWithImpl(
    _$MessageReadDtoImpl _value,
    $Res Function(_$MessageReadDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageReadDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? messageId = null,
    Object? userId = null,
    Object? readAt = null,
  }) {
    return _then(
      _$MessageReadDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        messageId: null == messageId
            ? _value.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        readAt: null == readAt
            ? _value.readAt
            : readAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageReadDtoImpl extends _MessageReadDto {
  const _$MessageReadDtoImpl({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.readAt,
  }) : super._();

  factory _$MessageReadDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageReadDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String messageId;
  @override
  final String userId;
  @override
  final String readAt;

  @override
  String toString() {
    return 'MessageReadDto(id: $id, messageId: $messageId, userId: $userId, readAt: $readAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageReadDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.readAt, readAt) || other.readAt == readAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, messageId, userId, readAt);

  /// Create a copy of MessageReadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageReadDtoImplCopyWith<_$MessageReadDtoImpl> get copyWith =>
      __$$MessageReadDtoImplCopyWithImpl<_$MessageReadDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageReadDtoImplToJson(this);
  }
}

abstract class _MessageReadDto extends MessageReadDto {
  const factory _MessageReadDto({
    required final String id,
    required final String messageId,
    required final String userId,
    required final String readAt,
  }) = _$MessageReadDtoImpl;
  const _MessageReadDto._() : super._();

  factory _MessageReadDto.fromJson(Map<String, dynamic> json) =
      _$MessageReadDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get messageId;
  @override
  String get userId;
  @override
  String get readAt;

  /// Create a copy of MessageReadDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageReadDtoImplCopyWith<_$MessageReadDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
