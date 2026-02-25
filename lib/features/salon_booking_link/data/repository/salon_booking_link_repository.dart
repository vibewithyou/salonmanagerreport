import 'package:salonmanager/features/salon_booking_link/data/datasource/salon_booking_link_datasource.dart';
import 'package:salonmanager/features/salon_booking_link/data/models/salon_booking_link.dart';

/// Repository für Salon Booking Link Management
class SalonBookingLinkRepository {
  final SalonBookingLinkDatasource _datasource;

  SalonBookingLinkRepository(this._datasource);

  /// Generiert einen Buchungslink für einen Salon
  ///
  /// Der Link folgt dem React-Format:
  /// https://salonmanager.app/#/booking/salon/{salonId}
  ///
  /// Parameters:
  /// - [salonId]: Eine eindeutige Salon-ID
  /// - [basePath]: Der Basis-Pfad (Domain + Path), z.B. "https://example.com/app"
  ///
  /// Returns:
  /// Ein vollständiger buchbarer Link
  String generateBookingLink(String salonId, String basePath) {
    // React-Referenz: https://salonmanager.app/#/booking/salon/{salonId}
    return 'https://salonmanager.app/#/booking/salon/$salonId';
  }

  /// Lädt den Booking Link mit allen Einstellungen
  ///
  /// Returns:
  /// Ein [SalonBookingLink] Objekt mit Link, enabled-Status und Salonname
  Future<SalonBookingLink> getBookingLink(String salonId, String basePath) async {
    try {
      // Parallel: Salon-Details und booking_enabled Status laden
      final detailsFuture = _datasource.getSalonDetails(salonId);
      final enabledFuture = _datasource.getSalonBookingEnabled(salonId);

      final results = await Future.wait([detailsFuture, enabledFuture]);
      final details = results[0] as Map<String, dynamic>;
      final enabled = results[1] as bool;

      final bookingLink = generateBookingLink(salonId, basePath);

      return SalonBookingLink(
        salonId: salonId,
        bookingLink: bookingLink,
        bookingEnabled: enabled,
        salonName: details['name'] as String? ?? 'Salon',
      );
    } catch (e) {
      throw Exception('Fehler beim Laden des Buchungslinks: $e');
    }
  }

  /// Aktualisiert die booking_enabled Einstellung
  ///
  /// Parameters:
  /// - [salonId]: Die Salon-ID
  /// - [enabled]: true zum Aktivieren, false zum Deaktivieren
  ///
  /// Returns:
  /// void - wirft Exception bei Fehler
  Future<void> updateBookingEnabled(String salonId, bool enabled) async {
    await _datasource.updateSalonBookingEnabled(salonId, enabled);
  }

  /// Generiert einen Dateiname für QR-Code Download
  ///
  /// Nutzt den Salonamen um zum Beispiel "hairbecker-qr-code.svg" zu generieren
  String generateQRCodeFilename(String salonName) {
    final cleanName = salonName
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
    return '$cleanName-qr-code.svg';
  }
}
