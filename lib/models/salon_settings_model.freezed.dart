// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salon_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalonSettings _$SalonSettingsFromJson(Map<String, dynamic> json) {
  return _SalonSettings.fromJson(json);
}

/// @nodoc
mixin _$SalonSettings {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get salonName => throw _privateConstructorUsedError;
  String? get salonDescription => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get postalCode => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get coverImageUrl => throw _privateConstructorUsedError;
  String? get taxId => throw _privateConstructorUsedError;
  String? get bankAccount => throw _privateConstructorUsedError;
  List<BusinessHours>? get businessHours => throw _privateConstructorUsedError;
  List<Holiday>? get holidays => throw _privateConstructorUsedError;
  List<PaymentMethod>? get paymentMethods => throw _privateConstructorUsedError;
  Map<String, dynamic>? get globalPermissions =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get globalModuleSettings =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SalonSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalonSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalonSettingsCopyWith<SalonSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalonSettingsCopyWith<$Res> {
  factory $SalonSettingsCopyWith(
    SalonSettings value,
    $Res Function(SalonSettings) then,
  ) = _$SalonSettingsCopyWithImpl<$Res, SalonSettings>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String salonName,
    String? salonDescription,
    String? address,
    String? city,
    String? postalCode,
    String? phone,
    String? email,
    String? website,
    String? logoUrl,
    String? coverImageUrl,
    String? taxId,
    String? bankAccount,
    List<BusinessHours>? businessHours,
    List<Holiday>? holidays,
    List<PaymentMethod>? paymentMethods,
    Map<String, dynamic>? globalPermissions,
    Map<String, dynamic>? globalModuleSettings,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$SalonSettingsCopyWithImpl<$Res, $Val extends SalonSettings>
    implements $SalonSettingsCopyWith<$Res> {
  _$SalonSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalonSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? salonName = null,
    Object? salonDescription = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? logoUrl = freezed,
    Object? coverImageUrl = freezed,
    Object? taxId = freezed,
    Object? bankAccount = freezed,
    Object? businessHours = freezed,
    Object? holidays = freezed,
    Object? paymentMethods = freezed,
    Object? globalPermissions = freezed,
    Object? globalModuleSettings = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
            salonName: null == salonName
                ? _value.salonName
                : salonName // ignore: cast_nullable_to_non_nullable
                      as String,
            salonDescription: freezed == salonDescription
                ? _value.salonDescription
                : salonDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            postalCode: freezed == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            website: freezed == website
                ? _value.website
                : website // ignore: cast_nullable_to_non_nullable
                      as String?,
            logoUrl: freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            coverImageUrl: freezed == coverImageUrl
                ? _value.coverImageUrl
                : coverImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            taxId: freezed == taxId
                ? _value.taxId
                : taxId // ignore: cast_nullable_to_non_nullable
                      as String?,
            bankAccount: freezed == bankAccount
                ? _value.bankAccount
                : bankAccount // ignore: cast_nullable_to_non_nullable
                      as String?,
            businessHours: freezed == businessHours
                ? _value.businessHours
                : businessHours // ignore: cast_nullable_to_non_nullable
                      as List<BusinessHours>?,
            holidays: freezed == holidays
                ? _value.holidays
                : holidays // ignore: cast_nullable_to_non_nullable
                      as List<Holiday>?,
            paymentMethods: freezed == paymentMethods
                ? _value.paymentMethods
                : paymentMethods // ignore: cast_nullable_to_non_nullable
                      as List<PaymentMethod>?,
            globalPermissions: freezed == globalPermissions
                ? _value.globalPermissions
                : globalPermissions // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            globalModuleSettings: freezed == globalModuleSettings
                ? _value.globalModuleSettings
                : globalModuleSettings // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
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
abstract class _$$SalonSettingsImplCopyWith<$Res>
    implements $SalonSettingsCopyWith<$Res> {
  factory _$$SalonSettingsImplCopyWith(
    _$SalonSettingsImpl value,
    $Res Function(_$SalonSettingsImpl) then,
  ) = __$$SalonSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String salonName,
    String? salonDescription,
    String? address,
    String? city,
    String? postalCode,
    String? phone,
    String? email,
    String? website,
    String? logoUrl,
    String? coverImageUrl,
    String? taxId,
    String? bankAccount,
    List<BusinessHours>? businessHours,
    List<Holiday>? holidays,
    List<PaymentMethod>? paymentMethods,
    Map<String, dynamic>? globalPermissions,
    Map<String, dynamic>? globalModuleSettings,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$SalonSettingsImplCopyWithImpl<$Res>
    extends _$SalonSettingsCopyWithImpl<$Res, _$SalonSettingsImpl>
    implements _$$SalonSettingsImplCopyWith<$Res> {
  __$$SalonSettingsImplCopyWithImpl(
    _$SalonSettingsImpl _value,
    $Res Function(_$SalonSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalonSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? salonName = null,
    Object? salonDescription = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? logoUrl = freezed,
    Object? coverImageUrl = freezed,
    Object? taxId = freezed,
    Object? bankAccount = freezed,
    Object? businessHours = freezed,
    Object? holidays = freezed,
    Object? paymentMethods = freezed,
    Object? globalPermissions = freezed,
    Object? globalModuleSettings = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$SalonSettingsImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        salonName: null == salonName
            ? _value.salonName
            : salonName // ignore: cast_nullable_to_non_nullable
                  as String,
        salonDescription: freezed == salonDescription
            ? _value.salonDescription
            : salonDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        postalCode: freezed == postalCode
            ? _value.postalCode
            : postalCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        website: freezed == website
            ? _value.website
            : website // ignore: cast_nullable_to_non_nullable
                  as String?,
        logoUrl: freezed == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        coverImageUrl: freezed == coverImageUrl
            ? _value.coverImageUrl
            : coverImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        taxId: freezed == taxId
            ? _value.taxId
            : taxId // ignore: cast_nullable_to_non_nullable
                  as String?,
        bankAccount: freezed == bankAccount
            ? _value.bankAccount
            : bankAccount // ignore: cast_nullable_to_non_nullable
                  as String?,
        businessHours: freezed == businessHours
            ? _value._businessHours
            : businessHours // ignore: cast_nullable_to_non_nullable
                  as List<BusinessHours>?,
        holidays: freezed == holidays
            ? _value._holidays
            : holidays // ignore: cast_nullable_to_non_nullable
                  as List<Holiday>?,
        paymentMethods: freezed == paymentMethods
            ? _value._paymentMethods
            : paymentMethods // ignore: cast_nullable_to_non_nullable
                  as List<PaymentMethod>?,
        globalPermissions: freezed == globalPermissions
            ? _value._globalPermissions
            : globalPermissions // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        globalModuleSettings: freezed == globalModuleSettings
            ? _value._globalModuleSettings
            : globalModuleSettings // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
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
class _$SalonSettingsImpl implements _SalonSettings {
  const _$SalonSettingsImpl({
    required this.id,
    required this.salonId,
    required this.salonName,
    this.salonDescription,
    this.address,
    this.city,
    this.postalCode,
    this.phone,
    this.email,
    this.website,
    this.logoUrl,
    this.coverImageUrl,
    this.taxId,
    this.bankAccount,
    final List<BusinessHours>? businessHours,
    final List<Holiday>? holidays,
    final List<PaymentMethod>? paymentMethods,
    final Map<String, dynamic>? globalPermissions,
    final Map<String, dynamic>? globalModuleSettings,
    required this.createdAt,
    required this.updatedAt,
  }) : _businessHours = businessHours,
       _holidays = holidays,
       _paymentMethods = paymentMethods,
       _globalPermissions = globalPermissions,
       _globalModuleSettings = globalModuleSettings;

  factory _$SalonSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalonSettingsImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String salonName;
  @override
  final String? salonDescription;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? postalCode;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? website;
  @override
  final String? logoUrl;
  @override
  final String? coverImageUrl;
  @override
  final String? taxId;
  @override
  final String? bankAccount;
  final List<BusinessHours>? _businessHours;
  @override
  List<BusinessHours>? get businessHours {
    final value = _businessHours;
    if (value == null) return null;
    if (_businessHours is EqualUnmodifiableListView) return _businessHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Holiday>? _holidays;
  @override
  List<Holiday>? get holidays {
    final value = _holidays;
    if (value == null) return null;
    if (_holidays is EqualUnmodifiableListView) return _holidays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PaymentMethod>? _paymentMethods;
  @override
  List<PaymentMethod>? get paymentMethods {
    final value = _paymentMethods;
    if (value == null) return null;
    if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _globalPermissions;
  @override
  Map<String, dynamic>? get globalPermissions {
    final value = _globalPermissions;
    if (value == null) return null;
    if (_globalPermissions is EqualUnmodifiableMapView)
      return _globalPermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _globalModuleSettings;
  @override
  Map<String, dynamic>? get globalModuleSettings {
    final value = _globalModuleSettings;
    if (value == null) return null;
    if (_globalModuleSettings is EqualUnmodifiableMapView)
      return _globalModuleSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SalonSettings(id: $id, salonId: $salonId, salonName: $salonName, salonDescription: $salonDescription, address: $address, city: $city, postalCode: $postalCode, phone: $phone, email: $email, website: $website, logoUrl: $logoUrl, coverImageUrl: $coverImageUrl, taxId: $taxId, bankAccount: $bankAccount, businessHours: $businessHours, holidays: $holidays, paymentMethods: $paymentMethods, globalPermissions: $globalPermissions, globalModuleSettings: $globalModuleSettings, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalonSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.salonName, salonName) ||
                other.salonName == salonName) &&
            (identical(other.salonDescription, salonDescription) ||
                other.salonDescription == salonDescription) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.taxId, taxId) || other.taxId == taxId) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount) &&
            const DeepCollectionEquality().equals(
              other._businessHours,
              _businessHours,
            ) &&
            const DeepCollectionEquality().equals(other._holidays, _holidays) &&
            const DeepCollectionEquality().equals(
              other._paymentMethods,
              _paymentMethods,
            ) &&
            const DeepCollectionEquality().equals(
              other._globalPermissions,
              _globalPermissions,
            ) &&
            const DeepCollectionEquality().equals(
              other._globalModuleSettings,
              _globalModuleSettings,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    salonId,
    salonName,
    salonDescription,
    address,
    city,
    postalCode,
    phone,
    email,
    website,
    logoUrl,
    coverImageUrl,
    taxId,
    bankAccount,
    const DeepCollectionEquality().hash(_businessHours),
    const DeepCollectionEquality().hash(_holidays),
    const DeepCollectionEquality().hash(_paymentMethods),
    const DeepCollectionEquality().hash(_globalPermissions),
    const DeepCollectionEquality().hash(_globalModuleSettings),
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of SalonSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalonSettingsImplCopyWith<_$SalonSettingsImpl> get copyWith =>
      __$$SalonSettingsImplCopyWithImpl<_$SalonSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalonSettingsImplToJson(this);
  }
}

abstract class _SalonSettings implements SalonSettings {
  const factory _SalonSettings({
    required final String id,
    required final String salonId,
    required final String salonName,
    final String? salonDescription,
    final String? address,
    final String? city,
    final String? postalCode,
    final String? phone,
    final String? email,
    final String? website,
    final String? logoUrl,
    final String? coverImageUrl,
    final String? taxId,
    final String? bankAccount,
    final List<BusinessHours>? businessHours,
    final List<Holiday>? holidays,
    final List<PaymentMethod>? paymentMethods,
    final Map<String, dynamic>? globalPermissions,
    final Map<String, dynamic>? globalModuleSettings,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$SalonSettingsImpl;

  factory _SalonSettings.fromJson(Map<String, dynamic> json) =
      _$SalonSettingsImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get salonName;
  @override
  String? get salonDescription;
  @override
  String? get address;
  @override
  String? get city;
  @override
  String? get postalCode;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get website;
  @override
  String? get logoUrl;
  @override
  String? get coverImageUrl;
  @override
  String? get taxId;
  @override
  String? get bankAccount;
  @override
  List<BusinessHours>? get businessHours;
  @override
  List<Holiday>? get holidays;
  @override
  List<PaymentMethod>? get paymentMethods;
  @override
  Map<String, dynamic>? get globalPermissions;
  @override
  Map<String, dynamic>? get globalModuleSettings;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of SalonSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalonSettingsImplCopyWith<_$SalonSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BusinessHours _$BusinessHoursFromJson(Map<String, dynamic> json) {
  return _BusinessHours.fromJson(json);
}

/// @nodoc
mixin _$BusinessHours {
  int get dayOfWeek =>
      throw _privateConstructorUsedError; // 0 = Monday, 6 = Sunday
  String get dayName =>
      throw _privateConstructorUsedError; // "Montag", "Dienstag", etc.
  bool get isOpen => throw _privateConstructorUsedError;
  String? get openTime => throw _privateConstructorUsedError; // HH:mm format
  String? get closeTime => throw _privateConstructorUsedError;

  /// Serializes this BusinessHours to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusinessHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessHoursCopyWith<BusinessHours> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessHoursCopyWith<$Res> {
  factory $BusinessHoursCopyWith(
    BusinessHours value,
    $Res Function(BusinessHours) then,
  ) = _$BusinessHoursCopyWithImpl<$Res, BusinessHours>;
  @useResult
  $Res call({
    int dayOfWeek,
    String dayName,
    bool isOpen,
    String? openTime,
    String? closeTime,
  });
}

/// @nodoc
class _$BusinessHoursCopyWithImpl<$Res, $Val extends BusinessHours>
    implements $BusinessHoursCopyWith<$Res> {
  _$BusinessHoursCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? dayName = null,
    Object? isOpen = null,
    Object? openTime = freezed,
    Object? closeTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            dayOfWeek: null == dayOfWeek
                ? _value.dayOfWeek
                : dayOfWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            dayName: null == dayName
                ? _value.dayName
                : dayName // ignore: cast_nullable_to_non_nullable
                      as String,
            isOpen: null == isOpen
                ? _value.isOpen
                : isOpen // ignore: cast_nullable_to_non_nullable
                      as bool,
            openTime: freezed == openTime
                ? _value.openTime
                : openTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            closeTime: freezed == closeTime
                ? _value.closeTime
                : closeTime // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BusinessHoursImplCopyWith<$Res>
    implements $BusinessHoursCopyWith<$Res> {
  factory _$$BusinessHoursImplCopyWith(
    _$BusinessHoursImpl value,
    $Res Function(_$BusinessHoursImpl) then,
  ) = __$$BusinessHoursImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int dayOfWeek,
    String dayName,
    bool isOpen,
    String? openTime,
    String? closeTime,
  });
}

/// @nodoc
class __$$BusinessHoursImplCopyWithImpl<$Res>
    extends _$BusinessHoursCopyWithImpl<$Res, _$BusinessHoursImpl>
    implements _$$BusinessHoursImplCopyWith<$Res> {
  __$$BusinessHoursImplCopyWithImpl(
    _$BusinessHoursImpl _value,
    $Res Function(_$BusinessHoursImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? dayName = null,
    Object? isOpen = null,
    Object? openTime = freezed,
    Object? closeTime = freezed,
  }) {
    return _then(
      _$BusinessHoursImpl(
        dayOfWeek: null == dayOfWeek
            ? _value.dayOfWeek
            : dayOfWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        dayName: null == dayName
            ? _value.dayName
            : dayName // ignore: cast_nullable_to_non_nullable
                  as String,
        isOpen: null == isOpen
            ? _value.isOpen
            : isOpen // ignore: cast_nullable_to_non_nullable
                  as bool,
        openTime: freezed == openTime
            ? _value.openTime
            : openTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        closeTime: freezed == closeTime
            ? _value.closeTime
            : closeTime // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessHoursImpl implements _BusinessHours {
  const _$BusinessHoursImpl({
    required this.dayOfWeek,
    required this.dayName,
    required this.isOpen,
    this.openTime,
    this.closeTime,
  });

  factory _$BusinessHoursImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessHoursImplFromJson(json);

  @override
  final int dayOfWeek;
  // 0 = Monday, 6 = Sunday
  @override
  final String dayName;
  // "Montag", "Dienstag", etc.
  @override
  final bool isOpen;
  @override
  final String? openTime;
  // HH:mm format
  @override
  final String? closeTime;

  @override
  String toString() {
    return 'BusinessHours(dayOfWeek: $dayOfWeek, dayName: $dayName, isOpen: $isOpen, openTime: $openTime, closeTime: $closeTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessHoursImpl &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.dayName, dayName) || other.dayName == dayName) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.openTime, openTime) ||
                other.openTime == openTime) &&
            (identical(other.closeTime, closeTime) ||
                other.closeTime == closeTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, dayOfWeek, dayName, isOpen, openTime, closeTime);

  /// Create a copy of BusinessHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessHoursImplCopyWith<_$BusinessHoursImpl> get copyWith =>
      __$$BusinessHoursImplCopyWithImpl<_$BusinessHoursImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessHoursImplToJson(this);
  }
}

abstract class _BusinessHours implements BusinessHours {
  const factory _BusinessHours({
    required final int dayOfWeek,
    required final String dayName,
    required final bool isOpen,
    final String? openTime,
    final String? closeTime,
  }) = _$BusinessHoursImpl;

  factory _BusinessHours.fromJson(Map<String, dynamic> json) =
      _$BusinessHoursImpl.fromJson;

  @override
  int get dayOfWeek; // 0 = Monday, 6 = Sunday
  @override
  String get dayName; // "Montag", "Dienstag", etc.
  @override
  bool get isOpen;
  @override
  String? get openTime; // HH:mm format
  @override
  String? get closeTime;

  /// Create a copy of BusinessHours
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessHoursImplCopyWith<_$BusinessHoursImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Holiday _$HolidayFromJson(Map<String, dynamic> json) {
  return _Holiday.fromJson(json);
}

/// @nodoc
mixin _$Holiday {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Holiday to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Holiday
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HolidayCopyWith<Holiday> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HolidayCopyWith<$Res> {
  factory $HolidayCopyWith(Holiday value, $Res Function(Holiday) then) =
      _$HolidayCopyWithImpl<$Res, Holiday>;
  @useResult
  $Res call({
    String id,
    String salonId,
    DateTime date,
    String name,
    String? description,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$HolidayCopyWithImpl<$Res, $Val extends Holiday>
    implements $HolidayCopyWith<$Res> {
  _$HolidayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Holiday
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? date = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdAt = freezed,
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
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HolidayImplCopyWith<$Res> implements $HolidayCopyWith<$Res> {
  factory _$$HolidayImplCopyWith(
    _$HolidayImpl value,
    $Res Function(_$HolidayImpl) then,
  ) = __$$HolidayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    DateTime date,
    String name,
    String? description,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$HolidayImplCopyWithImpl<$Res>
    extends _$HolidayCopyWithImpl<$Res, _$HolidayImpl>
    implements _$$HolidayImplCopyWith<$Res> {
  __$$HolidayImplCopyWithImpl(
    _$HolidayImpl _value,
    $Res Function(_$HolidayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Holiday
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? date = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$HolidayImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HolidayImpl implements _Holiday {
  const _$HolidayImpl({
    required this.id,
    required this.salonId,
    required this.date,
    required this.name,
    this.description,
    this.createdAt,
  });

  factory _$HolidayImpl.fromJson(Map<String, dynamic> json) =>
      _$$HolidayImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final DateTime date;
  @override
  final String name;
  @override
  final String? description;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Holiday(id: $id, salonId: $salonId, date: $date, name: $name, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HolidayImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, salonId, date, name, description, createdAt);

  /// Create a copy of Holiday
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HolidayImplCopyWith<_$HolidayImpl> get copyWith =>
      __$$HolidayImplCopyWithImpl<_$HolidayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HolidayImplToJson(this);
  }
}

abstract class _Holiday implements Holiday {
  const factory _Holiday({
    required final String id,
    required final String salonId,
    required final DateTime date,
    required final String name,
    final String? description,
    final DateTime? createdAt,
  }) = _$HolidayImpl;

  factory _Holiday.fromJson(Map<String, dynamic> json) = _$HolidayImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  DateTime get date;
  @override
  String get name;
  @override
  String? get description;
  @override
  DateTime? get createdAt;

  /// Create a copy of Holiday
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HolidayImplCopyWith<_$HolidayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) {
  return _PaymentMethod.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethod {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  Map<String, dynamic>? get configuration => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PaymentMethod to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodCopyWith<PaymentMethod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodCopyWith<$Res> {
  factory $PaymentMethodCopyWith(
    PaymentMethod value,
    $Res Function(PaymentMethod) then,
  ) = _$PaymentMethodCopyWithImpl<$Res, PaymentMethod>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String name,
    String type,
    bool isActive,
    Map<String, dynamic>? configuration,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$PaymentMethodCopyWithImpl<$Res, $Val extends PaymentMethod>
    implements $PaymentMethodCopyWith<$Res> {
  _$PaymentMethodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? name = null,
    Object? type = null,
    Object? isActive = null,
    Object? configuration = freezed,
    Object? createdAt = freezed,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            configuration: freezed == configuration
                ? _value.configuration
                : configuration // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentMethodImplCopyWith<$Res>
    implements $PaymentMethodCopyWith<$Res> {
  factory _$$PaymentMethodImplCopyWith(
    _$PaymentMethodImpl value,
    $Res Function(_$PaymentMethodImpl) then,
  ) = __$$PaymentMethodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String name,
    String type,
    bool isActive,
    Map<String, dynamic>? configuration,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$PaymentMethodImplCopyWithImpl<$Res>
    extends _$PaymentMethodCopyWithImpl<$Res, _$PaymentMethodImpl>
    implements _$$PaymentMethodImplCopyWith<$Res> {
  __$$PaymentMethodImplCopyWithImpl(
    _$PaymentMethodImpl _value,
    $Res Function(_$PaymentMethodImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? name = null,
    Object? type = null,
    Object? isActive = null,
    Object? configuration = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$PaymentMethodImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        configuration: freezed == configuration
            ? _value._configuration
            : configuration // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentMethodImpl implements _PaymentMethod {
  const _$PaymentMethodImpl({
    required this.id,
    required this.salonId,
    required this.name,
    required this.type,
    required this.isActive,
    final Map<String, dynamic>? configuration,
    this.createdAt,
  }) : _configuration = configuration;

  factory _$PaymentMethodImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String name;
  @override
  final String type;
  @override
  final bool isActive;
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
  final DateTime? createdAt;

  @override
  String toString() {
    return 'PaymentMethod(id: $id, salonId: $salonId, name: $name, type: $type, isActive: $isActive, configuration: $configuration, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(
              other._configuration,
              _configuration,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    name,
    type,
    isActive,
    const DeepCollectionEquality().hash(_configuration),
    createdAt,
  );

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodImplCopyWith<_$PaymentMethodImpl> get copyWith =>
      __$$PaymentMethodImplCopyWithImpl<_$PaymentMethodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodImplToJson(this);
  }
}

abstract class _PaymentMethod implements PaymentMethod {
  const factory _PaymentMethod({
    required final String id,
    required final String salonId,
    required final String name,
    required final String type,
    required final bool isActive,
    final Map<String, dynamic>? configuration,
    final DateTime? createdAt,
  }) = _$PaymentMethodImpl;

  factory _PaymentMethod.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get name;
  @override
  String get type;
  @override
  bool get isActive;
  @override
  Map<String, dynamic>? get configuration;
  @override
  DateTime? get createdAt;

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodImplCopyWith<_$PaymentMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
