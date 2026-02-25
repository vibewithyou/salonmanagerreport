// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ModuleSettings _$ModuleSettingsFromJson(Map<String, dynamic> json) {
  return _ModuleSettings.fromJson(json);
}

/// @nodoc
mixin _$ModuleSettings {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  ModuleType get moduleType => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  List<ModulePermission> get permissions => throw _privateConstructorUsedError;
  DateTime get enabledAt => throw _privateConstructorUsedError;
  DateTime? get disabledAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get configuration => throw _privateConstructorUsedError;

  /// Serializes this ModuleSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ModuleSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModuleSettingsCopyWith<ModuleSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModuleSettingsCopyWith<$Res> {
  factory $ModuleSettingsCopyWith(
    ModuleSettings value,
    $Res Function(ModuleSettings) then,
  ) = _$ModuleSettingsCopyWithImpl<$Res, ModuleSettings>;
  @useResult
  $Res call({
    String id,
    String salonId,
    ModuleType moduleType,
    bool isEnabled,
    List<ModulePermission> permissions,
    DateTime enabledAt,
    DateTime? disabledAt,
    Map<String, dynamic>? configuration,
  });
}

/// @nodoc
class _$ModuleSettingsCopyWithImpl<$Res, $Val extends ModuleSettings>
    implements $ModuleSettingsCopyWith<$Res> {
  _$ModuleSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModuleSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? moduleType = null,
    Object? isEnabled = null,
    Object? permissions = null,
    Object? enabledAt = null,
    Object? disabledAt = freezed,
    Object? configuration = freezed,
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
            moduleType: null == moduleType
                ? _value.moduleType
                : moduleType // ignore: cast_nullable_to_non_nullable
                      as ModuleType,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            permissions: null == permissions
                ? _value.permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                      as List<ModulePermission>,
            enabledAt: null == enabledAt
                ? _value.enabledAt
                : enabledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            disabledAt: freezed == disabledAt
                ? _value.disabledAt
                : disabledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            configuration: freezed == configuration
                ? _value.configuration
                : configuration // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ModuleSettingsImplCopyWith<$Res>
    implements $ModuleSettingsCopyWith<$Res> {
  factory _$$ModuleSettingsImplCopyWith(
    _$ModuleSettingsImpl value,
    $Res Function(_$ModuleSettingsImpl) then,
  ) = __$$ModuleSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    ModuleType moduleType,
    bool isEnabled,
    List<ModulePermission> permissions,
    DateTime enabledAt,
    DateTime? disabledAt,
    Map<String, dynamic>? configuration,
  });
}

/// @nodoc
class __$$ModuleSettingsImplCopyWithImpl<$Res>
    extends _$ModuleSettingsCopyWithImpl<$Res, _$ModuleSettingsImpl>
    implements _$$ModuleSettingsImplCopyWith<$Res> {
  __$$ModuleSettingsImplCopyWithImpl(
    _$ModuleSettingsImpl _value,
    $Res Function(_$ModuleSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ModuleSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? moduleType = null,
    Object? isEnabled = null,
    Object? permissions = null,
    Object? enabledAt = null,
    Object? disabledAt = freezed,
    Object? configuration = freezed,
  }) {
    return _then(
      _$ModuleSettingsImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        moduleType: null == moduleType
            ? _value.moduleType
            : moduleType // ignore: cast_nullable_to_non_nullable
                  as ModuleType,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        permissions: null == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<ModulePermission>,
        enabledAt: null == enabledAt
            ? _value.enabledAt
            : enabledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        disabledAt: freezed == disabledAt
            ? _value.disabledAt
            : disabledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        configuration: freezed == configuration
            ? _value._configuration
            : configuration // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ModuleSettingsImpl implements _ModuleSettings {
  const _$ModuleSettingsImpl({
    required this.id,
    required this.salonId,
    required this.moduleType,
    required this.isEnabled,
    required final List<ModulePermission> permissions,
    required this.enabledAt,
    this.disabledAt,
    final Map<String, dynamic>? configuration,
  }) : _permissions = permissions,
       _configuration = configuration;

  factory _$ModuleSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModuleSettingsImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final ModuleType moduleType;
  @override
  final bool isEnabled;
  final List<ModulePermission> _permissions;
  @override
  List<ModulePermission> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final DateTime enabledAt;
  @override
  final DateTime? disabledAt;
  final Map<String, dynamic>? _configuration;
  @override
  Map<String, dynamic>? get configuration {
    final value = _configuration;
    if (value == null) return null;
    if (_configuration is EqualUnmodifiableMapView) return _configuration;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ModuleSettings(id: $id, salonId: $salonId, moduleType: $moduleType, isEnabled: $isEnabled, permissions: $permissions, enabledAt: $enabledAt, disabledAt: $disabledAt, configuration: $configuration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModuleSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.moduleType, moduleType) ||
                other.moduleType == moduleType) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ) &&
            (identical(other.enabledAt, enabledAt) ||
                other.enabledAt == enabledAt) &&
            (identical(other.disabledAt, disabledAt) ||
                other.disabledAt == disabledAt) &&
            const DeepCollectionEquality().equals(
              other._configuration,
              _configuration,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    moduleType,
    isEnabled,
    const DeepCollectionEquality().hash(_permissions),
    enabledAt,
    disabledAt,
    const DeepCollectionEquality().hash(_configuration),
  );

  /// Create a copy of ModuleSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModuleSettingsImplCopyWith<_$ModuleSettingsImpl> get copyWith =>
      __$$ModuleSettingsImplCopyWithImpl<_$ModuleSettingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ModuleSettingsImplToJson(this);
  }
}

abstract class _ModuleSettings implements ModuleSettings {
  const factory _ModuleSettings({
    required final String id,
    required final String salonId,
    required final ModuleType moduleType,
    required final bool isEnabled,
    required final List<ModulePermission> permissions,
    required final DateTime enabledAt,
    final DateTime? disabledAt,
    final Map<String, dynamic>? configuration,
  }) = _$ModuleSettingsImpl;

  factory _ModuleSettings.fromJson(Map<String, dynamic> json) =
      _$ModuleSettingsImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  ModuleType get moduleType;
  @override
  bool get isEnabled;
  @override
  List<ModulePermission> get permissions;
  @override
  DateTime get enabledAt;
  @override
  DateTime? get disabledAt;
  @override
  Map<String, dynamic>? get configuration;

  /// Create a copy of ModuleSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModuleSettingsImplCopyWith<_$ModuleSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DashboardModule _$DashboardModuleFromJson(Map<String, dynamic> json) {
  return _DashboardModule.fromJson(json);
}

/// @nodoc
mixin _$DashboardModule {
  ModuleType get type => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  List<ModulePermission> get permissions => throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;
  bool? get isRequired => throw _privateConstructorUsedError;

  /// Serializes this DashboardModule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardModule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardModuleCopyWith<DashboardModule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardModuleCopyWith<$Res> {
  factory $DashboardModuleCopyWith(
    DashboardModule value,
    $Res Function(DashboardModule) then,
  ) = _$DashboardModuleCopyWithImpl<$Res, DashboardModule>;
  @useResult
  $Res call({
    ModuleType type,
    String label,
    String icon,
    String? description,
    bool isEnabled,
    List<ModulePermission> permissions,
    bool isPremium,
    bool? isRequired,
  });
}

/// @nodoc
class _$DashboardModuleCopyWithImpl<$Res, $Val extends DashboardModule>
    implements $DashboardModuleCopyWith<$Res> {
  _$DashboardModuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardModule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? label = null,
    Object? icon = null,
    Object? description = freezed,
    Object? isEnabled = null,
    Object? permissions = null,
    Object? isPremium = null,
    Object? isRequired = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ModuleType,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            permissions: null == permissions
                ? _value.permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                      as List<ModulePermission>,
            isPremium: null == isPremium
                ? _value.isPremium
                : isPremium // ignore: cast_nullable_to_non_nullable
                      as bool,
            isRequired: freezed == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardModuleImplCopyWith<$Res>
    implements $DashboardModuleCopyWith<$Res> {
  factory _$$DashboardModuleImplCopyWith(
    _$DashboardModuleImpl value,
    $Res Function(_$DashboardModuleImpl) then,
  ) = __$$DashboardModuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ModuleType type,
    String label,
    String icon,
    String? description,
    bool isEnabled,
    List<ModulePermission> permissions,
    bool isPremium,
    bool? isRequired,
  });
}

/// @nodoc
class __$$DashboardModuleImplCopyWithImpl<$Res>
    extends _$DashboardModuleCopyWithImpl<$Res, _$DashboardModuleImpl>
    implements _$$DashboardModuleImplCopyWith<$Res> {
  __$$DashboardModuleImplCopyWithImpl(
    _$DashboardModuleImpl _value,
    $Res Function(_$DashboardModuleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardModule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? label = null,
    Object? icon = null,
    Object? description = freezed,
    Object? isEnabled = null,
    Object? permissions = null,
    Object? isPremium = null,
    Object? isRequired = freezed,
  }) {
    return _then(
      _$DashboardModuleImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ModuleType,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        permissions: null == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<ModulePermission>,
        isPremium: null == isPremium
            ? _value.isPremium
            : isPremium // ignore: cast_nullable_to_non_nullable
                  as bool,
        isRequired: freezed == isRequired
            ? _value.isRequired
            : isRequired // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardModuleImpl implements _DashboardModule {
  const _$DashboardModuleImpl({
    required this.type,
    required this.label,
    required this.icon,
    this.description,
    required this.isEnabled,
    required final List<ModulePermission> permissions,
    required this.isPremium,
    this.isRequired,
  }) : _permissions = permissions;

  factory _$DashboardModuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardModuleImplFromJson(json);

  @override
  final ModuleType type;
  @override
  final String label;
  @override
  final String icon;
  @override
  final String? description;
  @override
  final bool isEnabled;
  final List<ModulePermission> _permissions;
  @override
  List<ModulePermission> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final bool isPremium;
  @override
  final bool? isRequired;

  @override
  String toString() {
    return 'DashboardModule(type: $type, label: $label, icon: $icon, description: $description, isEnabled: $isEnabled, permissions: $permissions, isPremium: $isPremium, isRequired: $isRequired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardModuleImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    label,
    icon,
    description,
    isEnabled,
    const DeepCollectionEquality().hash(_permissions),
    isPremium,
    isRequired,
  );

  /// Create a copy of DashboardModule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardModuleImplCopyWith<_$DashboardModuleImpl> get copyWith =>
      __$$DashboardModuleImplCopyWithImpl<_$DashboardModuleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardModuleImplToJson(this);
  }
}

abstract class _DashboardModule implements DashboardModule {
  const factory _DashboardModule({
    required final ModuleType type,
    required final String label,
    required final String icon,
    final String? description,
    required final bool isEnabled,
    required final List<ModulePermission> permissions,
    required final bool isPremium,
    final bool? isRequired,
  }) = _$DashboardModuleImpl;

  factory _DashboardModule.fromJson(Map<String, dynamic> json) =
      _$DashboardModuleImpl.fromJson;

  @override
  ModuleType get type;
  @override
  String get label;
  @override
  String get icon;
  @override
  String? get description;
  @override
  bool get isEnabled;
  @override
  List<ModulePermission> get permissions;
  @override
  bool get isPremium;
  @override
  bool? get isRequired;

  /// Create a copy of DashboardModule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardModuleImplCopyWith<_$DashboardModuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
