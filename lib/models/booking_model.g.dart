// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentImpl _$$AppointmentImplFromJson(Map<String, dynamic> json) =>
    _$AppointmentImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      serviceId: json['serviceId'] as String,
      stylistId: json['stylistId'] as String,
      customerId: json['customerId'] as String,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      notes: json['notes'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      termsAccepted: json['termsAccepted'] as bool?,
      privacyAccepted: json['privacyAccepted'] as bool?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      bookingReference: json['bookingReference'] as String?,
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'serviceId': instance.serviceId,
      'stylistId': instance.stylistId,
      'customerId': instance.customerId,
      'appointmentDate': instance.appointmentDate.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'price': instance.price,
      'notes': instance.notes,
      'images': instance.images,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'termsAccepted': instance.termsAccepted,
      'privacyAccepted': instance.privacyAccepted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'bookingReference': instance.bookingReference,
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
};
