// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model_extended.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingDataImpl _$$BookingDataImplFromJson(Map<String, dynamic> json) =>
    _$BookingDataImpl(
      id: json['id'] as String?,
      salonId: json['salonId'] as String,
      customerId: json['customerId'] as String,
      serviceId: json['serviceId'] as String,
      stylistId: json['stylistId'] as String,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      reminderSentAt: json['reminderSentAt'] == null
          ? null
          : DateTime.parse(json['reminderSentAt'] as String),
      rating: (json['rating'] as num?)?.toDouble(),
      feedback: json['feedback'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BookingDataImplToJson(_$BookingDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'customerId': instance.customerId,
      'serviceId': instance.serviceId,
      'stylistId': instance.stylistId,
      'appointmentDate': instance.appointmentDate.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'notes': instance.notes,
      'reminderSentAt': instance.reminderSentAt?.toIso8601String(),
      'rating': instance.rating,
      'feedback': instance.feedback,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
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
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$StylistImpl _$$StylistImplFromJson(Map<String, dynamic> json) =>
    _$StylistImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      specialties:
          (json['specialties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$StylistImplToJson(_$StylistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'specialties': instance.specialties,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$CustomerImpl _$$CustomerImplFromJson(Map<String, dynamic> json) =>
    _$CustomerImpl(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CustomerImplToJson(_$CustomerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
