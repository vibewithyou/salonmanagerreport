// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeEntryImpl _$$TimeEntryImplFromJson(Map<String, dynamic> json) =>
    _$TimeEntryImpl(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      salonId: json['salonId'] as String,
      checkInTime: DateTime.parse(json['checkInTime'] as String),
      checkOutTime: json['checkOutTime'] == null
          ? null
          : DateTime.parse(json['checkOutTime'] as String),
      totalMinutes: (json['totalMinutes'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$TimeEntryImplToJson(_$TimeEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'salonId': instance.salonId,
      'checkInTime': instance.checkInTime.toIso8601String(),
      'checkOutTime': instance.checkOutTime?.toIso8601String(),
      'totalMinutes': instance.totalMinutes,
      'notes': instance.notes,
    };

_$TimeEntryStatusImpl _$$TimeEntryStatusImplFromJson(
  Map<String, dynamic> json,
) => _$TimeEntryStatusImpl(
  isCheckedIn: json['isCheckedIn'] as bool,
  currentEntry: json['currentEntry'] == null
      ? null
      : TimeEntry.fromJson(json['currentEntry'] as Map<String, dynamic>),
  todayMinutes: (json['todayMinutes'] as num?)?.toInt(),
  weekMinutes: (json['weekMinutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$$TimeEntryStatusImplToJson(
  _$TimeEntryStatusImpl instance,
) => <String, dynamic>{
  'isCheckedIn': instance.isCheckedIn,
  'currentEntry': instance.currentEntry,
  'todayMinutes': instance.todayMinutes,
  'weekMinutes': instance.weekMinutes,
};
