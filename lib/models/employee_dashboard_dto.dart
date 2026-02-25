import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_dashboard_dto.freezed.dart';
part 'employee_dashboard_dto.g.dart';

/// DTO for Salon Services (POS Tab)
/// Fields: id, salon_id, name, description, duration_minutes, price, category
@freezed
class SalonServiceDto with _$SalonServiceDto {
  const factory SalonServiceDto({
    required String id,
    required String salonId,
    required String name,
    String? description,
    @Default(30) int durationMinutes,
    required double price,
    String? category,
    @Default(true) bool isActive,
    @Default(0) int bufferBefore,
    @Default(0) int bufferAfter,
    @Default(0) double depositAmount,
  }) = _SalonServiceDto;

  factory SalonServiceDto.fromJson(Map<String, dynamic> json) =>
      _$SalonServiceDtoFromJson(json);
}

/// DTO for Salon Customers (Customers Tab)
/// Fields: id, first_name, last_name, phone, email + computed: lastVisit, totalSpending
@freezed
class SalonCustomerDto with _$SalonCustomerDto {
  const factory SalonCustomerDto({
    required String id,
    required String salonId,
    required String firstName,
    required String lastName,
    String? phone,
    String? email,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<AppointmentSummaryDto> appointments,
    @Default(0) double totalSpending,
    DateTime? lastVisitDate,
  }) = _SalonCustomerDto;

  factory SalonCustomerDto.fromJson(
    Map<String, dynamic> json, {
    List<AppointmentSummaryDto>? appointments,
    double? totalSpending,
    DateTime? lastVisitDate,
  }) =>
      SalonCustomerDto(
        id: json['id'] as String,
        salonId: json['salon_id'] as String? ?? '',
        firstName: json['first_name'] as String? ?? '',
        lastName: json['last_name'] as String? ?? '',
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
        appointments: appointments ?? [],
        totalSpending: totalSpending ?? 0,
        lastVisitDate: lastVisitDate,
      );
}

/// DTO for Appointment Summary (for customer history)
@freezed
class AppointmentSummaryDto with _$AppointmentSummaryDto {
  const factory AppointmentSummaryDto({
    required String id,
    required DateTime startTime,
    required String status,
    double? price,
  }) = _AppointmentSummaryDto;

  factory AppointmentSummaryDto.fromJson(Map<String, dynamic> json) =>
      AppointmentSummaryDto(
        id: json['id'] as String,
        startTime: DateTime.parse(json['start_time'] as String),
        status: json['status'] as String? ?? 'pending',
        price: (json['price'] as num?)?.toDouble(),
      );
}

/// DTO for Employee Portfolio Images (Portfolio Tab)
/// Fields: id, image_url, caption, created_at, color, hairstyle
@freezed
class EmployeePortfolioImageDto with _$EmployeePortfolioImageDto {
  const factory EmployeePortfolioImageDto({
    required String id,
    required String employeeId,
    required String imageUrl,
    String? caption,
    required DateTime createdAt,
    String? color,
    String? hairstyle,
    String? mimeType,
    int? fileSize,
    int? height,
    int? width,
  }) = _EmployeePortfolioImageDto;

  factory EmployeePortfolioImageDto.fromJson(Map<String, dynamic> json) =>
      EmployeePortfolioImageDto(
        id: json['id'] as String,
        employeeId: json['employee_id'] as String? ?? '',
        imageUrl: json['image_url'] as String,
        caption: json['caption'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
        color: json['color'] as String?,
        hairstyle: json['hairstyle'] as String?,
        mimeType: json['mime_type'] as String?,
        fileSize: json['file_size'] as int?,
        height: json['height'] as int?,
        width: json['width'] as int?,
      );
}

/// DTO for Employee Portfolio Images with Tags
@freezed
class EmployeePortfolioImageWithTagsDto
    with _$EmployeePortfolioImageWithTagsDto {
  const factory EmployeePortfolioImageWithTagsDto({
    required String id,
    required String imageUrl,
    String? caption,
    required DateTime createdAt,
    String? color,
    String? hairstyle,
    String? mimeType,
    int? fileSize,
    int? height,
    int? width,
    @Default([]) List<String> tagIds,
  }) = _EmployeePortfolioImageWithTagsDto;

  factory EmployeePortfolioImageWithTagsDto.fromJson(
      Map<String, dynamic> json) {
    final tagsList = json['gallery_image_tags'] as List? ?? [];
    final tagIds = tagsList
        .whereType<Map<String, dynamic>>()
        .map((tag) => tag['tag_id'] as String)
        .toList();

    return EmployeePortfolioImageWithTagsDto(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      caption: json['caption'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      color: json['color'] as String?,
      hairstyle: json['hairstyle'] as String?,
      mimeType: json['mime_type'] as String?,
      fileSize: json['file_size'] as int?,
      height: json['height'] as int?,
      width: json['width'] as int?,
      tagIds: tagIds,
    );
  }
}

/// DTO for Past Appointments (Past Appointments Tab)
/// Fields: id, customer info, service, start_time, status, price, appointment_number
@freezed
class PastAppointmentDto with _$PastAppointmentDto {
  const factory PastAppointmentDto({
    required String id,
    String? customerProfileId,
    String? guestName,
    String? guestEmail,
    String? serviceId,
    required DateTime startTime,
    required String status,
    double? price,
    String? appointmentNumber,
  }) = _PastAppointmentDto;

  factory PastAppointmentDto.fromJson(Map<String, dynamic> json) =>
      PastAppointmentDto(
        id: json['id'] as String,
        customerProfileId: json['customer_profile_id'] as String?,
        guestName: json['guest_name'] as String?,
        guestEmail: json['guest_email'] as String?,
        serviceId: json['service_id'] as String?,
        startTime: DateTime.parse(json['start_time'] as String),
        status: json['status'] as String? ?? 'pending',
        price: (json['price'] as num?)?.toDouble(),
        appointmentNumber: json['appointment_number'] as String?,
      );
}

/// DTO for Appointment Statistics
@freezed
class AppointmentStatisticsDto with _$AppointmentStatisticsDto {
  const factory AppointmentStatisticsDto({
    required int totalAppointments,
    required int totalCompleted,
    required int totalCancelled,
    required double totalRevenue,
    required double completionRate,
  }) = _AppointmentStatisticsDto;

  factory AppointmentStatisticsDto.fromJson(Map<String, dynamic> json) =>
      AppointmentStatisticsDto(
        totalAppointments: json['totalAppointments'] as int? ?? 0,
        totalCompleted: json['totalCompleted'] as int? ?? 0,
        totalCancelled: json['totalCancelled'] as int? ?? 0,
        totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
        completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0,
      );
}

/// DTO for Customer with Full History
@freezed
class CustomerWithHistoryDto with _$CustomerWithHistoryDto {
  const factory CustomerWithHistoryDto({
    required String id,
    required String firstName,
    required String lastName,
    String? phone,
    String? email,
    String? address,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<AppointmentSummaryDto> appointments,
  }) = _CustomerWithHistoryDto;

  factory CustomerWithHistoryDto.fromJson(
    Map<String, dynamic> json, {
    List<AppointmentSummaryDto>? appointments,
  }) =>
      CustomerWithHistoryDto(
        id: json['id'] as String,
        firstName: json['first_name'] as String? ?? '',
        lastName: json['last_name'] as String? ?? '',
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        address: json['address'] as String?,
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
        appointments: appointments ?? [],
      );
}
