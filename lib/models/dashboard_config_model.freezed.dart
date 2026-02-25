// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardConfig _$DashboardConfigFromJson(Map<String, dynamic> json) {
  return _DashboardConfig.fromJson(json);
}

/// @nodoc
mixin _$DashboardConfig {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  Map<String, dynamic> get enabledModules => throw _privateConstructorUsedError;
  Map<String, dynamic> get permissions => throw _privateConstructorUsedError;
  String? get salonCodeHash => throw _privateConstructorUsedError;
  String? get salonCodePlaintext => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get salonCodeUpdatedAt => throw _privateConstructorUsedError;

  /// Serializes this DashboardConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardConfigCopyWith<DashboardConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardConfigCopyWith<$Res> {
  factory $DashboardConfigCopyWith(
    DashboardConfig value,
    $Res Function(DashboardConfig) then,
  ) = _$DashboardConfigCopyWithImpl<$Res, DashboardConfig>;
  @useResult
  $Res call({
    String id,
    String salonId,
    Map<String, dynamic> enabledModules,
    Map<String, dynamic> permissions,
    String? salonCodeHash,
    String? salonCodePlaintext,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? salonCodeUpdatedAt,
  });
}

/// @nodoc
class _$DashboardConfigCopyWithImpl<$Res, $Val extends DashboardConfig>
    implements $DashboardConfigCopyWith<$Res> {
  _$DashboardConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? enabledModules = null,
    Object? permissions = null,
    Object? salonCodeHash = freezed,
    Object? salonCodePlaintext = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? salonCodeUpdatedAt = freezed,
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
            enabledModules: null == enabledModules
                ? _value.enabledModules
                : enabledModules // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            permissions: null == permissions
                ? _value.permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            salonCodeHash: freezed == salonCodeHash
                ? _value.salonCodeHash
                : salonCodeHash // ignore: cast_nullable_to_non_nullable
                      as String?,
            salonCodePlaintext: freezed == salonCodePlaintext
                ? _value.salonCodePlaintext
                : salonCodePlaintext // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            salonCodeUpdatedAt: freezed == salonCodeUpdatedAt
                ? _value.salonCodeUpdatedAt
                : salonCodeUpdatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardConfigImplCopyWith<$Res>
    implements $DashboardConfigCopyWith<$Res> {
  factory _$$DashboardConfigImplCopyWith(
    _$DashboardConfigImpl value,
    $Res Function(_$DashboardConfigImpl) then,
  ) = __$$DashboardConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    Map<String, dynamic> enabledModules,
    Map<String, dynamic> permissions,
    String? salonCodeHash,
    String? salonCodePlaintext,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? salonCodeUpdatedAt,
  });
}

/// @nodoc
class __$$DashboardConfigImplCopyWithImpl<$Res>
    extends _$DashboardConfigCopyWithImpl<$Res, _$DashboardConfigImpl>
    implements _$$DashboardConfigImplCopyWith<$Res> {
  __$$DashboardConfigImplCopyWithImpl(
    _$DashboardConfigImpl _value,
    $Res Function(_$DashboardConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? enabledModules = null,
    Object? permissions = null,
    Object? salonCodeHash = freezed,
    Object? salonCodePlaintext = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? salonCodeUpdatedAt = freezed,
  }) {
    return _then(
      _$DashboardConfigImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        enabledModules: null == enabledModules
            ? _value._enabledModules
            : enabledModules // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        permissions: null == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        salonCodeHash: freezed == salonCodeHash
            ? _value.salonCodeHash
            : salonCodeHash // ignore: cast_nullable_to_non_nullable
                  as String?,
        salonCodePlaintext: freezed == salonCodePlaintext
            ? _value.salonCodePlaintext
            : salonCodePlaintext // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        salonCodeUpdatedAt: freezed == salonCodeUpdatedAt
            ? _value.salonCodeUpdatedAt
            : salonCodeUpdatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardConfigImpl implements _DashboardConfig {
  const _$DashboardConfigImpl({
    required this.id,
    required this.salonId,
    required final Map<String, dynamic> enabledModules,
    required final Map<String, dynamic> permissions,
    this.salonCodeHash,
    this.salonCodePlaintext,
    required this.createdAt,
    required this.updatedAt,
    this.salonCodeUpdatedAt,
  }) : _enabledModules = enabledModules,
       _permissions = permissions;

  factory _$DashboardConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  final Map<String, dynamic> _enabledModules;
  @override
  Map<String, dynamic> get enabledModules {
    if (_enabledModules is EqualUnmodifiableMapView) return _enabledModules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_enabledModules);
  }

  final Map<String, dynamic> _permissions;
  @override
  Map<String, dynamic> get permissions {
    if (_permissions is EqualUnmodifiableMapView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_permissions);
  }

  @override
  final String? salonCodeHash;
  @override
  final String? salonCodePlaintext;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? salonCodeUpdatedAt;

  @override
  String toString() {
    return 'DashboardConfig(id: $id, salonId: $salonId, enabledModules: $enabledModules, permissions: $permissions, salonCodeHash: $salonCodeHash, salonCodePlaintext: $salonCodePlaintext, createdAt: $createdAt, updatedAt: $updatedAt, salonCodeUpdatedAt: $salonCodeUpdatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            const DeepCollectionEquality().equals(
              other._enabledModules,
              _enabledModules,
            ) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ) &&
            (identical(other.salonCodeHash, salonCodeHash) ||
                other.salonCodeHash == salonCodeHash) &&
            (identical(other.salonCodePlaintext, salonCodePlaintext) ||
                other.salonCodePlaintext == salonCodePlaintext) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.salonCodeUpdatedAt, salonCodeUpdatedAt) ||
                other.salonCodeUpdatedAt == salonCodeUpdatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    const DeepCollectionEquality().hash(_enabledModules),
    const DeepCollectionEquality().hash(_permissions),
    salonCodeHash,
    salonCodePlaintext,
    createdAt,
    updatedAt,
    salonCodeUpdatedAt,
  );

  /// Create a copy of DashboardConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardConfigImplCopyWith<_$DashboardConfigImpl> get copyWith =>
      __$$DashboardConfigImplCopyWithImpl<_$DashboardConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardConfigImplToJson(this);
  }
}

abstract class _DashboardConfig implements DashboardConfig {
  const factory _DashboardConfig({
    required final String id,
    required final String salonId,
    required final Map<String, dynamic> enabledModules,
    required final Map<String, dynamic> permissions,
    final String? salonCodeHash,
    final String? salonCodePlaintext,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? salonCodeUpdatedAt,
  }) = _$DashboardConfigImpl;

  factory _DashboardConfig.fromJson(Map<String, dynamic> json) =
      _$DashboardConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  Map<String, dynamic> get enabledModules;
  @override
  Map<String, dynamic> get permissions;
  @override
  String? get salonCodeHash;
  @override
  String? get salonCodePlaintext;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get salonCodeUpdatedAt;

  /// Create a copy of DashboardConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardConfigImplCopyWith<_$DashboardConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
