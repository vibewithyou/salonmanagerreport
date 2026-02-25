import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_entry_model.freezed.dart';
part 'time_entry_model.g.dart';

/// Time tracking entry model
@freezed
class TimeEntry with _$TimeEntry {
  const factory TimeEntry({
    required String id,
    required String employeeId,
    required String employeeName,
    required String salonId,
    required DateTime checkInTime,
    DateTime? checkOutTime,
    int? totalMinutes,
    String? notes,
  }) = _TimeEntry;

  factory TimeEntry.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryFromJson(json);
}

/// Current time entry status
@freezed
class TimeEntryStatus with _$TimeEntryStatus {
  const factory TimeEntryStatus({
    required bool isCheckedIn,
    TimeEntry? currentEntry,
    int? todayMinutes,
    int? weekMinutes,
  }) = _TimeEntryStatus;

  factory TimeEntryStatus.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryStatusFromJson(json);
}
