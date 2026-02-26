class EmployeeAppointment {
  const EmployeeAppointment({
    required this.id,
    required this.salonId,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.customerName,
    required this.serviceName,
    this.price,
    this.notes,
  });

  final String id;
  final String salonId;
  final DateTime startAt;
  final DateTime endAt;
  final String status;
  final String customerName;
  final String serviceName;
  final num? price;
  final String? notes;

  factory EmployeeAppointment.fromJson(Map<String, dynamic> json) {
    return EmployeeAppointment(
      id: json['id'] as String,
      salonId: json['salon_id'] as String,
      startAt: DateTime.parse((json['start_at'] ?? json['start_time']).toString()),
      endAt: DateTime.parse((json['end_at'] ?? json['end_time']).toString()),
      status: (json['status'] as String?) ?? 'pending',
      customerName: (json['customer_name'] as String?) ?? 'Kunde',
      serviceName: (json['service_name'] as String?) ?? 'Service',
      price: json['price'] as num?,
      notes: json['notes'] as String?,
    );
  }
}
