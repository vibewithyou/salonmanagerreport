import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_config_model.freezed.dart';
part 'dashboard_config_model.g.dart';

@freezed
class DashboardConfig with _$DashboardConfig {
  const factory DashboardConfig({
    required String id,
    required String salonId,
    required Map<String, dynamic> enabledModules,
    required Map<String, dynamic> permissions,
    String? salonCodeHash,
    String? salonCodePlaintext,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? salonCodeUpdatedAt,
  }) = _DashboardConfig;

  factory DashboardConfig.fromJson(Map<String, dynamic> json) =>
      _$DashboardConfigFromJson(json);
}
