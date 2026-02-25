import 'package:freezed_annotation/freezed_annotation.dart';

part 'salon_settings_model.freezed.dart';
part 'salon_settings_model.g.dart';

@freezed
class SalonSettings with _$SalonSettings {
  const factory SalonSettings({
    required String id,
    required String salonId,
    required String salonName,
    String? salonDescription,
    String? address,
    String? city,
    String? postalCode,
    String? phone,
    String? email,
    String? website,
    String? logoUrl,
    String? coverImageUrl,
    String? taxId,
    String? bankAccount,
    List<BusinessHours>? businessHours,
    List<Holiday>? holidays,
    List<PaymentMethod>? paymentMethods,
    Map<String, dynamic>? globalPermissions,
    Map<String, dynamic>? globalModuleSettings,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SalonSettings;

  factory SalonSettings.fromJson(Map<String, dynamic> json) =>
      _$SalonSettingsFromJson(json);
}

/// Note: Holiday and PaymentMethod are stored as Maps in SalonSettings
/// because Freezed doesn't handle nested union/freezed types well in list form.
/// Components using these can parse them manually from the Map data.

@freezed
class BusinessHours with _$BusinessHours {
  const factory BusinessHours({
    required int dayOfWeek, // 0 = Monday, 6 = Sunday
    required String dayName, // "Montag", "Dienstag", etc.
    required bool isOpen,
    String? openTime, // HH:mm format
    String? closeTime, // HH:mm format
  }) = _BusinessHours;

  factory BusinessHours.fromJson(Map<String, dynamic> json) =>
      _$BusinessHoursFromJson(json);
}

@freezed
class Holiday with _$Holiday {
  const factory Holiday({
    required String id,
    required String salonId,
    required DateTime date,
    required String name,
    String? description,
    DateTime? createdAt,
  }) = _Holiday;

  factory Holiday.fromJson(Map<String, dynamic> json) =>
      _$HolidayFromJson(json);
}

@freezed
class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    required String id,
    required String salonId,
    required String name,
    required String type,
    required bool isActive,
    Map<String, dynamic>? configuration,
    DateTime? createdAt,
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
}
