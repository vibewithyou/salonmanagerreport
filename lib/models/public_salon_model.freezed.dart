// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'public_salon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PublicSalonData _$PublicSalonDataFromJson(Map<String, dynamic> json) {
  return _PublicSalonData.fromJson(json);
}

/// @nodoc
mixin _$PublicSalonData {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  List<String>? get gallery => throw _privateConstructorUsedError;
  List<PublicService> get services => throw _privateConstructorUsedError;
  List<String> get openingHours => throw _privateConstructorUsedError;

  /// Serializes this PublicSalonData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PublicSalonData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PublicSalonDataCopyWith<PublicSalonData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicSalonDataCopyWith<$Res> {
  factory $PublicSalonDataCopyWith(
    PublicSalonData value,
    $Res Function(PublicSalonData) then,
  ) = _$PublicSalonDataCopyWithImpl<$Res, PublicSalonData>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String? address,
    String? phone,
    String? email,
    String? website,
    String? logoUrl,
    List<String>? gallery,
    List<PublicService> services,
    List<String> openingHours,
  });
}

/// @nodoc
class _$PublicSalonDataCopyWithImpl<$Res, $Val extends PublicSalonData>
    implements $PublicSalonDataCopyWith<$Res> {
  _$PublicSalonDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PublicSalonData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? address = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? logoUrl = freezed,
    Object? gallery = freezed,
    Object? services = null,
    Object? openingHours = null,
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
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
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
            gallery: freezed == gallery
                ? _value.gallery
                : gallery // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            services: null == services
                ? _value.services
                : services // ignore: cast_nullable_to_non_nullable
                      as List<PublicService>,
            openingHours: null == openingHours
                ? _value.openingHours
                : openingHours // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PublicSalonDataImplCopyWith<$Res>
    implements $PublicSalonDataCopyWith<$Res> {
  factory _$$PublicSalonDataImplCopyWith(
    _$PublicSalonDataImpl value,
    $Res Function(_$PublicSalonDataImpl) then,
  ) = __$$PublicSalonDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String? address,
    String? phone,
    String? email,
    String? website,
    String? logoUrl,
    List<String>? gallery,
    List<PublicService> services,
    List<String> openingHours,
  });
}

/// @nodoc
class __$$PublicSalonDataImplCopyWithImpl<$Res>
    extends _$PublicSalonDataCopyWithImpl<$Res, _$PublicSalonDataImpl>
    implements _$$PublicSalonDataImplCopyWith<$Res> {
  __$$PublicSalonDataImplCopyWithImpl(
    _$PublicSalonDataImpl _value,
    $Res Function(_$PublicSalonDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PublicSalonData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? address = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? logoUrl = freezed,
    Object? gallery = freezed,
    Object? services = null,
    Object? openingHours = null,
  }) {
    return _then(
      _$PublicSalonDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
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
        gallery: freezed == gallery
            ? _value._gallery
            : gallery // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        services: null == services
            ? _value._services
            : services // ignore: cast_nullable_to_non_nullable
                  as List<PublicService>,
        openingHours: null == openingHours
            ? _value._openingHours
            : openingHours // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PublicSalonDataImpl implements _PublicSalonData {
  const _$PublicSalonDataImpl({
    required this.id,
    required this.name,
    required this.description,
    this.address,
    this.phone,
    this.email,
    this.website,
    this.logoUrl,
    final List<String>? gallery,
    final List<PublicService> services = const [],
    final List<String> openingHours = const [],
  }) : _gallery = gallery,
       _services = services,
       _openingHours = openingHours;

  factory _$PublicSalonDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicSalonDataImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String? address;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? website;
  @override
  final String? logoUrl;
  final List<String>? _gallery;
  @override
  List<String>? get gallery {
    final value = _gallery;
    if (value == null) return null;
    if (_gallery is EqualUnmodifiableListView) return _gallery;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PublicService> _services;
  @override
  @JsonKey()
  List<PublicService> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  final List<String> _openingHours;
  @override
  @JsonKey()
  List<String> get openingHours {
    if (_openingHours is EqualUnmodifiableListView) return _openingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_openingHours);
  }

  @override
  String toString() {
    return 'PublicSalonData(id: $id, name: $name, description: $description, address: $address, phone: $phone, email: $email, website: $website, logoUrl: $logoUrl, gallery: $gallery, services: $services, openingHours: $openingHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicSalonDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            const DeepCollectionEquality().equals(other._gallery, _gallery) &&
            const DeepCollectionEquality().equals(other._services, _services) &&
            const DeepCollectionEquality().equals(
              other._openingHours,
              _openingHours,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    address,
    phone,
    email,
    website,
    logoUrl,
    const DeepCollectionEquality().hash(_gallery),
    const DeepCollectionEquality().hash(_services),
    const DeepCollectionEquality().hash(_openingHours),
  );

  /// Create a copy of PublicSalonData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicSalonDataImplCopyWith<_$PublicSalonDataImpl> get copyWith =>
      __$$PublicSalonDataImplCopyWithImpl<_$PublicSalonDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicSalonDataImplToJson(this);
  }
}

abstract class _PublicSalonData implements PublicSalonData {
  const factory _PublicSalonData({
    required final String id,
    required final String name,
    required final String description,
    final String? address,
    final String? phone,
    final String? email,
    final String? website,
    final String? logoUrl,
    final List<String>? gallery,
    final List<PublicService> services,
    final List<String> openingHours,
  }) = _$PublicSalonDataImpl;

  factory _PublicSalonData.fromJson(Map<String, dynamic> json) =
      _$PublicSalonDataImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String? get address;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get website;
  @override
  String? get logoUrl;
  @override
  List<String>? get gallery;
  @override
  List<PublicService> get services;
  @override
  List<String> get openingHours;

  /// Create a copy of PublicSalonData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PublicSalonDataImplCopyWith<_$PublicSalonDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PublicService _$PublicServiceFromJson(Map<String, dynamic> json) {
  return _PublicService.fromJson(json);
}

/// @nodoc
mixin _$PublicService {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this PublicService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PublicService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PublicServiceCopyWith<PublicService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicServiceCopyWith<$Res> {
  factory $PublicServiceCopyWith(
    PublicService value,
    $Res Function(PublicService) then,
  ) = _$PublicServiceCopyWithImpl<$Res, PublicService>;
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    int duration,
    String? description,
  });
}

/// @nodoc
class _$PublicServiceCopyWithImpl<$Res, $Val extends PublicService>
    implements $PublicServiceCopyWith<$Res> {
  _$PublicServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PublicService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? duration = null,
    Object? description = freezed,
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
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PublicServiceImplCopyWith<$Res>
    implements $PublicServiceCopyWith<$Res> {
  factory _$$PublicServiceImplCopyWith(
    _$PublicServiceImpl value,
    $Res Function(_$PublicServiceImpl) then,
  ) = __$$PublicServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    int duration,
    String? description,
  });
}

/// @nodoc
class __$$PublicServiceImplCopyWithImpl<$Res>
    extends _$PublicServiceCopyWithImpl<$Res, _$PublicServiceImpl>
    implements _$$PublicServiceImplCopyWith<$Res> {
  __$$PublicServiceImplCopyWithImpl(
    _$PublicServiceImpl _value,
    $Res Function(_$PublicServiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PublicService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? duration = null,
    Object? description = freezed,
  }) {
    return _then(
      _$PublicServiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PublicServiceImpl implements _PublicService {
  const _$PublicServiceImpl({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    this.description,
  });

  factory _$PublicServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicServiceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double price;
  @override
  final int duration;
  @override
  final String? description;

  @override
  String toString() {
    return 'PublicService(id: $id, name: $name, price: $price, duration: $duration, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, price, duration, description);

  /// Create a copy of PublicService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicServiceImplCopyWith<_$PublicServiceImpl> get copyWith =>
      __$$PublicServiceImplCopyWithImpl<_$PublicServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicServiceImplToJson(this);
  }
}

abstract class _PublicService implements PublicService {
  const factory _PublicService({
    required final String id,
    required final String name,
    required final double price,
    required final int duration,
    final String? description,
  }) = _$PublicServiceImpl;

  factory _PublicService.fromJson(Map<String, dynamic> json) =
      _$PublicServiceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get price;
  @override
  int get duration;
  @override
  String? get description;

  /// Create a copy of PublicService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PublicServiceImplCopyWith<_$PublicServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
