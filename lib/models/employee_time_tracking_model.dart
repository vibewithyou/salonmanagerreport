import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_time_tracking_model.freezed.dart';
part 'employee_time_tracking_model.g.dart';

enum TimeEntryType {
  @JsonValue('clock_in')
  clockIn,
  @JsonValue('clock_out')
  clockOut,
  @JsonValue('break_start')
  breakStart,
  @JsonValue('break_end')
  breakEnd,
  @JsonValue('sick')
  sick,
  @JsonValue('absent')
  absent,
}

@freezed
class TimeEntry with _$TimeEntry {
  const factory TimeEntry({
    required String id,
    required String salonId,
    required String employeeId,
    required TimeEntryType entryType,
    required DateTime timestamp,
    String? notes,
    required bool adminConfirmed,
    String? adminId,
    DateTime? confirmedAt,
    int? durationMinutes,
    required DateTime createdAt,
  }) = _TimeEntry;

  factory TimeEntry.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryFromJson(json);
}

@freezed
class DailyWorkload with _$DailyWorkload {
  const factory DailyWorkload({
    required String employeeId,
    required String employeeName,
    required int totalMinutes,
    String? clockInTime,
    String? clockOutTime,
    required int breakMinutes,
    required String status, // 'working', 'sick', 'absent', 'no_entry'
    required bool isSick,
    required bool isAbsent,
  }) = _DailyWorkload;

  factory DailyWorkload.fromJson(Map<String, dynamic> json) =>
      _$DailyWorkloadFromJson(json);
}

@freezed
class WeeklyWorkload with _$WeeklyWorkload {
  const factory WeeklyWorkload({
    required String workDate,
    required String employeeId,
    required String employeeName,
    required double totalHours,
    required String status, // 'working', 'sick', 'absent', 'no_entry'
    required bool isSick,
    required bool isAbsent,
  }) = _WeeklyWorkload;

  factory WeeklyWorkload.fromJson(Map<String, dynamic> json) =>
      _$WeeklyWorkloadFromJson(json);
}

@freezed
class EmployeeTimeCode with _$EmployeeTimeCode {
  const factory EmployeeTimeCode({
    required String id,
    required String employeeId,
    required String timeCode,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _EmployeeTimeCode;

  factory EmployeeTimeCode.fromJson(Map<String, dynamic> json) =>
      _$EmployeeTimeCodeFromJson(json);
}

@freezed
class ActivityLogEntry with _$ActivityLogEntry {
  const factory ActivityLogEntry({
    required String id,
    required String salonId,
    required String userId,
    required String action,
    String? description,
    Map<String, dynamic>? metadata,
    required DateTime timestamp,
  }) = _ActivityLogEntry;

  factory ActivityLogEntry.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogEntryFromJson(json);
}
