// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CalendarEventImpl _$$CalendarEventImplFromJson(Map<String, dynamic> json) =>
    _$CalendarEventImpl(
      id: json['id'] as String?,
      salonId: json['salonId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      eventType: json['eventType'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CalendarEventImplToJson(_$CalendarEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'eventType': instance.eventType,
      'status': instance.status,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$AppointmentSummaryImpl _$$AppointmentSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentSummaryImpl(
  totalAppointments: (json['totalAppointments'] as num).toInt(),
  completedAppointments: (json['completedAppointments'] as num).toInt(),
  cancelledAppointments: (json['cancelledAppointments'] as num).toInt(),
  pendingAppointments: (json['pendingAppointments'] as num).toInt(),
);

Map<String, dynamic> _$$AppointmentSummaryImplToJson(
  _$AppointmentSummaryImpl instance,
) => <String, dynamic>{
  'totalAppointments': instance.totalAppointments,
  'completedAppointments': instance.completedAppointments,
  'cancelledAppointments': instance.cancelledAppointments,
  'pendingAppointments': instance.pendingAppointments,
};
