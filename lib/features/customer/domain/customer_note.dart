class CustomerNote {
  final String id;
  final String salonId;
  final String customerId;
  final String createdBy;
  final String note;
  final DateTime createdAt;

  const CustomerNote({
    required this.id,
    required this.salonId,
    required this.customerId,
    required this.createdBy,
    required this.note,
    required this.createdAt,
  });

  factory CustomerNote.fromJson(Map<String, dynamic> json) {
    return CustomerNote(
      id: json['id'] as String,
      salonId: json['salon_id'] as String,
      customerId: json['customer_id'] as String,
      createdBy: json['created_by'] as String,
      note: json['note'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
