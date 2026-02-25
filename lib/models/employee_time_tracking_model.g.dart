// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_time_tracking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeEntryImpl _$$TimeEntryImplFromJson(Map<String, dynamic> json) =>
    _$TimeEntryImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      employeeId: json['employeeId'] as String,
      entryType: $enumDecode(_$TimeEntryTypeEnumMap, json['entryType']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
      adminConfirmed: json['adminConfirmed'] as bool,
      adminId: json['adminId'] as String?,
      confirmedAt: json['confirmedAt'] == null
          ? null
          : DateTime.parse(json['confirmedAt'] as String),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TimeEntryImplToJson(_$TimeEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'employeeId': instance.employeeId,
      'entryType': _$TimeEntryTypeEnumMap[instance.entryType]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'notes': instance.notes,
      'adminConfirmed': instance.adminConfirmed,
      'adminId': instance.adminId,
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TimeEntryTypeEnumMap = {
  TimeEntryType.clockIn: 'clock_in',
  TimeEntryType.clockOut: 'clock_out',
  TimeEntryType.breakStart: 'break_start',
  TimeEntryType.breakEnd: 'break_end',
  TimeEntryType.sick: 'sick',
  TimeEntryType.absent: 'absent',
};

_$DailyWorkloadImpl _$$DailyWorkloadImplFromJson(Map<String, dynamic> json) =>
    _$DailyWorkloadImpl(
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      totalMinutes: (json['totalMinutes'] as num).toInt(),
      clockInTime: json['clockInTime'] as String?,
      clockOutTime: json['clockOutTime'] as String?,
      breakMinutes: (json['breakMinutes'] as num).toInt(),
      status: json['status'] as String,
      isSick: json['isSick'] as bool,
      isAbsent: json['isAbsent'] as bool,
    );

Map<String, dynamic> _$$DailyWorkloadImplToJson(_$DailyWorkloadImpl instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'totalMinutes': instance.totalMinutes,
      'clockInTime': instance.clockInTime,
      'clockOutTime': instance.clockOutTime,
      'breakMinutes': instance.breakMinutes,
      'status': instance.status,
      'isSick': instance.isSick,
      'isAbsent': instance.isAbsent,
    };

_$WeeklyWorkloadImpl _$$WeeklyWorkloadImplFromJson(Map<String, dynamic> json) =>
    _$WeeklyWorkloadImpl(
      workDate: json['workDate'] as String,
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      totalHours: (json['totalHours'] as num).toDouble(),
      status: json['status'] as String,
      isSick: json['isSick'] as bool,
      isAbsent: json['isAbsent'] as bool,
    );

Map<String, dynamic> _$$WeeklyWorkloadImplToJson(
  _$WeeklyWorkloadImpl instance,
) => <String, dynamic>{
  'workDate': instance.workDate,
  'employeeId': instance.employeeId,
  'employeeName': instance.employeeName,
  'totalHours': instance.totalHours,
  'status': instance.status,
  'isSick': instance.isSick,
  'isAbsent': instance.isAbsent,
};

_$EmployeeTimeCodeImpl _$$EmployeeTimeCodeImplFromJson(
  Map<String, dynamic> json,
) => _$EmployeeTimeCodeImpl(
  id: json['id'] as String,
  employeeId: json['employeeId'] as String,
  timeCode: json['timeCode'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$EmployeeTimeCodeImplToJson(
  _$EmployeeTimeCodeImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'employeeId': instance.employeeId,
  'timeCode': instance.timeCode,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_$ActivityLogEntryImpl _$$ActivityLogEntryImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityLogEntryImpl(
  id: json['id'] as String,
  salonId: json['salonId'] as String,
  userId: json['userId'] as String,
  action: json['action'] as String,
  description: json['description'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$$ActivityLogEntryImplToJson(
  _$ActivityLogEntryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'salonId': instance.salonId,
  'userId': instance.userId,
  'action': instance.action,
  'description': instance.description,
  'metadata': instance.metadata,
  'timestamp': instance.timestamp.toIso8601String(),
};
