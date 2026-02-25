import 'package:freezed_annotation/freezed_annotation.dart';

part 'module_settings_model.freezed.dart';
part 'module_settings_model.g.dart';

enum ModuleType {
  timeTracking,
  appointments,
  qrCheckin,
  leaveRequests,
  shifts,
  pos,
  inventory,
  gallery,
  chat,
  messaging,
  reports,
  coupons,
  calendar,
  loyaltyProgram,
}

enum ModulePermission {
  view,
  create,
  edit,
  delete,
  export,
  manage,
}

@freezed
class ModuleSettings with _$ModuleSettings {
  const factory ModuleSettings({
    required String id,
    required String salonId,
    required ModuleType moduleType,
    required bool isEnabled,
    required List<ModulePermission> permissions,
    required DateTime enabledAt,
    DateTime? disabledAt,
    Map<String, dynamic>? configuration,
  }) = _ModuleSettings;

  factory ModuleSettings.fromJson(Map<String, dynamic> json) =>
      _$ModuleSettingsFromJson(json);
}

@freezed
class DashboardModule with _$DashboardModule {
  const factory DashboardModule({
    required ModuleType type,
    required String label,
    required String icon,
    String? description,
    required bool isEnabled,
    required List<ModulePermission> permissions,
    required bool isPremium,
    bool? isRequired,
  }) = _DashboardModule;

  factory DashboardModule.fromJson(Map<String, dynamic> json) =>
      _$DashboardModuleFromJson(json);
}
