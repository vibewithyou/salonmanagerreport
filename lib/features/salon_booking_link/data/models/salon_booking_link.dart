import 'package:freezed_annotation/freezed_annotation.dart';

part 'salon_booking_link.freezed.dart';
part 'salon_booking_link.g.dart';

@freezed
class SalonBookingLink with _$SalonBookingLink {
  const factory SalonBookingLink({
    /// Die eindeutige Salon-ID
    required String salonId,

    /// Der vollständige Buchungslink (z.B. https://example.com/#/salon/{id})
    required String bookingLink,

    /// Ob die öffentliche Buchung über diesen Link aktiviert ist
    @Default(true) bool bookingEnabled,

    /// Der Salonname (für QR-Code-Download-Dateiname)
    String? salonName,
  }) = _SalonBookingLink;

  factory SalonBookingLink.fromJson(Map<String, dynamic> json) =>
      _$SalonBookingLinkFromJson(json);
}
