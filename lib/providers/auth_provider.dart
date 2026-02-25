import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_auth;
import '../services/supabase_service.dart';
import '../models/user_model.dart';
import '../core/auth/user_role_helpers.dart';

// Supabase Service Provider
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

// Auth state provider
final authStateProvider = StreamProvider<supabase_auth.User?>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return supabaseService.authStateChanges;
});

// Current user provider
final currentUserProvider = FutureProvider<UserData?>((ref) async {
  final supabaseService = ref.watch(supabaseServiceProvider);
  final authState = await ref.watch(authStateProvider.future);

  if (authState == null) {
    return null;
  }

  final userId = authState.id;
  final profile = await supabaseService.getUserProfile(userId);

  if (profile == null) {
    return null;
  }

  return UserData.fromJson(profile);
});

// User role provider
final userRoleProvider = FutureProvider<UserRole?>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  return user?.role;
});

class UserData {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final UserRole role;
  final String? avatar;
  final String? salonId;

  UserData({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    required this.role,
    this.avatar,
    this.salonId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      role: userRoleFromString(json['role'] as String?) ?? UserRole.customer,
      avatar: json['avatar'] as String?,
      salonId: json['salon_id'] as String?,
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}

// Auth Notifier Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return AuthNotifier(supabaseService);
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseService _supabaseService;

  AuthNotifier(this._supabaseService) : super(const AsyncValue.data(null));

  Future<void> changePassword(String currentPassword, String newPassword) async {
    state = const AsyncValue.loading();
    try {
      final user = _supabaseService.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Re-authenticate with current password
      final signInResult = await _supabaseService.client.auth.signInWithPassword(
        email: user.email!,
        password: currentPassword,
      );

      if (signInResult.user == null) {
        throw Exception('Invalid current password');
      }

      // Update password
      await _supabaseService.client.auth.updateUser(
        supabase_auth.UserAttributes(password: newPassword),
      );

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _supabaseService.signOut();
    state = const AsyncValue.data(null);
  }
}
