// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GalleryImageImpl _$$GalleryImageImplFromJson(Map<String, dynamic> json) =>
    _$GalleryImageImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      likes: (json['likes'] as num?)?.toInt(),
      isFeatured: json['isFeatured'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$GalleryImageImplToJson(_$GalleryImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'imageUrl': instance.imageUrl,
      'title': instance.title,
      'description': instance.description,
      'tags': instance.tags,
      'likes': instance.likes,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
