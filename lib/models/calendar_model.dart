import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_model.freezed.dart';
part 'calendar_model.g.dart';

@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    String? id,
    required String salonId,
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    required String eventType, // appointment, break, holiday, event
    required String status, // scheduled, completed, cancelled
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CalendarEvent;

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
}

@freezed
class AppointmentSummary with _$AppointmentSummary {
  const factory AppointmentSummary({
    required int totalAppointments,
    required int completedAppointments,
    required int cancelledAppointments,
    required int pendingAppointments,
  }) = _AppointmentSummary;

  factory AppointmentSummary.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSummaryFromJson(json);
}
