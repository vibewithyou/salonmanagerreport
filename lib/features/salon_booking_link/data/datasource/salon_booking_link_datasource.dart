import 'package:supabase_flutter/supabase_flutter.dart';

/// Datasource für Salon Booking Link und Einstellungen
class SalonBookingLinkDatasource {
  final SupabaseClient _supabaseClient;

  SalonBookingLinkDatasource(this._supabaseClient);

  /// Lädt die Salon-Einstellungen (booking_enabled) aus der Datenbank
  ///
  /// Returns:
  /// - `true/false` für den booking_enabled Status
  /// - Default: true, falls Wert null ist
  Future<bool> getSalonBookingEnabled(String salonId) async {
    try {
      final response = await _supabaseClient
          .from('salons')
          .select('booking_enabled')
          .eq('id', salonId)
          .single();

      return response['booking_enabled'] as bool? ?? true;
    } on PostgrestException catch (e) {
      throw Exception('Fehler beim Laden der Buchungseinstellungen: ${e.message}');
    } catch (e) {
      throw Exception('Fehler beim Laden der Buchungseinstellungen: $e');
    }
  }

  /// Aktualisiert die booking_enabled Einstellung für einen Salon
  ///
  /// Parameters:
  /// - [salonId]: Die Salon-ID
  /// - [enabled]: true zum Aktivieren, false zum Deaktivieren
  Future<void> updateSalonBookingEnabled(
    String salonId,
    bool enabled,
  ) async {
    try {
      await _supabaseClient
          .from('salons')
          .update({'booking_enabled': enabled})
          .eq('id', salonId);
    } on PostgrestException catch (e) {
      throw Exception('Fehler beim Aktualisieren: ${e.message}');
    } catch (e) {
      throw Exception('Fehler beim Aktualisieren: $e');
    }
  }

  /// Lädt Salon-Details (Name, etc.) für den Buchungslink
  Future<Map<String, dynamic>> getSalonDetails(String salonId) async {
    try {
      final response = await _supabaseClient
          .from('salons')
          .select('id, name')
          .eq('id', salonId)
          .single();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Fehler beim Laden des Salons: ${e.message}');
    } catch (e) {
      throw Exception('Fehler beim Laden des Salons: $e');
    }
  }
}
