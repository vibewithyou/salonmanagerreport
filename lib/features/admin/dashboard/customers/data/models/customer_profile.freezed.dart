// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerProfile _$CustomerProfileFromJson(Map<String, dynamic> json) {
  return _CustomerProfile.fromJson(json);
}

/// @nodoc
mixin _$CustomerProfile {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'salon_id')
  String get salonId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  DateTime? get birthdate => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get street => throw _privateConstructorUsedError;
  @JsonKey(name: 'house_number')
  String? get houseNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'postal_code')
  String? get postalCode => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  @Deprecated('Use structured address fields')
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_urls')
  List<String>? get imageUrls => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_number')
  String? get customerNumber => throw _privateConstructorUsedError;
  String? get preferences => throw _privateConstructorUsedError;
  String? get allergies => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'before_after_images')
  List<String>? get beforeAfterImages => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this CustomerProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerProfileCopyWith<CustomerProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerProfileCopyWith<$Res> {
  factory $CustomerProfileCopyWith(
    CustomerProfile value,
    $Res Function(CustomerProfile) then,
  ) = _$CustomerProfileCopyWithImpl<$Res, CustomerProfile>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'salon_id') String salonId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'first_name') String firstName,
    @JsonKey(name: 'last_name') String lastName,
    DateTime? birthdate,
    String? phone,
    String? email,
    String? street,
    @JsonKey(name: 'house_number') String? houseNumber,
    @JsonKey(name: 'postal_code') String? postalCode,
    String? city,
    @Deprecated('Use structured address fields') String? address,
    @JsonKey(name: 'image_urls') List<String>? imageUrls,
    String? notes,
    @JsonKey(name: 'customer_number') String? customerNumber,
    String? preferences,
    String? allergies,
    List<String>? tags,
    @JsonKey(name: 'before_after_images') List<String>? beforeAfterImages,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  });
}

/// @nodoc
class _$CustomerProfileCopyWithImpl<$Res, $Val extends CustomerProfile>
    implements $CustomerProfileCopyWith<$Res> {
  _$CustomerProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? userId = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? birthdate = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? street = freezed,
    Object? houseNumber = freezed,
    Object? postalCode = freezed,
    Object? city = freezed,
    Object? address = freezed,
    Object? imageUrls = freezed,
    Object? notes = freezed,
    Object? customerNumber = freezed,
    Object? preferences = freezed,
    Object? allergies = freezed,
    Object? tags = freezed,
    Object? beforeAfterImages = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
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
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            birthdate: freezed == birthdate
                ? _value.birthdate
                : birthdate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            street: freezed == street
                ? _value.street
                : street // ignore: cast_nullable_to_non_nullable
                      as String?,
            houseNumber: freezed == houseNumber
                ? _value.houseNumber
                : houseNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            postalCode: freezed == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrls: freezed == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerNumber: freezed == customerNumber
                ? _value.customerNumber
                : customerNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            preferences: freezed == preferences
                ? _value.preferences
                : preferences // ignore: cast_nullable_to_non_nullable
                      as String?,
            allergies: freezed == allergies
                ? _value.allergies
                : allergies // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            beforeAfterImages: freezed == beforeAfterImages
                ? _value.beforeAfterImages
                : beforeAfterImages // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerProfileImplCopyWith<$Res>
    implements $CustomerProfileCopyWith<$Res> {
  factory _$$CustomerProfileImplCopyWith(
    _$CustomerProfileImpl value,
    $Res Function(_$CustomerProfileImpl) then,
  ) = __$$CustomerProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'salon_id') String salonId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'first_name') String firstName,
    @JsonKey(name: 'last_name') String lastName,
    DateTime? birthdate,
    String? phone,
    String? email,
    String? street,
    @JsonKey(name: 'house_number') String? houseNumber,
    @JsonKey(name: 'postal_code') String? postalCode,
    String? city,
    @Deprecated('Use structured address fields') String? address,
    @JsonKey(name: 'image_urls') List<String>? imageUrls,
    String? notes,
    @JsonKey(name: 'customer_number') String? customerNumber,
    String? preferences,
    String? allergies,
    List<String>? tags,
    @JsonKey(name: 'before_after_images') List<String>? beforeAfterImages,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  });
}

/// @nodoc
class __$$CustomerProfileImplCopyWithImpl<$Res>
    extends _$CustomerProfileCopyWithImpl<$Res, _$CustomerProfileImpl>
    implements _$$CustomerProfileImplCopyWith<$Res> {
  __$$CustomerProfileImplCopyWithImpl(
    _$CustomerProfileImpl _value,
    $Res Function(_$CustomerProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? userId = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? birthdate = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? street = freezed,
    Object? houseNumber = freezed,
    Object? postalCode = freezed,
    Object? city = freezed,
    Object? address = freezed,
    Object? imageUrls = freezed,
    Object? notes = freezed,
    Object? customerNumber = freezed,
    Object? preferences = freezed,
    Object? allergies = freezed,
    Object? tags = freezed,
    Object? beforeAfterImages = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$CustomerProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        birthdate: freezed == birthdate
            ? _value.birthdate
            : birthdate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        street: freezed == street
            ? _value.street
            : street // ignore: cast_nullable_to_non_nullable
                  as String?,
        houseNumber: freezed == houseNumber
            ? _value.houseNumber
            : houseNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        postalCode: freezed == postalCode
            ? _value.postalCode
            : postalCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrls: freezed == imageUrls
            ? _value._imageUrls
            : imageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerNumber: freezed == customerNumber
            ? _value.customerNumber
            : customerNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        preferences: freezed == preferences
            ? _value.preferences
            : preferences // ignore: cast_nullable_to_non_nullable
                  as String?,
        allergies: freezed == allergies
            ? _value.allergies
            : allergies // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: freezed == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        beforeAfterImages: freezed == beforeAfterImages
            ? _value._beforeAfterImages
            : beforeAfterImages // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerProfileImpl implements _CustomerProfile {
  const _$CustomerProfileImpl({
    required this.id,
    @JsonKey(name: 'salon_id') required this.salonId,
    @JsonKey(name: 'user_id') this.userId,
    @JsonKey(name: 'first_name') required this.firstName,
    @JsonKey(name: 'last_name') required this.lastName,
    this.birthdate,
    this.phone,
    this.email,
    this.street,
    @JsonKey(name: 'house_number') this.houseNumber,
    @JsonKey(name: 'postal_code') this.postalCode,
    this.city,
    @Deprecated('Use structured address fields') this.address,
    @JsonKey(name: 'image_urls') final List<String>? imageUrls,
    this.notes,
    @JsonKey(name: 'customer_number') this.customerNumber,
    this.preferences,
    this.allergies,
    final List<String>? tags,
    @JsonKey(name: 'before_after_images') final List<String>? beforeAfterImages,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'deleted_at') this.deletedAt,
  }) : _imageUrls = imageUrls,
       _tags = tags,
       _beforeAfterImages = beforeAfterImages;

  factory _$CustomerProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerProfileImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'salon_id')
  final String salonId;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  final DateTime? birthdate;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? street;
  @override
  @JsonKey(name: 'house_number')
  final String? houseNumber;
  @override
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  @override
  final String? city;
  @override
  @Deprecated('Use structured address fields')
  final String? address;
  final List<String>? _imageUrls;
  @override
  @JsonKey(name: 'image_urls')
  List<String>? get imageUrls {
    final value = _imageUrls;
    if (value == null) return null;
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? notes;
  @override
  @JsonKey(name: 'customer_number')
  final String? customerNumber;
  @override
  final String? preferences;
  @override
  final String? allergies;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _beforeAfterImages;
  @override
  @JsonKey(name: 'before_after_images')
  List<String>? get beforeAfterImages {
    final value = _beforeAfterImages;
    if (value == null) return null;
    if (_beforeAfterImages is EqualUnmodifiableListView)
      return _beforeAfterImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'CustomerProfile(id: $id, salonId: $salonId, userId: $userId, firstName: $firstName, lastName: $lastName, birthdate: $birthdate, phone: $phone, email: $email, street: $street, houseNumber: $houseNumber, postalCode: $postalCode, city: $city, address: $address, imageUrls: $imageUrls, notes: $notes, customerNumber: $customerNumber, preferences: $preferences, allergies: $allergies, tags: $tags, beforeAfterImages: $beforeAfterImages, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.birthdate, birthdate) ||
                other.birthdate == birthdate) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.houseNumber, houseNumber) ||
                other.houseNumber == houseNumber) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.customerNumber, customerNumber) ||
                other.customerNumber == customerNumber) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences) &&
            (identical(other.allergies, allergies) ||
                other.allergies == allergies) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(
              other._beforeAfterImages,
              _beforeAfterImages,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    salonId,
    userId,
    firstName,
    lastName,
    birthdate,
    phone,
    email,
    street,
    houseNumber,
    postalCode,
    city,
    address,
    const DeepCollectionEquality().hash(_imageUrls),
    notes,
    customerNumber,
    preferences,
    allergies,
    const DeepCollectionEquality().hash(_tags),
    const DeepCollectionEquality().hash(_beforeAfterImages),
    createdAt,
    updatedAt,
    deletedAt,
  ]);

  /// Create a copy of CustomerProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerProfileImplCopyWith<_$CustomerProfileImpl> get copyWith =>
      __$$CustomerProfileImplCopyWithImpl<_$CustomerProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerProfileImplToJson(this);
  }
}

abstract class _CustomerProfile implements CustomerProfile {
  const factory _CustomerProfile({
    required final String id,
    @JsonKey(name: 'salon_id') required final String salonId,
    @JsonKey(name: 'user_id') final String? userId,
    @JsonKey(name: 'first_name') required final String firstName,
    @JsonKey(name: 'last_name') required final String lastName,
    final DateTime? birthdate,
    final String? phone,
    final String? email,
    final String? street,
    @JsonKey(name: 'house_number') final String? houseNumber,
    @JsonKey(name: 'postal_code') final String? postalCode,
    final String? city,
    @Deprecated('Use structured address fields') final String? address,
    @JsonKey(name: 'image_urls') final List<String>? imageUrls,
    final String? notes,
    @JsonKey(name: 'customer_number') final String? customerNumber,
    final String? preferences,
    final String? allergies,
    final List<String>? tags,
    @JsonKey(name: 'before_after_images') final List<String>? beforeAfterImages,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
    @JsonKey(name: 'deleted_at') final DateTime? deletedAt,
  }) = _$CustomerProfileImpl;

  factory _CustomerProfile.fromJson(Map<String, dynamic> json) =
      _$CustomerProfileImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'salon_id')
  String get salonId;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  DateTime? get birthdate;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get street;
  @override
  @JsonKey(name: 'house_number')
  String? get houseNumber;
  @override
  @JsonKey(name: 'postal_code')
  String? get postalCode;
  @override
  String? get city;
  @override
  @Deprecated('Use structured address fields')
  String? get address;
  @override
  @JsonKey(name: 'image_urls')
  List<String>? get imageUrls;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'customer_number')
  String? get customerNumber;
  @override
  String? get preferences;
  @override
  String? get allergies;
  @override
  List<String>? get tags;
  @override
  @JsonKey(name: 'before_after_images')
  List<String>? get beforeAfterImages;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt;

  /// Create a copy of CustomerProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerProfileImplCopyWith<_$CustomerProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
