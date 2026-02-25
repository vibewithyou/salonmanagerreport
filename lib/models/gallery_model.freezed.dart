// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gallery_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GalleryImage _$GalleryImageFromJson(Map<String, dynamic> json) {
  return _GalleryImage.fromJson(json);
}

/// @nodoc
mixin _$GalleryImage {
  String get id => throw _privateConstructorUsedError;
  String get salonId => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  int? get likes => throw _privateConstructorUsedError;
  bool? get isFeatured => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this GalleryImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GalleryImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GalleryImageCopyWith<GalleryImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GalleryImageCopyWith<$Res> {
  factory $GalleryImageCopyWith(
    GalleryImage value,
    $Res Function(GalleryImage) then,
  ) = _$GalleryImageCopyWithImpl<$Res, GalleryImage>;
  @useResult
  $Res call({
    String id,
    String salonId,
    String imageUrl,
    String title,
    String? description,
    List<String>? tags,
    int? likes,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$GalleryImageCopyWithImpl<$Res, $Val extends GalleryImage>
    implements $GalleryImageCopyWith<$Res> {
  _$GalleryImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GalleryImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? imageUrl = null,
    Object? title = null,
    Object? description = freezed,
    Object? tags = freezed,
    Object? likes = freezed,
    Object? isFeatured = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            likes: freezed == likes
                ? _value.likes
                : likes // ignore: cast_nullable_to_non_nullable
                      as int?,
            isFeatured: freezed == isFeatured
                ? _value.isFeatured
                : isFeatured // ignore: cast_nullable_to_non_nullable
                      as bool?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GalleryImageImplCopyWith<$Res>
    implements $GalleryImageCopyWith<$Res> {
  factory _$$GalleryImageImplCopyWith(
    _$GalleryImageImpl value,
    $Res Function(_$GalleryImageImpl) then,
  ) = __$$GalleryImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String salonId,
    String imageUrl,
    String title,
    String? description,
    List<String>? tags,
    int? likes,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$GalleryImageImplCopyWithImpl<$Res>
    extends _$GalleryImageCopyWithImpl<$Res, _$GalleryImageImpl>
    implements _$$GalleryImageImplCopyWith<$Res> {
  __$$GalleryImageImplCopyWithImpl(
    _$GalleryImageImpl _value,
    $Res Function(_$GalleryImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GalleryImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? salonId = null,
    Object? imageUrl = null,
    Object? title = null,
    Object? description = freezed,
    Object? tags = freezed,
    Object? likes = freezed,
    Object? isFeatured = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$GalleryImageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        salonId: null == salonId
            ? _value.salonId
            : salonId // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: freezed == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        likes: freezed == likes
            ? _value.likes
            : likes // ignore: cast_nullable_to_non_nullable
                  as int?,
        isFeatured: freezed == isFeatured
            ? _value.isFeatured
            : isFeatured // ignore: cast_nullable_to_non_nullable
                  as bool?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GalleryImageImpl implements _GalleryImage {
  const _$GalleryImageImpl({
    required this.id,
    required this.salonId,
    required this.imageUrl,
    required this.title,
    this.description,
    final List<String>? tags,
    this.likes,
    this.isFeatured,
    this.createdAt,
    this.updatedAt,
  }) : _tags = tags;

  factory _$GalleryImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$GalleryImageImplFromJson(json);

  @override
  final String id;
  @override
  final String salonId;
  @override
  final String imageUrl;
  @override
  final String title;
  @override
  final String? description;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? likes;
  @override
  final bool? isFeatured;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'GalleryImage(id: $id, salonId: $salonId, imageUrl: $imageUrl, title: $title, description: $description, tags: $tags, likes: $likes, isFeatured: $isFeatured, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GalleryImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.salonId, salonId) || other.salonId == salonId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
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
    salonId,
    imageUrl,
    title,
    description,
    const DeepCollectionEquality().hash(_tags),
    likes,
    isFeatured,
    createdAt,
    updatedAt,
  );

  /// Create a copy of GalleryImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GalleryImageImplCopyWith<_$GalleryImageImpl> get copyWith =>
      __$$GalleryImageImplCopyWithImpl<_$GalleryImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GalleryImageImplToJson(this);
  }
}

abstract class _GalleryImage implements GalleryImage {
  const factory _GalleryImage({
    required final String id,
    required final String salonId,
    required final String imageUrl,
    required final String title,
    final String? description,
    final List<String>? tags,
    final int? likes,
    final bool? isFeatured,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$GalleryImageImpl;

  factory _GalleryImage.fromJson(Map<String, dynamic> json) =
      _$GalleryImageImpl.fromJson;

  @override
  String get id;
  @override
  String get salonId;
  @override
  String get imageUrl;
  @override
  String get title;
  @override
  String? get description;
  @override
  List<String>? get tags;
  @override
  int? get likes;
  @override
  bool? get isFeatured;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of GalleryImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GalleryImageImplCopyWith<_$GalleryImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
