import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment_model_simple.freezed.dart';
part 'appointment_model_simple.g.dart';

enum AppointmentStatus {
  pending,
  confirmed,
  completed,
  cancelled,
  noShow
}

/// Simplified appointment model for dashboard displays
@freezed
class AppointmentSimple with _$AppointmentSimple {
  const factory AppointmentSimple({
    required String id,
    required DateTime startTime,
    required DateTime endTime,
    required String customerName,
    required String? customerPhone,
    required String serviceName,
    required double price,
    required AppointmentStatus status,
    String? stylistName,
    String? stylistId,
    String? notes,
  }) = _AppointmentSimple;

  factory AppointmentSimple.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSimpleFromJson(json);
}
