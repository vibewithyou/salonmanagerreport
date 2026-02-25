// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingDataImpl _$$OnboardingDataImplFromJson(Map<String, dynamic> json) =>
    _$OnboardingDataImpl(
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      street: json['street'] as String,
      houseNumber: json['houseNumber'] as String?,
      postalCode: json['postalCode'] as String,
      city: json['city'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$OnboardingDataImplToJson(
  _$OnboardingDataImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'phone': instance.phone,
  'street': instance.street,
  'houseNumber': instance.houseNumber,
  'postalCode': instance.postalCode,
  'city': instance.city,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
