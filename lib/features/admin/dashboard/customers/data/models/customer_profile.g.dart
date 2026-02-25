// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerProfileImpl _$$CustomerProfileImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerProfileImpl(
  id: json['id'] as String,
  salonId: json['salon_id'] as String,
  userId: json['user_id'] as String?,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  birthdate: json['birthdate'] == null
      ? null
      : DateTime.parse(json['birthdate'] as String),
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  street: json['street'] as String?,
  houseNumber: json['house_number'] as String?,
  postalCode: json['postal_code'] as String?,
  city: json['city'] as String?,
  address: json['address'] as String?,
  imageUrls: (json['image_urls'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  notes: json['notes'] as String?,
  customerNumber: json['customer_number'] as String?,
  preferences: json['preferences'] as String?,
  allergies: json['allergies'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  beforeAfterImages: (json['before_after_images'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$$CustomerProfileImplToJson(
  _$CustomerProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'salon_id': instance.salonId,
  'user_id': instance.userId,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'birthdate': instance.birthdate?.toIso8601String(),
  'phone': instance.phone,
  'email': instance.email,
  'street': instance.street,
  'house_number': instance.houseNumber,
  'postal_code': instance.postalCode,
  'city': instance.city,
  'address': instance.address,
  'image_urls': instance.imageUrls,
  'notes': instance.notes,
  'customer_number': instance.customerNumber,
  'preferences': instance.preferences,
  'allergies': instance.allergies,
  'tags': instance.tags,
  'before_after_images': instance.beforeAfterImages,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'deleted_at': instance.deletedAt?.toIso8601String(),
};
