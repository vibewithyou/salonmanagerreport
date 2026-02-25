// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaveRequestImpl _$$LeaveRequestImplFromJson(Map<String, dynamic> json) =>
    _$LeaveRequestImpl(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      type: $enumDecode(_$LeaveTypeEnumMap, json['type']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      reason: json['reason'] as String,
      status: $enumDecode(_$LeaveStatusEnumMap, json['status']),
      adminNotes: json['adminNotes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$LeaveRequestImplToJson(_$LeaveRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'type': _$LeaveTypeEnumMap[instance.type]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'reason': instance.reason,
      'status': _$LeaveStatusEnumMap[instance.status]!,
      'adminNotes': instance.adminNotes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$LeaveTypeEnumMap = {
  LeaveType.vacation: 'vacation',
  LeaveType.sick: 'sick',
  LeaveType.personal: 'personal',
  LeaveType.other: 'other',
};

const _$LeaveStatusEnumMap = {
  LeaveStatus.pending: 'pending',
  LeaveStatus.approved: 'approved',
  LeaveStatus.rejected: 'rejected',
};
