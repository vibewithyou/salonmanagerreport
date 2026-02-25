import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log_model.freezed.dart';
part 'activity_log_model.g.dart';

enum ActivityType {
  salonCodeGenerated,
  salonCodeReset,
  employeeCodeGenerated,
  employeeCodeReset,
  moduleEnabled,
  moduleDisabled,
  permissionChanged,
  salonSettingsUpdated,
  employeeAdded,
  employeeRemoved,
  employee_created,
  employee_deleted,
  employeeLogin,
  adminLogin,
  customerLogin,
  other,
}

@freezed
class ActivityLog with _$ActivityLog {
  const factory ActivityLog({
    required String id,
    required String salonId,
    required String userId,
    required String userName,
    required ActivityType type,
    required String description,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
    String? ipAddress,
    String? userAgent,
  }) = _ActivityLog;

  factory ActivityLog.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogFromJson(json);
}

@freezed
class ActivityLogCreateRequest with _$ActivityLogCreateRequest {
  const factory ActivityLogCreateRequest({
    required String salonId,
    required String userId,
    required String userName,
    required ActivityType type,
    required String description,
    Map<String, dynamic>? metadata,
    String? ipAddress,
    String? userAgent,
  }) = _ActivityLogCreateRequest;

  factory ActivityLogCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogCreateRequestFromJson(json);
}
