// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardConfigImpl _$$DashboardConfigImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardConfigImpl(
  id: json['id'] as String,
  salonId: json['salonId'] as String,
  enabledModules: json['enabledModules'] as Map<String, dynamic>,
  permissions: json['permissions'] as Map<String, dynamic>,
  salonCodeHash: json['salonCodeHash'] as String?,
  salonCodePlaintext: json['salonCodePlaintext'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  salonCodeUpdatedAt: json['salonCodeUpdatedAt'] == null
      ? null
      : DateTime.parse(json['salonCodeUpdatedAt'] as String),
);

Map<String, dynamic> _$$DashboardConfigImplToJson(
  _$DashboardConfigImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'salonId': instance.salonId,
  'enabledModules': instance.enabledModules,
  'permissions': instance.permissions,
  'salonCodeHash': instance.salonCodeHash,
  'salonCodePlaintext': instance.salonCodePlaintext,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'salonCodeUpdatedAt': instance.salonCodeUpdatedAt?.toIso8601String(),
};
