import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_appointment.freezed.dart';
part 'customer_appointment.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@freezed
class CustomerAppointment with _$CustomerAppointment {
  const factory CustomerAppointment({
    required String id,
    required DateTime startTime,
    required DateTime endTime,
    required String status,
    String? notes,
    String? guestName,
    String? guestEmail,
    String? guestPhone,
    double? price,
    int? bufferBefore,
    int? bufferAfter,
    String? imageUrl,
    String? customerProfileId,
    String? appointmentNumber,
    ServiceInfo? service,
  }) = _CustomerAppointment;

  factory CustomerAppointment.fromJson(Map<String, dynamic> json) =>
      _$CustomerAppointmentFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
@freezed
class ServiceInfo with _$ServiceInfo {
  const factory ServiceInfo({
    required String name,
    int? durationMinutes,
    double? price,
  }) = _ServiceInfo;

  factory ServiceInfo.fromJson(Map<String, dynamic> json) =>
      _$ServiceInfoFromJson(json);
}

extension CustomerAppointmentX on CustomerAppointment {
  String get displayDate {
    final now = DateTime.now();
    final appointmentDate = startTime;
    final diff = now.difference(appointmentDate);

    if (diff.inDays == 0) return 'Heute';
    if (diff.inDays == 1) return 'Gestern';
    if (diff.inDays < 7) return 'Vor ${diff.inDays} Tagen';
    if (diff.inDays < 30) return 'Vor ${(diff.inDays / 7).floor()} Wochen';
    if (diff.inDays < 365) return 'Vor ${(diff.inDays / 30).floor()} Monaten';
    return 'Vor ${(diff.inDays / 365).floor()} Jahren';
  }

  String get formattedPrice =>
      price != null ? '€${price!.toStringAsFixed(2)}' : '';
}
