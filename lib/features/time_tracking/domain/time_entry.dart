class BreakInterval {
  const BreakInterval({
    required this.startAt,
    this.endAt,
  });

  final DateTime startAt;
  final DateTime? endAt;

  factory BreakInterval.fromJson(Map<String, dynamic> json) {
    return BreakInterval(
      startAt: DateTime.parse(json['start_at'] as String),
      endAt: json['end_at'] == null
          ? null
          : DateTime.parse(json['end_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_at': startAt.toIso8601String(),
      'end_at': endAt?.toIso8601String(),
    };
  }
}

class TimeEntry {
  const TimeEntry({
    required this.id,
    required this.salonId,
    required this.staffId,
    required this.clockIn,
    required this.clockOut,
    required this.breaks,
  });

  final String id;
  final String salonId;
  final String staffId;
  final DateTime clockIn;
  final DateTime? clockOut;
  final List<BreakInterval> breaks;

  Duration? get workedDuration {
    final end = clockOut;
    if (end == null) {
      return null;
    }
    return end.difference(clockIn);
  }

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    final breaksJson = (json['breaks_json'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();

    return TimeEntry(
      id: json['id'] as String,
      salonId: json['salon_id'] as String,
      staffId: json['staff_id'] as String,
      clockIn: DateTime.parse(json['clock_in'] as String),
      clockOut: json['clock_out'] == null
          ? null
          : DateTime.parse(json['clock_out'] as String),
      breaks: breaksJson.map(BreakInterval.fromJson).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salon_id': salonId,
      'staff_id': staffId,
      'clock_in': clockIn.toIso8601String(),
      'clock_out': clockOut?.toIso8601String(),
      'breaks_json': breaks.map((item) => item.toJson()).toList(),
    };
  }
}
