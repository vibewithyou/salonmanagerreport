// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salon_code_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalonCode _$SalonCodeFromJson(Map<String, dynamic> json) {
  return _SalonCode.fromJson(json);
}

/// @nodoc
mixin _$SalonCode {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get generatedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  String? get generatedBy => throw _privateConstructorUsedError;

  /// Serializes this SalonCode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalonCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalonCodeCopyWith<SalonCode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalonCodeCopyWith<$Res> {
  factory $SalonCodeCopyWith(SalonCode value, $Res Function(SalonCode) then) =
      _$SalonCodeCopyWithImpl<$Res, SalonCode>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String code,
    bool isActive,
    DateTime? generatedAt,
    DateTime? expiresAt,
    String? generatedBy,
  });
}

/// @nodoc
class _$SalonCodeCopyWithImpl<$Res, $Val extends SalonCode>
    implements $SalonCodeCopyWith<$Res> {
  _$SalonCodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalonCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? code = null,
    Object? isActive = null,
    Object? generatedAt = freezed,
    Object? expiresAt = freezed,
    Object? generatedBy = freezed,
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
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            generatedAt: freezed == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            generatedBy: freezed == generatedBy
                ? _value.generatedBy
                : generatedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalonCodeImplCopyWith<$Res>
    implements $SalonCodeCopyWith<$Res> {
  factory _$$SalonCodeImplCopyWith(
    _$SalonCodeImpl value,
    $Res Function(_$SalonCodeImpl) then,
  ) = __$$SalonCodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String code,
    bool isActive,
    DateTime? generatedAt,
    DateTime? expiresAt,
    String? generatedBy,
  });
}

/// @nodoc
class __$$SalonCodeImplCopyWithImpl<$Res>
    extends _$SalonCodeCopyWithImpl<$Res, _$SalonCodeImpl>
    implements _$$SalonCodeImplCopyWith<$Res> {
  __$$SalonCodeImplCopyWithImpl(
    _$SalonCodeImpl _value,
    $Res Function(_$SalonCodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalonCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? code = null,
    Object? isActive = null,
    Object? generatedAt = freezed,
    Object? expiresAt = freezed,
    Object? generatedBy = freezed,
  }) {
    return _then(
      _$SalonCodeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        generatedAt: freezed == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        generatedBy: freezed == generatedBy
            ? _value.generatedBy
            : generatedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalonCodeImpl implements _SalonCode {
  const _$SalonCodeImpl({
    required this.id,
    required this.salonId,
    required this.code,
    required this.isActive,
    this.generatedAt,
    this.expiresAt,
    this.generatedBy,
  });

  factory _$SalonCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalonCodeImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String code;
  @override
  final bool isActive;
  @override
  final DateTime? generatedAt;
  @override
  final DateTime? expiresAt;
  @override
  final String? generatedBy;

  @override
  String toString() {
    return 'SalonCode(id: $id, salonId: $salonId, code: $code, isActive: $isActive, generatedAt: $generatedAt, expiresAt: $expiresAt, generatedBy: $generatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalonCodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.generatedBy, generatedBy) ||
                other.generatedBy == generatedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    code,
    isActive,
    generatedAt,
    expiresAt,
    generatedBy,
  );

  /// Create a copy of SalonCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalonCodeImplCopyWith<_$SalonCodeImpl> get copyWith =>
      __$$SalonCodeImplCopyWithImpl<_$SalonCodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalonCodeImplToJson(this);
  }
}

abstract class _SalonCode implements SalonCode {
  const factory _SalonCode({
    required final String id,
    required final String salonId,
    required final String code,
    required final bool isActive,
    final DateTime? generatedAt,
    final DateTime? expiresAt,
    final String? generatedBy,
  }) = _$SalonCodeImpl;

  factory _SalonCode.fromJson(Map<String, dynamic> json) =
      _$SalonCodeImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get code;
  @override
  bool get isActive;
  @override
  DateTime? get generatedAt;
  @override
  DateTime? get expiresAt;
  @override
  String? get generatedBy;

  /// Create a copy of SalonCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalonCodeImplCopyWith<_$SalonCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalonCodeVerifyRequest _$SalonCodeVerifyRequestFromJson(
  Map<String, dynamic> json,
) {
  return _SalonCodeVerifyRequest.fromJson(json);
}

/// @nodoc
mixin _$SalonCodeVerifyRequest {
  String get salonId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;

  /// Serializes this SalonCodeVerifyRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalonCodeVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalonCodeVerifyRequestCopyWith<SalonCodeVerifyRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalonCodeVerifyRequestCopyWith<$Res> {
  factory $SalonCodeVerifyRequestCopyWith(
    SalonCodeVerifyRequest value,
    $Res Function(SalonCodeVerifyRequest) then,
  ) = _$SalonCodeVerifyRequestCopyWithImpl<$Res, SalonCodeVerifyRequest>;
  @useResult
  $Res call({String salonId, String code});
}

/// @nodoc
class _$SalonCodeVerifyRequestCopyWithImpl<
  $Res,
  $Val extends SalonCodeVerifyRequest
>
    implements $SalonCodeVerifyRequestCopyWith<$Res> {
  _$SalonCodeVerifyRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalonCodeVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? salonId = null, Object? code = null}) {
    return _then(
      _value.copyWith(
            salonId: null == salonId
                ? _value.salonId
                : salonId // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalonCodeVerifyRequestImplCopyWith<$Res>
    implements $SalonCodeVerifyRequestCopyWith<$Res> {
  factory _$$SalonCodeVerifyRequestImplCopyWith(
    _$SalonCodeVerifyRequestImpl value,
    $Res Function(_$SalonCodeVerifyRequestImpl) then,
  ) = __$$SalonCodeVerifyRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String salonId, String code});
}

/// @nodoc
class __$$SalonCodeVerifyRequestImplCopyWithImpl<$Res>
    extends
        _$SalonCodeVerifyRequestCopyWithImpl<$Res, _$SalonCodeVerifyRequestImpl>
    implements _$$SalonCodeVerifyRequestImplCopyWith<$Res> {
  __$$SalonCodeVerifyRequestImplCopyWithImpl(
    _$SalonCodeVerifyRequestImpl _value,
    $Res Function(_$SalonCodeVerifyRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalonCodeVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? salonId = null, Object? code = null}) {
    return _then(
      _$SalonCodeVerifyRequestImpl(
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalonCodeVerifyRequestImpl implements _SalonCodeVerifyRequest {
  const _$SalonCodeVerifyRequestImpl({
    required this.salonId,
    required this.code,
  });

  factory _$SalonCodeVerifyRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalonCodeVerifyRequestImplFromJson(json);

  @override
  final String salonId;
  @override
  final String code;

  @override
  String toString() {
    return 'SalonCodeVerifyRequest(salonId: $salonId, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalonCodeVerifyRequestImpl &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, salonId, code);

  /// Create a copy of SalonCodeVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalonCodeVerifyRequestImplCopyWith<_$SalonCodeVerifyRequestImpl>
  get copyWith =>
      __$$SalonCodeVerifyRequestImplCopyWithImpl<_$SalonCodeVerifyRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SalonCodeVerifyRequestImplToJson(this);
  }
}

abstract class _SalonCodeVerifyRequest implements SalonCodeVerifyRequest {
  const factory _SalonCodeVerifyRequest({
    required final String salonId,
    required final String code,
  }) = _$SalonCodeVerifyRequestImpl;

  factory _SalonCodeVerifyRequest.fromJson(Map<String, dynamic> json) =
      _$SalonCodeVerifyRequestImpl.fromJson;

  @override
  String get salonId;
  @override
  String get code;

  /// Create a copy of SalonCodeVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalonCodeVerifyRequestImplCopyWith<_$SalonCodeVerifyRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SalonCodeVerifyResponse _$SalonCodeVerifyResponseFromJson(
  Map<String, dynamic> json,
) {
  return _SalonCodeVerifyResponse.fromJson(json);
}

/// @nodoc
mixin _$SalonCodeVerifyResponse {
  bool get isValid => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String? get salonName => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this SalonCodeVerifyResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalonCodeVerifyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalonCodeVerifyResponseCopyWith<SalonCodeVerifyResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalonCodeVerifyResponseCopyWith<$Res> {
  factory $SalonCodeVerifyResponseCopyWith(
    SalonCodeVerifyResponse value,
    $Res Function(SalonCodeVerifyResponse) then,
  ) = _$SalonCodeVerifyResponseCopyWithImpl<$Res, SalonCodeVerifyResponse>;
  @useResult
  $Res call({
    bool isValid,
    String salonId,
    String? salonName,
    String? errorMessage,
  });
}

/// @nodoc
class _$SalonCodeVerifyResponseCopyWithImpl<
  $Res,
  $Val extends SalonCodeVerifyResponse
>
    implements $SalonCodeVerifyResponseCopyWith<$Res> {
  _$SalonCodeVerifyResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalonCodeVerifyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? salonId = null,
    Object? salonName = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isValid: null == isValid
                ? _value.isValid
                : isValid // ignore: cast_nullable_to_non_nullable
                      as bool,
            salonId: null == salonId
                ? _value.salonId
                : salonId // ignore: cast_nullable_to_non_nullable
                      as String,
            salonName: freezed == salonName
                ? _value.salonName
                : salonName // ignore: cast_nullable_to_non_nullable
                      as String?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalonCodeVerifyResponseImplCopyWith<$Res>
    implements $SalonCodeVerifyResponseCopyWith<$Res> {
  factory _$$SalonCodeVerifyResponseImplCopyWith(
    _$SalonCodeVerifyResponseImpl value,
    $Res Function(_$SalonCodeVerifyResponseImpl) then,
  ) = __$$SalonCodeVerifyResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isValid,
    String salonId,
    String? salonName,
    String? errorMessage,
  });
}

/// @nodoc
class __$$SalonCodeVerifyResponseImplCopyWithImpl<$Res>
    extends
        _$SalonCodeVerifyResponseCopyWithImpl<
          $Res,
          _$SalonCodeVerifyResponseImpl
        >
    implements _$$SalonCodeVerifyResponseImplCopyWith<$Res> {
  __$$SalonCodeVerifyResponseImplCopyWithImpl(
    _$SalonCodeVerifyResponseImpl _value,
    $Res Function(_$SalonCodeVerifyResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalonCodeVerifyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? salonId = null,
    Object? salonName = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$SalonCodeVerifyResponseImpl(
        isValid: null == isValid
            ? _value.isValid
            : isValid // ignore: cast_nullable_to_non_nullable
                  as bool,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        salonName: freezed == salonName
            ? _value.salonName
            : salonName // ignore: cast_nullable_to_non_nullable
                  as String?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalonCodeVerifyResponseImpl implements _SalonCodeVerifyResponse {
  const _$SalonCodeVerifyResponseImpl({
    required this.isValid,
    required this.salonId,
    this.salonName,
    this.errorMessage,
  });

  factory _$SalonCodeVerifyResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalonCodeVerifyResponseImplFromJson(json);

  @override
  final bool isValid;
  @override
  final String salonId;
  @override
  final String? salonName;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'SalonCodeVerifyResponse(isValid: $isValid, salonId: $salonId, salonName: $salonName, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalonCodeVerifyResponseImpl &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.salonName, salonName) ||
                other.salonName == salonName) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isValid, salonId, salonName, errorMessage);

  /// Create a copy of SalonCodeVerifyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalonCodeVerifyResponseImplCopyWith<_$SalonCodeVerifyResponseImpl>
  get copyWith =>
      __$$SalonCodeVerifyResponseImplCopyWithImpl<
        _$SalonCodeVerifyResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalonCodeVerifyResponseImplToJson(this);
  }
}

abstract class _SalonCodeVerifyResponse implements SalonCodeVerifyResponse {
  const factory _SalonCodeVerifyResponse({
    required final bool isValid,
    required final String salonId,
    final String? salonName,
    final String? errorMessage,
  }) = _$SalonCodeVerifyResponseImpl;

  factory _SalonCodeVerifyResponse.fromJson(Map<String, dynamic> json) =
      _$SalonCodeVerifyResponseImpl.fromJson;

  @override
  bool get isValid;
  @override
  String get salonId;
  @override
  String? get salonName;
  @override
  String? get errorMessage;

  /// Create a copy of SalonCodeVerifyResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalonCodeVerifyResponseImplCopyWith<_$SalonCodeVerifyResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

EmployeeTimeCode _$EmployeeTimeCodeFromJson(Map<String, dynamic> json) {
  return _EmployeeTimeCode.fromJson(json);
}

/// @nodoc
mixin _$EmployeeTimeCode {
  String get id => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get generatedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  String? get generatedBy => throw _privateConstructorUsedError;

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
    String code,
    bool isActive,
    DateTime? generatedAt,
    DateTime? expiresAt,
    String? generatedBy,
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
    Object? code = null,
    Object? isActive = null,
    Object? generatedAt = freezed,
    Object? expiresAt = freezed,
    Object? generatedBy = freezed,
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
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            generatedAt: freezed == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            generatedBy: freezed == generatedBy
                ? _value.generatedBy
                : generatedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    String code,
    bool isActive,
    DateTime? generatedAt,
    DateTime? expiresAt,
    String? generatedBy,
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
    Object? code = null,
    Object? isActive = null,
    Object? generatedAt = freezed,
    Object? expiresAt = freezed,
    Object? generatedBy = freezed,
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
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        generatedAt: freezed == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        generatedBy: freezed == generatedBy
            ? _value.generatedBy
            : generatedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
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
    required this.code,
    required this.isActive,
    this.generatedAt,
    this.expiresAt,
    this.generatedBy,
  });

  factory _$EmployeeTimeCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeTimeCodeImplFromJson(json);

  @override
  final String id;
  @override
  final String employeeId;
  @override
  final String code;
  @override
  final bool isActive;
  @override
  final DateTime? generatedAt;
  @override
  final DateTime? expiresAt;
  @override
  final String? generatedBy;

  @override
  String toString() {
    return 'EmployeeTimeCode(id: $id, employeeId: $employeeId, code: $code, isActive: $isActive, generatedAt: $generatedAt, expiresAt: $expiresAt, generatedBy: $generatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeTimeCodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.generatedBy, generatedBy) ||
                other.generatedBy == generatedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    employeeId,
    code,
    isActive,
    generatedAt,
    expiresAt,
    generatedBy,
  );

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
    required final String code,
    required final bool isActive,
    final DateTime? generatedAt,
    final DateTime? expiresAt,
    final String? generatedBy,
  }) = _$EmployeeTimeCodeImpl;

  factory _EmployeeTimeCode.fromJson(Map<String, dynamic> json) =
      _$EmployeeTimeCodeImpl.fromJson;

  @override
  String get id;
  @override
  String get employeeId;
  @override
  String get code;
  @override
  bool get isActive;
  @override
  DateTime? get generatedAt;
  @override
  DateTime? get expiresAt;
  @override
  String? get generatedBy;

  /// Create a copy of EmployeeTimeCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeTimeCodeImplCopyWith<_$EmployeeTimeCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeeTimeCodeVerifyRequest _$EmployeeTimeCodeVerifyRequestFromJson(
  Map<String, dynamic> json,
) {
  return _EmployeeTimeCodeVerifyRequest.fromJson(json);
}

/// @nodoc
mixin _$EmployeeTimeCodeVerifyRequest {
  String get code => throw _privateConstructorUsedError;

  /// Serializes this EmployeeTimeCodeVerifyRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeTimeCodeVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeTimeCodeVerifyRequestCopyWith<EmployeeTimeCodeVerifyRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeTimeCodeVerifyRequestCopyWith<$Res> {
  factory $EmployeeTimeCodeVerifyRequestCopyWith(
    EmployeeTimeCodeVerifyRequest value,
    $Res Function(EmployeeTimeCodeVerifyRequest) then,
  ) =
      _$EmployeeTimeCodeVerifyRequestCopyWithImpl<
        $Res,
        EmployeeTimeCodeVerifyRequest
      >;
  @useResult
  $Res call({String code});
}

/// @nodoc
class _$EmployeeTimeCodeVerifyRequestCopyWithImpl<
  $Res,
  $Val extends EmployeeTimeCodeVerifyRequest
>
    implements $EmployeeTimeCodeVerifyRequestCopyWith<$Res> {
  _$EmployeeTimeCodeVerifyRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeTimeCodeVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null}) {
    return _then(
      _value.copyWith(
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeTimeCodeVerifyRequestImplCopyWith<$Res>
    implements $EmployeeTimeCodeVerifyRequestCopyWith<$Res> {
  factory _$$EmployeeTimeCodeVerifyRequestImplCopyWith(
    _$EmployeeTimeCodeVerifyRequestImpl value,
    $Res Function(_$EmployeeTimeCodeVerifyRequestImpl) then,
  ) = __$$EmployeeTimeCodeVerifyRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code});
}

/// @nodoc
class __$$EmployeeTimeCodeVerifyRequestImplCopyWithImpl<$Res>
    extends
        _$EmployeeTimeCodeVerifyRequestCopyWithImpl<
          $Res,
          _$EmployeeTimeCodeVerifyRequestImpl
        >
    implements _$$EmployeeTimeCodeVerifyRequestImplCopyWith<$Res> {
  __$$EmployeeTimeCodeVerifyRequestImplCopyWithImpl(
    _$EmployeeTimeCodeVerifyRequestImpl _value,
    $Res Function(_$EmployeeTimeCodeVerifyRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeTimeCodeVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null}) {
    return _then(
      _$EmployeeTimeCodeVerifyRequestImpl(
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeTimeCodeVerifyRequestImpl
    implements _EmployeeTimeCodeVerifyRequest {
  const _$EmployeeTimeCodeVerifyRequestImpl({required this.code});

  factory _$EmployeeTimeCodeVerifyRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$EmployeeTimeCodeVerifyRequestImplFromJson(json);

  @override
  final String code;

  @override
  String toString() {
    return 'EmployeeTimeCodeVerifyRequest(code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeTimeCodeVerifyRequestImpl &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code);

  /// Create a copy of EmployeeTimeCodeVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeTimeCodeVerifyRequestImplCopyWith<
    _$EmployeeTimeCodeVerifyRequestImpl
  >
  get copyWith =>
      __$$EmployeeTimeCodeVerifyRequestImplCopyWithImpl<
        _$EmployeeTimeCodeVerifyRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeTimeCodeVerifyRequestImplToJson(this);
  }
}

abstract class _EmployeeTimeCodeVerifyRequest
    implements EmployeeTimeCodeVerifyRequest {
  const factory _EmployeeTimeCodeVerifyRequest({required final String code}) =
      _$EmployeeTimeCodeVerifyRequestImpl;

  factory _EmployeeTimeCodeVerifyRequest.fromJson(Map<String, dynamic> json) =
      _$EmployeeTimeCodeVerifyRequestImpl.fromJson;

  @override
  String get code;

  /// Create a copy of EmployeeTimeCodeVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeTimeCodeVerifyRequestImplCopyWith<
    _$EmployeeTimeCodeVerifyRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

EmployeeCodeVerifyResponse _$EmployeeCodeVerifyResponseFromJson(
  Map<String, dynamic> json,
) {
  return _EmployeeCodeVerifyResponse.fromJson(json);
}

/// @nodoc
mixin _$EmployeeCodeVerifyResponse {
  bool get isValid => throw _privateConstructorUsedError;
  String? get employeeId => throw _privateConstructorUsedError;
  String? get employeeName => throw _privateConstructorUsedError;
  String? get employeeEmail => throw _privateConstructorUsedError;
  String? get salonId => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this EmployeeCodeVerifyResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeCodeVerifyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeCodeVerifyResponseCopyWith<EmployeeCodeVerifyResponse>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeCodeVerifyResponseCopyWith<$Res> {
  factory $EmployeeCodeVerifyResponseCopyWith(
    EmployeeCodeVerifyResponse value,
    $Res Function(EmployeeCodeVerifyResponse) then,
  ) =
      _$EmployeeCodeVerifyResponseCopyWithImpl<
        $Res,
        EmployeeCodeVerifyResponse
      >;
  @useResult
  $Res call({
    bool isValid,
    String? employeeId,
    String? employeeName,
    String? employeeEmail,
    String? salonId,
    String? errorMessage,
  });
}

/// @nodoc
class _$EmployeeCodeVerifyResponseCopyWithImpl<
  $Res,
  $Val extends EmployeeCodeVerifyResponse
>
    implements $EmployeeCodeVerifyResponseCopyWith<$Res> {
  _$EmployeeCodeVerifyResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeCodeVerifyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? employeeId = freezed,
    Object? employeeName = freezed,
    Object? employeeEmail = freezed,
    Object? salonId = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isValid: null == isValid
                ? _value.isValid
                : isValid // ignore: cast_nullable_to_non_nullable
                      as bool,
            employeeId: freezed == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            employeeName: freezed == employeeName
                ? _value.employeeName
                : employeeName // ignore: cast_nullable_to_non_nullable
                      as String?,
            employeeEmail: freezed == employeeEmail
                ? _value.employeeEmail
                : employeeEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            salonId: freezed == salonId
                ? _value.salonId
                : salonId // ignore: cast_nullable_to_non_nullable
                      as String?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeCodeVerifyResponseImplCopyWith<$Res>
    implements $EmployeeCodeVerifyResponseCopyWith<$Res> {
  factory _$$EmployeeCodeVerifyResponseImplCopyWith(
    _$EmployeeCodeVerifyResponseImpl value,
    $Res Function(_$EmployeeCodeVerifyResponseImpl) then,
  ) = __$$EmployeeCodeVerifyResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isValid,
    String? employeeId,
    String? employeeName,
    String? employeeEmail,
    String? salonId,
    String? errorMessage,
  });
}

/// @nodoc
class __$$EmployeeCodeVerifyResponseImplCopyWithImpl<$Res>
    extends
        _$EmployeeCodeVerifyResponseCopyWithImpl<
          $Res,
          _$EmployeeCodeVerifyResponseImpl
        >
    implements _$$EmployeeCodeVerifyResponseImplCopyWith<$Res> {
  __$$EmployeeCodeVerifyResponseImplCopyWithImpl(
    _$EmployeeCodeVerifyResponseImpl _value,
    $Res Function(_$EmployeeCodeVerifyResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeCodeVerifyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? employeeId = freezed,
    Object? employeeName = freezed,
    Object? employeeEmail = freezed,
    Object? salonId = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$EmployeeCodeVerifyResponseImpl(
        isValid: null == isValid
            ? _value.isValid
            : isValid // ignore: cast_nullable_to_non_nullable
                  as bool,
        employeeId: freezed == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        employeeName: freezed == employeeName
            ? _value.employeeName
            : employeeName // ignore: cast_nullable_to_non_nullable
                  as String?,
        employeeEmail: freezed == employeeEmail
            ? _value.employeeEmail
            : employeeEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        salonId: freezed == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeCodeVerifyResponseImpl implements _EmployeeCodeVerifyResponse {
  const _$EmployeeCodeVerifyResponseImpl({
    required this.isValid,
    this.employeeId,
    this.employeeName,
    this.employeeEmail,
    this.salonId,
    this.errorMessage,
  });

  factory _$EmployeeCodeVerifyResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$EmployeeCodeVerifyResponseImplFromJson(json);

  @override
  final bool isValid;
  @override
  final String? employeeId;
  @override
  final String? employeeName;
  @override
  final String? employeeEmail;
  @override
  final String? salonId;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'EmployeeCodeVerifyResponse(isValid: $isValid, employeeId: $employeeId, employeeName: $employeeName, employeeEmail: $employeeEmail, salonId: $salonId, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeCodeVerifyResponseImpl &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.employeeEmail, employeeEmail) ||
                other.employeeEmail == employeeEmail) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isValid,
    employeeId,
    employeeName,
    employeeEmail,
    salonId,
    errorMessage,
  );

  /// Create a copy of EmployeeCodeVerifyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeCodeVerifyResponseImplCopyWith<_$EmployeeCodeVerifyResponseImpl>
  get copyWith =>
      __$$EmployeeCodeVerifyResponseImplCopyWithImpl<
        _$EmployeeCodeVerifyResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeCodeVerifyResponseImplToJson(this);
  }
}

abstract class _EmployeeCodeVerifyResponse
    implements EmployeeCodeVerifyResponse {
  const factory _EmployeeCodeVerifyResponse({
    required final bool isValid,
    final String? employeeId,
    final String? employeeName,
    final String? employeeEmail,
    final String? salonId,
    final String? errorMessage,
  }) = _$EmployeeCodeVerifyResponseImpl;

  factory _EmployeeCodeVerifyResponse.fromJson(Map<String, dynamic> json) =
      _$EmployeeCodeVerifyResponseImpl.fromJson;

  @override
  bool get isValid;
  @override
  String? get employeeId;
  @override
  String? get employeeName;
  @override
  String? get employeeEmail;
  @override
  String? get salonId;
  @override
  String? get errorMessage;

  /// Create a copy of EmployeeCodeVerifyResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeCodeVerifyResponseImplCopyWith<_$EmployeeCodeVerifyResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
