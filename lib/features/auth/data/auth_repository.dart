import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return AuthRepository(supabaseService.client);
});

/// Repository for authentication operations
class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  /// Get current auth session
  Session? get currentSession => _client.auth.currentSession;

  /// Get current authenticated user
  User? get currentUser => _client.auth.currentUser;

  /// Stream of auth state changes
  Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange.map((data) {
        return AuthState(
          session: data.session,
          user: data.session?.user,
          event: data.event,
        );
      });

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  /// Sign up as a customer
  Future<AuthResponse> signUpAsCustomer({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'role': 'customer',
        },
      );

      // Create customer profile
      if (response.user != null) {
        await _createCustomerProfile(
          userId: response.user!.id,
          email: email,
          firstName: firstName,
          lastName: lastName,
        );
      }

      return response;
    } catch (e) {
      throw Exception('Customer sign up failed: $e');
    }
  }

  /// Sign up as a salon owner
  Future<AuthResponse> signUpAsSalonOwner({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String salonName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'role': 'salon_owner',
          'salon_name': salonName,
        },
      );

      // Create salon and owner profile
      if (response.user != null) {
        await _createSalonOwnerProfile(
          userId: response.user!.id,
          email: email,
          firstName: firstName,
          lastName: lastName,
          salonName: salonName,
        );
      }

      return response;
    } catch (e) {
      throw Exception('Owner sign up failed: $e');
    }
  }

  /// Accept employee invitation
  Future<void> acceptEmployeeInvitation({
    required String invitationId,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      // First, sign up the user
      final signUpResponse = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'role': 'employee',
        },
      );

      if (signUpResponse.user == null) {
        throw Exception('Failed to create user account');
      }

      final userId = signUpResponse.user!.id;

      // Update invitation status to accepted
      await _client.from('employee_invitations').update({
        'status': 'accepted',
        'accepted_at': DateTime.now().toIso8601String(),
        'user_id': userId,
      }).eq('id', invitationId);

      // Create employee record (link with salon from invitation)
      final invitation = await _client
          .from('employee_invitations')
          .select('salon_id, role')
          .eq('id', invitationId)
          .single();

      await _client.from('employees').insert({
        'salon_id': invitation['salon_id'],
        'user_id': userId,
        'role': invitation['role'] ?? 'stylist',
      });
    } catch (e) {
      throw Exception('Failed to accept invitation: $e');
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Failed to send reset email: $e');
    }
  }

  /// Reset password with token
  Future<AuthResponse> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      return await _client.auth.verifyOTP(
        token: token,
        type: OtpType.recovery,
      ).then((_) async {
        return await _client.auth.updateUser(
          UserAttributes(password: newPassword),
        ) as AuthResponse;
      });
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Get user profile from database
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      return await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  /// Get user role from database
  Future<String?> getUserRole(String userId) async {
    try {
      final profile = await _client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .maybeSingle();

      return profile?['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// Create customer profile in database
  Future<void> _createCustomerProfile({
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    try {
      await _client.from('profiles').insert({
        'id': userId,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'role': 'customer',
      });
    } catch (e) {
      throw Exception('Failed to create customer profile: $e');
    }
  }

  /// Create salon owner profile
  Future<void> _createSalonOwnerProfile({
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
    required String salonName,
  }) async {
    try {
      // Create profile
      await _client.from('profiles').insert({
        'id': userId,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'role': 'salon_owner',
      });

      // Create initial salon record
      await _client.from('salons').insert({
        'owner_id': userId,
        'name': salonName,
        'email': email,
      });
    } catch (e) {
      throw Exception('Failed to create owner profile: $e');
    }
  }
}

/// Auth state wrapper
class AuthState {
  final Session? session;
  final User? user;
  final AuthChangeEvent event;

  AuthState({
    required this.session,
    required this.user,
    required this.event,
  });

  bool get isAuthenticated => user != null && session != null;
}
