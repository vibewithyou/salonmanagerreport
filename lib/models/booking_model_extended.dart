import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model_extended.freezed.dart';
part 'booking_model_extended.g.dart';

@freezed
class BookingData with _$BookingData {
  const factory BookingData({
    String? id,
    required String salonId,
    required String customerId,
    required String serviceId,
    required String stylistId,
    required DateTime appointmentDate,
    required int durationMinutes,
    required double totalPrice,
    required String status, // pending, confirmed, completed, cancelled
    String? notes,
    DateTime? reminderSentAt,
    double? rating,
    String? feedback,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BookingData;

  factory BookingData.fromJson(Map<String, dynamic> json) =>
      _$BookingDataFromJson(json);
}

@freezed
class SalonService with _$SalonService {
  const factory SalonService({
    required String id,
    required String salonId,
    required String name,
    String? description,
    required double price,
    required int durationMinutes,
    String? category,
    bool? isActive,
    DateTime? createdAt,
  }) = _SalonService;

  factory SalonService.fromJson(Map<String, dynamic> json) =>
      _$SalonServiceFromJson(json);
}

@freezed
class Stylist with _$Stylist {
  const factory Stylist({
    required String id,
    required String salonId,
    required String name,
    String? email,
    String? phone,
    String? avatar,
    @Default([]) List<String> specialties,
    bool? isActive,
    DateTime? createdAt,
  }) = _Stylist;

  factory Stylist.fromJson(Map<String, dynamic> json) =>
      _$StylistFromJson(json);
}

@freezed
class Customer with _$Customer {
  const factory Customer({
    required String id,
    required String firstName,
    required String lastName,
    String? email,
    String? phone,
    String? avatar,
    DateTime? createdAt,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}
