// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_salon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PublicSalonDataImpl _$$PublicSalonDataImplFromJson(
  Map<String, dynamic> json,
) => _$PublicSalonDataImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  website: json['website'] as String?,
  logoUrl: json['logoUrl'] as String?,
  gallery: (json['gallery'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  services:
      (json['services'] as List<dynamic>?)
          ?.map((e) => PublicService.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  openingHours:
      (json['openingHours'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PublicSalonDataImplToJson(
  _$PublicSalonDataImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'address': instance.address,
  'phone': instance.phone,
  'email': instance.email,
  'website': instance.website,
  'logoUrl': instance.logoUrl,
  'gallery': instance.gallery,
  'services': instance.services,
  'openingHours': instance.openingHours,
};

_$PublicServiceImpl _$$PublicServiceImplFromJson(Map<String, dynamic> json) =>
    _$PublicServiceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      duration: (json['duration'] as num).toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$PublicServiceImplToJson(_$PublicServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'duration': instance.duration,
      'description': instance.description,
    };
