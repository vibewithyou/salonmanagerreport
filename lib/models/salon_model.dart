import 'package:freezed_annotation/freezed_annotation.dart';

part 'salon_model.freezed.dart';
part 'salon_model.g.dart';

@freezed
class Salon with _$Salon {
  const factory Salon({
    required String id,
    required String name,
    required String? description,
    required String? address,
    required String? city,
    required String? postalCode,
    required String? country,
    required String? phone,
    required String? email,
    required String? website,
    required String? logo,
    required String? banner,
    required double? latitude,
    required double? longitude,
    required DateTime createdAt,
    required DateTime? updatedAt,
    required bool isActive,
    required String? operatingHours,
    required String? openingDays,
    required String? closureDates,
    required String? ownerId,
  }) = _Salon;

  factory Salon.fromJson(Map<String, dynamic> json) => _$SalonFromJson(json);
}

@freezed
class SalonService with _$SalonService {
  const factory SalonService({
    required String id,
    required String salonId,
    required String name,
    required String? description,
    required double price,
    required int durationMinutes,
    required String? category,
    required bool isActive,
    required DateTime createdAt,
  }) = _SalonService;

  factory SalonService.fromJson(Map<String, dynamic> json) =>
      _$SalonServiceFromJson(json);
}

@freezed
class Stylist with _$Stylist {
  const factory Stylist({
    required String id,
    required String salonId,
    required String firstName,
    required String lastName,
    required String? phone,
    required String? email,
    required String? avatar,
    required List<String> specializations,
    required bool isActive,
    required DateTime createdAt,
  }) = _Stylist;

  factory Stylist.fromJson(Map<String, dynamic> json) =>
      _$StylistFromJson(json);
}
