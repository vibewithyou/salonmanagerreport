// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model_simple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentSimpleImpl _$$AppointmentSimpleImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentSimpleImpl(
  id: json['id'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: DateTime.parse(json['endTime'] as String),
  customerName: json['customerName'] as String,
  customerPhone: json['customerPhone'] as String?,
  serviceName: json['serviceName'] as String,
  price: (json['price'] as num).toDouble(),
  status: $enumDecode(_$AppointmentStatusEnumMap, json['status']),
  stylistName: json['stylistName'] as String?,
  stylistId: json['stylistId'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$AppointmentSimpleImplToJson(
  _$AppointmentSimpleImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime.toIso8601String(),
  'customerName': instance.customerName,
  'customerPhone': instance.customerPhone,
  'serviceName': instance.serviceName,
  'price': instance.price,
  'status': _$AppointmentStatusEnumMap[instance.status]!,
  'stylistName': instance.stylistName,
  'stylistId': instance.stylistId,
  'notes': instance.notes,
};

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.pending: 'pending',
  AppointmentStatus.confirmed: 'confirmed',
  AppointmentStatus.completed: 'completed',
  AppointmentStatus.cancelled: 'cancelled',
  AppointmentStatus.noShow: 'noShow',
};
