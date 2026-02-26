class LeaveRequest {
  const LeaveRequest({
    required this.id,
    required this.salonId,
    required this.staffId,
    required this.type,
    required this.startAt,
    required this.endAt,
    required this.status,
    this.reason,
    this.decidedBy,
    this.decidedAt,
  });

  final String id;
  final String salonId;
  final String staffId;
  final String type;
  final DateTime startAt;
  final DateTime endAt;
  final String status;
  final String? reason;
  final String? decidedBy;
  final DateTime? decidedAt;

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'] as String,
      salonId: json['salon_id'] as String,
      staffId: json['staff_id'] as String,
      type: (json['type'] as String?) ?? 'other',
      startAt: DateTime.parse(json['start_at'].toString()),
      endAt: DateTime.parse(json['end_at'].toString()),
      status: (json['status'] as String?) ?? 'pending',
      reason: json['reason'] as String?,
      decidedBy: json['decided_by'] as String?,
      decidedAt: json['decided_at'] == null
          ? null
          : DateTime.parse(json['decided_at'].toString()),
    );
  }
}
