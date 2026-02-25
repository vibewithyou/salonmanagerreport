import 'package:supabase_flutter/supabase_flutter.dart';

/// Wrapper for Supabase RPC functions from the database
class SupabaseRPC {
  final SupabaseClient _client;

  SupabaseRPC(this._client);

  /// Get salons within a certain radius using PostgreSQL + PostGIS
  /// Returns salons that have at least one employee and are active
  /// 
  /// Parameters:
  /// - lat: latitude
  /// - lon: longitude  
  /// - radius_km: search radius in kilometers
  Future<List<Map<String, dynamic>>> salonsWithinRadius({
    required double lat,
    required double lon,
    required double radiusKm,
  }) async {
    try {
      final result = await _client.rpc(
        'salons_within_radius',
        params: {
          'lat': lat,
          'lon': lon,
          'radius_km': radiusKm,
        },
      );

      if (result == null) return [];
      
      return List<Map<String, dynamic>>.from(
        (result as List).map((item) => Map<String, dynamic>.from(item as Map)),
      );
    } catch (e) {
      throw Exception('Error fetching salons within radius: $e');
    }
  }

  /// Get salons within radius with additional filters
  /// 
  /// Parameters:
  /// - lat: latitude
  /// - lon: longitude
  /// - radius_km: search radius in kilometers
  /// - min_rating: minimum salon rating (0-5)
  /// - min_price: minimum price range
  /// - max_price: maximum price range
  /// - categories: list of service categories to filter by
  /// - min_availability: minimum availability in minutes
  Future<List<Map<String, dynamic>>> salonsWithinRadiusFiltered({
    required double lat,
    required double lon,
    required double radiusKm,
    double? minRating,
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
    int? minAvailability,
  }) async {
    try {
      final result = await _client.rpc(
        'salons_within_radius_filtered',
        params: {
          'lat': lat,
          'lon': lon,
          'radius_km': radiusKm,
          'min_rating': minRating,
          'min_price': minPrice,
          'max_price': maxPrice,
          'categories': categories,
          'min_availability_minutes': minAvailability,
        },
      );

      if (result == null) return [];
      
      return List<Map<String, dynamic>>.from(
        (result as List).map((item) => Map<String, dynamic>.from(item as Map)),
      );
    } catch (e) {
      throw Exception('Error fetching filtered salons: $e');
    }
  }

  /// Check if a salon has a free slot for a service at a given time
  /// 
  /// Parameters:
  /// - salon_id: UUID of the salon
  /// - service_id: UUID of the service
  /// - start_time: start time (ISO 8601)
  /// - end_time: end time (ISO 8601)
  /// - employee_id: optional employee ID (if specific stylist requested)
  Future<bool> hasFreeSlot({
    required String salonId,
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? employeeId,
  }) async {
    try {
      final result = await _client.rpc(
        'has_free_slot',
        params: {
          'salon_id': salonId,
          'service_id': serviceId,
          'start_time': startTime.toIso8601String(),
          'end_time': endTime.toIso8601String(),
          'employee_id': employeeId,
        },
      );

      return result as bool? ?? false;
    } catch (e) {
      throw Exception('Error checking availability: $e');
    }
  }

  /// Get available time slots for a service on a specific date
  /// Returns list of available start times
  Future<List<DateTime>> getAvailableSlots({
    required String salonId,
    required String serviceId,
    required DateTime date,
    String? employeeId,
  }) async {
    try {
      final result = await _client.rpc(
        'get_available_slots',
        params: {
          'salon_id': salonId,
          'service_id': serviceId,
          'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
          'employee_id': employeeId,
        },
      );

      if (result == null || (result as List).isEmpty) return [];

      return (result)
          .map((slot) => DateTime.parse(slot as String))
          .toList();
    } catch (e) {
      throw Exception('Error fetching available slots: $e');
    }
  }
}
