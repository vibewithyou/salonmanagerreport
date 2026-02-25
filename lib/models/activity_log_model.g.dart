// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityLogImpl _$$ActivityLogImplFromJson(Map<String, dynamic> json) =>
    _$ActivityLogImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
    );

Map<String, dynamic> _$$ActivityLogImplToJson(_$ActivityLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'userId': instance.userId,
      'userName': instance.userName,
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
      'ipAddress': instance.ipAddress,
      'userAgent': instance.userAgent,
    };

const _$ActivityTypeEnumMap = {
  ActivityType.salonCodeGenerated: 'salonCodeGenerated',
  ActivityType.salonCodeReset: 'salonCodeReset',
  ActivityType.employeeCodeGenerated: 'employeeCodeGenerated',
  ActivityType.employeeCodeReset: 'employeeCodeReset',
  ActivityType.moduleEnabled: 'moduleEnabled',
  ActivityType.moduleDisabled: 'moduleDisabled',
  ActivityType.permissionChanged: 'permissionChanged',
  ActivityType.salonSettingsUpdated: 'salonSettingsUpdated',
  ActivityType.employeeAdded: 'employeeAdded',
  ActivityType.employeeRemoved: 'employeeRemoved',
  ActivityType.employee_created: 'employee_created',
  ActivityType.employee_deleted: 'employee_deleted',
  ActivityType.employeeLogin: 'employeeLogin',
  ActivityType.adminLogin: 'adminLogin',
  ActivityType.customerLogin: 'customerLogin',
  ActivityType.other: 'other',
};

_$ActivityLogCreateRequestImpl _$$ActivityLogCreateRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityLogCreateRequestImpl(
  salonId: json['salonId'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
  description: json['description'] as String,
  metadata: json['metadata'] as Map<String, dynamic>?,
  ipAddress: json['ipAddress'] as String?,
  userAgent: json['userAgent'] as String?,
);

Map<String, dynamic> _$$ActivityLogCreateRequestImplToJson(
  _$ActivityLogCreateRequestImpl instance,
) => <String, dynamic>{
  'salonId': instance.salonId,
  'userId': instance.userId,
  'userName': instance.userName,
  'type': _$ActivityTypeEnumMap[instance.type]!,
  'description': instance.description,
  'metadata': instance.metadata,
  'ipAddress': instance.ipAddress,
  'userAgent': instance.userAgent,
};
