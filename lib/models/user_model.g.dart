// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  phone: json['phone'] as String?,
  avatar: json['avatar'] as String?,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  emailVerified: json['emailVerified'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  lastLogin: json['lastLogin'] == null
      ? null
      : DateTime.parse(json['lastLogin'] as String),
  twoFactorEnabled: json['twoFactorEnabled'] as bool,
  salonId: json['salonId'] as String?,
  currentSalonId: json['currentSalonId'] as String?,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'role': _$UserRoleEnumMap[instance.role]!,
      'emailVerified': instance.emailVerified,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'lastLogin': instance.lastLogin?.toIso8601String(),
      'twoFactorEnabled': instance.twoFactorEnabled,
      'salonId': instance.salonId,
      'currentSalonId': instance.currentSalonId,
    };

const _$UserRoleEnumMap = {
  UserRole.customer: 'customer',
  UserRole.employee: 'employee',
  UserRole.stylist: 'stylist',
  UserRole.manager: 'manager',
  UserRole.admin: 'admin',
  UserRole.owner: 'owner',
};

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      userId: json['userId'] as String,
      bio: json['bio'] as String?,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      notificationPreferences: json['notificationPreferences'] as String?,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'bio': instance.bio,
      'avatar': instance.avatar,
      'phone': instance.phone,
      'address': instance.address,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'notificationPreferences': instance.notificationPreferences,
    };
