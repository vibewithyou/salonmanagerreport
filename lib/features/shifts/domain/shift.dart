class Shift {
  const Shift({
    required this.id,
    required this.salonId,
    required this.staffId,
    required this.startAt,
    required this.endAt,
    required this.type,
    this.note,
  });

  final String id;
  final String salonId;
  final String staffId;
  final DateTime startAt;
  final DateTime endAt;
  final String type;
  final String? note;

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'] as String,
      salonId: json['salon_id'] as String,
      staffId: json['staff_id'] as String,
      startAt: DateTime.parse(json['start_at'].toString()),
      endAt: DateTime.parse(json['end_at'].toString()),
      type: (json['type'] as String?) ?? 'work',
      note: json['note'] as String?,
    );
  }
}
