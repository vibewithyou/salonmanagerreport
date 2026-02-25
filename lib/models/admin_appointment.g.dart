// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminAppointmentImpl _$$AdminAppointmentImplFromJson(
  Map<String, dynamic> json,
) => _$AdminAppointmentImpl(
  id: json['id'] as String,
  salonId: json['salonId'] as String,
  customerId: json['customerId'] as String,
  employeeId: json['employeeId'] as String,
  serviceId: json['serviceId'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: DateTime.parse(json['endTime'] as String),
  status: json['status'] as String? ?? 'pending',
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  customerName: json['customerName'] as String?,
  employeeName: json['employeeName'] as String?,
  serviceName: json['serviceName'] as String?,
);

Map<String, dynamic> _$$AdminAppointmentImplToJson(
  _$AdminAppointmentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'salonId': instance.salonId,
  'customerId': instance.customerId,
  'employeeId': instance.employeeId,
  'serviceId': instance.serviceId,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime.toIso8601String(),
  'status': instance.status,
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'customerName': instance.customerName,
  'employeeName': instance.employeeName,
  'serviceName': instance.serviceName,
};
