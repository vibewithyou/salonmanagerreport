import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'leave_request.freezed.dart';
part 'leave_request.g.dart';

@freezed
class LeaveRequest with _$LeaveRequest {
  const factory LeaveRequest({
    required String id,
    required String employeeId,
    required String salonId,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    @Default('pending') String status,
    required DateTime requestedAt,
    DateTime? respondedAt,
    String? respondedBy,
    String? employeeName,
    String? employeeAvatar,
  }) = _LeaveRequest;

  const LeaveRequest._();

  factory LeaveRequest.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestFromJson(json);

  /// Color für Status-Anzeige in der UI
  Color get statusColor {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
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
      case 'approved':
        return 'Genehmigt';
      case 'rejected':
        return 'Abgelehnt';
      default:
        return status;
    }
  }

  /// Dauer der Abwesenheit in Tagen
  int get durationDays {
    return endDate.difference(startDate).inDays + 1;
  }

  /// Rückgabe der Dauer als Text (z.B. "3 Tage" oder "1 Tag")
  String get durationLabel {
    if (durationDays == 1) {
      return '1 Tag';
    }
    return '$durationDays Tage';
  }

  /// Prüft ob Anfrage noch ausstehend ist
  bool get isPending {
    return status == 'pending';
  }

  /// Prüft ob Anfrage genehmigt wurde
  bool get isApproved {
    return status == 'approved';
  }

  /// Prüft ob Anfrage abgelehnt wurde
  bool get isRejected {
    return status == 'rejected';
  }

  /// Rückgabe des formatierten Datums (z.B. "15. Feb 2026")
  String _formatDate(DateTime date) {
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
    return '${date.day}. ${monthNames[date.month - 1]} ${date.year}';
  }

  /// Zeitbereich als String (z.B. "15. Feb - 18. Feb 2026")
  String get dateRange {
    final start = _formatDate(startDate);
    final end = _formatDate(endDate);

    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      // Gleiches Datum
      return start;
    }

    if (startDate.year == endDate.year && startDate.month == endDate.month) {
      // Gleicher Monat und Jahr
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
      return '${startDate.day}. - ${endDate.day}. ${monthNames[endDate.month - 1]} ${endDate.year}';
    }

    return '$start - $end';
  }

  /// Prüft ob Urlaub in der Zukunft liegt
  bool get isFuture {
    return startDate.isAfter(DateTime.now());
  }

  /// Prüft ob Urlaub derzeit stattfindet
  bool get isOngoing {
    final now = DateTime.now();
    return !startDate.isAfter(now) && !endDate.isBefore(now);
  }

  /// Prüft ob Urlaub in der Vergangenheit liegt
  bool get isPast {
    return endDate.isBefore(DateTime.now());
  }

  /// Rückgabe des Mitarbeiternamen oder Fallback
  String get displayEmployeeName {
    return employeeName ?? 'Unbekannter Mitarbeiter';
  }

  /// Zeitstempel wann die Anfrage gestellt wurde (relativ)
  String get requestedAtRelative {
    final now = DateTime.now();
    final diff = now.difference(requestedAt);

    if (diff.inMinutes < 1) {
      return 'gerade eben';
    }
    if (diff.inMinutes < 60) {
      return 'vor ${diff.inMinutes} ${diff.inMinutes == 1 ? 'Minute' : 'Minuten'}';
    }
    if (diff.inHours < 24) {
      return 'vor ${diff.inHours} ${diff.inHours == 1 ? 'Stunde' : 'Stunden'}';
    }
    if (diff.inDays < 7) {
      return 'vor ${diff.inDays} ${diff.inDays == 1 ? 'Tag' : 'Tagen'}';
    }

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
    return '${requestedAt.day}. ${monthNames[requestedAt.month - 1]} ${requestedAt.year}';
  }

  /// Zeitstempel wann die Anfrage bearbeitet wurde
  String? get respondedAtFormatted {
    if (respondedAt == null) return null;

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
    final time =
        '${respondedAt!.hour.toString().padLeft(2, '0')}:${respondedAt!.minute.toString().padLeft(2, '0')}';
    return '${respondedAt!.day}. ${monthNames[respondedAt!.month - 1]} ${respondedAt!.year} um $time';
  }

  /// Rückgabe der Bearbeitungsperson oder Fallback
  String get displayRespondedBy {
    return respondedBy ?? 'Administrator';
  }

  /// Detaillierte Anzeige für Status
  String get statusDetail {
    final statusText = statusLabel;

    if (status == 'pending') {
      return '$statusText - Antrag vom $requestedAtRelative';
    }

    if (respondedAt != null) {
      return '$statusText von $displayRespondedBy am $respondedAtFormatted';
    }

    return statusText;
  }
}
