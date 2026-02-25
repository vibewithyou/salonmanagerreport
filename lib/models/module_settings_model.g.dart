// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModuleSettingsImpl _$$ModuleSettingsImplFromJson(Map<String, dynamic> json) =>
    _$ModuleSettingsImpl(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      moduleType: $enumDecode(_$ModuleTypeEnumMap, json['moduleType']),
      isEnabled: json['isEnabled'] as bool,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => $enumDecode(_$ModulePermissionEnumMap, e))
          .toList(),
      enabledAt: DateTime.parse(json['enabledAt'] as String),
      disabledAt: json['disabledAt'] == null
          ? null
          : DateTime.parse(json['disabledAt'] as String),
      configuration: json['configuration'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ModuleSettingsImplToJson(
  _$ModuleSettingsImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'salonId': instance.salonId,
  'moduleType': _$ModuleTypeEnumMap[instance.moduleType]!,
  'isEnabled': instance.isEnabled,
  'permissions': instance.permissions
      .map((e) => _$ModulePermissionEnumMap[e]!)
      .toList(),
  'enabledAt': instance.enabledAt.toIso8601String(),
  'disabledAt': instance.disabledAt?.toIso8601String(),
  'configuration': instance.configuration,
};

const _$ModuleTypeEnumMap = {
  ModuleType.timeTracking: 'timeTracking',
  ModuleType.appointments: 'appointments',
  ModuleType.qrCheckin: 'qrCheckin',
  ModuleType.leaveRequests: 'leaveRequests',
  ModuleType.shifts: 'shifts',
  ModuleType.pos: 'pos',
  ModuleType.inventory: 'inventory',
  ModuleType.gallery: 'gallery',
  ModuleType.chat: 'chat',
  ModuleType.messaging: 'messaging',
  ModuleType.reports: 'reports',
  ModuleType.coupons: 'coupons',
  ModuleType.calendar: 'calendar',
  ModuleType.loyaltyProgram: 'loyaltyProgram',
};

const _$ModulePermissionEnumMap = {
  ModulePermission.view: 'view',
  ModulePermission.create: 'create',
  ModulePermission.edit: 'edit',
  ModulePermission.delete: 'delete',
  ModulePermission.export: 'export',
  ModulePermission.manage: 'manage',
};

_$DashboardModuleImpl _$$DashboardModuleImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardModuleImpl(
  type: $enumDecode(_$ModuleTypeEnumMap, json['type']),
  label: json['label'] as String,
  icon: json['icon'] as String,
  description: json['description'] as String?,
  isEnabled: json['isEnabled'] as bool,
  permissions: (json['permissions'] as List<dynamic>)
      .map((e) => $enumDecode(_$ModulePermissionEnumMap, e))
      .toList(),
  isPremium: json['isPremium'] as bool,
  isRequired: json['isRequired'] as bool?,
);

Map<String, dynamic> _$$DashboardModuleImplToJson(
  _$DashboardModuleImpl instance,
) => <String, dynamic>{
  'type': _$ModuleTypeEnumMap[instance.type]!,
  'label': instance.label,
  'icon': instance.icon,
  'description': instance.description,
  'isEnabled': instance.isEnabled,
  'permissions': instance.permissions
      .map((e) => _$ModulePermissionEnumMap[e]!)
      .toList(),
  'isPremium': instance.isPremium,
  'isRequired': instance.isRequired,
};
