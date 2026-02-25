// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Salon _$SalonFromJson(Map<String, dynamic> json) {
  return _Salon.fromJson(json);
}

/// @nodoc
mixin _$Salon {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get postalCode => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get logo => throw _privateConstructorUsedError;
  String? get banner => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get operatingHours => throw _privateConstructorUsedError;
  String? get openingDays => throw _privateConstructorUsedError;
  String? get closureDates => throw _privateConstructorUsedError;
  String? get ownerId => throw _privateConstructorUsedError;

  /// Serializes this Salon to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Salon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalonCopyWith<Salon> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalonCopyWith<$Res> {
  factory $SalonCopyWith(Salon value, $Res Function(Salon) then) =
      _$SalonCopyWithImpl<$Res, Salon>;
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    String? phone,
    String? email,
    String? website,
    String? logo,
    String? banner,
    double? latitude,
    double? longitude,
    DateTime createdAt,
    DateTime? updatedAt,
    bool isActive,
    String? operatingHours,
    String? openingDays,
    String? closureDates,
    String? ownerId,
  });
}

/// @nodoc
class _$SalonCopyWithImpl<$Res, $Val extends Salon>
    implements $SalonCopyWith<$Res> {
  _$SalonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Salon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? logo = freezed,
    Object? banner = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isActive = null,
    Object? operatingHours = freezed,
    Object? openingDays = freezed,
    Object? closureDates = freezed,
    Object? ownerId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
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
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
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
            logo: freezed == logo
                ? _value.logo
                : logo // ignore: cast_nullable_to_non_nullable
                      as String?,
            banner: freezed == banner
                ? _value.banner
                : banner // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            operatingHours: freezed == operatingHours
                ? _value.operatingHours
                : operatingHours // ignore: cast_nullable_to_non_nullable
                      as String?,
            openingDays: freezed == openingDays
                ? _value.openingDays
                : openingDays // ignore: cast_nullable_to_non_nullable
                      as String?,
            closureDates: freezed == closureDates
                ? _value.closureDates
                : closureDates // ignore: cast_nullable_to_non_nullable
                      as String?,
            ownerId: freezed == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalonImplCopyWith<$Res> implements $SalonCopyWith<$Res> {
  factory _$$SalonImplCopyWith(
    _$SalonImpl value,
    $Res Function(_$SalonImpl) then,
  ) = __$$SalonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    String? phone,
    String? email,
    String? website,
    String? logo,
    String? banner,
    double? latitude,
    double? longitude,
    DateTime createdAt,
    DateTime? updatedAt,
    bool isActive,
    String? operatingHours,
    String? openingDays,
    String? closureDates,
    String? ownerId,
  });
}

/// @nodoc
class __$$SalonImplCopyWithImpl<$Res>
    extends _$SalonCopyWithImpl<$Res, _$SalonImpl>
    implements _$$SalonImplCopyWith<$Res> {
  __$$SalonImplCopyWithImpl(
    _$SalonImpl _value,
    $Res Function(_$SalonImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Salon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? logo = freezed,
    Object? banner = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isActive = null,
    Object? operatingHours = freezed,
    Object? openingDays = freezed,
    Object? closureDates = freezed,
    Object? ownerId = freezed,
  }) {
    return _then(
      _$SalonImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
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
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
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
        logo: freezed == logo
            ? _value.logo
            : logo // ignore: cast_nullable_to_non_nullable
                  as String?,
        banner: freezed == banner
            ? _value.banner
            : banner // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        operatingHours: freezed == operatingHours
            ? _value.operatingHours
            : operatingHours // ignore: cast_nullable_to_non_nullable
                  as String?,
        openingDays: freezed == openingDays
            ? _value.openingDays
            : openingDays // ignore: cast_nullable_to_non_nullable
                  as String?,
        closureDates: freezed == closureDates
            ? _value.closureDates
            : closureDates // ignore: cast_nullable_to_non_nullable
                  as String?,
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalonImpl implements _Salon {
  const _$SalonImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.phone,
    required this.email,
    required this.website,
    required this.logo,
    required this.banner,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.operatingHours,
    required this.openingDays,
    required this.closureDates,
    required this.ownerId,
  });

  factory _$SalonImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalonImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? postalCode;
  @override
  final String? country;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? website;
  @override
  final String? logo;
  @override
  final String? banner;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final bool isActive;
  @override
  final String? operatingHours;
  @override
  final String? openingDays;
  @override
  final String? closureDates;
  @override
  final String? ownerId;

  @override
  String toString() {
    return 'Salon(id: $id, name: $name, description: $description, address: $address, city: $city, postalCode: $postalCode, country: $country, phone: $phone, email: $email, website: $website, logo: $logo, banner: $banner, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, operatingHours: $operatingHours, openingDays: $openingDays, closureDates: $closureDates, ownerId: $ownerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.banner, banner) || other.banner == banner) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.operatingHours, operatingHours) ||
                other.operatingHours == operatingHours) &&
            (identical(other.openingDays, openingDays) ||
                other.openingDays == openingDays) &&
            (identical(other.closureDates, closureDates) ||
                other.closureDates == closureDates) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    description,
    address,
    city,
    postalCode,
    country,
    phone,
    email,
    website,
    logo,
    banner,
    latitude,
    longitude,
    createdAt,
    updatedAt,
    isActive,
    operatingHours,
    openingDays,
    closureDates,
    ownerId,
  ]);

  /// Create a copy of Salon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalonImplCopyWith<_$SalonImpl> get copyWith =>
      __$$SalonImplCopyWithImpl<_$SalonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalonImplToJson(this);
  }
}

abstract class _Salon implements Salon {
  const factory _Salon({
    required final String id,
    required final String name,
    required final String? description,
    required final String? address,
    required final String? city,
    required final String? postalCode,
    required final String? country,
    required final String? phone,
    required final String? email,
    required final String? website,
    required final String? logo,
    required final String? banner,
    required final double? latitude,
    required final double? longitude,
    required final DateTime createdAt,
    required final DateTime? updatedAt,
    required final bool isActive,
    required final String? operatingHours,
    required final String? openingDays,
    required final String? closureDates,
    required final String? ownerId,
  }) = _$SalonImpl;

  factory _Salon.fromJson(Map<String, dynamic> json) = _$SalonImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get address;
  @override
  String? get city;
  @override
  String? get postalCode;
  @override
  String? get country;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get website;
  @override
  String? get logo;
  @override
  String? get banner;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  bool get isActive;
  @override
  String? get operatingHours;
  @override
  String? get openingDays;
  @override
  String? get closureDates;
  @override
  String? get ownerId;

  /// Create a copy of Salon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalonImplCopyWith<_$SalonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalonService _$SalonServiceFromJson(Map<String, dynamic> json) {
  return _SalonService.fromJson(json);
}

/// @nodoc
mixin _$SalonService {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SalonService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalonService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalonServiceCopyWith<SalonService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalonServiceCopyWith<$Res> {
  factory $SalonServiceCopyWith(
    SalonService value,
    $Res Function(SalonService) then,
  ) = _$SalonServiceCopyWithImpl<$Res, SalonService>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String name,
    String? description,
    double price,
    int durationMinutes,
    String? category,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class _$SalonServiceCopyWithImpl<$Res, $Val extends SalonService>
    implements $SalonServiceCopyWith<$Res> {
  _$SalonServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalonService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? durationMinutes = null,
    Object? category = freezed,
    Object? isActive = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$SalonServiceImplCopyWith<$Res>
    implements $SalonServiceCopyWith<$Res> {
  factory _$$SalonServiceImplCopyWith(
    _$SalonServiceImpl value,
    $Res Function(_$SalonServiceImpl) then,
  ) = __$$SalonServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String name,
    String? description,
    double price,
    int durationMinutes,
    String? category,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$SalonServiceImplCopyWithImpl<$Res>
    extends _$SalonServiceCopyWithImpl<$Res, _$SalonServiceImpl>
    implements _$$SalonServiceImplCopyWith<$Res> {
  __$$SalonServiceImplCopyWithImpl(
    _$SalonServiceImpl _value,
    $Res Function(_$SalonServiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalonService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? durationMinutes = null,
    Object? category = freezed,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$SalonServiceImpl(
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
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$SalonServiceImpl implements _SalonService {
  const _$SalonServiceImpl({
    required this.id,
    required this.salonId,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.category,
    required this.isActive,
    required this.createdAt,
  });

  factory _$SalonServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalonServiceImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double price;
  @override
  final int durationMinutes;
  @override
  final String? category;
  @override
  final bool isActive;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SalonService(id: $id, salonId: $salonId, name: $name, description: $description, price: $price, durationMinutes: $durationMinutes, category: $category, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalonServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
    description,
    price,
    durationMinutes,
    category,
    isActive,
    createdAt,
  );

  /// Create a copy of SalonService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalonServiceImplCopyWith<_$SalonServiceImpl> get copyWith =>
      __$$SalonServiceImplCopyWithImpl<_$SalonServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalonServiceImplToJson(this);
  }
}

abstract class _SalonService implements SalonService {
  const factory _SalonService({
    required final String id,
    required final String salonId,
    required final String name,
    required final String? description,
    required final double price,
    required final int durationMinutes,
    required final String? category,
    required final bool isActive,
    required final DateTime createdAt,
  }) = _$SalonServiceImpl;

  factory _SalonService.fromJson(Map<String, dynamic> json) =
      _$SalonServiceImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get name;
  @override
  String? get description;
  @override
  double get price;
  @override
  int get durationMinutes;
  @override
  String? get category;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;

  /// Create a copy of SalonService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalonServiceImplCopyWith<_$SalonServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Stylist _$StylistFromJson(Map<String, dynamic> json) {
  return _Stylist.fromJson(json);
}

/// @nodoc
mixin _$Stylist {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  List<String> get specializations => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Stylist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Stylist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StylistCopyWith<Stylist> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StylistCopyWith<$Res> {
  factory $StylistCopyWith(Stylist value, $Res Function(Stylist) then) =
      _$StylistCopyWithImpl<$Res, Stylist>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String firstName,
    String lastName,
    String? phone,
    String? email,
    String? avatar,
    List<String> specializations,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class _$StylistCopyWithImpl<$Res, $Val extends Stylist>
    implements $StylistCopyWith<$Res> {
  _$StylistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Stylist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? avatar = freezed,
    Object? specializations = null,
    Object? isActive = null,
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
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            specializations: null == specializations
                ? _value.specializations
                : specializations // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$StylistImplCopyWith<$Res> implements $StylistCopyWith<$Res> {
  factory _$$StylistImplCopyWith(
    _$StylistImpl value,
    $Res Function(_$StylistImpl) then,
  ) = __$$StylistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String firstName,
    String lastName,
    String? phone,
    String? email,
    String? avatar,
    List<String> specializations,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$StylistImplCopyWithImpl<$Res>
    extends _$StylistCopyWithImpl<$Res, _$StylistImpl>
    implements _$$StylistImplCopyWith<$Res> {
  __$$StylistImplCopyWithImpl(
    _$StylistImpl _value,
    $Res Function(_$StylistImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Stylist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? avatar = freezed,
    Object? specializations = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$StylistImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        specializations: null == specializations
            ? _value._specializations
            : specializations // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$StylistImpl implements _Stylist {
  const _$StylistImpl({
    required this.id,
    required this.salonId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.avatar,
    required final List<String> specializations,
    required this.isActive,
    required this.createdAt,
  }) : _specializations = specializations;

  factory _$StylistImpl.fromJson(Map<String, dynamic> json) =>
      _$$StylistImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? avatar;
  final List<String> _specializations;
  @override
  List<String> get specializations {
    if (_specializations is EqualUnmodifiableListView) return _specializations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specializations);
  }

  @override
  final bool isActive;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Stylist(id: $id, salonId: $salonId, firstName: $firstName, lastName: $lastName, phone: $phone, email: $email, avatar: $avatar, specializations: $specializations, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StylistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            const DeepCollectionEquality().equals(
              other._specializations,
              _specializations,
            ) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    salonId,
    firstName,
    lastName,
    phone,
    email,
    avatar,
    const DeepCollectionEquality().hash(_specializations),
    isActive,
    createdAt,
  );

  /// Create a copy of Stylist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StylistImplCopyWith<_$StylistImpl> get copyWith =>
      __$$StylistImplCopyWithImpl<_$StylistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StylistImplToJson(this);
  }
}

abstract class _Stylist implements Stylist {
  const factory _Stylist({
    required final String id,
    required final String salonId,
    required final String firstName,
    required final String lastName,
    required final String? phone,
    required final String? email,
    required final String? avatar,
    required final List<String> specializations,
    required final bool isActive,
    required final DateTime createdAt,
  }) = _$StylistImpl;

  factory _Stylist.fromJson(Map<String, dynamic> json) = _$StylistImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get avatar;
  @override
  List<String> get specializations;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;

  /// Create a copy of Stylist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StylistImplCopyWith<_$StylistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
