// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalonImpl _$$SalonImplFromJson(Map<String, dynamic> json) => _$SalonImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
  postalCode: json['postalCode'] as String?,
  country: json['country'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  website: json['website'] as String?,
  logo: json['logo'] as String?,
  banner: json['banner'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  isActive: json['isActive'] as bool,
  operatingHours: json['operatingHours'] as String?,
  openingDays: json['openingDays'] as String?,
  closureDates: json['closureDates'] as String?,
  ownerId: json['ownerId'] as String?,
);

Map<String, dynamic> _$$SalonImplToJson(_$SalonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
      'logo': instance.logo,
      'banner': instance.banner,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isActive': instance.isActive,
      'operatingHours': instance.operatingHours,
      'openingDays': instance.openingDays,
      'closureDates': instance.closureDates,
      'ownerId': instance.ownerId,
    };

_$SalonServiceImpl _$$SalonServiceImplFromJson(Map<String, dynamic> json) =>
    _$SalonServiceImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      category: json['category'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SalonServiceImplToJson(_$SalonServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'durationMinutes': instance.durationMinutes,
      'category': instance.category,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$StylistImpl _$$StylistImplFromJson(Map<String, dynamic> json) =>
    _$StylistImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      specializations: (json['specializations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$StylistImplToJson(_$StylistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'email': instance.email,
      'avatar': instance.avatar,
      'specializations': instance.specializations,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };
