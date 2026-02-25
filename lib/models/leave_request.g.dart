// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaveRequestImpl _$$LeaveRequestImplFromJson(Map<String, dynamic> json) =>
    _$LeaveRequestImpl(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      salonId: json['salonId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      reason: json['reason'] as String,
      status: json['status'] as String? ?? 'pending',
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      respondedBy: json['respondedBy'] as String?,
      employeeName: json['employeeName'] as String?,
      employeeAvatar: json['employeeAvatar'] as String?,
    );

Map<String, dynamic> _$$LeaveRequestImplToJson(_$LeaveRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'salonId': instance.salonId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'reason': instance.reason,
      'status': instance.status,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'respondedBy': instance.respondedBy,
      'employeeName': instance.employeeName,
      'employeeAvatar': instance.employeeAvatar,
    };
