import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';

/// Customer repository provider
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return CustomerRepository(supabaseService.client);
});

/// Repository for customer profile operations
class CustomerRepository {
  final SupabaseClient _client;

  CustomerRepository(this._client);

  /// Get customer profile by ID
  Future<CustomerProfileData?> getCustomerById(String customerId) async {
    try {
      final data = await _client
          .from('customer_profiles')
          .select()
          .eq('id', customerId)
          .maybeSingle();

      if (data == null) return null;

      return CustomerProfileData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch customer: $e');
    }
  }

  /// Get customer profile by user ID
  Future<CustomerProfileData?> getCustomerByUserId({
    required String userId,
    required String salonId,
  }) async {
    try {
      final data = await _client
          .from('customer_profiles')
          .select()
          .eq('user_id', userId)
          .eq('salon_id', salonId)
          .maybeSingle();

      if (data == null) return null;

      return CustomerProfileData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch customer: $e');
    }
  }

  /// Get all customers for a salon
  Future<List<CustomerProfileData>> getSalonCustomers(String salonId) async {
    try {
      final data = await _client
          .from('customer_profiles')
          .select()
          .eq('salon_id', salonId);

      return (data as List)
          .map((json) => CustomerProfileData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch customers: $e');
    }
  }

  /// Create a customer profile
  Future<CustomerProfileData> createCustomer({
    required String salonId,
    required String firstName,
    required String lastName,
    String? userId,
    String? email,
    String? phone,
    String? address,
  }) async {
    try {
      final data = await _client.from('customer_profiles').insert({
        'salon_id': salonId,
        'first_name': firstName,
        'last_name': lastName,
        'user_id': userId,
        'email': email,
        'phone': phone,
        'address': address,
      }).select().single();

      return CustomerProfileData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create customer: $e');
    }
  }

  /// Create or get customer profile for guest booking
  Future<CustomerProfileData> getOrCreateGuestCustomer({
    required String salonId,
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
  }) async {
    try {
      // Try to find existing guest customer (based on email)
      final existing = await _client
          .from('customer_profiles')
          .select()
          .eq('salon_id', salonId)
          .eq('email', email)
          .eq('user_id', 'null')
          .maybeSingle();

      if (existing != null) {
        return CustomerProfileData.fromJson(existing);
      }

      // Create new guest profile
      return createCustomer(
        salonId: salonId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      );
    } catch (e) {
      throw Exception('Failed to get or create guest customer: $e');
    }
  }

  /// Update customer profile
  Future<void> updateCustomer({
    required String customerId,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? address,
    String? notes,
    List<String>? tags,
  }) async {
    try {
      final updates = <String, dynamic>{
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        if (address != null) 'address': address,
        if (notes != null) 'notes': notes,
        if (tags != null) 'tags': tags,
      };

      if (updates.isNotEmpty) {
        await _client
            .from('customer_profiles')
            .update(updates)
            .eq('id', customerId);
      }
    } catch (e) {
      throw Exception('Failed to update customer: $e');
    }
  }

  /// Get customer appointments
  Future<List<AppointmentSummary>> getCustomerAppointments(
    String customerId, {
    bool pastOnly = false,
    bool upcomingOnly = false,
  }) async {
    try {
      var query = _client
          .from('appointments')
          .select()
          .eq('customer_profile_id', customerId)
          .order('start_time', ascending: false);

      final now = DateTime.now();
      dynamic data = await query;
      dynamic filteredData = data;
      
      if (upcomingOnly) {
        filteredData = (data as List).where((item) {
          final startTime = DateTime.parse(item['start_time']);
          return startTime.isAfter(now);
        }).toList();
      } else if (pastOnly) {
        filteredData = (data as List).where((item) {
          final startTime = DateTime.parse(item['start_time']);
          return startTime.isBefore(now);
        }).toList();
      }

      return (filteredData as List)
          .map((json) => AppointmentSummary.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch appointments: $e');
    }
  }

  /// Get customer loyalty account
  Future<LoyaltyAccount?> getCustomerLoyalty(String customerId) async {
    try {
      final data = await _client
          .from('loyalty_accounts')
          .select()
          .eq('customer_profile_id', customerId)
          .maybeSingle();

      if (data == null) return null;

      return LoyaltyAccount.fromJson(data);
    } catch (e) {
      return null; // Loyalty account is optional
    }
  }
}

/// Customer profile data model
class CustomerProfileData {
  final String id;
  final String salonId;
  final String? userId;
  final String firstName;
  final String lastName;
  final DateTime? birthdate;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final List<String>? tags;
  final String? customerNumber;
  final String? preferences;
  final String? allergies;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CustomerProfileData({
    required this.id,
    required this.salonId,
    this.userId,
    required this.firstName,
    required this.lastName,
    this.birthdate,
    this.phone,
    this.email,
    this.address,
    this.notes,
    this.tags,
    this.customerNumber,
    this.preferences,
    this.allergies,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName'.trim();
  bool get isGuest => userId == null;

  factory CustomerProfileData.fromJson(Map<String, dynamic> json) {
    return CustomerProfileData(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      userId: json['user_id'] as String?,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate'] as String) : null,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      tags: (json['tags'] as List?)?.cast<String>(),
      customerNumber: json['customer_number'] as String?,
      preferences: json['preferences'] as String?,
      allergies: json['allergies'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
}

/// Summary of an appointment (for list views)
class AppointmentSummary {
  final String id;
  final String salonId;
  final String? customerId;
  final String? employeeId;
  final String? serviceId;
  final String? guestName;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final double? price;
  final String? notes;

  AppointmentSummary({
    required this.id,
    required this.salonId,
    this.customerId,
    this.employeeId,
    this.serviceId,
    this.guestName,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.price,
    this.notes,
  });

  Duration get duration => endTime.difference(startTime);

  factory AppointmentSummary.fromJson(Map<String, dynamic> json) {
    return AppointmentSummary(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      customerId: json['customer_id'] as String?,
      employeeId: json['employee_id'] as String?,
      serviceId: json['service_id'] as String?,
      guestName: json['guest_name'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      status: json['status'] as String? ?? 'pending',
      price: (json['price'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );
  }
}

/// Loyalty account data
class LoyaltyAccount {
  final String id;
  final String salonId;
  final String customerId;
  final double pointsBalance;
  final String? tierLevel;

  LoyaltyAccount({
    required this.id,
    required this.salonId,
    required this.customerId,
    required this.pointsBalance,
    this.tierLevel,
  });

  factory LoyaltyAccount.fromJson(Map<String, dynamic> json) {
    return LoyaltyAccount(
      id: json['id'] as String,
      salonId: json['salon_id'] as String? ?? '',
      customerId: json['customer_profile_id'] as String? ?? '',
      pointsBalance: (json['points_balance'] as num?)?.toDouble() ?? 0.0,
      tierLevel: json['tier_level'] as String?,
    );
  }
}
