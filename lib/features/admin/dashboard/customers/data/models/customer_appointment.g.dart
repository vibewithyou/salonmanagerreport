// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerAppointmentImpl _$$CustomerAppointmentImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerAppointmentImpl(
  id: json['id'] as String,
  startTime: DateTime.parse(json['start_time'] as String),
  endTime: DateTime.parse(json['end_time'] as String),
  status: json['status'] as String,
  notes: json['notes'] as String?,
  guestName: json['guest_name'] as String?,
  guestEmail: json['guest_email'] as String?,
  guestPhone: json['guest_phone'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  bufferBefore: (json['buffer_before'] as num?)?.toInt(),
  bufferAfter: (json['buffer_after'] as num?)?.toInt(),
  imageUrl: json['image_url'] as String?,
  customerProfileId: json['customer_profile_id'] as String?,
  appointmentNumber: json['appointment_number'] as String?,
  service: json['service'] == null
      ? null
      : ServiceInfo.fromJson(json['service'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$CustomerAppointmentImplToJson(
  _$CustomerAppointmentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'start_time': instance.startTime.toIso8601String(),
  'end_time': instance.endTime.toIso8601String(),
  'status': instance.status,
  'notes': instance.notes,
  'guest_name': instance.guestName,
  'guest_email': instance.guestEmail,
  'guest_phone': instance.guestPhone,
  'price': instance.price,
  'buffer_before': instance.bufferBefore,
  'buffer_after': instance.bufferAfter,
  'image_url': instance.imageUrl,
  'customer_profile_id': instance.customerProfileId,
  'appointment_number': instance.appointmentNumber,
  'service': instance.service,
};

_$ServiceInfoImpl _$$ServiceInfoImplFromJson(Map<String, dynamic> json) =>
    _$ServiceInfoImpl(
      name: json['name'] as String,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ServiceInfoImplToJson(_$ServiceInfoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'duration_minutes': instance.durationMinutes,
      'price': instance.price,
    };
