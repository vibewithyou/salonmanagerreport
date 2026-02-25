import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';

/// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return UserRepository(supabaseService.client);
});

/// Repository for user profile and role data
class UserRepository {
  final SupabaseClient _client;

  UserRepository(this._client);

  /// Fetch complete user profile
  Future<UserProfileData?> fetchProfile(String userId) async {
    try {
      final data = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data == null) return null;

      return UserProfileData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  /// Fetch user role from database (user_roles table)
  Future<String?> fetchRole(String userId) async {
    try {
      final data = await _client
          .from('user_roles')
          .select('role')
          .eq('user_id', userId)
          .maybeSingle();

      return data?['role'] as String?;
    } catch (e) {
      print('Failed to fetch role from user_roles: $e');
      return null;
    }
  }

  /// Fetch salon context for user (for employees/owners)
  Future<SalonContext?> fetchSalonContext(String userId) async {
    try {
      // First get user role
      final role = await fetchRole(userId);

      if (role == 'customer') {
        return null; // Customers don't have salon context
      }

      if (role == 'salon_owner') {
        // Owner's primary salon
        final salon = await _client
            .from('salons')
            .select()
            .eq('owner_id', userId)
            .maybeSingle();

        if (salon != null) {
          return SalonContext(
            primarySalonId: salon['id'] as String,
            salonIds: [salon['id'] as String],
            currentSalonId: salon['id'] as String,
          );
        }
      }

      if (role == 'stylist' || role == 'employee') {
        // Employee's salons
        final employees = await _client
            .from('employees')
            .select('salon_id')
            .eq('user_id', userId);

        if (employees.isNotEmpty) {
          final salonIds = List<String>.from(
            employees.map((e) => e['salon_id'] as String),
          ).toSet().toList();

          return SalonContext(
            primarySalonId: salonIds.isNotEmpty ? salonIds.first : null,
            salonIds: salonIds,
            currentSalonId: salonIds.isNotEmpty ? salonIds.first : null,
          );
        }
      }

      return null;
    } catch (e) {
      throw Exception('Failed to fetch salon context: $e');
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? avatar,
    String? phone,
    String? address,
  }) async {
    try {
      final updates = <String, dynamic>{
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (avatar != null) 'avatar': avatar,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
      };

      if (updates.isNotEmpty) {
        await _client
            .from('profiles')
            .update(updates)
            .eq('id', userId);
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Set current salon for user (for employees)
  Future<void> setCurrentSalon({
    required String userId,
    required String salonId,
  }) async {
    try {
      // Verify user is an employee in this salon
      final employee = await _client
          .from('employees')
          .select()
          .eq('user_id', userId)
          .eq('salon_id', salonId)
          .maybeSingle();

      if (employee == null) {
        throw Exception('User is not an employee in this salon');
      }

      // Store in local storage or session (handled by auth provider)
      // This is primarily for the app state
    } catch (e) {
      throw Exception('Failed to set current salon: $e');
    }
  }
}

/// User profile data model
class UserProfileData {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String role;
  final String? avatar;
  final String? phone;
  final String? address;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserProfileData({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    required this.role,
    this.avatar,
    this.phone,
    this.address,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      role: json['role'] as String? ?? 'customer',
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
}

/// Salon context for user
class SalonContext {
  final String? primarySalonId;
  final List<String> salonIds;
  final String? currentSalonId;

  SalonContext({
    required this.primarySalonId,
    required this.salonIds,
    required this.currentSalonId,
  });

  bool get hasSalon => salonIds.isNotEmpty;
  bool get hasSingleSalon => salonIds.length == 1;
}
