import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';

/// Service repository provider
final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return ServiceRepository(supabaseService.client);
});

/// Repository for service operations
class ServiceRepository {
  final SupabaseClient _client;

  ServiceRepository(this._client);

/// Get all service categories
  Future<List<ServiceCategory>> getAllCategories() async {
    try {
      final data = await _client
          .from('service_categories')
          .select()
          .order('name', ascending: true);

      return (data as List)
          .map((json) => ServiceCategory.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all categories: $e');
    }
  }

  /// Get all services for a salon
  Future<List<ServiceData>> getSalonServices(String salonId) async {
    try {
      final data = await _client
          .from('services')
          .select()
          .eq('salon_id', salonId);

      return (data as List)
          .map((json) => ServiceData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

  /// Get a specific service
  Future<ServiceData?> getServiceById(String serviceId) async {
    try {
      final data = await _client
          .from('services')
          .select()
          .eq('id', serviceId)
          .maybeSingle();

      if (data == null) return null;

      return ServiceData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch service: $e');
    }
  }

  /// Get services by category
  Future<List<ServiceData>> getServicesByCategory({
    required String salonId,
    required String categoryId,
  }) async {
    try {
      final data = await _client
          .from('services')
          .select()
          .eq('salon_id', salonId)
          .eq('category', categoryId);

      return (data as List)
          .map((json) => ServiceData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

  /// Create a new service
  Future<ServiceData> createService({
    required String salonId,
    required String name,
    required int durationMinutes,
    required double price,
    String? category,
    String? categoryId,
    String? description,
    int? bufferBefore,
    int? bufferAfter,
    double? depositAmount,
  }) async {
    try {
      final data = await _client.from('services').insert({
        'salon_id': salonId,
        'name': name,
        'duration_minutes': durationMinutes,
        'price': price,
        'category': category ?? categoryId,
        'description': description,
        if (bufferBefore != null) 'buffer_before': bufferBefore,
        if (bufferAfter != null) 'buffer_after': bufferAfter,
        if (depositAmount != null) 'deposit_amount': depositAmount,
      }).select().single();

      return ServiceData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create service: $e');
    }
  }

  /// Update service
  Future<ServiceData> updateService({
    required String serviceId,
    String? name,
    int? durationMinutes,
    double? price,
    String? category,
    String? description,
    bool? isActive,
    int? bufferBefore,
    int? bufferAfter,
    double? depositAmount,
  }) async {
    try {
      final updates = <String, dynamic>{
        if (name != null) 'name': name,
        if (durationMinutes != null) 'duration_minutes': durationMinutes,
        if (price != null) 'price': price,
        if (category != null) 'category': category,
        if (description != null) 'description': description,
        if (isActive != null) 'is_active': isActive,
        if (bufferBefore != null) 'buffer_before': bufferBefore,
        if (bufferAfter != null) 'buffer_after': bufferAfter,
        if (depositAmount != null) 'deposit_amount': depositAmount,
      };

      if (updates.isNotEmpty) {
        final data = await _client
            .from('services')
            .update(updates)
            .eq('id', serviceId)
            .select()
            .single();
        return ServiceData.fromJson(data);
      }

      final data = await _client
          .from('services')
          .select()
          .eq('id', serviceId)
          .single();
      return ServiceData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update service: $e');
    }
  }

  /// Delete service
  Future<void> deleteService(String serviceId) async {
    try {
      await _client.from('services').delete().eq('id', serviceId);
    } catch (e) {
      throw Exception('Failed to delete service: $e');
    }
  }

  /// Get service categories for a salon
  Future<List<ServiceCategory>> getSalonServiceCategories(String salonId) async {
    try {
      final data = await _client
          .from('service_categories')
          .select()
          .eq('salon_id', salonId);

      return (data as List)
          .map((json) => ServiceCategory.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  /// Create service category
  Future<ServiceCategory> createCategory({
    required String salonId,
    required String name,
    String? description,
  }) async {
    try {
      final data = await _client.from('service_categories').insert({
        'salon_id': salonId,
        'name': name,
        'description': description,
      }).select().single();

      return ServiceCategory.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  /// Get employees who offer a service
  Future<List<String>> getEmployeesForService(String serviceId) async {
    try {
      final data = await _client
          .from('employee_services')
          .select('employee_id')
          .eq('service_id', serviceId);

      return (data as List)
          .map((json) => json['employee_id'] as String)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch employees: $e');
    }
  }
}

/// Service data model
class ServiceData {
  final String id;
  final String salonId;
  final String? category;
  final String name;
  final String? description;
  final int durationMinutes;
  final double price;
  final int? bufferBefore;
  final int? bufferAfter;
  final double? depositAmount;
  final bool? isActive;
  final DateTime createdAt;

  ServiceData({
    required this.id,
    required this.salonId,
    this.category,
    required this.name,
    this.description,
    required this.durationMinutes,
    required this.price,
    this.bufferBefore,
    this.bufferAfter,
    this.depositAmount,
    this.isActive,
    required this.createdAt,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      category: (json['category'] ?? json['category_id']) as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      durationMinutes: json['duration_minutes'] as int? ?? 30,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      bufferBefore: json['buffer_before'] as int?,
      bufferAfter: json['buffer_after'] as int?,
      depositAmount: (json['deposit_amount'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}

/// Service category model
class ServiceCategory {
  final String id;
  final String salonId;
  final String name;
  final String? description;
  final int? order;

  ServiceCategory({
    required this.id,
    required this.salonId,
    required this.name,
    this.description,
    this.order,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      order: json['order'] as int?,
    );
  }
}
