class BookingMedia {
  final String id;
  final String appointmentId;
  final String customerProfileId;
  final String salonId;
  final String mediaType;
  final String fileUrl;
  final String? filePath;
  final String? mimeType;
  final int? fileSize;
  final DateTime createdAt;

  const BookingMedia({
    required this.id,
    required this.appointmentId,
    required this.customerProfileId,
    required this.salonId,
    required this.mediaType,
    required this.fileUrl,
    this.filePath,
    this.mimeType,
    this.fileSize,
    required this.createdAt,
  });

  factory BookingMedia.fromJson(Map<String, dynamic> json) {
    return BookingMedia(
      id: json['id'] as String,
      appointmentId: json['appointment_id'] as String,
      customerProfileId: json['customer_profile_id'] as String,
      salonId: json['salon_id'] as String,
      mediaType: (json['media_type'] as String?) ?? 'before',
      fileUrl: (json['file_url'] as String?) ?? '',
      filePath: json['file_path'] as String?,
      mimeType: json['mime_type'] as String?,
      fileSize: json['file_size'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

