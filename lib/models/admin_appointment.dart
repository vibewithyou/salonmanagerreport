import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'admin_appointment.freezed.dart';
part 'admin_appointment.g.dart';

@freezed
class AdminAppointment with _$AdminAppointment {
  const factory AdminAppointment({
    required String id,
    required String salonId,
    required String customerId,
    required String employeeId,
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    @Default('pending') String status,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? customerName,
    String? employeeName,
    String? serviceName,
  }) = _AdminAppointment;

  const AdminAppointment._();

  factory AdminAppointment.fromJson(Map<String, dynamic> json) =>
      _$AdminAppointmentFromJson(json);

  /// Color für Status-Anzeige in der UI
  Color get statusColor {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Lesbare Status-Bezeichnung
  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Ausstehend';
      case 'confirmed':
        return 'Bestätigt';
      case 'completed':
        return 'Abgeschlossen';
      case 'cancelled':
        return 'Storniert';
      default:
        return status;
    }
  }

  /// Zeitbereich als String (z.B. "10:30 - 11:30")
  String get timeRange {
    final start = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }

  /// Rückgabe der formatierten Dauer (z.B. "1h 30m")
  String get duration {
    final diff = endTime.difference(startTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    if (hours == 0) {
      return '${minutes}m';
    } else if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}m';
  }

  /// Prüft ob Termin in der Vergangenheit liegt
  bool get isPast {
    return endTime.isBefore(DateTime.now());
  }

  /// Prüft ob Termin heute ist
  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
        startTime.month == now.month &&
        startTime.day == now.day;
  }

  /// Prüft ob Termin storniert ist
  bool get isCancelled {
    return status == 'cancelled';
  }

  /// Prüft ob Termin bestätigt ist
  bool get isConfirmed {
    return status == 'confirmed';
  }

  /// Prüft ob Termin ausstehend ist
  bool get isPending {
    return status == 'pending';
  }

  /// Prüft ob Termin abgeschlossen ist
  bool get isCompleted {
    return status == 'completed';
  }

  /// Rückgabe des formatierten Datums (z.B. "15. Feb 2026")
  String get formattedDate {
    final monthNames = [
      'Jan',
      'Feb',
      'Mär',
      'Apr',
      'Mai',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Okt',
      'Nov',
      'Dez'
    ];
    return '${startTime.day}. ${monthNames[startTime.month - 1]} ${startTime.year}';
  }

  /// Rückgabe von "Heute um HH:MM" oder Datum + Zeit
  String get displayTime {
    if (isToday) {
      final time =
          '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
      return 'Heute um $time';
    }
    return '$formattedDate um $timeRange';
  }

  /// Rückgabe des Kundennamens oder Fallback
  String get displayCustomerName {
    return customerName ?? 'Unbekannter Kunde';
  }

  /// Rückgabe des Mitarbeiternamen oder Fallback
  String get displayEmployeeName {
    return employeeName ?? 'Unbekannter Mitarbeiter';
  }

  /// Rückgabe des Servicenamens oder Fallback
  String get displayServiceName {
    return serviceName ?? 'Unbekannter Service';
  }
}
