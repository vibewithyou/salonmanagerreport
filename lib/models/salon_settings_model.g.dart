// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalonSettingsImpl _$$SalonSettingsImplFromJson(Map<String, dynamic> json) =>
    _$SalonSettingsImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      salonName: json['salonName'] as String,
      salonDescription: json['salonDescription'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      postalCode: json['postalCode'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      logoUrl: json['logoUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      taxId: json['taxId'] as String?,
      bankAccount: json['bankAccount'] as String?,
      businessHours: (json['businessHours'] as List<dynamic>?)
          ?.map((e) => BusinessHours.fromJson(e as Map<String, dynamic>))
          .toList(),
      holidays: (json['holidays'] as List<dynamic>?)
          ?.map((e) => Holiday.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethods: (json['paymentMethods'] as List<dynamic>?)
          ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      globalPermissions: json['globalPermissions'] as Map<String, dynamic>?,
      globalModuleSettings:
          json['globalModuleSettings'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SalonSettingsImplToJson(_$SalonSettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'salonName': instance.salonName,
      'salonDescription': instance.salonDescription,
      'address': instance.address,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
      'logoUrl': instance.logoUrl,
      'coverImageUrl': instance.coverImageUrl,
      'taxId': instance.taxId,
      'bankAccount': instance.bankAccount,
      'businessHours': instance.businessHours,
      'holidays': instance.holidays,
      'paymentMethods': instance.paymentMethods,
      'globalPermissions': instance.globalPermissions,
      'globalModuleSettings': instance.globalModuleSettings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$BusinessHoursImpl _$$BusinessHoursImplFromJson(Map<String, dynamic> json) =>
    _$BusinessHoursImpl(
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      dayName: json['dayName'] as String,
      isOpen: json['isOpen'] as bool,
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
    );

Map<String, dynamic> _$$BusinessHoursImplToJson(_$BusinessHoursImpl instance) =>
    <String, dynamic>{
      'dayOfWeek': instance.dayOfWeek,
      'dayName': instance.dayName,
      'isOpen': instance.isOpen,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
    };

_$HolidayImpl _$$HolidayImplFromJson(Map<String, dynamic> json) =>
    _$HolidayImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      date: DateTime.parse(json['date'] as String),
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$HolidayImplToJson(_$HolidayImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'date': instance.date.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$PaymentMethodImpl _$$PaymentMethodImplFromJson(Map<String, dynamic> json) =>
    _$PaymentMethodImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      isActive: json['isActive'] as bool,
      configuration: json['configuration'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PaymentMethodImplToJson(_$PaymentMethodImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'name': instance.name,
      'type': instance.type,
      'isActive': instance.isActive,
      'configuration': instance.configuration,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
