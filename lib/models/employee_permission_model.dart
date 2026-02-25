import 'package:salonmanager/models/module_settings_model.dart';

class EmployeePermission {
  final String id;
  final String salonId;
  final String employeeId;
  final ModuleType moduleType;
  final List<ModulePermission> permissions;
  final DateTime createdAt;
  final DateTime updatedAt;

  EmployeePermission({
    required this.id,
    required this.salonId,
    required this.employeeId,
    required this.moduleType,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployeePermission.fromJson(Map<String, dynamic> json) {
    return EmployeePermission(
      id: json['id'] as String,
      salonId: json['salon_id'] as String,
      employeeId: json['employee_id'] as String,
      moduleType: _moduleTypeFromString(json['module_type'] as String),
      permissions: _permissionsFromList(json['permissions']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salon_id': salonId,
      'employee_id': employeeId,
      'module_type': moduleType.name,
      'permissions': permissions.map((p) => p.name).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

ModuleType _moduleTypeFromString(String value) {
  for (final item in ModuleType.values) {
    if (item.name == value) return item;
  }
  return ModuleType.timeTracking;
}

List<ModulePermission> _permissionsFromList(dynamic raw) {
  if (raw is List) {
    return raw
        .whereType<String>()
        .map((value) => _permissionFromString(value))
        .toList();
  }
  return [ModulePermission.view];
}

ModulePermission _permissionFromString(String value) {
  for (final item in ModulePermission.values) {
    if (item.name == value) return item;
  }
  return ModulePermission.view;
}
