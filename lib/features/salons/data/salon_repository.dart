import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';
import '../../../services/workforce_service.dart';
import '../../../core/supabase/supabase_rpc.dart';

/// Salon repository provider
final salonRepositoryProvider = Provider<SalonRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  final rpc = SupabaseRPC(supabaseService.client);
  return SalonRepository(supabaseService.client, rpc);
});

/// Repository for salon operations
class SalonRepository {
  final SupabaseClient _client;
  final SupabaseRPC _rpc;

  SalonRepository(this._client, this._rpc);

  /// Get a specific salon by ID
  Future<SalonData?> getSalonById(String salonId) async {
    try {
      final data = await _client
          .from('salons')
          .select()
          .eq('id', salonId)
          .maybeSingle();

      if (data == null) return null;

      return SalonData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch salon: $e');
    }
  }

  /// Get salons within radius using RPC
  Future<List<SalonData>> getSalonsWithinRadius({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    try {
      final results = await _rpc.salonsWithinRadius(
        lat: latitude,
        lon: longitude,
        radiusKm: radiusKm,
      );

      return results
          .map((json) => SalonData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch salons: $e');
    }
  }

  /// Get salons within radius with filters
  Future<List<SalonData>> getSalonsWithinRadiusFiltered({
    required double latitude,
    required double longitude,
    required double radiusKm,
    double? minRating,
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
  }) async {
    try {
      final results = await _rpc.salonsWithinRadiusFiltered(
        lat: latitude,
        lon: longitude,
        radiusKm: radiusKm,
        minRating: minRating,
        minPrice: minPrice,
        maxPrice: maxPrice,
        categories: categories,
      );

      return results
          .map((json) => SalonData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch filtered salons: $e');
    }
  }

  /// Get all salons (for admin/browse)
  Future<List<SalonData>> getAllSalons({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final data = await _client
          .from('salons')
          .select()
          .range(offset, offset + limit - 1);

      return (data as List)
          .map((json) => SalonData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch salons: $e');
    }
  }

  /// Get salons owned by a user
  Future<List<SalonData>> getSalonsByOwner(String ownerId) async {
    try {
      final data = await _client
          .from('salons')
          .select()
          .eq('owner_id', ownerId);

      return (data as List)
          .map((json) => SalonData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch salons for owner: $e');
    }
  }

  /// Create a new salon
  Future<SalonData> createSalon({
    required String ownerId,
    required String name,
    required String email,
    required String? phone,
    required String? address,
    required double? latitude,
    required double? longitude,
  }) async {
    try {
      final data = await _client.from('salons').insert({
        'owner_id': ownerId,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
      }).select().single();

      return SalonData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create salon: $e');
    }
  }

  /// Update salon information
  Future<void> updateSalon({
    required String salonId,
    String? name,
    String? email,
    String? phone,
    String? address,
    double? latitude,
    double? longitude,
    String? description,
  }) async {
    try {
      final updates = <String, dynamic>{
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (description != null) 'description': description,
      };

      if (updates.isNotEmpty) {
        await _client
            .from('salons')
            .update(updates)
            .eq('id', salonId);
      }
    } catch (e) {
      throw Exception('Failed to update salon: $e');
    }
  }

  /// Get employees for a salon
  Future<List<EmployeeData>> getSalonEmployees(String salonId) async {
    try {
      final data = await _client
          .from('employees')
          .select()
          .eq('salon_id', salonId);

      return (data as List)
          .map((json) => EmployeeData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch employees: $e');
    }
  }

  /// Check if salon has available slots
  Future<bool> hasFreeSlot({
    required String salonId,
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? employeeId,
  }) async {
    try {
      final reasons = await getBlockingReasons(
        salonId: salonId,
        serviceId: serviceId,
        startTime: startTime,
        endTime: endTime,
        employeeId: employeeId,
      );

      return reasons.isEmpty;
    } catch (e) {
      throw Exception('Failed to check availability: $e');
    }
  }

  Future<List<String>> getBlockingReasons({
    required String salonId,
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? employeeId,
  }) async {
    try {
      final workforceService = WorkforceService(_client);
      final reasons = await workforceService.getBookingBlockReasons(
        salonId: salonId,
        startTime: startTime,
        endTime: endTime,
        employeeId: employeeId,
      );

      if (reasons.isNotEmpty) {
        return reasons;
      }

      final isFree = await _rpc.hasFreeSlot(
        salonId: salonId,
        serviceId: serviceId,
        startTime: startTime,
        endTime: endTime,
        employeeId: employeeId,
      );

      if (!isFree) {
        return const ['Das gewählte Zeitfenster ist nicht mehr verfügbar.'];
      }

      return const [];
    } catch (e) {
      throw Exception('Failed to determine blocking reasons: $e');
    }
  }
}

/// Salon data model
class SalonData {
  final String id;
  final String? ownerId;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String? description;
  final List<String>? images;
  final double? rating;
  final int? reviewCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SalonData({
    required this.id,
    this.ownerId,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.description,
    this.images,
    this.rating,
    this.reviewCount,
    required this.createdAt,
    this.updatedAt,
  });

  factory SalonData.fromJson(Map<String, dynamic> json) {
    return SalonData(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      description: json['description'] as String?,
      images: (json['images'] as List?)?.cast<String>(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
}

/// Employee data model
class EmployeeData {
  final String id;
  final String salonId;
  final String? userId;
  final String? role;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final bool? isActive;
  final DateTime createdAt;

  EmployeeData({
    required this.id,
    required this.salonId,
    this.userId,
    this.role,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.isActive,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      userId: json['user_id'] as String?,
      role: json['role'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}
